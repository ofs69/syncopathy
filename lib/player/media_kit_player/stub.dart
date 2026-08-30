import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/player/media_kit_player/media_kit_video_player.dart';

/// One-time initialization of the playback engine, before any player is built.
void initPlaybackEngine() => throw UnimplementedError();

// stupid stub class
class MediaKitPlayerImpl extends MediaKitVideoPlayer {
  MediaKitPlayerImpl({
    required super.embeddedPlayer,
    ReadonlySignal<String>? hwdec,
  });
  @override
  ReadonlySignal<bool> get paused => throw UnimplementedError();
}
