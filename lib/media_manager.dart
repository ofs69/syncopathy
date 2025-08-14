import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:async_locks/async_locks.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path/path.dart' as p;
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/model/funscript.dart';
import 'package:syncopathy/funscript_algo.dart';
import 'package:syncopathy/main.dart';
import 'package:syncopathy/model/user_category.dart';
import 'package:syncopathy/model/video_model.dart';

class MediaManager {
  final List<Video> _allVideos = List.empty(growable: true);
  List<Video> get allVideos => _allVideos;
  final List<String> _paths;
  final ValueNotifier<int> videoCountNotifier = ValueNotifier(0);
  final _videoUpdateController = StreamController<Video>.broadcast();

  Stream<Video> get videoUpdates => _videoUpdateController.stream;

  MediaManager(this._paths) {
    _allVideos.clear();
    _allVideos.addAll(isar.videos.where().findAllSync());
  }

  void dispose() {
    _videoUpdateController.close();
  }

  Future<Map<String, dynamic>> _getVideoMetadata(
    String videoPath, {
    bool cache = true,
  }) async {
    if (cache) {
      final existingVideo = await isar.videos
          .filter()
          .videoPathEqualTo(videoPath)
          .findFirst();
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
      ]);

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
    for (final videoFile in videoFiles) {
      processFutures.add(() async {
        await processSemaphore.acquire();
        try {
          final videoPath = videoFile.path;
          final videoBasename = p.basenameWithoutExtension(videoPath);
          final funscriptPaths = funscriptMap[videoBasename];

          if (funscriptPaths != null && funscriptPaths.isNotEmpty) {
            if (funscriptPaths.length > 1) {
              final funscripts = await Future.wait(
                funscriptPaths.map(
                  (path) => Funscript.fromFile(
                    path,
                  ).catchError((e) => null, test: (e) => true),
                ),
              );
              final validFunscripts = funscripts.nonNulls.toList();

              if (validFunscripts.length > 1) {
                final firstActions = validFunscripts.first.actions;
                bool allActionsSame = true;
                for (int i = 1; i < validFunscripts.length; i++) {
                  if (!listEquals(firstActions, validFunscripts[i].actions)) {
                    allActionsSame = false;
                    break;
                  }
                }

                if (!allActionsSame) {
                  Logger.warning(
                    'Multiple funscripts found for video with different actions: $videoPath Funscripts: ${funscriptPaths.join(', ')}',
                  );
                } else {
                  Logger.info(
                    'Multiple funscripts found for video with identical actions: $videoPath Funscripts: ${funscriptPaths.join(', ')}',
                  );
                }
              }
            }
            final funscriptPath = funscriptPaths.first;
            if (p.dirname(videoPath) != p.dirname(funscriptPath)) {
              Logger.warning(
                'Video and funscript not in same directory: Video: $videoPath Funscript: $funscriptPath',
              );
            }
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
                funscript.actions,
              );

              final averageMin = FunscriptAlgorithms.averageMin(
                funscript.actions,
              );
              final averageMax = FunscriptAlgorithms.averageMax(
                funscript.actions,
              );
              final metadata = await _getVideoMetadata(
                videoFile.path,
                cache: true,
              );
              final duration = metadata['duration'];

              var video = Video(
                title: title,
                videoPath: videoPath,
                funscriptPath: funscriptPath,
                averageSpeed: averageSpeed,
                averageMin: averageMin,
                averageMax: averageMax,
                funscriptMetadata: funscript.metadata,
                duration: duration,
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
    // add files which are currently not in the database
    var videosFoundOnDisk = _allVideos.toList();

    await isar.writeTxn(() async {
      var videosInDb = await isar.videos.where().findAll();
      for (var video in videosInDb) {
        if (!videosFoundOnDisk.any(
          (element) => element.videoPath == video.videoPath,
        )) {
          await isar.videos.delete(video.id);
        }
      }

      for (var video in videosFoundOnDisk) {
        var dbVideo = videosInDb.firstWhereOrNull(
          (element) => element.videoPath == video.videoPath,
        );

        if (dbVideo == null) {
          // add new
          await isar.videos.put(video);
        } else {
          // update existing
          dbVideo.averageSpeed = video.averageSpeed;
          dbVideo.averageMin = video.averageMin;
          dbVideo.averageMax = video.averageMax;
          dbVideo.funscriptMetadata = video.funscriptMetadata;
          dbVideo.duration = video.duration;
          await isar.videos.put(dbVideo);
        }
      }
    });

    // display the database state
    _allVideos.clear();
    _allVideos.addAll(isar.videos.where().findAllSync());
  }

  void saveFavorite(Video video) async {
    await isar.writeTxn(() async {
      isar.videos.put(video);
    });
    _videoUpdateController.add(video);
  }

  void saveDislike(Video video) async {
    await isar.writeTxn(() async {
      isar.videos.put(video);
    });
    _videoUpdateController.add(video);
  }

  Future<void> createCategory(String name, {String? description}) async {
    final category = UserCategory(name: name, description: description);
    await isar.writeTxn(() async {
      await isar.userCategorys.put(category);
    });
  }

  Future<void> updateCategory(UserCategory category) async {
    await isar.writeTxn(() async {
      await isar.userCategorys.put(category);
    });
  }

  Future<void> deleteCategory(UserCategory category) async {
    await isar.writeTxn(() async {
      await isar.userCategorys.delete(category.id);
    });
  }

  Future<void> setVideoCategory(Video video, UserCategory? category) async {
    if (category == null) return;
    video.categories.add(category);
    await isar.writeTxn(() async {
      await video.categories.save();
    });
  }

  Future<void> removeVideoCategory(Video video, UserCategory category) async {
    video.categories.remove(category);
    await isar.writeTxn(() async {
      await video.categories.save();
    });
  }

  Future<void> addVideosToCategory(
    List<Video> videos,
    UserCategory category,
  ) async {
    for (var video in videos) {
      await video.categories.load();
    }
    await isar.writeTxn(() async {
      for (var video in videos) {
        if (!video.categories.any((c) => c.id == category.id)) {
          video.categories.add(category);
          await video.categories.save();
        }
      }
    });
  }

  Future<void> removeVideosFromCategory(
    List<Video> videos,
    UserCategory category,
  ) async {
    for (var video in videos) {
      await video.categories.load();
    }
    await isar.writeTxn(() async {
      for (var video in videos) {
        video.categories.removeWhere((c) => c.id == category.id);
        await video.categories.save();
      }
    });
  }

  Future<Video?> getVideoByPath(String path) async {
    return _allVideos.firstWhereOrNull((video) => video.videoPath == path);
  }
}