import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:pool/pool.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/helper/trie.dart';
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/media_library/media_metadata_retriever.dart';
import 'package:syncopathy/model/json/funscript_json.dart';
import 'package:syncopathy/funscript_algo.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/model/funscript.dart';
import 'package:syncopathy/model/json/funscript_metadata.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/objectbox.g.dart';
import 'package:syncopathy/persistence/service/fast_hash_cache_service.dart';
import 'package:syncopathy/persistence/entities/funscript_file.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';
import 'package:syncopathy/persistence/entities/media_metadata.dart';
import 'package:syncopathy/persistence/fast_file_hash.dart';

class _IndexingParams {
  final List<MediaFile> allMedias;
  final List<FunscriptFile> allFunscripts;
  final List<String> searchPaths;
  final Set<String> mediaHashesWithMetadata;
  final SendPort progressPort;
  final ByteData storeReference;

  late final Map<String?, MediaFile> allMediasMap = {
    for (var element in allMedias) element.fileHash: element,
  };
  late final Map<String?, FunscriptFile> allFunscriptsMap = {
    for (var element in allFunscripts) element.funscriptHash: element,
  };

  _IndexingParams({
    required this.allMedias,
    required this.allFunscripts,
    required this.searchPaths,
    required this.mediaHashesWithMetadata,
    required this.progressPort,
    required this.storeReference,
  });
}

class _IndexingResult {
  final Map<String, _FoundMediaFile> allFoundMedia;
  final Map<String, _FoundFunscriptFile> allFoundFunscript;

  final Map<String, _FoundMediaFile> newFoundMedia;
  final Map<String, _FoundFunscriptFile> newFoundFunscript;

  _IndexingResult({
    required this.allFoundMedia,
    required this.allFoundFunscript,
    required this.newFoundMedia,
    required this.newFoundFunscript,
  });
}

class _FoundMediaFile {
  final File file;
  final String mediaHash;
  final MediaType type;
  MediaMetadataRetrieved? metadata;
  final List<_FoundFunscriptFile> funscripts = [];
  final List<String> extraAliases = [];
  _FoundMediaFile(this.file, this.mediaHash, this.type, this.metadata);
}

class _FoundFunscriptFile {
  final File file;
  final String funscriptHash;

  final double averageSpeed;
  final double averageMin;
  final double averageMax;
  final bool isScriptToken;
  final FunscriptMetadata? metadata;

  _FoundFunscriptFile({
    required this.file,
    required this.funscriptHash,
    required this.averageSpeed,
    required this.averageMin,
    required this.averageMax,
    required this.isScriptToken,
    this.metadata,
  });
}

class _ProgressUpdate {
  final double? progress;
  final String? status;

  _ProgressUpdate({this.progress, this.status});
}

class MediaManager {
  final Signal<bool> _isIndexing = signal(false);
  ReadonlySignal<bool> get isIndexing => _isIndexing;

  final Signal<double?> _indexingProgress = signal(null);
  ReadonlySignal<double?> get indexingProgress => _indexingProgress;

  final Signal<String?> _indexingStatus = signal(null);
  ReadonlySignal<String?> get indexingStatus => _indexingStatus;

  final SettingsModel _settings;

  MediaManager(this._settings);

  static const Set<String> _videoExtensions = {
    '.mp4',
    '.mkv',
    '.avi',
    '.mov',
    '.wmv',
    '.webm',
  };
  static const Set<String> _audioExtensions = {
    '.mp3',
    '.aac',
    '.wav',
    '.flac',
    '.ogg',
    '.m4a',
    '.wma',
    '.opus',
  };

  // Concurrency for the hashing / metadata pools.
  static const int _hashPoolSize = 4;
  // Emit a progress update every N processed items to avoid signal churn.
  static const int _hashProgressInterval = 10;
  static const int _metadataProgressInterval = 5;

  /// Copies a retrieved metadata record into a persistable [MediaMetadata]
  /// entity. Shared by the existing-media and new-media indexing paths.
  static MediaMetadata _toMediaMetadata(MediaMetadataRetrieved m) {
    return MediaMetadata(
      duration: m.duration,
      aspectRatio: m.aspectRatio,
      audioChannels: m.audioChannels,
      audioCodec: m.audioCodec,
      bitRate: m.bitRate,
      creationTime: m.creationTime,
      frameRate: m.frameRate,
      height: m.height,
      width: m.width,
      pixelFormat: m.pixelFormat,
      rotation: m.rotation,
      videoCodec: m.videoCodec,
    );
  }

