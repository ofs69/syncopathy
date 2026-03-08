import 'package:flutter/scheduler.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/helper/effect_dispose_mixin.dart';

class SmoothVideoSignals with EffectDispose {
  final ReadonlySignal<double> rawPosition;
  final ReadonlySignal<bool> isPaused;
  final ReadonlySignal<double> playbackSpeed;
  final ReadonlySignal<bool> buffering;

  final _frameTick = signal(DateTime.now());
  late final Ticker _ticker;
  DateTime _lastUpdateWallClock = DateTime.now();

  late final ReadonlySignal<double> smoothPosition;

  SmoothVideoSignals(
    this.rawPosition,
    this.isPaused,
    this.playbackSpeed,
    this.buffering,
  ) {
    _ticker = Ticker((_) => _frameTick.value = DateTime.now());

    smoothPosition = computed(() {
      final pos = rawPosition.value;
      final playing = !isPaused.value;
      final speed = playbackSpeed.value;
      final now = _frameTick.value;
      final isBuffering = buffering.value;

      if (!playing || isBuffering) return pos;

      // Calculate real-world time passed
      final wallClockDrift =
          now.difference(_lastUpdateWallClock).inMilliseconds / 1000.0;

      // Adjust drift based on playback speed
      final extrapolated = pos + (wallClockDrift * speed);
      return extrapolated < pos ? pos : extrapolated;
    });

    effectAdd([
      effect(() {
        update(
          rawPosition.value,
          !isPaused.value,
          playbackSpeed.value,
          buffering.value,
        );
      }),
    ]);
  }

  void dispose() {
    effectDispose();
    _ticker.dispose();
  }

  // Update this from your VideoPlayerController listener
  void update(double newPos, bool playing, double speed, bool buffering) {
    _lastUpdateWallClock = DateTime.now();

    if (playing && !_ticker.isTicking) _ticker.start();
    if ((!playing || buffering) && _ticker.isTicking) _ticker.stop();
  }
}
