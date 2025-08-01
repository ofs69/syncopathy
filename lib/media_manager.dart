import 'dart:io';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path/path.dart' as p;
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

    // recursively search all provided paths for funscripts with videos
    final videoExtensions = {'.mp4', '.mkv', '.avi', '.mov', '.wmv', '.webm'};
    for (final path in _paths) {
      final dir = Directory(path);
      if (!await dir.exists()) {
        debugPrint('Directory not found, skipping: $path');
        continue;
      }

      await for (final entity in dir.list(
        recursive: true,
        followLinks: false,
      )) {
        if (entity is File) {
          final extension = p.extension(entity.path).toLowerCase();
          if (videoExtensions.contains(extension)) {
            final videoPath = entity.path;
            final funscriptPath = '${p.withoutExtension(videoPath)}.funscript';

            if (await File(funscriptPath).exists()) {
              final title = p.basenameWithoutExtension(videoPath);
              final funscript = await Funscript.fromFile(
                funscriptPath,
              ).catchError((e) => null, test: (e) => true);

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
