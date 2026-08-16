import 'package:collection/collection.dart';
import 'package:syncopathy/objectbox.g.dart';
import 'package:syncopathy/persistence/entities/fast_hash_cache.dart';
import 'package:syncopathy/persistence/entities/funscript_file.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';
import 'package:syncopathy/persistence/entities/media_metadata.dart';
import 'package:syncopathy/persistence/service/funscript_service.dart';

/// Everything a library cleanup would drop, gathered before anything is
/// written so the file-backed part can be shown to the user first.
class LibraryCleanupPlan {
  /// Media that cannot play for a reason removal resolves — the file is gone,
  /// or it has no usable script left. Script tokens are never in here.
  final List<MediaFile> media;

  /// Funscripts whose file is gone, plus those no surviving media links.
  final List<FunscriptFile> funscripts;

  /// Metadata records no surviving media points at.
  final List<int> metadataIds;

  /// Cached file hashes for paths no surviving record refers to.
  final List<int> hashCacheIds;

  const LibraryCleanupPlan({
    required this.media,
    required this.funscripts,
    required this.metadataIds,
    required this.hashCacheIds,
  });

  bool get isEmpty =>
      media.isEmpty &&
      funscripts.isEmpty &&
      metadataIds.isEmpty &&
      hashCacheIds.isEmpty;

  /// Records with no file of their own, so they are reported as a count rather
  /// than listed for review.
  int get orphanRecordCount => metadataIds.length + hashCacheIds.length;
}

/// Database-only maintenance for the media library: repairs what it can and
/// works out what is left to drop. Never touches a file on disk.
class LibraryCleanupService {
  final Store _store;
  final FunscriptService _funscriptService;

  LibraryCleanupService(this._store, this._funscriptService);

  /// Re-points media whose main script is unusable — unset, dangling, or a
  /// script whose file is gone — at the best script the media still has,
  /// preferring one that can actually play. This runs before [buildPlan] so an
  /// entry that is merely mislinked is repaired instead of removed.
  ///
  /// Returns the number of media that got a working main script back. A
  /// dangling link with nothing left to point at is cleared but not counted:
  /// that entry is broken either way, and the plan decides its fate.
  int repairMainFunscriptLinks() {
    final mediaBox = _store.box<MediaFile>();
    final changed = <MediaFile>[];
    var repointed = 0;

    for (final media in mediaBox.getAll()) {
      final targetId = media.mainFunscript.targetId;
      final main = media.mainFunscript.target;
      if (main != null && !main.fileNotFound) continue;

      final usable = media.funscripts.where((f) => !f.fileNotFound);
      final replacement =
          usable.firstWhereOrNull((f) => !f.isScriptToken) ??
          usable.firstOrNull;

      if (replacement != null) {
        if (replacement.id == targetId) continue;
        media.mainFunscript.target = replacement;
        repointed++;
      } else if (main == null && targetId != 0) {
        // Dangling: the record it named is already gone. Clear it so the entry
        // reports honestly instead of pointing at nothing.
        media.mainFunscript.target = null;
      } else {
        // Nothing usable to point at; the plan decides what happens to it.
        continue;
      }
      changed.add(media);
    }

    mediaBox.putMany(changed);
    return repointed;
  }

  LibraryCleanupPlan buildPlan() {
    final mediaBox = _store.box<MediaFile>();
    final funscriptBox = _store.box<FunscriptFile>();

    final allMedia = mediaBox.getAll();
    final allFunscripts = funscriptBox.getAll();

    final media = allMedia.where((m) {
      final reason = m.unplayable;
      return reason != null && reason != UnplayableReason.scriptToken;
    }).toList();
    final removedMediaIds = media.map((m) => m.id).toSet();

    final funscripts = allFunscripts.where((f) {
      if (f.fileNotFound) return true;
      // Orphaned once the media above are gone — `every` also covers scripts
      // that are already linked to nothing.
      return f.media.every((m) => removedMediaIds.contains(m.id));
    }).toList();
    final removedFunscriptIds = funscripts.map((f) => f.id).toSet();

    final survivingMedia = allMedia.where(
      (m) => !removedMediaIds.contains(m.id),
    );
    final survivingFunscripts = allFunscripts.where(
      (f) => !removedFunscriptIds.contains(f.id),
    );

    final referencedMetadata = survivingMedia
        .map((m) => m.metadata.targetId)
        .where((id) => id != 0)
        .toSet();
    final metadataIds = _store
        .box<MediaMetadata>()
        .getAll()
        .map((e) => e.id)
        .where((id) => !referencedMetadata.contains(id))
        .toList();

    // The hash cache is keyed by path and nothing ever prunes it, so entries
    // pile up for files no record mentions any more.
    final referencedPaths = {
      ...survivingMedia.map((m) => m.mediaPath),
      ...survivingFunscripts.map((f) => f.path),
    };
    final hashCacheIds = _store
        .box<FastHashCache>()
        .getAll()
        .where((c) => !referencedPaths.contains(c.path))
        .map((c) => c.id)
        .toList();

    return LibraryCleanupPlan(
      media: media,
      funscripts: funscripts,
      metadataIds: metadataIds,
      hashCacheIds: hashCacheIds,
    );
  }

  /// Applies [plan]. Each step is transactional on its own and the whole thing
  /// is idempotent, so an interrupted run only leaves work for the next one.
  void apply(LibraryCleanupPlan plan) {
    // Funscripts first: that detaches them from every media that links them,
    // including the ones removed right after.
    _funscriptService.removeMany(plan.funscripts);
    _store.box<MediaFile>().removeMany(plan.media.map((m) => m.id).toList());
    _store.box<MediaMetadata>().removeMany(plan.metadataIds);
    _store.box<FastHashCache>().removeMany(plan.hashCacheIds);
  }
}
