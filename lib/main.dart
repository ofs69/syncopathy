import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/media_manager.dart';

import 'package:syncopathy/model/app_model.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/sqlite/database_helper.dart';
import 'package:syncopathy/syncopathy.dart';
import 'package:window_manager/window_manager.dart';

Future<Widget> _initializeAppAndRun(Directory appSupportDir) async {
  await DatabaseHelper().initDb(directory: appSupportDir.path);
  Logger.info('SQLite initialized.');

  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(1920, 1080),
    center: true,
    backgroundColor: Colors.transparent,
    titleBarStyle: TitleBarStyle.hidden,
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  var settings = SettingsModel();
  await settings.load();
  var mediaManager = MediaManager(settings.mediaPaths.value);
  await mediaManager.load();
  var model = SyncopathyModel(settings, mediaManager);

  return MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: model),
      ChangeNotifierProvider.value(value: model.player),
    ],
    child: const Syncopathy(),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize FFI for SQLite on desktop
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  final appSupportDir = await getApplicationSupportDirectory();
  final isarDbFile = File(path.join(appSupportDir.path, 'syncopathyDB.isar'));
  final newSqliteDbFile = File(
    path.join(appSupportDir.path, 'syncopathyDB.sqlite'),
  );

  final isarDbExistsAtStart = await isarDbFile.exists();
  final newSqliteDbExists = await newSqliteDbFile.exists();

  if (newSqliteDbExists) {
    // New SQLite DB already exists, proceed directly to main app
    Logger.info('New SQLite database already exists, skipping migration.');
    final mainApp = await _initializeAppAndRun(appSupportDir);
    runApp(mainApp);
    return;
  }

  final mainApp = await _initializeAppAndRun(appSupportDir);
  runApp(mainApp);
}
