import 'dart:async';

import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/heresphere/heresphere_event.dart';
import 'package:syncopathy/heresphere/timestamp_protocol.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';
import 'package:syncopathy/player/playback_session.dart';
import 'package:syncopathy/player/smooth_video_signals.dart';

/// How far the reported position may drift from the predicted one before it is
/// read as a seek rather than as jitter.
///
/// State arrives about once a second, so normal error is tens of milliseconds
/// plus whatever the network adds. Three quarters of a second is comfortably
/// above that and far below any seek a person makes on purpose.
const double hereSphereSeekThresholdSeconds = 0.75;

/// How long `seeking` stays raised after a discontinuity.
///
/// Device backends act on the falling edge — that is when they rebuild their
/// buffer around the new position — so the pulse only has to be long enough to
/// be observed, with the new position already in place when it clears.
const Duration hereSphereSeekPulse = Duration(milliseconds: 150);

/// Wall time the clock may fail to advance, while the player claims to be
/// playing, before playback is treated as stalled.
///
/// HereSphere reports no buffering state of its own, so this is inferred. It is
/// deliberately conservative: two reports in a row that did not move the
/// playhead. Calling a stall early would chop up normal playback; calling it
/// late only costs a little extrapolation past a stall that already happened.
const Duration hereSphereStallAfter = Duration(milliseconds: 1200);

/// Predicted advance below which a report is too short to judge. Under this,
/// the reports are close enough together that "did it move" is noise.
const double _stallProbeSeconds = 0.1;

/// Fraction of the predicted advance the clock must beat to count as moving.
/// Well under a tenth of expected is not slow playback, it is stopped playback.
const double _stallFraction = 0.1;

/// A [PlaybackSession] fed by a HereSphere player that Syncopathy only watches.
///
/// Two channels drive it. Playback events arrive promptly and carry the
/// transitions — open, play, pause, close. The timestamp channel arrives about
/// once a second and is authoritative: it corrects the extrapolated clock,
/// exposes seeks as discontinuities, and — by arriving at all — is the proof
/// that a player is still on the other end.
///
/// Nothing here commands the player. [attachCommands] can grant that later, and
/// only then does the session advertise the matching capabilities.
class HereSpherePlaybackSession extends PlaybackSession {
  @override
  String get sessionName => 'HereSphere';

  @override
  final Signal<MediaFile?> currentMedia = signal(null);
  @override
  final Signal<String> loadedPath = signal('');
  @override
  final Signal<double?> duration = signal(null);
  @override
  final Signal<bool> paused = signal(true);
  @override
  final Signal<bool> buffering = signal(false);
  @override
  final Signal<bool> seeking = signal(false);
  @override
  final Signal<double> rawPosition = signal(0.0);
  @override
  final Signal<double> playbackSpeed = signal(1.0);
  @override
  final Signal<bool> loopFile = signal(false);
  @override
  final Signal<int?> videoWidth = signal(null);
  @override
  final Signal<int?> videoHeight = signal(null);

  final Signal<Set<PlaybackCapability>> _capabilities = signal(const {});
  @override
  ReadonlySignal<Set<PlaybackCapability>> get capabilities => _capabilities;

  final Signal<bool> _channelHealthy = signal(false);

  /// Whether the clock can be trusted.
  ///
  /// Requires both a live timestamp channel and media we resolved to a library
  /// entry: without the channel nothing is correcting the extrapolation, and
  /// without the entry there is no script to drive from. Either way
  /// `TimesourceModel` folds this into `paused`, so the device stops rather
  /// than running on a guess.
  @override
  late final ReadonlySignal<bool> connected = computed(
    () => _channelHealthy.value && currentMedia.value != null,
  );

  /// Built on first use rather than in the constructor: it drives a [Ticker],
  /// which needs a scheduler binding, and a caller that only reads the raw
  /// clock should not be made to provide one.
  SmoothVideoSignals? _smooth;

  SmoothVideoSignals get _smoothSignals => _smooth ??= SmoothVideoSignals(
    rawPosition,
    // Extrapolation must stop the moment the clock stops being
    // authoritative, not just when the player says it paused.
    computed(() => paused.value || !connected.value),
    playbackSpeed,
    buffering,
  );

  @override
  ReadonlySignal<double> get smoothPosition => _smoothSignals.smoothPosition;

  /// Resolves an event id or a streamed resource to a library entry.
  final MediaFile? Function(String? id, String? resource) _resolve;

  /// Sends a command to the player, or null while none may be sent.
  HereSphereCommandSink? _commands;

  /// Last position we were told, and when we were told it. The pair is what a
  /// prediction is built from, and what a seek is measured against.
  double? _authoritativeTime;
  DateTime? _authoritativeAt;

