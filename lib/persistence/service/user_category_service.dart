import 'package:syncopathy/objectbox.g.dart';
import 'package:syncopathy/persistence/entities/user_category.dart';

class UserCategoryService {
  final Box<UserCategory> _box;
  UserCategoryService(Store store) : _box = store.box<UserCategory>();

  int save(UserCategory category) {
    return _box.put(category);
  }

  void saveAll(List<UserCategory> categories) {
    _box.putMany(categories);
  }

  List<UserCategory> getAllUserCategories() {
    return (_box.query()..order(UserCategory_.sortOrder)).build().find();
  }

  void deleteCategory(int id) => _box.remove(id);

  Future<UserCategory> createCategory(String name) async {
    final exists = await _box
        .query(UserCategory_.name.equals(name))
        .build()
        .findFirstAsync();
    if (exists != null) return exists;

    final newCategory = UserCategory(name: name, sortOrder: _box.count());
    _box.put(newCategory);
    return newCategory;
  }

  UserCategory? getById(int categoryId) {
    return _box.get(categoryId);
  }
}
