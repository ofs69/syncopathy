import 'package:flutter_test/flutter_test.dart';
import 'package:syncopathy/heresphere/heresphere_media_resolver.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';

MediaFile entry(String hash, String path, {bool missing = false}) => MediaFile(
  name: hash,
  mediaPath: path,
  fileHash: hash,
  playCount: 0,
  fileNotFound: missing,
);

void main() {
  late MediaFile clip;
  late MediaFile other;
  late List<MediaFile> library;
  late HereSphereMediaResolver resolver;

  setUp(() {
    clip = entry('hash-clip', r'Q:\media\clip.mp4');
    other = entry('hash-other', r'Q:\media\other.mp4');
    library = [clip, other];
    resolver = HereSphereMediaResolver(
      byHash: (hash) => library.where((m) => m.fileHash == hash).firstOrNull,
      allMedia: () => library,
    );
  });

  group('by identifier', () {
    test('resolves an id this server issued', () {
      expect(resolver.byId('hash-clip'), clip);
    });

    test('an unknown id resolves to nothing', () {
      expect(resolver.byId('not-an-id'), isNull);
      expect(resolver.byId(''), isNull);
      expect(resolver.byId(null), isNull);
    });

    test('resolves the video URL HereSphere echoes back as the id', () {
      // Events do not carry the bare identifier: HereSphere reports the whole
      // metadata URL it fetched the entry from. Without this the session never
      // learns what is playing, and nothing hands over.
      expect(
        resolver.byId(
          'http://192.168.1.5:9678/hs/abcdef123456/video/hash-clip',
        ),
        clip,
      );
    });

    test('a video URL naming an unknown entry still resolves to nothing', () {
      expect(
        resolver.byId('http://192.168.1.5:9678/hs/abcdef123456/video/nope'),
        isNull,
      );
    });

    test('a trailing slash or query does not become part of the id', () {
      expect(
        resolver.byId('http://host:9678/hs/tok/video/hash-clip?x=1'),
        clip,
      );
      expect(resolver.byId('http://host:9678/hs/tok/video/hash-clip/'), clip);
    });

    test('an exact identifier wins over its own last segment', () {
      // A hash containing a separator must not be truncated before it is
      // tried as it stands.
      library = [entry('a/b', r'Q:\mediab.mp4'), entry('b', r'Q:\media.mp4')];
      expect(resolver.byId('a/b')?.fileHash, 'a/b');
    });

    test('an entry whose file is gone resolves to nothing', () {
      // Nothing to stream and nothing to drive, so it must not become the
      // session's current media.
      library = [entry('hash-gone', r'Q:\media\gone.mp4', missing: true)];
      expect(resolver.byId('hash-gone'), isNull);
    });
  });

  group('by streamed resource', () {
    test('takes the identifier out of a URL this server issued', () {
      expect(
        resolver.byResource(
          'http://192.168.1.5:9678/hs/abc123/media/hash-clip',
        ),
        clip,
      );
    });

    test('works after the token has been regenerated', () {
      // The player may still hold a URL from before the link was reissued. The
      // identifier in it is ours either way, and it is what names the media.
      expect(
        resolver.byResource(
          'http://host:9678/hs/a-different-token/media/hash-clip',
        ),
        clip,
      );
    });

    test('a URL naming an unknown id does not fall through to a filename', () {
      // The path ends in an identifier, not a filename; matching `hash-nope`
      // against the library by name would be a guess dressed up as a lookup.
      expect(
        resolver.byResource('http://host:9678/hs/tok/media/hash-nope'),
        isNull,
      );
    });

    test('falls back to a filename for a file the player opened itself', () {
      expect(resolver.byResource(r'D:\somewhere\else\clip.mp4'), clip);
      expect(resolver.byResource('file:///D:/somewhere/clip.mp4'), clip);
      expect(resolver.byResource('/mnt/media/other.mp4'), other);
    });

    test('the filename match is case-insensitive', () {
      expect(resolver.byResource(r'D:\elsewhere\CLIP.MP4'), clip);
    });

    test('an ambiguous filename resolves to nothing', () {
      // Two entries with the same name in different folders give no way to say
      // which is playing, and the wrong script driving a device is worse than
      // no script.
      library = [
        entry('hash-a', r'Q:\one\clip.mp4'),
        entry('hash-b', r'Q:\two\clip.mp4'),
      ];
      expect(resolver.byResource(r'D:\elsewhere\clip.mp4'), isNull);
    });

    test('a filename nothing matches resolves to nothing', () {
      expect(resolver.byResource(r'D:\elsewhere\unknown.mp4'), isNull);
      expect(resolver.byResource(''), isNull);
      expect(resolver.byResource(null), isNull);
    });

    test('a non-media route is not mistaken for one', () {
      expect(
        resolver.byResource('http://host:9678/hs/tok/video/hash-clip'),
        isNull,
      );
      expect(
        resolver.byResource('http://host:9678/hs/tok/thumb/hash-clip'),
        isNull,
      );
    });

    test('a media segment outside our prefix is not trusted', () {
      // Some other server's `/media/<something>` must not be read as one of our
      // identifiers.
      expect(
        resolver.byResource('http://elsewhere/api/media/hash-clip'),
        isNull,
      );
    });
  });

  test('an exact identifier outranks a filename that points elsewhere', () {
    // The ordering the plan calls for: an id we issued wins, always.
    final byId = resolver.byId('hash-other');
    final byName = resolver.byResource(r'D:\elsewhere\clip.mp4');
    expect(byId, other);
    expect(byName, clip);
    expect(byId ?? byName, other);
  });
}
