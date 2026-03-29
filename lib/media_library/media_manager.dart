import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:async_locks/async_locks.dart';
import 'package:collection/collection.dart';
import 'package:path/path.dart' as p;
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/model/funscript.dart';
import 'package:syncopathy/funscript_algo.dart';

import 'package:syncopathy/sqlite/database_helper.dart';
import 'package:syncopathy/sqlite/models/funscript_metadata.dart';
import 'package:syncopathy/sqlite/models/user_category.dart';
import 'package:syncopathy/sqlite/models/video_model.dart';

class MediaManager {
  final List<Video> _allVideos = List.empty(growable: true);
  List<Video> get allVideos => _allVideos;
  final List<String> _paths;
  final Signal<int> videoCountNotifier = signal(0);

  MediaManager(this._paths);

  Future<void> load() async {
    _allVideos.clear();
    _allVideos.addAll(await DatabaseHelper().getAllVideos());
  }

  Future<void> dispose() async {}

  Future<Map<String, dynamic>> _getVideoMetadata(
    String videoPath, {
    bool cache = true,
  }) async {
    if (cache) {
      final existingVideo = await DatabaseHelper().getVideoByPath(videoPath);
      if (existingVideo != null &&
          existingVideo.duration != null &&
          existingVideo.duration! > 0) {
        return {'duration': existingVideo.duration};
      }
    }

    try {
      final ffprobeResult = await Process.run('ffprobe', [
        '-v',
        'error',
        '-select_streams',
        'v:0',
        '-show_entries',
        'stream=width,height:format=duration',
        '-of',
        'json',
        videoPath,
      ]).timeout(Duration(seconds: 3));

      if (ffprobeResult.exitCode != 0) {
        Logger.error('ffprobe error for $videoPath: ${ffprobeResult.stderr}');
        return {};
      }

      final Map<String, dynamic> jsonOutput =
          jsonDecode(ffprobeResult.stdout) as Map<String, dynamic>;
      final format = jsonOutput['format'];

      final duration = format != null
          ? double.tryParse(format['duration'] as String)
          : null;

      if (duration == null || duration <= 0) {
        Logger.error(
          'Could not parse duration for $videoPath: ${ffprobeResult.stdout}',
        );
      }

      return {'duration': duration};
    } catch (e) {
      Logger.error('Error getting video metadata for $videoPath: $e');
      return {'duration': 0.0};
    }
  }

  Future<void> refreshVideos() async {
    _allVideos.clear();
    videoCountNotifier.value = 0;

    final videoExtensions = {'.mp4', '.mkv', '.avi', '.mov', '.wmv', '.webm'};
    final List<File> videoFiles = [];
    final Map<String, List<String>> funscriptMap =
        {}; // basename -> funscriptPath

    for (final path in _paths) {
      final dir = Directory(path);
      if (!await dir.exists()) {
        Logger.warning('Directory not found, skipping: $path');
        continue;
      }

      await for (final entity in dir.list(
        recursive: true,
        followLinks: false,
      )) {
        if (entity is File) {
          final extension = p.extension(entity.path).toLowerCase();
          if (videoExtensions.contains(extension)) {
            videoFiles.add(entity);
          } else if (extension == '.funscript') {
            final basename = p.basenameWithoutExtension(entity.path);
            funscriptMap.update(
              basename,
              (value) => [...value, entity.path],
              ifAbsent: () => [entity.path],
            );
          }
        }
      }
    }

    final processSemaphore = Semaphore(8);
    final List<Future<void>> processFutures = [];

    // Pre-fetch all videos in DB for fast lookup
    final videosInDb = await DatabaseHelper().getAllVideos();
    final Map<String, Video> dbVideoMap = {
      for (var v in videosInDb) v.videoPath: v,
    };

    for (final videoFile in videoFiles) {
      processFutures.add(() async {
        await processSemaphore.acquire();
        try {
          final videoPath = videoFile.path;
          final videoBasename = p.basenameWithoutExtension(videoPath);
          final funscriptPaths = funscriptMap[videoBasename];

          if (funscriptPaths != null && funscriptPaths.isNotEmpty) {
            final funscriptPath = funscriptPaths.first;
            final scriptFile = File(funscriptPath);

            // Get stats for both files
            final videoStat = await videoFile.stat();
            final scriptStat = await scriptFile.stat();

            // Check if we already have this video and if it's up to date
            final existingVideo = dbVideoMap[videoPath];
            if (existingVideo != null &&
                existingVideo.funscriptPath == funscriptPath &&
                existingVideo.videoFileSize == videoStat.size &&
                existingVideo.videoLastModified?.millisecondsSinceEpoch ==
                    videoStat.modified.millisecondsSinceEpoch &&
                existingVideo.funscriptFileSize == scriptStat.size &&
                existingVideo.funscriptLastModified?.millisecondsSinceEpoch ==
                    scriptStat.modified.millisecondsSinceEpoch) {
              // Up to date, just add to memory list and skip heavy processing
              _allVideos.add(existingVideo);
              videoCountNotifier.value = _allVideos.length;
              return;
            }

            // If we are here, file is new or changed - process it
            final title = videoBasename;
            final funscript = await Funscript.fromFile(funscriptPath)
                .catchError(
                  (e) => null,
                  test: (e) {
                    Logger.error(e.toString());
                    return true;
                  },
                );

            if (funscript != null) {
              final averageSpeed = FunscriptAlgorithms.averageSpeed(
                funscript.originalActions,
              );

              final averageMin = FunscriptAlgorithms.averageMin(
                funscript.originalActions,
              );
              final averageMax = FunscriptAlgorithms.averageMax(
                funscript.originalActions,
              );
              // Force fresh metadata if file changed
              final metadata = await _getVideoMetadata(
                videoFile.path,
                cache: false,
              );
              final duration = metadata['duration'];

              var video = Video(
                id: existingVideo?.id, // Preserve ID if it existed
                title: title,
                videoPath: videoPath,
                funscriptPath: funscriptPath,
                averageSpeed: averageSpeed,
                averageMin: averageMin,
                averageMax: averageMax,
                funscriptMetadata: funscript.metadata,
                duration: duration,
                dateFirstFound: existingVideo?.dateFirstFound ?? DateTime.now(),
                isFavorite: existingVideo?.isFavorite ?? false,
                isDislike: existingVideo?.isDislike ?? false,
                playCount: existingVideo?.playCount ?? 0,
                videoFileSize: videoStat.size,
                videoLastModified: videoStat.modified,
                funscriptFileSize: scriptStat.size,
                funscriptLastModified: scriptStat.modified,
              );

              _allVideos.add(video);
              videoCountNotifier.value = _allVideos.length;
            }
          }
        } finally {
          processSemaphore.release();
        }
      }());
    }
    await Future.wait(processFutures);

    // Update the database
    // remove files not found from the database
    var videosFoundOnDisk = _allVideos.toList();

    for (var video in videosInDb) {
      if (!videosFoundOnDisk.any((element) => element.id == video.id)) {
        await DatabaseHelper().deleteVideo(video.id!);
      }
    }

    List<Video> insertVideoBatch = List.empty(growable: true);
    List<Video> updateVideoBatch = List.empty(growable: true);
    List<FunscriptMetadata> updateMetadataBatch = List.empty(growable: true);

    for (var video in videosFoundOnDisk) {
      if (video.id == null) {
        // add new
        if (video.funscriptMetadata != null) {
          video.funscriptMetadataId = await DatabaseHelper()
              .insertFunscriptMetadata(video.funscriptMetadata!);
        }
        insertVideoBatch.add(video);
      } else {
        // update existing (only if changed, though _allVideos only contains processed ones or existing ones)
        // We can optimize this by only adding to updateVideoBatch if it was actually re-processed
        // For simplicity, we can batch update all that were found on disk or filter further.
        // Let's check if it was re-processed by comparing modified date with the one in DB
        final dbVideo = dbVideoMap[video.videoPath];
        if (dbVideo != null &&
            (dbVideo.videoLastModified != video.videoLastModified ||
                dbVideo.funscriptLastModified != video.funscriptLastModified)) {
          if (dbVideo.funscriptMetadataId == null &&
              video.funscriptMetadata != null) {
            video.funscriptMetadataId = await DatabaseHelper()
                .insertFunscriptMetadata(video.funscriptMetadata!);
          } else if (dbVideo.funscriptMetadataId != null &&
              video.funscriptMetadata != null) {
            video.funscriptMetadata!.id = dbVideo.funscriptMetadataId!;
            updateMetadataBatch.add(video.funscriptMetadata!);
          }
          updateVideoBatch.add(video);
        }
      }
    }

    await DatabaseHelper().batchUpdateFunscriptMetadata(updateMetadataBatch);
    await DatabaseHelper().batchInsertVideos(insertVideoBatch);
    await DatabaseHelper().batchUpdateVideos(updateVideoBatch);

    // display the database state
    await load();
  }

