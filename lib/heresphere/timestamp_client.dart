import 'dart:async';
import 'dart:io';

import 'package:signals/signals.dart';
import 'package:syncopathy/heresphere/timestamp_protocol.dart';
import 'package:syncopathy/logging.dart';

/// How long the channel may go silent before its clock stops being trusted.
///
/// The player reports about once a second, so this allows several missed
/// reports before giving up. It is the fail-safe the device depends on: past
/// this point nothing is correcting the extrapolated clock, and a stroker must
/// not keep running on a guess.
const Duration hereSphereStaleAfter = Duration(seconds: 4);

/// Defaults for [HereSphereTimestampClient.initialReconnectDelay] and
/// [HereSphereTimestampClient.maxReconnectDelay]: each failure doubles the gap
/// up to the ceiling, so a headset that is asleep is not hammered.
const Duration _initialReconnectDelay = Duration(seconds: 1);
const Duration _maxReconnectDelay = Duration(seconds: 15);

/// Shortest gap between two nudged retries.
///
/// [HereSphereTimestampClient.retryNow] is called from the media server's
/// request path, which can be busy — a headset streaming video makes range
/// requests throughout. This is what keeps a channel that cannot connect from
/// being retried once per request.
const Duration _nudgeFloor = Duration(seconds: 1);

/// Client for HereSphere's DeoVR-compatible timestamp server.
///
/// Supplies the periodic authoritative state that corrects the extrapolated
/// clock, and — more importantly — the heartbeat that says the player is still
/// there. Reconnects on its own, because a headset going to sleep and waking
/// again is normal rather than an error.
class HereSphereTimestampClient {
  final Signal<bool> _socketConnected = signal(false);

  /// Whether a socket is currently open. Not the same as usable: a connection
  /// that has stopped reporting still reads as connected here but not in
  /// [healthy].
  ReadonlySignal<bool> get socketConnected => _socketConnected;

  final Signal<DateTime?> _lastFrameAt = signal(null);
  final Signal<bool> _fresh = signal(false);

  /// Whether the channel is delivering state right now.
  ///
  /// This is what the playback session gates the device on: a socket that is
  /// open but silent is no better than a closed one, since neither is
  /// correcting the clock.
  late final ReadonlySignal<bool> healthy = computed(
    () => _socketConnected.value && _fresh.value,
  );

  final Signal<String?> _lastError = signal(null);
  ReadonlySignal<String?> get lastError => _lastError;

  final StreamController<HereSphereFrame> _frames =
      StreamController<HereSphereFrame>.broadcast();

  /// Decoded frames, in arrival order.
  Stream<HereSphereFrame> get frames => _frames.stream;

  final HereSphereFrameDecoder _decoder = HereSphereFrameDecoder();

  /// Gap before the first reconnect, and the ceiling the doubling stops at.
  /// Injectable so a test can put a retry far enough out to prove that
  /// [retryNow], and nothing else, is what brought a connection back.
  final Duration initialReconnectDelay;
  final Duration maxReconnectDelay;

  HereSphereTimestampClient({
    this.initialReconnectDelay = _initialReconnectDelay,
    this.maxReconnectDelay = _maxReconnectDelay,
  }) : _reconnectDelay = initialReconnectDelay;

  Socket? _socket;
  StreamSubscription<List<int>>? _subscription;
  Timer? _keepalive;
  Timer? _staleWatchdog;
  Timer? _reconnectTimer;
  Duration _reconnectDelay;

  String? _host;
  int _port = hereSphereDefaultTimestampPort;

  /// True between [start] and [stop]; a drop only reconnects while it is set.
  bool _wanted = false;

  /// A connection attempt is in flight.
  ///
  /// `Socket.connect` takes up to five seconds against a sleeping headset, and
  /// [retryNow] can arrive at any moment during it. Without this the nudge
  /// would start a second attempt alongside the first, and whichever finished
  /// last would install itself over the other's socket.
  bool _connecting = false;

  /// When [retryNow] last acted, for [_nudgeFloor].
  DateTime? _lastNudgeAt;

  /// Which connection attempt is the live one.
  ///
  /// `Socket.connect` cannot be cancelled, and it waits up to five seconds on a
  /// headset that is asleep — long enough for the user to switch the feature off
  /// and on again, or retype the host, while an attempt is still in flight.
  /// Asking only whether a connection is still [_wanted] does not tell that
  /// attempt apart from the one that replaced it, so it installs itself over
  /// the newer socket, subscription and timers. The overwritten connection is
  /// then unreachable: nothing can close it, it survives the next [stop] still
  /// pushing frames, and when it finally drops it tears down whichever
  /// connection is live by then. Numbering the attempts is what makes "is this
  /// still the one wanted" answerable.
  int _generation = 0;

