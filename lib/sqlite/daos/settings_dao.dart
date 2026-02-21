import 'package:sqflite/sqflite.dart';
import 'package:syncopathy/sqlite/database_helper.dart';
import 'package:syncopathy/sqlite/models/settings.dart';

class SettingsDao {
  final dbHelper = DatabaseHelper();
  final int _singletonId = 0;

  Future<int> saveSettings(Settings settings) async {
    final db = await dbHelper.database;
    // Use insert with conflict algorithm to create or update the single row
    return await db.insert(
      'settings',
      settings.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Settings> getSettings() async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'settings',
      where: 'id = ?',
      whereArgs: [_singletonId],
    );
    if (maps.isNotEmpty) {
      return Settings.fromMap(maps.first);
    }
    // If no settings exist, return a default instance.
    // The calling service will then save this default instance.
    return Settings();
  }
}
