import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/model/app_model.dart';
import 'package:syncopathy/model/settings.dart';
import 'package:syncopathy/model/user_category.dart';
import 'package:syncopathy/syncopathy.dart';
import 'package:syncopathy/model/video_model.dart';

import 'package:window_manager/window_manager.dart';

late Isar isar; // Global Isar instance

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  // Open the Isar instance
  final dir = await getApplicationSupportDirectory();
  isar = await Isar.open(
    [SettingsEntitySchema, VideoSchema, UserCategorySchema],
    name: 'syncopathyDB',
    directory: dir.path,
    // ignore: dead_code
    inspector: true && kDebugMode,
  );

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1920, 1080),
    center: true,
    backgroundColor: Colors.transparent,
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
