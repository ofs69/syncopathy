import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';

import 'package:syncopathy/logging.dart';
import 'package:syncopathy/model/funscript.dart';
import 'package:syncopathy/funscript_algo.dart';
import 'package:syncopathy/funscript_stream_controller.dart';
import 'package:syncopathy/handy_ble.dart';
import 'package:syncopathy/mpv.dart';
import 'package:syncopathy/model/settings.dart';

class PlayerModel extends ChangeNotifier {
  late final MpvVideoplayer mpvPlayer;

  late final HandyBle _handyBle;
  final Settings settings;

  FunscriptDevice? get device => _handyBle;

  ValueNotifier<bool> get paused => mpvPlayer.paused;
  ValueNotifier<double> get positionNoOffset => mpvPlayer.position;
  ValueNotifier<double> get duration => mpvPlayer.duration;
  ValueNotifier<double> get playbackSpeed => mpvPlayer.playbackSpeed;
  ValueNotifier<double> get volume => mpvPlayer.volume;

  ValueNotifier<bool> get isConnected => _handyBle.isConnected;
  ValueNotifier<bool> get isScanning => _handyBle.isScanning;

  ValueNotifier<String> get path => mpvPlayer.path;
  ValueNotifier<Funscript?> funscript = ValueNotifier(null);

  String? _lastAttemptedLoadPath;
  int get positionMs =>
      (positionNoOffset.value * 1000.0).round().toInt() +
      settings.offsetMs.value;

  late final FunscriptStreamController _funscriptStreamController;

  PlayerModel(this.settings) {
    mpvPlayer = MpvVideoplayer(videoOutput: settings.embeddedVideoPlayer.value);
    mpvPlayer.duration.addListener(_handleDurationChange);

    _handyBle = HandyBle();
    _funscriptStreamController = FunscriptStreamController(_handyBle);

    path.addListener(_tryToLoadFunscript);
    funscript.addListener(_handleLoadedScript);

    paused.addListener(_handlePausedChanged);
    positionNoOffset.addListener(_handlePositionChanged);
    settings.saveNotifier.stream.listen((_) {
      applySettings();
    });

    
  }

  void _handleDurationChange() {
    if (settings.skipToAction.value) {
      final startTime = FunscriptAlgorithms.findFirstStroke(
        funscript.value!.actions,
      );
      final percentPos = (startTime / 1000.0) / duration.value;
      mpvPlayer.seekTo(percentPos.clamp(0.0, 1.0));
    }
  }

  void tryConnect() {
    _handyBle.startScan(
      (settings.min.value.toDouble() / 100.0).clamp(0.0, 1.0),
      (settings.max.value.toDouble() / 100.0).clamp(0.0, 1.0),
    );
  }

  @override
  void dispose() {
    path.removeListener(_tryToLoadFunscript);
    _handyBle.dispose();

    mpvPlayer.dispose();
    super.dispose();
  }

  void _handleLoadedScript() async {
    Logger.debug(funscript.value?.fileName ?? "no script loaded");

    if (funscript.value != null) {
      _funscriptStreamController.loadFunscript(
        funscript.value!,
        positionMs,
        playbackSpeed.value,
      );
    } else {
      _funscriptStreamController.unloadFunscript();
    }
  }

  String? _findFunscript(String mediaPath) {
    // Searches for a .funscript file in the same directory as mediaPath,
    // with the same base name.
    try {
      final directoryPath = p.dirname(mediaPath);
      final baseName = p.basenameWithoutExtension(mediaPath);
      final funscriptPath = p.join(directoryPath, '$baseName.funscript');

      if (File(funscriptPath).existsSync()) {
        return funscriptPath;
      }
    } catch (e) {
      // It's possible mediaPath is not a valid path, causing an exception.
      // In that case, we can't find a funscript.
      Logger.error('Error while searching for funscript: $e');
    }
    Logger.error('Failed to find funscript');
    return null;
  }

  void _tryToLoadFunscript() async {
    await tryToOpenVideo(path.value);
  }

  Future<void> tryToOpenVideo(String filePath) async {
    var testFile = File(filePath);
    if (_lastAttemptedLoadPath == filePath ||
        filePath.isEmpty ||
        !await testFile.exists()) {
      return;
    }
    _lastAttemptedLoadPath = filePath;

    if (funscript.value != null && funscript.value?.filePath == filePath) {
      return;
    }

    final script = _findFunscript(filePath);
    if (script != null) {
      try {
        closeVideo();
        await _loadAndProcessFunscript(script);

        mpvPlayer.loadFile(filePath);
        return;
      } catch (e) {
        Logger.error(e.toString());
      }
    }
    funscript.value = null;
    mpvPlayer.closeFile();
    mpvPlayer.path.value = "";
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
      rdpEpsilon: settings.rdpEpsilon.value,
      slewMaxRateOfChangePerSecond: settings.slewMaxRateOfChange.value,
      remapRange: settings.remapFullRange.value ? (0, 100) : null,
    );
    funscript.value = funscriptFile;
  }

  void _handlePausedChanged() {
    if (paused.value) {
      _funscriptStreamController.stopPlayback();
    } else {
      _funscriptStreamController.startPlayback(positionMs, playbackSpeed.value);
    }
  }

  void _handlePositionChanged() {
    _funscriptStreamController.positionUpdate(
      positionMs,
      paused.value,
      playbackSpeed.value,
    );
  }

  void seekTo(double time) {
    final posPercent = time / duration.value;
    mpvPlayer.seekTo(posPercent.clamp(0.0, 1.0));
  }

  void togglePause() {
    mpvPlayer.togglePause();
  }

  void setPlaybackSpeed(double speed) {
    mpvPlayer.setSpeed(speed.clamp(0.5, 2.0));
  }

  void setVolume(double volume) {
    mpvPlayer.setVolume(volume);
  }

  void setMinMax(int min, int max) {
    settings.setMinMax(min, max);
  }

  void applySettings() {
    Logger.debug("Applying min ${settings.min.value} max: ${settings.max.value}");
    _handyBle.setSettings(
      (settings.min.value.toDouble() / 100.0).clamp(0.0, 1.0),
      (settings.max.value.toDouble() / 100.0).clamp(0.0, 1.0),
    );
  }

  void closeVideo() {
    mpvPlayer.pause();
    _funscriptStreamController.stopPlayback();
    _funscriptStreamController.unloadFunscript();
    mpvPlayer.closeFile();
    mpvPlayer.path.value = "";
  }

  void openVideoAndScript(String videoPath, String funscriptPath) async {
    try {
      closeVideo();
      _lastAttemptedLoadPath = videoPath;
      await _loadAndProcessFunscript(funscriptPath);
      mpvPlayer.loadFile(videoPath);
      return;
    } catch (e) {
      Logger.error(e.toString());
    }
  }
}
