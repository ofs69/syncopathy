import 'dart:io';
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

  MediaManager(this._paths) {
    _allVideos.clear();
    _allVideos.addAll(isar.videos.where().findAllSync());
  }

  void dispose() {
    videoCountNotifier.dispose();
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

    for (final videoFile in videoFiles) {
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
        final funscript = await Funscript.fromFile(
          funscriptPath,
        ).catchError((e) => null, test: (e) => true);

        if (funscript != null) {
          final averageSpeed = FunscriptAlgorithms.averageSpeed(
            funscript.actions,
          );

          final averageMin = FunscriptAlgorithms.averageMin(funscript.actions);
          final averageMax = FunscriptAlgorithms.averageMax(funscript.actions);

          var video = Video(
            title: title,
            videoPath: videoPath,
            funscriptPath: funscriptPath,
            averageSpeed: averageSpeed,
            averageMin: averageMin,
            averageMax: averageMax,
            funscriptMetadata: funscript.metadata,
          );

          _allVideos.add(video);
          videoCountNotifier.value = _allVideos.length;
        }
      }
    }

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
  }

  void saveDislike(Video video) async {
    await isar.writeTxn(() async {
      isar.videos.put(video);
    });
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
}
