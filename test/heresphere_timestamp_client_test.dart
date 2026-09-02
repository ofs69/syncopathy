import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:syncopathy/heresphere/timestamp_client.dart';
import 'package:syncopathy/heresphere/timestamp_protocol.dart';

/// A stand-in for HereSphere's timestamp server: accepts one client, sends
/// whatever the test tells it to, and records what came back.
class _FakePlayer {
  final ServerSocket _server;
  final List<Socket> connections = [];

  /// The connections still open. Every attempt the client makes is accepted by
  /// the OS whether the client wants it or not, so how many were *accepted*
  /// says nothing; how many it kept is the interesting number.
  final List<Socket> open = [];
  final List<int> received = [];

  final _connected = Completer<Socket>();

  _FakePlayer._(this._server) {
    _server.listen((socket) {
      connections.add(socket);
      open.add(socket);
      socket.listen(
        received.addAll,
        onError: (_) => open.remove(socket),
        onDone: () => open.remove(socket),
      );
      if (!_connected.isCompleted) _connected.complete(socket);
    });
  }

  static Future<_FakePlayer> bind() async =>
      _FakePlayer._(await ServerSocket.bind(InternetAddress.loopbackIPv4, 0));

  int get port => _server.port;

  Future<Socket> get firstConnection => _connected.future;

  void send(Socket socket, Map<String, Object?> state) =>
      socket.add(encodeHereSphereFrame(state));

  Future<void> close() async {
    for (final socket in connections) {
      socket.destroy();
    }
    await _server.close();
  }
}

