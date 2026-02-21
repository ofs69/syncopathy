import 'dart:convert';
import 'package:syncopathy/sqlite/daos/key_value_dao.dart';
import 'package:syncopathy/sqlite/models/key_value_pair.dart';

class KeyValueStore {
  static Future<void> put(String key, Map<String, dynamic> jsonMap) async {
    final dao = KeyValueDao();
    final kv = KeyValuePair(key: key, value: jsonEncode(jsonMap));
    await dao.put(kv);
  }

  static Future<Map<String, dynamic>?> get(String key) async {
    final dao = KeyValueDao();
    final kv = await dao.get(key);
    return kv?.jsonMap;
  }
}
