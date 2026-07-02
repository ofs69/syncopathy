import 'package:syncopathy/persistence/entities/funscript_file.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';
import 'package:syncopathy/persistence/entities/user_category.dart';
import 'package:syncopathy/persistence/service/funscript_service.dart';
import 'package:syncopathy/persistence/service/media_service.dart';

/// A thin command layer between the UI and the persistence services.
///
/// Widgets call intent-named operations here (toggle a rating, add a category,
/// reset a play count) instead of mutating entity fields and calling `save`
/// inline, so the mutate-then-persist pairing lives in one place rather than
/// being copy-pasted across the widget tree.
class MediaRepository {
  final MediaService _mediaService;
  final FunscriptService _funscriptService;

  MediaRepository(this._mediaService, this._funscriptService);

  // --- Rating ---

  void setRating(MediaFile media, MediaRating rating) {
    media.rating = rating;
    _mediaService.save(media);
  }

  /// Applies [rating], or clears it back to [MediaRating.noRating] when the
  /// media already has it (used by the favorite/dislike toggle buttons).
  void toggleRating(MediaFile media, MediaRating rating) {
    setRating(media, media.rating == rating ? MediaRating.noRating : rating);
  }

  void bulkSetRating(Iterable<MediaFile> medias, MediaRating rating) {
    final list = medias.toList();
    for (final m in list) {
      m.rating = rating;
    }
    _mediaService.saveMany(list);
  }

  // --- Play count ---

  void incrementPlayCount(MediaFile media) {
    media.playCount += 1;
    _mediaService.save(media);
  }

  void bulkResetPlayCount(Iterable<MediaFile> medias) {
    final list = medias.toList();
    for (final m in list) {
      m.playCount = 0;
    }
    _mediaService.saveMany(list);
  }

  void resetAllPlayCounts() => _mediaService.resetAllVideosPlayCount();

  // --- Categories ---

  void addCategory(MediaFile media, UserCategory category) {
    media.categories.add(category);
    _mediaService.save(media);
  }

  void removeCategory(MediaFile media, int categoryId) {
    media.categories.removeWhere((c) => c.id == categoryId);
    _mediaService.save(media);
  }

  void bulkAddCategory(Iterable<MediaFile> medias, UserCategory category) {
    final list = medias.toList();
    for (final m in list) {
      m.categories.add(category);
    }
    _mediaService.saveMany(list);
  }

  void bulkRemoveCategory(Iterable<MediaFile> medias, int categoryId) {
    final list = medias.toList();
    for (final m in list) {
      m.categories.removeWhere((c) => c.id == categoryId);
    }
    _mediaService.saveMany(list);
  }

  // --- Thumbnail state ---

  void setThumbnailGenerationFailed(MediaFile media, bool failed) {
    media.thumbnailGenerationFailed = failed;
    _mediaService.save(media);
  }

  // --- Persisting edits composed by the caller ---
  //
  // The media detail page and the move dialog mutate several fields (or move
  // files) and then persist; these route those writes through the repository
  // rather than reaching for the services directly.

  void save(MediaFile media) => _mediaService.save(media);

  void saveFunscript(FunscriptFile funscript) =>
      _funscriptService.save(funscript);

  void saveFunscripts(List<FunscriptFile> funscripts) =>
      _funscriptService.saveMany(funscripts);

  void remove(int mediaId) => _mediaService.remove(mediaId);
}
