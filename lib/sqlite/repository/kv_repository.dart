import 'package:syncopathy/sqlite/models/key_value_pair.dart';
import 'package:syncopathy/sqlite/repository/repository.dart';

class KeyValueRepository extends Repository<String, KeyValuePair> {
  KeyValueRepository() : super('key_value_store');

  @override
  KeyValuePair mapToEntity(Map<String, dynamic> map) {
    return KeyValuePair.fromMap(map);
  }
}
