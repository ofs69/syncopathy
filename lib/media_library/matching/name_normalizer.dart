import 'package:syncopathy/persistence/entities/funscript_file.dart';

/// A filename reduced to the parts that actually identify the scene it names.
///
/// Release names carry a lot of text that says nothing about *which* scene a
/// file is: resolution, codec, source, VR projection, release group. Two files
/// of the same scene routinely disagree on all of it while agreeing on the
/// handful of tokens that matter. Everything here exists to separate those two
/// groups so scoring compares titles rather than encoder settings.
class NormalizedName {
  /// The basename this was built from, unchanged. Kept for display; never used
  /// for comparison.
  final String source;

  /// Content tokens joined by single spaces — the string similarity metrics
  /// run on this rather than on [source].
  final String stem;

  /// Content tokens in the order they appeared, noise removed.
  final List<String> tokens;

  final Set<String> tokenSet;

  /// Studio/scene codes (`abp123`) and full dates (`20230514`), normalized so
  /// the same code written `ABP-123` and `abp 123` compares equal. An exact
  /// identifier agreement is the strongest signal available.
  final Set<String> identifiers;

  /// Season/episode/scene/part numbers the name declares. A disagreement here
  /// is disqualifying in a way that a low text similarity is not: `scene 3` and
  /// `scene 4` are deliberately near-identical names for different scenes.
  final Map<OrdinalKind, int> ordinals;

  /// Tokens dropped as release noise. Not compared, but kept so the review UI
  /// can explain why a name was reduced the way it was.
  final Set<String> noiseTokens;

  /// Character trigrams of [stem], padded at both ends. Precomputed because
  /// every media snapshot is compared against every unresolved script.
  final Set<String> trigrams;

  NormalizedName({
    required this.source,
    required this.stem,
    required this.tokens,
    required this.identifiers,
    required this.ordinals,
    required this.noiseTokens,
    required this.trigrams,
  }) : tokenSet = tokens.toSet();

  bool get isEmpty => tokens.isEmpty && identifiers.isEmpty;

  @override
  String toString() => 'NormalizedName($stem)';
}

/// The kinds of positional number a release name declares. Two names may
/// legitimately differ on one of these while sharing every other token, so they
/// are extracted separately rather than left in the token stream.
enum OrdinalKind { season, episode, scene, part }

/// Normalizes [basename] (a filename with no extension).
///
/// Pass [stripAxis] for funscript names so a multi-axis companion normalizes to
/// the same thing as its stroke script.
NormalizedName normalizeName(String basename, {bool stripAxis = false}) {
  final withoutAxis = stripAxis
      ? stripFunscriptAxisSuffix(basename)
      : basename;

  final folded = _foldSeparators(
    _foldDiacritics(_splitCamelCase(withoutAxis).toLowerCase()),
  );
  final rawTokens = folded
      .split(' ')
      .where((token) => token.isNotEmpty)
      .toList();

  final ordinals = <OrdinalKind, int>{};
  final identifiers = <String>{};
  final noiseTokens = <String>{};
  final tokens = <String>[];

  for (var i = 0; i < rawTokens.length; i++) {
    final token = rawTokens[i];

    // Ordinals are consumed rather than kept: leaving `s01e02` in the token
    // stream would let two different episodes score as near-identical text.
    final consumed = _consumeOrdinal(rawTokens, i, ordinals);
    if (consumed > 0) {
      i += consumed - 1;
      continue;
    }

    if (isNoiseToken(token)) {
      noiseTokens.add(token);
      continue;
    }

    tokens.add(token);
  }

  _collectIdentifiers(tokens, identifiers);

  final stem = tokens.join(' ');
  return NormalizedName(
    source: basename,
    stem: stem,
    tokens: tokens,
    identifiers: identifiers,
    ordinals: ordinals,
    noiseTokens: noiseTokens,
    trigrams: trigramsOf(stem),
  );
}

/// Splits `MySceneName` into `My Scene Name` before anything is lowercased.
///
/// CamelCase is a common filename convention, and a name written that way
/// shares no tokens at all with the same title written with separators — which
/// would leave two files of one scene looking completely unrelated. Runs of
/// capitals are split only before a capital that starts a word, so `HDVideo`
/// becomes `HD Video` while `ABP123` is left intact for identifier detection.
///
/// A digit before a capital is deliberately *not* a boundary: splitting it
/// would break `8K` and `60FPS` apart and leave the halves unrecognizable as
/// the release noise they are.
String _splitCamelCase(String value) {
  if (value.length < 2) return value;

  final buffer = StringBuffer(value[0]);
  for (var i = 1; i < value.length; i++) {
    final previous = value[i - 1];
    final current = value[i];
    final next = i + 1 < value.length ? value[i + 1] : null;

    final startsWord =
        _isUpper(current) &&
        (_isLower(previous) ||
            (_isUpper(previous) && next != null && _isLower(next)));
    if (startsWord) buffer.write(' ');
    buffer.write(current);
  }
  return buffer.toString();
}

