import 'dart:convert';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

/// PBKDF2 iterations. High enough that guessing a stolen hash offline is
/// expensive, low enough that one login is not a noticeable pause. Stored
/// alongside each hash so this can be raised later without invalidating
/// passwords already set.
const int _pbkdf2Iterations = 120000;

const int _saltBytes = 16;
const int _keyBytes = 32;

/// A stored password, as salt and derived key rather than the password itself.
///
/// The settings file this ends up in is plain JSON in the application data
/// directory, and it travels in bug reports. A password recovered from there
/// would be worth more than the media it guards, because people reuse them.
class HereSpherePasswordHash {
  final Uint8List salt;
  final Uint8List key;
  final int iterations;

  const HereSpherePasswordHash({
    required this.salt,
    required this.key,
    required this.iterations,
  });

  /// Serialised as `pbkdf2-sha256$<iterations>$<salt>$<key>`, base64 for the
  /// two byte fields. Self-describing so a future change of algorithm or cost
  /// can be told apart from what is already stored.
  String encode() =>
      'pbkdf2-sha256\$$iterations\$${base64.encode(salt)}\$${base64.encode(key)}';

  static HereSpherePasswordHash? decode(String? encoded) {
    if (encoded == null || encoded.isEmpty) return null;
    final parts = encoded.split(r'$');
    if (parts.length != 4 || parts[0] != 'pbkdf2-sha256') return null;
    final iterations = int.tryParse(parts[1]);
    if (iterations == null || iterations <= 0) return null;
    try {
      return HereSpherePasswordHash(
        iterations: iterations,
        salt: base64.decode(parts[2]),
        key: base64.decode(parts[3]),
      );
    } catch (_) {
      // Corrupted or hand-edited. Treated as "no password set", which locks the
      // server rather than opening it.
      return null;
    }
  }
}

/// Derives a hash for [password] with a fresh random salt.
///
/// Runs off the main isolate: the derivation is deliberately slow, and the same
/// event loop is streaming video.
Future<HereSpherePasswordHash> hashHereSpherePassword(String password) async {
  final random = Random.secure();
  final salt = Uint8List.fromList([
    for (var i = 0; i < _saltBytes; i++) random.nextInt(256),
  ]);
  final bytes = Uint8List.fromList(utf8.encode(password));
  final key = await Isolate.run(
    () => pbkdf2(
      password: bytes,
      salt: salt,
      iterations: _pbkdf2Iterations,
      keyLength: _keyBytes,
    ),
  );
  return HereSpherePasswordHash(
    salt: salt,
    key: key,
    iterations: _pbkdf2Iterations,
  );
}

/// Whether [password] matches [hash].
///
/// Also off the main isolate, and for the same reason: a login must not stall
/// an in-flight range request for the length of the derivation.
Future<bool> verifyHereSpherePassword(
  String password,
  HereSpherePasswordHash hash,
) async {
  final bytes = Uint8List.fromList(utf8.encode(password));
  final salt = hash.salt;
  final iterations = hash.iterations;
  final derived = await Isolate.run(
    () => pbkdf2(
      password: bytes,
      salt: salt,
      iterations: iterations,
      keyLength: hash.key.length,
    ),
  );
  return constantTimeEquals(derived, hash.key);
}

/// PBKDF2-HMAC-SHA256.
Uint8List pbkdf2({
  required Uint8List password,
  required Uint8List salt,
  required int iterations,
  required int keyLength,
}) {
  final hmac = Hmac(sha256, password);
  final blocks = (keyLength / 32).ceil();
  final output = Uint8List(blocks * 32);

  for (var block = 1; block <= blocks; block++) {
    // U1 = HMAC(password, salt || INT_32_BE(block))
    final input = Uint8List(salt.length + 4)
      ..setRange(0, salt.length, salt)
      ..buffer.asByteData().setUint32(salt.length, block, Endian.big);

    var u = Uint8List.fromList(hmac.convert(input).bytes);
    final accumulated = Uint8List.fromList(u);
    for (var i = 1; i < iterations; i++) {
      u = Uint8List.fromList(hmac.convert(u).bytes);
      for (var j = 0; j < accumulated.length; j++) {
        accumulated[j] ^= u[j];
      }
    }
    output.setRange((block - 1) * 32, block * 32, accumulated);
  }

  return Uint8List.sublistView(output, 0, keyLength);
}

