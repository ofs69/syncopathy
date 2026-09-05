import 'dart:async';
import 'dart:math';

import 'package:signals/signals.dart';
import 'package:syncopathy/helper/effect_dispose_mixin.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/heresphere/heresphere_auth.dart';
import 'package:syncopathy/heresphere/heresphere_library.dart';
import 'package:syncopathy/heresphere/heresphere_playback_session.dart';
import 'package:syncopathy/heresphere/heresphere_server.dart';
import 'package:syncopathy/heresphere/password_words.dart';
import 'package:syncopathy/heresphere/timestamp_client.dart';
import 'package:syncopathy/heresphere/timestamp_protocol.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';
import 'package:syncopathy/player/playback_session.dart';

/// Words in a generated password.
///
/// Three, joined by hyphens — `river-gold-lamp` rather than a run of random
/// characters. The password is typed once, on a headset keyboard, from a string
/// read off a monitor across the room, and that is the operation the generator
/// should be good at. Random characters optimise the wrong thing: they buy
/// entropy nobody needs here and pay for it in transcription errors.
///
/// The security this gives up is affordable because it was never the binding
/// constraint. The server answers at most five wrong guesses per address per
/// minute, so a space of tens of millions is already past any timescale a
/// local network matters over; the lockout, not the password, is what makes
/// guessing pointless.
const int _passwordWordCount = 3;

/// How long HereSphere may be unreachable before it gives the clock back.
///
/// A brief drop must not move the clock: a headset that stutters for a second
/// should stay in charge and read as paused, because bouncing ownership would
/// reload the funscript on every hiccup. A headset that is gone — taken off,
/// out of battery, off the network — is a different case entirely, and used to
/// be indistinguishable from the first: nothing ever released the clock, so the
/// local player stayed locked out until the user found the setting and toggled
/// it. This is the line between the two.
///
/// Generous, because the cost of crossing it late is nothing — the device is
/// already stopped, held by the same lost heartbeat — while crossing it early
/// would undo the debouncing that makes a drop survivable.
const Duration hereSphereAbandonAfter = Duration(seconds: 45);

/// How long to wait before rebinding a server that failed to start, doubling
/// up to [_maxServerRetryDelay].
///
/// A bind fails for reasons that pass: the address belongs to an interface
/// that is still coming up after a sleep, or the previous socket has not yet
/// been released. Leaving the feature dead until the user edits a setting made
/// a momentary condition permanent.
const Duration _initialServerRetryDelay = Duration(seconds: 2);
const Duration _maxServerRetryDelay = Duration(seconds: 30);

/// What the server was last asked to bind, so a retry can repeat it.
typedef _ServerConfig = ({String address, int port, HereSphereAuth? auth});

/// Owns everything the HereSphere feature runs, driven from settings.
///
/// Three things hang together here and are easier to reason about in one place
/// than spread across three: the media server's lifecycle, the timestamp
/// channel that carries HereSphere's clock, and the decision about which
/// playback session owns that clock. All of it is inert until the user enables
/// the feature.
class HereSphereController with EffectDispose {
  final SettingsModel _settings;

  /// Which session drives the funscript pipeline. Handing playback over is one
  /// assignment through this, so no device backend is rebuilt.
  final ActivePlaybackSession _activeSession;

  /// The local player to give the clock back to when HereSphere stops.
  final PlaybackSession _localSession;

  final HereSphereServer server;
  final HereSphereTimestampClient timestamps = HereSphereTimestampClient();
  final HereSpherePlaybackSession session;

  StreamSubscription<void>? _eventSubscription;
  StreamSubscription<HereSphereFrame>? _frameSubscription;
  StreamSubscription<void>? _activitySubscription;

  /// Counts down to giving the clock back, while the player is unreachable.
  Timer? _abandonTimer;

  /// What the server should be bound to, or null while it should be down.
  _ServerConfig? _serverConfig;
  Timer? _serverRetry;
  Duration _serverRetryDelay = _initialServerRetryDelay;

