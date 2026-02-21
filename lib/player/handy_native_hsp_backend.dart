import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/generated/constants.pb.dart';
import 'package:syncopathy/helper/debouncer.dart';
import 'package:syncopathy/helper/throttler.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/model/funscript.dart';
import 'package:syncopathy/player/handy_bluetooth_backend_base.dart';
import 'package:syncopathy/player/player_backend.dart';

class HandyNativeHspBackend extends HandyBluetoothBackendBase {
  final _bufferNotBufferedThrottle = Throttler(milliseconds: 100);
  final _currentTimeThrottle = Throttler(milliseconds: 1000);
  final _actionsChangeDebounce = Debouncer(milliseconds: 1000);

  HandyNativeHspBackend({
    required super.settingsModel,
    required super.batteryModel,
    required super.timesource,
    required super.currentFunscript,
  }) {
    effectAdd([
      effect(() {
        final homeMode = settingsModel.homeDeviceEnabled.value;
        print("Home Mode: $homeMode");
      }),
      // effect(() {
      //   final paused = timesource.paused.value;
      //   if (!settingsModel.homeDeviceEnabled.value) {
      //     untracked(() => _playChange(paused));
      //   }
      // }),
      // effect(() {
      //   final rawTime = timesource.rawPosition.value;
      //   if (!settingsModel.homeDeviceEnabled.value) {
      //     untracked(() => _timeChange(rawTime));
      //   }
      // }),
      // effect(() {
      //   final actions = currentActions.value;
      //   if (!settingsModel.homeDeviceEnabled.value) {
      //     untracked(() => _actionChangeChange(actions));
      //   }
      // }),
      timesource.paused.subscribe(_playChange),
      timesource.rawPosition.subscribe(_timeChange),
      currentActions.subscribe(_actionChangeChange),
    ]);
  }

  final _currentlyBufferedBuffers = <int>{};
  void _bufferPoints(ActionBuffer buffer, {required bool flush}) {
    if (flush) {
      _currentlyBufferedBuffers.clear();
    }
    if (_currentlyBufferedBuffers.contains(buffer.id)) {
      return;
    }
    final points = buffer.toPoints();
    handyBle?.hspAdd(
      points,
      flush: flush,
      tailPointStreamIndex: buffer.tailPointIndex,
      tailPointThreshold: buffer.tailPointTreshold,
    );
    _currentlyBufferedBuffers.add(buffer.id);
    debugPrint(
      "threshold: ${buffer.tailPointTreshold} tail: ${buffer.tailPointIndex}",
    );

    // If the buffer after the one passed to this function is the last
    // eagerly buffer it
    final remainingActions = buffer.allActions.length - buffer.tailPointIndex;
    if (remainingActions > 0 && remainingActions < ActionBuffer.maxBufferSize) {
      final lastBuffer = ActionBuffer.fromActions(
        buffer.id + 1,
        buffer.allActions,
      );
      if (lastBuffer != null) _bufferPoints(lastBuffer, flush: false);
      return;
    }
  }

  void _hspSetup() {
    handyBle?.hspSetup();
    _currentlyBufferedBuffers.clear();
  }

  void _actionChangeChange(List<FunscriptAction>? actions) {
    _actionsChangeDebounce.run(() {
      _hspSetup();
    });
  }

  void _timeChange(double timeSeconds_) {
    final currentTimeMs = timesource.currentSmoothMs;
    final actions = currentActions.value;
    if (actions == null) return;

    final hspState = handyBle?.hspState.value;
    if (hspState == null) return;
    final isPlaying = !timesource.paused.value;

    _currentTimeThrottle.run(() {
      if (hspState.playState == HspPlayState.HSP_STATE_PLAYING) {
        if (isPlaying) {
          if (hspState.firstPointTime <= currentTimeMs &&
              hspState.lastPointTime > currentTimeMs) {
            handyBle?.hspCurrentTimeSet(
              currentTime:
                  timesource.currentSmoothMs + settingsModel.offsetMs.value,
              forceCurrentTime: false,
            );
          }
        }
      }
    });

    _bufferNotBufferedThrottle.run(() {
      final currentBufferId =
          PlayerBackend.getActionIndex(currentTimeMs, actions) ~/
          ActionBuffer.maxBufferSize;

      if (!_currentlyBufferedBuffers.contains(currentBufferId)) {
        Logger.debug("Handy stalled restarting...");
        handyBle?.hspSetup();
        final buffer = ActionBuffer.fromActions(currentBufferId, actions);
        if (buffer != null) _bufferPoints(buffer, flush: true);
      }

      final maxBuffers = (actions.length / ActionBuffer.maxBufferSize).ceil();
      final nextBufferId = currentBufferId + 1 >= maxBuffers
          ? 0
          : currentBufferId + 1;
      if (!_currentlyBufferedBuffers.contains(nextBufferId)) {
        final buffer = ActionBuffer.fromActions(nextBufferId, actions);
        if (buffer != null) _bufferPoints(buffer, flush: false);
      }
    });
  }

