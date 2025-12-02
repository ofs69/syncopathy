import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/model/app_model.dart';
import 'package:syncopathy/isar/media_library_settings.dart';
import 'package:syncopathy/isar/settings.dart';
import 'package:syncopathy/isar/user_category.dart';
import 'package:syncopathy/syncopathy.dart';
import 'package:syncopathy/isar/video_model.dart';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:window_manager/window_manager.dart';

late Isar isar; // Global Isar instance

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize FFI for SQLite on desktop
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  
  await windowManager.ensureInitialized();

  // Open the Isar instance
  final dir = await getApplicationSupportDirectory();
  isar = await Isar.open(
    [
      SettingsEntitySchema,
      VideoSchema,
      UserCategorySchema,
      MediaLibrarySettingsEntitySchema,
    ],
    name: 'syncopathyDB',
    directory: dir.path,
    // ignore: dead_code
    inspector: true && kDebugMode,
  );

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1920, 1080),
    center: true,
    backgroundColor: Colors.transparent,
    titleBarStyle: TitleBarStyle.hidden,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  var settings = Settings();
  await settings.load();
  var model = SyncopathyModel(settings);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: model),
        ChangeNotifierProvider.value(value: model.player),
      ],
      child: const Syncopathy(),
    ),
  );
}
