
import 'package:sqflite/sqflite.dart';
import 'package:syncopathy/sqlite/database_helper.dart';
import 'package:syncopathy/sqlite/models/video_model.dart';

class VideoDao {
  final dbHelper = DatabaseHelper();

  Future<int> insertVideo(Video video) async {
    final db = await dbHelper.database;
    return await db.insert('videos', video.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Video?> getVideo(int id) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'videos',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Video.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Video>> getAllVideos() async {
    final db = await dbHelper.database;
    final maps = await db.query('videos');
    return List.generate(maps.length, (i) {
      return Video.fromMap(maps[i]);
    });
  }

  Future<int> updateVideo(Video video) async {
    final db = await dbHelper.database;
    return await db.update(
      'videos',
      video.toMap(),
      where: 'id = ?',
      whereArgs: [video.id],
    );
  }

  Future<int> deleteVideo(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'videos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Methods for handling the many-to-many relationship with UserCategory

  Future<void> linkVideoToCategory(int videoId, int categoryId) async {
    final db = await dbHelper.database;
    await db.insert(
      'video_user_category_links',
      {'videoId': videoId, 'userCategoryId': categoryId},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> unlinkVideoFromCategory(int videoId, int categoryId) async {
    final db = await dbHelper.database;
    await db.delete(
      'video_user_category_links',
      where: 'videoId = ? AND userCategoryId = ?',
      whereArgs: [videoId, categoryId],
    );
  }
}
