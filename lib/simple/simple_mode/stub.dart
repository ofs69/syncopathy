import 'package:syncopathy/model/player_model.dart';

class SimpleMode {
  static Future<void> toggleFullscreen() async {
    throw UnimplementedError();
  }

  static Future<void> enterFullscreen() async {
    throw UnimplementedError();
  }

  static Future<void> exitFullscreen() async {
    throw UnimplementedError();
  }

  static Future<void> pickAndLoadFiles(PlayerModel playerModel) async {
    throw UnimplementedError();
  }

  static Future<void> openFile(
    PlayerModel playerModel,
    String name,
    String path,
    String? mimeType,
    Future<String> Function() readAsString,
  ) async {
    throw UnimplementedError();
  }
}
