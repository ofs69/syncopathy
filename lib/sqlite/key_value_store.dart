import 'dart:convert';
import 'package:syncopathy/main.dart';
import 'package:syncopathy/sqlite/models/key_value_pair.dart';
import 'package:syncopathy/sqlite/repository/kv_repository.dart';

class KeyValueStore {
  static Future<void> put(String key, Map<String, dynamic> jsonMap) async {
    final repository = getIt.get<KeyValueRepository>();
    final kv = KeyValuePair(key, value: jsonEncode(jsonMap));
    await repository.save(kv);
  }

  static Future<Map<String, dynamic>?> get(String key) async {
    final repository = getIt.get<KeyValueRepository>();
    final kv = await repository.getById(key);
    return kv?.jsonMap;
  }
}
