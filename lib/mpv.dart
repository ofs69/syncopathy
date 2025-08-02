import 'package:flutter/foundation.dart';
import 'package:libmpv_dart/libmpv.dart';

class MpvVideoplayer {
  late Player player;

  ValueNotifier<bool> get paused => player.paused;
  ValueNotifier<double> get position => player.position;
  ValueNotifier<double> get duration => player.duration;
  ValueNotifier<double> get playbackSpeed => player.speed;
  ValueNotifier<String> get path => player.path;
  ValueNotifier<double> get volume => player.volume;

  MpvVideoplayer({required bool videoOutput}) {
    player = Player(
      {
        'config': 'yes',
        'config-dir': '',
        'input-default-bindings': 'yes',
        'vo': 'gpu-next',
        'osc': 'yes',
        'hwdec': 'auto-safe',
        'border': 'yes',
        'geometry': "1280x720",
        'idle': 'yes',
        'force-window': 'yes',
      },
      videoOutput: videoOutput,
      initialize: true,
    );

    player.setPropertyString('keep-open', 'always');
    player.setPropertyString('loop-file', 'inf');
    player.setPropertyString("pause", 'yes');
    player.setPropertyDouble("volume", 100.0);

    player.command(["keybind", "CLOSE_WIN", "ignore"]);
    player.command(["keybind", "q", "ignore"]);
  }

  void loadFile(String filepath) {
    player.command(["loadfile", filepath]);
    bringToFront();
  }

  void closeFile() {
    player.command(["stop"]);
    player.command(["loadfile", ""]);
  }

  void dispose() {
    player.destroy();
  }

  void bringToFront() async {
    player.setPropertyString("ontop", "yes");
    await Future.delayed(Duration(microseconds: 100));
    player.setPropertyString("ontop", "no");
  }

  void seekTo(double positionPercent) {
    player.command([
      "seek",
      (positionPercent * 100.0).toString(),
      "absolute-percent+exact",
    ]);
  }

  void pause() {
    player.setPropertyFlag('pause', true);
  }

  void togglePause() {
    player.setPropertyFlag('pause', !paused.value);
  }

  void setSpeed(double speed) {
    player.command(["set", "speed", speed.toStringAsPrecision(3)]);
  }

  void setVolume(double volume) {
    player.setPropertyDouble('volume', volume.clamp(0, 100));
  }
}
