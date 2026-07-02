import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/helper/debouncer.dart';
import 'package:syncopathy/helper/entity_binding.dart';
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

  /// The single source of truth for which fields persist: each binding copies
  /// one setting out of [_entity] on load and back into it on save. Adding a
  /// persisted setting means declaring its signal and adding one line here —
  /// there is no third copy site to keep in sync. Signals absent from this list
  /// are intentionally not persisted.
  late final List<EntityBinding> _bindings = [
    EntityBinding(() => min.value = _entity.min, () => _entity.min = min.value),
    EntityBinding(() => max.value = _entity.max, () => _entity.max = max.value),
    EntityBinding(
      () => offsetMs.value = _entity.offsetMs,
      () => _entity.offsetMs = offsetMs.value,
    ),
    EntityBinding(
      () => mediaPaths.value = _entity.mediaPaths,
      () => _entity.mediaPaths = mediaPaths.value,
    ),
    EntityBinding(
      () => slewMaxRateOfChange.value = _entity.slewMaxRateOfChange,
      () => _entity.slewMaxRateOfChange = slewMaxRateOfChange.value,
    ),
    EntityBinding(
      () => rdpEpsilon.value = _entity.rdpEpsilon,
      () => _entity.rdpEpsilon = rdpEpsilon.value,
    ),
    EntityBinding(
      () => remapFullRange.value = _entity.remapFullRange,
      () => _entity.remapFullRange = remapFullRange.value,
    ),
    EntityBinding(
      () => skipToAction.value = _entity.skipToAction,
      () => _entity.skipToAction = skipToAction.value,
    ),
    EntityBinding(
      () => embeddedVideoPlayer.value = _entity.embeddedVideoPlayer || kIsWeb,
      () => _entity.embeddedVideoPlayer = embeddedVideoPlayer.value,
    ),
    EntityBinding(
      () => autoSwitchToVideoPlayerTab.value = _entity.autoSwitchToVideoPlayerTab,
      () => _entity.autoSwitchToVideoPlayerTab = autoSwitchToVideoPlayerTab.value,
    ),
    EntityBinding(
      () => invert.value = _entity.invert,
      () => _entity.invert = invert.value,
    ),
    EntityBinding(
      () => playerBackendType.value = _entity.playerBackendType,
      () => _entity.playerBackendType = playerBackendType.value,
    ),
    EntityBinding(
      () => funscriptGraphEnabled.value = _entity.funscriptGraphEnabled,
      () => _entity.funscriptGraphEnabled = funscriptGraphEnabled.value,
    ),
    EntityBinding(
      () => customShortcuts.value = _entity.customShortcuts,
      () => _entity.customShortcuts = customShortcuts.value,
    ),
  ];

  SettingsModel();

  Future<void> dispose() async {
    _saveEffectDispose?.call();
  }

  Future<void> load() async {
    _saveEffectDispose?.call();
    final settings = await KVStore.get(Settings.key);
    _entity = settings != null ? Settings.fromJson(settings) : Settings();

    for (final binding in _bindings) {
      binding.loadFromEntity();
    }

    _saveEffectDispose = effect(() async {
      for (final binding in _bindings) {
        binding.saveToEntity();
      }
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
