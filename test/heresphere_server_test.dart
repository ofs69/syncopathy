import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:syncopathy/heresphere/heresphere_api.dart';
import 'package:syncopathy/heresphere/heresphere_auth.dart';
import 'package:syncopathy/heresphere/heresphere_library.dart';
import 'package:syncopathy/heresphere/heresphere_mode.dart';
import 'package:syncopathy/heresphere/heresphere_server.dart';

/// A library backed by whatever the test put on disk, so the request handling
/// can be driven without ObjectBox or a media scan.
class _FakeLibrary implements HereSphereLibrary {
  final Map<String, HereSphereEntry> entries;
  final Map<String, Uint8List> thumbnails;
  final Map<String, List<Uint8List>> scriptFiles;

  _FakeLibrary(
    this.entries, {
    Map<String, Uint8List>? thumbnails,
    Map<String, List<Uint8List>>? scriptFiles,
  }) : thumbnails = thumbnails ?? {},
       scriptFiles = scriptFiles ?? {};

  @override
  List<HereSphereSection> sections() => [
    HereSphereSection(name: 'Interactive', entries: entries.values.toList()),
  ];

  @override
  HereSphereEntry? entryById(String id) => entries[id];

  @override
  List<HereSphereEntry> allEntries() => entries.values.toList();

  @override
  Future<HereSphereThumbnail?> thumbnail(HereSphereEntry entry) async {
    final bytes = thumbnails[entry.id];
    return bytes == null ? null : HereSphereThumbnail(bytes, 'image/jpeg');
  }

  @override
  List<HereSphereScript> scripts(HereSphereEntry entry) {
    final files = scriptFiles[entry.id] ?? const [];
    return [
      for (var i = 0; i < files.length; i++)
        HereSphereScript(index: i, name: i == 0 ? 'Script' : 'axis$i'),
    ];
  }

  @override
  Future<Uint8List?> scriptBytes(HereSphereEntry entry, int index) async {
    final files = scriptFiles[entry.id] ?? const [];
    return index >= 0 && index < files.length ? files[index] : null;
  }
}

/// One response, already read into memory. Fine for tests; the server itself
/// never does this.
class _Response {
  final int statusCode;
  final HttpHeaders headers;
  final List<int> body;

  _Response(this.statusCode, this.headers, this.body);

  String get text => utf8.decode(body);
  Map<String, dynamic> get json => jsonDecode(text) as Map<String, dynamic>;
  String? header(String name) => headers.value(name);
}

