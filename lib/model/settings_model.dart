import 'dart:async';

import 'package:flutter/material.dart';
import 'package:syncopathy/helper/throttler.dart';
import 'package:syncopathy/sqlite/database_helper.dart';
import 'package:syncopathy/sqlite/models/settings.dart';

class SettingsModel {
  late Settings _entity;
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
  late ValueNotifier<bool> autoSwitchToVideoPlayerTab;
  late ValueNotifier<bool> autoPlay;
  late ValueNotifier<bool> invert;
  StreamController<void> get saveNotifier => _saveNotifier;
  final _saveNotifier = StreamController<void>.broadcast();

  SettingsModel() {
    min = ValueNotifier<int>(0);
    max = ValueNotifier<int>(0);
    offsetMs = ValueNotifier<int>(0);
    mediaPaths = ValueNotifier<List<String>>([]);
    slewMaxRateOfChange = ValueNotifier<double?>(null);
    rdpEpsilon = ValueNotifier<double?>(null);
    remapFullRange = ValueNotifier<bool>(false);
    skipToAction = ValueNotifier<bool>(false);
    embeddedVideoPlayer = ValueNotifier<bool>(false);
    autoSwitchToVideoPlayerTab = ValueNotifier<bool>(false);
    autoPlay = ValueNotifier<bool>(true);
    invert = ValueNotifier<bool>(false);
  }

  Future<void> load() async {
    _entity = await DatabaseHelper().getSettings();
    min.value = _entity.min;
    max.value = _entity.max;
    offsetMs.value = _entity.offsetMs;
    mediaPaths.value = _entity.mediaPaths;
    slewMaxRateOfChange.value = _entity.slewMaxRateOfChange;
    rdpEpsilon.value = _entity.rdpEpsilon;
    remapFullRange.value = _entity.remapFullRange;
    skipToAction.value = _entity.skipToAction;
    embeddedVideoPlayer.value = _entity.embeddedVideoPlayer;
    autoSwitchToVideoPlayerTab.value = _entity.autoSwitchToVideoPlayerTab;
    autoPlay.value = _entity.autoPlay;
    invert.value = _entity.invert;
    await _save();
  }

  Future<void> _save() async {
    _throttler.run(() => _saveInternal());
  }

  Future<void> _saveInternal() async {
    await DatabaseHelper().updateSettings(_entity);
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

  Future<void> setAutoSwitchToVideoPlayerTab(bool value) async {
    _entity.autoSwitchToVideoPlayerTab = value;
    await _save();
    autoSwitchToVideoPlayerTab.value = value;
  }

  Future<void> setAutoPlay(bool value) async {
    _entity.autoPlay = value;
    await _save();
    autoPlay.value = value;
  }

  Future<void> setInvert(bool value) async {
    _entity.invert = value;
    await _save();
    invert.value = value;
  }
}
