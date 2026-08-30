/// Resolution of an HTTP `Range` request header, per RFC 9110 §14.
///
/// Kept free of `dart:io` so the rules can be tested without a socket. The
/// header is the one part of media streaming a client will exercise hardest —
/// HereSphere seeks by aborting the current response and re-requesting from a
/// new offset — so the edge cases are decided here rather than inline in the
/// request handler.
library;

/// A byte range within a file, both ends inclusive.
class ByteRange {
  /// First byte to send, inclusive.
  final int start;

  /// Last byte to send, inclusive.
  final int end;

  const ByteRange(this.start, this.end);

  int get length => end - start + 1;

  @override
  bool operator ==(Object other) =>
      other is ByteRange && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => 'ByteRange($start-$end)';
}

/// What to answer a request with, once its `Range` header has been resolved
/// against the length of the file it asked for.
sealed class RangeResolution {
  const RangeResolution();
}

/// Send the whole file with `200 OK`.
///
/// Also the answer for a header that is absent, syntactically invalid, in a
/// unit other than bytes, or asking for more than one range: RFC 9110 requires
/// a recipient that cannot honour a `Range` header to ignore it, and ignoring
/// it means serving the full representation rather than failing.
class FullContent extends RangeResolution {
  const FullContent();

  @override
  bool operator ==(Object other) => other is FullContent;

  @override
  int get hashCode => (FullContent).hashCode;

  @override
  String toString() => 'FullContent()';
}

/// Send [range] with `206 Partial Content`.
class PartialContent extends RangeResolution {
  final ByteRange range;

  const PartialContent(this.range);

  @override
  bool operator ==(Object other) =>
      other is PartialContent && other.range == range;

  @override
  int get hashCode => range.hashCode;

  @override
  String toString() => 'PartialContent($range)';
}

/// The range is well formed but lies outside the file: `416` with a
/// `Content-Range: bytes */<length>` telling the client the real length.
class UnsatisfiableRange extends RangeResolution {
  const UnsatisfiableRange();

  @override
  bool operator ==(Object other) => other is UnsatisfiableRange;

  @override
  int get hashCode => (UnsatisfiableRange).hashCode;

  @override
  String toString() => 'UnsatisfiableRange()';
}

final RegExp _bytesUnit = RegExp(r'^bytes\s*=\s*(.*)$', caseSensitive: false);

/// Decides what to serve for [header] from a file of [fileLength] bytes.
///
/// Only single-range requests are honoured. A multipart response would need
/// boundary framing that no video client asks for, and ignoring the header is
/// both legal and cheaper than getting that wrong.
RangeResolution resolveRange(String? header, int fileLength) {
  if (header == null) return const FullContent();

  final match = _bytesUnit.firstMatch(header.trim());
  // A unit we do not implement. Ignore rather than reject.
  if (match == null) return const FullContent();

  final specs = match.group(1)!.split(',');
  // Exactly one range, and it must not be blank.
  if (specs.length != 1) return const FullContent();
  final spec = specs.first.trim();
  if (spec.isEmpty) return const FullContent();

  final dash = spec.indexOf('-');
  if (dash < 0) return const FullContent();

  final firstText = spec.substring(0, dash).trim();
  final lastText = spec.substring(dash + 1).trim();

  if (firstText.isEmpty) {
    // Suffix form, `bytes=-N`: the last N bytes.
    final suffix = _parsePositiveInt(lastText);
    if (suffix == null) return const FullContent();
    // "-0" is well formed but selects nothing, which is unsatisfiable rather
    // than an invitation to send the whole file.
    if (suffix == 0 || fileLength == 0) return const UnsatisfiableRange();
    final start = suffix >= fileLength ? 0 : fileLength - suffix;
    return PartialContent(ByteRange(start, fileLength - 1));
  }

  final first = _parsePositiveInt(firstText);
  if (first == null) return const FullContent();

  int last;
  if (lastText.isEmpty) {
    // Open-ended form, `bytes=N-`: everything from N on. This is what a player
    // issues to start streaming from a seek target.
    last = fileLength - 1;
  } else {
    final parsed = _parsePositiveInt(lastText);
    if (parsed == null) return const FullContent();
    // last < first makes the whole header invalid, so it is ignored.
    if (parsed < first) return const FullContent();
    // Clamping past the end is expected, not an error.
    last = parsed >= fileLength ? fileLength - 1 : parsed;
  }

  // Starting at or past the end has nothing to send. An empty file lands here
  // too, since every offset is past its end.
  if (first >= fileLength) return const UnsatisfiableRange();

  return PartialContent(ByteRange(first, last));
}

/// Parses a bare non-negative decimal integer, rejecting signs, whitespace and
/// anything `int.parse` would accept but the grammar does not.
int? _parsePositiveInt(String text) {
  if (text.isEmpty) return null;
  for (final unit in text.codeUnits) {
    if (unit < 0x30 || unit > 0x39) return null;
  }
  // Absurdly long digit runs overflow rather than parse; treat as invalid.
  return int.tryParse(text);
}
