import 'dart:io';

import 'package:syncopathy/funscript_algo.dart';
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/media_library/matching/match_draft.dart';
import 'package:syncopathy/media_library/matching/match_discovery.dart';
import 'package:syncopathy/media_library/media_metadata_retriever.dart';
import 'package:syncopathy/objectbox.g.dart';
import 'package:syncopathy/persistence/entities/funscript_file.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';
import 'package:syncopathy/persistence/fast_file_hash.dart';

/// One relation an Apply created, and everything undoing it needs.
///
/// Recorded per link rather than per match so a revert puts back exactly what
/// was written: a video that already existed keeps its other scripts, a video
/// this tool imported disappears again, and a main-script slot that was filled
/// here is emptied rather than re-picked.
class AppliedLink {
  final int mediaId;
  final int funscriptId;

  /// The script basename added to the media's search aliases, if any.
  final String? addedAlias;

  /// Whether this Apply set the media's main script to [funscriptId].
  final bool becameMainScript;

  /// Whether this Apply created the row, rather than reusing an existing one.
  final bool createdMedia;
  final bool createdFunscript;

  const AppliedLink({
    required this.mediaId,
    required this.funscriptId,
    required this.addedAlias,
    required this.becameMainScript,
    required this.createdMedia,
    required this.createdFunscript,
  });
}

/// What applying a batch of accepted matches did.
class MatchApplyOutcome {
  /// Funscripts linked, counting multi-axis companions individually.
  final int linkedScripts;

  /// Media that gained at least one script.
  final int linkedMedia;

  /// Matches dropped because a file moved, changed or vanished between review
  /// and Apply. Named by script basename, which is what the reviewer saw.
  final List<String> invalidated;

  /// Every relation written, in the order it was written. Kept so the whole
  /// batch can be undone.
  final List<AppliedLink> links;

  const MatchApplyOutcome({
    required this.linkedScripts,
    required this.linkedMedia,
    required this.invalidated,
    this.links = const [],
  });

  bool get isEmpty => linkedScripts == 0 && invalidated.isEmpty;
  bool get isRevertable => links.isNotEmpty;
}

/// One accepted match that survived revalidation, with the files re-checked.
class _Validated {
  final UnmatchedMedia media;
  final List<UnmatchedFunscript> scripts;
  _Validated(this.media, this.scripts);
}

