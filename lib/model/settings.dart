import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:isar/isar.dart';
import 'package:syncopathy/main.dart';
import 'package:syncopathy/helper/throttler.dart';

part 'settings.g.dart';

@collection
class SettingsEntity {
  // Use a fixed ID for the single settings object
  Id id = 0;

  int min = 0;
  int max = 100;
  int offsetMs = 25;
  List<String> mediaPaths = [];
  double? slewMaxRateOfChange = 400;
  double? rdpEpsilon = 15;
  bool remapFullRange = true;
  bool skipToAction = true;
  bool embeddedVideoPlayer = false;
}

class Settings {
  late SettingsEntity _entity;
  final _throttler = Throttler(milliseconds: 500);

  late ValueNotifier<int> min;
  late ValueNotifier<int> max;
  late ValueNotifier<int> offsetMs;
  late ValueNotifier<List<String>> mediaPaths;
  late ValueNotifier<double?> slewMaxRateOfChange;
  late ValueNotifier<double?> rdpEpsilon;
  late ValueNotifier<bool> remapFullRange;
  late ValueNotifier<bool> skipToAction;
  late ValueNotifier<bool> embeddedVideoPlayer;
  StreamController<void> get saveNotifier => _saveNotifier;
  final _saveNotifier = StreamController<void>.broadcast();

  Settings() {
    min = ValueNotifier<int>(0);
    max = ValueNotifier<int>(0);
    offsetMs = ValueNotifier<int>(0);
    mediaPaths = ValueNotifier<List<String>>([]);
    slewMaxRateOfChange = ValueNotifier<double?>(null);
    rdpEpsilon = ValueNotifier<double?>(null);
    remapFullRange = ValueNotifier<bool>(false);
    skipToAction = ValueNotifier<bool>(false);
    embeddedVideoPlayer = ValueNotifier<bool>(false);
  }

  Future<void> load() async {
    _entity = await isar.settingsEntitys.get(0) ?? SettingsEntity();
    // by default isar lists are not growable...
    // this fixes an issue where only one path could be added
    _entity.mediaPaths = _entity.mediaPaths.toList();
    min.value = _entity.min;
    max.value = _entity.max;
    offsetMs.value = _entity.offsetMs;
    mediaPaths.value = _entity.mediaPaths;
    slewMaxRateOfChange.value = _entity.slewMaxRateOfChange;
    rdpEpsilon.value = _entity.rdpEpsilon;
    remapFullRange.value = _entity.remapFullRange;
    skipToAction.value = _entity.skipToAction;
    embeddedVideoPlayer.value = _entity.embeddedVideoPlayer;
    await _save();
  }

  Future<void> _save() async {
    _throttler.run(() => _saveInternal());
  }

  Future<void> _saveInternal() async {
    await isar.writeTxn(() async {
      await isar.settingsEntitys.put(_entity);
    });
    _saveNotifier.add(null);
  }

  Future<void> setRdpEpsilon(double? value) async {
    _entity.rdpEpsilon = value;
    await _save();
    rdpEpsilon.value = value;
  }

  Future<void> setSlewMaxRateOfChange(double? maxRateOfChange) async {
    _entity.slewMaxRateOfChange = maxRateOfChange;
    await _save();
    slewMaxRateOfChange.value = maxRateOfChange;
  }

  Future<void> setMinMax(int min, int max) async {
    _entity.min = min;
    _entity.max = max;
    await _save();
    this.min.value = min;
    this.max.value = max;
  }

  Future<void> setOffsetMs(int offsetMs) async {
    _entity.offsetMs = offsetMs;
    _save();
    this.offsetMs.value = offsetMs;
  }

  Future<void> setPaths(List<String> paths) async {
    _entity.mediaPaths = paths;
    await _save();
    mediaPaths.value = _entity.mediaPaths.toList();
  }

  Future<void> addPath(String path) async {
    if (_entity.mediaPaths.contains(path)) return;
    _entity.mediaPaths.add(path);
    await _save();
    mediaPaths.value = _entity.mediaPaths.toList();
  }

  Future<void> removePath(String path) async {
    _entity.mediaPaths.remove(path);
    await _save();
    mediaPaths.value = _entity.mediaPaths.toList();
  }

  Future<void> setRemapFullRange(bool value) async {
    _entity.remapFullRange = value;
    await _save();
    remapFullRange.value = value;
  }

  Future<void> setSkipToAction(bool value) async {
    _entity.skipToAction = value;
    await _save();
    skipToAction.value = value;
  }

  Future<void> setEmbeddedVideoPlayer(bool value) async {
    _entity.embeddedVideoPlayer = value;
    await _save();
    embeddedVideoPlayer.value = value;
  }
}