  void _playChange(bool paused) {
    final hspState = handyBle?.hspState.value;
    if (hspState == null) return;

    final playing = !paused;
    final actions = currentActions.value;
    if (actions == null) return;

    final handyPlaying = hspState.playState == HspPlayState.HSP_STATE_PLAYING;
    final handyPaused =
        hspState.playState == HspPlayState.HSP_STATE_PAUSED ||
        hspState.playState == HspPlayState.HSP_STATE_STOPPED;
    if (playing && handyPaused) {
      // Start playing
      // 1. Get the current buffer send to to the handy
      // 2. Buffer the next buffer
      // 3. hspPlay is called when the hspState updates in _hspStateChange
      final bufferId =
          PlayerBackend.getActionIndex(timesource.currentSmoothMs, actions) ~/
          ActionBuffer.maxBufferSize;
      final currentBuffer = ActionBuffer.fromActions(bufferId, actions);
      if (currentBuffer != null) _bufferPoints(currentBuffer, flush: true);
      final nextBuffer = ActionBuffer.fromActions(bufferId + 1, actions);
      if (nextBuffer != null) _bufferPoints(nextBuffer, flush: false);
    } else if (!playing && handyPlaying) {
      // Stop playing
      handyBle?.hspPause();
    } else {
      // Not sure if something needs to happen here
      // print(hspState.toDebugString());
    }
  }

  HspPlayState? _lastState;
  void _hspStateChange(HspState? hspState) {
    final handy = handyBle;
    if (hspState == null || handy == null) return;

    final currentTimeMs = timesource.currentSmoothMs;
    final isPlaying = !timesource.paused.value;

    if (_lastState != hspState.playState) {
      debugPrint("hspStateChange: ${hspState.playState.toString()}");
    }
    _lastState = hspState.playState;
    switch (hspState.playState) {
      case HspPlayState.HSP_STATE_NOT_INITIALIZED:
        _hspSetup(); // initialize
        break;
      case HspPlayState.HSP_STATE_PAUSED:
      case HspPlayState.HSP_STATE_STOPPED:
        if (isPlaying) {
          if (hspState.firstPointTime <= currentTimeMs &&
              hspState.lastPointTime > currentTimeMs) {
            handyBle?.hspPlay(
              startTime: currentTimeMs + settingsModel.offsetMs.value,
              playbackRate: timesource.playbackSpeed.value,
              loop: true,
            );
          }
          playbackDelta.value = 0;
        }
        break;
      case HspPlayState.HSP_STATE_PLAYING:
        playbackDelta.value = currentTimeMs - hspState.currentTime;
        print(
          "$currentTimeMs - ${hspState.currentTime} = ${playbackDelta.value}",
        );
        //print(hspState.toDebugString());

        break;
      case HspPlayState.HSP_STATE_STARVING:
        Logger.debug("Handy HSP starved. Restarting...");
        _hspSetup(); // initialize
        break;
    }
  }

  void _handleThresholdReached(bool isStarving) {
    print("Threshold reached!!");

    final actions = currentActions.value;
    if (actions == null) return;

    final hspState = handyBle?.hspState.value;
    if (hspState == null) return;

    // Get the next buffer and buffer it
    var bufferId =
        PlayerBackend.getActionIndex(timesource.currentRawMs, actions) ~/
        ActionBuffer.maxBufferSize;
    while (_currentlyBufferedBuffers.contains(bufferId)) {
      bufferId += 1;
    }
    final actionBuffer = ActionBuffer.fromActions(bufferId, actions);
    if (actionBuffer != null) {
      _bufferPoints(actionBuffer, flush: false);
    }
  }

  @override
  Future<void> tryConnect() async {
    await super.tryConnect();
    handyBle?.hspSetup();
    handyBle?.hspThresholdReached = _handleThresholdReached;
    effectAdd([
      effect(() {
        final hspState = handyBle?.hspState.value;
        untracked(() => _hspStateChange(hspState));
      }),
    ]);
  }

  @override
  Future<void> dispose() async {
    await super.dispose();
    effectDispose();
  }
}