/// Turns accepted decisions into database relations.
///
/// This is the only part of the tool that writes, and it writes once: every
/// accepted match lands in a single transaction, so a failure part-way through
/// leaves the library exactly as it was rather than half-repaired.
class MatchApplier {
  /// Applies [accepted], revalidating every file first.
  ///
  /// Revalidation is not paranoia about a race: a review session can sit open
  /// for a long time, and a decision made about a file is meaningless once that
  /// file's content has changed. Hashes are recomputed rather than trusted.
  static Future<MatchApplyOutcome> apply(
    List<AcceptedMatch> accepted, {
    required Map<String, UnmatchedMedia> mediaByHash,
    required Map<String, UnmatchedFunscript> scriptsByHash,
  }) async {
    final validated = <_Validated>[];
    final invalidated = <String>[];

    for (final match in accepted) {
      final media = mediaByHash[match.mediaHash];
      if (media == null || !await _stillMatches(media.path, media.fileHash)) {
        invalidated.add(match.proposal.script.basename);
        continue;
      }

      final scripts = <UnmatchedFunscript>[];
      var ok = true;
      for (final hash in match.funscriptHashes) {
        final script = scriptsByHash[hash];
        if (script == null || !await _stillMatches(script.path, hash)) {
          ok = false;
          break;
        }
        scripts.add(script);
      }
      if (!ok || scripts.isEmpty) {
        invalidated.add(match.proposal.script.basename);
        continue;
      }

      validated.add(_Validated(media, scripts));
    }

    // ffprobe before the transaction, not inside it: a write transaction that
    // waits on a subprocess holds the database for as long as ffmpeg feels like
    // taking.
    final metadata = await _probeNewMedia(validated);

    final touchedMedia = <int>{};
    final links = <AppliedLink>[];

    if (validated.isNotEmpty) {
      oBox.store.runInTransaction(TxMode.write, () {
        final mediaBox = oBox.store.box<MediaFile>();
        final funscriptBox = oBox.store.box<FunscriptFile>();

        for (final entry in validated) {
          final (media, createdMedia) = _resolveMedia(
            mediaBox,
            entry.media,
            metadata,
          );

          final added = <(FunscriptFile, bool, String?)>[];
          for (final script in entry.scripts) {
            final (funscript, createdFunscript) = _resolveFunscript(
              funscriptBox,
              script,
            );
            if (media.funscripts.any((f) => f.id == funscript.id)) continue;
            media.funscripts.add(funscript);

            // The script's own name becomes a search alias, so the association
            // is findable by the name the user knew it under.
            final alias = media.aliases.contains(script.basename)
                ? null
                : script.basename;
            if (alias != null) media.aliases.add(alias);

            added.add((funscript, createdFunscript, alias));
          }

          // Only ever fills an empty slot. A media that already has a main
          // script keeps it — this tool adds scripts, it does not re-pick for
          // media the user has already set up.
          int? newMainId;
          if (media.mainFunscript.target == null &&
              media.funscripts.isNotEmpty) {
            final main = pickMainFunscript(media.funscripts);
            media.mainFunscript.target = main;
            newMainId = main?.id;
          }

          mediaBox.put(media);
          touchedMedia.add(media.id);

          var first = true;
          for (final (funscript, createdFunscript, alias) in added) {
            links.add(
              AppliedLink(
                mediaId: media.id,
                funscriptId: funscript.id,
                addedAlias: alias,
                becameMainScript: newMainId == funscript.id,
                // Attributed to the first link only, so undoing one link of a
                // media does not try to delete a row the others still use.
                createdMedia: createdMedia && first,
                createdFunscript: createdFunscript,
              ),
            );
            first = false;
          }
        }
      });
    }

    return MatchApplyOutcome(
      linkedScripts: links.length,
      linkedMedia: touchedMedia.length,
      invalidated: invalidated,
      links: links,
    );
  }

  /// Undoes an Apply, link by link, in one transaction.
  ///
  /// Applying a session can link dozens of files at once, and a mistake spread
  /// across that many rows is not something anyone wants to unpick by hand.
  /// Files on disk are never touched, here or anywhere else in this tool.
  ///
  /// Returns how many relations were removed.
  static int revert(List<AppliedLink> links) {
    if (links.isEmpty) return 0;

    var removed = 0;
    oBox.store.runInTransaction(TxMode.write, () {
      final mediaBox = oBox.store.box<MediaFile>();
      final funscriptBox = oBox.store.box<FunscriptFile>();

      // Grouped by media so both relation edges are applied to one instance
      // rather than two loads overwriting each other.
      final byMedia = <int, List<AppliedLink>>{};
      for (final link in links) {
        byMedia.putIfAbsent(link.mediaId, () => []).add(link);
      }

      final orphanedFunscripts = <int>{};
      final orphanedMedia = <int>{};

      for (final entry in byMedia.entries) {
        final media = mediaBox.get(entry.key);
        if (media == null) continue;

        for (final link in entry.value) {
          final before = media.funscripts.length;
          media.funscripts.removeWhere((f) => f.id == link.funscriptId);
          if (media.funscripts.length != before) removed++;

          if (link.becameMainScript &&
              media.mainFunscript.targetId == link.funscriptId) {
            // Emptied rather than re-picked: the slot was empty before this
            // Apply filled it, and that is the state being restored.
            media.mainFunscript.target = null;
          }
          if (link.addedAlias case final alias?) {
            media.aliases.remove(alias);
          }
          if (link.createdFunscript) orphanedFunscripts.add(link.funscriptId);
          if (link.createdMedia) orphanedMedia.add(link.mediaId);
        }

        mediaBox.put(media);
      }

      // Rows this Apply brought into existence go back out of existence —
      // indexing would not have kept them, so leaving them behind would be a
      // visible side effect of an undone action.
      for (final id in orphanedFunscripts) {
        final funscript = funscriptBox.get(id);
        if (funscript != null && funscript.media.isEmpty) {
          funscriptBox.remove(id);
        }
      }
      for (final id in orphanedMedia) {
        final media = mediaBox.get(id);
        if (media != null && media.funscripts.isEmpty) {
          mediaBox.remove(id);
        }
      }
    });

    return removed;
  }

