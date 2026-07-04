import 'package:flutter/foundation.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/funscript_algo.dart';
import 'package:syncopathy/helper/debouncer.dart';
import 'package:syncopathy/helper/effect_dispose_mixin.dart';
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/model/battery_model.dart';
import 'package:syncopathy/model/funscript.dart';
import 'package:syncopathy/model/json/buttplug_backend_settings.dart';
import 'package:syncopathy/model/json/funscript_json.dart';
import 'package:syncopathy/model/json/handy_native_web_backend_settings.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/model/timesource_model.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';
import 'package:syncopathy/platform/key_value_store/key_value_store.dart';
import 'package:syncopathy/player/buttplug_stroker_backend.dart';
import 'package:syncopathy/player/handy_native_command_backend.dart';
import 'package:syncopathy/player/handy_native_hsp_bt_backend.dart';
import 'package:syncopathy/player/handy_native_hsp_web_backend.dart';
import 'package:syncopathy/player/player_backend.dart';
import 'package:syncopathy/player/player_backend_type.dart';
import 'package:syncopathy/player/video_player.dart';

class MediaFunscript {
  final MediaFile media;
  final Funscript funscript;
  MediaFunscript({required this.media, required this.funscript});
}

class PlayerModel with EffectDispose {
  // A video shorter than this (seconds) is treated as not yet loaded.
  static const double _minValidDurationSeconds = 0.1;
  // Debounce before (re)processing a funscript after settings/media change.
  static const int _processingDebounceMs = 300;
  // A video must play uninterrupted this long before it counts as viewed.
  static const int _viewCountDebounceMs = 5000;

  final SettingsModel _settings;
  final BatteryModel _batteryModel;
  final TimesourceModel timeSource;
  late final Signal<PlayerBackend?> playerBackend;

  final Signal<Funscript?> _currentFunscript = signal(null);

  late final ReadonlySignal<MediaFunscript?> currentlyOpen;

  final Signal<Funscript?> simpleModeFunscript = signal(null);
  final Signal<int> selectedFunscriptIndex = signal(0);

  bool _videoViewCounted = false;
  bool _skipToActionProcessed = false;

  final Debouncer _processingDebouncer = Debouncer(
    milliseconds: _processingDebounceMs,
  );
  final Debouncer _viewCountDebouncer = Debouncer(
    milliseconds: _viewCountDebounceMs,
  );

  PlayerModel(
    this._settings,
    this.timeSource,
    VideoPlayer player,
    this._batteryModel,
  ) {
    playerBackend = signal(null);

    currentlyOpen = computed(() {
      final media = untracked(() => player.currentMedia.value);
      final funscript = _currentFunscript.value;

      if (media != null && funscript != null) {
        return MediaFunscript(media: media, funscript: funscript);
      }
      return null;
    });

    if (syncopathySimpleMode) {
      simpleModeEffects(player);
    } else {
      regularEffects(player);
    }

    effectAdd([
      effect(() {
        final duration = player.duration.value;
        final funscript = currentlyOpen.value?.funscript;

        if (duration == null ||
            duration < _minValidDurationSeconds ||
            funscript == null) {
          return;
        }

        if (_skipToActionProcessed) return;

        // Skip to first stroke if enabled
        untracked(() {
          if (_settings.skipToAction.value) {
            _skipToActionProcessed = true;
            final actions = funscript.originalActions;
            if (actions.isNotEmpty) {
              final startTime = FunscriptAlgorithms.findFirstStroke(actions);
              player.seekTo(Duration(milliseconds: startTime));
            }
          }
        });
      }),
      effect(() {
        final backendType = _settings.playerBackendType.value;
        untracked(() async => await _updateBackend(backendType, _batteryModel));
      }),
    ]);
  }

  void _processFunscript(Funscript funscript, FunscriptProcessParams params) {
    _processingDebouncer.run(() async {
      final modifiedActions = compute(
        FunscriptAlgorithms.processForHandy,
        params,
      );
      funscript.processedActions.value = await modifiedActions;
    }, leading: true);
  }

