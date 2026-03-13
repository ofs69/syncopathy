import 'dart:convert';
import 'package:syncopathy/objectbox.g.dart';
import 'package:syncopathy/persistence/entities/key_value.dart';

class KeyValueService {
  final Box<KeyValue> _box;

  KeyValueService(Store store) : _box = store.box<KeyValue>();

  void putJsonMap(String key, Map<String, dynamic> jsonMap) {
    final jsonString = jsonEncode(jsonMap);
    return putJson(key, jsonString);
  }

  void putJson(String key, String jsonString) {
    // Use a unique key
    final existing = _box.query(KeyValue_.key.equals(key)).build().findFirst();

    if (existing != null) {
      existing.value = jsonString;
      _box.put(existing);
    } else {
      _box.put(KeyValue(key: key, value: jsonString));
    }
  }

  T? get<T>(String key, T Function(Map<String, dynamic>) fromJson) {
    final container = _box.query(KeyValue_.key.equals(key)).build().findFirst();
    if (container == null) return null;

    final map = jsonDecode(container.value);
    return fromJson(map);
  }

  String? getRaw(String key) {
    final container = _box.query(KeyValue_.key.equals(key)).build().findFirst();
    if (container == null) return null;
    return container.value;
  }
}
