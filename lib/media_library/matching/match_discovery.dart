import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:pool/pool.dart';
import 'package:syncopathy/funscript_algo.dart';
import 'package:syncopathy/helper/trie.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/media_library/matching/match_snapshot.dart';
import 'package:syncopathy/media_library/matching/name_normalizer.dart';
import 'package:syncopathy/media_library/media_file_scanner.dart';
import 'package:syncopathy/model/funscript.dart';
import 'package:syncopathy/model/json/funscript_json.dart';
import 'package:syncopathy/model/json/funscript_metadata.dart';
import 'package:syncopathy/objectbox.g.dart';
import 'package:syncopathy/persistence/entities/funscript_file.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';
import 'package:syncopathy/persistence/fast_file_hash.dart';
import 'package:syncopathy/persistence/service/fast_hash_cache_service.dart';

/// A media file on disk that nothing is linked to.
///
/// Either it is not in the library at all — normal indexing drops media with no
/// funscript — or it is a row whose `funscripts` relation is empty. Both are
/// media a user might still have a script for, and together they are the only
/// pool this tool proposes from.
class UnmatchedMedia {
  final String fileHash;
  final String path;
  final String basename;
  final String directoryLabel;
  final MediaType type;

  /// Known only for media already in the library; new media has no metadata
  /// until something asks ffprobe for it, and this tool deliberately does not.
  final double? durationSeconds;
  final int? width;
  final int? height;

  /// Whether a [MediaFile] row already exists for this hash.
  final bool inLibrary;

  const UnmatchedMedia({
    required this.fileHash,
    required this.path,
    required this.basename,
    required this.directoryLabel,
    required this.type,
    required this.inLibrary,
    this.durationSeconds,
    this.width,
    this.height,
  });

  MediaSnapshot toSnapshot({
    NoiseVocabulary vocabulary = NoiseVocabulary.standard,
  }) => MediaSnapshot(
    fileHash: fileHash,
    basename: basename,
    directoryLabel: directoryLabel,
    durationSeconds: durationSeconds,
    width: width,
    height: height,
    vocabulary: vocabulary,
  );
}

/// A funscript on disk that is not linked to any media.
///
/// Carries everything importing it later needs, so applying a match never has
/// to parse the file a second time.
class UnmatchedFunscript {
  final String funscriptHash;
  final String path;
  final String basename;
  final String directoryLabel;

  final double averageSpeed;
  final double averageMin;
  final double averageMax;
  final bool isScriptToken;

  /// Serialized [FunscriptMetadata], or null. Kept as JSON because the entity
  /// stores it that way and because it crosses an isolate boundary on the way
  /// here.
  final String? metadataJson;

  final String? metadataTitle;
  final List<String> performers;
  final double? metadataDurationSeconds;
  final double? lastActionSeconds;

  /// Whether a [FunscriptFile] row already exists for this hash.
  final bool inLibrary;

  const UnmatchedFunscript({
    required this.funscriptHash,
    required this.path,
    required this.basename,
    required this.directoryLabel,
    required this.averageSpeed,
    required this.averageMin,
    required this.averageMax,
    required this.isScriptToken,
    required this.inLibrary,
    this.metadataJson,
    this.metadataTitle,
    this.performers = const [],
    this.metadataDurationSeconds,
    this.lastActionSeconds,
  });

  FunscriptMetadata? get metadata => metadataJson == null
      ? null
      : FunscriptMetadata.fromJson(jsonDecode(metadataJson!));

  FunscriptSnapshot toSnapshot({
    NoiseVocabulary vocabulary = NoiseVocabulary.standard,
  }) => FunscriptSnapshot(
    funscriptHash: funscriptHash,
    basename: basename,
    directoryLabel: directoryLabel,
    metadataTitle: metadataTitle,
    performers: performers,
    metadataDurationSeconds: metadataDurationSeconds,
    lastActionSeconds: lastActionSeconds,
    vocabulary: vocabulary,
  );
}

/// What a discovery pass found. Everything downstream works from this.
class MatchDiscoveryResult {
  final List<UnmatchedMedia> media;
  final List<UnmatchedFunscript> scripts;

  /// Scripts a normal library refresh would link on its own, because the media
  /// basename trie still resolves them. Excluded from [scripts] — offering a
  /// fuzzy guess for something the deterministic matcher already handles is how
  /// a repair tool starts creating the mess it exists to clean up.
  final int trieResolvableScripts;

  /// Totals for the "what did it look at" line in the UI.
  final int totalMediaFiles;
  final int totalScriptFiles;

  final List<String> skippedPaths;

  const MatchDiscoveryResult({
    required this.media,
    required this.scripts,
    required this.trieResolvableScripts,
    required this.totalMediaFiles,
    required this.totalScriptFiles,
    required this.skippedPaths,
  });

  static const empty = MatchDiscoveryResult(
    media: [],
    scripts: [],
    trieResolvableScripts: 0,
    totalMediaFiles: 0,
    totalScriptFiles: 0,
    skippedPaths: [],
  );
}