  /// Reads every processing-relevant setting (plus the current playback speed)
  /// synchronously so the surrounding effect tracks them, and returns a builder
  /// that turns a script's actions + duration into [FunscriptProcessParams].
  /// Shared by the simple- and regular-mode effects, which differ only in where
  /// the funscript comes from.
  FunscriptProcessParams Function(List<FunscriptAction> actions, double duration)
  _snapshotProcessParams(VideoPlayer player) {
    final invert = _settings.invert.value;
    final intensity = _settings.intensity.value;
    final playbackSpeed = player.playbackSpeed.value;
    final strokeRange = _settings.minMaxRange.value;
    final slewMaxRateOfChange = _settings.slewMaxRateOfChange.value;
    final rdpEpsilon = _settings.rdpEpsilon.value;
    final remapFullRange = _settings.remapFullRange.value;
    final smoothIntervalMs = _settings.pchipSmoothInterval.value;

    return (actions, duration) => FunscriptProcessParams(
      actions: actions,
      invert: invert,
      intensity: intensity,
      totalDuration: duration,
      playbackSpeed: playbackSpeed,
      strokeRange: strokeRange,
      slewMaxRateOfChangePerSecond: slewMaxRateOfChange < 0
          ? null
          : slewMaxRateOfChange,
      rdpEpsilon: rdpEpsilon < 0 ? null : rdpEpsilon,
      remapRange: remapFullRange ? (0, 100) : null,
      smoothIntervalMs: smoothIntervalMs,
    );
  }

  void simpleModeEffects(VideoPlayer player) {
    effectAdd([
      effect(() async {
        final media = player.currentMedia.value;
        final funscript = simpleModeFunscript.value;
        final totalDuration = player.duration.value;
        final buildParams = _snapshotProcessParams(player);

        if (media == null ||
            totalDuration == null ||
            totalDuration < _minValidDurationSeconds) {
          _currentFunscript.value = null;
          return;
        }
        try {
          if (funscript?.likelyScriptToken ?? false) {
            Logger.warning("Script token playback is not supported.");
            return;
          }
          if (funscript != null) {
            untracked(() {
              _processFunscript(
                funscript,
                buildParams(funscript.originalActions, totalDuration),
              );
            });
          }
          _currentFunscript.value = funscript;
        } catch (e, st) {
          Logger.error("Failed to process funscript", e, st);
        }
      }),
    ]);
  }

  void regularEffects(VideoPlayer player) {
    effectAdd([
      effect(() async {
        final media = player.currentMedia.value;
        final index = selectedFunscriptIndex.value;
        final totalDuration = player.duration.value;
        final buildParams = _snapshotProcessParams(player);

        final funscriptFile = (media?.funscripts.length ?? 0) > index
            ? media?.funscripts[index]
            : null;

        if (media == null ||
            funscriptFile == null ||
            totalDuration == null ||
            totalDuration < _minValidDurationSeconds) {
          _currentFunscript.value = null;
          return;
        }
        try {
          Funscript? funscript;
          final currentFunscript = untracked(() => _currentFunscript.value);
          if (currentFunscript == null ||
              (currentFunscript.filePath != funscriptFile.path)) {
            funscript = await Funscript.fromFile(funscriptFile.path);
          } else {
            funscript = currentFunscript;
          }

          if (funscript?.likelyScriptToken ?? false) {
            Logger.warning("Script token playback is not supported.");
            return;
          }
          untracked(() {
            if (funscript != null) {
              _processFunscript(
                funscript,
                buildParams(funscript.originalActions, totalDuration),
              );
            }
          });
          _currentFunscript.value = funscript;
        } catch (e, st) {
          Logger.error("Failed to process funscript", e, st);
        }
      }),
      // View counting logic
      effect(() {
        final media = player.currentMedia.value;
        _videoViewCounted = false;

        // Initialize the index with the mainFunscript
        if (media != null) {
          final mainFsId = media.mainFunscript.targetId;
          final index = media.funscripts.indexWhere((fs) => fs.id == mainFsId);
          selectedFunscriptIndex.value = index != -1 ? index : 0;
        } else {
          selectedFunscriptIndex.value = 0;
        }

        _skipToActionProcessed = false;
      }),
      effect(() {
        final video = currentlyOpen.value?.media;
        final playing = !player.paused.value;
        untracked(() {
          if (video != null && playing && !_videoViewCounted) {
            _viewCountDebouncer.run(() {
              final moreCurrentVideo = currentlyOpen.value?.media;
              if (!player.paused.value) {
                if (moreCurrentVideo == video && !_videoViewCounted) {
                  // Count the view
                  _videoViewCounted = true;
                  oBox.mediaRepository.incrementPlayCount(video);
                }
              }
            });
          }
        });
      }),
      // View counting logic end
    ]);
  }

