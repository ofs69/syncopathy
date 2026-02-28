import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/helper/debouncer.dart';
import 'package:syncopathy/player/player_backend_type.dart';
import 'package:syncopathy/model/json/settings.dart';
import 'package:syncopathy/web_key_value_store.dart';

class SettingsModel {
  late final Settings _entity;
  final _debouncer = Debouncer(milliseconds: 500);

  final Signal<int> min = signal(0);
  final Signal<int> max = signal(100);
  late final minMaxRange = computed(
    () => RangeValues(min.value.toDouble(), max.value.toDouble()),
  );
  final Signal<int> offsetMs = signal(0);
  final Signal<double?> slewMaxRateOfChange = signal(null);
  final Signal<double?> rdpEpsilon = signal(null);
  final Signal<bool> remapFullRange = signal(false);
  final Signal<bool> skipToAction = signal(false);
  final Signal<bool> invert = signal(false);
  final Signal<PlayerBackendType> playerBackendType = signal(
    PlayerBackendType.handyStrokerStreamingBluetooth,
  );
  final Signal<int> dismissedStartModal = signal(0);

  // Not persisted in the database
  Signal<bool> showDebugNotifications = signal(kDebugMode);
  Signal<Duration> funscriptGraphViewDuration = signal(Duration(seconds: 5));
  Signal<bool> homeDeviceEnabled = signal(false);

  late final Function? _saveEffectDispose;

  SettingsModel();

  Future<void> dispose() async {
    _saveEffectDispose?.call();
  }

  Future<void> load() async {
    final settings = await KeyValueStore.get(Settings.key);
    _entity = settings != null ? Settings.fromJson(settings) : Settings();
    min.value = _entity.min;
    max.value = _entity.max;
    offsetMs.value = _entity.offsetMs;
    slewMaxRateOfChange.value = _entity.slewMaxRateOfChange;
    rdpEpsilon.value = _entity.rdpEpsilon;
    remapFullRange.value = _entity.remapFullRange;
    skipToAction.value = _entity.skipToAction;
    invert.value = _entity.invert;
    playerBackendType.value = _entity.playerBackendType;
    dismissedStartModal.value = _entity.dismissedStartModal;

    _saveEffectDispose = effect(() async {
      _entity.min = min.value;
      _entity.max = max.value;
      _entity.offsetMs = offsetMs.value;
      _entity.slewMaxRateOfChange = slewMaxRateOfChange.value;
      _entity.rdpEpsilon = rdpEpsilon.value;
      _entity.remapFullRange = remapFullRange.value;
      _entity.skipToAction = skipToAction.value;
      _entity.invert = invert.value;
      _entity.playerBackendType = playerBackendType.value;
      _entity.dismissedStartModal = dismissedStartModal.value;
      await _save();
    });
  }

  Future<void> _save() async {
    _debouncer.run(() => _saveInternal());
  }

  Future<void> _saveInternal() async {
    KeyValueStore.put(Settings.key, _entity.toJson());
  }
}
