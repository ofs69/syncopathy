import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:signals/signals.dart';
import 'package:syncopathy/heresphere/byte_range.dart';
import 'package:syncopathy/heresphere/heresphere_api.dart';
import 'package:syncopathy/heresphere/heresphere_auth.dart';
import 'package:syncopathy/heresphere/heresphere_event.dart';
import 'package:syncopathy/heresphere/heresphere_library.dart';
import 'package:syncopathy/heresphere/heresphere_mode.dart';
import 'package:syncopathy/logging.dart';

/// Path segment every route sits under, ahead of the token.
const String hereSpherePathPrefix = 'hs';

/// Largest request body accepted. Only the event endpoint reads one, and its
/// payloads are a few hundred bytes; the cap keeps a hostile client from
/// making us buffer something large.
const int _maxRequestBodyBytes = 64 * 1024;

/// How long the driving client keeps its claim after its last event.
///
/// HereSphere goes quiet between transitions — a paused video reports nothing —
/// so the window has to outlast a pause. It only matters when a second player
/// starts posting events, which in normal use never happens.
const Duration _clientClaimTimeout = Duration(minutes: 10);

enum HereSphereServerState { stopped, starting, running, failed }

/// Tracks which client drives the clock.
///
/// One driver at a time, by design: two players reporting playback would leave
/// Syncopathy unable to say which of them the device should follow. The holder
/// keeps its claim for [timeout] past its last event, which has to outlast the
/// quiet stretch between a pause and the next transition.
///
/// Scoped to the events that carry playback, and to nothing else. Reading the
/// library confuses no clock, so a phone browsing while a headset plays is not
/// a rival — it was only ever treated as one because this check sat in front of
/// every route rather than in front of the one that matters. Gating reads also
/// meant a headset that woke on a new DHCP lease was locked out by its own
/// stale claim, since the key is the address it happened to arrive from.
class ClientClaim {
  final Duration timeout;

  String? _holder;
  DateTime _lastSeen = DateTime.fromMillisecondsSinceEpoch(0);

  ClientClaim({this.timeout = _clientClaimTimeout});

  String? get holder => _holder;

  /// Whether [key] may proceed, renewing the claim when it may.
  ///
  /// The current holder always may. Anyone else may only once the holder has
  /// been quiet for longer than [timeout].
  bool claim(String key, DateTime now) {
    final holder = _holder;
    if (holder != null &&
        holder != key &&
        now.difference(_lastSeen) <= timeout) {
      return false;
    }
    _holder = key;
    _lastSeen = now;
    return true;
  }

  void release() {
    _holder = null;
    _lastSeen = DateTime.fromMillisecondsSinceEpoch(0);
  }
}

/// Serves the HereSphere JSON API and media byte ranges for one client.
///
/// Native only: it binds a socket and reads files, neither of which the web
/// build has. Off unless explicitly started, and it resolves nothing but
/// identifiers this application issued — a path from the client is never
/// honoured, so the exposure is exactly the indexed library and nothing else
/// on disk.
class HereSphereServer {
  final HereSphereLibrary _library;

  HttpServer? _server;

  /// Issues and checks the tokens that stand in for credentials on the routes
  /// a video player fetches with a plain GET.
  final SessionTokenStore sessions;

  /// Refuses an address that has guessed wrong too often.
  final LoginThrottle throttle;

  /// The login the client must present. Null while no password is set, which
  /// closes the server rather than opening it.
  HereSphereAuth? _auth;

  final Signal<HereSphereServerState> _state = signal(
    HereSphereServerState.stopped,
  );
  ReadonlySignal<HereSphereServerState> get state => _state;

  final Signal<String?> _lastError = signal(null);

  /// Why the last start attempt failed — a port already in use, an address that
  /// is not ours — or null when nothing has gone wrong.
  ReadonlySignal<String?> get lastError => _lastError;

  final Signal<String?> _connectedClient = signal(null);

  /// Address of the client last heard from, for the status panel.
  ///
  /// Any authenticated request counts, not only one from whoever is driving:
  /// the panel is answering "has anything reached me", and a headset browsing
  /// the library has plainly reached us.
  ReadonlySignal<String?> get connectedClient => _connectedClient;

