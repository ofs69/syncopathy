import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncopathy/platform/key_value_store/key_value_store.dart';

class KeyValueStore extends IKeyValueStore {
  @override
  Future<Map<String, dynamic>?> get(String key) async {
    return _get(key);
  }

  @override
  Future<void> put(String key, Map<String, dynamic> json) async {
    await _put(key, json);
  }

  static Future<void> _put(String key, Map<String, dynamic> json) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(json));
  }

  static Future<Map<String, dynamic>?> _get(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);
    return jsonString != null ? jsonDecode(jsonString) : null;
  }
}