  /// Whether outbound commands are allowed. Off by default: commanding the
  /// player is a separate opt-in from observing it.
  final Signal<bool> allowCommands = signal(false);

  bool get isRunning => _wanted;

  /// Connects to [host]:[port], reconnecting until [stop].
  ///
  /// Calling it again with a different endpoint moves the connection; calling
  /// it with the same one while already running does nothing, so it is safe to
  /// drive straight from a settings effect.
  void start({required String host, required int port}) {
    if (_wanted && _host == host && _port == port) return;
    stop();
    _wanted = true;
    _host = host;
    _port = port;
    _reconnectDelay = initialReconnectDelay;
    _connect(_generation);
  }

  void stop() {
    _wanted = false;
    // Abandons whatever is in flight, so it cannot come back and install
    // itself over the next connection.
    _generation++;
    _connecting = false;
    _lastNudgeAt = null;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _teardownConnection();
    _lastError.value = null;
  }

  /// Something else has just seen the player: try again now.
  ///
  /// The channel dials out to a headset that is regularly asleep, so the
  /// backoff grows to fifteen seconds. That is the right answer while there is
  /// no news, and the wrong one the moment the media server hears from the
  /// same headset — which is proof it is awake, and arrives seconds before the
  /// backoff would have run out. Recovering on that evidence is the difference
  /// between a headset waking to a working device and one waking to a device
  /// that stays still for another quarter of a minute.
  ///
  /// Cheap enough to call from a request handler: it does nothing while a
  /// socket is up or an attempt is in flight, and never acts more often than
  /// [_nudgeFloor].
  void retryNow() {
    if (!_wanted || _connecting || _socket != null) return;
    final now = DateTime.now();
    final last = _lastNudgeAt;
    if (last != null && now.difference(last) < _nudgeFloor) return;
    _lastNudgeAt = now;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    // The player is up, so the last failure said nothing about how long to
    // wait for the next attempt. Start the backoff over.
    _reconnectDelay = initialReconnectDelay;
    unawaited(_connect(_generation));
  }

  Future<void> dispose() async {
    stop();
    await _frames.close();
  }

  Future<void> _connect(int generation) async {
    if (generation != _generation) return;
    final host = _host;
    if (host == null) return;
    if (_connecting) return;
    _connecting = true;

    try {
      final socket = await Socket.connect(
        host,
        _port,
        timeout: const Duration(seconds: 5),
      );
      if (generation != _generation) {
        socket.destroy();
        return;
      }
      // State reports are small and latency matters more than packing them, so
      // do not let Nagle hold a command back waiting for more bytes.
      socket.setOption(SocketOption.tcpNoDelay, true);

      _socket = socket;
      _decoder.reset();
      _socketConnected.value = true;
      _lastError.value = null;
      _reconnectDelay = initialReconnectDelay;
      Logger.info('HereSphere timestamp channel connected to $host:$_port');

      _subscription = socket.listen(
        _onBytes,
        onError: (Object e) => _onDisconnected('$e'),
        onDone: () => _onDisconnected(null),
        cancelOnError: true,
      );

      _keepalive = Timer.periodic(
        hereSphereKeepaliveInterval,
        (_) => _sendKeepalive(),
      );
      _staleWatchdog = Timer.periodic(
        const Duration(milliseconds: 500),
        (_) => _checkFreshness(),
      );
    } catch (e) {
      // A superseded attempt failing says nothing about the current endpoint,
      // and reporting it would overwrite the live error and reset the backoff.
      if (generation != _generation) return;
      _lastError.value = _describe(e, host, _port);
      // Cleared before scheduling, so the retry this arms is not mistaken for
      // an attempt still in flight.
      _connecting = false;
      _scheduleReconnect();
    } finally {
      // Only the live attempt owns the flag. A superseded one finishing must
      // not clear it out from under the attempt that replaced it — and cannot
      // strand it either, since `stop` clears the flag before `start` sets it.
      if (generation == _generation) _connecting = false;
    }
  }