  final Signal<String?> _clientAddress = signal(null);

  /// Where to reach the player, in a form that can be dialled.
  ///
  /// The timestamp channel runs the other way round from everything else here:
  /// HereSphere listens and Syncopathy connects out to it. The address to
  /// connect to is not something a user should have to find and type — it is
  /// already known, because that same player is making these requests. This is
  /// that address.
  ///
  /// Set only from an authenticated request. It decides where Syncopathy opens
  /// an outbound connection, so an unauthenticated stranger must not be able to
  /// aim it — and, once a player is driving, only that player may move it.
  ReadonlySignal<String?> get clientAddress => _clientAddress;

  final StreamController<HereSphereEvent> _events =
      StreamController<HereSphereEvent>.broadcast();

  /// Playback events posted by the player.
  ///
  /// Nothing consumes these yet; the session that turns them into a clock
  /// arrives with phase 3. Publishing them now keeps the endpoint honest and
  /// gives the protocol spike something to observe.
  Stream<HereSphereEvent> get events => _events.stream;

  final ClientClaim _claim;

  final Signal<int> _activeSessions = signal(0);

  /// How many devices are signed in, for the status panel.
  ReadonlySignal<int> get activeSessions => _activeSessions;

  /// Who drives the device, which decides whether script URLs are published.
  ///
  /// Held as a signal rather than passed at start: the user can change their
  /// mind while a headset is connected, and the next metadata request should
  /// reflect it without a restart.
  final Signal<HereSphereDeviceOwner> deviceOwner = signal(
    HereSphereDeviceOwner.syncopathy,
  );

  HereSphereServer(
    this._library, {
    SessionTokenStore? sessions,
    LoginThrottle? throttle,
    ClientClaim? claim,
  }) : sessions = sessions ?? SessionTokenStore(),
       throttle = throttle ?? LoginThrottle(),
       // Injectable so a test can stand a rival player up. Two clients cannot
       // be told apart over loopback — they share one address key — so this is
       // the only way to exercise the rule at all.
       _claim = claim ?? ClientClaim();

  bool get isRunning => _server != null;

  /// The port actually bound, or null while stopped. Asking for port 0 gets one
  /// assigned, which is how tests bind without picking a fixed number.
  int? get port => _server?.port;

  /// Binds [address]:[port], requiring [auth] of every client.
  ///
  /// Restarts if already running, so a settings change is a single call.
  /// Failure is reported through [state] and [lastError] rather than thrown: a
  /// busy port is a routine misconfiguration, not an application error.
  ///
  /// A null [auth] is a server nobody can log in to. That is deliberate: the
  /// alternative to "no password set" is an open server, and this feature
  /// publishes a media library over a network.
  Future<void> start({
    required String address,
    required int port,
    required HereSphereAuth? auth,
  }) async {
    await stop();

    _state.value = HereSphereServerState.starting;
    _lastError.value = null;
    setAuth(auth);

    try {
      final bindAddress = await _resolveBindAddress(address);
      final server = await HttpServer.bind(bindAddress, port, v6Only: false);
      // Video bytes are already compressed and the JSON is tiny, so gzip would
      // only cost CPU.
      server.autoCompress = false;
      _server = server;
      _state.value = HereSphereServerState.running;
      Logger.info(
        'HereSphere server listening on '
        '${server.address.address}:${server.port}',
      );
      unawaited(_serve(server));
    } catch (e, st) {
      Logger.error('HereSphere server failed to start', e, st);
      _fail(_describeBindFailure(e, address, port));
    }
  }

  /// Replaces the accepted login without restarting.
  ///
  /// Changing the password signs every device out: a session token was issued
  /// against the old credentials, and letting it outlive them would make
  /// changing the password mean nothing until a restart.
  void setAuth(HereSphereAuth? auth) {
    final changed = _auth?.differsFrom(auth) ?? (auth != null);
    _auth = auth;
    if (changed) revokeSessions();
  }

