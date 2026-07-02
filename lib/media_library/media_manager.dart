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

/// Sends progress back from the indexing isolate. [status] posts a labelled
/// phase message; [report] throttles per-item updates to one every [interval]
/// items (plus the final item), keeping the counter boilerplate in one place.
class _IndexingProgress {
  final SendPort _port;
  _IndexingProgress(this._port);

  void status(String status, [double? progress]) {
    _port.send(_ProgressUpdate(status: status, progress: progress));
  }

  void report(
    String label,
    int processed,
    int total, {
    int interval = MediaManager._hashProgressInterval,
  }) {
    if (processed % interval == 0 || processed == total) {
      status("$label ($processed/$total)", processed / total);
    }
  }
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
    final subscription = receivePort.listen(_handleProgressMessage);

    try {
      final result = await _runIndexingIsolate(receivePort.sendPort);

      _indexingStatus.value = "Updating database...";
      _indexingProgress.value = null;
      _applyIndexingResult(result);
    } finally {
      _isIndexing.value = false;
      _indexingProgress.value = null;
      _indexingStatus.value = null;
      subscription.cancel();
      receivePort.close();
    }
  }

  void _handleProgressMessage(dynamic message) {
    if (message is _ProgressUpdate) {
      if (message.progress != null) _indexingProgress.value = message.progress;
      if (message.status != null) _indexingStatus.value = message.status;
    }
  }

  /// Snapshots the current DB state and runs the (CPU/IO-heavy) scan in a
  /// background isolate, streaming progress back through [progressPort].
  Future<_IndexingResult> _runIndexingIsolate(SendPort progressPort) async {
    final allMedias = await oBox.mediaService.getAllAsync();
    return compute(
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
        progressPort: progressPort,
        storeReference: oBox.store.reference,
      ),
    );
  }

  /// Reconciles the scan result into the database in a single write
  /// transaction: update/insert funscripts, then media, then relink them.
  void _applyIndexingResult(_IndexingResult result) {
    oBox.store.runInTransaction(TxMode.write, () {
      final mediaBox = oBox.store.box<MediaFile>();
      final funscriptBox = oBox.store.box<FunscriptFile>();

      final funscriptMap = _reconcileFunscripts(funscriptBox, result);
      final mediaMap = _reconcileMedia(mediaBox, result);
      _linkMediaToFunscripts(result, mediaMap, funscriptMap);

      mediaBox.putMany(mediaMap.values.toList());
      funscriptBox.putMany(funscriptMap.values.toList());
    });
  }

  /// Updates existing funscript rows (marking vanished ones not-found) and
  /// inserts newly discovered ones, returning them keyed by hash.
  static Map<String, FunscriptFile> _reconcileFunscripts(
    Box<FunscriptFile> funscriptBox,
    _IndexingResult result,
  ) {
    final Map<String, FunscriptFile> funscriptMap = {};

    for (final funscript in funscriptBox.getAll()) {
      final found = result.allFoundFunscript[funscript.funscriptHash];
      if (found != null) {
        funscript.path = found.file.path;
        funscript.fileNotFound = false;
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

    return funscriptMap;
  }

  /// Updates existing media rows (paths, aliases, metadata; marking vanished
  /// ones not-found) and inserts newly discovered ones, keyed by hash.
  static Map<String, MediaFile> _reconcileMedia(
    Box<MediaFile> mediaBox,
    _IndexingResult result,
  ) {
    final Map<String, MediaFile> mediaMap = {};

    for (final media in mediaBox.getAll()) {
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

    return mediaMap;
  }

  /// Attaches each media's discovered funscripts and picks a main funscript
  /// when one isn't already set.
  static void _linkMediaToFunscripts(
    _IndexingResult result,
    Map<String, MediaFile> mediaMap,
    Map<String, FunscriptFile> funscriptMap,
  ) {
    for (final foundMedia in result.allFoundMedia.values) {
      final media = mediaMap[foundMedia.mediaHash];
      if (media == null) continue;

      for (final foundFunscript in foundMedia.funscripts) {
        final funscript = funscriptMap[foundFunscript.funscriptHash];
        if (funscript != null && !media.funscripts.contains(funscript)) {
          media.funscripts.add(funscript);
        }
      }

      if (media.mainFunscript.target == null && media.funscripts.isNotEmpty) {
        media.mainFunscript.target = media.funscripts.first;
      }
    }
  }

  /// Isolate entry point: walks the search paths, hashes media and funscripts,
  /// matches them, retrieves metadata, and folds everything into an
  /// [_IndexingResult]. Runs off the UI thread via [compute].
  static Future<_IndexingResult> _indexing(_IndexingParams params) async {
    final store = Store.fromReference(
      getObjectBoxModel(),
      params.storeReference,
    );
    final cacheService = FastHashCacheService(store);
    final progress = _IndexingProgress(params.progressPort);
    final pool = Pool(_hashPoolSize);

    try {
      progress.status("Listing files...");
      final (mediaFiles, funscriptFiles) = await _listMediaFiles(
        params.searchPaths,
      );

      final (mediaTrie, groups) = await _hashMediaFiles(
        mediaFiles,
        pool,
        cacheService,
        progress,
      );

      final allFoundFunscripts = await _hashFunscripts(
        funscriptFiles,
        pool,
        cacheService,
        params,
        mediaTrie,
        groups,
        progress,
      );

      _pruneEmptyGroups(params, groups);

      await _retrieveMetadata(params, groups, pool, progress);

      progress.status("Finalizing...");
      return _importGroups(params, groups, allFoundFunscripts);
    } finally {
      store.close();
    }
  }

  /// Recursively lists the search paths, splitting entries into media files
  /// (by extension) and `.funscript` files.
  static Future<(List<File>, List<File>)> _listMediaFiles(
    List<String> searchPaths,
  ) async {
    final combinedExtension = {..._videoExtensions, ..._audioExtensions};
    final List<File> mediaFiles = [];
    final List<File> funscriptFiles = [];

    for (final path in searchPaths) {
      final dir = Directory(path);
      if (!await dir.exists()) continue;

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
    return (mediaFiles, funscriptFiles);
  }

  /// Hashes all media files (pooled), returning a trie of their basenames (for
  /// funscript matching) and the found media grouped by basename.
  static Future<(Trie, Map<String, List<_FoundMediaFile>>)> _hashMediaFiles(
    List<File> mediaFiles,
    Pool pool,
    FastHashCacheService cacheService,
    _IndexingProgress progress,
  ) async {
    final mediaTrie = Trie();
    final groups = <String, List<_FoundMediaFile>>{};

    progress.status("Hashing media files...", 0.0);
    int processed = 0;
    final total = mediaFiles.length;

    final hashed = mediaFiles.map((media) {
      return pool.withResource(() async {
        final hash = await fastFileHash(media, cacheService: cacheService);
        processed++;
        progress.report("Hashing media files", processed, total);
        return (media, hash);
      });
    }).toList();

    await for (var (file, hash) in Stream.fromFutures(hashed)) {
      if (hash == null) continue;

      final basename = p.basenameWithoutExtension(file.path);
      final extension = p.extension(file.path).toLowerCase();
      final type = _videoExtensions.contains(extension)
          ? MediaType.video
          : MediaType.audio;

      mediaTrie.insert(basename);
      groups
          .putIfAbsent(basename, () => [])
          .add(_FoundMediaFile(file, hash, type, null));
    }
    return (mediaTrie, groups);
  }

  /// Hashes and analyzes all funscripts (pooled), attaching each to the media
  /// group whose basename is its longest prefix. Returns them keyed by hash.
  static Future<Map<String, _FoundFunscriptFile>> _hashFunscripts(
    List<File> funscriptFiles,
    Pool pool,
    FastHashCacheService cacheService,
    _IndexingParams params,
    Trie mediaTrie,
    Map<String, List<_FoundMediaFile>> groups,
    _IndexingProgress progress,
  ) async {
    progress.status("Hashing funscripts...", 0.0);
    int processed = 0;
    final total = funscriptFiles.length;

    final hashed = funscriptFiles.map((file) {
      return pool.withResource(() async {
        try {
          final funscriptHash = await fastFileHash(
            file,
            cacheService: cacheService,
          );
          if (funscriptHash == null) {
            processed++;
            return (file, null);
          }

          final existing = params.allFunscriptsMap[funscriptHash];
          final basename = p.basenameWithoutExtension(file.path);
          final bestMatch = mediaTrie.findLongestPrefix(basename);

          // Skip funscripts that are neither known nor match any media.
          if (existing == null && bestMatch == null) {
            processed++;
            progress.report("Hashing funscripts", processed, total);
            return (file, null);
          }

          final found = await _analyzeFunscript(file, funscriptHash, existing);
          processed++;
          progress.report("Hashing funscripts", processed, total);
          return (file, found);
        } catch (e, st) {
          Logger.error("Failed to hash/parse funscript", e, st);
        }
        processed++;
        return (file, null);
      });
    }).toList();

    final Map<String, _FoundFunscriptFile> allFoundFunscripts = {};
    await for (var (file, foundFunscript) in Stream.fromFutures(hashed)) {
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
    return allFoundFunscripts;
  }

  /// Builds a [_FoundFunscriptFile], reusing the cached metrics of [existing]
  /// when its analysis is current, otherwise parsing and re-analyzing the file.
  static Future<_FoundFunscriptFile> _analyzeFunscript(
    File file,
    String funscriptHash,
    FunscriptFile? existing,
  ) async {
    if (existing != null &&
        existing.algorithmVersion >= FunscriptAlgorithms.algorithmVersion) {
      return _FoundFunscriptFile(
        file: file,
        funscriptHash: funscriptHash,
        averageSpeed: existing.averageSpeed,
        averageMin: existing.averageMin,
        averageMax: existing.averageMax,
        isScriptToken: existing.isScriptToken,
        metadata: existing.metadata,
      );
    }

    final funscriptJsonText = await file.readAsString();
    final funscript = FunscriptJson.fromJson(jsonDecode(funscriptJsonText));
    final actions = funscript.actions;

    return _FoundFunscriptFile(
      file: file,
      funscriptHash: funscriptHash,
      averageSpeed: FunscriptAlgorithms.averageSpeed(actions),
      averageMin: FunscriptAlgorithms.averageMin(actions),
      averageMax: FunscriptAlgorithms.averageMax(actions),
      isScriptToken: Funscript.isScriptToken(actions),
      metadata: funscript.metadata,
    );
  }

  /// Drops media that has no funscript and isn't already in the database
  /// (existing media is kept so missing files can be tracked).
  static void _pruneEmptyGroups(
    _IndexingParams params,
    Map<String, List<_FoundMediaFile>> groups,
  ) {
    final existingMediaHashes = params.allMediasMap.keys.toSet();
    for (final key in groups.keys.toList()) {
      groups[key]!.removeWhere(
        (m) =>
            m.funscripts.isEmpty && !existingMediaHashes.contains(m.mediaHash),
      );
      if (groups[key]!.isEmpty) groups.remove(key);
    }
  }

  /// Runs ffprobe (pooled) for any grouped media that doesn't already have
  /// metadata, storing the result back on the found-media entry.
  static Future<void> _retrieveMetadata(
    _IndexingParams params,
    Map<String, List<_FoundMediaFile>> groups,
    Pool pool,
    _IndexingProgress progress,
  ) async {
    progress.status("Retrieving metadata...", 0.0);
    int processed = 0;
    final entries = groups.values.expand((list) => list).toList();
    final total = entries.length;

    await Future.wait(
      entries.map((m) {
        return pool.withResource(() async {
          if (!params.mediaHashesWithMetadata.contains(m.mediaHash)) {
            m.metadata = await MediaMetadataRetriever.runFFprobe(m.file.path);
          }
          processed++;
          progress.report(
            "Retrieving metadata",
            processed,
            total,
            interval: _metadataProgressInterval,
          );
        });
      }),
    );
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
