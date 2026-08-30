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
  final List<int> received = [];

  final _connected = Completer<Socket>();

  _FakePlayer._(this._server) {
    _server.listen((socket) {
      connections.add(socket);
      socket.listen(received.addAll, onError: (_) {}, onDone: () {});
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
