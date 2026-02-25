import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/events/event_bus.dart';
import 'package:syncopathy/events/event_subscriber_mixin.dart';
import 'package:syncopathy/events/player_event.dart';
import 'package:syncopathy/funscript_algo.dart';
import 'package:syncopathy/helper/debouncer.dart';
import 'package:syncopathy/helper/effect_dispose_mixin.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/model/battery_model.dart';
import 'package:syncopathy/model/funscript.dart';
import 'package:syncopathy/model/json/buttplug_stroker_backend_settings.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/model/timesource_model.dart';
import 'package:syncopathy/player/buttplug_stroker_backend.dart';
import 'package:syncopathy/player/handy_native_command_backend.dart';
import 'package:syncopathy/player/handy_native_hsp_backend.dart';
import 'package:syncopathy/player/media_kit_player.dart';
import 'package:syncopathy/player/player_backend.dart';
import 'package:syncopathy/player/player_backend_type.dart';
import 'package:syncopathy/sqlite/database_helper.dart';
import 'package:syncopathy/sqlite/key_value_store.dart';

import 'package:syncopathy/sqlite/models/video_model.dart';

class PlayerModel with EventSubscriber, EffectDispose {
  final SettingsModel _settings;
  final TimesourceModel timeSource;
  late final Signal<PlayerBackend?> playerBackend;

  late final ReadonlySignal<Video?> currentVideo;
  late final AsyncSignal<Funscript?> _asyncCurrentFunscript = computedAsync(
    () async {
      final video = currentVideo.value;
      try {
        if (video != null) {
          if (video.funscript == null) await video.loadFunscript();
          if (video.funscript?.likelyScriptToken ?? false) {
            Logger.warning("Script token playback is not supported.");
            return null;
          }
          return video.funscript;
        }
      } finally {
        // if (video?.funscript == null) {
        //   Events.emit(CloseMediaEvent());
        // }
      }
      return null;
    },
  );
  late final ReadonlySignal<Funscript?> currentFunscript = computed(
    () => _asyncCurrentFunscript.value.value,
  );

  bool _videoViewCounted = false;

  PlayerModel(
    this._settings,
    this.timeSource,
    MediaKitPlayer player,
    BatteryModel batteryModel,
  ) {
    playerBackend = signal(null);
    currentVideo = player.currentVideo;

    effectAdd([
      // View counting logic
      effect(() {
        final _ = currentVideo.value;
        _videoViewCounted = false;
      }),
      effect(() {
        final video = currentVideo.value;
        final playing = !player.paused.value;
        if (video != null && playing && !_videoViewCounted) {
          final viewCounter = Debouncer(milliseconds: 5000);
          viewCounter.run(() {
            final moreCurrentVideo = untracked(() => currentVideo.value);
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
      }),
      // View counting logic end
      effect(() {
        final funscript = currentFunscript.value;
        final duration = player.duration.value;
        // Skip to first stroke if enabled
        if (untracked(() => _settings.skipToAction.value)) {
          if (funscript != null && duration > 0.0) {
            final startTime = FunscriptAlgorithms.findFirstStroke(
              untracked(() => funscript.actions.value),
            );
            player.seekTo(Duration(milliseconds: startTime));
          }
        }
      }),
      effect(() async {
        PlayerBackend? newBackend;
        switch (_settings.playerBackendType.value) {
          case PlayerBackendType.buttplugStrokerCommand:
            if (playerBackend.value is! ButtplugStrokerBackend) {
              final settings = await KeyValueStore.get(
                ButtplugStrokerBackendSettings.key,
              );

              newBackend = ButtplugStrokerBackend(
                timesource: timeSource,
                currentFunscript: currentFunscript,
                settingsModel: _settings,
                settings: settings != null
                    ? ButtplugStrokerBackendSettings.fromJson(settings)
                    : ButtplugStrokerBackendSettings(),
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
                currentFunscript: currentFunscript,
              );
            }
            break;
          case PlayerBackendType.handyStrokerStreamingBluetooth:
            if (playerBackend.value is! HandyNativeHspBackend) {
              newBackend = HandyNativeHspBackend(
                currentFunscript: currentFunscript,
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
      }),
      effect(() {
        final funscript = currentFunscript.value;
        if (funscript == null) return;
        final modifiedActions = FunscriptAlgorithms.processForHandy(
          funscript.originalActions,
          _settings.slewMaxRateOfChange.value,
          _settings.rdpEpsilon.value,
          _settings.remapFullRange.value ? (0, 100) : null,
          _settings.invert.value,
        );
        funscript.actions.value = modifiedActions;
      }),
    ]);
  }

  void dispose() {
    eventDispose();
    effectDispose();
  }
}