/// Progress callback for [MatchDiscovery.run].
typedef DiscoveryProgress = void Function(String status, double? progress);

class _DiscoveryParams {
  final List<String> searchPaths;
  final SendPort progressPort;
  final ByteData storeReference;

  const _DiscoveryParams({
    required this.searchPaths,
    required this.progressPort,
    required this.storeReference,
  });
}

class _DiscoveryUpdate {
  final String status;
  final double? progress;
  const _DiscoveryUpdate(this.status, this.progress);
}

/// Finds the funscripts nothing is linked to, and the media nothing is linked
/// to, by walking the library's search paths.
///
/// It has to walk the filesystem rather than read the database, because normal
/// indexing never stores either side: a funscript that matches no media is
/// skipped, and a media group with no funscript is pruned. The residual this
/// tool exists for is exactly what indexing threw away, so it is only on disk.
///
/// Read-only throughout. Nothing here writes to the database.
class MatchDiscovery {
  static const int _hashPoolSize = 4;
  static const int _progressInterval = 25;

  /// Runs a discovery pass off the UI thread.
  static Future<MatchDiscoveryResult> run({
    required List<String> searchPaths,
    required ByteData storeReference,
    DiscoveryProgress? onProgress,
  }) async {
    final receivePort = ReceivePort();
    final subscription = receivePort.listen((message) {
      if (message is _DiscoveryUpdate) {
        onProgress?.call(message.status, message.progress);
      }
    });

    try {
      return await compute(
        _discover,
        _DiscoveryParams(
          searchPaths: searchPaths,
          progressPort: receivePort.sendPort,
          storeReference: storeReference,
        ),
      );
    } finally {
      await subscription.cancel();
      receivePort.close();
    }
  }

  /// Isolate entry point.
  static Future<MatchDiscoveryResult> _discover(_DiscoveryParams params) async {
    final store = Store.fromReference(
      getObjectBoxModel(),
      params.storeReference,
    );
    final cacheService = FastHashCacheService(store);
    final pool = Pool(_hashPoolSize);

    void report(String status, [double? progress]) {
      params.progressPort.send(_DiscoveryUpdate(status, progress));
    }

    try {
      report('Listing files…');
      final listing = await MediaFileScanner.list(
        params.searchPaths,
        // A walk over a large or remote tree takes long enough that a status
        // line which never changes reads as a hang.
        onProgress: (directories, media, funscripts) => report(
          'Listing files ($directories folders, '
          '$media media, $funscripts funscripts)',
        ),
      );

      // The library as it stands: which hashes exist, and which of those have
      // anything linked. A row with an empty relation counts as unmatched just
      // as much as a file that was never imported.
      final linkedMedia = <String>{};
      final knownMedia = <String, MediaFile>{};
      for (final media in store.box<MediaFile>().getAll()) {
        knownMedia[media.fileHash] = media;
        if (media.funscripts.isNotEmpty) linkedMedia.add(media.fileHash);
      }

      final linkedScripts = <String>{};
      final knownScripts = <String, FunscriptFile>{};
      for (final script in store.box<FunscriptFile>().getAll()) {
        knownScripts[script.funscriptHash] = script;
        if (script.media.isNotEmpty) linkedScripts.add(script.funscriptHash);
      }

      final media = await _collectMedia(
        listing.mediaFiles,
        pool,
        cacheService,
        knownMedia,
        linkedMedia,
        report,
      );

      // The trie is built over *every* media basename, not just the unmatched
      // ones, so it answers the same question normal indexing would.
      final trie = Trie();
      for (final file in listing.mediaFiles) {
        trie.insert(p.basenameWithoutExtension(file.path));
      }

      final (scripts, trieResolvable) = await _collectScripts(
        listing.funscriptFiles,
        pool,
        cacheService,
        knownScripts,
        linkedScripts,
        trie,
        report,
      );

      return MatchDiscoveryResult(
        media: media,
        scripts: scripts,
        trieResolvableScripts: trieResolvable,
        totalMediaFiles: listing.mediaFiles.length,
        totalScriptFiles: listing.funscriptFiles.length,
        skippedPaths: listing.skippedPaths,
      );
    } finally {
      store.close();
    }
  }