/// Polls until [condition] holds or the budget runs out, so a test never sleeps
/// longer than it has to.
Future<void> waitFor(
  bool Function() condition, {
  Duration timeout = const Duration(seconds: 8),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (!condition() && DateTime.now().isBefore(deadline)) {
    await Future<void>.delayed(const Duration(milliseconds: 20));
  }
}

void main() {
  late _FakePlayer player;
  late HereSphereTimestampClient client;

  setUp(() async {
    player = await _FakePlayer.bind();
    client = HereSphereTimestampClient();
  });

  tearDown(() async {
    await client.dispose();
    await player.close();
  });

  test('connects and reports state frames', () async {
    final frames = <HereSphereFrame>[];
    client.frames.listen(frames.add);

    client.start(host: '127.0.0.1', port: player.port);
    final socket = await player.firstConnection;
    await waitFor(() => client.socketConnected.value);

    player.send(socket, {
      'currentTime': 42.0,
      'playerState': 0,
      'resource': 'http://host/hs/tok/media/abc',
    });
    await waitFor(() => frames.isNotEmpty);

    final snapshot = (frames.single as HereSphereStateFrame).snapshot;
    expect(snapshot.currentTime, 42.0);
    expect(snapshot.isPlaying, isTrue);
    expect(client.healthy.value, isTrue);
  });

  test('a connection that never delivers state is not healthy', () async {
    // An open socket is not the same as a working channel: nothing is
    // correcting the clock until state actually arrives.
    client.start(host: '127.0.0.1', port: player.port);
    await player.firstConnection;
    await waitFor(() => client.socketConnected.value);

    expect(client.socketConnected.value, isTrue);
    expect(client.healthy.value, isFalse);
  });

  test('sends keepalives so the player does not drop us', () async {
    client.start(host: '127.0.0.1', port: player.port);
    await player.firstConnection;
    await waitFor(
      () => player.received.length >= 4,
      timeout: const Duration(seconds: 5),
    );

    // The keepalive is an empty frame: a four-byte zero length.
    expect(player.received.take(4).toList(), [0, 0, 0, 0]);
  });

  test('a dropped connection is re-established', () async {
    client.start(host: '127.0.0.1', port: player.port);
    final socket = await player.firstConnection;
    await waitFor(() => client.socketConnected.value);

    socket.destroy();
    await waitFor(() => !client.socketConnected.value);
    expect(client.socketConnected.value, isFalse);

    // A headset going to sleep and waking again is normal, not an error.
    await waitFor(
      () => client.socketConnected.value,
      timeout: const Duration(seconds: 10),
    );
    expect(client.socketConnected.value, isTrue);
    expect(player.connections.length, greaterThanOrEqualTo(2));
  });

  test('health drops when a live connection goes quiet', () async {
    client.start(host: '127.0.0.1', port: player.port);
    final socket = await player.firstConnection;
    player.send(socket, {'currentTime': 1.0, 'playerState': 0});
    await waitFor(() => client.healthy.value);

    // The socket stays open; only the reports stop. That is the case the
    // fail-safe exists for — an extrapolated clock with nothing correcting it.
    await waitFor(
      () => !client.healthy.value,
      timeout: hereSphereStaleAfter + const Duration(seconds: 3),
    );
    expect(client.healthy.value, isFalse);
    expect(client.socketConnected.value, isTrue);
  });

  test('stopping closes the connection and does not reconnect', () async {
    client.start(host: '127.0.0.1', port: player.port);
    await player.firstConnection;
    await waitFor(() => client.socketConnected.value);

    client.stop();
    expect(client.socketConnected.value, isFalse);
    expect(client.healthy.value, isFalse);

    final connectionsWhenStopped = player.connections.length;
    await Future<void>.delayed(const Duration(seconds: 2));
    expect(player.connections.length, connectionsWhenStopped);
  });

  test('switching off and on again leaves only one connection', () async {
    // `Socket.connect` cannot be cancelled, so a stop lands while an attempt is
    // still in flight — the shape of a user toggling the feature off and on
    // because the headset was not answering. The abandoned attempt must not
    // come back and install itself alongside the one that replaced it.
    client.start(host: '127.0.0.1', port: player.port);
    client.stop();
    client.start(host: '127.0.0.1', port: player.port);

    await player.firstConnection;
    await waitFor(() => client.socketConnected.value);
    await waitFor(() => player.open.length == 1);

    expect(player.open.length, 1);

    // The orphan was the harmful part: the client held no reference to it, so
    // it outlived a stop still delivering frames and, when it eventually
    // dropped, tore down whichever connection was live by then. A stop now
    // really does close everything.
    client.stop();
    expect(client.socketConnected.value, isFalse);
    await waitFor(() => player.open.isEmpty);
    expect(player.open, isEmpty);
  });

  test('an endpoint change abandons the attempt it replaced', () async {
    final other = await _FakePlayer.bind();
    addTearDown(other.close);

    client.start(host: '127.0.0.1', port: player.port);
    // Retyped before the first attempt resolves.
    client.start(host: '127.0.0.1', port: other.port);

    await other.firstConnection;
    await waitFor(() => client.socketConnected.value);
    await waitFor(() => player.open.isEmpty);

    expect(other.open.length, 1);
    // Whatever the abandoned attempt reached is dropped, not kept alongside.
    expect(player.open, isEmpty);
  });

  test('an unreachable endpoint reports rather than throws', () async {
    final deadPort = player.port;
    await player.close();

    client.start(host: '127.0.0.1', port: deadPort);
    await waitFor(() => client.lastError.value != null);

    expect(client.lastError.value, isNotNull);
    expect(client.healthy.value, isFalse);
  });

  group('commands', () {
    test('nothing is sent while commands are disabled', () async {
      // Observing the player and steering it are different permissions.
      client.start(host: '127.0.0.1', port: player.port);
      await player.firstConnection;
      await waitFor(() => client.socketConnected.value);

      expect(client.seekTo(30), isFalse);
      expect(client.setPaused(true), isFalse);
      expect(client.setSpeed(1.5), isFalse);
    });

    test('an enabled command reaches the player', () async {
      client.allowCommands.value = true;
      client.start(host: '127.0.0.1', port: player.port);
      await player.firstConnection;
      await waitFor(() => client.socketConnected.value);
      player.received.clear();

      expect(client.seekTo(30.5), isTrue);
      await waitFor(() => player.received.length > 4);

      final frames = HereSphereFrameDecoder().add(player.received);
      // Keepalives may be mixed in; the command is the one carrying state.
      final states = frames.whereType<HereSphereStateFrame>().toList();
      expect(states, isNotEmpty);
      expect(states.first.snapshot.currentTime, 30.5);
    });

    test('a command with no connection is refused, not queued', () async {
      client.allowCommands.value = true;
      expect(client.seekTo(10), isFalse);
    });
  });

  test('a closed port is reported as a setting, not a network fault', () async {
    // The distinction matters more than the wording: a refusal means the
    // address is right and nothing is bound there, which is a switch in the
    // player rather than anything the user can fix on this side.
    final probe = await ServerSocket.bind('127.0.0.1', 0);
    final closedPort = probe.port;
    await probe.close();

    final client = HereSphereTimestampClient();
    addTearDown(client.dispose);
    client.start(host: '127.0.0.1', port: closedPort);

    while (client.lastError.value == null) {
      await Future<void>.delayed(const Duration(milliseconds: 20));
    }

    expect(client.lastError.value, contains('Nothing is listening'));
    expect(client.lastError.value, contains('remote control'));
    expect(client.socketConnected.value, isFalse);
  });
}
