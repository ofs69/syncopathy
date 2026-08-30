import 'package:path/path.dart' as p;
import 'package:syncopathy/heresphere/heresphere_server.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';
import 'package:syncopathy/persistence/service/media_service.dart';

/// Turns the identifiers HereSphere reports back into library entries.
///
/// Three sources name the same media in different ways: an event carries the
/// `id` this server issued, the timestamp channel carries the `resource` URL it
/// is streaming, and an externally opened file carries a local path. They are
/// tried in that order — an exact identifier must never lose to a filename
/// guess, because the wrong script driving a device is worse than no script.
class HereSphereMediaResolver {
  /// Exact lookup by the identifier this server issues, which is the media
  /// hash.
  final MediaFile? Function(String hash) _byHash;

  /// Everything indexed, for the filename fallback only.
  final List<MediaFile> Function() _allMedia;

  HereSphereMediaResolver({
    required MediaFile? Function(String hash) byHash,
    required List<MediaFile> Function() allMedia,
  }) : _byHash = byHash,
       _allMedia = allMedia;

  /// The resolver the application runs with.
  ///
  /// Takes the two lookups rather than the service itself so the rules can be
  /// tested against a handful of entries instead of a database.
  factory HereSphereMediaResolver.fromService(MediaService service) =>
      HereSphereMediaResolver(
        byHash: service.getByHash,
        allMedia: () => service.allMediaFiles.value,
      );

  /// Resolves the `id` from a playback event.
  ///
  /// HereSphere does not echo back the identifier from the URL path — it sends
  /// the whole video-data URL it fetched the entry from. So `id` arrives as
  /// either a bare hash or something like
  /// `http://host:port/hs/<token>/video/<hash>`, and only the last segment of
  /// it is ours. Every reference implementation splits on `/` and keeps the
  /// tail for exactly this reason.
  MediaFile? byId(String? id) {
    if (id == null || id.isEmpty) return null;

    final direct = _present(_byHash(id));
    if (direct != null) return direct;

    final tail = _lastSegment(id);
    if (tail == null || tail == id) return null;
    return _present(_byHash(tail));
  }

  /// The last non-empty path segment of [value], percent-decoded.
  ///
  /// Parsed as a URI when it is one, so a query string or a trailing slash does
  /// not end up inside the identifier; a plain string falls back to splitting
  /// on separators.
  static String? _lastSegment(String value) {
    final uri = Uri.tryParse(value);
    final segments = uri?.pathSegments.where((s) => s.isNotEmpty).toList();
    if (segments != null && segments.isNotEmpty) return segments.last;

    final parts = value
        .split(RegExp(r'[/\\]'))
        .where((part) => part.isNotEmpty)
        .toList();
    return parts.isEmpty ? null : parts.last;
  }

  /// Resolves the `resource` or `path` from a timestamp snapshot.
  ///
  /// A URL this server issued carries the identifier in its path, which is
  /// exact. Anything else is a local path HereSphere opened on its own, and
  /// only its filename can be matched — a last resort, and only when it picks
  /// out exactly one entry.
  MediaFile? byResource(String? resource) {
    if (resource == null || resource.isEmpty) return null;

    final fromUrl = _idFromMediaUrl(resource);
    if (fromUrl != null) {
      final media = _present(_byHash(fromUrl));
      if (media != null) return media;
    }

    return _byFileName(resource);
  }

  /// Extracts the media identifier from a URL this server handed out.
  ///
  /// Matches on the shape `/hs/<token>/media/<id>` rather than on the token
  /// itself: the token may have been regenerated since the player fetched the
  /// URL, and the identifier is still the one we issued.
  static String? _idFromMediaUrl(String resource) {
    final uri = Uri.tryParse(resource);
    if (uri == null) return null;
    final segments = uri.pathSegments;
    for (var i = 0; i + 1 < segments.length; i++) {
      if (segments[i] == 'media' &&
          i >= 2 &&
          segments[i - 2] == hereSpherePathPrefix) {
        final id = segments[i + 1];
        return id.isEmpty ? null : id;
      }
    }
    return null;
  }

  /// Last-resort match on the filename of a path the player opened itself.
  ///
  /// Ambiguity resolves to nothing: two library entries with the same filename
  /// in different folders give no way to tell which is playing, and picking one
  /// would drive the device from the wrong script.
  MediaFile? _byFileName(String resource) {
    final name = p.basename(_pathOf(resource)).toLowerCase();
    if (name.isEmpty) return null;

    MediaFile? match;
    for (final media in _allMedia()) {
      if (p.basename(media.mediaPath).toLowerCase() != name) continue;
      if (match != null) return null;
      match = media;
    }
    return _present(match);
  }

  /// The filesystem-ish portion of [resource], whether it arrived as a URL, a
  /// `file:` URI, or a bare Windows or POSIX path.
  static String _pathOf(String resource) {
    final uri = Uri.tryParse(resource);
    if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
      return uri.path;
    }
    if (uri != null && uri.scheme == 'file') {
      try {
        return uri.toFilePath();
      } catch (_) {
        return uri.path;
      }
    }
    return resource;
  }

  /// Entries whose file has gone missing resolve to nothing: there is nothing
  /// to play and nothing to drive.
  static MediaFile? _present(MediaFile? media) =>
      media != null && !media.fileNotFound ? media : null;
}
