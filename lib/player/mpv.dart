import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:libmpv_dart/libmpv.dart';

class MpvVideoplayer {
  late Player _player;

  ValueNotifier<bool> get paused => _player.paused;
  ValueNotifier<double> get position => _player.position;
  ValueNotifier<double> get duration => _player.duration;
  ValueNotifier<double> get playbackSpeed => _player.speed;
  //ValueNotifier<String> get path => _player.path;
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

  void enableLooping() {
    _player.setPropertyString('loop-file', 'inf');
  }

  void disableLooping() {
    _player.setPropertyString('loop-file', 'no');
  }

  Future<bool> loadFile(String filepath) async {
    if (_player.path.value == filepath) {
      return true;
    }

    final completer = Completer<bool>();

    void listener() {
      if (_player.duration.value > 0 && !completer.isCompleted) {
        completer.complete(true);
      }
    }

    _player.duration.addListener(listener);

    _player.command(["loadfile", filepath]);

    try {
      return await completer.future.timeout(const Duration(seconds: 5));
    } on TimeoutException {
      return false;
    } finally {
      _player.duration.removeListener(listener);
    }
  }

  Future<void> closeFile() async {
    _player.command(["stop"]);
    _player.path.value = "";
    _player.duration.value = 0.0;
  }

  void setSizeAndPosition(int width, int height, int x, int y) {
    _player.setPropertyString("geometry", "${width}x$height+$x+$y");
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

  void play() {
    _player.setPropertyFlag('pause', false);
  }

  void setSpeed(double speed) {
    _player.command(["set", "speed", speed.toStringAsPrecision(3)]);
  }

  void setVolume(double volume) {
    _player.setPropertyDouble('volume', volume.clamp(0, 100));
  }
}
