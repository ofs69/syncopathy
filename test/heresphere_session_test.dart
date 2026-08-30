import 'package:flutter_test/flutter_test.dart';
import 'package:syncopathy/heresphere/heresphere_api.dart';
import 'package:syncopathy/heresphere/heresphere_event.dart';
import 'package:syncopathy/heresphere/heresphere_library.dart';
import 'package:syncopathy/heresphere/heresphere_server.dart';

void main() {
  group('ClientClaim', () {
    final start = DateTime(2026, 1, 1, 12);
    const timeout = Duration(minutes: 10);

    test('the first client through gets the session', () {
      final claim = ClientClaim(timeout: timeout);
      expect(claim.claim('10.0.0.5', start), isTrue);
      expect(claim.holder, '10.0.0.5');
    });

    test('the holder keeps it across requests', () {
      final claim = ClientClaim(timeout: timeout);
      claim.claim('10.0.0.5', start);
      expect(
        claim.claim('10.0.0.5', start.add(const Duration(hours: 3))),
        isTrue,
      );
    });

    test('a second client is refused while the holder is active', () {
      final claim = ClientClaim(timeout: timeout);
      claim.claim('10.0.0.5', start);
      expect(
        claim.claim('10.0.0.9', start.add(const Duration(minutes: 5))),
        isFalse,
      );
      expect(claim.holder, '10.0.0.5');
    });

    test('browsing quietly does not hand the session away', () {
      // HereSphere goes silent between scanning the library and opening a
      // video; the claim has to outlast that.
      final claim = ClientClaim(timeout: timeout);
      claim.claim('10.0.0.5', start);
      final later = start.add(const Duration(minutes: 9));
      expect(claim.claim('10.0.0.9', later), isFalse);
      expect(claim.claim('10.0.0.5', later), isTrue);
    });

    test('a claim expires once the holder has gone quiet past the timeout', () {
      final claim = ClientClaim(timeout: timeout);
      claim.claim('10.0.0.5', start);
      expect(
        claim.claim('10.0.0.9', start.add(const Duration(minutes: 11))),
        isTrue,
      );
      expect(claim.holder, '10.0.0.9');
    });

    test('each accepted request renews the window', () {
      final claim = ClientClaim(timeout: timeout);
      claim.claim('10.0.0.5', start);
      claim.claim('10.0.0.5', start.add(const Duration(minutes: 9)));
      // Eleven minutes after the first request, but only two after the last.
      expect(
        claim.claim('10.0.0.9', start.add(const Duration(minutes: 11))),
        isFalse,
      );
    });

    test('release frees the session immediately', () {
      final claim = ClientClaim(timeout: timeout);
      claim.claim('10.0.0.5', start);
      claim.release();
      expect(claim.holder, isNull);
      expect(claim.claim('10.0.0.9', start), isTrue);
    });
  });

  group('HereSphereEvent', () {
    test('decodes a full payload', () {
      final event = HereSphereEvent.fromJson({
        'id': 'abc',
        'title': 'A Clip',
        'event': 2,
        'time': 12.5,
        'speed': 1.5,
        'utc': 1772000000.25,
      });
      expect(event, isNotNull);
      expect(event!.kind, HereSphereEventKind.pause);
      expect(event.id, 'abc');
      expect(event.title, 'A Clip');
      expect(event.time, 12.5);
      expect(event.speed, 1.5);
      expect(event.utc, 1772000000.25);
    });

    test('maps each wire value to its transition', () {
      for (final (wire, kind) in const [
        (0, HereSphereEventKind.open),
        (1, HereSphereEventKind.play),
        (2, HereSphereEventKind.pause),
        (3, HereSphereEventKind.close),
      ]) {
        expect(HereSphereEvent.fromJson({'event': wire})?.kind, kind);
      }
    });

    test('an unfamiliar transition decodes rather than throwing', () {
      // A newer player build must not be able to break event handling
      // wholesale by adding a value.
      expect(
        HereSphereEvent.fromJson({'event': 99})?.kind,
        HereSphereEventKind.unknown,
      );
    });

    test('integers where doubles are expected still decode', () {
      final event = HereSphereEvent.fromJson({'event': 1, 'time': 12});
      expect(event?.time, 12.0);
    });

    test('a payload with no event is not one', () {
      expect(HereSphereEvent.fromJson({'time': 1.0}), isNull);
      expect(HereSphereEvent.fromJson({'event': 'play'}), isNull);
      expect(HereSphereEvent.fromJson('play'), isNull);
      expect(HereSphereEvent.fromJson(null), isNull);
    });

    test('fields of the wrong type are dropped, not fatal', () {
      final event = HereSphereEvent.fromJson({
        'event': 1,
        'id': 42,
        'time': 'soon',
      });
      expect(event, isNotNull);
      expect(event!.id, isNull);
      expect(event.time, isNull);
    });
  });

  group('HereSphereApi', () {
    const api = HereSphereApi('http://host:9678/hs/tok');
    const entry = HereSphereEntry(
      id: 'the-id',
      title: 'Clip',
      mediaPath: r'C:\media\secret folder\clip.mp4',
    );

    test('an entry with no metadata still produces a usable response', () {
      final body = api.videoData(entry);
      expect(body['title'], 'Clip');
      // Absent rather than zero: a duration of 0 would read as a real value.
      expect(body.containsKey('duration'), isFalse);
      expect(body.containsKey('rating'), isFalse);
      expect(body.containsKey('dateAdded'), isFalse);
      expect(body.containsKey('tags'), isFalse);
    });

    test('the media path is never serialised', () {
      // The client gets identifiers only; a path in a response would tell it
      // about the filesystem and invite it to ask for one back.
      final encoded = api.videoData(entry).toString();
      expect(encoded, isNot(contains('secret folder')));
      expect(encoded, isNot(contains('clip.mp4')));
    });

    test('identifiers are escaped into URLs', () {
      const odd = HereSphereEntry(id: 'a/b c', title: 'x', mediaPath: 'x.mp4');
      expect(api.mediaUrl(odd.id), 'http://host:9678/hs/tok/media/a%2Fb%20c');
    });

    test('the index lists one URL per entry, per section', () {
      final body = api.index([
        const HereSphereSection(name: 'Interactive', entries: [entry]),
        const HereSphereSection(name: 'Empty', entries: []),
      ]);
      final sections = body['library'] as List;
      expect(sections, hasLength(2));
      expect(sections[0]['list'], ['http://host:9678/hs/tok/video/the-id']);
      expect(sections[1]['list'], isEmpty);
    });
  });
}
