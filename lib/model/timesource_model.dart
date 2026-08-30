import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/player/playback_session.dart';

/// The read-only clock the device backends run on.
///
/// A deliberately narrow view of a [PlaybackSession]: backends get the media
/// clock and nothing else — no commands, no playlist, no way to reach the
/// player.
class TimesourceModel {
  final ReadonlySignal<double?> duration;
  final ReadonlySignal<double> playbackSpeed;
  final ReadonlySignal<bool> paused;
  final ReadonlySignal<double> rawPosition;
  final ReadonlySignal<double> smoothPosition;
  final ReadonlySignal<int?> videoWidth;
  final ReadonlySignal<int?> videoHeight;
  final ReadonlySignal<bool> loopFile;
  final ReadonlySignal<String> loadedPath;
  final ReadonlySignal<bool> seeking;

  int get currentSmoothMs => (smoothPosition.value * 1000.0).round();
  int get currentRawMs => (rawPosition.value * 1000.0).round();

  TimesourceModel({
    required this.duration,
    required this.playbackSpeed,
    required this.paused,
    required this.seeking,
    required this.rawPosition,
    required this.smoothPosition,
    required this.videoWidth,
    required this.videoHeight,
    required this.loopFile,
    required this.loadedPath,
  });

  /// Reads through [session] rather than capturing one player's signals, so a
  /// different [PlaybackSession] can take over the clock without every backend
  /// having to be torn down and rebuilt around new signal instances.
  factory TimesourceModel.fromSession(
    ReadonlySignal<PlaybackSession> session,
  ) => TimesourceModel(
    duration: computed(() => session.value.duration.value),
    playbackSpeed: computed(() => session.value.playbackSpeed.value),
    // A session that has lost contact with its player must read as paused: an
    // extrapolated clock with nothing correcting it would keep driving the
    // device long after playback actually stopped.
    paused: computed(
      () => session.value.paused.value || !session.value.connected.value,
    ),
    seeking: computed(() => session.value.seeking.value),
    rawPosition: computed(() => session.value.rawPosition.value),
    smoothPosition: computed(() => session.value.smoothPosition.value),
    videoWidth: computed(() => session.value.videoWidth.value),
    videoHeight: computed(() => session.value.videoHeight.value),
    loopFile: computed(() => session.value.loopFile.value),
    loadedPath: computed(() => session.value.loadedPath.value),
  );
}
