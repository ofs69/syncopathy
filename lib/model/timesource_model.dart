import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/player/media_kit_player.dart';

class TimesourceModel {
  final ReadonlySignal<double> volume;
  final ReadonlySignal<double> duration;
  final ReadonlySignal<double> playbackSpeed;
  final ReadonlySignal<bool> paused;
  final ReadonlySignal<double> rawPosition;
  final ReadonlySignal<double> smoothPosition;
  final ReadonlySignal<int?> videoWidth;
  final ReadonlySignal<int?> videoHeight;
  final ReadonlySignal<bool> loopFile;
  final ReadonlySignal<String> loadedPath;

  int get currentSmoothMs => (smoothPosition.value * 1000.0).round();
  int get currentRawMs => (rawPosition.value * 1000.0).round();

  TimesourceModel({
    required this.volume,
    required this.duration,
    required this.playbackSpeed,
    required this.paused,
    required this.rawPosition,
    required this.smoothPosition,
    required this.videoWidth,
    required this.videoHeight,
    required this.loopFile,
    required this.loadedPath,
  });

  static TimesourceModel fromPlayer(MediaKitPlayer player) => TimesourceModel(
    volume: player.volume,
    duration: player.duration,
    playbackSpeed: player.playbackSpeed,
    paused: player.paused,
    rawPosition: player.rawPosition,
    smoothPosition: player.smoothPosition,
    videoWidth: player.videoWidth,
    videoHeight: player.videoHeight,
    loopFile: player.loopFile,
    loadedPath: player.loadedPath,
  );
}
