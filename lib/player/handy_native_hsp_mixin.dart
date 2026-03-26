import 'dart:async';
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
  hspStateStarving;

  @override
  String toString() {
    return switch (this) {
      HspStateAdapterPlayState.hspStateNotInitialized => 'NotInitialized',
      HspStateAdapterPlayState.hspStatePlaying => 'Playing',
      HspStateAdapterPlayState.hspStateStopped => 'Stopped',
      HspStateAdapterPlayState.hspStatePaused => 'Paused',
      HspStateAdapterPlayState.hspStateStarving => 'Starving',
    };
  }
}

class HspStateAdapter {
  final HspStateAdapterPlayState playState;
  final int firstPointTime;
  final int lastPointTime;
  final int currentTime;
  final int points;
  final int currentPoint;
  final bool pauseOnStarving;
  final int maxPoints;
  final bool loop;
  final double playbackRate;
  final int streamId;
  final int tailPointStreamIndex;
  final int tailPointStreamIndexThreshold;

  HspStateAdapter({
    required this.playState,
    required this.firstPointTime,
    required this.lastPointTime,
    required this.currentTime,
    required this.points,
    required this.currentPoint,
    required this.pauseOnStarving,
    required this.maxPoints,
    required this.loop,
    required this.playbackRate,
    required this.streamId,
    required this.tailPointStreamIndex,
    required this.tailPointStreamIndexThreshold,
  });

  @override
  String toString() {
    return 'playState: $playState\n'
        'firstPointTime: $firstPointTime\n'
        'lastPointTime: $lastPointTime\n'
        'currentTime: $currentTime\n'
        'points: $points\n'
        'currentPoint: $currentPoint\n'
        'pauseOnStarving: $pauseOnStarving\n'
        'maxPoints: $maxPoints\n'
        'loop: $loop\n'
        'playbackRate: $playbackRate\n'
        'streamId: $streamId\n'
        'tailPointStreamIndex: $tailPointStreamIndex\n'
        'tailPointStreamIndexThreshold: $tailPointStreamIndexThreshold\n';
  }
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

// A helper class to track the on device buffer and determine which actions are
// evicted if the maximum is reached
class InternalActionBuffer {
  final _currentlyBufferedBuffers = <int>{};
  final _currentlyBufferedActions = <FunscriptAction>[];

  bool get isEmpty => _currentlyBufferedActions.isEmpty;
  bool get isNotEmpty => _currentlyBufferedActions.isNotEmpty;

  int get firstAt => _currentlyBufferedActions.first.at;
  int get lastAt => _currentlyBufferedActions.last.at;
  int get lastBufferId => _currentlyBufferedBuffers.last;

  int maxPoints = 0;

  List<FunscriptAction>? limitCheck(ActionBuffer buffer) {
    final bufferLength = buffer.endIndex - buffer.startIndex;
    if (_currentlyBufferedActions.length + bufferLength > maxPoints) {
      final delta =
          (_currentlyBufferedActions.length + bufferLength) - maxPoints;
      if (_currentlyBufferedActions.length >= delta) {
        return _currentlyBufferedActions.sublist(0, delta);
      }
    }
    return null;
  }

  void addToBuffer(ActionBuffer buffer) {
    _currentlyBufferedBuffers.add(buffer.id);

    final bufferActions = buffer.toActions();
    if (_currentlyBufferedActions.length + bufferActions.length > maxPoints) {
      final delta =
          (_currentlyBufferedActions.length + bufferActions.length) - maxPoints;
      if (_currentlyBufferedActions.length >= delta) {
        _currentlyBufferedActions.removeRange(0, delta);
      }
    }
    _currentlyBufferedActions.addAll(bufferActions);
  }

  void reset() {
    _currentlyBufferedBuffers.clear();
    _currentlyBufferedActions.clear();
  }