bool _isUpper(String char) {
  final code = char.codeUnitAt(0);
  return code >= 0x41 && code <= 0x5a;
}

bool _isLower(String char) {
  final code = char.codeUnitAt(0);
  return code >= 0x61 && code <= 0x7a;
}

/// Character trigrams of [value], padded so short strings still produce enough
/// grams to compare and so word boundaries count as evidence.
Set<String> trigramsOf(String value) {
  if (value.isEmpty) return const {};
  final padded = '  $value ';
  final result = <String>{};
  for (var i = 0; i + 3 <= padded.length; i++) {
    result.add(padded.substring(i, i + 3));
  }
  return result;
}

/// Replaces the punctuation release names use as word separators with spaces.
/// Apostrophes are removed rather than split on, so `girl's` and `girls`
/// normalize alike.
String _foldSeparators(String value) {
  final buffer = StringBuffer();
  for (final rune in value.runes) {
    final char = String.fromCharCode(rune);
    if (_removedCharacters.contains(char)) continue;
    buffer.write(_isAlphanumeric(rune) ? char : ' ');
  }
  return buffer.toString();
}

const Set<String> _removedCharacters = {"'", '’', '`'};

bool _isAlphanumeric(int rune) =>
    (rune >= 0x30 && rune <= 0x39) || // 0-9
    (rune >= 0x61 && rune <= 0x7a) || // a-z (input is already lowercased)
    rune > 0x7f; // anything non-ASCII that survived folding

/// Folds the accented Latin letters that appear in performer and studio names,
/// so `bjork` matches `björk`. Deliberately not a full Unicode normalization:
/// this covers the range these filenames actually use, and anything it misses
/// still compares equal to itself.
String _foldDiacritics(String value) {
  if (!value.runes.any((rune) => rune > 0x7f)) return value;

  final buffer = StringBuffer();
  for (final rune in value.runes) {
    final char = String.fromCharCode(rune);
    buffer.write(_diacriticFolding[char] ?? char);
  }
  return buffer.toString();
}

const Map<String, String> _diacriticFolding = {
  'à': 'a', 'á': 'a', 'â': 'a', 'ã': 'a', 'ä': 'a', 'å': 'a', 'ā': 'a',
  'ă': 'a', 'ą': 'a', 'æ': 'ae',
  'ç': 'c', 'ć': 'c', 'č': 'c',
  'ď': 'd', 'đ': 'd',
  'è': 'e', 'é': 'e', 'ê': 'e', 'ë': 'e', 'ē': 'e', 'ė': 'e', 'ę': 'e',
  'ě': 'e',
  'ğ': 'g',
  'ì': 'i', 'í': 'i', 'î': 'i', 'ï': 'i', 'ī': 'i', 'į': 'i', 'ı': 'i',
  'ł': 'l', 'ľ': 'l',
  'ñ': 'n', 'ń': 'n', 'ň': 'n',
  'ò': 'o', 'ó': 'o', 'ô': 'o', 'õ': 'o', 'ö': 'o', 'ø': 'o', 'ō': 'o',
  'œ': 'oe',
  'ř': 'r',
  'ś': 's', 'š': 's', 'ş': 's', 'ß': 'ss',
  'ť': 't', 'ţ': 't',
  'ù': 'u', 'ú': 'u', 'û': 'u', 'ü': 'u', 'ū': 'u', 'ů': 'u', 'ų': 'u',
  'ý': 'y', 'ÿ': 'y',
  'ź': 'z', 'ż': 'z', 'ž': 'z',
};

/// Tries to read an ordinal starting at [index], recording it in [ordinals].
/// Returns how many tokens were consumed, or 0 when [index] starts no ordinal.
///
/// The first declaration of a kind wins: a name that says `scene 2` twice means
/// scene 2, and a later stray number should not overwrite it.
int _consumeOrdinal(
  List<String> tokens,
  int index,
  Map<OrdinalKind, int> ordinals,
) {
  final token = tokens[index];

  // `s01e02` — the only form that declares two ordinals in one token.
  final seasonEpisode = _seasonEpisodePattern.firstMatch(token);
  if (seasonEpisode != null) {
    ordinals.putIfAbsent(
      OrdinalKind.season,
      () => int.parse(seasonEpisode.group(1)!),
    );
    ordinals.putIfAbsent(
      OrdinalKind.episode,
      () => int.parse(seasonEpisode.group(2)!),
    );
    return 1;
  }

  for (final entry in _ordinalPatterns.entries) {
    // Attached form: `scene3`, `pt2`, `cd1`.
    final attached = entry.value.attached.firstMatch(token);
    if (attached != null) {
      ordinals.putIfAbsent(entry.key, () => int.parse(attached.group(1)!));
      return 1;
    }

    // Detached form: `scene 3`. Only a bare number may follow, so `part two`
    // and `scene of` are left alone as ordinary words.
    if (entry.value.words.contains(token) && index + 1 < tokens.length) {
      final next = int.tryParse(tokens[index + 1]);
      if (next != null && tokens[index + 1].length <= 3) {
        ordinals.putIfAbsent(entry.key, () => next);
        return 2;
      }
    }
  }

  return 0;
}

