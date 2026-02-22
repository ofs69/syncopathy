import 'package:sqflite/sql.dart';
import 'package:syncopathy/sqlite/database_helper.dart';
import 'package:syncopathy/sqlite/models/key_value_pair.dart';

class KeyValueDao {
  final dbHelper = DatabaseHelper();

  Future<int> put(KeyValuePair kv) async {
    final db = await dbHelper.database;
    return await db.insert(
      'key_value_store',
      kv.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<KeyValuePair?> get(String key) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'key_value_store',
      where: "id = ?",
      whereArgs: [key],
    );
    if (maps.isNotEmpty) {
      return KeyValuePair.fromMap(maps.first);
    }
    return null;
  }
}
