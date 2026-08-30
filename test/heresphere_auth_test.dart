import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:syncopathy/heresphere/heresphere_auth.dart';

void main() {
  group('password hashing', () {
    test('a password verifies against its own hash', () async {
      final hash = await hashHereSpherePassword('correct horse');
      expect(await verifyHereSpherePassword('correct horse', hash), isTrue);
      expect(await verifyHereSpherePassword('correct horsé', hash), isFalse);
      expect(await verifyHereSpherePassword('', hash), isFalse);
    });

    test('the same password hashes differently every time', () async {
      // Distinct salts, so two accounts with the same password do not share a
      // hash and a precomputed table is no use.
      final first = await hashHereSpherePassword('same');
      final second = await hashHereSpherePassword('same');
      expect(first.key, isNot(second.key));
      expect(first.salt, isNot(second.salt));
      expect(await verifyHereSpherePassword('same', second), isTrue);
    });

    test('the encoded form carries no trace of the password', () async {
      final encoded = (await hashHereSpherePassword('hunter2')).encode();
      expect(encoded, isNot(contains('hunter2')));
      expect(encoded, startsWith('pbkdf2-sha256\$'));
    });

    test('encoding round-trips', () async {
      final hash = await hashHereSpherePassword('round trip');
      final decoded = HereSpherePasswordHash.decode(hash.encode());

      expect(decoded, isNotNull);
      expect(decoded!.iterations, hash.iterations);
      expect(decoded.salt, hash.salt);
      expect(decoded.key, hash.key);
      expect(await verifyHereSpherePassword('round trip', decoded), isTrue);
    });

    test('unusable stored values decode to nothing', () async {
      // Which the caller treats as "no password set", locking the server
      // rather than opening it.
      for (final broken in [
        null,
        '',
        'garbage',
        'pbkdf2-sha256\$notanumber\$AAAA\$AAAA',
        'bcrypt\$10\$AAAA\$AAAA',
        'pbkdf2-sha256\$1000\$not base64!\$AAAA',
        'pbkdf2-sha256\$1000\$AAAA',
      ]) {
        expect(
          HereSpherePasswordHash.decode(broken),
          isNull,
          reason: 'decoded $broken',
        );
      }
    });

    test('a unicode password survives the round trip', () async {
      final hash = await hashHereSpherePassword('pässwörd 🔒');
      expect(await verifyHereSpherePassword('pässwörd 🔒', hash), isTrue);
      expect(await verifyHereSpherePassword('passwörd 🔒', hash), isFalse);
    });
  });

  group('pbkdf2', () {
    test('matches the RFC 6070 style vector for HMAC-SHA256', () {
      // Derived from the well-known PBKDF2-HMAC-SHA256 test vector:
      // P = "password", S = "salt", c = 1, dkLen = 32.
      final result = pbkdf2(
        password: Uint8List.fromList(utf8.encode('password')),
        salt: Uint8List.fromList(utf8.encode('salt')),
        iterations: 1,
        keyLength: 32,
      );
      expect(
        result.map((b) => b.toRadixString(16).padLeft(2, '0')).join(),
        '120fb6cffcf8b32c43e7225256c4f837a86548c92ccc35480805987cb70be17b',
      );
    });

    test('two iterations match their vector too', () {
      final result = pbkdf2(
        password: Uint8List.fromList(utf8.encode('password')),
        salt: Uint8List.fromList(utf8.encode('salt')),
        iterations: 2,
        keyLength: 32,
      );
      expect(
        result.map((b) => b.toRadixString(16).padLeft(2, '0')).join(),
        'ae4d0c95af6b46d32d0adff928f06dd02a303f8ef3c251dfd6e2d85a95474c43',
      );
    });

    test('a key longer than one block spans blocks correctly', () {
      final result = pbkdf2(
        password: Uint8List.fromList(utf8.encode('passwordPASSWORDpassword')),
        salt: Uint8List.fromList(
          utf8.encode('saltSALTsaltSALTsaltSALTsaltSALTsalt'),
        ),
        iterations: 4096,
        keyLength: 40,
      );
      expect(
        result.map((b) => b.toRadixString(16).padLeft(2, '0')).join(),
        '348c89dbcbd32b2f32d814b8116e84cf2b17347ebc1800181c4e2a1fb8dd53e1'
        'c635518c7dac47e9',
      );
    });
  });

  group('constant-time comparison', () {
    test('agrees with ordinary equality', () {
      expect(constantTimeEquals([1, 2, 3], [1, 2, 3]), isTrue);
      expect(constantTimeEquals([1, 2, 3], [1, 2, 4]), isFalse);
      expect(constantTimeEquals([1, 2, 3], [1, 2]), isFalse);
      expect(constantTimeEquals([], []), isTrue);

      expect(constantTimeEqualsString('abc', 'abc'), isTrue);
      expect(constantTimeEqualsString('abc', 'abd'), isFalse);
      expect(constantTimeEqualsString('abc', 'ab'), isFalse);
    });
  });

  group('HereSphereCredentials', () {
    test('reads what HereSphere posts', () {
      final credentials = HereSphereCredentials.fromBody(
        jsonEncode({'username': 'user', 'password': 'secret'}),
      );
      expect(credentials!.username, 'user');
      expect(credentials.password, 'secret');
      expect(credentials.isBlank, isFalse);
    });

    test('the blank pair the player sends first is recognised as blank', () {
      // It must not count as a wrong guess, or a player that prompts twice
      // would spend the user's lockout budget before they typed anything.
      final credentials = HereSphereCredentials.fromBody(
        jsonEncode({'username': '', 'password': ''}),
      );
      expect(credentials!.isBlank, isTrue);
    });

    test('a body with no credentials is not a login attempt', () {
      expect(HereSphereCredentials.fromBody(null), isNull);
      expect(HereSphereCredentials.fromBody(''), isNull);
      expect(HereSphereCredentials.fromBody('not json'), isNull);
      expect(HereSphereCredentials.fromBody('[]'), isNull);
      expect(
        HereSphereCredentials.fromBody('{"needsMediaSource":true}'),
        isNull,
      );
    });

    test('a half-filled body still counts, with the missing half empty', () {
      final credentials = HereSphereCredentials.fromBody(
        jsonEncode({'password': 'secret'}),
      );
      expect(credentials!.username, '');
      expect(credentials.password, 'secret');
    });
  });

  group('HereSphereAuth', () {
    late HereSphereAuth auth;

    setUp(() async {
      auth = HereSphereAuth(
        username: 'user',
        password: await hashHereSpherePassword('secret'),
      );
    });

    test('accepts exactly the right pair', () async {
      expect(
        await auth.matches(
          const HereSphereCredentials(username: 'user', password: 'secret'),
        ),
        isTrue,
      );
    });

    test('refuses a wrong half', () async {
      expect(
        await auth.matches(
          const HereSphereCredentials(username: 'user', password: 'wrong'),
        ),
        isFalse,
      );
      expect(
        await auth.matches(
          const HereSphereCredentials(username: 'other', password: 'secret'),
        ),
        isFalse,
      );
    });

    test('no stored password means no login at all', () {
      // The safe reading of "not configured yet" is closed, not open.
      expect(
        HereSphereAuth.fromSettings(username: 'user', encodedPassword: ''),
        isNull,
      );
      expect(
        HereSphereAuth.fromSettings(username: 'user', encodedPassword: null),
        isNull,
      );
    });

    test('differsFrom spots a changed username or password', () async {
      final same = HereSphereAuth(
        username: auth.username,
        password: auth.password,
      );
      expect(auth.differsFrom(same), isFalse);
      expect(auth.differsFrom(null), isTrue);
      expect(
        auth.differsFrom(
          HereSphereAuth(username: 'other', password: auth.password),
        ),
        isTrue,
      );
      expect(
        auth.differsFrom(
          HereSphereAuth(
            username: auth.username,
            password: await hashHereSpherePassword('different'),
          ),
        ),
        isTrue,
      );
    });
  });

  group('LoginThrottle', () {
    final start = DateTime(2026, 1, 1, 12);

    test('lets a few mistakes through', () {
      final throttle = LoginThrottle(maxFailures: 3);
      throttle.recordFailure('10.0.0.5', start);
      throttle.recordFailure('10.0.0.5', start);
      expect(throttle.isLockedOut('10.0.0.5', start), isFalse);
    });

    test('locks out after the limit', () {
      final throttle = LoginThrottle(maxFailures: 3);
      for (var i = 0; i < 3; i++) {
        throttle.recordFailure('10.0.0.5', start);
      }
      expect(throttle.isLockedOut('10.0.0.5', start), isTrue);
    });

    test('one address does not lock out another', () {
      final throttle = LoginThrottle(maxFailures: 1);
      throttle.recordFailure('10.0.0.5', start);
      expect(throttle.isLockedOut('10.0.0.5', start), isTrue);
      expect(throttle.isLockedOut('10.0.0.9', start), isFalse);
    });

    test('the lockout expires', () {
      final throttle = LoginThrottle(
        maxFailures: 1,
        lockout: const Duration(minutes: 1),
      );
      throttle.recordFailure('10.0.0.5', start);
      expect(
        throttle.isLockedOut(
          '10.0.0.5',
          start.add(const Duration(seconds: 30)),
        ),
        isTrue,
      );
      expect(
        throttle.isLockedOut('10.0.0.5', start.add(const Duration(minutes: 2))),
        isFalse,
      );
    });

    test('a success wipes the slate', () {
      final throttle = LoginThrottle(maxFailures: 3);
      throttle.recordFailure('10.0.0.5', start);
      throttle.recordFailure('10.0.0.5', start);
      throttle.recordSuccess('10.0.0.5');
      expect(throttle.failureCount('10.0.0.5'), 0);
    });

    test('failures spaced beyond the window do not accumulate', () {
      // Otherwise a typo a day would eventually lock someone out.
      final throttle = LoginThrottle(
        maxFailures: 2,
        lockout: const Duration(minutes: 1),
      );
      throttle.recordFailure('10.0.0.5', start);
      throttle.recordFailure('10.0.0.5', start.add(const Duration(hours: 1)));
      expect(
        throttle.isLockedOut('10.0.0.5', start.add(const Duration(hours: 1))),
        isFalse,
      );
    });
  });

  group('SessionTokenStore', () {
    final start = DateTime(2026, 1, 1, 12);

    test('issues a token that validates', () {
      final store = SessionTokenStore();
      final token = store.issue(start);
      expect(token, hasLength(22));
      expect(store.validate(token, start), isTrue);
    });

    test('an invented token does not validate', () {
      final store = SessionTokenStore();
      store.issue(start);
      expect(store.validate('not-a-real-token', start), isFalse);
      expect(store.validate('', start), isFalse);
    });

    test('tokens are unique', () {
      final store = SessionTokenStore(maxSessions: 500);
      final tokens = {for (var i = 0; i < 200; i++) store.issue(start)};
      expect(tokens.length, 200);
    });

    test('an idle token expires', () {
      final store = SessionTokenStore(idleTimeout: const Duration(hours: 1));
      final token = store.issue(start);
      expect(
        store.validate(token, start.add(const Duration(minutes: 59))),
        isTrue,
      );
      expect(
        store.validate(token, start.add(const Duration(hours: 3))),
        isFalse,
      );
    });

    test('use refreshes the idle timer', () {
      // A long film is one session; it must not expire mid-playback.
      final store = SessionTokenStore(idleTimeout: const Duration(hours: 1));
      final token = store.issue(start);
      var now = start;
      for (var i = 0; i < 5; i++) {
        now = now.add(const Duration(minutes: 50));
        expect(store.validate(token, now), isTrue);
      }
    });

    test('revoking signs everyone out', () {
      final store = SessionTokenStore();
      final first = store.issue(start);
      final second = store.issue(start);

      store.revokeAll();

      expect(store.validate(first, start), isFalse);
      expect(store.validate(second, start), isFalse);
      expect(store.activeCount, 0);
    });

    test('the store is bounded, dropping the least recently used', () {
      final store = SessionTokenStore(maxSessions: 2);
      final oldest = store.issue(start);
      final middle = store.issue(start.add(const Duration(minutes: 1)));
      final newest = store.issue(start.add(const Duration(minutes: 2)));

      expect(store.activeCount, 2);
      expect(
        store.validate(oldest, start.add(const Duration(minutes: 2))),
        isFalse,
      );
      expect(
        store.validate(middle, start.add(const Duration(minutes: 2))),
        isTrue,
      );
      expect(
        store.validate(newest, start.add(const Duration(minutes: 2))),
        isTrue,
      );
    });
  });
}
