import 'dart:convert';

class KeyValuePair {
  final String key;
  final String value;

  Map<String, dynamic> get jsonMap => jsonDecode(value);

  KeyValuePair({required this.key, required this.value});

  Map<String, dynamic> toMap() => {'key': key, 'value': value};

  factory KeyValuePair.fromMap(Map<String, dynamic> map) {
    return KeyValuePair(key: map['key'], value: map['value']);
  }
}
