import 'dart:convert';

import 'package:syncopathy/model/funscript.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/notification_feed.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';

/// Shared simple-mode file handling used by both the native and web
/// [SimpleMode.openFile] implementations, which otherwise duplicated this
/// funscript-decode/token-check flow and the placeholder [MediaFile] shape.

/// Decodes a funscript JSON payload and assigns it as the active simple-mode
/// script, or reports an error if it is a script token or fails to parse.
void loadSimpleFunscript(PlayerModel playerModel, String path, String json) {
  try {
    final funscript = Funscript.fromJson(jsonDecode(json), path);
    if (!funscript.likelyScriptToken) {
      playerModel.simpleModeFunscript.value = funscript;
    } else {
      playerModel.simpleModeFunscript.value = null;
      AlertManager.showError("Script token playback is not supported.");
    }
  } catch (e) {
    AlertManager.showError(e.toString());
  }
}

/// Builds the placeholder [MediaFile] used for simple-mode direct playback:
/// no library entry, so the hash is empty and the file is treated as external.
MediaFile buildSimpleModeMediaFile(String name, String path) {
  return MediaFile(
    name: name,
    mediaPath: path,
    playCount: 0,
    rating: MediaRating.noRating,
    type: MediaType.unknown,
    fileHash: '',
    fileNotFound: true,
  );
}
