import 'package:flutter/foundation.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/helper/debouncer.dart';
import 'package:syncopathy/helper/throttler.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/model/funscript.dart';
import 'package:syncopathy/player/player_backend.dart';

enum HspStateAdapterPlayState {
  hspStateNotInitialized,
  hspStatePlaying,
  hspStateStopped,
  hspStatePaused,
  hspStateStarving,
}

class HspStateAdapter {
  HspStateAdapterPlayState playState;
  int firstPointTime;
  int lastPointTime;
  int currentTime;
  int points;
  int currentPoint;

  HspStateAdapter({
    required this.playState,
    required this.firstPointTime,
    required this.lastPointTime,
    required this.currentTime,
    required this.points,
    required this.currentPoint,
  });
}

abstract class IHandyHspBase {
  ReadonlySignal<HspStateAdapter?> get hspStateAdapter;

  void hspSetup({int? streamId});
  void hspFlush();
  void hspAdd(
    List<FunscriptAction> points, {
    required bool flush,
    required int? tailPointStreamIndex,
    required int? tailPointThreshold,
  });
  void hspPlay({
    required int startTime,
    required double playbackRate,
    required bool loop,
    required bool pauseOnStarving,
  });
  void hspResume();
  void hspPause();
  void hspCurrentTimeSet({required int currentTime, required double filter});
  void hspStop();
  void hspLoop(bool loop);
}

