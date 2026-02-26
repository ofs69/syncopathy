import 'dart:io';

import 'package:args/args.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:syncopathy/media_manager.dart';
import 'package:syncopathy/migration_screen.dart';

import 'package:syncopathy/model/battery_model.dart';
import 'package:syncopathy/model/media_library_settings_model.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/model/timesource_model.dart';
import 'package:syncopathy/persistence/objectbox.dart';
import 'package:syncopathy/player/media_kit_player.dart';
import 'package:syncopathy/sqlite/database_helper.dart';
import 'package:syncopathy/syncopathy.dart';
import 'package:window_manager/window_manager.dart';

import 'package:flutter/foundation.dart';

late ObjectBox oBox;

bool isDesktop() {
  return defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.linux;
}

Future<Widget> _initializeAppAndRun({
  required bool simple,
  required String? file,
}) async {
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
  var mpvPlayer = MediaKitPlayer(
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
  MediaKit.ensureInitialized();

  // Initialize FFI for SQLite on desktop
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

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

  // Objectbox migration logic
  final appSupportDir = await getApplicationSupportDirectory();
  final sqliteDbExists = await File(
    p.join(appSupportDir.path, "syncopathyDB.sqlite"),
  ).exists();
  final objectBoxExists = await Directory(
    p.join(appSupportDir.path, "objectbox"),
  ).exists();

  if (sqliteDbExists && !objectBoxExists) {
    // Migrate SQLite to objectbox
    oBox = await ObjectBox.create(appSupportDir.path);
    await DatabaseHelper().initDb(directory: appSupportDir.path);
    return runApp(
      MaterialApp(
        home: MigrationScreen(
          onMigrationComplete: (context, result) async {
            switch (result) {
              case MigrationResult.success:
                _showMigrationDialog(
                  context,
                  "Migration success",
                  'The data migration has completed successfully. Please restart the application to apply the changes.',
                );
              case MigrationResult.error:
                _showMigrationDialog(
                  context,
                  "Migration failed",
                  '(╯°□°)╯︵ ┻━┻ ... I hope this doesn\'t happen',
                );
              case MigrationResult.skipped:
                _showMigrationDialog(
                  context,
                  "Migration skipped",
                  'Please restart the application to apply the changes.',
                );
            }
          },
        ),
      ),
    );
  }

  oBox = await ObjectBox.create(appSupportDir.path);
  final String? filePath = results.rest.isNotEmpty ? results.rest.first : null;
  final bool isSimple = (results['simple'] as bool) || (filePath != null);

  final mainApp = await _initializeAppAndRun(simple: isSimple, file: filePath);
  runApp(mainApp);
}

void _showMigrationDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevents closing by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(child: const Text('OK'), onPressed: () => exit(0)),
        ],
      );
    },
  );
}
