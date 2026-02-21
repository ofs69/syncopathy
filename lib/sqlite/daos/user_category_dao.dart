import 'package:sqflite/sqflite.dart';
import 'package:syncopathy/sqlite/database_helper.dart';
import 'package:syncopathy/sqlite/models/user_category.dart';

class UserCategoryDao {
  final dbHelper = DatabaseHelper();

  Future<int> insert(UserCategory category) async {
    final db = await dbHelper.database;
    return await db.insert(
      'user_categories',
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<UserCategory?> get(int id) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'user_categories',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return UserCategory.fromMap(maps.first);
    }
    return null;
  }

  Future<List<UserCategory>> getAll() async {
    final db = await dbHelper.database;
    final maps = await db.query('user_categories');
    return List.generate(maps.length, (i) {
      return UserCategory.fromMap(maps[i]);
    });
  }

  Future<int> update(UserCategory category) async {
    final db = await dbHelper.database;
    return await db.update(
      'user_categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    return await db.delete('user_categories', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<UserCategory>> getCategoriesForVideo(int videoId) async {
    final db = await dbHelper.database;
    final maps = await db.rawQuery(
      '''
      SELECT c.* FROM user_categories c
      INNER JOIN video_user_category_links l ON c.id = l.userCategoryId
      WHERE l.videoId = ?
    ''',
      [videoId],
    );

    return List.generate(maps.length, (i) {
      return UserCategory.fromMap(maps[i]);
    });
  }
}
