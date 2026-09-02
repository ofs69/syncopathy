import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:syncopathy/heresphere/heresphere_library.dart';
import 'package:syncopathy/heresphere/heresphere_projection.dart';
import 'package:syncopathy/heresphere/library_sections.dart';
import 'package:syncopathy/heresphere/thumbnail_decorator.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/media_library/media_badge.dart';
import 'package:syncopathy/media_library/thumbnail_generator.dart';
import 'package:syncopathy/model/funscript.dart';
import 'package:syncopathy/model/json/funscript_json.dart';
import 'package:syncopathy/model/media_filter_presets_model.dart';
import 'package:syncopathy/persistence/entities/funscript_file.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';
import 'package:syncopathy/persistence/service/media_service.dart';
import 'package:syncopathy/persistence/service/user_category_service.dart';

/// How many decorated thumbnails to keep.
///
/// Decorating means decoding a JPEG, drawing, and re-encoding a PNG, which is
/// far too much to repeat every time a headset scrolls past an entry. Bounded
/// because the library can be tens of thousands of entries and this holds
/// encoded images.
const int _thumbnailCacheSize = 128;

/// Publishes the indexed media library over the HereSphere API.
///
/// Only entries whose file is present are listed, and only by their stable
/// hash: nothing here accepts or exposes a path, so a client cannot name a file
/// the library does not already hold.
class MediaLibraryHereSphereSource implements HereSphereLibrary {
  final MediaService _mediaService;

  /// Categories become sections, so the headset browses the library the way it
  /// is organised here. Optional: without it the feature still works, it just
  /// publishes the two default sections.
  final UserCategoryService? _categories;

  final ThumbnailGenerator _thumbnails;

  /// Whether to draw badges and a heatmap over published thumbnails. Read
  /// through a callback rather than captured, so toggling the setting takes
  /// effect on the next request without rebuilding the library source.
  final bool Function() _decorateThumbnails;

  /// The badges the media library is currently configured to show, by id. The
  /// same list, so a badge turned off on the cards is off in the headset too.
  final List<String> Function() _enabledBadgeIds;

  /// The user's saved filter presets, each published as a section. Read through
  /// a callback so one saved, renamed or deleted on the desktop is reflected by
  /// the next request rather than at the next restart.
  final List<MediaFilterPreset> Function() _presets;

  /// Decorated thumbnails, keyed by a signature of everything that affects how
  /// one is drawn. Insertion-ordered, evicted oldest-first.
  final Map<String, HereSphereThumbnail> _decorated = {};

  MediaLibraryHereSphereSource(
    this._mediaService, {
    UserCategoryService? categories,
    ThumbnailGenerator? thumbnails,
    bool Function()? decorateThumbnails,
    List<String> Function()? enabledBadgeIds,
    List<MediaFilterPreset> Function()? presets,
  }) : _categories = categories,
       _thumbnails = thumbnails ?? ThumbnailGenerator(),
       _decorateThumbnails = decorateThumbnails ?? (() => true),
       _enabledBadgeIds = enabledBadgeIds ?? (() => defaultBadgeIds),
       _presets = presets ?? (() => const []);

  @override
  List<HereSphereSection> sections() {
    final playable = _playable();

    // Scripted media apart from the rest, and named for it: that is what
    // Syncopathy is for, and it is the half a user is looking for in the
    // headset.
    final interactive = <MediaFile>[];
    final rest = <MediaFile>[];
    for (final media in playable) {
      (hasPlayableFunscript(media) ? interactive : rest).add(media);
    }

    // Ordered by the question each answers. The shelves and the user's own
    // saved queries answer "what do I watch now", which is what a headset gets
    // opened with; the complete lists below them answer "where is that file",
    // which the player's own search over `/scan` answers better than any list
    // of several thousand entries can.
    return withDistinctNames([
      for (final shelf in hereSphereShelves(playable))
        HereSphereSection(name: shelf.name, entries: _toEntries(shelf.media)),
      for (final shelf in hereSpherePresetShelves(playable, _presets()))
        HereSphereSection(name: shelf.name, entries: _toEntries(shelf.media)),
      if (interactive.isNotEmpty)
        HereSphereSection(
          name: 'Interactive',
          entries: _toEntries(_sorted(interactive)),
        ),
      if (rest.isNotEmpty)
        HereSphereSection(
          name: 'Other Videos',
          entries: _toEntries(_sorted(rest)),
        ),
      ..._categorySections(),
    ]);
  }

  /// One section per user category, in the order they are arranged here.
  ///
  /// Categories are how the library is already organised, so republishing them
  /// costs nothing and saves scrolling one enormous list in a headset. Empty
  /// categories are skipped: a section with nothing in it is only a dead end to
  /// navigate into.
  List<HereSphereSection> _categorySections() {
    final service = _categories;
    if (service == null) return const [];

    final sections = <HereSphereSection>[];
    for (final category in service.getAllUserCategories()) {
      final entries = category.entries
          .where(
            (media) => !media.fileNotFound && media.type != MediaType.audio,
          )
          .toList();
      if (entries.isEmpty) continue;
      sections.add(
        HereSphereSection(
          name: category.name,
          entries: _toEntries(_sorted(entries)),
        ),
      );
    }
    return sections;
  }

