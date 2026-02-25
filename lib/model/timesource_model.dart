import 'package:media_kit/media_kit.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/player/media_kit_player.dart';

class TimesourceModel {
  final ReadonlySignal<int> textureId;
  final ReadonlySignal<double> volume;
  final ReadonlySignal<double> duration;
  final ReadonlySignal<double> playbackSpeed;
  final ReadonlySignal<bool> paused;
  final ReadonlySignal<double> rawPosition;
  final ReadonlySignal<double> smoothPosition;
  final ReadonlySignal<VideoParams> videoParams;
  final ReadonlySignal<bool> loopFile;
  final ReadonlySignal<String> loadedPath;

  int get currentSmoothMs => (smoothPosition.value * 1000.0).round();
  int get currentRawMs => (rawPosition.value * 1000.0).round();

  TimesourceModel({
    required this.textureId,
    required this.volume,
    required this.duration,
    required this.playbackSpeed,
    required this.paused,
    required this.rawPosition,
    required this.smoothPosition,
    required this.videoParams,
    required this.loopFile,
    required this.loadedPath,
  });

  static TimesourceModel fromPlayer(MediaKitPlayer player) => TimesourceModel(
    textureId: player.textureId,
    volume: player.volume,
    duration: player.duration,
    playbackSpeed: player.playbackSpeed,
    paused: player.paused,
    rawPosition: player.rawPosition,
    smoothPosition: player.smoothPosition,
    videoParams: player.videoParams,
    loopFile: player.loopFile,
    loadedPath: player.loadedPath,
  );
}
