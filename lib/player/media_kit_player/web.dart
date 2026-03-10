import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart' hide Video;
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/player/video_player.dart';

class MediaKitPlayerImpl extends VideoPlayer {
  @override
  ReadonlySignal<bool> get paused => _paused;
  late final ReadonlySignal<bool> _paused;

  MediaKitPlayerImpl({required super.embeddedPlayer}) {
    player = Player(configuration: PlayerConfiguration(title: "syncopathy"));
    controller = embeddedPlayer ? VideoController(player) : null;
    _paused = player.stream.playing
        .map((p) => !p)
        .toSyncSignal(!player.state.playing);
    initSignals(player);
  }
}
