import 'package:flutter/foundation.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/funscript_algo.dart';
import 'package:syncopathy/helper/debouncer.dart';
import 'package:syncopathy/helper/effect_dispose_mixin.dart';
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/model/auto_home.dart';
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
import 'package:syncopathy/player/playback_session.dart';
import 'package:syncopathy/player/player_backend.dart';
import 'package:syncopathy/player/player_backend_type.dart';

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

  /// The player that currently owns the clock. Read through the signal on every
  /// access — never cached — so an external player taking over is picked up by
  /// the effects below without rebuilding them.
  final ReadonlySignal<PlaybackSession> _session;

  late final Signal<PlayerBackend?> playerBackend;

  final Signal<Funscript?> _currentFunscript = signal(null);

  late final ReadonlySignal<MediaFunscript?> currentlyOpen;

  final Signal<Funscript?> simpleModeFunscript = signal(null);
  final Signal<int> selectedFunscriptIndex = signal(0);

  bool _videoViewCounted = false;
  bool _skipToActionProcessed = false;

  final AutoHomeController _autoHome = AutoHomeController();

  /// Whether Home Mode is on because playback paused rather than because the
  /// user switched it on. The home button shows the two apart.
  ReadonlySignal<bool> get autoHomeEngaged => _autoHome.engaged;

  final Debouncer _processingDebouncer = Debouncer(
    milliseconds: _processingDebounceMs,
  );
  final Debouncer _viewCountDebouncer = Debouncer(
    milliseconds: _viewCountDebounceMs,
  );

  PlayerModel(
    this._settings,
    this.timeSource,
    this._session,
    this._batteryModel,
  ) {
    playerBackend = signal(null);

    currentlyOpen = computed(() {
      final media = untracked(() => _session.value.currentMedia.value);
      final funscript = _currentFunscript.value;

      if (media != null && funscript != null) {
        return MediaFunscript(media: media, funscript: funscript);
      }
      return null;
    });

    if (syncopathySimpleMode) {
      simpleModeEffects();
    } else {
      regularEffects();
    }

    effectAdd([
      effect(() {
        final session = _session.value;
        final duration = session.duration.value;
        final funscript = currentlyOpen.value?.funscript;

        if (duration == null ||
            duration < _minValidDurationSeconds ||
            funscript == null) {
          return;
        }

        if (_skipToActionProcessed) return;

        // Skip to first stroke if enabled
        untracked(() {
          // A session that does not accept seeks — an external player we only
          // observe — silently keeps its own start position.
          if (_settings.skipToAction.value &&
              session.supports(PlaybackCapability.seek)) {
            _skipToActionProcessed = true;
            final actions = funscript.originalActions;
            if (actions.isNotEmpty) {
              final startTime = FunscriptAlgorithms.findFirstStroke(actions);
              session.seekTo(Duration(milliseconds: startTime));
            }
          }
        });
      }),
      effect(() {
        final backendType = _settings.playerBackendType.value;
        untracked(() async => await _updateBackend(backendType, _batteryModel));
      }),
      _autoHomeOnPauseEffect(),
    ]);
  }

  /// Parks the device while playback is paused and releases it on resume, as
  /// long as [SettingsModel.autoHomeOnPause] is on. [AutoHomeController] holds
  /// the rules; this only feeds it the current state.
  ///
  /// Home Mode is tracked as well as written, so a toggle by the user's own
  /// hand is noticed and hands ownership of the park back to them. Writing it
  /// re-runs the effect once more, which the controller then sees as a state
  /// it already knows and leaves alone.
  VoidCallback _autoHomeOnPauseEffect() {
    return effect(() {
      final autoHomeOnPause = _settings.autoHomeOnPause.value;
      final paused = timeSource.paused.value;
      final homeEnabled = _settings.homeDeviceEnabled.value;

      untracked(() {
        final next = _autoHome.nextHomeState(
          autoHomeOnPause: autoHomeOnPause,
          paused: paused,
          homeEnabled: homeEnabled,
        );
        if (next != null) _settings.homeDeviceEnabled.value = next;
      });
    });
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
  FunscriptProcessParams Function(
    List<FunscriptAction> actions,
    double duration,
  )
  _snapshotProcessParams(PlaybackSession session) {
    final invert = _settings.invert.value;
    final intensity = _settings.intensity.value;
    final playbackSpeed = session.playbackSpeed.value;
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

  void simpleModeEffects() {
    effectAdd([
      effect(() async {
        final session = _session.value;
        final media = session.currentMedia.value;
        final funscript = simpleModeFunscript.value;
        final totalDuration = session.duration.value;
        final buildParams = _snapshotProcessParams(session);

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

  void regularEffects() {
    effectAdd([
      effect(() async {
        final session = _session.value;
        final media = session.currentMedia.value;
        final index = selectedFunscriptIndex.value;
        final totalDuration = session.duration.value;
        final buildParams = _snapshotProcessParams(session);

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
        final media = _session.value.currentMedia.value;
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
        final playing = !_session.value.paused.value;
        untracked(() {
          if (video != null && playing && !_videoViewCounted) {
            _viewCountDebouncer.run(() {
              final moreCurrentVideo = currentlyOpen.value?.media;
              if (!_session.value.paused.value) {
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