  void saveFavorite(Video video) async {
    await DatabaseHelper().updateVideo(video);
  }

  void saveDislike(Video video) async {
    await DatabaseHelper().updateVideo(video);
  }

  Future<void> createCategory(String name, {String? description}) async {
    final maxSortOrder = await DatabaseHelper().getMaxUserCategorySortOrder();
    final category = UserCategory(
      name: name,
      description: description,
      sortOrder: maxSortOrder + 1,
    );
    await DatabaseHelper().insertUserCategory(category);
  }

  Future<void> deleteCategory(UserCategory category) async {
    await DatabaseHelper().deleteUserCategory(category.id!);
  }

  Future<void> setVideoCategory(Video video, UserCategory category) async {
    await DatabaseHelper().insertVideoUserCategoryLink(video.id!, category.id!);
    video.categories.add(category);
  }

  Future<void> removeVideoCategory(Video video, UserCategory category) async {
    await DatabaseHelper().deleteVideoUserCategoryLink(video.id!, category.id!);
    video.categories.remove(category);
  }

  Future<void> addVideosToCategory(
    List<Video> videos,
    UserCategory category,
  ) async {
    for (var video in videos) {
      if (!video.categories.any((c) => c.id == category.id)) {
        await DatabaseHelper().insertVideoUserCategoryLink(
          video.id!,
          category.id!,
        );
        video.categories.add(category);
      }
    }
  }

  Future<void> removeVideosFromCategory(
    List<Video> videos,
    UserCategory category,
  ) async {
    for (var video in videos) {
      await DatabaseHelper().deleteVideoUserCategoryLink(
        video.id!,
        category.id!,
      );
      video.categories.removeWhere((c) => c.id == category.id);
    }
  }

  Future<Video?> getVideoByPath(String path) async {
    return _allVideos.firstWhereOrNull((video) => video.videoPath == path);
  }

  Future<void> deleteVideo(Video video) async {
    try {
      final videoFile = File(video.videoPath);
      if (await videoFile.exists()) {
        await videoFile.delete();
      }

      if (video.funscriptPath.isNotEmpty) {
        final scriptFile = File(video.funscriptPath);
        if (await scriptFile.exists()) {
          await scriptFile.delete();
        }
      }

      DatabaseHelper().deleteVideo(video.id!);

      _allVideos.removeWhere((v) => v.id == video.id);
    } catch (e) {
      Logger.error('Error deleting video ${video.title}: $e');
    }
  }
}
