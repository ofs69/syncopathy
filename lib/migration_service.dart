import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pool/pool.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/funscript_algo.dart';
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/media_library/media_metadata_retriever.dart';
import 'package:syncopathy/model/funscript.dart';
import 'package:syncopathy/model/media_library_settings_model.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/model/json/funscript_json.dart';
import 'package:syncopathy/model/json/funscript_metadata.dart';
import 'package:syncopathy/objectbox.g.dart';
import 'package:syncopathy/persistence/entities/funscript_file.dart';
import 'package:syncopathy/persistence/entities/key_value.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';
import 'package:syncopathy/persistence/entities/media_metadata.dart';
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

class _FunscriptData {
  final String? funscriptHash;
  final FunscriptMetadata? metadata;
  final bool isScriptToken;
  final bool fileNotFound;
  final double averageSpeed;
  final double averageMin;
  final double averageMax;

  _FunscriptData({
    required this.funscriptHash,
    required this.metadata,
    required this.isScriptToken,
    required this.fileNotFound,
    required this.averageSpeed,
    required this.averageMin,
    required this.averageMax,
  });
}

class _TransactionParams {
  final List<KeyValuePairOld> keyValues;
  final List<UserCategoryOld> categories;
  final List<VideoOld> videos;
  final Map<int, String> mediaHashes;
  final Map<int, MediaMetadataRetrieved?> mediaMetadata;
  final Map<int, _FunscriptData> funscriptData;
  final SendPort sendPort;

  _TransactionParams(
    this.keyValues,
    this.categories,
    this.videos,
    this.mediaHashes,
    this.mediaMetadata,
    this.funscriptData,
    this.sendPort,
  );
}

class MigrationService {
  final Signal<String> statusSignal = signal("...");
  final Signal<double> progress = signal(0.0);
  final Signal<Duration?> eta = signal(null);
  final Signal<bool> isMigrating = signal(false);
  final Signal<bool> hasMigrated = signal(false);

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
    isMigrating.value = true;
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

