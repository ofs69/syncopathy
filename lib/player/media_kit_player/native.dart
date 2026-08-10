import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart' hide Video;
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/player/video_player.dart';

class MediaKitPlayerImpl extends VideoPlayer {
  @override
  ReadonlySignal<bool> get paused => _paused;
  final Signal<bool> _paused = signal(false);

  /// Last value written to mpv, so the reactive re-apply below can skip writes
  /// that would change nothing.
  String _appliedHwdec;

  MediaKitPlayerImpl({
    required super.embeddedPlayer,
    required ReadonlySignal<String> hwdec,
  }) : _appliedHwdec = hwdec.value {
    player = Player(
      configuration: PlayerConfiguration(
        osc: !embeddedPlayer,
        externalWindow: !embeddedPlayer,
        aditionalLibMpvOptions: {
          'config': 'yes',
          // Point mpv at our app-owned config dir (set during platform init)
          // so it uses our mpv.conf/input.conf rather than the user's global
          // mpv configuration. Empty string falls back to mpv's defaults.
          'config-dir': mpvConfigDir ?? '',
          'input-default-bindings': 'yes',
          // Only takes effect for the external window, where there is no
          // VideoController; the embedded path is governed by the controller
          // configuration below, which mpv applies later and thus wins.
          'hwdec': _appliedHwdec,
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
              hwdec: _appliedHwdec,
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
    // Prefetch the next playlist entry so switches don't pay the full load cost.
    nativePlayer?.setProperty('prefetch-playlist', 'yes');
    // Local files don't need the disk-backed cache (meant for network streams).
    nativePlayer?.setProperty('cache-on-disk', 'no');
    nativePlayer?.command(["keybind", "CLOSE_WIN", "ignore"]);
    nativePlayer?.command(["keybind", "q", "ignore"]);

    // Apply later changes to the setting without a restart. `hwdec` is one of
    // mpv's runtime-changeable options, and writing it as a property is the only
    // reliable way to change it: VideoController issues its own hwdec property
    // write once it attaches, after both the init options and mpv.conf have been
    // read, so anything set earlier would be overwritten.
    //
    // The first run is a no-op because _appliedHwdec already holds the value
    // baked into the configuration above.
    final mpv = nativePlayer;
    if (mpv != null) {
      effectAdd([
        effect(() {
          final value = hwdec.value;
          if (value == _appliedHwdec) return;
          _appliedHwdec = value;
          mpv.setProperty('hwdec', value);
        }),
      ]);
    }
  }
}