  /// Signs every device out. They log in again with the current credentials.
  void revokeSessions() {
    sessions.revokeAll();
    throttle.clear();
    _activeSessions.value = 0;
  }

  Future<void> stop() async {
    final server = _server;
    _server = null;
    _auth = null;
    revokeSessions();
    _releaseClaim();
    if (server != null) {
      // force: a client parked on a stalled range request would otherwise hold
      // the port until it times out, and the next start would fail on it.
      try {
        await server.close(force: true);
      } catch (e) {
        Logger.warning('HereSphere server close failed: $e');
      }
      Logger.info('HereSphere server stopped');
    }
    _state.value = HereSphereServerState.stopped;
    _lastError.value = null;
  }

  Future<void> dispose() async {
    await stop();
    await _events.close();
  }

  void _fail(String message) {
    _lastError.value = message;
    _state.value = HereSphereServerState.failed;
  }

  Future<void> _serve(HttpServer server) async {
    try {
      await for (final request in server) {
        // Deliberately not awaited: a media response can run for minutes, and
        // the library scan HereSphere issues alongside it must not queue behind
        // it.
        unawaited(_dispatch(request));
      }
    } catch (e, st) {
      // Closing the server ends the loop through here too; only report it if
      // the server was still meant to be running.
      if (identical(_server, server)) {
        Logger.error('HereSphere server loop ended', e, st);
        _server = null;
        _fail('Server stopped unexpectedly: $e');
      }
    }
  }

  Future<void> _dispatch(HttpRequest request) async {
    final response = request.response;
    // A client that walks away mid-response errors this future too; without a
    // handler it surfaces as an unhandled async error.
    unawaited(response.done.catchError((Object _) => response));

    try {
      final segments = request.uri.pathSegments
          .where((segment) => segment.isNotEmpty)
          .toList();

      // The one route that answers without a token, because it is where a
      // client that has none goes to log in. It reveals nothing until it does:
      // an unauthenticated request gets `access: 0` and an empty library.
      if (segments.isEmpty ||
          (segments.length == 1 && segments[0] == 'heresphere')) {
        await _handleIndex(request);
        return;
      }

      // Bulk metadata, which HereSphere asks for by appending `/scan` to the
      // library URL it was given. It therefore arrives without a session token
      // and has to log in the same way the index does. Both spellings are
      // accepted because either could be the URL that was typed.
      if ((segments.length == 1 && segments[0] == 'scan') ||
          (segments.length == 2 &&
              segments[0] == 'heresphere' &&
              segments[1] == 'scan')) {
        await _handleScan(request);
        return;
      }

      // Everything else lives under /hs/<session token>/. An expired or
      // invented token is a 404 rather than a 403, so probing cannot even
      // confirm the prefix exists.
      if (segments.length < 2 ||
          segments[0] != hereSpherePathPrefix ||
          !sessions.validate(segments[1], DateTime.now())) {
        await _drain(request);
        await _unauthorised(request);
        return;
      }

      // The token has just been checked, so this request is as authenticated
      // as a login is. Kept current from here rather than only from the login,
      // because a headset that changes address mid-session should be followed.
      _noteClientAddress(request);
      await _route(request, segments[1], segments.sublist(2));
    } catch (e, st) {
      Logger.error('HereSphere request failed: ${request.uri.path}', e, st);
      try {
        await _writeStatus(response, HttpStatus.internalServerError);
      } catch (_) {
        // Headers already went out, or the socket is gone. Nothing to say.
      }
    }
  }

  /// The library index, which doubles as the login endpoint.
  ///
  /// HereSphere posts `username` and `password` here. On the first request it
  /// has none to send, gets `access: 0`, prompts the user, and tries again —
  /// which is the whole handshake. A successful login mints the session token
  /// every URL in the response is then built from.
  Future<void> _handleIndex(HttpRequest request) async {
    if (!_allow(request, const {'GET', 'POST', 'HEAD'})) return;
    final body = await _readBody(request);
    final credentials = HereSphereCredentials.fromBody(body);

    final result = await _authenticate(request, credentials);
    if (result != HereSphereAuthResult.granted) {
      // Deliberately identical in shape to a granted response apart from
      // `access`, because that is what HereSphere reads to decide whether to
      // prompt.
      await _writeJson(request, {
        'access': result == HereSphereAuthResult.loginFailed
            ? hereSphereAccessDenied
            : hereSphereAccessLoginRequired,
        'library': const [],
      });
      return;
    }

    final token = sessions.issue(DateTime.now());
    _activeSessions.value = sessions.activeCount;
    await _writeJson(
      request,
      HereSphereApi(_baseUrlFor(request, token)).index(_library.sections()),
    );
  }