mixin HandyNativeHspMixin on IHandyHspBase, ICommandBackendBase, PlayerBackend {
  final _currentlyBufferedBuffers = <int>{};
  int _syncCounter = 0;
  double _lastTime = 0.0;

  final _currentTimeThrottle = Throttler(milliseconds: 2000);
  final _actionsChangeDebounce = Debouncer(milliseconds: 300);
  final _bufferNotBufferedThrottle = Throttler(milliseconds: 200);
  final _loopChangeDebouncer = Debouncer(milliseconds: 200);

  List<Function()> addEffects() {
    return [
      effect(() {
        final homeMode = settingsModel.homeDeviceEnabled.value;
        untracked(() {
          if (homeMode) {
            hspStop(); // stop
            positionWithDuration(0.0, 500);
          } else {
            hspSetup(); // reset
            final paused = timesource.paused.value;

            if (!paused) {
              final actions = currentActions.value;
              if (actions == null) return;
              _bootstrapBuffer(actions);
            }
          }
        });
      }),
      effect(() {
        final paused = timesource.paused.value;
        if (!settingsModel.homeDeviceEnabled.value) {
          untracked(() => _playChange(paused));
        }
      }),
      effect(() {
        final rawTime = timesource.rawPosition.value;
        if (!settingsModel.homeDeviceEnabled.value) {
          untracked(() => _timeChange(rawTime));
        }
      }),
      effect(() {
        final actions = currentActions.value;
        if (!settingsModel.homeDeviceEnabled.value) {
          untracked(() => _actionChangeChange(actions));
        }
      }),
      effect(() {
        final state = hspStateAdapter.value;
        if (!settingsModel.homeDeviceEnabled.value) {
          untracked(() => _hspStateChange(state));
        }
      }),
      effect(() {
        final loop = timesource.loopFile.value;
        if (!settingsModel.homeDeviceEnabled.value) {
          untracked(() => _loopChanged(loop));
        }
      }),
    ];
  }

  void _loopChanged(bool loop) {
    if (hspStateAdapter.value?.playState ==
        HspStateAdapterPlayState.hspStatePlaying) {
      _loopChangeDebouncer.run(() {
        hspLoop(loop);
      });
    }
  }

  void _actionChangeChange(List<FunscriptAction>? actions) {
    _actionsChangeDebounce.run(() {
      hspSetup();
    });
  }

  void _timeChange(double timeSeconds) {
    final currentTimeMs = timesource.currentSmoothMs;
    final actions = currentActions.value;
    if (actions == null) return;

    final state = hspStateAdapter.value;
    if (state == null) return;
    final isPlaying = !timesource.paused.value;

    _currentTimeThrottle.run(
      () {
        if (state.playState == HspStateAdapterPlayState.hspStatePlaying) {
          if (isPlaying) {
            if (state.firstPointTime <= currentTimeMs &&
                state.lastPointTime > currentTimeMs) {
              hspCurrentTimeSet(
                currentTime:
                    timesource.currentSmoothMs + settingsModel.offsetMs.value,
                filter: _syncCounter < 2 ? 0.9 : 0.5,
              );
              _syncCounter += 1;
              debugPrint("SYNC COUNTER: $_syncCounter ${DateTime.now()}");
            }
          }
        }
      },
      throttleTime: _syncCounter < 2 ? (_syncCounter + 1) * 2000 : 10000,
      immediate: _syncCounter == 0,
    );

    _bufferNotBufferedThrottle.run(() {
      final currentBufferId =
          Funscript.getActionBefore(currentTimeMs, actions) ~/
          ActionBuffer.maxBufferSize;

      if (!_currentlyBufferedBuffers.contains(currentBufferId) ||
          _lastTime > timeSeconds) {
        Logger.debug("Handy stalled restarting...");
        hspSetup();

        final currentBuffer = ActionBuffer.fromActions(
          currentBufferId,
          actions,
        );
        final nextBuffer = ActionBuffer.fromActions(
          currentBufferId + 1,
          actions,
        );
        _bufferPoints([?currentBuffer, ?nextBuffer], flush: true);
      } else {
        // This works because it's not a Set<int> preserves insertion order
        //final lastBufferBufferedId = _currentlyBufferedBuffers.last;
        final maxBuffers = (actions.length / ActionBuffer.maxBufferSize).ceil();
        final nextBufferId = currentBufferId + 1 >= maxBuffers
            ? 0
            : currentBufferId + 1;

        if (!_currentlyBufferedBuffers.contains(nextBufferId)) {
          final buffer = ActionBuffer.fromActions(nextBufferId, actions);
          if (buffer != null) {
            debugPrint("EAGER BUFFER");
            _bufferPoints([buffer], flush: false);
          }
        }
      }
      _lastTime = timeSeconds;
    });
  }

  void _playChange(bool paused) {
    final state = hspStateAdapter.value;
    if (state == null) return;

    final playing = !paused;
    final actions = currentActions.value;
    if (actions == null) return;

    _lastTime = timesource.rawPosition.value;

    final handyPlaying =
        state.playState == HspStateAdapterPlayState.hspStatePlaying;
    final handyPaused =
        state.playState == HspStateAdapterPlayState.hspStatePaused ||
        state.playState == HspStateAdapterPlayState.hspStateStopped;
    if (playing && handyPaused) {
      // Start playing
      // 1. Get the current buffer send to to the handy
      // 2. Buffer the next buffer
      // 3. hspPlay is called when the hspState updates in _hspStateChange
      _bootstrapBuffer(actions);
    } else if (!playing && handyPlaying) {
      // Stop playing
      hspPause();
    } else {
      // Not sure if something needs to happen here
      // print(hspState.toDebugString());
    }
  }

  HspStateAdapterPlayState? _lastState;
  void _hspStateChange(HspStateAdapter? hspState) {
    if (hspState == null) return;

    final currentTimeMs = timesource.currentSmoothMs;
    final isPlaying = !timesource.paused.value;

    if (kDebugMode) {
      if (_lastState != hspState.playState) {
        debugPrint("hspStateChange: ${hspState.playState.toString()}");
      }
      _lastState = hspState.playState;
    }
    switch (hspState.playState) {
      case HspStateAdapterPlayState.hspStateNotInitialized:
        hspSetup(); // initialize
        break;
      case HspStateAdapterPlayState.hspStatePaused:
      case HspStateAdapterPlayState.hspStateStopped:
        if (isPlaying) {
          if (hspState.firstPointTime <= currentTimeMs &&
              hspState.lastPointTime > currentTimeMs) {
            hspPlay(
              startTime: currentTimeMs + settingsModel.offsetMs.value,
              playbackRate: timesource.playbackSpeed.value,
              loop: timesource.loopFile.value,
              pauseOnStarving: false,
            );
          }
          playbackDelta.value = 0;
        }
        break;
      case HspStateAdapterPlayState.hspStatePlaying:
        playbackDelta.value = currentTimeMs - hspState.currentTime;
        break;
      case HspStateAdapterPlayState.hspStateStarving:
        //Logger.debug("Handy HSP starved. Restarting...");
        //hspSetup(); // initialize
        debugPrint("STARVED");
        break;
    }
  }

  @override
  void hspSetup({int? streamId}) {
    _currentlyBufferedBuffers.clear();
    _syncCounter = 0;
    super.hspSetup(streamId: streamId);
  }

  // buffers are expected to be sorted by id ascending
  int? _bufferPoints(List<ActionBuffer> buffers, {required bool flush}) {
    if (flush) {
      _currentlyBufferedBuffers.clear();
      _syncCounter = 0;
    }
    if (buffers.isEmpty) {
      if (flush) hspFlush();
      return null;
    }
    // Merge buffers into one hspAdd
    final points = <FunscriptAction>[];
    var tailPointIndex = 0;
    var tailPointTreshold = 0;
    for (final buffer in buffers) {
      if (_currentlyBufferedBuffers.contains(buffer.id)) {
        continue;
      }
      _currentlyBufferedBuffers.add(buffer.id);
      points.addAll(buffer.toActions());
      tailPointIndex = buffer.tailPointIndex;
      tailPointTreshold = buffer.tailPointTreshold;
    }

    // If the buffer after the last one passed to this function is the last eagerly buffer it
    final remainingActions =
        buffers.last.allActions.length - buffers.last.tailPointIndex;
    if (remainingActions > 0 && remainingActions < ActionBuffer.maxBufferSize) {
      final lastBuffer = ActionBuffer.fromActions(
        buffers.last.id + 1,
        buffers.last.allActions,
      );
      if (lastBuffer != null) {
        _currentlyBufferedBuffers.add(lastBuffer.id);
        points.addAll(lastBuffer.toActions());
        tailPointIndex = lastBuffer.tailPointIndex;
        tailPointTreshold = lastBuffer.tailPointTreshold;
      }
    }

    // 100 is the limit but I want to keep messages small
    assert(points.length <= 50, "Too many points.");

    hspAdd(
      points,
      flush: flush,
      tailPointStreamIndex: tailPointIndex,
      tailPointThreshold: tailPointTreshold,
    );

    int startTime = points.first.at;
    int endTime = points.last.at;
    debugPrint(
      "Buffering ${((endTime - startTime) / 1000.0).toStringAsFixed(2)} seconds",
    );
    return endTime;
  }

  void _bootstrapBuffer(List<FunscriptAction> actions) {
    // 1. Get the current buffer send to to the handy
    // 2. Buffer the next buffer
    // 3. hspPlay is called when the hspState updates in _hspStateChange
    final bufferId =
        Funscript.getActionBefore(timesource.currentSmoothMs, actions) ~/
        ActionBuffer.maxBufferSize;
    final currentBuffer = ActionBuffer.fromActions(bufferId, actions);
    final nextBuffer = ActionBuffer.fromActions(bufferId + 1, actions);
    _bufferPoints([?currentBuffer, ?nextBuffer], flush: true);
  }

  void handleThresholdReached(bool starving) {
    debugPrint("Handy threshold reached. Starving: $starving");

    final actions = currentActions.value;
    if (actions == null) return;
    final hspState = hspStateAdapter.value;
    if (hspState == null) return;

    // we are here
    final currentPointIndex = hspState.currentPoint;

    // Get the next buffer and buffer it
    var bufferId =
        Funscript.getActionBefore(timesource.currentRawMs, actions) ~/
        ActionBuffer.maxBufferSize;
    while (_currentlyBufferedBuffers.contains(bufferId)) {
      bufferId += 1;
    }
    final actionBuffer = ActionBuffer.fromActions(bufferId, actions);
    if (actionBuffer != null) {
      final currentAt = hspState.currentTime;
      final lastAt = _bufferPoints([actionBuffer], flush: false);
      double runWay = (lastAt! - currentAt) / 1000.0;
      debugPrint(
        "Runway: ${runWay.toStringAsFixed(2)} seconds StateIndex: $currentPointIndex StateAt: $currentAt PlayerAt: ${timesource.currentRawMs}",
      );
    }
  }

  void handleLoop() {
    _syncCounter = 0;
  }
}
