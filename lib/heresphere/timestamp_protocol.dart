import 'dart:convert';
import 'dart:typed_data';

/// Default port of HereSphere's DeoVR-compatible timestamp server.
const int hereSphereDefaultTimestampPort = 23554;

/// How often a keepalive goes out when there is nothing else to send. The
/// server drops a connection that has gone quiet for longer.
const Duration hereSphereKeepaliveInterval = Duration(seconds: 1);

/// Largest frame accepted. State payloads are a few hundred bytes; the cap
/// stops a bogus or misaligned length prefix from turning into a huge
/// allocation.
const int _maxFrameBytes = 1024 * 1024;

/// Playback state as the timestamp channel reports it.
enum HereSpherePlayerState {
  playing(0),
  paused(1),

  /// A value this build does not know. Treated as paused everywhere it
  /// matters: guessing that an unrecognised state means "playing" would let
  /// the device run on an unverified clock.
  unknown(-1);

  final int wireValue;
  const HereSpherePlayerState(this.wireValue);

  static HereSpherePlayerState fromWire(int? value) =>
      HereSpherePlayerState.values.firstWhere(
        (state) => state.wireValue == value,
        orElse: () => HereSpherePlayerState.unknown,
      );
}

/// One authoritative state report from the player.
class HereSphereSnapshot {
  /// What the player says it has open — the URL it is streaming, or a path.
  final String? resource;

  /// Media length in seconds, or null when the player did not say.
  final double? duration;

  /// Playhead in seconds.
  final double? currentTime;

  final double? playbackSpeed;

  final HereSpherePlayerState state;

  const HereSphereSnapshot({
    this.resource,
    this.duration,
    this.currentTime,
    this.playbackSpeed,
    this.state = HereSpherePlayerState.unknown,
  });

  bool get isPlaying => state == HereSpherePlayerState.playing;

  static HereSphereSnapshot? fromJson(Object? json) {
    if (json is! Map) return null;
    return HereSphereSnapshot(
      // `resource` is the documented field; `path` is what older DeoVR-style
      // servers send. Either identifies the media, so both are accepted.
      resource: _asString(json['resource']) ?? _asString(json['path']),
      duration: _asDouble(json['duration']),
      currentTime: _asDouble(json['currentTime']),
      playbackSpeed: _asDouble(json['playbackSpeed']),
      state: HereSpherePlayerState.fromWire(
        json['playerState'] is num
            ? (json['playerState'] as num).toInt()
            : null,
      ),
    );
  }

  static String? _asString(Object? value) =>
      value is String && value.isNotEmpty ? value : null;

  static double? _asDouble(Object? value) =>
      value is num ? value.toDouble() : null;

  @override
  String toString() =>
      'HereSphereSnapshot(${state.name}, t: $currentTime, '
      'speed: $playbackSpeed, resource: $resource)';
}

/// A decoded frame from the timestamp channel.
sealed class HereSphereFrame {
  const HereSphereFrame();
}

/// A state report.
class HereSphereStateFrame extends HereSphereFrame {
  final HereSphereSnapshot snapshot;
  const HereSphereStateFrame(this.snapshot);
}

/// A zero-length frame: the player has nothing open, or is telling us to drop
/// what we think we know. It still counts as a heartbeat — the connection is
/// alive, there is just no media behind it.
class HereSphereResetFrame extends HereSphereFrame {
  const HereSphereResetFrame();
}

/// Reassembles frames from a byte stream.
///
/// The wire format is a 4-byte little-endian length followed by that many bytes
/// of UTF-8 JSON. TCP gives no message boundaries, so a frame can arrive split
/// across reads or several can arrive in one; this holds the partial tail
/// between calls.
class HereSphereFrameDecoder {
  final BytesBuilder _buffer = BytesBuilder(copy: true);

  /// True once a length prefix was seen that cannot be real.
  ///
  /// The stream is then unrecoverable — there is no resynchronisation marker to
  /// look for — so the caller must drop the connection rather than keep
  /// decoding noise.
  bool get desynchronised => _desynchronised;
  bool _desynchronised = false;

  /// Feeds [chunk] in and returns whatever frames completed.
  List<HereSphereFrame> add(List<int> chunk) {
    if (_desynchronised) return const [];
    _buffer.add(chunk);

    final frames = <HereSphereFrame>[];
    // Taking the bytes empties the builder, so whatever is left over after the
    // last complete frame has to go back in before returning.
    var bytes = _buffer.takeBytes();
    var offset = 0;

    while (bytes.length - offset >= 4) {
      final length = ByteData.sublistView(
        bytes,
        offset,
        offset + 4,
      ).getInt32(0, Endian.little);

      if (length <= 0) {
        // A zero or negative length is the reset packet, not a broken stream.
        offset += 4;
        frames.add(const HereSphereResetFrame());
        continue;
      }
      if (length > _maxFrameBytes) {
        _desynchronised = true;
        return frames;
      }
      if (bytes.length - offset - 4 < length) break;

      final payload = bytes.sublist(offset + 4, offset + 4 + length);
      offset += 4 + length;
      final frame = _decodePayload(payload);
      if (frame != null) frames.add(frame);
    }

    if (offset < bytes.length) _buffer.add(bytes.sublist(offset));
    return frames;
  }

  static HereSphereFrame? _decodePayload(Uint8List payload) {
    try {
      final snapshot = HereSphereSnapshot.fromJson(
        jsonDecode(utf8.decode(payload)),
      );
      // A frame that decodes to nothing usable is dropped rather than treated
      // as a reset: the connection is fine, this one packet just said nothing.
      return snapshot == null ? null : HereSphereStateFrame(snapshot);
    } catch (_) {
      return null;
    }
  }

  void reset() {
    _buffer.clear();
    _desynchronised = false;
  }
}

/// Frames [json] for sending: 4-byte little-endian length, then UTF-8 JSON.
Uint8List encodeHereSphereFrame(Map<String, Object?> json) {
  final payload = utf8.encode(jsonEncode(json));
  final frame = Uint8List(4 + payload.length);
  ByteData.sublistView(frame, 0, 4).setInt32(0, payload.length, Endian.little);
  frame.setRange(4, frame.length, payload);
  return frame;
}

/// The empty frame sent to keep an idle connection open.
final Uint8List hereSphereKeepaliveFrame = Uint8List(4);
