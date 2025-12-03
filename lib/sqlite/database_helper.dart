import 'dart:async';


import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:syncopathy/sqlite/models/settings.dart';
import 'package:syncopathy/sqlite/models/user_category.dart';
import 'package:syncopathy/sqlite/models/video_model.dart';
import 'package:syncopathy/sqlite/models/media_library_settings.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    throw Exception("Database not initialized. Call initDb() first.");
  }

  Future<void> initDb({required String directory}) async {
    if (_database != null) return;
    final path = join(directory, 'syncopathyDB.sqlite');
    _database = await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> closeDB() async {
    if (_database == null) return;
    await _database?.close();
    _database = null;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE videos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        videoPath TEXT NOT NULL,
        funscriptPath TEXT NOT NULL,
        averageSpeed REAL NOT NULL,
        averageMin REAL NOT NULL,
        averageMax REAL NOT NULL,
        isFavorite INTEGER NOT NULL DEFAULT 0,
        isDislike INTEGER NOT NULL DEFAULT 0,
        dateFirstFound INTEGER NOT NULL,
        duration REAL,
        funscriptMetadataId INTEGER,
        FOREIGN KEY (funscriptMetadataId) REFERENCES funscript_metadata(id) ON DELETE SET NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE funscript_metadata(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        creator TEXT,
        description TEXT,
        duration INTEGER,
        license TEXT,
        notes TEXT,
        scriptUrl TEXT,
        title TEXT,
        type TEXT,
        videoUrl TEXT,
        bookmarks TEXT,
        chapters TEXT,
        performers TEXT,
        tags TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE user_categories(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        description TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE video_user_category_links(
        videoId INTEGER NOT NULL,
        userCategoryId INTEGER NOT NULL,
        PRIMARY KEY (videoId, userCategoryId),
        FOREIGN KEY (videoId) REFERENCES videos(id) ON DELETE CASCADE,
        FOREIGN KEY (userCategoryId) REFERENCES user_categories(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE media_library_settings(
        id INTEGER PRIMARY KEY,
        sortOption TEXT NOT NULL,
        isSortAscending INTEGER NOT NULL,
        videosPerRow INTEGER NOT NULL,
        showVideoTitles INTEGER NOT NULL,
        showAverageSpeed INTEGER NOT NULL,
        showAverageMinMax INTEGER NOT NULL,
        showDuration INTEGER NOT NULL,
        separateFavorites INTEGER NOT NULL,
        visibilityFilters TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE settings(
        id INTEGER PRIMARY KEY,
        min INTEGER NOT NULL,
        max INTEGER NOT NULL,
        offsetMs INTEGER NOT NULL,
        mediaPaths TEXT,
        slewMaxRateOfChange REAL,
        rdpEpsilon REAL,
        remapFullRange INTEGER NOT NULL,
        skipToAction INTEGER NOT NULL,
        embeddedVideoPlayer INTEGER NOT NULL,
        autoSwitchToVideoPlayerTab INTEGER NOT NULL,
        autoPlay INTEGER NOT NULL,
        invert INTEGER NOT NULL
      )
    ''');
  }

  Future<List<UserCategory>> getAllUserCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('user_categories');
    return List.generate(maps.length, (i) {
      return UserCategory.fromMap(maps[i]);
    });
  }

  Future<int> insertUserCategory(UserCategory category) async {
    final db = await database;
    return await db.insert(
      'user_categories',
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteUserCategory(int id) async {
    final db = await database;
    return await db.delete('user_categories', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Video>> getAllVideos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('videos');
    return List.generate(maps.length, (i) {
      return Video.fromMap(maps[i]);
    });
  }

  Future<Settings> getSettings() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('settings');
    if (maps.isNotEmpty) {
      return Settings.fromMap(maps.first);
    } else {
      final defaultSettings = Settings();
      await updateSettings(defaultSettings);
      return defaultSettings;
    }
  }

  Future<int> updateSettings(Settings settings) async {
    final db = await database;
    return await db.insert(
      'settings',
      settings.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Video?> getVideoByPath(String videoPath) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'videos',
      where: 'videoPath = ?',
      whereArgs: [videoPath],
    );
    if (maps.isNotEmpty) {
      return Video.fromMap(maps.first);
    }
    return null;
  }

  Future<int> insertVideo(Video video) async {
    final db = await database;
    return await db.insert(
      'videos',
      video.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateVideo(Video video) async {
    final db = await database;
    return await db.update(
      'videos',
      video.toMap(),
      where: 'id = ?',
      whereArgs: [video.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteVideo(int id) async {
    final db = await database;
    return await db.delete('videos', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertVideoUserCategoryLink(
    int videoId,
    int userCategoryId,
  ) async {
    final db = await database;
    return await db.insert(
      'video_user_category_links',
      {'videoId': videoId, 'userCategoryId': userCategoryId},
      conflictAlgorithm: ConflictAlgorithm.ignore, // Prevent duplicate links
    );
  }

  Future<int> deleteVideoUserCategoryLink(
    int videoId,
    int userCategoryId,
  ) async {
    final db = await database;
    return await db.delete(
      'video_user_category_links',
      where: 'videoId = ? AND userCategoryId = ?',
      whereArgs: [videoId, userCategoryId],
    );
  }

  Future<List<UserCategory>> getVideoCategories(int videoId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT uc.id, uc.name, uc.description
      FROM user_categories uc
      JOIN video_user_category_links vucl ON uc.id = vucl.userCategoryId
      WHERE vucl.videoId = ?
    ''',
      [videoId],
    );
    return List.generate(maps.length, (i) {
      return UserCategory.fromMap(maps[i]);
    });
  }

  Future<MediaLibrarySettings> getMediaLibrarySettings() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'media_library_settings',
    );
    if (maps.isNotEmpty) {
      return MediaLibrarySettings.fromMap(maps.first);
    } else {
      final defaultSettings = MediaLibrarySettings();
      await updateMediaLibrarySettings(defaultSettings);
      return defaultSettings;
    }
  }

  Future<int> updateMediaLibrarySettings(MediaLibrarySettings settings) async {
    final db = await database;
    return await db.insert(
      'media_library_settings',
      settings.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