/// Compares two byte strings without leaking where they first differ.
bool constantTimeEquals(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  var difference = 0;
  for (var i = 0; i < a.length; i++) {
    difference |= a[i] ^ b[i];
  }
  return difference == 0;
}

/// Compares two strings without leaking a matching prefix.
bool constantTimeEqualsString(String a, String b) {
  if (a.length != b.length) return false;
  var difference = 0;
  for (var i = 0; i < a.length; i++) {
    difference |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
  }
  return difference == 0;
}

/// The credentials HereSphere posts with a library or video request.
class HereSphereCredentials {
  final String username;
  final String password;

  const HereSphereCredentials({required this.username, required this.password});

  /// Reads credentials out of a request body, or returns null when it carries
  /// none — which is the very first request, before the player has anything to
  /// send.
  static HereSphereCredentials? fromBody(String? body) {
    if (body == null || body.isEmpty) return null;
    try {
      final json = jsonDecode(body);
      if (json is! Map) return null;
      final username = json['username'];
      final password = json['password'];
      if (username is! String && password is! String) return null;
      return HereSphereCredentials(
        username: username is String ? username : '',
        password: password is String ? password : '',
      );
    } catch (_) {
      return null;
    }
  }

  /// Whether the player sent a blank login, which it does before prompting the
  /// user. Treated as "no credentials" rather than as a wrong password, so it
  /// does not count against the failure limit.
  bool get isBlank => username.isEmpty && password.isEmpty;
}

/// The login a server accepts.
///
/// Holds the username in the clear and the password only as a derived hash, so
/// the pair can be compared but not read back. Constructed from settings; a
/// null one means no password has been set, which locks the server.
class HereSphereAuth {
  final String username;
  final HereSpherePasswordHash password;

  const HereSphereAuth({required this.username, required this.password});

  /// Builds one from stored settings, or null when no usable password is set.
  static HereSphereAuth? fromSettings({
    required String username,
    required String? encodedPassword,
  }) {
    final hash = HereSpherePasswordHash.decode(encodedPassword);
    if (hash == null) return null;
    return HereSphereAuth(username: username, password: hash);
  }

  /// Whether [credentials] are the ones this accepts.
  ///
  /// The username is compared in constant time as well. It is not a secret, but
  /// comparing it with `==` would answer "is the first character right?" faster
  /// than "is the whole thing right?", and there is no reason to offer that.
  Future<bool> matches(HereSphereCredentials credentials) async {
    final userMatches = constantTimeEqualsString(
      credentials.username,
      username,
    );
    // Verify the password either way, so a wrong username does not return
    // faster than a wrong password and give away which half was wrong.
    final passwordMatches = await verifyHereSpherePassword(
      credentials.password,
      password,
    );
    return userMatches && passwordMatches;
  }

  /// Whether [other] is a different login, and so should invalidate sessions
  /// issued against this one.
  bool differsFrom(HereSphereAuth? other) {
    if (other == null) return true;
    return other.username != username ||
        !constantTimeEquals(other.password.key, password.key);
  }
}

/// Why a login was refused, or that it was not.
enum HereSphereAuthResult {
  /// The client may proceed.
  granted,

  /// No usable credentials were sent; the player should prompt.
  loginRequired,

  /// Credentials were sent and were wrong.
  loginFailed,
}