  bool containsBuffer(int id) {
    return _currentlyBufferedBuffers.contains(id);
  }
}

mixin HandyNativeHspMixin on IHandyHspBase, ICommandBackendBase, PlayerBackend {
  final _internalActionBuffer = InternalActionBuffer();
  bool _internalHandyPlaying = false;
  final _internalHandyPlayStateDebouncer = Debouncer(milliseconds: 200);
  final _eagerBufferThrottle = Throttler(milliseconds: 1000);

  // eager buffer limit 30 seconds
  static const int _eagerBufferLimitMs = 30000;

  // a reference to check if the actions have changed
  Object? _bufferedActionsReference;
  int _syncCounter = 0;
  Timer? _syncTimer;

  // for predictability I'm counting stream IDs up instead of random ones
  int _currentStreamId = 0;
  int get _nextStreamId => _currentStreamId + 1;

  final _loopChangeDebouncer = Debouncer(milliseconds: 200);

  List<Function()> addEffects() {
    return [
      effect(() {
        final isConnected = connected.value;
        final homeMode = settingsModel.homeDeviceEnabled.value;
        if (!isConnected) return;
        untracked(() {
          if (homeMode) {
            hspStop(); // stop
            positionWithDuration(settingsModel.invert.value ? 1.0 : 0.0, 500);
          } else {
            _resetPlayback(currentActions.value);
          }
        });
      }),
      effect(() {
        final isConnected = connected.value;
        final rawTime = timesource.rawPosition.value;
        final homeMode = settingsModel.homeDeviceEnabled.value;
        if (!isConnected) return;
        if (!homeMode) {
          untracked(() => _timeChange(rawTime));
        }
      }),
      effect(() {
        final isConnected = connected.value;
        final state = hspStateAdapter.value;
        final _ = timesource.paused.value;
        final homeMode = settingsModel.homeDeviceEnabled.value;
        _internalActionBuffer.maxPoints = state?.maxPoints ?? 0;
        if (!isConnected) return;
        if (!homeMode) {
          untracked(() => _hspStateChange(state));
        }
      }),
      effect(() {
        final loop = timesource.loopFile.value;
        final homeMode = settingsModel.homeDeviceEnabled.value;
        if (!homeMode) {
          untracked(() => _loopChanged(loop));
        }
      }),
      effect(() {
        final isSeeking = timesource.seeking.value;
        final homeMode = settingsModel.homeDeviceEnabled.value;
        if (!homeMode) {
          untracked(() => _seeking(isSeeking));
        }
      }),
    ];
  }

  @override
  void hspPlay({
    required int startTime,
    required double playbackRate,
    required bool loop,
    required bool pauseOnStarving,
  }) {
    if (_internalHandyPlaying) {
      if (kDebugMode) {
        debugPrint("hspPlay INTERNAL STATE IS: $_internalHandyPlaying");
      }
      return;
    }
    _internalHandyPlaying = true;
    super.hspPlay(
      startTime: startTime,
      playbackRate: playbackRate,
      loop: loop,
      pauseOnStarving: pauseOnStarving,
    );
  }

  @override
  void hspStop() {
    if (!_internalHandyPlaying) {
      if (kDebugMode) {
        debugPrint("hspStop INTERNAL STATE IS: $_internalHandyPlaying");
      }
      return;
    }
    _internalHandyPlaying = false;
    super.hspStop();
  }

  @override
  void hspPause() {
    if (!_internalHandyPlaying) {
      if (kDebugMode) {
        debugPrint("hspPause INTERNAL STATE IS: $_internalHandyPlaying");
      }
      return;
    }
    _internalHandyPlaying = false;
    super.hspPause();
  }

  HspStateAdapterPlayState? _lastState;
  void _hspStateChange(HspStateAdapter? hspState) {
    if (hspState == null) return;
    final playerPlaying = !timesource.paused.value;

    {
      // fallback mechanism to set the internalHandyPlaying state from the hspState with a 200ms debouncer
      final currentPlayStateAccordingToDevice = switch (hspState.playState) {
        HspStateAdapterPlayState.hspStateNotInitialized => false,
        HspStateAdapterPlayState.hspStatePlaying => true,
        HspStateAdapterPlayState.hspStateStopped => false,
        HspStateAdapterPlayState.hspStatePaused => false,
        // I think it only turns starving when pauseWhenStarving is turned on
        HspStateAdapterPlayState.hspStateStarving => false,
      };
      if (currentPlayStateAccordingToDevice != _internalHandyPlaying) {
        if (kDebugMode) {
          debugPrint(
            "playingDevice: $currentPlayStateAccordingToDevice internalPlayState: $_internalHandyPlaying",
          );
        }
        _internalHandyPlayStateDebouncer.run(() {
          if (_internalHandyPlaying != currentPlayStateAccordingToDevice) {
            if (kDebugMode) {
              debugPrint(
                "DEBOUNCER SET _internalHandyPlaying=$currentPlayStateAccordingToDevice",
              );
            }
            // Ideally this case never happens
            _internalHandyPlaying = currentPlayStateAccordingToDevice;
            _hspStateChange(hspState);
          }
        });
      }
    }

    if (kDebugMode) {
      if (_lastState != hspState.playState) {
        debugPrint("hspStateChange: ${hspState.playState.toString()}");
      }
      _lastState = hspState.playState;
    }

    if (hspState.streamId != _currentStreamId) {
      // Ignore old states from old streams
      return;
    }

    final currentTimeMs = timesource.currentRawMs;

    switch (hspState.playState) {
      case HspStateAdapterPlayState.hspStateNotInitialized:
        hspSetup(); // initialize
        break;
      case HspStateAdapterPlayState.hspStatePaused:
      case HspStateAdapterPlayState.hspStateStopped:
        if (playerPlaying) {
          if (currentTimeMs > hspState.firstPointTime &&
              currentTimeMs < hspState.lastPointTime) {
            hspPlay(
              startTime: currentTimeMs + settingsModel.offsetMs.value,
              playbackRate: timesource.playbackSpeed.value,
              loop: timesource.loopFile.value,
              pauseOnStarving: false,
            );
          } else if (hspState.points > 0) {
            // This is an edge case where we have to reset
            final actions = currentActions.value;
            if (actions != null) _resetPlayback(actions);
          }
        }
        debugPlaybackDelta.value = 0;
        break;
      case HspStateAdapterPlayState.hspStatePlaying:
        if (!playerPlaying) {
          hspPause();
        }
        debugPlaybackDelta.value =
            timesource.currentSmoothMs - hspState.currentTime;
        break;
      case HspStateAdapterPlayState.hspStateStarving:
        debugPrint("STARVED");
        break;
    }
  }

  void _seeking(bool isSeeking) {
    final currentTime = timesource.currentRawMs;
    final state = hspStateAdapter.value;
    if (state == null) return;

    final isLoop = currentTime < 33;
    if (isLoop) return;

    if (kDebugMode) debugPrint("Seek: $isSeeking Time: $currentTime");

    // This only handles seeking in the buffered interval
    // Outside of the buffered interval _timeChange triggers a stall
    if (currentTime >= state.firstPointTime &&
        currentTime <= state.lastPointTime) {
      if (!isSeeking) {
        _syncCounter = 0;
        hspPause();
        if (kDebugMode) debugPrint("Seek paused");
      } else {
        // playback should automatically resume in _hspStateChange
      }
    }
  }

  void _timeChange(double timeSecondsRaw) {
    final state = hspStateAdapter.value;
    if (state == null) return;
    if (_currentStreamId != state.streamId) {
      _syncTimer?.cancel();
      _syncTimer = null;
      return;
    }

    final actions = currentActions.value;

    // Check if actions have changed
    if (_bufferedActionsReference != null &&
        _bufferedActionsReference != actions) {
      _resetPlayback(actions);
    } else if (actions == null) {
      // actions is null ?? hspFlush or hspSetup?
    }
    if (actions == null) return;

    final isPlaying = !timesource.paused.value;
    final currentTime = timesource.currentRawMs;

    if (isPlaying) {
      if (_internalActionBuffer.isNotEmpty) {
        final expectedFirstTime = _internalActionBuffer.firstAt;
        final expectedLastTime = _internalActionBuffer.lastAt;
        if (currentTime < expectedFirstTime || currentTime > expectedLastTime) {
          if (state.points > 0) {
            if (kDebugMode) {
              debugPrint(
                "STALL currentTime: $currentTime expectedFirstTime: $expectedFirstTime expectedLastTime: $expectedLastTime",
              );
            }
            _resetPlayback(actions);
          }
        } else {
          _eagerBufferThrottle.run(() {
            if (_internalActionBuffer.isEmpty) return;
            if (kDebugMode) debugPrint("EAGER BUFFER");
            final bufferId = _internalActionBuffer.lastBufferId + 1;
            final actionBuffer = ActionBuffer.fromActions(bufferId, actions);

            if (actionBuffer != null) {
              final bufferLength = actionBuffer.bufferLength;
              final softMaxPoints = (state.maxPoints ~/ 100) * 100;
              if (state.points + bufferLength > softMaxPoints) {
                // stop buffering soft limit is reached
                return;
              }

              final delta = _internalActionBuffer.lastAt - currentTime;
              if (delta >= _eagerBufferLimitMs) {
                // stop buffering
                // there's already _eagerBufferLimitMs milliseconds of actions buffered
                return;
              }

              // finally buffer the points no issues were found
              _bufferPoints([actionBuffer], flush: false);
            }
          });
        }
      } else {
        hspSetup();
        _bootstrapBuffer(actions);
      }
    }

    if (isPlaying) {
      _syncTimer ??= Timer(
        Duration(seconds: _syncCounter < 3 ? _syncCounter + 1 : 10),
        () {
          try {
            if (isPlaying) {
              final currentTimeMs =
                  timesource.currentSmoothMs + settingsModel.offsetMs.value;
              final state = hspStateAdapter.value;
              if (state == null) return;
              final handyPlaying =
                  state.playState == HspStateAdapterPlayState.hspStatePlaying;
              if (!handyPlaying) return;

              if (currentTimeMs >= state.firstPointTime &&
                  currentTimeMs <= state.lastPointTime) {
                hspCurrentTimeSet(
                  currentTime: currentTimeMs,
                  // one hard sync 0.9 followed by soft syncs 0.5
                  filter: _syncCounter < 1 ? 0.9 : 0.5,
                );
                if (kDebugMode) {
                  debugPrint(
                    "SYNC COUNTER: $_syncCounter hard:${_syncCounter < 1} ${currentTimeMs}ms",
                  );
                }
                _syncCounter += 1;
              }
            }
          } finally {
            _syncTimer = null;
          }
        },
      );
    } else {
      _syncTimer?.cancel();
      _syncTimer = null;
    }
  }

  void _resetPlayback(List<FunscriptAction>? actions) {
    Logger.debug("Handy stalled restarting...");
    hspSetup();
    if (actions != null) {
      _bootstrapBuffer(actions);
    } else {
      hspStop();
    }
  }

  void _loopChanged(bool loop) {
    if (hspStateAdapter.value?.playState ==
        HspStateAdapterPlayState.hspStatePlaying) {
      _loopChangeDebouncer.run(() {
        hspLoop(loop);
      });
    }
  }

  @override
  void hspSetup({int? streamId}) {
    _resetInternalState(false);
    _currentStreamId = _nextStreamId;
    super.hspSetup(streamId: _currentStreamId);
  }

  void _resetInternalState(bool flush) {
    _internalActionBuffer.reset();
    if (!flush) _internalHandyPlaying = false;
    _bufferedActionsReference = null;
    _syncTimer?.cancel();
    _syncTimer = null;
    _syncCounter = 0;
    debugPlaybackDelta.value = 0;
  }

  @override
  void hspFlush() {
    _resetInternalState(true);
    super.hspFlush();
  }

  // buffers are expected to be sorted by id ascending
  void _bufferPoints(List<ActionBuffer> buffers, {required bool flush}) {
    if (flush) {
      _resetInternalState(true);
      // hardware flush is happening with the hspAdd command
    }
    assert(buffers.isNotEmpty);

    // Merge buffers into one hspAdd
    final points = <FunscriptAction>[];
    var tailPointIndex = 0;
    var tailPointTreshold = 0;
    for (final buffer in buffers) {
      if (_internalActionBuffer.containsBuffer(buffer.id)) {
        continue;
      }
      _internalActionBuffer.addToBuffer(buffer);
      final bufferActions = buffer.toActions();
      points.addAll(bufferActions);
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
        _internalActionBuffer.addToBuffer(lastBuffer);
        points.addAll(lastBuffer.toActions());
        tailPointIndex = lastBuffer.tailPointIndex;
        tailPointTreshold = lastBuffer.tailPointTreshold;
      }
    }

    // 100 is the limit but I want to keep messages small
    assert(points.length <= 80, "Too many points.");

    if (points.isNotEmpty) {
      hspAdd(
        points,
        flush: flush,
        tailPointStreamIndex: tailPointIndex,
        tailPointThreshold: tailPointTreshold,
      );

      int startTime = points.first.at;
      int endTime = points.last.at;
      if (kDebugMode) {
        debugPrint(
          "Buffering ${((endTime - startTime) / 1000.0).toStringAsFixed(2)} seconds",
        );
      }
    }
  }

