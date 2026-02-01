import 'dart:async';

import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/helper/debouncer.dart';
import 'package:syncopathy/sqlite/database_helper.dart';
import 'package:syncopathy/sqlite/models/settings.dart';

class SettingsModel {
  late final Settings _entity;
  final _debouncer = Debouncer(milliseconds: 500);

  final Signal<int> min = signal(0);
  final Signal<int> max = signal(100);
  late final minMaxRange = computed(
    () => RangeValues(min.value.toDouble(), max.value.toDouble()),
  );
  final Signal<int> offsetMs = signal(0);
  final Signal<List<String>> mediaPaths = listSignal([]);
  final Signal<double?> slewMaxRateOfChange = signal(null);
  final Signal<double?> rdpEpsilon = signal(null);
  final Signal<bool> remapFullRange = signal(false);
  final Signal<bool> skipToAction = signal(false);
  final Signal<bool> embeddedVideoPlayer = signal(false);
  final Signal<bool> autoSwitchToVideoPlayerTab = signal(false);
  final Signal<bool> autoPlay = signal(true);
  final Signal<bool> invert = signal(false);

  // Not persisted in the database
  Signal<bool> showDebugNotifications = signal(false);

  late final Function? _saveEffectDispose;

  SettingsModel();

  Future<void> dispose() async {
    _saveEffectDispose!();
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

    _saveEffectDispose = effect(() async {
      _entity.min = min.value;
      _entity.max = max.value;
      _entity.offsetMs = offsetMs.value;
      _entity.mediaPaths = mediaPaths.value;
      _entity.slewMaxRateOfChange = slewMaxRateOfChange.value;
      _entity.rdpEpsilon = rdpEpsilon.value;
      _entity.remapFullRange = remapFullRange.value;
      _entity.skipToAction = skipToAction.value;
      _entity.embeddedVideoPlayer = embeddedVideoPlayer.value;
      _entity.autoSwitchToVideoPlayerTab = autoSwitchToVideoPlayerTab.value;
      _entity.autoPlay = autoPlay.value;
      _entity.invert = invert.value;
      await _save();
    });
  }

  Future<void> _save() async {
    _debouncer.run(() => _saveInternal());
  }

  Future<void> _saveInternal() async {
    await DatabaseHelper().updateSettings(_entity);
  }
}
