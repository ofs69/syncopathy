import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/persistence/objectbox.dart';
import 'package:window_manager/window_manager.dart';

class PlatformInit {
  static Future<void> initPlatform(bool simpleMode) async {
    final appSupportDir = await getApplicationSupportDirectory();
    Logger.addSink(RollingFileSink(directory: appSupportDir));

    if (!simpleMode) {
      oBox = await ObjectBox.create(appSupportDir.path);
    }
    if (isDesktop()) {
      await windowManager.ensureInitialized();

      WindowOptions windowOptions = const WindowOptions(
        center: true,
        size: Size(1280, 720),
        minimumSize: Size(800, 600),
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
