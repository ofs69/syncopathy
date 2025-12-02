import 'package:isar/isar.dart';

part 'user_category.g.dart';

@collection
class UserCategory {
  Id id = Isar.autoIncrement;
  String name;
  String? description;

  UserCategory({required this.name, this.description});
}
