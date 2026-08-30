import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/helper/debouncer.dart';
import 'package:syncopathy/helper/entity_binding.dart';
import 'package:syncopathy/heresphere/heresphere_mode.dart';
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/platform/key_value_store/key_value_store.dart';
import 'package:syncopathy/player/hwdec_mode.dart';
import 'package:syncopathy/player/player_backend_type.dart';
import 'package:syncopathy/model/home_target.dart';
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

  /// Whether a lost Bluetooth connection is re-established without asking.
  /// Off by default: reconnecting means scanning again, which takes the device
  /// over without the user having asked for it.
  final Signal<bool> autoReconnect = signal(false);

  /// Whether pausing playback parks the device and resuming releases it.
  /// Off by default: it takes the device over on every pause, which is a
  /// surprise unless the user asked for it.
  final Signal<bool> autoHomeOnPause = signal(false);

  /// How long the device takes to travel to the parked position, in
  /// milliseconds. Persisted, unlike the rest of Home Mode's state, because it
  /// describes the device rather than the current session.
  final Signal<int> homeMoveDurationMs = signal(
    HomeTarget.defaultMoveDurationMs,
  );
  final Signal<HwdecMode> hwdecMode = signal(HwdecMode.autoCopy);
  final MapSignal<String, ShortcutBinding> customShortcuts = mapSignal({});

  /// Experimental: serve the media library to HereSphere over the local
  /// network. Off by default — enabling it exposes the indexed library to
  /// whoever can reach the port.
  final Signal<bool> hereSphereEnabled = signal(false);
  final Signal<int> hereSpherePort = signal(9678);
  final Signal<String> hereSphereBindAddress = signal('0.0.0.0');

  /// Which application commands the device while HereSphere plays the video.
  /// Only one may, so this is a choice rather than a pair of toggles.
  final Signal<HereSphereDeviceOwner> hereSphereDeviceOwner = signal(
    HereSphereDeviceOwner.syncopathy,
  );

  /// Whether the timestamp channel's address is taken from the player that
  /// connected to the media server, rather than typed in.
  final Signal<bool> hereSphereTimestampAutoDetect = signal(true);

  /// Where to reach HereSphere's DeoVR-compatible timestamp server, which
  /// supplies the periodic clock correction and the heartbeat. Consulted only
  /// when [hereSphereTimestampAutoDetect] is off.
  final Signal<String> hereSphereTimestampHost = signal('127.0.0.1');
  final Signal<int> hereSphereTimestampPort = signal(23554);

  /// Whether Syncopathy may command HereSphere over the timestamp channel —
  /// seek, play/pause, change speed. Off by default: observing a player and
  /// steering it are different permissions, and only this one reaches out.
  final Signal<bool> hereSphereAllowRemoteControl = signal(false);

  /// Whether to draw the media library's badges and a funscript heatmap over
  /// the thumbnails HereSphere shows.
  final Signal<bool> hereSphereDecorateThumbnails = signal(true);

  /// The login HereSphere must present.
  ///
  /// The password is held only as a salted PBKDF2 hash, so it can be checked
  /// but never read back or displayed. An empty hash means no password is set,
  /// which leaves the server refusing everyone rather than admitting everyone.
  final Signal<String> hereSphereUsername = signal('syncopathy');
  final Signal<String> hereSpherePasswordHash = signal('');

  /// Whether a usable login exists. The server is unreachable without one.
  late final ReadonlySignal<bool> hereSphereHasPassword = computed(
    () => hereSpherePasswordHash.value.isNotEmpty,
  );

  /// The `hwdec` value actually handed to mpv. A `--hwdec=` command line
  /// argument wins over the stored setting, so a user can diagnose a driver
  /// problem without first having to reach a working video player.
  late final ReadonlySignal<String> effectiveHwdec = computed(
    () => hwdecOverride ?? hwdecMode.value.mpvValue,
  );

  // Not persisted in the database
  final Signal<double?> intensity = signal(null);
  final Signal<int?> pchipSmoothInterval = signal(null);
  final Signal<Duration> funscriptGraphViewDuration = signal(
    Duration(seconds: 5),
  );
  final Signal<bool> homeDeviceEnabled = signal(false);

  /// Which end of the stroke Home Mode parks at. Session-only, like
  /// [homeDeviceEnabled] itself — a fresh start comes up at [HomeTarget.low].
  final Signal<HomeTarget> homeTarget = signal(HomeTarget.low);

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
      () =>
          autoSwitchToVideoPlayerTab.value = _entity.autoSwitchToVideoPlayerTab,
      () =>
          _entity.autoSwitchToVideoPlayerTab = autoSwitchToVideoPlayerTab.value,
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
      () => autoReconnect.value = _entity.autoReconnect,
      () => _entity.autoReconnect = autoReconnect.value,
    ),
    EntityBinding(
      () => autoHomeOnPause.value = _entity.autoHomeOnPause,
      () => _entity.autoHomeOnPause = autoHomeOnPause.value,
    ),
    EntityBinding(
      () => homeMoveDurationMs.value = _entity.homeMoveDurationMs.clamp(
        HomeTarget.minMoveDurationMs,
        HomeTarget.maxMoveDurationMs,
      ),
      () => _entity.homeMoveDurationMs = homeMoveDurationMs.value,
    ),
    EntityBinding(
      () => funscriptGraphEnabled.value = _entity.funscriptGraphEnabled,
      () => _entity.funscriptGraphEnabled = funscriptGraphEnabled.value,
    ),
    EntityBinding(
      () => hwdecMode.value = _entity.hwdecMode,
      () => _entity.hwdecMode = hwdecMode.value,
    ),
    EntityBinding(
      () => customShortcuts.value = _entity.customShortcuts,
      () => _entity.customShortcuts = customShortcuts.value,
    ),
    EntityBinding(
      () => hereSphereEnabled.value = _entity.hereSphereEnabled,
      () => _entity.hereSphereEnabled = hereSphereEnabled.value,
    ),
    EntityBinding(
      () => hereSpherePort.value = _entity.hereSpherePort,
      () => _entity.hereSpherePort = hereSpherePort.value,
    ),
    EntityBinding(
      () => hereSphereBindAddress.value = _entity.hereSphereBindAddress,
      () => _entity.hereSphereBindAddress = hereSphereBindAddress.value,
    ),
    EntityBinding(
      () => hereSphereDeviceOwner.value = _entity.hereSphereDeviceOwner,
      () => _entity.hereSphereDeviceOwner = hereSphereDeviceOwner.value,
    ),
    EntityBinding(
      () => hereSphereTimestampAutoDetect.value =
          _entity.hereSphereTimestampAutoDetect,
      () => _entity.hereSphereTimestampAutoDetect =
          hereSphereTimestampAutoDetect.value,
    ),
    EntityBinding(
      () => hereSphereTimestampHost.value = _entity.hereSphereTimestampHost,
      () => _entity.hereSphereTimestampHost = hereSphereTimestampHost.value,
    ),
    EntityBinding(
      () => hereSphereTimestampPort.value = _entity.hereSphereTimestampPort,
      () => _entity.hereSphereTimestampPort = hereSphereTimestampPort.value,
    ),
    EntityBinding(
      () => hereSphereAllowRemoteControl.value =
          _entity.hereSphereAllowRemoteControl,
      () => _entity.hereSphereAllowRemoteControl =
          hereSphereAllowRemoteControl.value,
    ),
    EntityBinding(
      () => hereSphereDecorateThumbnails.value =
          _entity.hereSphereDecorateThumbnails,
      () => _entity.hereSphereDecorateThumbnails =
          hereSphereDecorateThumbnails.value,
    ),
    EntityBinding(
      () => hereSphereUsername.value = _entity.hereSphereUsername,
      () => _entity.hereSphereUsername = hereSphereUsername.value,
    ),
    EntityBinding(
      () => hereSpherePasswordHash.value = _entity.hereSpherePasswordHash,
      () => _entity.hereSpherePasswordHash = hereSpherePasswordHash.value,
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
