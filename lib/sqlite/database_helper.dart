import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
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
  String? _databaseWasResetName;

  // Migrations must be added to this array,
  // in the order in which they should be applied
  // They must be created in lib/sqlite/migrations
  final _migrations = ["000001_initialize_db.sql"];

  Future<Database> get database async {
    if (_database != null) return _database!;
    throw Exception("Database not initialized. Call initDb() first.");
  }

  bool get databaseWasReset => _databaseWasResetName != null;
  String? get databaseWasResetName => _databaseWasResetName;

  Future<void> initDb({required String directory}) async {
    if (_database != null) return;
    final path = join(directory, 'syncopathyDB.sqlite');
    final int currentAppSchemaVersion = _migrations.length;
    try {
      _database = await openDatabase(
        path,
        version: currentAppSchemaVersion,
        onConfigure: _onConfigure,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        onDowngrade: (db, oldVersion, newVersion) {
          throw Exception(
            "Database downgrade is not supported. Existing database version $oldVersion is newer than app version $newVersion.",
          );
        },
      );
    } catch (e) {
      // Check if the exception is due to a database downgrade
      if (e is Exception &&
          e.toString().contains("Database downgrade is not supported")) {
        // Extract oldVersion from the exception message
        final RegExp versionRegExp = RegExp(
          r"Existing database version (\d+) is newer than app version (\d+)",
        );
        final Match? match = versionRegExp.firstMatch(e.toString());
        final int oldVersion = int.parse(match?.group(1) ?? '0');

        debugPrint(
          "Handling database downgrade: existing version $oldVersion is newer than app version $currentAppSchemaVersion.",
        );

        // Ensure any previous database instance is truly closed
        if (_database != null) {
          await _database!.close();
          _database = null;
        }

        final oldDbPath = join(directory, 'syncopathyDB.sqlite');
        final backupDbPath = join(
          directory,
          'syncopathyDB_v$oldVersion.sqlite_backup',
        );
        _databaseWasResetName = backupDbPath; // Set flag for UI feedback

        final file = File(oldDbPath);
        if (await file.exists()) {
          try {
            await file.rename(backupDbPath);
            debugPrint(
              'Backed up newer database from $oldDbPath to $backupDbPath',
            );
          } catch (renameError) {
            debugPrint('Error renaming database file: $renameError');
            // If renaming fails, we should probably throw an error or handle it gracefully
            // For now, rethrow as this is a critical operation
            rethrow;
          }
        } else {
          debugPrint(
            'Original database file not found at $oldDbPath, could not back up.',
          );
        }

        // Re-open the database, which will now create a new one as the old one was renamed
        // This second openDatabase call should create the database at currentAppSchemaVersion
        _database = await openDatabase(
          path,
          version: currentAppSchemaVersion,
          onConfigure: _onConfigure,
          onCreate: _onCreate,
          onUpgrade: _onUpgrade,
          onDowngrade: (db, oldVer, newVer) {
            // This onDowngrade should not be hit here as we are creating a fresh DB
            debugPrint(
              'Unexpected onDowngrade call during re-initialization after reset.',
            );
            throw Exception(
              'Database reset and re-initialization failed unexpectedly.',
            );
          },
        );
      } else {
        // If it's another type of exception, rethrow it
        rethrow;
      }
    }
  }

  Future<void> closeDB() async {
    if (_database == null) return;
    await _database?.close();
    _database = null;
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    for (var i = oldVersion; i < newVersion; i++) {
      if (i < _migrations.length) {
        var migration = _migrations[i];
        await _applyMigration(db, migration);
      }
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await _onUpgrade(db, 0, version);
  }

  Future<void> _applyMigration(Database db, String fileName) async {
    final migrationSql = await rootBundle.loadString(
      'lib/sqlite/migrations/$fileName',
    );
    await db.transaction((txn) async {
      await txn.execute(migrationSql);
    });
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