  Future<void> startIndexing() async {
    if (_isIndexing.value) return;
    _isIndexing.value = true;
    _indexingProgress.value = null;
    _indexingStatus.value = "Starting...";

    final receivePort = ReceivePort();
    final subscription = receivePort.listen((message) {
      if (message is _ProgressUpdate) {
        if (message.progress != null) {
          _indexingProgress.value = message.progress;
        }
        if (message.status != null) _indexingStatus.value = message.status;
      }
    });

    try {
      final allMedias = await oBox.mediaService.getAllAsync();
      final result = await compute(
        _indexing,
        _IndexingParams(
          allMedias: allMedias,
          allFunscripts: await oBox.funscriptService.getAllAsync(),
          searchPaths: _settings.mediaPaths.value,
          mediaHashesWithMetadata: allMedias
              .where((m) => m.metadata.targetId != 0)
              .map((m) => m.fileHash)
              .whereType<String>()
              .toSet(),
          progressPort: receivePort.sendPort,
          storeReference: oBox.store.reference,
        ),
      );

      _indexingStatus.value = "Updating database...";
      _indexingProgress.value = null;

      await oBox.store.runInTransaction(TxMode.write, () {
        final mediaBox = oBox.store.box<MediaFile>();
        final funscriptBox = oBox.store.box<FunscriptFile>();

        // 1. Process FunscriptFiles
        final existingFunscripts = funscriptBox.getAll();
        final Map<String, FunscriptFile> funscriptMap = {};

        for (final funscript in existingFunscripts) {
          final found = result.allFoundFunscript[funscript.funscriptHash];
          if (found != null) {
            funscript.path = found.file.path;
            funscript.fileNotFound = false;
            // Update metrics
            funscript.averageSpeed = found.averageSpeed;
            funscript.averageMin = found.averageMin;
            funscript.averageMax = found.averageMax;
            funscript.isScriptToken = found.isScriptToken;
            funscript.metadata = found.metadata;
            funscript.algorithmVersion = FunscriptAlgorithms.algorithmVersion;

            funscript.firstIndexedOn ??= DateTime.now();
          } else {
            funscript.fileNotFound = true;
          }
          funscriptMap[funscript.funscriptHash] = funscript;
        }

        // Add new funscripts
        for (final newFound in result.newFoundFunscript.values) {
          final funscript =
              FunscriptFile(
                  path: newFound.file.path,
                  averageSpeed: newFound.averageSpeed,
                  averageMin: newFound.averageMin,
                  averageMax: newFound.averageMax,
                  isScriptToken: newFound.isScriptToken,
                  fileNotFound: false,
                  funscriptHash: newFound.funscriptHash,
                  metadata: newFound.metadata,
                )
                ..algorithmVersion = FunscriptAlgorithms.algorithmVersion
                ..firstIndexedOn ??= DateTime.now();
          funscriptBox.put(funscript); // Put to get ID
          funscriptMap[newFound.funscriptHash] = funscript;
        }

        // 2. Process MediaFiles
        final existingMedias = mediaBox.getAll();
        final Map<String, MediaFile> mediaMap = {};

        for (final media in existingMedias) {
          final found = result.allFoundMedia[media.fileHash];
          if (found != null) {
            media.mediaPath = found.file.path;
            media.fileNotFound = false;
            media.firstIndexedOn ??= DateTime.now();

            final basename = p.basenameWithoutExtension(found.file.path);
            if (!media.aliases.contains(basename)) {
              media.aliases.add(basename);
            }
            for (final alias in found.extraAliases) {
              if (!media.aliases.contains(alias)) {
                media.aliases.add(alias);
              }
            }

            if (media.metadata.target == null && found.metadata != null) {
              media.metadata.target = _toMediaMetadata(found.metadata!);
            }
          } else {
            media.fileNotFound = true;
          }
          mediaMap[media.fileHash] = media;
        }

        // Add new media
        for (final newFound in result.newFoundMedia.values) {
          final media = MediaFile(
            name: p.basenameWithoutExtension(newFound.file.path),
            mediaPath: newFound.file.path,
            fileHash: newFound.mediaHash,
            playCount: 0,
            fileNotFound: false,
            type: newFound.type,
            aliases: [
              p.basenameWithoutExtension(newFound.file.path),
              ...newFound.extraAliases,
            ],
          )..firstIndexedOn ??= DateTime.now();
          if (newFound.metadata != null) {
            media.metadata.target = _toMediaMetadata(newFound.metadata!);
          }
          mediaBox.put(media); // Put to get ID
          mediaMap[newFound.mediaHash] = media;
        }

        // 3. Update Links
        for (final foundMedia in result.allFoundMedia.values) {
          final media = mediaMap[foundMedia.mediaHash];
          if (media == null) continue;

          for (final foundFunscript in foundMedia.funscripts) {
            final funscript = funscriptMap[foundFunscript.funscriptHash];
            if (funscript != null) {
              if (!media.funscripts.contains(funscript)) {
                media.funscripts.add(funscript);
              }
            }
          }

          if (media.mainFunscript.target == null &&
              media.funscripts.isNotEmpty) {
            media.mainFunscript.target = media.funscripts.first;
          }
        }

        mediaBox.putMany(mediaMap.values.toList());
        funscriptBox.putMany(funscriptMap.values.toList());
      });
    } finally {
      _isIndexing.value = false;
      _indexingProgress.value = null;
      _indexingStatus.value = null;
      subscription.cancel();
      receivePort.close();
    }
  }