  /// The whole library's metadata in one response.
  ///
  /// Authenticated exactly like the index, because it is reached the same way —
  /// a URL a person typed, with credentials in the body and no session token to
  /// go on. An unauthenticated request gets `access: 0` and no data, which
  /// sends the player back to log in; if it does not, the library still works
  /// entry by entry, only more slowly.
  Future<void> _handleScan(HttpRequest request) async {
    if (!_allow(request, const {'GET', 'POST', 'HEAD'})) return;
    final body = await _readBody(request);
    final credentials = HereSphereCredentials.fromBody(body);

    final result = await _authenticate(request, credentials);
    if (result != HereSphereAuthResult.granted) {
      await _writeJson(request, {
        'access': result == HereSphereAuthResult.loginFailed
            ? hereSphereAccessDenied
            : hereSphereAccessLoginRequired,
        'scanData': const [],
      });
      return;
    }

    final token = sessions.issue(DateTime.now());
    _activeSessions.value = sessions.activeCount;
    final entries = _library.allEntries();
    Logger.info('HereSphere: published ${entries.length} entries to /scan');
    await _writeJson(
      request,
      HereSphereApi(_baseUrlFor(request, token)).scan(entries),
    );
  }

  /// Checks a login, applying the lockout.
  Future<HereSphereAuthResult> _authenticate(
    HttpRequest request,
    HereSphereCredentials? credentials,
  ) async {
    final auth = _auth;
    if (auth == null) {
      // No password configured. Nobody gets in — an open server is not the
      // safe reading of "not set up yet".
      Logger.warning(
        'HereSphere: a client tried to log in with no password set',
      );
      return HereSphereAuthResult.loginRequired;
    }

    final client = _clientKey(request);
    final now = DateTime.now();
    if (throttle.isLockedOut(client, now)) {
      Logger.warning(
        'HereSphere: $client is locked out after repeated failures',
      );
      return HereSphereAuthResult.loginFailed;
    }

    // No credentials at all, or the blank pair the player sends before it has
    // prompted. Neither is a wrong guess, so neither counts against the limit.
    if (credentials == null || credentials.isBlank) {
      return HereSphereAuthResult.loginRequired;
    }

    final matches = await auth.matches(credentials);
    if (!matches) {
      throttle.recordFailure(client, now);
      Logger.warning('HereSphere: failed login from $client');
      return HereSphereAuthResult.loginFailed;
    }

    throttle.recordSuccess(client);
    _noteClientAddress(request);
    Logger.info('HereSphere: $client signed in');
    return HereSphereAuthResult.granted;
  }

  /// Answers a request whose session token is missing, invented or expired.
  ///
  /// The JSON routes get `access: 0`, which sends HereSphere back to log in
  /// again; the byte routes get a 404, since a video decoder has nothing to do
  /// with an access field.
  Future<void> _unauthorised(HttpRequest request) async {
    final segments = request.uri.pathSegments;
    final wantsJson = segments.contains('video') || segments.contains('scan');
    if (wantsJson) {
      await _writeJson(request, {
        'access': hereSphereAccessLoginRequired,
        'library': const [],
      });
      return;
    }
    await _writeStatus(request.response, HttpStatus.notFound);
  }

