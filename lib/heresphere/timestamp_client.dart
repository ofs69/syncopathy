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

/// First reconnect delay. Each further failure doubles it up to
/// [_maxReconnectDelay], so a headset that is asleep is not hammered.
const Duration _initialReconnectDelay = Duration(seconds: 1);
const Duration _maxReconnectDelay = Duration(seconds: 15);

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

  Socket? _socket;
  StreamSubscription<List<int>>? _subscription;
  Timer? _keepalive;
  Timer? _staleWatchdog;
  Timer? _reconnectTimer;
  Duration _reconnectDelay = _initialReconnectDelay;

  String? _host;
  int _port = hereSphereDefaultTimestampPort;

  /// True between [start] and [stop]; a drop only reconnects while it is set.
  bool _wanted = false;

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
    _reconnectDelay = _initialReconnectDelay;
    _connect();
  }

  void stop() {
    _wanted = false;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _teardownConnection();
    _lastError.value = null;
  }

  Future<void> dispose() async {
    stop();
    await _frames.close();
  }

  Future<void> _connect() async {
    if (!_wanted) return;
    final host = _host;
    if (host == null) return;

    try {
      final socket = await Socket.connect(
        host,
        _port,
        timeout: const Duration(seconds: 5),
      );
      if (!_wanted) {
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
      _reconnectDelay = _initialReconnectDelay;
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
      _lastError.value = _describe(e, host, _port);
      _scheduleReconnect();
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
    _reconnectTimer = Timer(delay, _connect);
    // Bounded doubling: a headset that is off should not be probed every
    // second forever, but a brief drop should recover quickly.
    final next = delay * 2;
    _reconnectDelay = next > _maxReconnectDelay ? _maxReconnectDelay : next;
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
