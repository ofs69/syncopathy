import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/player/video_player.dart';

// stupid stub class
class MediaKitPlayerImpl extends VideoPlayer {
  MediaKitPlayerImpl({
    required super.embeddedPlayer,
    ReadonlySignal<String>? hwdec,
  });
  @override
  ReadonlySignal<bool> get paused => throw UnimplementedError();
}
