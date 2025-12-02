
import 'package:sqflite/sqflite.dart';
import 'package:syncopathy/sqlite/database_helper.dart';
import 'package:syncopathy/sqlite/models/funscript_metadata.dart';

class FunscriptMetadataDao {
  final dbHelper = DatabaseHelper();

  Future<int> insert(FunscriptMetadata metadata) async {
    final db = await dbHelper.database;
    return await db.insert('funscript_metadata', metadata.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<FunscriptMetadata?> get(int id) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'funscript_metadata',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return FunscriptMetadata.fromMap(maps.first);
    }
    return null;
  }

  Future<int> update(FunscriptMetadata metadata) async {
    final db = await dbHelper.database;
    return await db.update(
      'funscript_metadata',
      metadata.toMap(),
      where: 'id = ?',
      whereArgs: [metadata.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'funscript_metadata',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
