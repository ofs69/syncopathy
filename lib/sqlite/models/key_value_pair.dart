import 'dart:convert';

import 'package:syncopathy/sqlite/repository/db_entity.dart';

class KeyValuePair extends DbEntity<String> {
  String value;

  Map<String, dynamic> get jsonMap => jsonDecode(value);

  KeyValuePair(super.id, {required this.value});

  Map<String, dynamic> toMap() => {'id': id, 'value': value};

  factory KeyValuePair.fromMap(Map<String, dynamic> map) {
    return KeyValuePair(map['id'], value: map['value']);
  }

  @override
  void updateFromMap(Map<String, dynamic> map) {
    value = map['value'];
  }
}
