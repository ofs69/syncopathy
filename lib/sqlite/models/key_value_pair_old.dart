import 'dart:convert';

import 'package:syncopathy/sqlite/repository/db_entity.dart';

class KeyValuePairOld extends DbEntity<String> {
  String value;

  Map<String, dynamic> get jsonMap => jsonDecode(value);

  KeyValuePairOld(super.id, {required this.value});

  @override
  Map<String, dynamic> toMap() => {'id': id, 'value': value};

  factory KeyValuePairOld.fromMap(Map<String, dynamic> map) {
    return KeyValuePairOld(map['id'], value: map['value']);
  }

  @override
  void updateFromMap(Map<String, dynamic> map) {
    value = map['value'];
  }
}