  Future<void> _route(
    HttpRequest request,
    String token,
    List<String> path,
  ) async {
    final response = request.response;

    if (path.length == 2 && path[0] == 'video') {
      if (!_allow(request, const {'GET', 'POST', 'HEAD'})) return;
      await _drain(request);
      final entry = _library.entryById(path[1]);
      if (entry == null) {
        await _writeStatus(response, HttpStatus.notFound);
        return;
      }
      final size = await _fileSize(entry.mediaPath);
      await _writeJson(
        request,
        _api(request, token).videoData(
          entry,
          fileSizeBytes: size,
          scripts: _publishableScripts(entry),
        ),
      );
      return;
    }

    if (path.length == 2 && path[0] == 'thumb') {
      if (!_allow(request, const {'GET', 'HEAD'})) return;
      await _drain(request);
      await _serveThumbnail(request, path[1]);
      return;
    }

    if (path.length == 2 && path[0] == 'media') {
      if (!_allow(request, const {'GET', 'HEAD'})) return;
      await _drain(request);
      final entry = _library.entryById(path[1]);
      if (entry == null) {
        await _writeStatus(response, HttpStatus.notFound);
        return;
      }
      await _serveMedia(request, entry);
      return;
    }

    if (path.length == 3 && path[0] == 'script') {
      if (!_allow(request, const {'GET', 'HEAD'})) return;
      await _drain(request);
      await _serveScript(request, path[1], path[2]);
      return;
    }

    if (path.length == 1 && path[0] == 'event') {
      if (!_allow(request, const {'POST'})) return;
      // The one route that moves the clock, so the one route a second player
      // may not reach. Refused rather than ignored: a player whose events are
      // silently dropped looks to its user like a device that stopped working.
      if (!_claimClient(request)) {
        await _drain(request);
        Logger.warning(
          'HereSphere: refused playback events from ${_clientKey(request)}; '
          '${_claim.holder} is driving',
        );
        await _writeStatus(request.response, HttpStatus.forbidden);
        return;
      }
      await _handleEvent(request);
      return;
    }

    await _drain(request);
    await _writeStatus(response, HttpStatus.notFound);
  }

  /// Scripts this entry may hand out, which is none unless the user put
  /// HereSphere in charge of the device.
  List<HereSphereScript> _publishableScripts(HereSphereEntry entry) {
    if (!deviceOwner.value.publishesScripts) return const [];
    return _library.scripts(entry);
  }

  Future<void> _serveScript(
    HttpRequest request,
    String id,
    String rawIndex,
  ) async {
    final response = request.response;
    final entry = _library.entryById(id);
    final index = int.tryParse(rawIndex);
    if (entry == null || index == null) {
      await _writeStatus(response, HttpStatus.notFound);
      return;
    }

    // Checked here as well as when building the metadata: a client that kept a
    // script URL from an earlier session must not keep working after the user
    // has taken the device back.
    final published = _publishableScripts(entry);
    if (!published.any((script) => script.index == index)) {
      await _writeStatus(response, HttpStatus.notFound);
      return;
    }

    Uint8List? bytes;
    try {
      bytes = await _library.scriptBytes(entry, index);
    } catch (e) {
      Logger.warning('HereSphere: could not read script $index of $id: $e');
    }
    if (bytes == null) {
      await _writeStatus(response, HttpStatus.notFound);
      return;
    }

    response.statusCode = HttpStatus.ok;
    response.headers.contentType = ContentType.json;
    response.contentLength = bytes.length;
    if (request.method != 'HEAD') response.add(bytes);
    await response.close();
  }

  Future<void> _handleEvent(HttpRequest request) async {
    final body = await _readBody(request);
    if (body != null) {
      try {
        final event = HereSphereEvent.fromJson(jsonDecode(body));
        if (event != null) {
          Logger.debug('HereSphere event: $event');
          if (_events.hasListener) _events.add(event);
        } else {
          // Name the fields, never their values: the payload carries the
          // session token inside `id`. Which keys arrived is what tells a
          // future reader whether the player changed shape on us.
          final decoded = jsonDecode(body);
          final keys = decoded is Map
              ? decoded.keys.join(', ')
              : '<not an object>';
          Logger.warning(
            'HereSphere: unrecognised event payload; fields: $keys',
          );
        }
      } catch (e) {
        // A malformed body is the client's problem, not a server fault; the
        // event channel is best-effort and the timestamp channel corrects it.
        Logger.warning('HereSphere: malformed event payload: $e');
      }
    }
    // Always 200: HereSphere has nothing useful to do with a rejection, and an
    // endpoint that looks broken could make it stop sending events at all.
    await _writeStatus(request.response, HttpStatus.ok);
  }

