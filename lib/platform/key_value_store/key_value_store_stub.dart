import 'package:syncopathy/platform/key_value_store/key_value_store.dart';

class KeyValueStore extends IKeyValueStore {
  @override
  Future<Map<String, dynamic>?> get(String key) async {
    throw UnimplementedError();
  }

  @override
  Future<void> put(String key, Map<String, dynamic> json) async {
    throw UnimplementedError();
  }
}