final RegExp _seasonEpisodePattern = RegExp(r'^s(\d{1,2})e(\d{1,3})$');

class _OrdinalPattern {
  final RegExp attached;
  final Set<String> words;
  const _OrdinalPattern(this.attached, this.words);
}

final Map<OrdinalKind, _OrdinalPattern> _ordinalPatterns = {
  OrdinalKind.season: _OrdinalPattern(RegExp(r'^s(\d{1,2})$'), {'season'}),
  OrdinalKind.episode: _OrdinalPattern(RegExp(r'^e(?:p)?(\d{1,3})$'), {
    'episode',
    'ep',
  }),
  OrdinalKind.scene: _OrdinalPattern(RegExp(r'^sc(?:ene)?(\d{1,3})$'), {
    'scene',
    'sc',
  }),
  OrdinalKind.part: _OrdinalPattern(RegExp(r'^(?:p|pt|part|cd)(\d{1,3})$'), {
    'part',
    'pt',
    'cd',
    'disc',
  }),
};

/// Pulls studio codes and dates out of [tokens] into [identifiers].
///
/// Tokens are left in place as well: an identifier is extra evidence on top of
/// the text, not a replacement for it.
void _collectIdentifiers(List<String> tokens, Set<String> identifiers) {
  for (var i = 0; i < tokens.length; i++) {
    final token = tokens[i];

    if (_attachedCodePattern.hasMatch(token)) {
      identifiers.add(token);
      continue;
    }
    if (_compactDatePattern.hasMatch(token)) {
      identifiers.add(token);
      continue;
    }

    // `abp 123` — separator folding split what was one code. A following year
    // is excluded: `Studio 2023` is a title and a year far more often than it
    // is a scene code, and treating it as one makes two releases of the same
    // studio in different years look like conflicting identifiers.
    if (i + 1 < tokens.length &&
        _lettersOnlyPattern.hasMatch(token) &&
        _digitsOnlyPattern.hasMatch(tokens[i + 1]) &&
        !_yearPattern.hasMatch(tokens[i + 1])) {
      identifiers.add('$token${tokens[i + 1]}');
      continue;
    }

    // `2023 05 14` — likewise for a split date.
    if (i + 2 < tokens.length &&
        _yearPattern.hasMatch(token) &&
        _twoDigitPattern.hasMatch(tokens[i + 1]) &&
        _twoDigitPattern.hasMatch(tokens[i + 2])) {
      identifiers.add('$token${tokens[i + 1]}${tokens[i + 2]}');
    }
  }
}

final RegExp _attachedCodePattern = RegExp(r'^[a-z]{2,6}\d{2,6}$');
final RegExp _compactDatePattern = RegExp(r'^(?:19|20)\d{2}(?:0[1-9]|1[0-2])'
    r'(?:0[1-9]|[12]\d|3[01])$');
final RegExp _lettersOnlyPattern = RegExp(r'^[a-z]{2,6}$');
final RegExp _digitsOnlyPattern = RegExp(r'^\d{2,6}$');
final RegExp _yearPattern = RegExp(r'^(?:19|20)\d{2}$');
final RegExp _twoDigitPattern = RegExp(r'^\d{2}$');

