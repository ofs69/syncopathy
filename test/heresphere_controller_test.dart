import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:syncopathy/heresphere/heresphere_api.dart';
import 'package:syncopathy/heresphere/heresphere_auth.dart';
import 'package:syncopathy/heresphere/heresphere_controller.dart';
import 'package:syncopathy/heresphere/heresphere_event.dart';
import 'package:syncopathy/heresphere/heresphere_library.dart';
import 'package:syncopathy/heresphere/heresphere_mode.dart';
import 'package:syncopathy/heresphere/heresphere_server.dart';
import 'package:syncopathy/heresphere/password_words.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/player/playback_session.dart';

import 'support/fake_playback_session.dart';

class _EmptyLibrary implements HereSphereLibrary {
  @override
  List<HereSphereSection> sections() => const [];

  @override
  HereSphereEntry? entryById(String id) => null;

  @override
  List<HereSphereEntry> allEntries() => const [];

  @override
  Future<HereSphereThumbnail?> thumbnail(HereSphereEntry entry) async => null;

  @override
  List<HereSphereScript> scripts(HereSphereEntry entry) => const [];

  @override
  Future<Uint8List?> scriptBytes(HereSphereEntry entry, int index) async =>
      null;
}

/// Waits for the controller's queued lifecycle work to settle.
///
/// Starts are serialised behind a future rather than run inline, so a settings
/// write is not observable on the next microtask.
Future<void> settle() async {
  for (var i = 0; i < 20; i++) {
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
}

/// Polls until [condition] holds, so a test never sleeps longer than it has to.
Future<void> waitUntil(
  bool Function() condition, {
  Duration timeout = const Duration(seconds: 5),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (!condition() && DateTime.now().isBefore(deadline)) {
    await Future<void>.delayed(const Duration(milliseconds: 20));
  }
}

void main() {
  late SettingsModel settings;
  late HereSphereController controller;
  late FakePlaybackSession localSession;
  late ActivePlaybackSession activeSession;
  late MediaFile clip;

  /// What the controller's resolver returns. Swapped per test so a case can
  /// decide whether HereSphere is playing something the library knows.
  MediaFile? resolved;

  setUp(() {
    // No load(): the defaults are all this needs, and loading would want a
    // key-value store.
    settings = SettingsModel();
    settings.hereSphereBindAddress.value = '127.0.0.1';
    // Port 0 lets the OS pick, so the test never collides with a real server.
    settings.hereSpherePort.value = 0;
    // Nothing listens on this in the test, so the timestamp channel stays
    // unhealthy — which is the point for every case below except the ones that
    // drive the session directly.
    settings.hereSphereTimestampHost.value = '';
    clip = MediaFile(
      name: 'clip',
      mediaPath: r'Q:\media\clip.mp4',
      fileHash: 'hash-clip',
      playCount: 0,
      fileNotFound: false,
    );
    resolved = clip;
    localSession = FakePlaybackSession();
    activeSession = ActivePlaybackSession(localSession);
    controller = HereSphereController(
      settings,
      _EmptyLibrary(),
      activeSession: activeSession,
      localSession: localSession,
      resolveMedia: (id, resource) => resolved,
    );
  });

  /// Rebuilds the controller with an abandon window a test can wait out.
  ///
  /// The real one is three quarters of a minute, which is the right answer for
  /// a headset and the wrong one for a test suite.
  Future<void> useShortAbandonWindow([
    Duration window = const Duration(milliseconds: 100),
  ]) async {
    await controller.dispose();
    controller = HereSphereController(
      settings,
      _EmptyLibrary(),
      activeSession: activeSession,
      localSession: localSession,
      resolveMedia: (id, resource) => resolved,
      abandonAfter: window,
    );
  }

  tearDown(() async {
    await controller.dispose();
  });

  test('nothing binds until the feature is enabled', () async {
    await settle();
    expect(controller.server.isRunning, isFalse);
    expect(controller.server.state.value, HereSphereServerState.stopped);
  });

  test('enabling starts the server', () async {
    settings.hereSphereEnabled.value = true;
    await settle();

    expect(controller.server.state.value, HereSphereServerState.running);
    expect(controller.server.isRunning, isTrue);
  });

  test(
    'a server with no password set still binds, and refuses everyone',
    () async {
      // Not binding would read as the feature being broken. Binding and refusing
      // every login is the honest state, and the panel says so.
      settings.hereSphereEnabled.value = true;
      await settle();
      expect(settings.hereSphereHasPassword.value, isFalse);

      // urlFor reports the configured port, which is 0 here because the OS picked
      // the real one. Substitute what actually got bound.
      final bound = controller
          .urlFor('127.0.0.1')
          .replaceFirst('127.0.0.1:0', '127.0.0.1:${controller.server.port}');

      final client = HttpClient();
      addTearDown(() => client.close(force: true));
      final response = await (await client.getUrl(Uri.parse(bound))).close();
      final bytes = <int>[];
      await for (final chunk in response) {
        bytes.addAll(chunk);
      }
      expect(response.statusCode, HttpStatus.ok);
      expect(
        (jsonDecode(utf8.decode(bytes)) as Map)['access'],
        hereSphereAccessLoginRequired,
      );
    },
  );

  test('setting a password stores a hash, never the password', () async {
    await controller.setPassword('hunter2');

    final stored = settings.hereSpherePasswordHash.value;
    expect(stored, isNotEmpty);
    expect(stored, isNot(contains('hunter2')));
    expect(stored, startsWith('pbkdf2-sha256\$'));
    expect(settings.hereSphereHasPassword.value, isTrue);
  });

  test('the stored hash verifies the password it was made from', () async {
    await controller.setPassword('hunter2');
    final hash = HereSpherePasswordHash.decode(
      settings.hereSpherePasswordHash.value,
    );

    expect(await verifyHereSpherePassword('hunter2', hash!), isTrue);
    expect(await verifyHereSpherePassword('hunter3', hash), isFalse);
  });

  test('disabling stops the server', () async {
    settings.hereSphereEnabled.value = true;
    await settle();
    expect(controller.server.isRunning, isTrue);

    settings.hereSphereEnabled.value = false;
    await settle();
    expect(controller.server.isRunning, isFalse);
  });

  test('changing the password signs every device out', () async {
    // A session token was issued against the old credentials. Letting it
    // outlive them would make changing the password mean nothing.
    settings.hereSphereEnabled.value = true;
    await controller.setPassword('first');
    await settle();

    final token = controller.server.sessions.issue(DateTime.now());
    expect(controller.server.sessions.validate(token, DateTime.now()), isTrue);

    await controller.setPassword('second');
    await settle();

    expect(controller.server.sessions.validate(token, DateTime.now()), isFalse);
  });

  group('clock ownership', () {
    HereSphereEvent open() =>
        const HereSphereEvent(kind: HereSphereEventKind.open, id: 'hash-clip');

    setUp(() async {
      settings.hereSphereEnabled.value = true;
      await settle();
    });

    test('the local player keeps the clock until HereSphere opens', () {
      expect(activeSession.value, same(localSession));
      expect(controller.externalPlaybackActive.value, isFalse);
    });

    test('opening media hands the clock over', () {
      controller.session.applyEvent(open());

      expect(activeSession.value, same(controller.session));
      expect(controller.externalPlaybackActive.value, isTrue);
    });

    test('closing gives the clock back', () {
      controller.session.applyEvent(open());
      expect(activeSession.value, same(controller.session));

      controller.session.applyEvent(
        const HereSphereEvent(kind: HereSphereEventKind.close),
      );

      expect(activeSession.value, same(localSession));
    });

    test('media the library does not know never takes the clock', () {
      // There would be no script to drive from, so the local player keeps it.
      resolved = null;
      controller.session.applyEvent(open());

      expect(activeSession.value, same(localSession));
    });

    test('the local player is stopped when HereSphere takes over', () async {
      // Handing the clock over does not silence the local player on its own.
      // Two videos playing at once is two soundtracks and two claims on one
      // device.
      localSession.capabilities.value = {PlaybackCapability.playPause};
      localSession.paused.value = false;

      controller.session.applyEvent(open());

      expect(localSession.paused.value, isTrue);
      expect(localSession.pauseToggles, 1);
    });

    test('a local player that cannot be paused does not block handover', () {
      // The clock has to move regardless, or HereSphere drives nothing.
      localSession.capabilities.value = {};
      localSession.paused.value = false;

      controller.session.applyEvent(open());

      expect(activeSession.value, same(controller.session));
      expect(localSession.pauseToggles, 0);
    });

    test('an already-paused local player is left alone', () {
      localSession.capabilities.value = {PlaybackCapability.playPause};
      localSession.paused.value = true;

      controller.session.applyEvent(open());

      expect(localSession.pauseToggles, 0);
    });

    test('a lost heartbeat keeps ownership but reads as paused', () async {
      // Bouncing ownership back on every dropout would reload the funscript
      // each time. The session stays in charge and stops instead.
      controller.session.applyEvent(open());
      controller.session.setChannelHealthy(true);
      expect(controller.session.connected.value, isTrue);

      controller.session.setChannelHealthy(false);

      expect(activeSession.value, same(controller.session));
      expect(controller.session.connected.value, isFalse);
    });

    test('handing the device to HereSphere gives the clock back', () async {
      controller.session.applyEvent(open());
      expect(activeSession.value, same(controller.session));

      // In this mode Syncopathy is a media server and nothing more.
      settings.hereSphereDeviceOwner.value = HereSphereDeviceOwner.hereSphere;
      await settle();

      expect(activeSession.value, same(localSession));
    });

    test('disabling the feature gives the clock back', () async {
      controller.session.applyEvent(open());
      settings.hereSphereEnabled.value = false;
      await settle();

      expect(activeSession.value, same(localSession));
      expect(controller.session.currentMedia.value, isNull);
    });

    test('disposing gives the clock back', () async {
      controller.session.applyEvent(open());
      expect(activeSession.value, same(controller.session));

      await controller.dispose();

      expect(activeSession.value, same(localSession));
    });

    test('a player that never comes back gives the clock back', () async {
      // A dropout has to be survivable without moving the clock, but a headset
      // that is simply gone — taken off, out of battery — used to keep the
      // clock for good, and with it the local player's ability to play
      // anything at all.
      await useShortAbandonWindow();
      settings.hereSphereEnabled.value = true;
      await settle();

      controller.session.applyEvent(open());
      expect(activeSession.value, same(controller.session));

      await waitUntil(() => identical(activeSession.value, localSession));

      expect(activeSession.value, same(localSession));
      expect(controller.session.currentMedia.value, isNull);
    });

    test('a player that comes back takes the clock again', () async {
      // Giving up has to be recoverable without the user touching anything:
      // the next thing HereSphere says puts it back in charge.
      await useShortAbandonWindow();
      settings.hereSphereEnabled.value = true;
      await settle();

      controller.session.applyEvent(open());
      await waitUntil(() => identical(activeSession.value, localSession));

      controller.session.applyEvent(open());

      expect(activeSession.value, same(controller.session));
      expect(controller.session.currentMedia.value, isNotNull);
    });

    test('handing the device over cancels the countdown', () async {
      // The countdown only exists to free a clock HereSphere is holding. Once
      // it holds nothing, there is nothing to time out — and a timer left
      // running would close media the user is watching without a device.
      await useShortAbandonWindow();
      settings.hereSphereEnabled.value = true;
      await settle();

      controller.session.applyEvent(open());
      settings.hereSphereDeviceOwner.value = HereSphereDeviceOwner.hereSphere;
      await settle();

      expect(activeSession.value, same(localSession));
      expect(controller.session.currentMedia.value, isNotNull);
    });
  });

  group('keeping the server bound', () {
    test('a bind that fails is retried until it works', () async {
      // A port is busy for reasons that pass — the previous socket has not been
      // released, or an interface is still coming up after a sleep. Leaving the
      // feature dead until the user edits a setting made that permanent.
      final blocker = await HttpServer.bind('127.0.0.1', 0);
      settings.hereSpherePort.value = blocker.port;
      settings.hereSphereEnabled.value = true;
      await settle();

      expect(controller.server.state.value, HereSphereServerState.failed);

      await blocker.close(force: true);

      await waitUntil(
        () => controller.server.state.value == HereSphereServerState.running,
        timeout: const Duration(seconds: 15),
      );
      expect(controller.server.isRunning, isTrue);
    });

    test('nothing is retried once the feature is switched off', () async {
      final blocker = await HttpServer.bind('127.0.0.1', 0);
      addTearDown(() => blocker.close(force: true));
      settings.hereSpherePort.value = blocker.port;
      settings.hereSphereEnabled.value = true;
      await settle();
      expect(controller.server.state.value, HereSphereServerState.failed);

      settings.hereSphereEnabled.value = false;
      await settle();

      // Long enough for several retries to have come due.
      await Future<void>.delayed(const Duration(seconds: 5));
      expect(controller.server.isRunning, isFalse);
      expect(controller.server.state.value, HereSphereServerState.stopped);
    });
  });

  group('device ownership mode', () {
    test('the server follows the setting', () async {
      settings.hereSphereEnabled.value = true;
      await settle();
      expect(
        controller.server.deviceOwner.value,
        HereSphereDeviceOwner.syncopathy,
      );

      settings.hereSphereDeviceOwner.value = HereSphereDeviceOwner.hereSphere;
      await settle();
      expect(
        controller.server.deviceOwner.value,
        HereSphereDeviceOwner.hereSphere,
      );
    });

    test(
      'remote control is off unless both the mode and the toggle allow it',
      () async {
        settings.hereSphereEnabled.value = true;
        settings.hereSphereAllowRemoteControl.value = true;
        await settle();
        expect(controller.timestamps.allowCommands.value, isTrue);
        expect(controller.session.capabilities.value, isNotEmpty);

        // Syncopathy does not steer a player that is driving the device itself.
        settings.hereSphereDeviceOwner.value = HereSphereDeviceOwner.hereSphere;
        await settle();
        expect(controller.timestamps.allowCommands.value, isFalse);
        expect(controller.session.capabilities.value, isEmpty);
      },
    );
  });

  group('finding HereSphere', () {
    test('there is nowhere to connect until a player signs in', () async {
      // Better than retrying an address no player is behind: the channel stays
      // down and the panel says why.
      settings.hereSphereEnabled.value = true;
      await settle();
      expect(controller.timestampHost.value, isEmpty);
    });

    test('the address comes from the player that connected', () async {
      settings.hereSphereEnabled.value = true;
      await controller.setPassword('hunter2');
      await settle();

      final url = controller
          .urlFor('127.0.0.1')
          .replaceFirst('127.0.0.1:0', '127.0.0.1:${controller.server.port}');
      final client = HttpClient();
      addTearDown(() => client.close(force: true));
      final request = await client.postUrl(Uri.parse(url));
      request.write(
        jsonEncode({'username': 'syncopathy', 'password': 'hunter2'}),
      );
      await (await request.close()).drain<void>();

      // Asking the user to find and type this was the wrong answer to a
      // question the server can already answer for itself.
      expect(controller.timestampHost.value, '127.0.0.1');
    });

    test('a typed address wins when auto-detection is off', () async {
      settings.hereSphereTimestampAutoDetect.value = false;
      settings.hereSphereTimestampHost.value = '192.168.1.50';
      await settle();
      expect(controller.timestampHost.value, '192.168.1.50');
    });

    test(
      'an unauthenticated request never aims the outbound connection',
      () async {
        // It decides where Syncopathy dials out to, so a stranger must not be
        // able to point it anywhere.
        settings.hereSphereEnabled.value = true;
        await settle();

        final url = controller
            .urlFor('127.0.0.1')
            .replaceFirst('127.0.0.1:0', '127.0.0.1:${controller.server.port}');
        final client = HttpClient();
        addTearDown(() => client.close(force: true));
        await (await (await client.getUrl(
          Uri.parse(url),
        )).close()).drain<void>();

        expect(controller.server.clientAddress.value, isNull);
        expect(controller.timestampHost.value, isEmpty);
      },
    );
  });

  test('a generated password is words, not characters', () {
    // It gets typed on a headset keyboard once, from a string read off a
    // monitor. Three ordinary words survive that; sixteen random characters
    // do not.
    for (var i = 0; i < 50; i++) {
      final password = generateHereSpherePassword();
      expect(password, matches(RegExp(r'^[a-z]+-[a-z]+-[a-z]+$')));
      for (final word in password.split('-')) {
        expect(hereSpherePasswordWords, contains(word));
      }
    }
  });

  test('the word list is usable', () {
    // A duplicate or a stray character would quietly shrink the space and, in
    // the second case, produce a password that cannot be typed.
    expect(
      hereSpherePasswordWords.toSet(),
      hasLength(hereSpherePasswordWords.length),
    );
    for (final word in hereSpherePasswordWords) {
      expect(word, matches(RegExp(r'^[a-z]{3,6}$')));
    }
    // Three words out of this many is tens of millions of combinations, which
    // against a five-guesses-per-minute lockout is already unreachable.
    expect(hereSpherePasswordWords.length, greaterThan(250));
  });

  test('generated passwords differ', () {
    final generated = {
      for (var i = 0; i < 200; i++) generateHereSpherePassword(),
    };
    // Not all-distinct: the words are drawn independently, so a repeat is
    // possible and asserting otherwise would be a rare flake for no gain.
    expect(generated.length, greaterThan(190));
  });
}
