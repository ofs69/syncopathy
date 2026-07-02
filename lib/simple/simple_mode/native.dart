import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/player/video_player.dart';
import 'package:syncopathy/simple/simple_mode/simple_file_loader.dart';
import 'package:window_manager/window_manager.dart';

class SimpleMode {
  static const allowedExtensions = [
    "funscript",
    "mp4",
    "webm",
    "mkv",
    "avi",
    "wmv",
    "mov",
    "mp3",
    "flac",
    "wav",
    "m4a",
    "aac",
    "ogg",
    "wma",
  ];

  static Future<void> toggleFullscreen() async {
    await windowManager.setFullScreen(!(await windowManager.isFullScreen()));
  }

  static Future<void> enterFullscreen() async {
    await windowManager.setFullScreen(true);
  }

  static Future<void> exitFullscreen() async {
    await windowManager.setFullScreen(false);
  }

  static Future<void> pickAndLoadFiles(PlayerModel playerModel) async {
    final files = await FilePicker.pickFiles(
      dialogTitle: "Pick files to load",
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
    );
    if (files == null) return;
    for (final file in files.files) {
      final path = file.path;
      if (path == null) continue;
      await openFile(
        playerModel,
        file.name,
        path,
        null,
        () => File(path).readAsString(),
      );
    }
  }

  static Future<void> openFile(
    PlayerModel playerModel,
    String name,
    String path,
    String? mimeType,
    Future<String> Function() readAsString,
  ) async {
    final ext = p.extension(name).toLowerCase();
    if (ext == ".funscript") {
      loadSimpleFunscript(playerModel, path, await readAsString());
    } else if (ext.length > 1 && allowedExtensions.contains(ext.substring(1))) {
      getIt.get<VideoPlayer>().openSingleVideo(
        buildSimpleModeMediaFile(name, path),
      );
    }
  }
}
