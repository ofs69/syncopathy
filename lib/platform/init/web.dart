import 'package:flutter/material.dart';

class PlatformInit {
  static Future<void> initPlatform(bool simpleMode) async {
    debugPrint("Initialize web platform simple mode: $simpleMode");
  }
}
