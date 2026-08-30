import 'package:flutter_test/flutter_test.dart';
import 'package:signals/signals.dart';
import 'package:syncopathy/model/timesource_model.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';
import 'package:syncopathy/player/playback_session.dart';

/// A [PlaybackSession] driven entirely from the test, standing in for a player
/// Syncopathy does not own. Every signal is writable so a test can push the
/// clock around without a real decoder.
class FakePlaybackSession extends PlaybackSession {
  @override
  final Signal<MediaFile?> currentMedia = signal(null);
  @override
  final Signal<String> loadedPath = signal("");
  @override
  final Signal<double?> duration = signal(null);
  @override
  final Signal<bool> paused = signal(true);
  @override
  final Signal<bool> buffering = signal(false);
  @override
  final Signal<bool> seeking = signal(false);
  @override
  final Signal<double> rawPosition = signal(0.0);
  @override
  final Signal<double> playbackSpeed = signal(1.0);
  @override
  final Signal<bool> loopFile = signal(false);
  @override
  final Signal<int?> videoWidth = signal(null);
  @override
  final Signal<int?> videoHeight = signal(null);
  @override
  final Signal<bool> connected = signal(true);
  @override
  final Signal<Set<PlaybackCapability>> capabilities = signal({});

  /// No extrapolation: the tests want the clock to be exactly what they set.
  @override
  ReadonlySignal<double> get smoothPosition => rawPosition;

  final List<Duration> seeks = [];

  @override
  void seekTo(Duration position) {
    if (!supports(PlaybackCapability.seek)) {
      unsupported(PlaybackCapability.seek);
    }
    seeks.add(position);
  }
}

MediaFile _media(String name) => MediaFile(
  name: name,
  mediaPath: 'Q:/media/$name.mp4',
  fileHash: name,
  playCount: 0,
  fileNotFound: false,
);

void main() {
  group('PlaybackCapability', () {
    test('a command the session does not advertise throws', () {
      final session = FakePlaybackSession();

      expect(session.supports(PlaybackCapability.seek), isFalse);
      expect(() => session.seekTo(Duration.zero), throwsUnsupportedError);
      // Untouched defaults: nothing the base class does not implement should
      // silently succeed.
      expect(session.togglePause, throwsUnsupportedError);
      expect(() => session.setSpeed(1.5), throwsUnsupportedError);
      expect(session.toggleLooping, throwsUnsupportedError);
      expect(session.closeMedia(), throwsUnsupportedError);
    });

    test('capabilities are reactive, so lost control reaches the UI', () {
      final session = FakePlaybackSession();
      final seekable = <bool>[];
      final dispose = effect(
        () => seekable.add(session.supports(PlaybackCapability.seek)),
      );

      session.capabilities.value = {PlaybackCapability.seek};
      session.capabilities.value = {};

      dispose();
      expect(seekable, [false, true, false]);
    });

    test('seekRelative offsets the last reported position', () {
      final session = FakePlaybackSession()
        ..capabilities.value = {PlaybackCapability.seek}
        ..rawPosition.value = 12.5;

      session.seekRelative(const Duration(seconds: -2));

      expect(session.seeks, [const Duration(milliseconds: 10500)]);
    });
  });

  group('derived position signals', () {
    test('currentPositionFixedStep splits the duration into fixed steps', () {
      final session = FakePlaybackSession()
        ..duration.value = 100.0
        ..rawPosition.value = 50.0;

      expect(session.currentPositionSeconds.value, 50);
      expect(
        session.currentPositionFixedStep.value,
        videoPlayerPositionFixedStepCount ~/ 2,
      );
    });

    test('an unknown duration reports step 0 rather than dividing by it', () {
      final session = FakePlaybackSession()..rawPosition.value = 50.0;

      expect(session.currentPositionFixedStep.value, 0);
    });
  });

  group('TimesourceModel.fromSession', () {
    test('follows the session it was built from', () {
      final session = FakePlaybackSession();
      final active = ActivePlaybackSession(session);
      final timesource = TimesourceModel.fromSession(active.session);

      session.rawPosition.value = 4.2;
      session.paused.value = false;
      session.playbackSpeed.value = 1.5;
      session.loopFile.value = true;
      session.duration.value = 60.0;
      session.loadedPath.value = 'Q:/media/a.mp4';

      expect(timesource.currentRawMs, 4200);
      expect(timesource.currentSmoothMs, 4200);
      expect(timesource.paused.value, isFalse);
      expect(timesource.playbackSpeed.value, 1.5);
      expect(timesource.loopFile.value, isTrue);
      expect(timesource.duration.value, 60.0);
      expect(timesource.loadedPath.value, 'Q:/media/a.mp4');
    });

    test('a handover retargets the clock without rebuilding the timesource', () {
      final local = FakePlaybackSession()
        ..rawPosition.value = 10.0
        ..paused.value = false;
      final external = FakePlaybackSession()
        ..rawPosition.value = 99.0
        ..paused.value = false
        ..playbackSpeed.value = 2.0;

      final active = ActivePlaybackSession(local);
      final timesource = TimesourceModel.fromSession(active.session);
      final positions = <int>[];
      final dispose = effect(() {
        timesource.rawPosition.value;
        positions.add(timesource.currentRawMs);
      });

      expect(timesource.currentRawMs, 10000);

      active.takeOver(external);

      expect(timesource.currentRawMs, 99000);
      expect(timesource.playbackSpeed.value, 2.0);

      // The old session is still alive but no longer drives the clock.
      local.rawPosition.value = 11.0;
      expect(timesource.currentRawMs, 99000);

      dispose();
      expect(positions, [10000, 99000]);
    });

    test('a session that lost contact reads as paused', () {
      final session = FakePlaybackSession()..paused.value = false;
      final active = ActivePlaybackSession(session);
      final timesource = TimesourceModel.fromSession(active.session);

      expect(timesource.paused.value, isFalse);

      session.connected.value = false;

      // Otherwise an extrapolated clock with nothing correcting it would keep
      // driving the device after playback actually stopped.
      expect(timesource.paused.value, isTrue);
    });
  });

  group('ActivePlaybackSession', () {
    test('handing over to the same session does not notify', () {
      final session = FakePlaybackSession();
      final active = ActivePlaybackSession(session);
      var notifications = 0;
      final dispose = effect(() {
        active.session.value;
        notifications += 1;
      });

      active.takeOver(session);

      dispose();
      expect(notifications, 1);
    });

    test('currentMedia is read through the active session', () {
      final local = FakePlaybackSession()..currentMedia.value = _media('local');
      final external = FakePlaybackSession()
        ..currentMedia.value = _media('external');
      final active = ActivePlaybackSession(local);

      expect(active.value.currentMedia.value?.name, 'local');
      active.takeOver(external);
      expect(active.value.currentMedia.value?.name, 'external');
    });
  });
}
