import 'package:material_ui/material_ui.dart';

class PlatformInit {
  static Future<void> initPlatform(bool simpleMode) async {
    debugPrint("Initialize web platform simple mode: $simpleMode");
  }
}
