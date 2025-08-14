import 'dart:async';
import 'package:libmpv_dart/libmpv.dart';
import 'package:flutter/material.dart';

import 'package:syncopathy/logging.dart';
import 'package:syncopathy/model/funscript.dart';
import 'package:syncopathy/funscript_algo.dart';
import 'package:syncopathy/player/funscript_stream_controller.dart';
import 'package:syncopathy/player/handy_ble.dart';
import 'package:syncopathy/player/mpv.dart';
import 'package:syncopathy/model/settings.dart';
import 'package:syncopathy/model/video_model.dart';
import 'package:syncopathy/media_manager.dart';

class PlayerModel extends ChangeNotifier {
  late MpvVideoplayer _mpvPlayer;

  late final HandyBle _handyBle;
  final Settings _settings;
  final MediaManager _mediaManager;

  ValueNotifier<bool> get paused => _mpvPlayer.paused;
  ValueNotifier<double> get positionNoOffset => _mpvPlayer.position;
  ValueNotifier<double> get duration => _mpvPlayer.duration;
  ValueNotifier<double> get playbackSpeed => _mpvPlayer.playbackSpeed;
  ValueNotifier<double> get volume => _mpvPlayer.volume;
  ValueNotifier<VideoParams> get videoParams => _mpvPlayer.videoParams;

  ValueNotifier<bool> get isConnected => _handyBle.isConnected;
  ValueNotifier<bool> get isScanning => _handyBle.isScanning;

  ValueNotifier<String> get mediaPath => _mpvPlayer.path;
  ValueNotifier<Funscript?> currentFunscript = ValueNotifier(null);
  ValueNotifier<Video?> currentVideoNotifier = ValueNotifier(null);

  int get positionMs =>
      (positionNoOffset.value * 1000.0).round().toInt() +
      _settings.offsetMs.value;

  ValueNotifier<int> get textureId => _mpvPlayer.textureId;

  late final FunscriptStreamController _funscriptStreamController;

  PlayerModel(this._settings, this._mediaManager) {
    _mpvPlayer = MpvVideoplayer(
      videoOutput: _settings.embeddedVideoPlayer.value,
    );
    _mpvPlayer.duration.addListener(_handleDurationChange);

    _handyBle = HandyBle();
    _funscriptStreamController = FunscriptStreamController(_handyBle);

    mediaPath.addListener(_handleMediaPathChange);
    currentFunscript.addListener(_handleLoadedScript);

    paused.addListener(_handlePausedChanged);
    positionNoOffset.addListener(_handlePositionChanged);
    _settings.saveNotifier.stream.listen((_) {
      applySettings();
    });
  }

  void _handleDurationChange() {
    if (_settings.skipToAction.value) {
      final startTime = FunscriptAlgorithms.findFirstStroke(
        currentFunscript.value!.actions,
      );
      final percentPos = (startTime / 1000.0) / duration.value;
      _mpvPlayer.seekTo(percentPos.clamp(0.0, 1.0));
    }
  }

  void tryConnect() {
    _handyBle.startScan(
      (_settings.min.value.toDouble() / 100.0).clamp(0.0, 1.0),
      (_settings.max.value.toDouble() / 100.0).clamp(0.0, 1.0),
    );
  }

  @override
  void dispose() {
    mediaPath.removeListener(_handleMediaPathChange);
    _handyBle.dispose();

    _mpvPlayer.dispose();
    super.dispose();
  }

  Future<void> _handleLoadedScript() async {
    Logger.debug(currentFunscript.value?.fileName ?? "no script loaded");

    if (currentFunscript.value != null) {
      await _funscriptStreamController.loadFunscript(
        currentFunscript.value!,
        playbackSpeed.value,
      );
    } else {
      await _funscriptStreamController.unloadFunscript();
    }
  }

  void _handleMediaPathChange() async {
    if (mediaPath.value.isEmpty) {
      currentVideoNotifier.value = null;
      return;
    }

    if (currentVideoNotifier.value == null ||
        currentVideoNotifier.value!.videoPath != mediaPath.value) {
      final video = await _mediaManager.getVideoByPath(mediaPath.value);
      if (video != null) {
        currentVideoNotifier.value = video;
      } else {
        closeVideo();
      }
    }
  }

  Future<void> _loadAndProcessFunscript(String script) async {
    var funscriptFile = await Funscript.fromFile(script).catchError(
      (e) => null,
      test: (e) {
        Logger.error(e.toString());
        return true;
      },
    );
    funscriptFile!.actions = FunscriptAlgorithms.processForHandy(
      funscriptFile.actions,
      rdpEpsilon: _settings.rdpEpsilon.value,
      slewMaxRateOfChangePerSecond: _settings.slewMaxRateOfChange.value,
      remapRange: _settings.remapFullRange.value ? (0, 100) : null,
    );
    currentFunscript.value = funscriptFile;
  }

  Future<void> _handlePausedChanged() async {
    if (paused.value) {
      await _funscriptStreamController.stopPlayback();
    } else {
      await _funscriptStreamController.startPlayback(
        positionMs,
        playbackSpeed.value,
      );
    }
  }

  Future<void> _handlePositionChanged() async {
    await _funscriptStreamController.positionUpdate(
      positionMs,
      paused.value,
      playbackSpeed.value,
    );
  }

  void seekTo(double time) {
    final posPercent = time / duration.value;
    _mpvPlayer.seekTo(posPercent.clamp(0.0, 1.0));
  }

  void togglePause() {
    _mpvPlayer.togglePause();
  }

  void setPlaybackSpeed(double speed) {
    _mpvPlayer.setSpeed(speed.clamp(0.5, 2.0));
  }

  void setVolume(double volume) {
    _mpvPlayer.setVolume(volume);
  }

  void setMinMax(int min, int max) {
    _settings.setMinMax(min, max);
  }

  void applySettings() {
    Logger.debug(
      "Applying min ${_settings.min.value} max: ${_settings.max.value}",
    );
    _handyBle.setSettings(
      (_settings.min.value.toDouble() / 100.0).clamp(0.0, 1.0),
      (_settings.max.value.toDouble() / 100.0).clamp(0.0, 1.0),
    );
  }

  Future<void> closeVideo() async {
    _mpvPlayer.pause();
    await _funscriptStreamController.stopPlayback();
    await _funscriptStreamController.unloadFunscript();
    _mpvPlayer.closeFile();
    _mpvPlayer.path.value = "";
  }

  void openVideoAndScript(Video video) async {
    try {
      await closeVideo();
      await _loadAndProcessFunscript(video.funscriptPath);
      _mpvPlayer.loadFile(video.videoPath);
      if (_settings.autoPlay.value) {
        _mpvPlayer.play();
      }
      return;
    } catch (e) {
      Logger.error(e.toString());
    }
  }

  void setSizeAndPosition(int width, int height, int x, int y) {
    _mpvPlayer.setSizeAndPosition(width, height, x, y);
  }
}