  Future<void> _serveThumbnail(HttpRequest request, String id) async {
    final response = request.response;
    final entry = _library.entryById(id);
    if (entry == null) {
      await _writeStatus(response, HttpStatus.notFound);
      return;
    }
    HereSphereThumbnail? thumbnail;
    try {
      thumbnail = await _library.thumbnail(entry);
    } catch (e) {
      Logger.warning('HereSphere: thumbnail lookup failed: $e');
    }
    if (thumbnail == null) {
      await _writeStatus(response, HttpStatus.notFound);
      return;
    }
    final type = thumbnail.mimeType.split('/');
    response.statusCode = HttpStatus.ok;
    response.headers.contentType = type.length == 2
        ? ContentType(type[0], type[1])
        : ContentType('image', 'jpeg');
    response.contentLength = thumbnail.bytes.length;
    if (request.method != 'HEAD') response.add(thumbnail.bytes);
    await response.close();
  }

  Future<void> _serveMedia(HttpRequest request, HereSphereEntry entry) async {
    final response = request.response;
    final file = File(entry.mediaPath);

    final int length;
    try {
      length = await file.length();
    } catch (e) {
      // Indexed but gone, or unreadable. Never echo the path back to the
      // client.
      Logger.warning('HereSphere: cannot stat media ${entry.id}: $e');
      await _writeStatus(response, HttpStatus.notFound);
      return;
    }

    response.headers.set(HttpHeaders.acceptRangesHeader, 'bytes');
    response.headers.contentType = contentTypeForMedia(entry.mediaPath);

    final resolution = resolveRange(
      request.headers.value(HttpHeaders.rangeHeader),
      length,
    );

    switch (resolution) {
      case UnsatisfiableRange():
        response.statusCode = HttpStatus.requestedRangeNotSatisfiable;
        // Tells the client the real length so it can retry sensibly.
        response.headers.set(HttpHeaders.contentRangeHeader, 'bytes */$length');
        response.contentLength = 0;
        await response.close();

      case FullContent():
        response.statusCode = HttpStatus.ok;
        response.contentLength = length;
        await _pump(request, () => file.openRead(), entry.id);

      case PartialContent(:final range):
        response.statusCode = HttpStatus.partialContent;
        response.headers.set(
          HttpHeaders.contentRangeHeader,
          'bytes ${range.start}-${range.end}/$length',
        );
        response.contentLength = range.length;
        await _pump(
          request,
          // openRead's end is exclusive; the range's is inclusive.
          () => file.openRead(range.start, range.end + 1),
          entry.id,
        );
    }
  }

  /// Streams [openStream] to the response, honouring HEAD and surviving the
  /// client hanging up.
  ///
  /// The file is never read into memory: `openRead` yields chunks and
  /// `addStream` pauses it whenever the socket buffer fills, so a seek into an
  /// 8K file costs one open and a few chunks rather than a copy of the file.
  Future<void> _pump(
    HttpRequest request,
    Stream<List<int>> Function() openStream,
    String id,
  ) async {
    final response = request.response;
    if (request.method == 'HEAD') {
      await response.close();
      return;
    }
    try {
      await response.addStream(openStream());
      await response.close();
    } catch (e) {
      // Seeking *is* an abort: HereSphere drops the current response and asks
      // for a new offset. Routine, so this is not logged as an error.
      Logger.debug('HereSphere: stream for $id ended early: $e');
      try {
        await response.close();
      } catch (_) {
        // Socket already gone.
      }
    }
  }

  HereSphereApi _api(HttpRequest request, String token) =>
      HereSphereApi(_baseUrlFor(request, token));

