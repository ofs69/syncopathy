/// VR layout read off a filename.
///
/// Only ever populated from markers the file actually carries. Nothing here
/// guesses from resolution or aspect ratio: a wrong projection is worse than
/// none, because HereSphere trusts what the API tells it and stops working out
/// the layout for itself.
class HereSphereProjection {
  /// HereSphere's projection name: `perspective`, `equirectangular`,
  /// `equirectangular360` or `fisheye`.
  final String? projection;

  /// `mono`, `sbs` or `tb`.
  final String? stereo;

  /// Field of view in degrees, for the fisheye lenses that state one.
  final double? fov;

  /// Lens name for the fisheye formats HereSphere knows by name.
  final String? lens;

  const HereSphereProjection({
    this.projection,
    this.stereo,
    this.fov,
    this.lens,
  });

  static const HereSphereProjection none = HereSphereProjection();

  /// Whether anything at all was recognised.
  bool get isEmpty =>
      projection == null && stereo == null && fov == null && lens == null;

  bool get isNotEmpty => !isEmpty;
}

/// Lens markers, longest first so `mkx220` is not matched as `mkx200`'s
/// neighbour and `fisheye190` beats a bare `fisheye`.
const List<(String, String, double)> _lensMarkers = [
  ('vrca220', 'VRCA220', 220),
  ('mkx220', 'MKX220', 220),
  ('mkx200', 'MKX200', 200),
  ('rf52', 'RF52', 190),
  ('fisheye190', 'Linear', 190),
  ('fisheye', 'Linear', 180),
];

/// Reads the VR layout markers out of [fileName].
///
/// This is the same convention HereSphere applies to filenames it opens
/// directly. Syncopathy publishes media under an opaque identifier, so the
/// player never sees the filename — reading it here is what keeps a correctly
/// named file working, rather than an improvement on the player's own
/// detection.
///
/// A file with no markers yields [HereSphereProjection.none], and the caller
/// then publishes no layout fields at all, which leaves HereSphere free to
/// decide for itself.
HereSphereProjection detectHereSphereProjection(String fileName) {
  final name = fileName.toLowerCase();

  String? lens;
  double? fov;
  for (final (marker, lensName, lensFov) in _lensMarkers) {
    if (name.contains(marker)) {
      lens = lensName;
      fov = lensFov;
      break;
    }
  }

  String? projection;
  if (lens != null) {
    projection = 'fisheye';
  } else if (_hasMarker(name, '360')) {
    projection = 'equirectangular360';
    fov = 360;
  } else if (_hasMarker(name, '180')) {
    projection = 'equirectangular';
    fov = 180;
  }

  String? stereo;
  if (_hasMarker(name, 'sbs') || _hasMarker(name, 'lr')) {
    stereo = 'sbs';
  } else if (_hasMarker(name, 'tb') || _hasMarker(name, 'ou')) {
    stereo = 'tb';
  } else if (_hasMarker(name, 'mono') || _hasMarker(name, '2d')) {
    stereo = 'mono';
    // An explicit 2D marker with no projection marker means a flat video.
    projection ??= 'perspective';
  }

  // A VR projection with no stereo marker is conventionally side-by-side, but
  // that is an assumption rather than a statement, so it is left unsaid.
  return HereSphereProjection(
    projection: projection,
    stereo: stereo,
    fov: fov,
    lens: lens,
  );
}

/// Whether [name] carries [marker] as a standalone token.
///
/// Delimiter-bounded on purpose: `_180_` is a marker, the `180` inside
/// `1800s` is not, and `lr` must not match the middle of a word.
bool _hasMarker(String name, String marker) {
  var index = name.indexOf(marker);
  while (index >= 0) {
    final beforeOk = index == 0 || _isDelimiter(name.codeUnitAt(index - 1));
    final after = index + marker.length;
    final afterOk =
        after >= name.length || _isDelimiter(name.codeUnitAt(after));
    if (beforeOk && afterOk) return true;
    index = name.indexOf(marker, index + 1);
  }
  return false;
}

bool _isDelimiter(int codeUnit) {
  // Anything that is not a letter or a digit separates tokens in the naming
  // conventions these markers come from.
  final isDigit = codeUnit >= 0x30 && codeUnit <= 0x39;
  final isLower = codeUnit >= 0x61 && codeUnit <= 0x7A;
  return !isDigit && !isLower;
}
