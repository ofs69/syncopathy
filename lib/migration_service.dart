import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pool/pool.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/model/funscript.dart';
import 'package:syncopathy/model/json/funscript_json.dart';
import 'package:syncopathy/model/json/funscript_metadata.dart';
import 'package:syncopathy/objectbox.g.dart';
import 'package:syncopathy/persistence/entities/funscript_file.dart';
import 'package:syncopathy/persistence/entities/key_value.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';
import 'package:syncopathy/persistence/entities/user_category.dart';
import 'package:syncopathy/persistence/fast_file_hash.dart';
import 'package:syncopathy/sqlite/models/key_value_pair_old.dart';
import 'package:syncopathy/sqlite/models/user_category_old.dart';
import 'package:syncopathy/sqlite/models/video_model_old.dart';
import 'package:syncopathy/sqlite/sqlite_helper.dart';

class HashingResult {
  final Map<int, String> mediaHashes;
  final Map<String, List<VideoOld>> duplicateFiles;
  HashingResult(this.mediaHashes, this.duplicateFiles);
}

class MigrationService {
  final Signal<String> statusSignal = signal("...");
  final Signal<double> progress = signal(0.0);

  final SetSignal<List<VideoOld>> duplicateVideos = setSignal({});

  Future<void> renameThumbnail(
    Directory supportDir,
    String oldHash,
    String newHash,
  ) async {
    final path = p.join(supportDir.path, "thumbnails_old", oldHash);
    final newPath = p.join(supportDir.path, "thumbnails", newHash);
    try {
      await File(path).rename(newPath);
    } catch (_) {}
  }

  Future<void> migrate() async {
    final supportDirectory = await getApplicationSupportDirectory();

    final videos = await SQLiteHelper().getAllVideos();
    final categories = await SQLiteHelper().getAllUserCategories();
    final keyValues = await SQLiteHelper().getAllKeyValues();

    try {
      await Directory(
        p.join(supportDirectory.path, "thumbnails"),
      ).rename(p.join(supportDirectory.path, "thumbnails_old"));
      await Directory(p.join(supportDirectory.path, "thumbnails")).create();
    } catch (_) {}

    // Video Id -> Media Hash
    Map<int, String> mediaHashes = {};
    {
      // Media Hash -> Videos
      Map<String, List<VideoOld>> duplicateFiles = {};
      int progressCounter = 0;

      final pool = Pool(32);
      final fileHashes = videos.map((video) {
        return pool.withResource(() async {
          return (video, await fastFileHash(video.videoPath));
        });
      }).toList();

      statusSignal.value = "Busy hashing...";
      progressCounter = 0;
      progress.value = 0.0;

      final stream = Stream.fromFutures(fileHashes);

      await for (final (video, mediaHash) in stream) {
        if (mediaHash == null) {
          continue; // Use continue instead of return to process others
        }

        // Update UI based on the specific video that just finished
        statusSignal.value = "Processed: ${p.basename(video.videoPath)}";

        final dups = duplicateFiles.putIfAbsent(mediaHash, () => []);
        dups.add(video);

        if (dups.length > 1) {
          duplicateVideos.add(dups);
        }

        mediaHashes.putIfAbsent(video.id!, () => mediaHash);
        await renameThumbnail(supportDirectory, video.videoHash, mediaHash);

        // Update progress bar
        progressCounter++;
        progress.value = progressCounter / videos.length;
      }

      statusSignal.value = "Writing transaction...";
      progressCounter = 0;
      progress.value = 0.0;
    }

    final receivePort = ReceivePort();
    try {
      receivePort.listen((p) => progress.value = p as double);
      await writeToDatabase(
        keyValues,
        categories,
        videos,
        mediaHashes,
        receivePort.sendPort,
      );
    } finally {
      receivePort.close();
    }
  }

  static Future<void> writeToDatabase(
    List<KeyValuePairOld> keyValues,
    List<UserCategoryOld> categories,
    List<VideoOld> videos,
    Map<int, String> mediaHashes,
    SendPort sendPort,
  ) async {
    await oBox.store.runInTransactionAsync(TxMode.write, (store, parameter) {
      SendPort sendPort = parameter;
      final kvBox = store.box<KeyValue>();
      for (final kv in keyValues) {
        kvBox.put(KeyValue(key: kv.id!, value: kv.value));
      }

      // CategoryId -> UserCategoiry
      Map<int, UserCategory> categoryMap = {};
      final categoryBox = store.box<UserCategory>();
      for (final categoryOld in categories) {
        final found = categoryBox
            .query(UserCategory_.name.equals(categoryOld.name))
            .build()
            .findFirst();
        if (found == null) {
          final category = UserCategory(
            name: categoryOld.name,
            description: categoryOld.description,
            sortOrder: categoryOld.sortOrder,
          );
          categoryBox.put(category);
          categoryMap[categoryOld.id!] = category;
        } else {
          found.name = categoryOld.name;
          found.description = categoryOld.description;
          found.sortOrder = categoryOld.sortOrder;
          categoryBox.put(found);
          categoryMap[categoryOld.id!] = found;
        }
      }

      final funscriptBox = store.box<FunscriptFile>();
      final mediaBox = store.box<MediaFile>();

      // Media Hash -> Media File
      Map<String, MediaFile> mediaMap = {};
      int progressCounter = 0;
      for (final video in videos) {
        bool isScriptToken = false;
        bool fileNotFound = true;

        FunscriptMetadata? metadata;
        String? funscriptHash;
        try {
          final funscriptJsonText = File(
            video.funscriptPath,
          ).readAsStringSync();
          final funscript = FunscriptJson.fromJson(
            jsonDecode(funscriptJsonText),
          );
          isScriptToken = Funscript.isScriptToken(funscript.actions);
          metadata = funscript.metadata;
          funscriptHash = funscript.computeFunscriptHash();
          fileNotFound = false;
        } catch (e) {
          if (kDebugMode) debugPrint(e.toString());
        }

        final funscript = FunscriptFile(
          funscriptHash: funscriptHash,
          path: video.funscriptPath,
          averageMax: video.averageMax,
          averageMin: video.averageMin,
          averageSpeed: video.averageSpeed,
          metadata: metadata,
          fileNotFound: fileNotFound,
          isScriptToken: isScriptToken,
        );
        funscriptBox.put(funscript);

        final mediaHash = mediaHashes[video.id!];
        MediaFile? media = mediaMap[mediaHash];
        if (media == null) {
          final rating = switch ((video.isFavorite, video.isDislike)) {
            (true, false) => MediaRating.like,
            (false, true) => MediaRating.dislike,
            (_, _) => MediaRating.noRating,
          };
          media = MediaFile(
            mediaPath: video.videoPath,
            name: video.title,
            playCount: video.playCount,
            rating: rating,
            type: MediaType.video,
            fileHash: mediaHash,
            fileNotFound: mediaHash == null,
          );
          media.mainFunscript.target = funscript;
          if (mediaHash != null) {
            mediaMap[mediaHash] = media;
          }
        }
        // put all names into aliases
        media.aliases.add(video.title);
        // associate all funscripts
        media.funscripts.add(funscript);
        mediaBox.put(media);

        for (final categoryOld in video.categories) {
          final category = categoryMap[categoryOld.id!];
          if (category != null) {
            if (!category.entries.contains(media)) {
              category.entries.add(media);
              categoryBox.put(category);
            }
          }
        }
        progressCounter += 1;
        sendPort.send(progressCounter / videos.length);
      }
    }, sendPort);
  }
}
