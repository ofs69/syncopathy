import 'dart:convert';

class KeyValuePair {
  final String id;
  final String value;

  Map<String, dynamic> get jsonMap => jsonDecode(value);

  KeyValuePair({required this.id, required this.value});

  Map<String, dynamic> toMap() => {'id': id, 'value': value};

  factory KeyValuePair.fromMap(Map<String, dynamic> map) {
    return KeyValuePair(id: map['id'], value: map['value']);
  }
}