  /// Builds the prefix for every URL handed back to the client.
  ///
  /// Derived from the request's own Host header so whichever address the client
  /// reached us on keeps working — a LAN address from a headset, loopback from
  /// this machine — instead of advertising one guessed interface. The header is
  /// client-controlled, but it is only ever reflected back to that same client,
  /// and it is validated before use.
  String _baseUrlFor(HttpRequest request, String token) {
    final host = _sanitizeHost(request.headers.value(HttpHeaders.hostHeader));
    return 'http://$host/$hereSpherePathPrefix/$token';
  }

  String _sanitizeHost(String? header) {
    final fallback = _fallbackAuthority();
    if (header == null) return fallback;
    final host = header.trim();
    if (host.isEmpty || host.length > 255) return fallback;
    // host[:port], where host is a name, an IPv4 address, or a bracketed IPv6
    // one. Anything else — spaces, slashes, credentials — falls back.
    final valid = RegExp(
      r'^(\[[0-9A-Fa-f:.]+\]|[A-Za-z0-9._-]+)(:\d{1,5})?$',
    ).hasMatch(host);
    return valid ? host : fallback;
  }

  String _fallbackAuthority() {
    final server = _server;
    if (server == null) return 'localhost';
    final address = server.address;
    final host = address.type == InternetAddressType.IPv6
        ? '[${address.address}]'
        : address.address;
    return '$host:${server.port}';
  }

  bool _claimClient(HttpRequest request) {
    final key = _clientKey(request);
    final previous = _claim.holder;
    if (!_claim.claim(key, DateTime.now())) return false;
    if (previous != key) Logger.info('HereSphere: playback claimed by $key');
    // Re-read after the claim, never before: the request that hands the clock
    // to a new driver is also the first evidence of where that driver lives,
    // which is what lets a headset back on a new lease move the channel with
    // it rather than leaving it dialling the address it used yesterday.
    _noteClientAddress(request);
    return true;
  }

  void _releaseClaim() {
    _claim.release();
    _connectedClient.value = null;
    _clientAddress.value = null;
  }

  /// Records where the player can be reached, for the timestamp channel.
  ///
  /// Loopback is normalised to `127.0.0.1`: the claim key collapses every
  /// loopback form to one name, which is right for identity and useless for
  /// dialling.
  void _noteClientAddress(HttpRequest request) {
    final address = request.connectionInfo?.remoteAddress;
    if (address == null) return;

    final key = _clientKey(request);
    _connectedClient.value = key;

    // Whoever drives the clock is the player worth dialling; a phone browsing
    // the library is not, and now that browsing no longer needs the claim it
    // could otherwise aim the channel at itself. Before anyone is driving, the
    // client doing the asking is the only candidate there is — which is what
    // brings the channel up while a headset is still browsing, rather than a
    // beat late at the first video it opens.
    final driver = _claim.holder;
    if (driver != null && driver != key) return;

    final dialable = address.isLoopback ? '127.0.0.1' : address.address;
    if (_clientAddress.value != dialable) {
      Logger.info('HereSphere: player reachable at $dialable');
      _clientAddress.value = dialable;
    }
  }

  /// Identity of the requesting client.
  ///
  /// All loopback addresses collapse to one key: a client on this machine can
  /// arrive as 127.0.0.1 or ::1 from one request to the next, and treating
  /// those as rivals would lock the user out of their own server.
  static String _clientKey(HttpRequest request) {
    final address = request.connectionInfo?.remoteAddress;
    if (address == null) return 'unknown';
    return address.isLoopback ? 'loopback' : address.address;
  }

  /// Answers [request] with `405` and returns false when its method is not in
  /// [allowed], so callers can guard a route with a single `if`.
  bool _allow(HttpRequest request, Set<String> allowed) {
    if (allowed.contains(request.method)) return true;
    unawaited(() async {
      await _drain(request);
      request.response.headers.set(HttpHeaders.allowHeader, allowed.join(', '));
      await _writeStatus(request.response, HttpStatus.methodNotAllowed);
    }());
    return false;
  }