  static Future<_IndexingResult> _indexing(_IndexingParams params) async {
    final store = Store.fromReference(
      getObjectBoxModel(),
      params.storeReference,
    );
    final cacheService = FastHashCacheService(store);

    try {
      void updateStatus(String status, [double? progress]) {
        params.progressPort.send(
          _ProgressUpdate(status: status, progress: progress),
        );
      }

      // Emit "$label ($processed/$total)" every [interval] items (and on the
      // final item), keeping the counter/threshold boilerplate in one place.
      void reportProgress(
        String label,
        int processed,
        int total, {
        int interval = _hashProgressInterval,
      }) {
        if (processed % interval == 0 || processed == total) {
          updateStatus("$label ($processed/$total)", processed / total);
        }
      }

      final combinedExtension = {..._videoExtensions, ..._audioExtensions};

      updateStatus("Listing files...");

      final List<File> mediaFiles = [];
      final List<File> funscriptFiles = [];

      for (final path in params.searchPaths) {
        final dir = Directory(path);
        if (!await dir.exists()) {
          continue;
        }

        await for (final entity in dir.list(
          recursive: true,
          followLinks: false,
        )) {
          if (entity is File) {
            final extension = p.extension(entity.path).toLowerCase();
            if (combinedExtension.contains(extension)) {
              mediaFiles.add(entity);
            } else if (extension == '.funscript') {
              funscriptFiles.add(entity);
            }
          }
        }
      }

      Trie mediaTrie = Trie();
      Map<String, List<_FoundMediaFile>> groups = {};

      final pool = Pool(_hashPoolSize);

      updateStatus("Hashing media files...", 0.0);
      int processedMedia = 0;
      final totalMedia = mediaFiles.length;

      final mediaFilesWithHashes = mediaFiles.map((media) {
        return pool.withResource(() async {
          final hash = await fastFileHash(media, cacheService: cacheService);
          processedMedia++;
          reportProgress("Hashing media files", processedMedia, totalMedia);
          return (media, hash);
        });
      }).toList();

      await for (var (file, hash) in Stream.fromFutures(mediaFilesWithHashes)) {
        final basename = p.basenameWithoutExtension(file.path);
        if (hash == null) continue;

        final extension = p.extension(file.path).toLowerCase();
        final type = _videoExtensions.contains(extension)
            ? MediaType.video
            : MediaType.audio;

        mediaTrie.insert(basename);
        groups
            .putIfAbsent(basename, () => [])
            .add(_FoundMediaFile(file, hash, type, null));
      }

      updateStatus("Hashing funscripts...", 0.0);
      int processedFunscripts = 0;
      final totalFunscripts = funscriptFiles.length;

      final funscriptFilesWithHashes = funscriptFiles.map((file) {
        return pool.withResource(() async {
          try {
            final funscriptHash = await fastFileHash(
              file,
              cacheService: cacheService,
            );
            if (funscriptHash == null) {
              processedFunscripts++;
              return (file, null);
            }

            final existing = params.allFunscriptsMap[funscriptHash];
            final basename = p.basenameWithoutExtension(file.path);
            final bestMatch = mediaTrie.findLongestPrefix(basename);

            if (existing == null && bestMatch == null) {
              processedFunscripts++;
              reportProgress(
                "Hashing funscripts",
                processedFunscripts,
                totalFunscripts,
              );
              return (file, null);
            }

            _FoundFunscriptFile found;

            if (existing != null &&
                existing.algorithmVersion >=
                    FunscriptAlgorithms.algorithmVersion) {
              found = _FoundFunscriptFile(
                file: file,
                funscriptHash: funscriptHash,
                averageSpeed: existing.averageSpeed,
                averageMin: existing.averageMin,
                averageMax: existing.averageMax,
                isScriptToken: existing.isScriptToken,
                metadata: existing.metadata,
              );
            } else {
              final funscriptJsonText = await file.readAsString();
              final funscript = FunscriptJson.fromJson(
                jsonDecode(funscriptJsonText),
              );
              final actions = funscript.actions;

              found = _FoundFunscriptFile(
                file: file,
                funscriptHash: funscriptHash,
                averageSpeed: FunscriptAlgorithms.averageSpeed(actions),
                averageMin: FunscriptAlgorithms.averageMin(actions),
                averageMax: FunscriptAlgorithms.averageMax(actions),
                isScriptToken: Funscript.isScriptToken(actions),
                metadata: funscript.metadata,
              );
            }

            processedFunscripts++;
            reportProgress(
              "Hashing funscripts",
              processedFunscripts,
              totalFunscripts,
            );

            return (file, found);
          } catch (e, st) {
            Logger.error("Failed to hash/parse funscript", e, st);
          }
          processedFunscripts++;
          return (file, null);
        });
      }).toList();

      final Map<String, _FoundFunscriptFile> allFoundFunscripts = {};
      await for (var (file, foundFunscript) in Stream.fromFutures(
        funscriptFilesWithHashes,
      )) {
        if (foundFunscript == null) continue;
        allFoundFunscripts[foundFunscript.funscriptHash] = foundFunscript;

        final basename = p.basenameWithoutExtension(file.path);
        final bestMatch = mediaTrie.findLongestPrefix(basename);

        if (bestMatch != null) {
          final groupList = groups[bestMatch];
          if (groupList == null) continue;
          for (final group in groupList) {
            group.funscripts.add(foundFunscript);
          }
        }
      }

      // Only index media if it has at least one funscript,
      // OR if it was already in the database (to allow tracking missing files).
      final existingMediaHashes = params.allMediasMap.keys.toSet();
      for (final key in groups.keys.toList()) {
        groups[key]!.removeWhere(
          (m) =>
              m.funscripts.isEmpty &&
              !existingMediaHashes.contains(m.mediaHash),
        );
        if (groups[key]!.isEmpty) groups.remove(key);
      }

      updateStatus("Retrieving metadata...", 0.0);
      int processedMetadata = 0;
      final allGroupEntries = groups.values.expand((list) => list).toList();
      final totalMetadata = allGroupEntries.length;

      final metadataFutures = allGroupEntries.map((m) {
        return pool.withResource(() async {
          if (!params.mediaHashesWithMetadata.contains(m.mediaHash)) {
            m.metadata = await MediaMetadataRetriever.runFFprobe(m.file.path);
          }
          processedMetadata++;
          reportProgress(
            "Retrieving metadata",
            processedMetadata,
            totalMetadata,
            interval: _metadataProgressInterval,
          );
        });
      });
      await Future.wait(metadataFutures);

      updateStatus("Finalizing...");
      return _importGroups(params, groups, allFoundFunscripts);
    } finally {
      store.close();
    }
  }

