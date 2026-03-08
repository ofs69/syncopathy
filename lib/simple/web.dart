import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/model/funscript.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/player/video_player.dart';
import 'package:syncopathy/sqlite/models/video_model.dart';
import 'package:web/web.dart' as web;

class SimpleMode {
  static Widget webFullscreenButton() {
    return IconButton(
      icon: const Icon(Icons.fullscreen),
      tooltip: "Fullscreen",
      onPressed: () {
        final element = web.document.documentElement;

        if (element != null) {
          // Check if we are already in fullscreen
          if (web.document.fullscreenElement == null) {
            // Request Fullscreen
            element.requestFullscreen();
          } else {
            // Exit Fullscreen
            web.document.exitFullscreen();
          }
        }
      },
    );
  }

  static Future<String> _readBlobUrlAsString(String blobUrl) async {
    // 1. Fetch the data from the Blob URL
    final response = await web.window.fetch(blobUrl.toJS).toDart;

    // 2. Convert the response body to a Blob object
    final web.Blob blob = await response.blob().toDart;

    // 3. Create a FileReader to read the Blob as text
    final reader = web.FileReader();
    final completer = Completer<String>();

    reader.onLoadEnd.listen((event) {
      // The result contains the string content of the file
      completer.complete(reader.result.toString());
    });

    reader.readAsText(blob);

    return completer.future;
  }

  static Future<List<(String, String, String)>> _pickFileAndGetBlobUrl() async {
    // 1. Create a hidden HTML input element
    final web.HTMLInputElement input =
        web.document.createElement('input') as web.HTMLInputElement;
    input.type = 'file';
    input.accept = 'audio/*,video/*,.funscript';
    input.multiple = true;

    // 2. Create a "Completer" to wait for the user's selection
    final completer = Completer<List<(String, String, String)>>();

    // 3. Listen for the 'change' event (when the user selects a file)
    input.onChange.listen((event) {
      if (input.files != null && input.files!.length > 0) {
        final result = <(String, String, String)>[];
        for (int i = 0; i < input.files!.length; i += 1) {
          final web.File file = input.files!.item(i)!;
          final name = file.name;
          final mimeType = file.type;

          // 4. Generate the Blob URL
          final String blobUrl = web.URL.createObjectURL(file);
          result.add((name, blobUrl, mimeType));
        }
        completer.complete(result);
      } else {
        completer.complete([]);
      }
    });

    // 5. Trigger the file picker dialog
    input.click();

    return completer.future;
  }

  static Future<void> pickAndLoadFiles(PlayerModel playerModel) async {
    // 1. Open the file picker dialog
    final result = await _pickFileAndGetBlobUrl();

    if (result.isNotEmpty) {
      try {
        for (final file in result) {
          await openFile(
            playerModel,
            file.$1,
            file.$2,
            file.$3,
            () => _readBlobUrlAsString(file.$2),
          );
        }
      } catch (e) {
        Logger.error(e.toString());
      }
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
    } else {
      if (mimeType != null && !_canPlayVideo(mimeType)) {
        Logger.error("Can't play $name");
      } else {
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

  static bool _canPlayVideo(String mimeType) {
    final video = web.document.createElement('video') as web.HTMLVideoElement;
    final support = video.canPlayType(mimeType);
    return support == 'probably' || support == 'maybe';
  }
}
