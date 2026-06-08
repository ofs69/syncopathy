import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/helper/debouncer.dart';
import 'package:syncopathy/platform/key_value_store/key_value_store.dart';
import 'package:syncopathy/player/player_backend_type.dart';
import 'package:syncopathy/model/json/settings.dart';
import 'package:syncopathy/model/shortcut_settings.dart';

class SettingsModel {
  late Settings _entity;
  final _debouncer = Debouncer(milliseconds: 500);

  final Signal<int> min = signal(0);
  final Signal<int> max = signal(100);
  late final ReadonlySignal<RangeValues> minMaxRange = computed(
    () => RangeValues(min.value.toDouble(), max.value.toDouble()),
  );
  final Signal<int> offsetMs = signal(0);
  final ListSignal<String> mediaPaths = listSignal([]);
  final Signal<double> slewMaxRateOfChange = signal(-1);
  final Signal<double> rdpEpsilon = signal(-1);
  final Signal<bool> remapFullRange = signal(false);
  final Signal<bool> skipToAction = signal(false);
  final Signal<bool> embeddedVideoPlayer = signal(kIsWeb);
  final Signal<bool> autoSwitchToVideoPlayerTab = signal(false);
  final Signal<bool> invert = signal(false);
  final Signal<PlayerBackendType> playerBackendType = signal(
    PlayerBackendType.handyStrokerStreamingBluetooth,
  );
  final Signal<bool> funscriptGraphEnabled = signal(false);
  final MapSignal<String, ShortcutBinding> customShortcuts = mapSignal({});

  // Not persisted in the database
  final Signal<double?> intensity = signal(null);
  final Signal<int?> pchipSmoothInterval = signal(null);
  final Signal<Duration> funscriptGraphViewDuration = signal(
    Duration(seconds: 5),
  );
  final Signal<bool> homeDeviceEnabled = signal(false);

  VoidCallback? _saveEffectDispose;

  SettingsModel();

  Future<void> dispose() async {
    _saveEffectDispose?.call();
  }

  Future<void> load() async {
    _saveEffectDispose?.call();
    final settings = await KVStore.get(Settings.key);
    _entity = settings != null ? Settings.fromJson(settings) : Settings();
    min.value = _entity.min;
    max.value = _entity.max;
    offsetMs.value = _entity.offsetMs;
    mediaPaths.value = _entity.mediaPaths;
    slewMaxRateOfChange.value = _entity.slewMaxRateOfChange;
    rdpEpsilon.value = _entity.rdpEpsilon;
    remapFullRange.value = _entity.remapFullRange;
    skipToAction.value = _entity.skipToAction;
    embeddedVideoPlayer.value = _entity.embeddedVideoPlayer || kIsWeb;
    autoSwitchToVideoPlayerTab.value = _entity.autoSwitchToVideoPlayerTab;
    invert.value = _entity.invert;
    playerBackendType.value = _entity.playerBackendType;
    funscriptGraphEnabled.value = _entity.funscriptGraphEnabled;
    customShortcuts.value = _entity.customShortcuts;

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
      _entity.invert = invert.value;
      _entity.playerBackendType = playerBackendType.value;
      _entity.funscriptGraphEnabled = funscriptGraphEnabled.value;
      _entity.customShortcuts = customShortcuts.value;
      await _save();
    });
  }

  Future<void> _save() async {
    _debouncer.run(() => _saveInternal());
  }

  Future<void> _saveInternal() async {
    KVStore.put(Settings.key, _entity.toJson());
  }
}