    // Video Id -> Media Hash & Metadata
    Map<int, String> mediaHashes = {};
    Map<int, MediaMetadataRetrieved?> mediaMetadata = {};
    Map<int, _FunscriptData> funscriptDataMap = {};
    try {
      {
        int progressCounter = 0;

        final pool = Pool(32);
        final fileData = videos.map((video) {
          return pool.withResource(() async {
            final file = File(video.videoPath);
            final hash = await fastFileHash(file);
            MediaMetadataRetrieved? metadata;
            if (hash != null) {
              metadata = await MediaMetadataRetriever.runFFprobe(
                video.videoPath,
              );
            }

            FunscriptMetadata? funscriptMetadata;
            String? funscriptHash;
            bool isScriptToken = false;
            bool fileNotFound = true;
            double averageSpeed = 0;
            double averageMin = 0;
            double averageMax = 0;
            try {
              final funscriptJsonText = await File(
                video.funscriptPath,
              ).readAsString();
              final funscript = FunscriptJson.fromJson(
                jsonDecode(funscriptJsonText),
              );
              isScriptToken = Funscript.isScriptToken(funscript.actions);
              funscriptMetadata = funscript.metadata;
              funscriptHash = funscript.computeFunscriptHash();
              averageSpeed = FunscriptAlgorithms.averageSpeed(
                funscript.actions,
              );
              averageMin = FunscriptAlgorithms.averageMin(funscript.actions);
              averageMax = FunscriptAlgorithms.averageMax(funscript.actions);
              fileNotFound = false;
            } catch (e) {
              if (kDebugMode) debugPrint(e.toString());
            }

            return (
              video,
              hash,
              metadata,
              _FunscriptData(
                funscriptHash: funscriptHash,
                metadata: funscriptMetadata,
                isScriptToken: isScriptToken,
                fileNotFound: fileNotFound,
                averageSpeed: averageSpeed,
                averageMin: averageMin,
                averageMax: averageMax,
              ),
            );
          });
        }).toList();

        statusSignal.value = "Busy hashing and retrieving metadata...";
        progressCounter = 0;
        progress.value = 0.0;
        eta.value = null;

        final stream = Stream.fromFutures(fileData);
        final stopwatch = Stopwatch()..start();

        await for (final (video, mediaHash, metadata, fData) in stream) {
          if (mediaHash == null) {
            continue; // Use continue instead of return to process others
          }

          // Update UI based on the specific video that just finished
          statusSignal.value = "Processed: ${p.basename(video.videoPath)}";

          mediaHashes.putIfAbsent(video.id!, () => mediaHash);
          mediaMetadata.putIfAbsent(video.id!, () => metadata);
          funscriptDataMap.putIfAbsent(video.id!, () => fData);
          await renameThumbnail(supportDirectory, video.videoHash, mediaHash);

          // Update progress bar
          progressCounter++;
          progress.value = progressCounter / videos.length;

          final elapsed = stopwatch.elapsed;
          final estimatedTotal = elapsed * (videos.length / progressCounter);
          eta.value = estimatedTotal - elapsed;
        }

        statusSignal.value = "Writing transaction...";
        progressCounter = 0;
        progress.value = 0.0;
        eta.value = null;
      }

      final receivePort = ReceivePort();
      try {
        receivePort.listen((p) => progress.value = p as double);
        await _writeToDatabase(
          _TransactionParams(
            keyValues,
            categories,
            videos,
            mediaHashes,
            mediaMetadata,
            funscriptDataMap,
            receivePort.sendPort,
          ),
        );
      } finally {
        receivePort.close();
      }
      await getIt.get<SettingsModel>().load();
      if (getIt.isRegistered<MediaLibrarySettingsModel>()) {
        await getIt.get<MediaLibrarySettingsModel>().load();
      }
      hasMigrated.value = true;
    } finally {
      isMigrating.value = false;
    }
  }

  static Future<void> _writeToDatabase(_TransactionParams params) async {
    await oBox.store.runInTransactionAsync(TxMode.write, (store, parameter) {
      final params = parameter;
      final kvBox = store.box<KeyValue>();
      kvBox.putMany(
        params.keyValues
            .map((kv) => KeyValue(key: kv.id!, value: kv.value))
            .toList(),
      );

      // CategoryId -> UserCategory
      Map<int, UserCategory> categoryMap = {};
      final categoryBox = store.box<UserCategory>();
      final existingCategories = categoryBox.getAll();

      for (final categoryOld in params.categories) {
        var category = existingCategories
            .where((c) => c.name == categoryOld.name)
            .firstOrNull;
        if (category == null) {
          category = UserCategory(
            name: categoryOld.name,
            description: categoryOld.description,
            sortOrder: categoryOld.sortOrder,
          );
        } else {
          category.description = categoryOld.description;
          category.sortOrder = categoryOld.sortOrder;
        }
        categoryBox.put(category);
        categoryMap[categoryOld.id!] = category;
      }

      final funscriptBox = store.box<FunscriptFile>();
      final mediaBox = store.box<MediaFile>();
      final metadataBox = store.box<MediaMetadata>();

      // Media Hash -> Media File
      Map<String, MediaFile> mediaMap = {};
      List<FunscriptFile> funscriptsToPut = [];
      List<MediaMetadata> metadataToPut = [];

      for (final video in params.videos) {
        final fData = params.funscriptData[video.id!];
        FunscriptFile? funscript;
        if (fData != null) {
          funscript = FunscriptFile(
            funscriptHash: fData.funscriptHash,
            path: video.funscriptPath,
            averageMax: fData.averageMax,
            averageMin: fData.averageMin,
            averageSpeed: fData.averageSpeed,
            metadata: fData.metadata,
            fileNotFound: fData.fileNotFound,
            isScriptToken: fData.isScriptToken,
          );
          funscriptsToPut.add(funscript);
        }

        final mediaHash = params.mediaHashes[video.id!];
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

          final meta = params.mediaMetadata[video.id!];
          if (meta != null) {
            final mediaMetadata = MediaMetadata(
              duration: meta.duration,
              aspectRatio: meta.aspectRatio,
              audioChannels: meta.audioChannels,
              audioCodec: meta.audioCodec,
              bitRate: meta.bitRate,
              creationTime: meta.creationTime,
              frameRate: meta.frameRate,
              height: meta.height,
              width: meta.width,
              pixelFormat: meta.pixelFormat,
              rotation: meta.rotation,
              videoCodec: meta.videoCodec,
            );
            media.metadata.target = mediaMetadata;
            metadataToPut.add(mediaMetadata);
          }

          if (mediaHash != null) {
            mediaMap[mediaHash] = media;
          }
        }
        // put all names into aliases
        media.aliases.add(video.title);
        // associate all funscripts
        if (funscript != null) media.funscripts.add(funscript);

        for (final categoryOld in video.categories) {
          final category = categoryMap[categoryOld.id!];
          if (category != null) {
            if (!category.entries.contains(media)) {
              category.entries.add(media);
            }
          }
        }
      }

      funscriptBox.putMany(funscriptsToPut);
      metadataBox.putMany(metadataToPut);
      mediaBox.putMany(mediaMap.values.toList());
      categoryBox.putMany(categoryMap.values.toList());

      params.sendPort.send(1.0);
    }, params);
  }
}
