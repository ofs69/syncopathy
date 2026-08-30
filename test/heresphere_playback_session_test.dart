import 'package:flutter_test/flutter_test.dart';
import 'package:syncopathy/heresphere/heresphere_event.dart';
import 'package:syncopathy/heresphere/heresphere_playback_session.dart';
import 'package:syncopathy/heresphere/timestamp_protocol.dart';
import 'package:syncopathy/model/timesource_model.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';
import 'package:syncopathy/player/playback_session.dart';

MediaFile media(String name) => MediaFile(
  name: name,
  mediaPath: 'Q:/media/$name.mp4',
  fileHash: name,
  playCount: 0,
  fileNotFound: false,
);

/// Records what a session was told to send back to the player.
class _RecordingSink implements HereSphereCommandSink {
  final List<String> sent = [];

  @override
  void seek(double seconds) => sent.add('seek:$seconds');

  @override
  void setPaused(bool paused) => sent.add('paused:$paused');

  @override
  void setSpeed(double speed) => sent.add('speed:$speed');
}

HereSphereSnapshot snapshot({
  String? resource,
  double? currentTime,
  double? duration,
  double? speed,
  HereSpherePlayerState state = HereSpherePlayerState.playing,
}) => HereSphereSnapshot(
  resource: resource,
  currentTime: currentTime,
  duration: duration,
  playbackSpeed: speed,
  state: state,
);