  bool _backendMatchesType(PlayerBackendType type) {
    final backend = playerBackend.value;
    return switch (type) {
      PlayerBackendType.buttplugStrokerCommand =>
        backend is ButtplugStrokerBackend,
      PlayerBackendType.handyStrokerCommand =>
        backend is HandyNativeCommandBackend,
      PlayerBackendType.handyStrokerStreamingBluetooth =>
        backend is HandyNativeHspBluetoothBackend,
      PlayerBackendType.handyStrokerStreamingWeb =>
        backend is HandyNativeHspWebBackend,
    };
  }

  Future<PlayerBackend> _createBackend(
    PlayerBackendType backendType,
    BatteryModel batteryModel,
  ) async {
    switch (backendType) {
      case PlayerBackendType.buttplugStrokerCommand:
        final settings = await KVStore.get(ButtplugBackendSettings.key);
        return ButtplugStrokerBackend(
          timesource: timeSource,
          currentlyOpen: currentlyOpen,
          settingsModel: _settings,
          settings: settings != null
              ? ButtplugBackendSettings.fromJson(settings)
              : ButtplugBackendSettings(),
          batteryModel: batteryModel,
        );
      case PlayerBackendType.handyStrokerCommand:
        return HandyNativeCommandBackend(
          settingsModel: _settings,
          batteryModel: batteryModel,
          timesource: timeSource,
          currentlyOpen: currentlyOpen,
        );
      case PlayerBackendType.handyStrokerStreamingBluetooth:
        return HandyNativeHspBluetoothBackend(
          currentlyOpen: currentlyOpen,
          timesource: timeSource,
          settingsModel: _settings,
          batteryModel: batteryModel,
        );
      case PlayerBackendType.handyStrokerStreamingWeb:
        final settings = await KVStore.get(HandyNativeWebBackendSettings.key);
        return HandyNativeHspWebBackend(
          webSettings: settings != null
              ? HandyNativeWebBackendSettings.fromJson(settings)
              : HandyNativeWebBackendSettings(),
          currentlyOpen: currentlyOpen,
          timesource: timeSource,
          settingsModel: _settings,
          batteryModel: batteryModel,
        );
    }
  }

  Future<void> _updateBackend(
    PlayerBackendType backendType,
    BatteryModel batteryModel,
  ) async {
    // Already running the requested backend type — nothing to swap.
    if (_backendMatchesType(backendType)) return;

    final newBackend = await _createBackend(backendType, batteryModel);
    await playerBackend.value?.dispose();
    playerBackend.value = newBackend;
  }

  void dispose() {
    effectDispose();
  }

  void disconnectBackend() async {
    await playerBackend.value?.dispose();
    playerBackend.value = null;
    await _updateBackend(_settings.playerBackendType.value, _batteryModel);
  }

  void connectBackend() async {
    await playerBackend.value?.dispose();
    playerBackend.value = null;
    await _updateBackend(_settings.playerBackendType.value, _batteryModel);
    // Backends surface their own connection failures; this guard is a
    // backstop so a stray throw can't become an unhandled async error.
    try {
      await playerBackend.value?.tryConnect();
    } catch (e, st) {
      Logger.error("Backend connect failed", e, st);
    }
  }
}
