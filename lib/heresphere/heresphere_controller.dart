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

  /// Serialises restarts. Settings arrive in bursts — a port edit is several
  /// keystrokes — and two overlapping `start` calls would race over the socket.
  Future<void> _pending = Future.value();

  HereSphereController(
    this._settings,
    HereSphereLibrary library, {
    required ActivePlaybackSession activeSession,
    required PlaybackSession localSession,
    required MediaFile? Function(String? id, String? resource) resolveMedia,
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

  void _applyServer({
    required bool enabled,
    required int port,
    required String address,
    required String username,
    required String passwordHash,
  }) {
    if (!enabled) {
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
    await _eventSubscription?.cancel();
    await _frameSubscription?.cancel();
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
