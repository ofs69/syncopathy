import 'package:flutter/material.dart';
import 'package:syncopathy/model/player_model.dart';

class SimpleMode {
  static Future<void> pickAndLoadFiles(PlayerModel playerModel) async {
    throw UnimplementedError("implement native");
  }

  static Widget webFullscreenButton() {
    throw Exception("not available in native");
  }
}
