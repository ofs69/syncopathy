import 'dart:convert';

import 'package:path/path.dart' as p;
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/events/event_bus.dart';
import 'package:syncopathy/events/event_subscriber_mixin.dart';
import 'package:syncopathy/events/player_event.dart';
import 'package:syncopathy/funscript_algo.dart';
import 'package:syncopathy/helper/effect_dispose_mixin.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/model/battery_model.dart';
import 'package:syncopathy/model/funscript.dart';
import 'package:syncopathy/model/json/buttplug_stroker_backend_settings.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/model/timesource_model.dart';
import 'package:syncopathy/model/video.dart';
import 'package:syncopathy/player/buttplug_stroker_backend.dart';
import 'package:syncopathy/player/handy_native_command_backend.dart';
import 'package:syncopathy/player/handy_native_hsp_backend.dart';
import 'package:syncopathy/player/media_kit_player.dart';
import 'package:syncopathy/player/player_backend.dart';
import 'package:syncopathy/player/player_backend_type.dart';
import 'package:syncopathy/web_key_value_store.dart';
import 'package:web/web.dart' as web;

class PlayerModel with EventSubscriber, EffectDispose {
  final SettingsModel _settings;
  final TimesourceModel timeSource;
  late final Signal<PlayerBackend?> playerBackend;

  late final ReadonlySignal<Video?> currentVideo;
  late final Signal<Funscript?> currentFunscript = signal(null);

  PlayerModel(
    this._settings,
    this.timeSource,
    MediaKitPlayer player,
    BatteryModel batteryModel,
  ) {
    playerBackend = signal(null);
    currentVideo = player.currentVideo;

    effectAdd([
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

  Future<void> openFile(
    String name,
    String path,
    String? mimeType,
    Future<String> Function() readAsString,
  ) async {
    final ext = p.extension(name).toLowerCase();
    if (ext == ".funscript") {
      final funscriptJson = await readAsString();
      final funscriptMap = jsonDecode(funscriptJson);
      final funscript = Funscript.fromJson(funscriptMap, path);
      currentFunscript.value = funscript;
    } else {
      if (mimeType != null && !_canPlayVideo(mimeType)) {
        Logger.error("Can't play $name");
      } else {
        Events.emit(OpenVideoEvent(Video(title: name, url: path)));
      }
    }
  }

  // ignore: unused_element
  bool _canPlayVideo(String mimeType) {
    // Create a dummy video element in memory
    final video = web.document.createElement('video') as web.HTMLVideoElement;
    // Ask the browser if it supports this specific MIME type
    final support = video.canPlayType(mimeType);
    // Returns true if browser says 'probably' or 'maybe'
    return support == 'probably' || support == 'maybe';
  }

  void dispose() {
    eventDispose();
    effectDispose();
  }
}
