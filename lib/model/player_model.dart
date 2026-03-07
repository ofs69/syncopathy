import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/events/event_subscriber_mixin.dart';
import 'package:syncopathy/funscript_algo.dart';
import 'package:syncopathy/helper/debouncer.dart';
import 'package:syncopathy/helper/effect_dispose_mixin.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/model/battery_model.dart';
import 'package:syncopathy/model/funscript.dart';
import 'package:syncopathy/model/json/buttplug_backend_settings.dart';
import 'package:syncopathy/model/json/handy_native_web_backend_settings.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/model/timesource_model.dart';
import 'package:syncopathy/player/buttplug_stroker_backend.dart';
import 'package:syncopathy/player/handy_native_command_backend.dart';
import 'package:syncopathy/player/handy_native_hsp_bt_backend.dart';
import 'package:syncopathy/player/handy_native_hsp_web_backend.dart';
import 'package:syncopathy/player/media_kit_player.dart';
import 'package:syncopathy/player/player_backend.dart';
import 'package:syncopathy/player/player_backend_type.dart';
import 'package:syncopathy/sqlite/database_helper.dart';
import 'package:syncopathy/sqlite/key_value_store.dart';

import 'package:syncopathy/sqlite/models/video_model.dart';

class MediaFunscript {
  final Video media;
  final Funscript funscript;
  MediaFunscript({required this.media, required this.funscript});
}

class PlayerModel with EventSubscriber, EffectDispose {
  final SettingsModel _settings;
  final BatteryModel _batteryModel;
  final TimesourceModel timeSource;
  late final Signal<PlayerBackend?> playerBackend;

  ReadonlySignal<Funscript?> get _currentFunscript => __currentFunscript;
  final Signal<Funscript?> __currentFunscript = signal(null);

  late final ReadonlySignal<MediaFunscript?> currentlyOpen;

  bool _videoViewCounted = false;

  PlayerModel(
    this._settings,
    this.timeSource,
    MediaKitPlayer player,
    this._batteryModel,
  ) {
    playerBackend = signal(null);
    // _currentFunscript = computed(() {
    //   final video = player.currentVideo.value;
    //   final totalDuration = player.duration.value;
    //   final slewMaxRateOfChange = _settings.slewMaxRateOfChange.value;
    //   final rdpEpsilon = _settings.rdpEpsilon.value;
    //   final remapFullRange = _settings.remapFullRange.value;
    //   final invert = _settings.invert.value;

    //   if (totalDuration == null || totalDuration < 0.1) return video?.funscript;

    //   try {
    //     if (video != null) {
    //       if (video.funscript == null) {
    //         video.loadFunscript();
    //       }

    //       final funscript = video.funscript;
    //       if (funscript?.likelyScriptToken ?? false) {
    //         Logger.warning("Script token playback is not supported.");
    //         return null;
    //       }
    //       if (funscript != null) {
    //         untracked(() {
    //           final modifiedActions = FunscriptAlgorithms.processForHandy(
    //             funscript.originalActions,
    //             slewMaxRateOfChange,
    //             rdpEpsilon,
    //             remapFullRange ? (0, 100) : null,
    //             invert,
    //             totalDuration,
    //           );
    //           funscript.processedActions.value = modifiedActions;
    //         });
    //       }

    //       return funscript;
    //     }
    //   } catch (_) {}
    //   return null;
    // });

    currentlyOpen = computed(() {
      final video = untracked(() => player.currentVideo.value);
      final funscript = _currentFunscript.value;

      if (video != null && funscript != null) {
        return MediaFunscript(media: video, funscript: funscript);
      }
      return null;
    });

    effectAdd([
      // View counting logic
      effect(() {
        final _ = player.currentVideo.value;
        _videoViewCounted = false;
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
                  DatabaseHelper().updateVideo(video);
                }
              }
            });
          }
        });
      }),
      // View counting logic end
      effect(() async {
        final video = player.currentVideo.value;
        final totalDuration = player.duration.value;
        final slewMaxRateOfChange = _settings.slewMaxRateOfChange.value;
        final rdpEpsilon = _settings.rdpEpsilon.value;
        final remapFullRange = _settings.remapFullRange.value;
        final invert = _settings.invert.value;
        if (totalDuration == null || totalDuration < 0.1) {
          return null;
        }
        try {
          if (video != null) {
            if (video.funscript == null) {
              await video.loadFunscript();
            }
            final funscript = video.funscript;
            if (funscript?.likelyScriptToken ?? false) {
              Logger.warning("Script token playback is not supported.");
              return null;
            }
            if (funscript != null) {
              untracked(() {
                final modifiedActions = FunscriptAlgorithms.processForHandy(
                  funscript.originalActions,
                  slewMaxRateOfChange,
                  rdpEpsilon,
                  remapFullRange ? (0, 100) : null,
                  invert,
                  totalDuration,
                );
                funscript.processedActions.value = modifiedActions;
              });
            }
            __currentFunscript.value = funscript;
          }
        } catch (_) {}
      }),
      effect(() {
        final duration = player.duration.value;
        //final video = untracked(() => player.currentVideo.value);
        final funscript = currentlyOpen.value?.funscript;

        if (duration == null || duration < 0.1 || funscript == null) {
          return;
        }

        // Skip to first stroke if enabled
        untracked(() {
          if (_settings.skipToAction.value) {
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

  Future<void> _updateBackend(
    PlayerBackendType backendType,
    BatteryModel batteryModel,
  ) async {
    PlayerBackend? newBackend;
    switch (backendType) {
      case PlayerBackendType.buttplugStrokerCommand:
        if (playerBackend.value is! ButtplugStrokerBackend) {
          final settings = await KeyValueStore.get(ButtplugBackendSettings.key);

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
          final settings = await KeyValueStore.get(
            HandyNativeWebBackendSettings.key,
          );
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
    eventDispose();
    effectDispose();
  }

  void disconnectBackend() {
    playerBackend.value?.dispose();
    playerBackend.value = null; // this should cause the backend to recreated
  }

  void connectBackend() async {
    await playerBackend.value?.dispose();
    playerBackend.value = null;
    await _updateBackend(_settings.playerBackendType.value, _batteryModel);
    await playerBackend.value?.tryConnect();
  }
}
