import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:syncopathy/heresphere/timestamp_protocol.dart';

/// Builds one wire frame: 4-byte little-endian length, then UTF-8 JSON.
Uint8List frame(Map<String, Object?> json) => encodeHereSphereFrame(json);

Uint8List bytes(List<int> values) => Uint8List.fromList(values);

void main() {
  group('HereSphereFrameDecoder', () {
    test('decodes a single frame', () {
      final decoder = HereSphereFrameDecoder();
      final frames = decoder.add(
        frame({'currentTime': 12.5, 'playerState': 0}),
      );
      expect(frames, hasLength(1));
      final snapshot = (frames.single as HereSphereStateFrame).snapshot;
      expect(snapshot.currentTime, 12.5);
      expect(snapshot.isPlaying, isTrue);
    });

    test('reassembles a frame split across reads', () {
      // TCP gives no message boundaries, so a report can arrive in pieces —
      // even with the length prefix itself cut in half.
      final decoder = HereSphereFrameDecoder();
      final whole = frame({'currentTime': 1.0, 'playerState': 0});

      expect(decoder.add(whole.sublist(0, 2)), isEmpty);
      expect(decoder.add(whole.sublist(2, 4)), isEmpty);
      expect(decoder.add(whole.sublist(4, whole.length - 3)), isEmpty);

      final frames = decoder.add(whole.sublist(whole.length - 3));
      expect(frames, hasLength(1));
    });

    test('splits several frames arriving in one read', () {
      final decoder = HereSphereFrameDecoder();
      final combined = <int>[
        ...frame({'currentTime': 1.0, 'playerState': 0}),
        ...frame({'currentTime': 2.0, 'playerState': 0}),
        ...frame({'currentTime': 3.0, 'playerState': 1}),
      ];

      final frames = decoder.add(combined);
      expect(frames, hasLength(3));
      expect(
        frames
            .cast<HereSphereStateFrame>()
            .map((f) => f.snapshot.currentTime)
            .toList(),
        [1.0, 2.0, 3.0],
      );
    });

    test('a zero-length frame is a reset, not a broken stream', () {
      final decoder = HereSphereFrameDecoder();
      final frames = decoder.add([
        ...bytes([0, 0, 0, 0]),
        ...frame({'currentTime': 5.0, 'playerState': 0}),
      ]);
      expect(frames.first, isA<HereSphereResetFrame>());
      expect(frames.last, isA<HereSphereStateFrame>());
      expect(decoder.desynchronised, isFalse);
    });

    test('a negative length is also a reset', () {
      final decoder = HereSphereFrameDecoder();
      final frames = decoder.add(bytes([0xFF, 0xFF, 0xFF, 0xFF]));
      expect(frames.single, isA<HereSphereResetFrame>());
      expect(decoder.desynchronised, isFalse);
    });

    test('an impossible length desynchronises rather than allocating', () {
      // A misaligned prefix can name a gigabyte. Trusting it would be the
      // easiest way to run the application out of memory from the network.
      final decoder = HereSphereFrameDecoder();
      decoder.add(bytes([0xFF, 0xFF, 0xFF, 0x7F]));
      expect(decoder.desynchronised, isTrue);
      // Once desynchronised there is nothing to resynchronise on, so it stops.
      expect(decoder.add(frame({'currentTime': 1.0})), isEmpty);
    });

    test('a payload that is not JSON is dropped, and the stream survives', () {
      final decoder = HereSphereFrameDecoder();
      final garbage = utf8.encode('not json');
      final header = Uint8List(4);
      ByteData.sublistView(header).setInt32(0, garbage.length, Endian.little);

      final frames = decoder.add([
        ...header,
        ...garbage,
        ...frame({'currentTime': 9.0, 'playerState': 0}),
      ]);

      expect(frames, hasLength(1));
      expect((frames.single as HereSphereStateFrame).snapshot.currentTime, 9.0);
      expect(decoder.desynchronised, isFalse);
    });

    test('reset clears a half-read frame', () {
      final decoder = HereSphereFrameDecoder();
      final whole = frame({'currentTime': 1.0});
      decoder.add(whole.sublist(0, 6));
      decoder.reset();
      // Without the clear, the leftover head would be parsed as the start of
      // the next connection's stream.
      final frames = decoder.add(frame({'currentTime': 4.0, 'playerState': 0}));
      expect(frames, hasLength(1));
      expect((frames.single as HereSphereStateFrame).snapshot.currentTime, 4.0);
    });
  });

  group('HereSphereSnapshot', () {
    test('reads the documented fields', () {
      final snapshot = HereSphereSnapshot.fromJson({
        'resource': 'http://host/hs/tok/media/abc',
        'duration': 120.0,
        'currentTime': 30.5,
        'playbackSpeed': 1.25,
        'playerState': 0,
      });
      expect(snapshot!.resource, 'http://host/hs/tok/media/abc');
      expect(snapshot.duration, 120.0);
      expect(snapshot.currentTime, 30.5);
      expect(snapshot.playbackSpeed, 1.25);
      expect(snapshot.state, HereSpherePlayerState.playing);
    });

    test('falls back to `path` when `resource` is absent', () {
      final snapshot = HereSphereSnapshot.fromJson({
        'path': r'C:\videos\clip.mp4',
        'playerState': 1,
      });
      expect(snapshot!.resource, r'C:\videos\clip.mp4');
      expect(snapshot.state, HereSpherePlayerState.paused);
    });

    test('an unknown player state is not treated as playing', () {
      // Guessing "playing" for a value this build does not know would let the
      // device run on a state nobody verified.
      final snapshot = HereSphereSnapshot.fromJson({'playerState': 7});
      expect(snapshot!.state, HereSpherePlayerState.unknown);
      expect(snapshot.isPlaying, isFalse);
    });

    test('a missing player state is not playing either', () {
      expect(
        HereSphereSnapshot.fromJson({'currentTime': 1.0})!.isPlaying,
        isFalse,
      );
    });

    test('a non-map payload is not a snapshot', () {
      expect(HereSphereSnapshot.fromJson('hello'), isNull);
      expect(HereSphereSnapshot.fromJson(null), isNull);
    });
  });

  group('encodeHereSphereFrame', () {
    test('prefixes the payload length little-endian', () {
      final encoded = encodeHereSphereFrame({'currentTime': 1.0});
      final length = ByteData.sublistView(
        encoded,
        0,
        4,
      ).getInt32(0, Endian.little);
      expect(length, encoded.length - 4);
      expect(jsonDecode(utf8.decode(encoded.sublist(4))), {'currentTime': 1.0});
    });

    test('round-trips through the decoder', () {
      final decoder = HereSphereFrameDecoder();
      final frames = decoder.add(
        encodeHereSphereFrame({'currentTime': 7.5, 'playerState': 1}),
      );
      final snapshot = (frames.single as HereSphereStateFrame).snapshot;
      expect(snapshot.currentTime, 7.5);
      expect(snapshot.state, HereSpherePlayerState.paused);
    });

    test('the keepalive is an empty frame', () {
      expect(hereSphereKeepaliveFrame, hasLength(4));
      expect(hereSphereKeepaliveFrame, everyElement(0));
    });
  });
}
