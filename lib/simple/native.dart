import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/model/funscript.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/player/video_player.dart';
import 'package:syncopathy/sqlite/models/video_model.dart';

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
    "acc",
    "ogg",
    "wma",
  ];

  static Widget webFullscreenButton() {
    throw Exception("not available in native");
  }

  static Future<void> pickAndLoadFiles(PlayerModel playerModel) async {
    final files = await FilePicker.platform.pickFiles(
      dialogTitle: "Pick files to load",
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
      allowMultiple: true,
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
      final funscriptJson = await readAsString();
      final funscriptMap = jsonDecode(funscriptJson);
      final funscript = Funscript.fromJson(funscriptMap, path);
      if (!funscript.likelyScriptToken) {
        playerModel.simpleModeFunscript.value = funscript;
      } else {
        playerModel.simpleModeFunscript.value = null;
        Logger.error("Script token playback is not supported.");
      }
    } else if (ext.length > 1 && allowedExtensions.contains(ext.substring(1))) {
      getIt.get<VideoPlayer>().openSingleVideo(
        Video(
          title: name,
          videoPath: path,
          funscriptPath: "",
          averageSpeed: 0.0,
          averageMin: 0.0,
          averageMax: 100.0,
          dateFirstFound: DateTime.now(),
        ),
      );
    }
  }
}