  static List<MediaFile> _sorted(List<MediaFile> media) =>
      media
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

  @override
  List<HereSphereEntry> allEntries() => _toEntries(_sorted(_playable()));

  /// Everything present and watchable. Audio is excluded throughout: HereSphere
  /// is a video player, and an entry it cannot open is only a dead end.
  List<MediaFile> _playable() => _mediaService.allMediaFiles.value
      .where((media) => !media.fileNotFound && media.type != MediaType.audio)
      .toList();

  @override
  HereSphereEntry? entryById(String id) {
    // A hash lookup, never a path. An id we did not issue simply resolves to
    // nothing.
    final media = _mediaService.getByHash(id);
    if (media == null || media.fileNotFound) return null;
    return _toEntry(media);
  }

  @override
  Future<HereSphereThumbnail?> thumbnail(HereSphereEntry entry) async {
    final media = _mediaService.getByHash(entry.id);
    if (media == null) return null;

    final badges = _decorateThumbnails()
        ? resolveBadges(_enabledBadgeIds())
        : const <BadgeSpec>[];
    final signature = _thumbnailSignature(media, badges);

    final cached = _decorated[signature];
    if (cached != null) {
      // Move to the back so the entries a headset is actually scrolling
      // through are the ones that survive eviction.
      _decorated.remove(signature);
      _decorated[signature] = cached;
      return cached;
    }

    // Reuses the cache the library grid already fills; a miss queues one
    // generation behind whatever the UI has running.
    final source = await _thumbnails
        .addRequest(ThumbnailRequest(file: media))
        .result;
    if (source == null) return null;

    final plain = HereSphereThumbnail(source, 'image/jpeg');
    if (!_decorateThumbnails()) return plain;

    final overlay = HereSphereThumbnailOverlay(
      badges: badges,
      heatmapActions: await _heatmapActions(media),
      durationSeconds: media.metadata.target?.duration,
    );
    final decorated = await decorateThumbnail(
      source: source,
      media: media,
      overlay: overlay,
    );

    // Nothing to draw, or drawing failed: the plain picture is still the right
    // answer, and it is not worth a cache slot the decorated ones need.
    if (decorated == null) return plain;

    final result = HereSphereThumbnail(decorated, 'image/png');
    _decorated[signature] = result;
    while (_decorated.length > _thumbnailCacheSize) {
      _decorated.remove(_decorated.keys.first);
    }
    return result;
  }

  /// Everything that changes what a decorated thumbnail looks like.
  ///
  /// A rating, a play count or a swapped script all change a badge, so the
  /// cached picture has to fall out of date with them; keying on the media hash
  /// alone would leave a stale badge on screen until the app restarted.
  String _thumbnailSignature(MediaFile media, List<BadgeSpec> badges) {
    final main = media.mainFunscript.target;
    return [
      media.fileHash,
      for (final badge in badges) badge.id,
      media.playCount,
      media.rating?.id,
      media.funscripts.length,
      main?.funscriptHash ?? '',
      media.metadata.target?.duration ?? '',
    ].join('|');
  }

  /// Actions for the heatmap strip, or empty when there is no script to draw.
  ///
  /// Read straight off disk rather than from the entity: the database keeps
  /// aggregate metrics, not the samples a heatmap needs. Failures are empty,
  /// not fatal — a thumbnail without a strip is still a thumbnail.
  Future<List<FunscriptAction>> _heatmapActions(MediaFile media) async {
    final main = media.mainFunscript.target;
    if (main == null || main.fileNotFound || main.isScriptToken) {
      return const [];
    }
    try {
      final funscript = await Funscript.fromFile(main.path);
      return funscript?.json.actions ?? const [];
    } catch (e) {
      Logger.debug('HereSphere: no heatmap for ${media.fileHash}: $e');
      return const [];
    }
  }

  @override
  List<HereSphereScript> scripts(HereSphereEntry entry) {
    final media = _mediaService.getByHash(entry.id);
    if (media == null) return const [];
    final files = playableScripts(media);
    return [
      for (var i = 0; i < files.length; i++)
        HereSphereScript(index: i, name: _scriptName(files[i], media)),
    ];
  }

  @override
  Future<Uint8List?> scriptBytes(HereSphereEntry entry, int index) async {
    final media = _mediaService.getByHash(entry.id);
    if (media == null) return null;
    final files = playableScripts(media);
    if (index < 0 || index >= files.length) return null;
    try {
      return await File(files[index].path).readAsBytes();
    } catch (_) {
      // Indexed but unreadable. The caller turns this into a 404 rather than
      // naming the path in a response.
      return null;
    }
  }

