import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/platform/key_value_store/key_value_store_native.dart'
    as native;
import 'package:syncopathy/platform/key_value_store/key_value_store_web.dart'
    as web;

abstract class IKeyValueStore {
  Future<void> put(String key, Map<String, dynamic> json);
  Future<Map<String, dynamic>?> get(String key);
}

class KVStore {
  static Future<void> put(String key, Map<String, dynamic> jsonMap) async {
    final kv = getIt.get<IKeyValueStore>();
    await kv.put(key, jsonMap);
  }

  static Future<Map<String, dynamic>?> get(String key) async {
    final kv = getIt.get<IKeyValueStore>();
    return kv.get(key);
  }

  static void initKeyValueStore(bool simple) {
    if (simple) {
      getIt.registerSingleton<IKeyValueStore>(web.KeyValueStore());
    } else {
      getIt.registerSingleton<IKeyValueStore>(native.KeyValueStore());
    }
  }
}