  /// Serialises restarts. Settings arrive in bursts — a port edit is several
  /// keystrokes — and two overlapping `start` calls would race over the socket.
  Future<void> _pending = Future.value();

  /// How long an unreachable player keeps the clock. Injectable so a test does
  /// not have to sit out the real window.
  final Duration abandonAfter;

  HereSphereController(
    this._settings,
    HereSphereLibrary library, {
    required ActivePlaybackSession activeSession,
    required PlaybackSession localSession,
    required MediaFile? Function(String? id, String? resource) resolveMedia,
    this.abandonAfter = hereSphereAbandonAfter,
  }) : _activeSession = activeSession,
       _localSession = localSession,
       server = HereSphereServer(library),
       session = HereSpherePlaybackSession(resolve: resolveMedia) {
    _eventSubscription = server.events.listen((event) {
      // Events keep flowing while HereSphere owns the device; they just have no
      // clock to feed, since Syncopathy is not driving anything then.
      if (!_settings.hereSphereDeviceOwner.value.drivesDevice) return;
      session.applyEvent(event);
    });

    _activitySubscription = server.clientActivity.listen((_) {
      // The player just talked to the media server, so it is awake whatever
      // the timestamp channel's backoff currently believes.
      timestamps.retryNow();
    });

    _frameSubscription = timestamps.frames.listen((frame) {
      switch (frame) {
        case HereSphereStateFrame(:final snapshot):
          session.applySnapshot(snapshot);
        case HereSphereResetFrame():
          // The player has nothing open. Drop the media rather than keep
          // driving from a clock that no longer describes anything.
          session.applyReset();
      }
    });

    effectAdd([
      effect(() {
        _applyServer(
          enabled: _settings.hereSphereEnabled.value,
          port: _settings.hereSpherePort.value,
          address: _settings.hereSphereBindAddress.value,
          username: _settings.hereSphereUsername.value,
          passwordHash: _settings.hereSpherePasswordHash.value,
        );
      }),
      effect(() {
        // Read on the server so a mode change is reflected by the next metadata
        // request, without a restart.
        server.deviceOwner.value = _settings.hereSphereDeviceOwner.value;
      }),
      effect(() {
        _applyTimestampChannel(
          enabled:
              _settings.hereSphereEnabled.value &&
              _settings.hereSphereDeviceOwner.value.drivesDevice,
          host: timestampHost.value,
          port: _settings.hereSphereTimestampPort.value,
        );
      }),
      effect(() {
        // The fail-safe: no live channel means no trusted clock, which
        // `TimesourceModel` turns into a pause rather than letting the device
        // run on extrapolation nothing is correcting.
        session.setChannelHealthy(timestamps.healthy.value);
      }),
      effect(() {
        final allowed =
            _settings.hereSphereAllowRemoteControl.value &&
            _settings.hereSphereDeviceOwner.value.drivesDevice;
        timestamps.allowCommands.value = allowed;
        session.attachCommands(allowed ? _CommandSink(timestamps) : null);
      }),
      effect(() {
        final owns =
            _settings.hereSphereEnabled.value &&
            _settings.hereSphereDeviceOwner.value.drivesDevice &&
            session.currentMedia.value != null;
        untracked(() => _applyOwnership(owns));
      }),
      effect(() {
        // Holding the clock for a player nothing can reach. Fine for a moment,
        // wrong forever — see [hereSphereAbandonAfter].
        final stalled =
            _settings.hereSphereEnabled.value &&
            _settings.hereSphereDeviceOwner.value.drivesDevice &&
            session.currentMedia.value != null &&
            !timestamps.healthy.value;
        untracked(() => _armAbandonTimer(stalled));
      }),
      effect(() {
        final state = server.state.value;
        untracked(() => _onServerState(state));
      }),
    ]);
  }

