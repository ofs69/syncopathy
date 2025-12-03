import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:syncopathy/isar/media_library_settings.dart';
import 'package:syncopathy/isar/settings.dart';
import 'package:syncopathy/isar/user_category.dart';
import 'package:syncopathy/isar/video_model.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/media_manager.dart';

import 'package:syncopathy/migration_screen.dart';
import 'package:syncopathy/model/app_model.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/sqlite/database_helper.dart';
import 'package:syncopathy/syncopathy.dart';
import 'package:window_manager/window_manager.dart';

late Isar
isar; // Global Isar instance, only initialized if migration is needed.

Future<Widget> _initializeAppAndRun(
  Directory appSupportDir, {
  Isar? initialIsarInstance,
  MigrationResult? migrationResult,
}) async {
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

  Isar? initialIsarInstance; // Declare here, outside the if block

  if (isarDbExistsAtStart) {
    // Only proceed with potential migration if Isar DB exists and new SQLite DB does not
    initialIsarInstance = await Isar.open(
      [
        SettingsEntitySchema,
        VideoSchema,
        UserCategorySchema,
        MediaLibrarySettingsEntitySchema,
      ],
      name: 'syncopathyDB',
      directory: appSupportDir.path,
      // ignore: dead_code
      inspector: true && kDebugMode,
    );
    Logger.info('Isar initialized for potential migration.');
    isar = initialIsarInstance; // Assign to global isar for MigrationService

    runApp(
      MaterialApp(
        home: MigrationScreen(
          onMigrationComplete: (result) async {
            // Close Isar instance (from migration).
            if (initialIsarInstance != null && initialIsarInstance.isOpen) {
              isar.close();
              Logger.info(
                'Isar instance (from migration) closed after MigrationScreen completion.',
              );
            }

            if (result == MigrationResult.success) {
              Logger.info('Migration successful, proceeding to main app.');
              final mainApp = await _initializeAppAndRun(
                appSupportDir,
                initialIsarInstance: null, // It's closed/nulled by now
                migrationResult: result,
              );
              runApp(mainApp);
            } else if (result == MigrationResult.error) {
              SystemNavigator.pop(); // Still exit on error, might need manual restart or investigation
            } else if (result == MigrationResult.skipped) {
              // User skipped, proceed to main app setup
              final mainApp = await _initializeAppAndRun(
                appSupportDir,
                initialIsarInstance: null, // It's closed/nulled by now
                migrationResult: result,
              );
              runApp(mainApp);
            }
          },
        ),
      ),
    );
  } else {
    // No migration needed, directly initialize and run the main app
    final mainApp = await _initializeAppAndRun(
      appSupportDir,
      initialIsarInstance: null,
    ); // Always pass null
    runApp(mainApp);
  }
}
