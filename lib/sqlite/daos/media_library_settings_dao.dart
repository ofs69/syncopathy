import 'package:sqflite/sqflite.dart';
import 'package:syncopathy/sqlite/database_helper.dart';
import 'package:syncopathy/sqlite/models/media_library_settings.dart';

class MediaLibrarySettingsDao {
  final dbHelper = DatabaseHelper();
  final int _singletonId = 1;

  Future<int> saveSettings(MediaLibrarySettings settings) async {
    final db = await dbHelper.database;
    // Use insert with conflict algorithm to create or update the single row
    return await db.insert(
      'media_library_settings',
      settings.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<MediaLibrarySettings> getSettings() async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'media_library_settings',
      where: 'id = ?',
      whereArgs: [_singletonId],
    );
    if (maps.isNotEmpty) {
      return MediaLibrarySettings.fromMap(maps.first);
    }
    // If no settings exist, return a default instance.
    // The calling service will then save this default instance.
    return MediaLibrarySettings();
  }
}
