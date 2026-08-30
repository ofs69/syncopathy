import 'package:signals/signals.dart';
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

  /// How many times the session was asked to start or stop.
  int pauseToggles = 0;

  @override
  void seekTo(Duration position) {
    if (!supports(PlaybackCapability.seek)) {
      unsupported(PlaybackCapability.seek);
    }
    seeks.add(position);
  }

  @override
  void togglePause() {
    if (!supports(PlaybackCapability.playPause)) {
      unsupported(PlaybackCapability.playPause);
    }
    pauseToggles++;
    paused.value = !paused.value;
  }
}
