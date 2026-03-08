import 'dart:convert';

import 'package:syncopathy/platform/key_value_store/key_value_store.dart';
import 'package:syncopathy/sqlite/models/key_value_pair.dart';
import 'package:syncopathy/sqlite/repository/kv_repository.dart';

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
    final repo = KeyValueRepositoryOld();
    final kv = KeyValuePair(key, value: jsonEncode(json));
    await repo.save(kv);
  }

  static Future<Map<String, dynamic>?> _get(String key) async {
    final repo = KeyValueRepositoryOld();
    final kv = await repo.getById(key);
    return kv?.jsonMap;
  }
}