  /// A name for the script, which for a multi-axis set is the axis suffix.
  ///
  /// `clip.twist.funscript` beside `clip.funscript` reads as "twist"; a lone
  /// script is just "Script", since its filename only repeats the video's.
  static String _scriptName(FunscriptFile script, MediaFile media) {
    final base = p.basenameWithoutExtension(script.path);
    final mediaBase = p.basenameWithoutExtension(media.mediaPath);
    if (base.length > mediaBase.length &&
        base.toLowerCase().startsWith(mediaBase.toLowerCase())) {
      final suffix = base
          .substring(mediaBase.length)
          .replaceAll('.', ' ')
          .trim();
      if (suffix.isNotEmpty) return suffix;
    }
    return identical(script, media.mainFunscript.target) ? 'Script' : base;
  }

  /// Every entry in the section, with no cap.
  ///
  /// An earlier version published at most five hundred per section, on the
  /// theory that a headset should not be handed an enormous index. That was
  /// the wrong trade: the index carries nothing but a URL per entry, and
  /// silently truncating a library is far worse than a larger response —
  /// the missing half looks like media that failed to index. The bulk
  /// metadata now goes over [allEntries] in one request instead.
  List<HereSphereEntry> _toEntries(List<MediaFile> media) => [
    for (final file in media) _toEntry(file),
  ];

  HereSphereEntry _toEntry(MediaFile media) {
    final metadata = media.metadata.target;
    return HereSphereEntry(
      id: media.fileHash,
      title: media.name,
      mediaPath: media.mediaPath,
      durationSeconds: metadata?.duration,
      width: metadata?.width,
      height: metadata?.height,
      addedOn: media.firstIndexedOn,
      rating: _starsFor(media.rating),
      isFavorite: media.isFavorite,
      hasFunscript: hasPlayableFunscript(media),
      playCount: media.playCount,
      tags: _tagsFor(media),
      // From the name on disk, not the library title: renaming an entry in
      // Syncopathy must not lose the layout the file itself declares, and the
      // player never sees the filename because media is served by identifier.
      projection: detectHereSphereProjection(p.basename(media.mediaPath)),
    );
  }

  /// Searchable labels for one entry, each `Group:Value`.
  ///
  /// HereSphere offers every distinct group as its own filter, so this is the
  /// whole of what a user can narrow a large library down by in the headset.
  /// The groups are chosen to answer the questions this library is actually
  /// browsed with — is it scripted, how fast, have I watched it, which
  /// category — rather than to mirror every column Syncopathy stores.
  static List<String> _tagsFor(MediaFile media) {
    final tags = <String>[];

    for (final category in media.categories) {
      tags.add('Category:${category.name}');
    }

    final main = media.mainFunscript.target;
    final scripted = hasPlayableFunscript(media);
    tags.add('Interactive:${scripted ? 'Yes' : 'No'}');

    if (scripted && main != null) {
      tags.add('Speed:${_speedBand(main.averageSpeed)}');
      tags.add('Range:${_rangeBand(main.averageMin, main.averageMax)}');
      if (main.isAiGenerated) tags.add('Script:AI Generated');
      final axes = playableScripts(media).length;
      if (axes > 1) tags.add('Script:Multi-Axis');
    }

    final height = media.metadata.target?.height;
    if (height != null && height > 0) tags.add('Resolution:${_tier(height)}');

    tags.add(media.playCount > 0 ? 'Watched:Yes' : 'Watched:No');

    switch (media.rating) {
      case MediaRating.like:
        tags.add('Rating:Liked');
      case MediaRating.dislike:
        tags.add('Rating:Disliked');
      case _:
        break;
    }

    return tags;
  }

  /// Average speed as a band rather than a number.
  ///
  /// A filter needs a value that repeats across entries; the raw average is
  /// unique to each one, which would give a filter list as long as the library.
  static String _speedBand(double speed) => switch (speed) {
    < 100 => 'Very Slow',
    < 200 => 'Slow',
    < 300 => 'Medium',
    < 400 => 'Fast',
    _ => 'Very Fast',
  };

  /// How much of the stroke range the script actually uses.
  static String _rangeBand(double min, double max) {
    final span = (max - min).clamp(0.0, 100.0);
    if (span < 30) return 'Short Strokes';
    if (span < 60) return 'Medium Strokes';
    return 'Full Strokes';
  }

  /// The nearest common resolution name, so entries recorded a few lines apart
  /// still land in the same filter.
  static String _tier(int height) => switch (height) {
    >= 4000 => '8K',
    >= 2800 => '6K',
    >= 1800 => '4K',
    >= 1000 => '1080p',
    >= 680 => '720p',
    _ => 'SD',
  };

  /// Maps Syncopathy's like/dislike onto HereSphere's five-star scale. No
  /// rating stays absent rather than becoming zero stars, which the headset
  /// would show as a deliberate low score.
  static double? _starsFor(MediaRating? rating) => switch (rating) {
    MediaRating.like => 5.0,
    MediaRating.dislike => 1.0,
    _ => null,
  };
}