void main() {
  late MediaFile clip;
  late HereSpherePlaybackSession session;

  setUp(() {
    clip = media('clip');
    session = HereSpherePlaybackSession(
      // Any identifier resolves to the one clip; the resolver has its own
      // tests, and this keeps these about the clock.
      resolve: (id, resource) => (id == null && resource == null) ? null : clip,
    );
  });

  tearDown(() => session.dispose());

  group('media identity', () {
    test('an open event loads the entry and starts paused', () {
      session.applyEvent(
        const HereSphereEvent(
          kind: HereSphereEventKind.open,
          id: 'clip',
          time: 0,
        ),
      );

      expect(session.currentMedia.value, clip);
      expect(session.paused.value, isTrue);
    });

    test('media that does not resolve leaves the session disconnected', () {
      // Streaming something the library does not know: there is no script to
      // drive from, so the device must not be handed a clock.
      final unknown = HereSpherePlaybackSession(resolve: (_, _) => null);
      addTearDown(unknown.dispose);
      unknown.setChannelHealthy(true);

      unknown.applyEvent(
        const HereSphereEvent(kind: HereSphereEventKind.open, id: 'nope'),
      );

      expect(unknown.currentMedia.value, isNull);
      expect(unknown.connected.value, isFalse);
    });

    test('a close event clears everything', () {
      session.setChannelHealthy(true);
      session.applyEvent(
        const HereSphereEvent(
          kind: HereSphereEventKind.play,
          id: 'clip',
          time: 10,
        ),
      );
      expect(session.connected.value, isTrue);

      session.applyEvent(
        const HereSphereEvent(kind: HereSphereEventKind.close),
      );

      expect(session.currentMedia.value, isNull);
      expect(session.rawPosition.value, 0.0);
      expect(session.paused.value, isTrue);
      expect(session.connected.value, isFalse);
    });

    test('a reset frame closes the media but keeps the channel', () {
      session.setChannelHealthy(true);
      session.applySnapshot(snapshot(resource: 'x', currentTime: 5));
      expect(session.currentMedia.value, clip);

      session.applyReset();

      expect(session.currentMedia.value, isNull);
      expect(session.paused.value, isTrue);
    });
  });

  group('transport state', () {
    test('play and pause events move the paused signal', () {
      session.applyEvent(
        const HereSphereEvent(
          kind: HereSphereEventKind.play,
          id: 'clip',
          time: 1,
          speed: 1.5,
        ),
      );
      expect(session.paused.value, isFalse);
      expect(session.playbackSpeed.value, 1.5);

      session.applyEvent(
        const HereSphereEvent(kind: HereSphereEventKind.pause, time: 2),
      );
      expect(session.paused.value, isTrue);
      expect(session.rawPosition.value, 2.0);
    });

    test('a paused snapshot pauses even mid-playback', () {
      session.applySnapshot(snapshot(resource: 'x', currentTime: 1));
      expect(session.paused.value, isFalse);

      session.applySnapshot(
        snapshot(
          resource: 'x',
          currentTime: 1.2,
          state: HereSpherePlayerState.paused,
        ),
      );
      expect(session.paused.value, isTrue);
    });

    test('an unknown player state reads as paused', () {
      session.applySnapshot(
        snapshot(
          resource: 'x',
          currentTime: 1,
          state: HereSpherePlayerState.unknown,
        ),
      );
      expect(session.paused.value, isTrue);
    });

    test('duration and speed come from the snapshot', () {
      session.applySnapshot(
        snapshot(resource: 'x', currentTime: 0, duration: 300, speed: 0.75),
      );
      expect(session.duration.value, 300.0);
      expect(session.playbackSpeed.value, 0.75);
    });

    test('a nonsense duration or speed is ignored, not adopted', () {
      session.applySnapshot(
        snapshot(resource: 'x', currentTime: 0, duration: 300, speed: 1.0),
      );
      session.applySnapshot(
        snapshot(resource: 'x', currentTime: 1, duration: 0, speed: 0),
      );
      expect(session.duration.value, 300.0);
      expect(session.playbackSpeed.value, 1.0);
    });
  });

  group('seek detection', () {
    test('ordinary drift between reports is not a seek', () async {
      session.applySnapshot(snapshot(resource: 'x', currentTime: 10));
      await Future<void>.delayed(const Duration(milliseconds: 50));
      // Roughly where a second of playback would put it — well inside the
      // threshold, so this is a correction and nothing more.
      session.applySnapshot(snapshot(resource: 'x', currentTime: 10.06));

      expect(session.seeking.value, isFalse);
      expect(session.rawPosition.value, 10.06);
    });

    test('a jump forward raises seeking with the new position in place', () {
      session.applySnapshot(snapshot(resource: 'x', currentTime: 10));
      session.applySnapshot(snapshot(resource: 'x', currentTime: 120));

      // Backends rebuild their buffer on the falling edge, so the position has
      // to be correct while seeking is still raised.
      expect(session.seeking.value, isTrue);
      expect(session.rawPosition.value, 120.0);
    });

    test('seeking falls again on its own', () async {
      session.applySnapshot(snapshot(resource: 'x', currentTime: 10));
      session.applySnapshot(snapshot(resource: 'x', currentTime: 120));
      expect(session.seeking.value, isTrue);

      await Future<void>.delayed(
        hereSphereSeekPulse + const Duration(milliseconds: 60),
      );
      expect(session.seeking.value, isFalse);
      expect(session.rawPosition.value, 120.0);
    });

    test('a jump backwards is a seek too', () {
      session.applySnapshot(snapshot(resource: 'x', currentTime: 120));
      session.applySnapshot(snapshot(resource: 'x', currentTime: 3));
      expect(session.seeking.value, isTrue);
      expect(session.rawPosition.value, 3.0);
    });

    test('a loop back to the start is reported as a seek', () async {
      // Whether the player calls it a loop or a seek, a device backend's buffer
      // now describes the wrong part of the timeline and has to be rebuilt.
      session.applySnapshot(
        snapshot(resource: 'x', currentTime: 599, duration: 600),
      );
      session.applySnapshot(
        snapshot(resource: 'x', currentTime: 0.1, duration: 600),
      );
      expect(session.seeking.value, isTrue);
    });

    test('the first report after opening is not a seek', () {
      // There is no prediction to compare against yet, so a large first
      // position must not pulse the backends for nothing.
      session.applyEvent(
        const HereSphereEvent(kind: HereSphereEventKind.open, id: 'clip'),
      );
      session.applySnapshot(snapshot(resource: 'x', currentTime: 450));
      expect(session.seeking.value, isFalse);
      expect(session.rawPosition.value, 450.0);
    });

    test('a paused clock that jumps is still a seek', () {
      session.applySnapshot(
        snapshot(
          resource: 'x',
          currentTime: 10,
          state: HereSpherePlayerState.paused,
        ),
      );
      session.applySnapshot(
        snapshot(
          resource: 'x',
          currentTime: 90,
          state: HereSpherePlayerState.paused,
        ),
      );
      expect(session.seeking.value, isTrue);
    });
  });

  group('stall detection', () {
    test('a clock that stops while playing is treated as buffering', () async {
      // HereSphere reports no buffering of its own, and the plan forbids
      // reading it off download progress. A playhead that does not move is the
      // only honest signal left.
      session.applySnapshot(snapshot(resource: 'x', currentTime: 10));
      expect(session.buffering.value, isFalse);

      await Future<void>.delayed(
        hereSphereStallAfter + const Duration(milliseconds: 100),
      );
      session.applySnapshot(snapshot(resource: 'x', currentTime: 10));

      expect(session.buffering.value, isTrue);
    });

    test('buffering clears as soon as the clock moves again', () async {
      session.applySnapshot(snapshot(resource: 'x', currentTime: 10));
      await Future<void>.delayed(
        hereSphereStallAfter + const Duration(milliseconds: 100),
      );
      session.applySnapshot(snapshot(resource: 'x', currentTime: 10));
      expect(session.buffering.value, isTrue);

      session.applySnapshot(snapshot(resource: 'x', currentTime: 10.4));
      expect(session.buffering.value, isFalse);
    });

    test('a paused clock is not a stall', () async {
      session.applySnapshot(
        snapshot(
          resource: 'x',
          currentTime: 10,
          state: HereSpherePlayerState.paused,
        ),
      );
      await Future<void>.delayed(
        hereSphereStallAfter + const Duration(milliseconds: 100),
      );
      session.applySnapshot(
        snapshot(
          resource: 'x',
          currentTime: 10,
          state: HereSpherePlayerState.paused,
        ),
      );
      expect(session.buffering.value, isFalse);
    });
  });

  group('connection fail-safe', () {
    test('a session with no channel is not connected', () {
      session.applySnapshot(snapshot(resource: 'x', currentTime: 5));
      expect(session.currentMedia.value, clip);
      expect(session.connected.value, isFalse);
    });

    test('losing the channel reads as paused downstream', () {
      // The whole point of the fail-safe: with nothing correcting the clock,
      // the device must stop rather than run on extrapolation.
      final active = ActivePlaybackSession(session);
      final timesource = TimesourceModel.fromSession(active.session);

      session.setChannelHealthy(true);
      session.applySnapshot(snapshot(resource: 'x', currentTime: 5));
      expect(timesource.paused.value, isFalse);

      session.setChannelHealthy(false);
      expect(timesource.paused.value, isTrue);
    });

    test('the clock stops advancing once the channel is gone', () {
      session.setChannelHealthy(true);
      session.applySnapshot(snapshot(resource: 'x', currentTime: 5));
      session.setChannelHealthy(false);

      // The next report after a gap must land as a correction rather than be
      // measured against a prediction built before the outage.
      session.setChannelHealthy(true);
      session.applySnapshot(snapshot(resource: 'x', currentTime: 45));

      expect(session.seeking.value, isFalse);
      expect(session.rawPosition.value, 45.0);
    });
  });

  group('commands', () {
    test('a session with no command sink advertises nothing', () {
      expect(session.capabilities.value, isEmpty);
      expect(() => session.seekTo(Duration.zero), throwsUnsupportedError);
      expect(session.togglePause, throwsUnsupportedError);
      expect(() => session.setSpeed(1.5), throwsUnsupportedError);
    });

    test('attaching a sink grants the matching capabilities', () {
      final sink = _RecordingSink();
      session.attachCommands(sink);

      expect(session.supports(PlaybackCapability.seek), isTrue);
      expect(session.supports(PlaybackCapability.playPause), isTrue);
      expect(session.supports(PlaybackCapability.setSpeed), isTrue);
      // Never granted: Syncopathy does not open or close media on the player.
      expect(session.supports(PlaybackCapability.openMedia), isFalse);
    });

    test('commands reach the sink', () {
      final sink = _RecordingSink();
      session.attachCommands(sink);
      session.applySnapshot(snapshot(resource: 'x', currentTime: 1));

      session.seekTo(const Duration(milliseconds: 2500));
      session.togglePause();
      session.setSpeed(1.25);

      expect(sink.sent, ['seek:2.5', 'paused:true', 'speed:1.25']);
    });

    test('detaching takes the capabilities away again', () {
      session.attachCommands(_RecordingSink());
      expect(session.capabilities.value, isNotEmpty);

      session.attachCommands(null);

      expect(session.capabilities.value, isEmpty);
      expect(() => session.seekTo(Duration.zero), throwsUnsupportedError);
    });
  });
}
