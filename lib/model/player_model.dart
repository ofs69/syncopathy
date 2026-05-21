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
  final SettingsModel _settings;
  final BatteryModel _batteryModel;
  final TimesourceModel timeSource;
  late final Signal<PlayerBackend?> playerBackend;

  ReadonlySignal<Funscript?> get _currentFunscript => __currentFunscript;
  final Signal<Funscript?> __currentFunscript = signal(null);

  late final ReadonlySignal<MediaFunscript?> currentlyOpen;

  final Signal<Funscript?> simpleModeFunscript = signal(null);
  final Signal<int> selectedFunscriptIndex = signal(0);

  bool _videoViewCounted = false;
  bool _skipToActionProcessed = false;

  final Debouncer _processingDebouncer = Debouncer(milliseconds: 300);

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

        if (duration == null || duration < 0.1 || funscript == null) {
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

  void simpleModeEffects(VideoPlayer player) {
    effectAdd([
      effect(() async {
        final media = player.currentMedia.value;
        final funscript = simpleModeFunscript.value;
        final totalDuration = player.duration.value;
        final slewMaxRateOfChange = _settings.slewMaxRateOfChange.value;
        final rdpEpsilon = _settings.rdpEpsilon.value;
        final remapFullRange = _settings.remapFullRange.value;
        final invert = _settings.invert.value;
        final playbackSpeed = player.playbackSpeed.value;
        final strokeRange = _settings.minMaxRange.value;
        final smoothIntervalMs = _settings.catmullRomSplineSmoothInterval.value;

        if (media == null || totalDuration == null || totalDuration < 0.1) {
          __currentFunscript.value = null;
          return null;
        }
        try {
          if (funscript?.likelyScriptToken ?? false) {
            Logger.warning("Script token playback is not supported.");
            return null;
          }
          if (funscript != null) {
            untracked(() {
              _processFunscript(
                funscript,
                FunscriptProcessParams(
                  actions: funscript.originalActions,
                  invert: invert,
                  totalDuration: totalDuration,
                  playbackSpeed: playbackSpeed,
                  strokeRange: strokeRange,
                  slewMaxRateOfChangePerSecond: slewMaxRateOfChange,
                  rdpEpsilon: rdpEpsilon,
                  remapRange: remapFullRange ? (0, 100) : null,
                  smoothIntervalMs: smoothIntervalMs,
                ),
              );
            });
          }
          __currentFunscript.value = funscript;
        } catch (_) {}
      }),
    ]);
  }

  void regularEffects(VideoPlayer player) {
    effectAdd([
      effect(() async {
        final media = player.currentMedia.value;
        final index = selectedFunscriptIndex.value;
        final totalDuration = player.duration.value;
        final slewMaxRateOfChange = _settings.slewMaxRateOfChange.value;
        final rdpEpsilon = _settings.rdpEpsilon.value;
        final remapFullRange = _settings.remapFullRange.value;
        final invert = _settings.invert.value;
        final playbackSpeed = player.playbackSpeed.value;
        final strokeRange = _settings.minMaxRange.value;
        final smoothIntervalMs = _settings.catmullRomSplineSmoothInterval.value;

        final funscriptFile = (media?.funscripts.length ?? 0) > index
            ? media?.funscripts[index]
            : null;

        if (media == null ||
            funscriptFile == null ||
            totalDuration == null ||
            totalDuration < 0.1) {
          __currentFunscript.value = null;
          return null;
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
            return null;
          }
          untracked(() {
            if (funscript != null) {
              _processFunscript(
                funscript,
                FunscriptProcessParams(
                  actions: funscript.originalActions,
                  invert: invert,
                  totalDuration: totalDuration,
                  playbackSpeed: playbackSpeed,
                  strokeRange: strokeRange,
                  slewMaxRateOfChangePerSecond: slewMaxRateOfChange,
                  rdpEpsilon: rdpEpsilon,
                  remapRange: remapFullRange ? (0, 100) : null,
                  smoothIntervalMs: smoothIntervalMs,
                ),
              );
            }
          });
          __currentFunscript.value = funscript;
        } catch (_) {}
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
            final viewCounter = Debouncer(milliseconds: 5000);
            viewCounter.run(() {
              final moreCurrentVideo = currentlyOpen.value?.media;
              if (!player.paused.value) {
                if (moreCurrentVideo == video && !_videoViewCounted) {
                  // Count the view
                  _videoViewCounted = true;
                  video.playCount += 1;
                  oBox.mediaService.save(video);
                }
              }
            });
          }
        });
      }),
      // View counting logic end
    ]);
  }

  Future<void> _updateBackend(
    PlayerBackendType backendType,
    BatteryModel batteryModel,
  ) async {
    PlayerBackend? newBackend;
    switch (backendType) {
      case PlayerBackendType.buttplugStrokerCommand:
        if (playerBackend.value is! ButtplugStrokerBackend) {
          final settings = await KVStore.get(ButtplugBackendSettings.key);

          newBackend = ButtplugStrokerBackend(
            timesource: timeSource,
            currentlyOpen: currentlyOpen,
            settingsModel: _settings,
            settings: settings != null
                ? ButtplugBackendSettings.fromJson(settings)
                : ButtplugBackendSettings(),
            batteryModel: batteryModel,
          );
        }
        break;
      case PlayerBackendType.handyStrokerCommand:
        if (playerBackend.value is! HandyNativeCommandBackend) {
          newBackend = HandyNativeCommandBackend(
            settingsModel: _settings,
            batteryModel: batteryModel,
            timesource: timeSource,
            currentlyOpen: currentlyOpen,
          );
        }
        break;
      case PlayerBackendType.handyStrokerStreamingBluetooth:
        if (playerBackend.value is! HandyNativeHspBluetoothBackend) {
          newBackend = HandyNativeHspBluetoothBackend(
            currentlyOpen: currentlyOpen,
            timesource: timeSource,
            settingsModel: _settings,
            batteryModel: batteryModel,
          );
        }
        break;
      case PlayerBackendType.handyStrokerStreamingWeb:
        if (playerBackend.value is! HandyNativeHspWebBackend) {
          final settings = await KVStore.get(HandyNativeWebBackendSettings.key);
          newBackend = HandyNativeHspWebBackend(
            webSettings: settings != null
                ? HandyNativeWebBackendSettings.fromJson(settings)
                : HandyNativeWebBackendSettings(),
            currentlyOpen: currentlyOpen,
            timesource: timeSource,
            settingsModel: _settings,
            batteryModel: batteryModel,
          );
        }
        break;
    }
    if (newBackend != null) {
      await playerBackend.value?.dispose();
      playerBackend.value = newBackend;
    }
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
    await playerBackend.value?.tryConnect();
  }
}
