import 'dart:io';

import 'package:args/args.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/media_library/media_manager.dart';

import 'package:syncopathy/model/battery_model.dart';
import 'package:syncopathy/model/media_library_settings_model.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/model/timesource_model.dart';
import 'package:syncopathy/platform/key_value_store/key_value_store.dart';

import 'package:syncopathy/player/media_kit_player_stub.dart'
    if (dart.library.html) 'package:syncopathy/player/media_kit_player_web.dart'
    if (dart.library.io) 'package:syncopathy/player/media_kit_player_native.dart';
import 'package:syncopathy/player/video_player.dart';
import 'package:syncopathy/syncopathy.dart';

import 'package:syncopathy/platform/init/stub.dart'
    if (dart.library.html) 'package:syncopathy/platform/init/web.dart'
    if (dart.library.io) 'package:syncopathy/platform/init/native.dart';

Future<Widget> _initializeAppAndRun({
  required bool simple,
  required String? file,
}) async {
  syncopathySimpleMode = simple;
  await PlatformInit.initPlatform(simple);
  KVStore.initKeyValueStore(simple);

  SettingsModel settings = SettingsModel();
  await settings.load();

  MediaLibrarySettingsModel? mediaSettings;
  MediaManager? mediaManager;
  if (!simple) {
    mediaSettings = MediaLibrarySettingsModel();
    await mediaSettings.load();

    mediaManager = MediaManager(settings.mediaPaths.value);
    await mediaManager.load();
  }

  var batteryModel = BatteryModel();
  var videoPlayer = MediaKitPlayerImpl(
    embeddedPlayer: settings.embeddedVideoPlayer.value,
  );
  getIt.registerSingleton<VideoPlayer>(videoPlayer);

  var playerModel = PlayerModel(
    settings,
    TimesourceModel.fromPlayer(videoPlayer),
    videoPlayer,
    batteryModel,
  );

  return MultiProvider(
    providers: [
      Provider.value(value: settings),
      Provider.value(value: videoPlayer as VideoPlayer),
      Provider.value(value: playerModel),
      Provider.value(value: batteryModel),
      if (mediaSettings != null) Provider.value(value: mediaSettings),
      if (mediaManager != null) Provider.value(value: mediaManager),
    ],
    // HACK: I added this ExcludeSemantics because it spams some accessibility error 🤷‍♂️
    // [ERROR:flutter/shell/platform/common/accessibility_bridge.cc(114)] Failed to update ui::AXTree, error: Nodes left pending by the update: 76
    child: ExcludeSemantics(child: const Syncopathy()),
  );
}

void main(List<String> args) async {
  // comment this out if you want to use the signals devtools
  SignalsObserver.instance = null;
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  String? openFile;
  bool isSimple = false;
  if (!kIsWeb) {
    final parser = ArgParser()
      ..addFlag(
        'help',
        abbr: 'h',
        negatable: false,
        help: 'Print this usage information.',
      )
      ..addFlag(
        'simple',
        abbr: 's',
        negatable: false,
        help: 'Enable simple interface (automatic if [file] is provided).',
      );
    final results = parser.parse(args);

    if (results['help']) {
      stdout.writeln('Usage: syncopathy [options] [file]');
      stdout.writeln(parser.usage);
      await stdout.flush();
      return;
    }

    openFile = results.rest.isNotEmpty ? results.rest.first : null;
    isSimple = (results['simple'] as bool) || (openFile != null);
  } else if (kIsWeb) {
    isSimple = true;
    openFile = null;
  }

  final mainApp = await _initializeAppAndRun(simple: isSimple, file: openFile);
  runApp(mainApp);
}
