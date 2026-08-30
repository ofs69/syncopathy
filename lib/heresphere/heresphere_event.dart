/// The playback transition an event reports.
///
/// Wire values are HereSphere's; an unknown number decodes to [unknown] rather
/// than throwing, so a newer player build cannot break event handling wholesale.
enum HereSphereEventKind {
  open(0),
  play(1),
  pause(2),
  close(3),
  unknown(-1);

  final int wireValue;
  const HereSphereEventKind(this.wireValue);

  static HereSphereEventKind fromWire(int? value) =>
      HereSphereEventKind.values.firstWhere(
        (kind) => kind.wireValue == value,
        orElse: () => HereSphereEventKind.unknown,
      );
}

/// One playback event posted to the per-video event server.
///
/// Events carry the prompt state changes; the timestamp channel added in
/// phase 3 supplies the periodic authoritative correction. Every field is
/// optional on the wire, so every field here is nullable except the kind.
class HereSphereEvent {
  /// Identifier of the media the event is about, as issued by this server.
  final String? id;

  final String? title;
  final HereSphereEventKind kind;

  /// Media position in seconds at the moment of the transition.
  final double? time;

  final double? speed;

  /// The player's UTC clock when it sent the event, in its own units.
  ///
  /// Kept raw: whether HereSphere sends seconds or milliseconds here is one of
  /// the things the protocol spike has to settle, and guessing a scale would
  /// bake a silent error into every latency calculation built on it.
  final double? utc;

  const HereSphereEvent({
    required this.kind,
    this.id,
    this.title,
    this.time,
    this.speed,
    this.utc,
  });

  /// Decodes an event body, or returns null when [json] is not one.
  static HereSphereEvent? fromJson(Object? json) {
    if (json is! Map) return null;
    // `event` is the one field that must be present and numeric; without it
    // there is no transition to report.
    final rawKind = json['event'];
    if (rawKind is! num) return null;
    return HereSphereEvent(
      kind: HereSphereEventKind.fromWire(rawKind.toInt()),
      id: json['id'] is String ? json['id'] as String : null,
      title: json['title'] is String ? json['title'] as String : null,
      time: _asDouble(json['time']),
      speed: _asDouble(json['speed']),
      utc: _asDouble(json['utc']),
    );
  }

  static double? _asDouble(Object? value) =>
      value is num ? value.toDouble() : null;

  @override
  String toString() =>
      'HereSphereEvent(${kind.name}, id: ${_redactedId ?? '-'}, '
      'time: $time, speed: $speed)';

  /// The identifier with anything in front of it dropped.
  ///
  /// HereSphere echoes back the whole URL it fetched the entry from, and that
  /// URL contains a session token. The tail is the only part worth logging and
  /// the only part that is safe to.
  String? get _redactedId {
    final value = id;
    if (value == null || value.isEmpty) return null;
    final parts = value
        .split(RegExp(r'[/\\]'))
        .where((part) => part.isNotEmpty)
        .toList();
    return parts.isEmpty ? null : parts.last;
  }
}
