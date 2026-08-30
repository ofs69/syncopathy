import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/helper/effect_dispose_mixin.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';

/// For UI purposes the position is reported in this many discrete steps.
const int videoPlayerPositionFixedStepCount = 1000;

/// Optional commands a [PlaybackSession] may or may not be able to carry out.
///
/// Only the clock and media-identity signals are mandatory. A session that does
/// not own the video — an external player Syncopathy merely observes — supports
/// few or none of these, so callers must gate on [PlaybackSession.supports] and
/// disable the control instead of invoking a command that will throw.
enum PlaybackCapability {
  /// [PlaybackSession.openSingleVideo] can load media.
  openMedia,

  /// [PlaybackSession.closeMedia] can unload media.
  closeMedia,

  /// [PlaybackSession.seekTo] / [PlaybackSession.seekRelative] can move the
  /// playhead. Skip-to-first-stroke depends on this.
  seek,

  /// [PlaybackSession.togglePause] can start and stop playback.
  playPause,

  /// [PlaybackSession.setSpeed] can change the playback rate.
  setSpeed,

  /// [PlaybackSession.toggleLooping] can change the loop mode.
  toggleLoop,
}

/// The player that owns the media clock.
///
/// This is everything the funscript/device pipeline knows about the video side:
/// which media is loaded, where the clock is, and which commands — if any — the
/// player will accept. `media_kit` lives entirely behind its own implementation;
/// an external player implements the same contract without any of the
/// local-playback surface.
abstract class PlaybackSession with EffectDispose {
  /// The library entry currently loaded, or null when nothing is open.
  ReadonlySignal<MediaFile?> get currentMedia;

  /// Path/URI of the loaded media, empty when nothing is open. Identifies the
  /// *file*; [currentMedia] identifies the library entry it resolved to.
  ReadonlySignal<String> get loadedPath;

  /// Media length in seconds, or null while it is unknown — a load in flight,
  /// or a duration too short to be real.
  ReadonlySignal<double?> get duration;

  ReadonlySignal<bool> get paused;

  /// The player is stalled waiting for data. The clock does not advance while
  /// this is set, so extrapolation must stop with it.
  ReadonlySignal<bool> get buffering;

  /// A seek is in flight. Device backends use this to tear down and rebuild
  /// their action buffer.
  ReadonlySignal<bool> get seeking;

  /// Last position the player actually reported, in seconds.
  ReadonlySignal<double> get rawPosition;

  /// [rawPosition] extrapolated to the current frame, in seconds. Implementations
  /// should build this with `SmoothVideoSignals` rather than rolling their own.
  ReadonlySignal<double> get smoothPosition;

  ReadonlySignal<double> get playbackSpeed;

  /// The loaded media repeats when it ends.
  ReadonlySignal<bool> get loopFile;

  ReadonlySignal<int?> get videoWidth;
  ReadonlySignal<int?> get videoHeight;

  /// Which of the optional commands this session accepts right now.
  ///
  /// A signal rather than a plain set: an external session can gain and lose
  /// the ability to be commanded as its connection comes and goes, and the UI
  /// has to follow.
  ReadonlySignal<Set<PlaybackCapability>> get capabilities;

  /// Whether the session's clock can be trusted right now.
  ///
  /// Always true for a local player. An external session clears this when its
  /// heartbeat is lost, which must stop device playback rather than let an
  /// extrapolated clock keep running unattended.
  ReadonlySignal<bool> get connected => _alwaysConnected;
  static final ReadonlySignal<bool> _alwaysConnected = signal(true);

  bool supports(PlaybackCapability capability) =>
      capabilities.value.contains(capability);

  late final ReadonlySignal<int> currentPositionSeconds = computed(
    () => smoothPosition.value.toInt(),
  );

  late final ReadonlySignal<int> currentPositionFixedStep = computed(() {
    final currentPosition = smoothPosition.value;
    final totalDuration = duration.value;
    if (totalDuration == null) return 0;
    final stepSize = totalDuration / videoPlayerPositionFixedStepCount;
    return currentPosition ~/ stepSize;
  });

  /// Thrown from every command a session does not implement. Reaching one is a
  /// caller bug: check [supports] first.
  Never unsupported(PlaybackCapability capability) => throw UnsupportedError(
    '$runtimeType does not support ${capability.name}',
  );

  Future<void> openSingleVideo(MediaFile media) async =>
      unsupported(PlaybackCapability.openMedia);

  Future<void> closeMedia() async => unsupported(PlaybackCapability.closeMedia);

  void seekTo(Duration position) => unsupported(PlaybackCapability.seek);

  /// Moves the playhead by [offset] relative to the last reported position.
  void seekRelative(Duration offset) => seekTo(
    Duration(microseconds: (rawPosition.value * Duration.microsecondsPerSecond).round()) +
        offset,
  );

  void togglePause() => unsupported(PlaybackCapability.playPause);

  void setSpeed(double speed) => unsupported(PlaybackCapability.setSpeed);

  void toggleLooping() => unsupported(PlaybackCapability.toggleLoop);

  void dispose() {
    effectDispose();
  }
}

/// Holds whichever [PlaybackSession] currently owns the media clock.
///
/// Everything downstream — `TimesourceModel`, `PlayerModel`, and through them
/// every device backend — reads the session through this indirection instead of
/// capturing one instance. That way an external player can take over playback
/// with a single assignment, without rebuilding the funscript pipeline or
/// dropping a live device connection.
class ActivePlaybackSession {
  final Signal<PlaybackSession> _session;

  ActivePlaybackSession(PlaybackSession initial) : _session = signal(initial);

  ReadonlySignal<PlaybackSession> get session => _session;

  PlaybackSession get value => _session.value;

  /// Hands clock ownership to [session]. The previous session is left alone —
  /// it is not disposed, so control can be handed back.
  void takeOver(PlaybackSession session) {
    if (identical(_session.value, session)) return;
    _session.value = session;
  }
}
