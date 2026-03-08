import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/player/video_player.dart';

// stupid stub class
class MediaKitPlayerImpl extends VideoPlayer {
  MediaKitPlayerImpl({required super.embeddedPlayer});
  @override
  ReadonlySignal<bool> get paused => throw UnimplementedError();
}