/// Tokens that describe how a file was encoded or delivered rather than what it
/// contains. Dropping them is what lets a 4K VR remux match the 1080p web
/// version of the same scene.
///
/// Numbers that are almost always projection or resolution markers in this
/// domain (`180`, `360`, `5k`) are included: a title that genuinely needs one
/// still keeps every other token, and leaving them in matched far more wrong
/// files than right ones.
const Set<String> _noiseTokens = {
  // Resolution and quality
  '360p', '480p', '540p', '576p', '720p', '1080p', '1440p', '2160p', '4320p',
  'sd', 'hd', 'fhd', 'fullhd', 'uhd', 'hq', 'lq',
  '2k', '4k', '5k', '6k', '7k', '8k',
  // Codecs and encoding
  'h264', 'h265', 'x264', 'x265', 'hevc', 'avc', 'av1', 'vp9', 'xvid', 'divx',
  'mpeg4', 'mpeg2', '8bit', '10bit', 'hdr', 'hdr10', 'sdr', 'crf', 'cbr', 'vbr',
  'aac', 'ac3', 'eac3', 'dts', 'opus', 'mp3', 'flac', 'lpcm', '2ch', '6ch',
  // Source
  'web', 'webrip', 'webdl', 'dl', 'bluray', 'blueray', 'bdrip', 'brrip', 'bdremux',
  'remux', 'dvdrip', 'dvd', 'hdrip', 'hdtv', 'cam', 'rip', 'encode', 'reencode',
  // VR
  'vr', 'vr180', 'vr360', '180', '360', 'sbs', 'lr', 'tb', 'ou', 'mono',
  'stereo', 'fisheye', 'mkx200', 'mkx220', 'vrca220', 'rf52', 'f180', 'i180',
  'lr180', 'sbs180', 'ts180', '180x180', '360x180', '3dh', '3dv', 'oculus',
  'quest', 'smartphone', 'gearvr', 'psvr',
  '2d', '3d', 'sidebyside', 'overunder', 'topbottom', 'halfsbs', 'fullsbs',
  'equirect', 'equirectangular', 'cubemap', 'passthrough', 'fov',
  'binaural', 'ambisonic', 'ambix', 'spatial',
  // Frame rate
  'fps', '24fps', '25fps', '30fps', '50fps', '59fps', '60fps', '90fps',
  '120fps',
  // Release bookkeeping
  'proper', 'repack', 'internal', 'multi', 'dual', 'subbed', 'sub', 'subs',
  'uncut', 'uncensored', 'censored', 'extended', 'final', 'complete', 'full',
  'xxx', 'nsfw', 'trailer', 'sample', 'preview',
  // Container words that survive when the extension was part of the name
  'mp4', 'mkv', 'avi', 'mov', 'wmv', 'webm', 'm4v',
  // Script bookkeeping
  'funscript', 'script', 'scripted',
};

/// Noise that no word list can keep up with.
///
/// Every season brings a new resolution, a new headset revision and a new
/// projection tag, and each one arrives looking like a rare, highly
/// distinctive word — which is the worst possible thing for scoring, because
/// rarity is what the matcher trusts most. A `5400x2700` shared by two files
/// says only that both were shot for a headset; scored as a rare agreement it
/// says they are the same scene.
///
/// Families survive where members do not: matching the *shape* of a resolution
/// covers the ones nobody has published yet.
final List<RegExp> _noisePatterns = [
  // Pixel dimensions: 5400x2700, 7680x3840, 3840x1920.
  RegExp(r'^\d{3,5}x\d{3,5}$'),
  // Vertical resolution and its shorthand: 1080p, 2160p, 4k, 8k.
  RegExp(r'^\d{3,4}p$'),
  RegExp(r'^\d{1,2}k$'),
  // Frame rate, bit rate, bit depth, file size.
  RegExp(r'^\d{2,3}fps$'),
  RegExp(r'^fps\d{2,3}$'),
  RegExp(r'^\d{2,6}(?:kbps|mbps|kbit|mbit)$'),
  RegExp(r'^\d{1,4}(?:mb|gb)$'),
  RegExp(r'^\d{1,2}bits?$'),
  // The Oculus family, every model and revision of it. No title uses this
  // word, so the whole prefix can go.
  RegExp(r'^oculus[a-z0-9]{0,8}$'),
  RegExp(
    r'^(?:gearvr|psvr|daydream|cardboard|pimax|varjo|bigscreen|deovr'
    r'|smartphone)[a-z0-9]{0,8}$',
  ),
  // Headsets whose bare names are ordinary words. A model number or a trim
  // level is required so `quest` in a title survives — and so `question`,
  // which starts the same way, is never mistaken for one.
  RegExp(r'^(?:quest|pico|vive|psvr)\d?(?:pro|plus|xr|elite)?$'),
  // Projection tags carrying a field of view: mkx200, vrca220, rf52,
  // fisheye190, dome180, sbs360.
  RegExp(r'^(?:mkx|vrca|rf|fisheye|dome|eac|cmp|ts|lr|sbs|ou|tb)\d{2,3}$'),
];

/// Whether [token] would be dropped as release noise. Exposed so the review UI
/// and tests can explain a reduction without reaching into the private set.
bool isNoiseToken(String token) {
  final lowered = token.toLowerCase();
  if (_noiseTokens.contains(lowered)) return true;
  return _noisePatterns.any((pattern) => pattern.hasMatch(lowered));
}
