import 'dart:async';

import 'package:args/args.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/global_shortcuts.dart';
import 'package:syncopathy/heresphere/heresphere_controller.dart';
import 'package:syncopathy/heresphere/heresphere_media_resolver.dart';
import 'package:syncopathy/heresphere/media_library_source.dart';
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/media_library/media_badge.dart';
import 'package:syncopathy/media_library/media_manager.dart';

import 'package:syncopathy/model/battery_model.dart';
import 'package:syncopathy/model/media_library_settings_model.dart';
import 'package:syncopathy/model/media_filter_presets_model.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/model/timesource_model.dart';
import 'package:syncopathy/notification_feed.dart';
import 'package:syncopathy/platform/key_value_store/key_value_store.dart';
import 'package:syncopathy/player/media_kit_player/media_kit_player.dart';
import 'package:syncopathy/player/playback_session.dart';

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
  HereSphereController? hereSphere;
  if (!simple) {
    mediaSettings = MediaLibrarySettingsModel();
    await mediaSettings.load();
    getIt.registerSingleton<MediaLibrarySettingsModel>(mediaSettings);

    final filterPresets = MediaFilterPresetsModel();
    await filterPresets.load();
    getIt.registerSingleton<MediaFilterPresetsModel>(filterPresets);

    mediaManager = MediaManager(settings);
    getIt.registerSingleton<MediaManager>(mediaManager);
  }

  var batteryModel = BatteryModel();
  var videoPlayer = MediaKitPlayerImpl(
    embeddedPlayer: settings.embeddedVideoPlayer.value,
    hwdec: settings.effectiveHwdec,
  );
  getIt.registerSingleton<VideoPlayer>(videoPlayer);

  // The seam an external player (HereSphere) plugs into: everything downstream
  // reads the clock through this, so handing playback over is one assignment
  // rather than a rebuild of the funscript pipeline and the device backends.
  final activeSession = ActivePlaybackSession(videoPlayer);
  // Closes the loop: the player is what the session boundary is built from, and
  // this hands it back a way to ask whether it is still the one in charge.
  videoPlayer.bindOwnership(activeSession);
  getIt.registerSingleton<ActivePlaybackSession>(activeSession);

  var playerModel = PlayerModel(
    settings,
    TimesourceModel.fromSession(activeSession.session),
    activeSession.session,
    batteryModel,
  );

  // Built after the active session, because handing the clock to HereSphere and
  // giving it back is the controller's job. Experimental and inert until the
  // user enables it: constructing it only subscribes it to the settings that
  // decide whether a socket is ever bound.
  if (!simple && !kIsWeb) {
    final resolver = HereSphereMediaResolver.fromService(oBox.mediaService);
    hereSphere = HereSphereController(
      settings,
      MediaLibraryHereSphereSource(
        oBox.mediaService,
        categories: oBox.userCategoryService,
        decorateThumbnails: () => settings.hereSphereDecorateThumbnails.value,
        // The badges the library grid is showing, so the headset's thumbnails
        // carry the same information the cards do rather than a second set
        // configured somewhere else.
        enabledBadgeIds: () =>
            mediaSettings?.enabledBadges.value ?? defaultBadgeIds,
        // The library filters the user already saved and named, republished as
        // sections. Registered above, since this branch only runs when the
        // media library does.
        presets: () => getIt.get<MediaFilterPresetsModel>().presets.value,
      ),
      activeSession: activeSession,
      localSession: videoPlayer,
      resolveMedia: (id, resource) =>
          resolver.byId(id) ?? resolver.byResource(resource),
    );
    getIt.registerSingleton<HereSphereController>(hereSphere);
  }

  final alertManager = AlertManager();
  getIt.registerSingleton<AlertManager>(alertManager);
  unawaited(UpdateChecker.notifyIfUpdateAvailable());

  return MultiProvider(
    providers: [
      Provider.value(value: settings),
      Provider.value(value: videoPlayer as VideoPlayer),
      Provider.value(value: activeSession),
      Provider.value(value: playerModel),
      Provider.value(value: batteryModel),
      ChangeNotifierProvider<AlertManager>.value(value: alertManager),
      if (mediaSettings != null) Provider.value(value: mediaSettings),
      if (!simple) Provider.value(value: getIt.get<MediaFilterPresetsModel>()),
      if (mediaManager != null) Provider.value(value: mediaManager),
      if (hereSphere != null) Provider.value(value: hereSphere),
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
  initPlaybackEngine();

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