  /// Hashes every media file and keeps the ones nothing is linked to.
  static Future<List<UnmatchedMedia>> _collectMedia(
    List<File> files,
    Pool pool,
    FastHashCacheService cacheService,
    Map<String, MediaFile> known,
    Set<String> linked,
    void Function(String, [double?]) report,
  ) async {
    report('Hashing media…', 0.0);
    var processed = 0;
    final total = files.length;

    final hashed = files.map((file) {
      return pool.withResource(() async {
        final hash = await fastFileHash(file, cacheService: cacheService);
        processed++;
        if (processed % _progressInterval == 0 || processed == total) {
          report('Hashing media ($processed/$total)', processed / total);
        }
        return (file, hash);
      });
    }).toList();

    final result = <UnmatchedMedia>[];
    final seen = <String>{};

    await for (final (file, hash) in Stream.fromFutures(hashed)) {
      if (hash == null) continue;
      if (linked.contains(hash)) continue;
      // Two paths, one hash: the same file twice over. Proposing both would ask
      // the user the same question twice and let them answer it differently.
      if (!seen.add(hash)) continue;

      final existing = known[hash];
      final metadata = existing?.metadata.target;
      result.add(
        UnmatchedMedia(
          fileHash: hash,
          path: file.path,
          basename: p.basenameWithoutExtension(file.path),
          directoryLabel: p.basename(p.dirname(file.path)),
          type: MediaFileScanner.typeForPath(file.path),
          inLibrary: existing != null,
          durationSeconds: metadata?.duration,
          width: metadata?.width,
          height: metadata?.height,
        ),
      );
    }
    return result;
  }

  /// Hashes every funscript, drops the ones already linked or resolvable by the
  /// trie, and parses what is left.
  ///
  /// Parsing is confined to the residual on purpose: it is a JSON decode of an
  /// action array, which is far too expensive to do for a whole library and
  /// perfectly affordable for the handful that failed to match.
  static Future<(List<UnmatchedFunscript>, int)> _collectScripts(
    List<File> files,
    Pool pool,
    FastHashCacheService cacheService,
    Map<String, FunscriptFile> known,
    Set<String> linked,
    Trie trie,
    void Function(String, [double?]) report,
  ) async {
    report('Hashing funscripts…', 0.0);
    var processed = 0;
    var trieResolvable = 0;
    final total = files.length;

    final hashed = files.map((file) {
      return pool.withResource(() async {
        try {
          final hash = await fastFileHash(file, cacheService: cacheService);
          return (file, hash);
        } catch (e, st) {
          Logger.error('Failed to hash funscript: ${file.path}', e, st);
          return (file, null);
        } finally {
          processed++;
          if (processed % _progressInterval == 0 || processed == total) {
            report('Hashing funscripts ($processed/$total)', processed / total);
          }
        }
      });
    }).toList();

    final residual = <(File, String)>[];
    final seen = <String>{};

    await for (final (file, hash) in Stream.fromFutures(hashed)) {
      if (hash == null) continue;
      if (linked.contains(hash)) continue;
      if (!seen.add(hash)) continue;

      if (trie.findLongestPrefix(p.basenameWithoutExtension(file.path)) !=
          null) {
        trieResolvable++;
        continue;
      }
      residual.add((file, hash));
    }

    report('Reading funscripts…', 0.0);
    var parsed = 0;
    final analyzed = residual.map((entry) {
      final (file, hash) = entry;
      return pool.withResource(() async {
        final result = await _analyze(file, hash, known[hash]);
        parsed++;
        report(
          'Reading funscripts ($parsed/${residual.length})',
          parsed / residual.length,
        );
        return result;
      });
    }).toList();

    final scripts = <UnmatchedFunscript>[];
    for (final script in await Future.wait(analyzed)) {
      if (script != null) scripts.add(script);
    }

    // Ordered so the list a user reads is the same on every run.
    scripts.sort((a, b) => a.path.toLowerCase().compareTo(b.path.toLowerCase()));
    return (scripts, trieResolvable);
  }

  static Future<UnmatchedFunscript?> _analyze(
    File file,
    String hash,
    FunscriptFile? existing,
  ) async {
    try {
      final json = FunscriptJson.fromJson(jsonDecode(await file.readAsString()));
      final actions = json.actions;
      final metadata = json.metadata ?? existing?.metadata;

      // A script's metadata duration is authored; its last action is derived.
      // Both are only ever supporting evidence, so an absent one is fine.
      final metadataDuration = metadata?.duration;
      final lastAction = actions.isEmpty
          ? null
          : actions
                .map((a) => a.at)
                .reduce((a, b) => a > b ? a : b);

      return UnmatchedFunscript(
        funscriptHash: hash,
        path: file.path,
        basename: p.basenameWithoutExtension(file.path),
        directoryLabel: p.basename(p.dirname(file.path)),
        averageSpeed: FunscriptAlgorithms.averageSpeed(actions),
        averageMin: FunscriptAlgorithms.averageMin(actions),
        averageMax: FunscriptAlgorithms.averageMax(actions),
        isScriptToken: Funscript.isScriptToken(actions),
        inLibrary: existing != null,
        metadataJson: metadata == null ? null : jsonEncode(metadata.toJson()),
        metadataTitle: _blankToNull(metadata?.title),
        performers: metadata?.performers
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList() ??
            const [],
        metadataDurationSeconds:
            metadataDuration == null || metadataDuration <= 0
            ? null
            : metadataDuration.toDouble(),
        lastActionSeconds: lastAction == null ? null : lastAction / 1000.0,
      );
    } catch (e, st) {
      // A script that will not parse is not a match problem; skip it rather
      // than fail the whole pass.
      Logger.error('Failed to read funscript: ${file.path}', e, st);
      return null;
    }
  }

  static String? _blankToNull(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}
