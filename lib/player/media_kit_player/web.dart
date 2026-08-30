import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart' hide Video;
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/player/media_kit_player/media_kit_video_player.dart';

/// One-time initialization of the playback engine, before any player is built.
void initPlaybackEngine() => MediaKit.ensureInitialized();

class MediaKitPlayerImpl extends MediaKitVideoPlayer {
  @override
  ReadonlySignal<bool> get paused => _paused;
  late final ReadonlySignal<bool> _paused;

  /// Accepted for signature parity with the native implementation. The web
  /// player decodes in the browser, which exposes no equivalent knob.
  MediaKitPlayerImpl({
    required super.embeddedPlayer,
    ReadonlySignal<String>? hwdec,
  }) {
    player = Player(configuration: PlayerConfiguration(title: "syncopathy"));
    controller = embeddedPlayer ? VideoController(player) : null;
    _paused = player.stream.playing
        .map((p) => !p)
        .toSyncSignal(!player.state.playing);
    initSignals(player);
  }
}