  /// Where the timestamp channel connects.
  ///
  /// The channel runs opposite to everything else: HereSphere listens and
  /// Syncopathy dials out. Asking the user for that address was the wrong
  /// answer to an easy question — the player is already connected to the media
  /// server, so its address is known. Auto-detection follows it; the typed
  /// host is a fallback for the case where what connects is not what plays.
  ///
  /// Empty means there is nowhere to connect yet, which stops the channel
  /// rather than leaving it retrying an address that no player is behind.
  late final ReadonlySignal<String> timestampHost = computed(() {
    if (!_settings.hereSphereTimestampAutoDetect.value) {
      return _settings.hereSphereTimestampHost.value.trim();
    }
    return server.clientAddress.value ?? '';
  });

  /// Whether HereSphere currently owns the clock the device follows.
  ///
  /// The player page reads this to say so, and to stop offering local controls
  /// that would do nothing.
  late final ReadonlySignal<bool> externalPlaybackActive = computed(
    () => identical(_activeSession.session.value, session),
  );

  /// The URL to type into HereSphere, given the address it will reach us on.
  ///
  /// Just the host and port: there is no secret in it any more, because the
  /// secret is the password the player is prompted for. Every URL that does
  /// carry a session token is handed out by the server after that login, never
  /// typed by a person.
  String urlFor(String host) =>
      'http://$host:${_settings.hereSpherePort.value}';

  /// Sets the password every client must present.
  ///
  /// Hashing is slow by design, so this is asynchronous. Storing the hash
  /// re-runs the settings effect, which signs every device out — a password
  /// change that left existing sessions alive would not be a password change.
  Future<void> setPassword(String password) async {
    final hash = await hashHereSpherePassword(password);
    _settings.hereSpherePasswordHash.value = hash.encode();
  }

  /// Signs every device out without changing the password.
  void signOutAllDevices() => server.revokeSessions();

  /// Hands the clock to whichever session should have it.
  ///
  /// Deliberately keyed on resolved media rather than on channel health: a
  /// heartbeat that drops mid-playback should leave HereSphere in charge and
  /// reading as paused, not bounce ownership back and forth and reload the
  /// funscript each time.
  void _applyOwnership(bool external) {
    if (external) {
      // Stop the local player first. Handing the clock over does not silence
      // it, and a video still running here while the headset plays another is
      // two soundtracks and two claims on one device.
      _pauseLocalPlayer();
      _activeSession.takeOver(session);
      return;
    }
    _activeSession.takeOver(_localSession);
  }

  /// Pauses local playback, if it is playing and will accept the command.
  void _pauseLocalPlayer() {
    if (_localSession.paused.value) return;
    if (!_localSession.supports(PlaybackCapability.playPause)) return;
    try {
      _localSession.togglePause();
    } catch (e) {
      // Never let a local player's refusal block the handover: the clock has
      // to move regardless, or HereSphere drives nothing.
      Logger.warning('Could not pause the local player on handover: $e');
    }
  }

  /// Starts or stops the countdown to giving the clock back.
  ///
  /// Armed once, not restarted: the window measures how long the player has
  /// been unreachable, and re-arming it on every unhealthy tick would measure
  /// nothing.
  void _armAbandonTimer(bool stalled) {
    if (!stalled) {
      _abandonTimer?.cancel();
      _abandonTimer = null;
      return;
    }
    _abandonTimer ??= Timer(abandonAfter, () {
      _abandonTimer = null;
      Logger.info(
        'HereSphere has been unreachable for ${abandonAfter.inSeconds}s; '
        'giving the clock back to the local player',
      );
      // Dropping the media hands ownership back through the effect that
      // watches it, and releasing the claim lets the same headset drive again
      // the moment it returns — on whatever address it returns with. Neither
      // stops the channel dialling, so a player that wakes up is picked
      // straight back up and takes the clock again.
      session.close();
      server.releaseDriver();
    });
  }

