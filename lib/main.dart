import 'dart:async';

import 'package:args/args.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/global_shortcuts.dart';
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/media_library/media_manager.dart';

import 'package:syncopathy/model/battery_model.dart';
import 'package:syncopathy/model/media_library_settings_model.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/model/timesource_model.dart';
import 'package:syncopathy/notification_feed.dart';
import 'package:syncopathy/platform/key_value_store/key_value_store.dart';
import 'package:syncopathy/player/media_kit_player/media_kit_player.dart';

import 'package:syncopathy/player/video_player.dart';
import 'package:syncopathy/syncopathy.dart';
import 'package:syncopathy/update_checker.dart';

import 'package:syncopathy/platform/init/init.dart';

Future<Widget> _initializeAppAndRun({required bool simple}) async {
  syncopathySimpleMode = simple;
  await PlatformInit.initPlatform(simple);

  Logger.info('--- Application Started ---');

  KVStore.initKeyValueStore(simple);

  SettingsModel settings = SettingsModel();
  await settings.load();
  getIt.registerSingleton<SettingsModel>(settings);

  MediaLibrarySettingsModel? mediaSettings;
  MediaManager? mediaManager;
  if (!simple) {
    mediaSettings = MediaLibrarySettingsModel();
    await mediaSettings.load();
    getIt.registerSingleton<MediaLibrarySettingsModel>(mediaSettings);

    mediaManager = MediaManager(settings);
    getIt.registerSingleton<MediaManager>(mediaManager);
  }

  var batteryModel = BatteryModel();
  var videoPlayer = MediaKitPlayerImpl(
    embeddedPlayer: settings.embeddedVideoPlayer.value,
    hwdec: settings.effectiveHwdec,
  );
  getIt.registerSingleton<VideoPlayer>(videoPlayer);

  var playerModel = PlayerModel(
    settings,
    TimesourceModel.fromPlayer(videoPlayer),
    videoPlayer,
    batteryModel,
  );

  final alertManager = AlertManager();
  getIt.registerSingleton<AlertManager>(alertManager);
  unawaited(UpdateChecker.notifyIfUpdateAvailable());

  return MultiProvider(
    providers: [
      Provider.value(value: settings),
      Provider.value(value: videoPlayer as VideoPlayer),
      Provider.value(value: playerModel),
      Provider.value(value: batteryModel),
      ChangeNotifierProvider<AlertManager>.value(value: alertManager),
      if (mediaSettings != null) Provider.value(value: mediaSettings),
      if (mediaManager != null) Provider.value(value: mediaManager),
    ],
    // HACK: I added this ExcludeSemantics because it spams some accessibility error 🤷‍♂️
    // [ERROR:flutter/shell/platform/common/accessibility_bridge.cc(114)] Failed to update ui::AXTree, error: Nodes left pending by the update: 76
    child: const ExcludeSemantics(child: GlobalShortcuts(child: Syncopathy())),
  );
}

/// Unwraps the error a signals effect actually threw.
///
/// When a subscriber throws — a Flutter element marked dirty mid-frame, say —
/// the batch collects the error and rethrows it wrapped in a
/// [SignalEffectException], which has no `toString` of its own, so the log ends
/// up reading `Instance of 'SignalEffectException'` with a stack that stops at
/// `endBatch`. The wrapper carries the real cause and the stack from inside the
/// effect callback, which is the half worth reporting.
@visibleForTesting
(Object, StackTrace?) unwrapSignalError(Object error, StackTrace? stack) {
  var cause = error;
  var causeStack = stack;
  // Nested batches can wrap more than once.
  while (cause is SignalEffectException) {
    final inner = cause.error;
    if (inner == null) break;
    causeStack = cause.stackTrace ?? causeStack;
    cause = inner;
  }
  return (cause, causeStack);
}

void main(List<String> args) async {
  // comment this out if you want to use the signals devtools
  SignalsObserver.instance = null;

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    final (error, stack) = unwrapSignalError(details.exception, details.stack);
    Logger.error(
      identical(error, details.exception)
          ? details.exceptionAsString()
          : '$error',
      error,
      stack,
    );
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    final (cause, causeStack) = unwrapSignalError(error, stack);
    Logger.error('Uncaught platform error', cause, causeStack);
    return true;
  };

  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  String? openFile;
  bool isSimple = false;
  if (!kIsWeb) {
    final parser = ArgParser()
      ..addFlag(
        'simple',
        abbr: 's',
        negatable: false,
        help: 'Enable simple interface (automatic if [file] is provided).',
      )
      ..addOption(
        'hwdec',
        help:
            'Override the video hardware decoding mode for this run, taking '
            'precedence over the setting. Accepts any mpv --hwdec value '
            '(e.g. no, auto, auto-copy, vaapi). Useful for diagnosing GPU '
            'driver problems.',
        valueHelp: 'mode',
      );
    final results = parser.parse(args);

    openFile = results.rest.isNotEmpty ? results.rest.first : null;
    isSimple = (results['simple'] as bool) || (openFile != null);
    // Must land before any settings are read, since the effective hwdec value
    // is derived from it.
    hwdecOverride = results['hwdec'] as String?;
  } else {
    // Web always runs in simple mode.
    isSimple = true;
  }

  final mainApp = await _initializeAppAndRun(simple: isSimple);
  runApp(mainApp);
}
