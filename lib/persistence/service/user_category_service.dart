import 'package:syncopathy/objectbox.g.dart';
import 'package:syncopathy/persistence/entities/user_category.dart';

class UserCategoryService {
  final Box<UserCategory> _box;
  UserCategoryService(Store store) : _box = store.box<UserCategory>();

  int save(UserCategory category) {
    return _box.put(category);
  }

  List<UserCategory> getAllUserCategories() {
    return _box.getAll();
  }

  void deleteCategory(int id) => _box.remove(id);

  Future<UserCategory> createCategory(String name) async {
    final exists = await _box
        .query(UserCategory_.name.equals(name))
        .build()
        .findFirstAsync();
    if (exists != null) return exists;

    final newCategory = UserCategory(name: name);
    _box.put(newCategory);
    return newCategory;
  }
}