  /// When the playhead last actually moved, for the stall detector.
  DateTime? _lastAdvanceAt;

  Timer? _seekPulse;

  HereSpherePlaybackSession({
    required MediaFile? Function(String? id, String? resource) resolve,
  }) : _resolve = resolve;

  /// Grants the session the right to command the player.
  ///
  /// Separate from construction because it is a user decision, not a structural
  /// one: observing HereSphere and driving it are different permissions, and
  /// the capabilities the UI enables follow this.
  void attachCommands(HereSphereCommandSink? commands) {
    _commands = commands;
    _refreshCapabilities();
  }

  void _refreshCapabilities() {
    final commands = _commands;
    // No commands, no capabilities: the base class then throws on every
    // transport call, and the UI disables the control rather than offering one
    // that does nothing.
    _capabilities.value = commands == null
        ? const {}
        : const {
            PlaybackCapability.seek,
            PlaybackCapability.playPause,
            PlaybackCapability.setSpeed,
          };
  }

  /// Reports whether the timestamp channel is delivering state.
  void setChannelHealthy(bool healthy) {
    // Read untracked: the caller is an effect watching the channel's health,
    // and a plain read here would make that effect depend on the signal it is
    // about to write — so it would re-run and immediately undo itself.
    if (untracked(() => _channelHealthy.value) == healthy) return;
    _channelHealthy.value = healthy;
    if (!healthy) {
      // Nothing is correcting the clock any more. Freeze it where it stands
      // instead of letting the last known speed carry it onward.
      _authoritativeTime = null;
      _authoritativeAt = null;
      _lastAdvanceAt = null;
      buffering.value = false;
    }
  }

  /// Applies a playback event: the prompt half of the protocol.
  void applyEvent(HereSphereEvent event) {
    switch (event.kind) {
      case HereSphereEventKind.open:
        _openMedia(id: event.id, resource: null);
        if (event.time != null) {
          _applyPosition(event.time!);
        }
        paused.value = true;
      case HereSphereEventKind.play:
        if (currentMedia.value == null) {
          _openMedia(id: event.id, resource: null);
        }
        if (event.time != null) {
          _applyPosition(event.time!);
        }
        if (event.speed != null && event.speed! > 0) {
          playbackSpeed.value = event.speed!;
        }
        paused.value = false;
      case HereSphereEventKind.pause:
        if (event.time != null) {
          _applyPosition(event.time!);
        }
        // Pause is the one transition that must never be late: the device is
        // moving until this lands.
        paused.value = true;
      case HereSphereEventKind.close:
        close();
      case HereSphereEventKind.unknown:
        Logger.warning('HereSphere: ignoring an unrecognised event');
    }
  }

  /// Applies an authoritative state report from the timestamp channel.
  void applySnapshot(HereSphereSnapshot snapshot) {
    final resource = snapshot.resource;
    if (resource != null && resource != loadedPath.value) {
      _openMedia(id: null, resource: resource);
    }

    final reportedDuration = snapshot.duration;
    if (reportedDuration != null && reportedDuration > 0) {
      duration.value = reportedDuration;
    }
    final speed = snapshot.playbackSpeed;
    if (speed != null && speed > 0) playbackSpeed.value = speed;

    // An unrecognised state counts as paused. Guessing "playing" would keep the
    // device running on a state this build does not understand.
    paused.value = !snapshot.isPlaying;

    final time = snapshot.currentTime;
    if (time != null) _applyPosition(time);
  }

  /// The player reported that it has nothing open.
  void applyReset() => close();

  /// Drops the current media, leaving the session connected but idle.
  void close() {
    _seekPulse?.cancel();
    _seekPulse = null;
    batch(() {
      currentMedia.value = null;
      loadedPath.value = '';
      duration.value = null;
      rawPosition.value = 0.0;
      paused.value = true;
      seeking.value = false;
      buffering.value = false;
      videoWidth.value = null;
      videoHeight.value = null;
    });
    _authoritativeTime = null;
    _authoritativeAt = null;
    _lastAdvanceAt = null;
  }

  void _openMedia({String? id, String? resource}) {
    final media = _resolve(id, resource);
    final previous = currentMedia.value;
    if (media == null) {
      // Streaming something the library does not know. There is no script to
      // drive from, so the session stays disconnected rather than pretending.
      Logger.warning('HereSphere opened media Syncopathy could not resolve');
      batch(() {
        currentMedia.value = null;
        loadedPath.value = resource ?? '';
      });
      return;
    }

    if (previous?.id == media.id) {
      // Same entry, refreshed identity — a snapshot naming the URL after an
      // event already named the id. Nothing about the clock changes.
      if (resource != null) loadedPath.value = resource;
      return;
    }

    Logger.info('HereSphere opened library entry ${media.id}');
    batch(() {
      currentMedia.value = media;
      loadedPath.value = resource ?? media.mediaPath;
      duration.value = media.metadata.target?.duration;
      videoWidth.value = media.metadata.target?.width;
      videoHeight.value = media.metadata.target?.height;
      rawPosition.value = 0.0;
      buffering.value = false;
    });
    _authoritativeTime = null;
    _authoritativeAt = null;
    _lastAdvanceAt = null;
  }

