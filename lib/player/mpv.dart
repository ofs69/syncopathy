import 'package:flutter/foundation.dart';
import 'package:libmpv_dart/libmpv.dart';

class MpvVideoplayer {
  late Player _player;

  ValueNotifier<bool> get paused => _player.paused;
  ValueNotifier<double> get position => _player.position;
  ValueNotifier<double> get duration => _player.duration;
  ValueNotifier<double> get playbackSpeed => _player.speed;
  ValueNotifier<String> get path => _player.path;
  ValueNotifier<double> get volume => _player.volume;
  ValueNotifier<VideoParams> get videoParams => _player.videoParams;
  ValueNotifier<int> get textureId => _player.id;

  MpvVideoplayer({required bool videoOutput}) {
    _player = Player(
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

    _player.setPropertyString('keep-open', 'always');
    _player.setPropertyString('loop-file', 'inf');
    _player.setPropertyString("pause", 'yes');
    _player.setPropertyDouble("volume", 100.0);

    _player.command(["keybind", "CLOSE_WIN", "ignore"]);
    _player.command(["keybind", "q", "ignore"]);
  }

  void loadFile(String filepath) {
    _player.command(["loadfile", filepath]);
  }

  void closeFile() {
    _player.command(["stop"]);
    _player.command(["loadfile", ""]);
  }

  void dispose() {
    _player.destroy();
  }

  void bringToFront() async {
    _player.setPropertyString("ontop", "yes");
    await Future.delayed(Duration(microseconds: 100));
    _player.setPropertyString("ontop", "no");
  }

  void seekTo(double positionPercent) {
    _player.command([
      "seek",
      (positionPercent * 100.0).toString(),
      "absolute-percent+exact",
    ]);
  }

  void pause() {
    _player.setPropertyFlag('pause', true);
  }

  void togglePause() {
    _player.setPropertyFlag('pause', !paused.value);
  }

  void setSpeed(double speed) {
    _player.command(["set", "speed", speed.toStringAsPrecision(3)]);
  }

  void setVolume(double volume) {
    _player.setPropertyDouble('volume', volume.clamp(0, 100));
  }
}