  /// Reads a bounded request body, or null when there is none or it is too big.
  static Future<String?> _readBody(HttpRequest request) async {
    final builder = BytesBuilder(copy: false);
    var overLimit = false;
    await for (final chunk in request) {
      // Past the cap the bytes are dropped but still read: abandoning the
      // stream mid-body leaves a keep-alive connection out of step, and the
      // client's next request would be parsed as the tail of this one.
      if (overLimit) continue;
      builder.add(chunk);
      if (builder.length > _maxRequestBodyBytes) {
        overLimit = true;
        builder.clear();
        Logger.warning('HereSphere: request body over the size limit');
      }
    }
    if (overLimit || builder.isEmpty) return null;
    try {
      return utf8.decode(builder.takeBytes());
    } catch (_) {
      return null;
    }
  }

  /// Consumes a body we do not need, so the connection can be reused.
  static Future<void> _drain(HttpRequest request) async {
    try {
      await request.drain<void>();
    } catch (_) {
      // Client hung up before finishing its body.
    }
  }

  static Future<void> _writeStatus(HttpResponse response, int status) async {
    response.statusCode = status;
    response.contentLength = 0;
    await response.close();
  }

  static Future<void> _writeJson(
    HttpRequest request,
    Map<String, dynamic> body,
  ) async {
    final response = request.response;
    final bytes = utf8.encode(jsonEncode(body));
    response.statusCode = HttpStatus.ok;
    response.headers.set(hereSphereJsonVersionHeader, hereSphereJsonVersion);
    response.headers.contentType = ContentType.json;
    response.contentLength = bytes.length;
    if (request.method != 'HEAD') response.add(bytes);
    await response.close();
  }

  static Future<int?> _fileSize(String path) async {
    try {
      return await File(path).length();
    } catch (_) {
      return null;
    }
  }

  static Future<InternetAddress> _resolveBindAddress(String address) async {
    final trimmed = address.trim();
    if (trimmed.isEmpty) return InternetAddress.anyIPv4;
    final literal = InternetAddress.tryParse(trimmed);
    if (literal != null) return literal;
    final resolved = await InternetAddress.lookup(trimmed);
    if (resolved.isEmpty) {
      throw ArgumentError('No address found for "$trimmed"');
    }
    return resolved.first;
  }

  static String _describeBindFailure(Object error, String address, int port) {
    if (error is SocketException) {
      final reason = error.osError?.message ?? error.message;
      return 'Could not listen on $address:$port — $reason';
    }
    return 'Could not listen on $address:$port — $error';
  }
}

/// Content type for a media file, chosen by extension.
///
/// Deliberately narrow: an unknown extension gets `application/octet-stream`
/// rather than a guess, which players handle by sniffing the container.
ContentType contentTypeForMedia(String path) {
  switch (p.extension(path).toLowerCase()) {
    case '.mp4':
    case '.m4v':
      return ContentType('video', 'mp4');
    case '.mkv':
      return ContentType('video', 'x-matroska');
    case '.webm':
      return ContentType('video', 'webm');
    case '.mov':
      return ContentType('video', 'quicktime');
    case '.avi':
      return ContentType('video', 'x-msvideo');
    case '.wmv':
      return ContentType('video', 'x-ms-wmv');
    case '.ts':
      return ContentType('video', 'mp2t');
    case '.flv':
      return ContentType('video', 'x-flv');
    case '.m4a':
      return ContentType('audio', 'mp4');
    case '.mp3':
      return ContentType('audio', 'mpeg');
    default:
      return ContentType('application', 'octet-stream');
  }
}

/// Addresses this machine can be reached on, for the settings panel to show.
///
/// Loopback is listed last: it works only when HereSphere runs on this same
/// machine, and a headset needs one of the others.
Future<List<String>> hereSphereCandidateHosts() async {
  final hosts = <String>[];
  try {
    final interfaces = await NetworkInterface.list(
      includeLoopback: false,
      type: InternetAddressType.IPv4,
    );
    for (final interface in interfaces) {
      for (final address in interface.addresses) {
        hosts.add(address.address);
      }
    }
  } catch (e) {
    Logger.warning('HereSphere: could not enumerate interfaces: $e');
  }
  hosts.add('127.0.0.1');
  return hosts;
}