/// Slows down guessing, per client address.
///
/// A local network is not a safe place to leave an unlimited password oracle:
/// anything on it — another person's laptop, a compromised appliance — can try
/// as fast as the server will answer. After [maxFailures] wrong answers the
/// address is refused outright for [lockout], regardless of what it sends.
class LoginThrottle {
  final int maxFailures;
  final Duration lockout;

  final Map<String, _FailureRecord> _failures = {};

  LoginThrottle({
    this.maxFailures = 5,
    this.lockout = const Duration(minutes: 1),
  });

  /// Whether [client] is currently locked out.
  bool isLockedOut(String client, DateTime now) {
    final record = _failures[client];
    if (record == null) return false;
    if (record.count < maxFailures) return false;
    if (now.difference(record.lastFailure) > lockout) {
      // Served its time.
      _failures.remove(client);
      return false;
    }
    return true;
  }

  void recordFailure(String client, DateTime now) {
    final record = _failures[client];
    if (record == null || now.difference(record.lastFailure) > lockout) {
      _failures[client] = _FailureRecord(count: 1, lastFailure: now);
      return;
    }
    _failures[client] = _FailureRecord(
      count: record.count + 1,
      lastFailure: now,
    );
  }

  void recordSuccess(String client) => _failures.remove(client);

  void clear() => _failures.clear();

  /// How many failures [client] has to its name, for diagnostics.
  int failureCount(String client) => _failures[client]?.count ?? 0;
}

class _FailureRecord {
  final int count;
  final DateTime lastFailure;

  const _FailureRecord({required this.count, required this.lastFailure});
}

/// Characters a session token is drawn from. Unlike a password nobody types
/// one of these, so the full alphabet is fine.
const String _sessionAlphabet =
    'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

/// Length of a session token: 62 symbols over 22 characters, comfortably past
/// 128 bits.
const int _sessionTokenLength = 22;

/// Issues and validates the tokens that authorise the byte-serving routes.
///
/// Media, thumbnail, script and event requests come from the video player as
/// plain GETs, with no way to carry credentials. A token in the URL is what
/// stands in for them, and it is minted only after a successful login — so it
/// is a consequence of authenticating rather than a replacement for it.
///
/// Held in memory only. Restarting Syncopathy invalidates every session, which
/// costs nothing: HereSphere keeps the credentials and logs in again.
class SessionTokenStore {
  /// How long a token survives without being used.
  final Duration idleTimeout;

  /// Cap on live sessions, so a client that logs in repeatedly cannot grow the
  /// map without bound.
  final int maxSessions;

  final Map<String, DateTime> _sessions = {};
  final Random _random = Random.secure();

  SessionTokenStore({
    this.idleTimeout = const Duration(hours: 24),
    this.maxSessions = 8,
  });

  int get activeCount => _sessions.length;

  /// Mints a token and returns it.
  String issue(DateTime now) {
    _expire(now);
    if (_sessions.length >= maxSessions) {
      // Drop the least recently used rather than refusing: the newest login is
      // the one the user is actually waiting on.
      final oldest = _sessions.entries.reduce(
        (a, b) => a.value.isBefore(b.value) ? a : b,
      );
      _sessions.remove(oldest.key);
    }
    final token = String.fromCharCodes([
      for (var i = 0; i < _sessionTokenLength; i++)
        _sessionAlphabet.codeUnitAt(_random.nextInt(_sessionAlphabet.length)),
    ]);
    _sessions[token] = now;
    return token;
  }

  /// Whether [token] is live, refreshing its idle timer when it is.
  bool validate(String token, DateTime now) {
    _expire(now);
    // Looked up by exact key rather than scanned, so there is no comparison to
    // time: a wrong token simply is not in the map.
    final lastUsed = _sessions[token];
    if (lastUsed == null) return false;
    _sessions[token] = now;
    return true;
  }

  /// Invalidates every session, which signs out every device.
  void revokeAll() => _sessions.clear();

  void _expire(DateTime now) => _sessions.removeWhere(
    (_, lastUsed) => now.difference(lastUsed) > idleTimeout,
  );
}
