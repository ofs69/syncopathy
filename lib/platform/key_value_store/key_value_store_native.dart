import 'dart:convert';

import 'package:syncopathy/ioc.dart';
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
    oBox.keyValueService.putJsonMap(key,json);
  }

  static Future<Map<String, dynamic>?> _get(String key) async {
    final value = oBox.keyValueService.getRaw(key);
    if (value == null) return null;
    final jsonMap = jsonDecode(value);
    return jsonMap;
  }
}