  static Future<_IndexingResult> _importGroups(
    _IndexingParams params,
    Map<String, List<_FoundMediaFile>> groups,
    Map<String, _FoundFunscriptFile> allFoundFunscripts,
  ) async {
    final dbMediaMap = params.allMediasMap;
    final dbFunscriptMap = params.allFunscriptsMap;

    final allFoundMediaMap = <String, _FoundMediaFile>{};
    for (final media in groups.values.expand((list) => list)) {
      if (allFoundMediaMap.containsKey(media.mediaHash)) {
        allFoundMediaMap[media.mediaHash]!.funscripts.addAll(media.funscripts);
        allFoundMediaMap[media.mediaHash]!.extraAliases.add(
          p.basenameWithoutExtension(media.file.path),
        );
      } else {
        allFoundMediaMap[media.mediaHash] = media;
      }
    }

    final allFoundFunscriptMap = {
      for (final funscript
          in groups.values.expand((list) => list).expand((m) => m.funscripts))
        funscript.funscriptHash: funscript,
    };

    // Also include existing funscripts that might be orphaned now
    for (final funscript in allFoundFunscripts.values) {
      if (dbFunscriptMap.containsKey(funscript.funscriptHash)) {
        allFoundFunscriptMap[funscript.funscriptHash] = funscript;
      }
    }

    final Map<String, _FoundMediaFile> newFoundMedia = Map.from(
      allFoundMediaMap,
    )..removeWhere((key, value) => dbMediaMap.containsKey(key));

    final Map<String, _FoundFunscriptFile> newFoundFunscript = Map.from(
      allFoundFunscriptMap,
    )..removeWhere((key, value) => dbFunscriptMap.containsKey(key));

    return _IndexingResult(
      allFoundMedia: allFoundMediaMap,
      allFoundFunscript: allFoundFunscriptMap,
      newFoundMedia: newFoundMedia,
      newFoundFunscript: newFoundFunscript,
    );
  }
}
