import 'dart:async';

import 'package:flutter/material.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/model/player_model.dart';
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
          throw UnimplementedError();
          // playerModel.openFile(
          //   file.$1,
          //   file.$2,
          //   file.$3,
          //   () => readBlobUrlAsString(file.$2),
          // );
        }
      } catch (e) {
        Logger.error(e.toString());
      }
    }
  }
}
