import 'dart:typed_data';

import 'package:syncopathy/heresphere/heresphere_projection.dart';

/// One library entry as the HereSphere JSON API sees it.
///
/// A projection of [MediaFile] rather than the entity itself, so the HTTP layer
/// can be exercised without ObjectBox and cannot reach anything the API is not
/// meant to publish.
class HereSphereEntry {
  /// Opaque, stable identifier used in every URL that names this entry.
  ///
  /// Stable across restarts so HereSphere's own favourites keep resolving, and
  /// derived from indexed state rather than the path — a path must never appear
  /// in a route nor be accepted from the client.
  final String id;

  final String title;

  /// Absolute path of the file to stream. Server-side only; it is never
  /// serialised into a response.
  final String mediaPath;

  /// Media length in seconds, or null when the library has not measured it.
  final double? durationSeconds;

  final int? width;
  final int? height;

  /// When the entry entered the library, for HereSphere's sort-by-added.
  final DateTime? addedOn;

  /// 0..5 for HereSphere's star display, or null when the user has not rated.
  /// Syncopathy stores a like/dislike, which maps onto the ends of that scale.
  final double? rating;

  final bool isFavorite;

  /// Whether Syncopathy holds a funscript for this entry.
  ///
  /// Surfaced only as a display tag. The script itself is deliberately not
  /// published: Syncopathy owns funscript processing and device playback, and
  /// handing HereSphere a script URL would let it drive the device too.
  final bool hasFunscript;

  /// How often the entry has been played, for HereSphere's sort-by-views.
  final int playCount;

  /// Searchable labels, each `Group:Value`.
  ///
  /// HereSphere groups tags by the part before the colon and offers each group
  /// as its own filter, so this is what makes a large library navigable in the
  /// headset — its browser can search titles on its own, but everything else it
  /// can filter by has to be published here.
  final List<String> tags;

  /// VR layout read off the file's own name, or
  /// [HereSphereProjection.none] when it carries no markers.
  final HereSphereProjection projection;

  const HereSphereEntry({
    required this.id,
    required this.title,
    required this.mediaPath,
    this.durationSeconds,
    this.width,
    this.height,
    this.addedOn,
    this.rating,
    this.isFavorite = false,
    this.hasFunscript = false,
    this.playCount = 0,
    this.tags = const [],
    this.projection = HereSphereProjection.none,
  });
}

/// One funscript attached to an entry, as the API names it.
///
/// Published only when HereSphere is the one driving the device; in the other
/// mode Syncopathy keeps the script to itself.
class HereSphereScript {
  /// Position in the entry's script list. Doubles as the identifier in the
  /// script URL, so nothing about the file's location travels to the client.
  final int index;

  /// Display name, usually the axis — HereSphere shows this when an entry has
  /// more than one script.
  final String name;

  const HereSphereScript({required this.index, required this.name});
}

/// Encoded image bytes and the type to serve them as.
///
/// The type travels with the bytes because it is not fixed: a thumbnail passed
/// through unchanged is the JPEG the generator produced, while one that had
/// badges and a heatmap drawn onto it is re-encoded as PNG.
class HereSphereThumbnail {
  final Uint8List bytes;

  /// A MIME type, `image/jpeg` or `image/png`.
  final String mimeType;

  const HereSphereThumbnail(this.bytes, this.mimeType);
}

/// A named group of entries, published as one HereSphere library section.
class HereSphereSection {
  final String name;
  final List<HereSphereEntry> entries;

  const HereSphereSection({required this.name, required this.entries});
}

/// The library the server publishes.
///
/// An interface so the request handling can be tested against a fake, and so
/// the server never holds a database handle of its own.
abstract class HereSphereLibrary {
  /// Sections to advertise on the index, in display order.
  List<HereSphereSection> sections();

  /// The entry [id] names, or null when it is unknown — a stale bookmark, or a
  /// guess. Callers must treat null as `404`, never as an invitation to fall
  /// back to a path.
  HereSphereEntry? entryById(String id);

  /// Every entry the library holds, in no particular order.
  ///
  /// Backs the bulk metadata endpoint, which describes the whole library in one
  /// response. Sections may overlap — an entry in two categories appears in
  /// both — so this is deduplicated by identifier, not a concatenation of
  /// [sections].
  List<HereSphereEntry> allEntries();

  /// A thumbnail for [entry], or null when none can be produced. Must not block
  /// on generating one for long.
  Future<HereSphereThumbnail?> thumbnail(HereSphereEntry entry);

  /// Scripts attached to [entry], main axis first.
  ///
  /// Callers must still decide whether to publish them: this reports what
  /// exists, not what the current device-owner mode permits handing out.
  List<HereSphereScript> scripts(HereSphereEntry entry);

  /// The raw bytes of one of [scripts], or null when it cannot be read.
  ///
  /// Served as stored rather than processed: in this mode HereSphere applies
  /// its own settings, so handing it a script Syncopathy had already reshaped
  /// would apply two sets of transforms to one signal.
  Future<Uint8List?> scriptBytes(HereSphereEntry entry, int index);
}
