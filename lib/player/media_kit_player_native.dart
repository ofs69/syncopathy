import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart' hide Video;
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/player/video_player.dart';

class MediaKitPlayerImpl extends VideoPlayer {
  @override
  ReadonlySignal<bool> get paused => _paused;
  final Signal<bool> _paused = signal(false);

  MediaKitPlayerImpl({required super.embeddedPlayer}) {
    player = Player(
      configuration: PlayerConfiguration(
        osc: !embeddedPlayer,
        externalWindow: !embeddedPlayer,
        aditionalLibMpvOptions: {
          'config': 'yes',
          'config-dir': '',
          'input-default-bindings': 'yes',
          'hwdec': 'auto-safe',
          'border': 'yes',
          'geometry': "1280x720",
          'idle': 'yes',
          'force-window': embeddedPlayer ? 'no' : 'yes',
        },
        vo: embeddedPlayer ? 'libmpv' : 'gpu-next',
        title: "syncopathy",
      ),
    );
    controller = embeddedPlayer
        ? VideoController(
            player,
            configuration: VideoControllerConfiguration(
              vo: 'libmpv',
              hwdec: 'auto-safe',
            ),
          )
        : null;

    NativePlayer? nativePlayer;
    if (player.platform is NativePlayer) {
      nativePlayer = player.platform as NativePlayer;
    }
    assert(nativePlayer != null, "Non MPV player not supported");
    _paused.value = !player.state.playing;
    // media-kit pause state is weird. listen to mpv directly
    nativePlayer?.observeProperty('pause', (value) async {
      _paused.value = value == 'yes' ? true : false;
    });
    initSignals(player);

    nativePlayer?.setProperty('keep-open', 'yes');
    nativePlayer?.command(["keybind", "CLOSE_WIN", "ignore"]);
    nativePlayer?.command(["keybind", "q", "ignore"]);
  }
}
