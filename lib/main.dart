import 'dart:io';

import 'package:args/args.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/media_manager.dart';

import 'package:syncopathy/model/battery_model.dart';
import 'package:syncopathy/model/media_library_settings_model.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/model/timesource_model.dart';
import 'package:syncopathy/player/mpv.dart';
import 'package:syncopathy/sqlite/database_helper.dart';
import 'package:syncopathy/syncopathy.dart';
import 'package:window_manager/window_manager.dart';

import 'package:flutter/foundation.dart';

bool isDesktop() {
  return defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.linux;
}

Future<Widget> _initializeAppAndRun(
  Directory appSupportDir, {
  required bool simple,
  required String? file,
}) async {
  await DatabaseHelper().initDb(directory: appSupportDir.path);
  Logger.info('SQLite initialized.');

  if (isDesktop()) {
    await windowManager.ensureInitialized();
  }

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1920, 1080),
    center: true,
    backgroundColor: Colors.transparent,
    titleBarStyle: TitleBarStyle.hidden,
  );

  if (isDesktop()) {
    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

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
  var mpvPlayer = MpvVideoplayer(
    videoOutput: settings.embeddedVideoPlayer.value,
  );

  var playerModel = PlayerModel(
    settings,
    TimesourceModel.fromPlayer(mpvPlayer),
    mpvPlayer,
    batteryModel,
  );

  return MultiProvider(
    providers: [
      Provider.value(value: settings),
      Provider.value(value: mpvPlayer),
      Provider.value(value: playerModel),
      Provider.value(value: batteryModel),
      if (mediaSettings != null) Provider.value(value: mediaSettings),
      if (mediaManager != null) Provider.value(value: mediaManager),
    ],
    child: const Syncopathy(),
  );
}

void main(List<String> args) async {
  // comment this out if you want to use the signals devtools
  SignalsObserver.instance = null;
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize FFI for SQLite on desktop
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  final appSupportDir = await getApplicationSupportDirectory();

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

  final String? filePath = results.rest.isNotEmpty ? results.rest.first : null;
  final bool isSimple = (results['simple'] as bool) || (filePath != null);

  final mainApp = await _initializeAppAndRun(
    appSupportDir,
    simple: isSimple,
    file: filePath,
  );
  runApp(mainApp);
}