  /// Whether the file at [path] is still there and still hashes to [hash].
  static Future<bool> _stillMatches(String path, String hash) async {
    try {
      final file = File(path);
      if (!await file.exists()) return false;
      return await fastFileHash(file) == hash;
    } catch (e, st) {
      Logger.error('Failed to revalidate $path', e, st);
      return false;
    }
  }

  /// Runs ffprobe for media this tool is about to import for the first time.
  ///
  /// Normal indexing only ever probes media it keeps, and it does not keep
  /// media without a script — so anything being rescued here has never been
  /// looked at. Bounded by the size of the accepted batch.
  static Future<Map<String, MediaMetadataRetrieved>> _probeNewMedia(
    List<_Validated> validated,
  ) async {
    final result = <String, MediaMetadataRetrieved>{};
    for (final entry in validated) {
      if (entry.media.inLibrary) continue;
      if (result.containsKey(entry.media.fileHash)) continue;
      final metadata = await MediaMetadataRetriever.runFFprobe(
        entry.media.path,
      );
      if (metadata != null) result[entry.media.fileHash] = metadata;
    }
    return result;
  }

  /// The [MediaFile] for [found], reusing the existing row when there is one.
  ///
  /// Reuse is by hash rather than by path, so a file that has merely moved
  /// keeps its rating, categories and play count instead of coming back as a
  /// stranger.
  static (MediaFile, bool created) _resolveMedia(
    Box<MediaFile> box,
    UnmatchedMedia found,
    Map<String, MediaMetadataRetrieved> metadata,
  ) {
    final query = box.query(MediaFile_.fileHash.equals(found.fileHash)).build();
    final existing = query.findFirst();
    query.close();

    if (existing != null) {
      existing.mediaPath = found.path;
      existing.fileNotFound = false;
      existing.firstIndexedOn ??= DateTime.now();
      if (!existing.aliases.contains(found.basename)) {
        existing.aliases.add(found.basename);
      }
      return (existing, false);
    }

    final media = MediaFile(
      name: found.basename,
      mediaPath: found.path,
      fileHash: found.fileHash,
      playCount: 0,
      fileNotFound: false,
      type: found.type,
      aliases: [found.basename],
    )..firstIndexedOn = DateTime.now();

    final probed = metadata[found.fileHash];
    if (probed != null) media.metadata.target = probed.toEntity();

    box.put(media); // Put to get an id before the relation is written.
    return (media, true);
  }

  /// The [FunscriptFile] for [found], reusing the existing row when there is
  /// one. Everything needed to create it was read during discovery, so nothing
  /// here parses the file again.
  static (FunscriptFile, bool created) _resolveFunscript(
    Box<FunscriptFile> box,
    UnmatchedFunscript found,
  ) {
    final query = box
        .query(FunscriptFile_.funscriptHash.equals(found.funscriptHash))
        .build();
    final existing = query.findFirst();
    query.close();

    if (existing != null) {
      existing.path = found.path;
      existing.fileNotFound = false;
      existing.firstIndexedOn ??= DateTime.now();
      return (existing, false);
    }

    final funscript =
        FunscriptFile(
            path: found.path,
            averageSpeed: found.averageSpeed,
            averageMin: found.averageMin,
            averageMax: found.averageMax,
            isScriptToken: found.isScriptToken,
            fileNotFound: false,
            funscriptHash: found.funscriptHash,
            metadata: found.metadata,
          )
          ..algorithmVersion = FunscriptAlgorithms.algorithmVersion
          ..firstIndexedOn = DateTime.now();

    box.put(funscript); // Put to get an id before the relation is written.
    return (funscript, true);
  }
}