  void _bootstrapBuffer(List<FunscriptAction> actions) {
    final bufferId =
        Funscript.getActionBefore(timesource.currentRawMs, actions) ~/
        ActionBuffer.maxBufferSize;
    final previousBuffer = ActionBuffer.fromActions(bufferId - 1, actions);
    final currentBuffer = ActionBuffer.fromActions(bufferId, actions);
    final nextBuffer = ActionBuffer.fromActions(bufferId + 1, actions);
    _bufferPoints([?previousBuffer, ?currentBuffer, ?nextBuffer], flush: true);
    _bufferedActionsReference = actions;
  }

  void handleThresholdReached(bool starving) {
    if (kDebugMode) debugPrint("Handy threshold reached. Starving: $starving");

    final actions = currentActions.value;
    if (actions == null) return;
    final hspState = hspStateAdapter.value;
    if (hspState == null) return;

    // Get the next buffer and buffer it
    var bufferId =
        Funscript.getActionBefore(timesource.currentRawMs, actions) ~/
        ActionBuffer.maxBufferSize;
    while (_internalActionBuffer.containsBuffer(bufferId)) {
      bufferId += 1;
    }
    final actionBuffer = ActionBuffer.fromActions(bufferId, actions);
    if (actionBuffer != null) {
      final bufferLength = actionBuffer.bufferLength;
      final softMaxPoints = (hspState.maxPoints ~/ 100) * 100;
      if (hspState.points + bufferLength > softMaxPoints) {
        // when the soft limit is reached we pause and flush the buffer
        hspPause();
        _bootstrapBuffer(actions);
      } else {
        _bufferPoints([actionBuffer], flush: false);
      }
    }
  }

  void handleLoop() {
    _syncCounter = 0;
  }
}
