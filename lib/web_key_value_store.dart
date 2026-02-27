import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class KeyValueStore {
  static Future<void> put(String key, Map<String, dynamic> json) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(json));
  }

  static Future<Map<String, dynamic>?> get(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);
    return jsonString != null ? jsonDecode(jsonString) : null;
  }
}
