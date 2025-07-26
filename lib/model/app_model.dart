import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter/widgets.dart';
import 'package:syncopathy/model/funscript.dart';
import 'package:syncopathy/funscript_algo.dart';
import 'package:syncopathy/funscript_stream_controller.dart';
import 'package:syncopathy/handy_ble.dart';
import 'package:syncopathy/mpv.dart';
import 'package:syncopathy/model/settings.dart';
import 'package:syncopathy/model/user_category.dart';

class SyncopathyModel extends ChangeNotifier {
  final MpvVideoplayer _mpv = MpvVideoplayer();
  final _errorController = StreamController<String>.broadcast();
  final _notificationController = StreamController<String>.broadcast();

  late final HandyBle _handyBle;
  late final Settings settings;

  FunscriptDevice? get device => _handyBle;

  ValueNotifier<UserCategory?> selectedCategory = ValueNotifier(null);

  ValueNotifier<bool> get paused => _mpv.paused;
  ValueNotifier<double> get positionNoOffset => _mpv.position;
  ValueNotifier<double> get duration => _mpv.duration;
  ValueNotifier<double> get playbackSpeed => _mpv.playbackSpeed;

  ValueNotifier<bool> get isConnected => _handyBle.isConnected;
  ValueNotifier<bool> get isScanning => _handyBle.isScanning;
  Stream<String> get onError => _errorController.stream;
  Stream<String> get onNotification => _notificationController.stream;

  ValueNotifier<String> get path => _mpv.path;
  ValueNotifier<Funscript?> funscript = ValueNotifier(null);
  String? _lastAttemptedLoadPath;
  int get positionMs =>
      (positionNoOffset.value * 1000.0).round().toInt() + settings.offsetMs;

  late final FunscriptStreamController _funscriptStreamController;

  SyncopathyModel() {
    settings = Settings();

    _handyBle = HandyBle(_errorController, _notificationController);
    _funscriptStreamController = FunscriptStreamController(_handyBle);

    path.addListener(_tryToLoadFunscript);
    funscript.addListener(_handleLoadedScript);

    paused.addListener(_handlePausedChanged);
    positionNoOffset.addListener(_handlePositionChanged);
    settings.addListener(applySettings);
  }

  Future<void> initialize() async {
    await settings.load();
  }

  void selectCategory(UserCategory? category) {
    selectedCategory.value = category;
  }

  void tryConnect() {
    _handyBle.startScan(
      (settings.min.toDouble() / 100.0).clamp(0.0, 1.0),
      (settings.max.toDouble() / 100.0).clamp(0.0, 1.0),
    );
  }

  @override
  void dispose() {
    path.removeListener(_tryToLoadFunscript);
    _handyBle.dispose();
    settings.removeListener(applySettings);
    _mpv.dispose();
    super.dispose();
  }

  void _handleLoadedScript() async {
    _addNotification(funscript.value?.fileName ?? "no script loaded");

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
      _addError('Error while searching for funscript: $e');
    }
    _addError('Failed to find funscript');
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

        _mpv.loadFile(filePath);
        return;
      } catch (e) {
        _addError(e.toString());
      }
    }
    funscript.value = null;
    _mpv.closeFile();
    _mpv.path.value = "";
  }

  Future<void> _loadAndProcessFunscript(String script) async {
    var funscriptFile = await Funscript.fromFile(script).catchError(
      (e) => null,
      test: (e) {
        _addError(e.toString());
        return true;
      },
    );
    funscriptFile!.actions = FunscriptAlgorithms.processForHandy(
      funscriptFile.actions,
      rdpEpsilon: settings.rdpEpsilon,
      slewMaxRateOfChangePerSecond: settings.slewMaxRateOfChange,
      remapRange: settings.remapFullRange ? (0, 100) : null,
    );
    funscript.value = funscriptFile;
  }

  void _addError(String string) => _errorController.sink.add(string);
  void _addNotification(String string) =>
      _notificationController.sink.add(string);

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
    _mpv.seekTo(posPercent.clamp(0.0, 1.0));
  }

  // These methods assume your MpvVideoplayer class has corresponding
  // `togglePause()` and `setSpeed(double)` methods.
  void togglePause() {
    _mpv.togglePause();
  }

  void setPlaybackSpeed(double speed) {
    _mpv.setSpeed(speed.clamp(0.5, 2.0));
  }

  void applySettings() {
    _handyBle.setSettings(
      (settings.min.toDouble() / 100.0).clamp(0.0, 1.0),
      (settings.max.toDouble() / 100.0).clamp(0.0, 1.0),
    );
  }

  void closeVideo() {
    _mpv.pause();
    _funscriptStreamController.stopPlayback();
    _funscriptStreamController.unloadFunscript();
    _mpv.closeFile();
    _mpv.path.value = "";
  }

  void openVideoAndScript(String videoPath, String funscriptPath) async {
    try {
      closeVideo();
      _lastAttemptedLoadPath = videoPath;
      await _loadAndProcessFunscript(funscriptPath);
      _mpv.loadFile(videoPath);
      return;
    } catch (e) {
      _addError(e.toString());
    }
  }
}