void main() {
  late Directory tempDir;
  late File mediaFile;
  late Uint8List mediaBytes;
  late _FakeLibrary library;
  late HereSphereServer server;
  late ClientClaim claim;
  late HttpClient client;
  late String origin;

  /// Prefix carrying the session token the login handed back. Every route but
  /// the index lives under it.
  late String base;

  const username = 'tester';
  const password = 'correct horse battery staple';
  const mediaId = 'hash-of-the-media';

  /// Big enough that a full read spans many chunks, so range arithmetic cannot
  /// pass by accident on a single-chunk file.
  const mediaLength = 300 * 1024;

  /// Posts credentials to the index and returns the whole response.
  Future<_Response> login({
    String user = username,
    String pass = password,
  }) async {
    final req = await client.postUrl(Uri.parse('$origin/'));
    req.write(jsonEncode({'username': user, 'password': pass}));
    final response = await req.close();
    final bytes = <int>[];
    await for (final chunk in response) {
      bytes.addAll(chunk);
    }
    return _Response(response.statusCode, response.headers, bytes);
  }

  /// Posts credentials to an absolute path, the way the player reaches the
  /// endpoints it derives from the URL a person typed.
  Future<_Response> postTo(
    String path, {
    String? user = username,
    String? pass = password,
  }) async {
    final req = await client.postUrl(Uri.parse('$origin$path'));
    if (user != null && pass != null) {
      req.write(jsonEncode({'username': user, 'password': pass}));
    }
    final response = await req.close();
    final bytes = <int>[];
    await for (final chunk in response) {
      bytes.addAll(chunk);
    }
    return _Response(response.statusCode, response.headers, bytes);
  }

  /// Logs in and returns the tokenised prefix from the URLs it was given.
  Future<String> signIn() async {
    final body = (await login()).json;
    final first =
        ((body['library'] as List).first['list'] as List).first as String;
    // .../hs/<token>/video/<id> -> .../hs/<token>
    return first.substring(0, first.indexOf('/video/'));
  }

  Future<_Response> request(
    String path, {
    String method = 'GET',
    String? range,
    String? host,
    String? body,
  }) async {
    final uri = Uri.parse('$base$path');
    final req = await client.openUrl(method, uri);
    if (range != null) req.headers.set(HttpHeaders.rangeHeader, range);
    if (host != null) req.headers.set(HttpHeaders.hostHeader, host);
    if (body != null) req.write(body);
    final response = await req.close();
    final bytes = <int>[];
    await for (final chunk in response) {
      bytes.addAll(chunk);
    }
    return _Response(response.statusCode, response.headers, bytes);
  }

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('heresphere_test');
    mediaFile = File('${tempDir.path}${Platform.pathSeparator}clip.mp4');
    final random = Random(1234);
    mediaBytes = Uint8List.fromList([
      for (var i = 0; i < mediaLength; i++) random.nextInt(256),
    ]);
    await mediaFile.writeAsBytes(mediaBytes);

    library = _FakeLibrary(
      {
        mediaId: HereSphereEntry(
          id: mediaId,
          title: 'A Clip',
          mediaPath: mediaFile.path,
          durationSeconds: 12.5,
          width: 3840,
          height: 2160,
          addedOn: DateTime(2026, 3, 4),
          rating: 5.0,
          isFavorite: true,
          hasFunscript: true,
          playCount: 3,
          tags: const ['Interactive:Yes', 'Resolution:4K'],
        ),
      },
      thumbnails: {
        mediaId: Uint8List.fromList([1, 2, 3, 4]),
      },
      scriptFiles: {
        mediaId: [
          Uint8List.fromList(utf8.encode('{"actions":[]}')),
          Uint8List.fromList(utf8.encode('{"actions":[1]}')),
        ],
      },
    );

    // Held so a test can stand a rival player up. Two clients cannot be told
    // apart over loopback — every one of them keys as `loopback` — so injecting
    // the claim is the only way to exercise the rule at all.
    claim = ClientClaim();
    server = HereSphereServer(library, claim: claim);
    // Port 0: the OS picks a free one, so tests never collide with a real
    // server or with each other.
    await server.start(
      address: '127.0.0.1',
      port: 0,
      auth: HereSphereAuth(
        username: username,
        password: await hashHereSpherePassword(password),
      ),
    );
    expect(server.state.value, HereSphereServerState.running);
    origin = 'http://127.0.0.1:${server.port}';
    client = HttpClient();
    base = await signIn();
  });

  tearDown(() async {
    client.close(force: true);
    await server.dispose();
    await tempDir.delete(recursive: true);
  });

  group('authentication', () {
    test('an unauthenticated index asks the player to log in', () async {
      // HereSphere reads `access` to decide whether to prompt. Nothing about
      // the library is revealed before it does.
      final req = await client.getUrl(Uri.parse('$origin/'));
      final response = await req.close();
      final bytes = <int>[];
      await for (final chunk in response) {
        bytes.addAll(chunk);
      }
      final body = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;

      expect(body['access'], hereSphereAccessLoginRequired);
      expect(body['library'], isEmpty);
      expect(response.headers.value(hereSphereJsonVersionHeader), '1');
    });

    test(
      'the blank login the player sends first is not a failed attempt',
      () async {
        final body = (await login(user: '', pass: '')).json;
        expect(body['access'], hereSphereAccessLoginRequired);
        // It must not count towards the lockout, or a player that prompts twice
        // would lock the user out before they had typed anything.
        expect(server.throttle.failureCount('loopback'), 0);
      },
    );

    test('a wrong password is reported as a failed login', () async {
      final body = (await login(pass: 'wrong')).json;
      expect(body['access'], hereSphereAccessDenied);
      expect(body['library'], isEmpty);
    });

    test('a wrong username is refused too', () async {
      expect(
        (await login(user: 'nobody')).json['access'],
        hereSphereAccessDenied,
      );
    });

    test('the right credentials grant the library', () async {
      final body = (await login()).json;
      expect(body['access'], hereSphereAccessGranted);
      expect(body['library'], isNotEmpty);
    });

    test('repeated failures lock the address out', () async {
      // A LAN is not a safe place to leave an unlimited password oracle.
      for (var i = 0; i < 5; i++) {
        expect(
          (await login(pass: 'wrong$i')).json['access'],
          hereSphereAccessDenied,
        );
      }
      // Even the correct password is refused while the lockout stands.
      expect((await login()).json['access'], hereSphereAccessDenied);
    });

    test('a successful login clears the failure count', () async {
      await login(pass: 'wrong');
      expect(server.throttle.failureCount('loopback'), 1);
      await login();
      expect(server.throttle.failureCount('loopback'), 0);
    });

    test('a server with no password set refuses everyone', () async {
      // The safe reading of "not configured" is closed, not open.
      final locked = HereSphereServer(_FakeLibrary({}));
      addTearDown(locked.dispose);
      await locked.start(address: '127.0.0.1', port: 0, auth: null);

      final req = await client.postUrl(
        Uri.parse('http://127.0.0.1:${locked.port}/'),
      );
      req.write(jsonEncode({'username': username, 'password': password}));
      final response = await req.close();
      final bytes = <int>[];
      await for (final chunk in response) {
        bytes.addAll(chunk);
      }
      expect(
        (jsonDecode(utf8.decode(bytes)) as Map)['access'],
        hereSphereAccessLoginRequired,
      );
    });
  });

  group('session tokens', () {
    test('each login gets its own token', () async {
      final first = await signIn();
      final second = await signIn();
      expect(first, isNot(second));
      // Both stay valid: a second headset does not evict the first.
      expect((await request('/video/$mediaId')).statusCode, HttpStatus.ok);
      base = first;
      expect((await request('/video/$mediaId')).statusCode, HttpStatus.ok);
      base = second;
    });

    test('an invented token cannot reach media', () async {
      base = '$origin/$hereSpherePathPrefix/not-a-real-session-token';
      expect(
        (await request('/media/$mediaId')).statusCode,
        HttpStatus.notFound,
      );
      expect(
        (await request('/thumb/$mediaId')).statusCode,
        HttpStatus.notFound,
      );
    });

    test(
      'an invented token on a JSON route sends the player back to log in',
      () async {
        // A 404 here would leave HereSphere with a dead library rather than a
        // prompt it can act on.
        base = '$origin/$hereSpherePathPrefix/not-a-real-session-token';
        final response = await request('/video/$mediaId');
        expect(response.json['access'], hereSphereAccessLoginRequired);
      },
    );

    test('signing out kills the tokens already handed out', () async {
      expect((await request('/media/$mediaId')).statusCode, HttpStatus.ok);

      server.revokeSessions();

      expect(
        (await request('/media/$mediaId')).statusCode,
        HttpStatus.notFound,
      );
    });

    test('changing the password signs every device out', () async {
      // Otherwise a device that was signed in keeps its access, and changing
      // the password would mean nothing until a restart.
      expect((await request('/media/$mediaId')).statusCode, HttpStatus.ok);

      server.setAuth(
        HereSphereAuth(
          username: username,
          password: await hashHereSpherePassword('something else'),
        ),
      );

      expect(
        (await request('/media/$mediaId')).statusCode,
        HttpStatus.notFound,
      );
    });

    test('stopping the server invalidates everything', () async {
      await server.stop();
      expect(server.isRunning, isFalse);
      // A closure, so the matcher invokes and awaits it rather than being
      // handed the future as a plain value.
      await expectLater(
        () => request('/video/$mediaId'),
        throwsA(anyOf(isA<SocketException>(), isA<HttpException>())),
      );
    });

    test('a path outside the prefix is a 404', () async {
      final req = await client.getUrl(Uri.parse('$origin/etc/passwd'));
      final response = await req.close();
      await response.drain<void>();
      expect(response.statusCode, HttpStatus.notFound);
    });
  });

  group('index', () {
    test('advertises the JSON version and tokenised video URLs', () async {
      final response = await login();
      expect(response.statusCode, HttpStatus.ok);
      expect(response.header(hereSphereJsonVersionHeader), '1');

      final body = response.json;
      expect(body['access'], hereSphereAccessGranted);
      final sections = body['library'] as List;
      expect(sections, hasLength(1));
      expect(sections.first['name'], 'Interactive');

      // Each login mints its own token, so this asserts the shape rather than
      // the one the fixture happens to hold.
      final url = (sections.first['list'] as List).single as String;
      expect(url, startsWith('$origin/$hereSpherePathPrefix/'));
      expect(url, endsWith('/video/$mediaId'));
    });

    test('URLs follow the Host the client reached us on', () async {
      // A headset reaches the LAN address; the URLs it gets back have to keep
      // pointing there rather than at whichever interface we guessed.
      final req = await client.postUrl(Uri.parse('$origin/'));
      req.headers.set(HttpHeaders.hostHeader, 'syncopathy.local:9678');
      req.write(jsonEncode({'username': username, 'password': password}));
      final response = await req.close();
      final bytes = <int>[];
      await for (final chunk in response) {
        bytes.addAll(chunk);
      }
      final body = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
      final list = (body['library'] as List).first['list'] as List;
      expect(
        list.first,
        startsWith('http://syncopathy.local:9678/$hereSpherePathPrefix/'),
      );
    });
  });

  group('video metadata', () {
    test('reports duration in milliseconds and links the media', () async {
      final body = (await request('/video/$mediaId')).json;
      expect(body['title'], 'A Clip');
      expect(body['duration'], 12500.0);
      expect(body['dateAdded'], '2026-03-04');
      expect(body['rating'], 5.0);
      expect(body['isFavorite'], true);
      expect(body['eventServer'], '$base/event');
      expect(body['thumbnailImage'], '$base/thumb/$mediaId');

      final source = (body['media'] as List).first['sources'][0];
      expect(source['url'], '$base/media/$mediaId');
      expect(source['width'], 3840);
      expect(source['height'], 2160);
      expect(source['size'], mediaLength);
    });

    test(
      'publishes no funscript URL while Syncopathy drives the device',
      () async {
        // The default mode. A script URL is exactly what would let HereSphere
        // command the hardware Syncopathy is already commanding.
        expect(server.deviceOwner.value, HereSphereDeviceOwner.syncopathy);
        final body = (await request('/video/$mediaId')).json;
        expect(body.containsKey('scripts'), isFalse);
        // The entry is still marked interactive, without the script itself.
        expect(body['tags'], [
          {'name': 'Interactive:Yes'},
          {'name': 'Resolution:4K'},
        ]);
      },
    );

    test('an unknown id is a 404', () async {
      final response = await request('/video/not-a-real-id');
      expect(response.statusCode, HttpStatus.notFound);
    });

    test('a path passed as an id resolves to nothing', () async {
      final response = await request(
        '/video/${Uri.encodeComponent('../../../etc/passwd')}',
      );
      expect(response.statusCode, HttpStatus.notFound);
    });
  });

  group('handing the device to HereSphere', () {
    setUp(() {
      server.deviceOwner.value = HereSphereDeviceOwner.hereSphere;
    });

    test('script URLs appear in the metadata', () async {
      final body = (await request('/video/$mediaId')).json;
      final scripts = body['scripts'] as List;
      expect(scripts, hasLength(2));
      expect(scripts[0]['name'], 'Script');
      expect(scripts[0]['url'], '$base/script/$mediaId/0');
      expect(scripts[1]['url'], '$base/script/$mediaId/1');
    });

    test('a script is served as stored', () async {
      // As stored, not as processed: in this mode HereSphere applies its own
      // settings, and reshaping it here would stack two sets of transforms.
      final response = await request('/script/$mediaId/0');
      expect(response.statusCode, HttpStatus.ok);
      expect(
        response.header(HttpHeaders.contentTypeHeader),
        startsWith('application/json'),
      );
      expect(response.text, '{"actions":[]}');
    });

    test('the second axis is reachable by its own index', () async {
      final response = await request('/script/$mediaId/1');
      expect(response.text, '{"actions":[1]}');
    });

    test('an index the entry does not have is a 404', () async {
      expect(
        (await request('/script/$mediaId/9')).statusCode,
        HttpStatus.notFound,
      );
      expect(
        (await request('/script/$mediaId/-1')).statusCode,
        HttpStatus.notFound,
      );
      expect(
        (await request('/script/$mediaId/x')).statusCode,
        HttpStatus.notFound,
      );
    });

    test('taking the device back kills the script URLs immediately', () async {
      // A headset that kept the URL from an earlier session must not keep
      // pulling scripts once Syncopathy is driving again.
      expect((await request('/script/$mediaId/0')).statusCode, HttpStatus.ok);

      server.deviceOwner.value = HereSphereDeviceOwner.syncopathy;

      expect(
        (await request('/script/$mediaId/0')).statusCode,
        HttpStatus.notFound,
      );
      final body = (await request('/video/$mediaId')).json;
      expect(body.containsKey('scripts'), isFalse);
    });
  });

  group('media streaming', () {
    test('serves the whole file when no range is asked for', () async {
      final response = await request('/media/$mediaId');
      expect(response.statusCode, HttpStatus.ok);
      expect(response.header(HttpHeaders.acceptRangesHeader), 'bytes');
      expect(response.header(HttpHeaders.contentTypeHeader), 'video/mp4');
      expect(response.body, hasLength(mediaLength));
      expect(response.body, mediaBytes);
    });

    test(
      'an open-ended range comes back as 206 with the right bytes',
      () async {
        final response = await request('/media/$mediaId', range: 'bytes=1024-');
        expect(response.statusCode, HttpStatus.partialContent);
        expect(
          response.header(HttpHeaders.contentRangeHeader),
          'bytes 1024-${mediaLength - 1}/$mediaLength',
        );
        expect(response.body, hasLength(mediaLength - 1024));
        expect(response.body, mediaBytes.sublist(1024));
      },
    );

    test('a closed range returns exactly that slice', () async {
      final response = await request('/media/$mediaId', range: 'bytes=100-199');
      expect(response.statusCode, HttpStatus.partialContent);
      expect(
        response.header(HttpHeaders.contentRangeHeader),
        'bytes 100-199/$mediaLength',
      );
      expect(response.body, mediaBytes.sublist(100, 200));
    });

    test('a suffix range returns the tail', () async {
      final response = await request('/media/$mediaId', range: 'bytes=-256');
      expect(response.statusCode, HttpStatus.partialContent);
      expect(response.body, mediaBytes.sublist(mediaLength - 256));
    });

    test('a range past the end is 416 and reports the real length', () async {
      final response = await request(
        '/media/$mediaId',
        range: 'bytes=${mediaLength + 10}-',
      );
      expect(response.statusCode, HttpStatus.requestedRangeNotSatisfiable);
      expect(
        response.header(HttpHeaders.contentRangeHeader),
        'bytes */$mediaLength',
      );
      expect(response.body, isEmpty);
    });

    test('HEAD reports the length without a body', () async {
      final response = await request('/media/$mediaId', method: 'HEAD');
      expect(response.statusCode, HttpStatus.ok);
      expect(response.header(HttpHeaders.acceptRangesHeader), 'bytes');
      expect(response.header(HttpHeaders.contentLengthHeader), '$mediaLength');
      expect(response.body, isEmpty);
    });

    test('HEAD with a range reports the slice without a body', () async {
      final response = await request(
        '/media/$mediaId',
        method: 'HEAD',
        range: 'bytes=0-99',
      );
      expect(response.statusCode, HttpStatus.partialContent);
      expect(response.header(HttpHeaders.contentLengthHeader), '100');
      expect(response.body, isEmpty);
    });

    test('repeated seeks stay correct and independent', () async {
      // Scrubbing is a burst of ranges all over the file. Each one has to be
      // resolved against the file, not against where the last one left off.
      for (final start in [0, 4096, mediaLength ~/ 2, mediaLength - 4096]) {
        final end = start + 511;
        final response = await request(
          '/media/$mediaId',
          range: 'bytes=$start-$end',
        );
        expect(response.statusCode, HttpStatus.partialContent);
        expect(response.body, mediaBytes.sublist(start, end + 1));
      }
    });

    test('the media of a missing file is a 404, not a crash', () async {
      await mediaFile.delete();
      final response = await request('/media/$mediaId');
      expect(response.statusCode, HttpStatus.notFound);
    });

    test('abandoning a response leaves the server able to answer', () async {
      // Exactly what a seek does: drop the response in flight and ask again.
      final req = await client.getUrl(Uri.parse('$base/media/$mediaId'));
      final response = await req.close();
      final subscription = response.listen(null);
      await subscription.cancel();

      final next = await request('/media/$mediaId', range: 'bytes=0-9');
      expect(next.statusCode, HttpStatus.partialContent);
      expect(next.body, mediaBytes.sublist(0, 10));
    });
  });

  group('thumbnails', () {
    test('serves cached JPEG bytes', () async {
      final response = await request('/thumb/$mediaId');
      expect(response.statusCode, HttpStatus.ok);
      expect(response.header(HttpHeaders.contentTypeHeader), 'image/jpeg');
      expect(response.body, [1, 2, 3, 4]);
    });

    test('an id with no thumbnail is a 404', () async {
      final response = await request('/thumb/unknown');
      expect(response.statusCode, HttpStatus.notFound);
    });
  });

  group('events', () {
    test('a posted event reaches the event stream', () async {
      final received = server.events.first;
      final response = await request(
        '/event',
        method: 'POST',
        body: jsonEncode({
          'id': mediaId,
          'event': 1,
          'time': 42.5,
          'speed': 1.0,
          'utc': 1772000000.0,
        }),
      );
      expect(response.statusCode, HttpStatus.ok);

      final event = await received;
      expect(event.kind.name, 'play');
      expect(event.id, mediaId);
      expect(event.time, 42.5);
    });

    test('a malformed body is still answered 200', () async {
      // A rejection tells HereSphere nothing useful, and an endpoint that looks
      // broken could make it stop sending events at all.
      final response = await request(
        '/event',
        method: 'POST',
        body: 'not json at all',
      );
      expect(response.statusCode, HttpStatus.ok);
    });

    test('an oversized body is refused without being buffered', () async {
      final response = await request(
        '/event',
        method: 'POST',
        body: 'x' * (128 * 1024),
      );
      expect(response.statusCode, HttpStatus.ok);
    });

    test('GET is not allowed on the event endpoint', () async {
      final response = await request('/event');
      expect(response.statusCode, HttpStatus.methodNotAllowed);
      expect(response.header(HttpHeaders.allowHeader), 'POST');
    });
  });

  group('one player drives, the rest may look', () {
    /// Hands the clock to somebody who is not this test's client.
    void rivalIsDriving() => claim.claim('192.168.1.50', DateTime.now());

    test('a rival driver does not close the library', () async {
      rivalIsDriving();

      // None of this touches the clock, so none of it is anyone's to lose.
      expect((await login()).json['access'], hereSphereAccessGranted);
      expect((await postTo('/scan')).json['access'], hereSphereAccessGranted);
      expect((await request('/video/$mediaId')).statusCode, HttpStatus.ok);
      expect((await request('/thumb/$mediaId')).statusCode, HttpStatus.ok);
      expect((await request('/media/$mediaId')).statusCode, HttpStatus.ok);
    });

    test('a rival driver keeps playback events out', () async {
      rivalIsDriving();

      final response = await request(
        '/event',
        method: 'POST',
        body: jsonEncode({'id': mediaId, 'event': 1, 'time': 1.0}),
      );

      // Refused rather than ignored: a player whose events vanish looks to its
      // user like a device that stopped working.
      expect(response.statusCode, HttpStatus.forbidden);
    });

    test('browsing does not take the clock from nobody', () async {
      // Reads used to claim the session, which is what locked a headset out of
      // its own server for ten minutes after it came back on a new address.
      await request('/video/$mediaId');

      final response = await request(
        '/event',
        method: 'POST',
        body: jsonEncode({'id': mediaId, 'event': 1, 'time': 1.0}),
      );
      expect(response.statusCode, HttpStatus.ok);
    });

    test('a driver that has gone quiet gives way', () async {
      claim = ClientClaim(timeout: Duration.zero);
      claim.claim('192.168.1.50', DateTime(2020));

      // The rival is stale, so the clock is there for the taking.
      expect(claim.claim('loopback', DateTime.now()), isTrue);
    });

    test('the status panel still sees a client that only browsed', () async {
      rivalIsDriving();
      await request('/video/$mediaId');

      // "Has anything reached me" is a different question from "who is
      // driving", and the panel is asking the first one.
      expect(server.connectedClient.value, isNotNull);
    });

    test('a client that only browses cannot aim the timestamp channel', () async {
      // The channel dials whoever is driving, and Syncopathy opens that
      // connection outbound. Reads no longer need the claim, so without this a
      // phone browsing the library could point it at itself.
      //
      // On its own server, because the shared one has already recorded this
      // client's address at login — and an assertion that cannot come out the
      // other way proves nothing.
      final rival = ClientClaim();
      final other = HereSphereServer(library, claim: rival);
      addTearDown(other.dispose);
      await other.start(
        address: '127.0.0.1',
        port: 0,
        auth: HereSphereAuth(
          username: username,
          password: await hashHereSpherePassword(password),
        ),
      );
      // After starting, not before: a start stops first, and stopping releases
      // the claim along with everything else the old server was holding.
      rival.claim('192.168.1.50', DateTime.now());

      final origin = 'http://127.0.0.1:${other.port}';
      final req = await client.postUrl(Uri.parse('$origin/'));
      req.write(jsonEncode({'username': username, 'password': password}));
      final body = jsonDecode(
        await (await req.close()).transform(utf8.decoder).join(),
      );
      expect(body['access'], hereSphereAccessGranted);

      expect(other.clientAddress.value, isNull);
      // The panel still knows something arrived, which is a different question.
      expect(other.connectedClient.value, isNotNull);
    });
  });

  group('bulk metadata', () {
    // HereSphere reaches this by appending `/scan` to the library URL, so it
    // arrives with no session token and has to log in for itself.

    test('describes the whole library in one response', () async {
      final body = (await postTo('/scan')).json;

      expect(body['access'], hereSphereAccessGranted);
      final data = body['scanData'] as List;
      expect(data, hasLength(1));

      final entry = data.first as Map<String, dynamic>;
      expect(entry['title'], 'A Clip');
      expect(entry['isFavorite'], isTrue);
      expect(entry['rating'], 5.0);
      expect(entry['dateAdded'], '2026-03-04');
      expect(entry['tags'], [
        {'name': 'Interactive:Yes'},
        {'name': 'Resolution:4K'},
      ]);
    });

    test('links point at the per-entry metadata URL', () async {
      // Each login mints its own token, so only the shape can be asserted —
      // the prefix from `setUp` belongs to a different session.
      final data = (await postTo('/scan')).json['scanData'] as List;
      final link = (data.first as Map<String, dynamic>)['link'] as String;

      expect(link, startsWith('$origin/$hereSpherePathPrefix/'));
      expect(link, endsWith('/video/$mediaId'));
    });

    test('publishes duration in seconds', () async {
      // Deliberately not the milliseconds `videoData` uses. See the note there:
      // this follows the only implementation with evidence behind it.
      final data = (await postTo('/scan')).json['scanData'] as List;
      expect((data.first as Map<String, dynamic>)['duration'], 12.5);
    });

    test('reveals nothing before a login', () async {
      final body = (await postTo('/scan', user: null, pass: null)).json;
      expect(body['access'], hereSphereAccessLoginRequired);
      expect(body['scanData'], isEmpty);
    });

    test('a wrong password is refused', () async {
      final body = (await postTo('/scan', pass: 'wrong')).json;
      expect(body['access'], hereSphereAccessDenied);
      expect(body['scanData'], isEmpty);
    });

    test('the /heresphere spelling works too', () async {
      // Either URL could be the one the user typed into the player.
      final body = (await postTo('/heresphere/scan')).json;
      expect(body['access'], hereSphereAccessGranted);
      expect(body['scanData'], hasLength(1));
    });

    test(
      'a stale token on a scan route sends the player back to log in',
      () async {
        server.revokeSessions();
        final body = (await request('/scan')).json;
        expect(body['access'], hereSphereAccessLoginRequired);
      },
    );
  });

  test('an unknown route under a valid token is a 404', () async {
    final response = await request('/nope');
    expect(response.statusCode, HttpStatus.notFound);
  });

  test('restarting on the same port succeeds', () async {
    // The settings panel restarts the server on every edit; a port left in
    // TIME_WAIT would make the second start fail.
    final port = server.port!;
    final auth = HereSphereAuth(
      username: username,
      password: await hashHereSpherePassword(password),
    );
    await server.start(address: '127.0.0.1', port: port, auth: auth);
    expect(server.state.value, HereSphereServerState.running);
    expect(server.port, port);
  });

  test('a port already taken is reported, not thrown', () async {
    final other = HereSphereServer(_FakeLibrary({}));
    addTearDown(other.dispose);
    await other.start(address: '127.0.0.1', port: server.port!, auth: null);
    expect(other.state.value, HereSphereServerState.failed);
    expect(other.lastError.value, isNotNull);
  });
}