  /// Folds a newly reported position into the clock.
  ///
  /// Everything interesting happens here. A report is one of three things, and
  /// they have to be told apart in the right order:
  ///
  /// - a **stall**, where the playhead did not move although the player claims
  ///   to be playing;
  /// - a **seek**, where it moved somewhere the prediction cannot explain;
  /// - ordinary **drift**, which is just a correction.
  ///
  /// Stall is checked first, and that ordering is the whole trick: once the
  /// prediction has run a second ahead of a frozen clock, a stall reads exactly
  /// like a jump backwards. What separates them is not how far the report is
  /// from the prediction but how far it is from the *previous report* — a
  /// stalled clock has barely moved, a seek has moved a lot.
  void _applyPosition(double time) {
    final now = DateTime.now();
    final previousTime = _authoritativeTime;
    final previousAt = _authoritativeAt;
    _authoritativeTime = time;
    _authoritativeAt = now;

    if (previousTime == null || previousAt == null) {
      // Nothing to compare against — the first report after opening, or after
      // the channel came back. It is a correction by definition, never a seek.
      _noteAdvance(now);
      rawPosition.value = time;
      return;
    }

    final elapsed =
        now.difference(previousAt).inMicroseconds /
        Duration.microsecondsPerSecond;
    // Zero while paused, which is what keeps a pause from ever looking like a
    // stall.
    final expectedAdvance = paused.value ? 0.0 : elapsed * playbackSpeed.value;
    final actualAdvance = time - previousTime;

    if (expectedAdvance > _stallProbeSeconds &&
        actualAdvance.abs() < expectedAdvance * _stallFraction) {
      _noteStall(now);
      rawPosition.value = time;
      return;
    }

    _noteAdvance(now);

    final predicted = previousTime + expectedAdvance;
    if ((time - predicted).abs() > hereSphereSeekThresholdSeconds) {
      // A jump back to the very start of a looping file lands here too, and
      // should: either way a device backend's buffer now describes the wrong
      // part of the timeline and has to be rebuilt.
      _pulseSeek(time);
      return;
    }

    rawPosition.value = time;
  }

  /// The clock moved as expected, so nothing is stalled.
  void _noteAdvance(DateTime now) {
    _lastAdvanceAt = now;
    if (buffering.value) buffering.value = false;
  }

  /// The clock did not move. Once it has failed to move for long enough,
  /// playback is stalled whatever the player says, and extrapolation must stop
  /// with it.
  void _noteStall(DateTime now) {
    final lastAdvance = _lastAdvanceAt ??= now;
    if (now.difference(lastAdvance) >= hereSphereStallAfter &&
        !buffering.value) {
      Logger.debug('HereSphere: clock stalled, holding the device');
      buffering.value = true;
    }
  }

  /// Raises `seeking`, moves the clock, then lowers it.
  ///
  /// The order is the contract: backends rebuild on the falling edge, so the
  /// new position has to be in place before `seeking` clears.
  void _pulseSeek(double time) {
    _seekPulse?.cancel();
    batch(() {
      seeking.value = true;
      rawPosition.value = time;
      buffering.value = false;
    });
    _lastAdvanceAt = DateTime.now();
    _seekPulse = Timer(hereSphereSeekPulse, () {
      _seekPulse = null;
      seeking.value = false;
    });
  }

  @override
  void seekTo(Duration position) {
    final commands = _commands;
    if (commands == null) unsupported(PlaybackCapability.seek);
    commands.seek(position.inMicroseconds / Duration.microsecondsPerSecond);
  }

  @override
  void togglePause() {
    final commands = _commands;
    if (commands == null) unsupported(PlaybackCapability.playPause);
    commands.setPaused(!paused.value);
  }

  @override
  void setSpeed(double speed) {
    final commands = _commands;
    if (commands == null) unsupported(PlaybackCapability.setSpeed);
    commands.setSpeed(speed);
  }

  @override
  void dispose() {
    _seekPulse?.cancel();
    _seekPulse = null;
    _smooth?.dispose();
    super.dispose();
  }
}

/// The commands a session may send back to the player.
///
/// An interface rather than the client itself so the session stays testable and
/// cannot reach the socket for anything else.
abstract class HereSphereCommandSink {
  void seek(double seconds);
  void setPaused(bool paused);
  void setSpeed(double speed);
}