  /// Keeps the server bound, retrying a failed bind for as long as one is
  /// wanted.
  void _onServerState(HereSphereServerState state) {
    if (state == HereSphereServerState.running) {
      // A bind that worked earns the next failure a fresh, short first retry.
      _serverRetryDelay = _initialServerRetryDelay;
      return;
    }
    // Only a failure is worth acting on. `starting` in particular is not: a
    // retry passes through it on the way to failing again, and treating that
    // as progress would reset the backoff every time round.
    if (state != HereSphereServerState.failed) return;

    final config = _serverConfig;
    if (config == null || _serverRetry != null) return;

    final delay = _serverRetryDelay;
    Logger.warning(
      'HereSphere server failed to bind; retrying in ${delay.inSeconds}s',
    );
    _serverRetry = Timer(delay, () {
      _serverRetry = null;
      final current = _serverConfig;
      if (current == null) return;
      _queue(
        () => server.start(
          address: current.address,
          port: current.port,
          auth: current.auth,
        ),
      );
    });
    final next = delay * 2;
    _serverRetryDelay = next > _maxServerRetryDelay
        ? _maxServerRetryDelay
        : next;
  }

  void _cancelServerRetry() {
    _serverRetry?.cancel();
    _serverRetry = null;
    _serverRetryDelay = _initialServerRetryDelay;
  }

  void _applyServer({
    required bool enabled,
    required int port,
    required String address,
    required String username,
    required String passwordHash,
  }) {
    _cancelServerRetry();
    if (!enabled) {
      _serverConfig = null;
      _queue(() async {
        await server.stop();
        // Nothing is watching any more, so anything half-open is stale.
        session.close();
      });
      return;
    }
    final auth = HereSphereAuth.fromSettings(
      username: username,
      encodedPassword: passwordHash,
    );
    // Remembered so a bind that fails can be repeated without waiting for the
    // user to touch a setting.
    _serverConfig = (address: address, port: port, auth: auth);
    // A server with no password still binds. It refuses every login, which is
    // the honest state to be in — and the settings panel says so — where not
    // binding at all would look like the feature is broken.
    _queue(() => server.start(address: address, port: port, auth: auth));
  }

  void _applyTimestampChannel({
    required bool enabled,
    required String host,
    required int port,
  }) {
    if (!enabled || host.trim().isEmpty) {
      timestamps.stop();
      return;
    }
    timestamps.start(host: host.trim(), port: port);
  }

  void _queue(Future<void> Function() action) {
    _pending = _pending.then((_) => action()).catchError((Object _) {});
  }

  Future<void> dispose() async {
    effectDispose();
    _abandonTimer?.cancel();
    _abandonTimer = null;
    _cancelServerRetry();
    _serverConfig = null;
    await _eventSubscription?.cancel();
    await _frameSubscription?.cancel();
    await _activitySubscription?.cancel();
    // Give the clock back before tearing anything down, so nothing downstream
    // is left pointing at a disposed session.
    _activeSession.takeOver(_localSession);
    session.dispose();
    await timestamps.dispose();
    await server.dispose();
  }
}

/// Bridges the session's transport calls onto the timestamp channel.
class _CommandSink implements HereSphereCommandSink {
  final HereSphereTimestampClient _client;

  _CommandSink(this._client);

  @override
  void seek(double seconds) => _client.seekTo(seconds);

  @override
  void setPaused(bool paused) => _client.setPaused(paused);

  @override
  void setSpeed(double speed) => _client.setSpeed(speed);
}

/// Generates a password from a cryptographically secure source.
///
/// Words may repeat: rejecting a repeat would remove combinations and tell an
/// attacker that no password ever contains one, which is a small loss on both
/// counts and a needless special case.
String generateHereSpherePassword() {
  final random = Random.secure();
  return [
    for (var i = 0; i < _passwordWordCount; i++)
      hereSpherePasswordWords[random.nextInt(hereSpherePasswordWords.length)],
  ].join('-');
}
