
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'package:syncopathy/main.dart';
import 'package:syncopathy/sqlite/database_helper.dart';

// Isar Models
import 'package:syncopathy/isar/settings.dart' as isar_settings;
import 'package:syncopathy/isar/media_library_settings.dart'
    as isar_media_settings;
import 'package:syncopathy/isar/user_category.dart' as isar_category;
import 'package:syncopathy/isar/video_model.dart' as isar_video;

// Sqlite Models
import 'package:syncopathy/sqlite/models/settings.dart' as sqlite_settings;
import 'package:syncopathy/sqlite/models/media_library_settings.dart'
    as sqlite_media_settings;
import 'package:syncopathy/sqlite/models/user_category.dart'
    as sqlite_category;
import 'package:syncopathy/sqlite/models/video_model.dart' as sqlite_video;
import 'package:syncopathy/sqlite/models/funscript_metadata.dart'
    as sqlite_funscript;

// Sqlite DAOs
import 'package:syncopathy/sqlite/daos/settings_dao.dart';
import 'package:syncopathy/sqlite/daos/media_library_settings_dao.dart';
import 'package:syncopathy/sqlite/daos/user_category_dao.dart';
import 'package:syncopathy/sqlite/daos/video_dao.dart';
import 'package:syncopathy/sqlite/daos/funscript_metadata_dao.dart';

class MigrationService {
  final _settingsDao = SettingsDao();
  final _mediaSettingsDao = MediaLibrarySettingsDao();
  final _categoryDao = UserCategoryDao();
  final _videoDao = VideoDao();
  final _funscriptDao = FunscriptMetadataDao();

  Future<void> migrate() async {
    // 1. Initialize SQLite database
    final dir = await getApplicationSupportDirectory();
    await DatabaseHelper().initDb(directory: dir.path);

    debugPrint("Starting database migration...");

    // 2. Migrate Settings
    await _migrateSettings();
    await _migrateMediaLibrarySettings();

    // 3. Migrate Categories and Videos
    final categoryIdMap = await _migrateCategories();
    await _migrateVideos(categoryIdMap);

    debugPrint("Database migration completed successfully!");
    await isar.close();
  }

  Future<void> _migrateSettings() async {
    final isarSettings = await isar.settingsEntitys.get(0) ?? isar_settings.SettingsEntity();
    final newSettings = sqlite_settings.Settings(
      min: isarSettings.min,
      max: isarSettings.max,
      offsetMs: isarSettings.offsetMs,
      mediaPaths: isarSettings.mediaPaths,
      slewMaxRateOfChange: isarSettings.slewMaxRateOfChange,
      rdpEpsilon: isarSettings.rdpEpsilon,
      remapFullRange: isarSettings.remapFullRange,
      skipToAction: isarSettings.skipToAction,
      embeddedVideoPlayer: isarSettings.embeddedVideoPlayer,
      autoSwitchToVideoPlayerTab: isarSettings.autoSwitchToVideoPlayerTab,
      autoPlay: isarSettings.autoPlay,
      invert: isarSettings.invert,
    );
    await _settingsDao.saveSettings(newSettings);
    debugPrint("Migrated settings.");
  }

  Future<void> _migrateMediaLibrarySettings() async {
    final isarMediaSettings =
        await isar.mediaLibrarySettingsEntitys.get(1) ?? isar_media_settings.MediaLibrarySettingsEntity();
    
    final newMediaSettings = sqlite_media_settings.MediaLibrarySettings(
      sortOption: isarMediaSettings.sortOption,
      isSortAscending: isarMediaSettings.isSortAscending,
      videosPerRow: isarMediaSettings.videosPerRow,
      showVideoTitles: isarMediaSettings.showVideoTitles,
      showAverageSpeed: isarMediaSettings.showAverageSpeed,
      showAverageMinMax: isarMediaSettings.showAverageMinMax,
      showDuration: isarMediaSettings.showDuration,
      separateFavorites: isarMediaSettings.separateFavorites,
      visibilityFilters: isarMediaSettings.visibilityFilters,
    );
    await _mediaSettingsDao.saveSettings(newMediaSettings);
    debugPrint("Migrated media library settings.");
  }

  Future<Map<int, int>> _migrateCategories() async {
    final isarCategories = await isar.userCategorys.where().findAll();
    final Map<int, int> idMap = {}; // old Isar Id -> new Sqlite Id

    for (final isarCategory in isarCategories) {
      final newCategory = sqlite_category.UserCategory(
        name: isarCategory.name,
        description: isarCategory.description,
      );
      final newId = await _categoryDao.insert(newCategory);
      idMap[isarCategory.id] = newId;
    }
    debugPrint("Migrated ${idMap.length} categories.");
    return idMap;
  }

  Future<void> _migrateVideos(Map<int, int> categoryIdMap) async {
    final isarVideos = await isar.videos.where().findAll();
    int videoCount = 0;

    for (final isarVideo in isarVideos) {
      // a. Migrate FunscriptMetadata if it exists
      int? newFunscriptId;
      if (isarVideo.funscriptMetadata != null) {
        final isarMeta = isarVideo.funscriptMetadata!;
        final newMeta = sqlite_funscript.FunscriptMetadata(
          // Here we have to manually map fields as there's no toMap in the embedded Isar object
          creator: isarMeta.creator,
          description: isarMeta.description,
          duration: isarMeta.duration,
          license: isarMeta.license,
          notes: isarMeta.notes,
          scriptUrl: isarMeta.scriptUrl,
          title: isarMeta.title,
          type: isarMeta.type,
          videoUrl: isarMeta.videoUrl,
          performers: isarMeta.performers,
          tags: isarMeta.tags,
          bookmarks: isarMeta.bookmarks
              .map((b) => sqlite_funscript.Bookmark(name: b.name, timeMs: b.timeMs))
              .toList(),
          chapters: isarMeta.chapters
              .map((c) => sqlite_funscript.Chapter(name: c.name, timeMs: c.timeMs))
              .toList(),
        );
        newFunscriptId = await _funscriptDao.insert(newMeta);
      }

      // b. Migrate the Video itself
      final newVideo = sqlite_video.Video(
        title: isarVideo.title,
        videoPath: isarVideo.videoPath,
        funscriptPath: isarVideo.funscriptPath,
        averageSpeed: isarVideo.averageSpeed,
        averageMin: isarVideo.averageMin,
        averageMax: isarVideo.averageMax,
        isFavorite: isarVideo.isFavorite,
        isDislike: isarVideo.isDislike,
        dateFirstFound: isarVideo.dateFirstFound,
        duration: isarVideo.duration,
        funscriptMetadataId: newFunscriptId,
      );
      final newVideoId = await _videoDao.insertVideo(newVideo);

      // c. Link categories to the new video
      await isarVideo.categories.load();
      for (final isarCategory in isarVideo.categories) {
        final oldCategoryId = isarCategory.id;
        final newCategoryId = categoryIdMap[oldCategoryId];
        if (newCategoryId != null) {
          await _videoDao.linkVideoToCategory(newVideoId, newCategoryId);
        }
      }
      videoCount++;
    }
    debugPrint("Migrated $videoCount videos and their category links.");
  }
}