  void _onBytes(List<int> chunk) {
    final frames = _decoder.add(chunk);
    if (_decoder.desynchronised) {
      // No marker to resynchronise on, so the only safe move is to start the
      // connection over.
      Logger.warning(
        'HereSphere timestamp channel desynchronised; reconnecting',
      );
      _onDisconnected('Malformed frame');
      return;
    }
    if (frames.isEmpty) return;

    _lastFrameAt.value = DateTime.now();
    _fresh.value = true;
    for (final frame in frames) {
      if (!_frames.isClosed) _frames.add(frame);
    }
  }

  void _sendKeepalive() {
    final socket = _socket;
    if (socket == null) return;
    try {
      socket.add(hereSphereKeepaliveFrame);
    } catch (e) {
      _onDisconnected('$e');
    }
  }

  /// Sends a command frame, if commands are enabled and a socket is up.
  ///
  /// Returns whether it went out, so a caller can tell the difference between
  /// "sent" and "silently dropped" rather than assuming the player obeyed.
  bool sendCommand(Map<String, Object?> command) {
    if (!allowCommands.value) return false;
    final socket = _socket;
    if (socket == null) return false;
    try {
      socket.add(encodeHereSphereFrame(command));
      return true;
    } catch (e) {
      _onDisconnected('$e');
      return false;
    }
  }

  bool seekTo(double seconds) => sendCommand({'currentTime': seconds});

  bool setPaused(bool paused) => sendCommand({
    'playerState': paused
        ? HereSpherePlayerState.paused.wireValue
        : HereSpherePlayerState.playing.wireValue,
  });

  bool setSpeed(double speed) => sendCommand({'playbackSpeed': speed});

  bool openPath(String path) => sendCommand({'path': path});

  void _checkFreshness() {
    final last = _lastFrameAt.value;
    final stale =
        last == null || DateTime.now().difference(last) > hereSphereStaleAfter;
    if (_fresh.value == !stale) return;
    _fresh.value = !stale;
    if (stale) {
      Logger.warning(
        'HereSphere timestamp channel went quiet; the clock is no longer '
        'trusted',
      );
    }
  }

  void _onDisconnected(String? error) {
    if (_socket == null && !_socketConnected.value) return;
    if (error != null) {
      Logger.warning('HereSphere timestamp channel lost: $error');
      _lastError.value = error;
    } else {
      Logger.info('HereSphere timestamp channel closed by the player');
    }
    _teardownConnection();
    _scheduleReconnect();
  }

  void _teardownConnection() {
    _keepalive?.cancel();
    _keepalive = null;
    _staleWatchdog?.cancel();
    _staleWatchdog = null;
    _subscription?.cancel();
    _subscription = null;
    _socket?.destroy();
    _socket = null;
    _decoder.reset();
    _socketConnected.value = false;
    _fresh.value = false;
    _lastFrameAt.value = null;
  }

  void _scheduleReconnect() {
    if (!_wanted) return;
    _reconnectTimer?.cancel();
    final delay = _reconnectDelay;
    final generation = _generation;
    _reconnectTimer = Timer(delay, () => _connect(generation));
    // Bounded doubling: a headset that is off should not be probed every
    // second forever, but a brief drop should recover quickly.
    final next = delay * 2;
    _reconnectDelay = next > maxReconnectDelay ? maxReconnectDelay : next;
  }

  static String _describe(Object error, String host, int port) {
    if (error is SocketException) {
      if (_isRefused(error)) {
        // The one failure with a specific cause worth naming. Everything else
        // is a network problem; this one is almost always a switch that is off.
        return 'Nothing is listening on $host:$port. HereSphere serves this '
            'connection itself, so its remote control has to be enabled in '
            'the headset — the address is right, the port is closed.';
      }
      return 'Cannot reach $host:$port — '
          '${error.osError?.message ?? error.message}';
    }
    return 'Cannot reach $host:$port — $error';
  }

  /// Whether the host answered and declined, rather than not answering at all.
  ///
  /// Worth telling apart, because the two mean opposite things: a refusal says
  /// the address is right and nothing is bound to that port, which is a setting
  /// in the player; a timeout says the address or the network is wrong.
  ///
  /// Matched on the platform error numbers, not the message, which is
  /// localised. Windows reports `ERROR_CONNECTION_REFUSED` (1225) here rather
  /// than the Winsock `WSAECONNREFUSED` (10061) one might expect, so both are
  /// listed; then Linux (111) and macOS (61).
  static bool _isRefused(SocketException error) {
    const refused = {1225, 10061, 111, 61};
    final code = error.osError?.errorCode;
    return code != null && refused.contains(code);
  }
}
