import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/sqlite/database_helper.dart';
import 'package:window_manager/window_manager.dart';

class PlatformInit {
  static Future<void> initPlatform(bool simpleMode) async {
    if (!simpleMode) {
      // Initialize FFI for SQLite on desktop
      if (isDesktop()) {
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
      }
      final appSupportDir = await getApplicationSupportDirectory();
      await DatabaseHelper().initDb(directory: appSupportDir.path);
    }
    if (isDesktop()) {
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
    }
  }
}
