import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/helper/debouncer.dart';
import 'package:syncopathy/helper/throttler.dart';
import 'package:syncopathy/generated/constants.pb.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/model/funscript.dart';
import 'package:syncopathy/model/json/funscript_json.dart';
import 'package:syncopathy/model/json/handyV3/handy_response.dart';
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

/// Snapshot of the device's HSP playback state.
///
/// Field semantics mirror `HspState` in `protos/constants.proto` (the source of
/// truth — see the block comment there). Read carefully: these fields are NOT
/// all sampled at the same instant, and some are internal bookkeeping rather
/// than exact playback facts. The snapshot is assembled field-by-field while
/// playback continues in the background, so individual fields may be from
/// slightly different instants. Use it as an approximate status indicator, not
/// as a source for exact-frame synchronization.
class HspStateAdapter {
  final HspStateAdapterPlayState playState;

  /// Time of the first point in the buffer. Describes the buffer contents, not
  /// the live playback position, and updates only when points are added or
  /// cleared. Source: `HspState.first_point_time` in `protos/constants.proto`.
  final int firstPointTime;

  /// Time of the last point in the buffer. Describes the buffer contents, not
  /// the live playback position, and updates only when points are added or
  /// cleared. Source: `HspState.last_point_time` in `protos/constants.proto`.
  final int lastPointTime;

  /// The live playback clock at the moment this message was generated. Advances
  /// continuously while playing. While paused it may continue to drift rather
  /// than freeze at the pause instant, so treat it as meaningful only while
  /// [playState] indicates active playback. Source: `HspState.current_time` in
  /// `protos/constants.proto`.
  final int currentTime;

  /// Number of points currently in the buffer. Source: `HspState.points` in
  /// `protos/constants.proto`.
  final int points;

  /// An internal index into the point buffer that tracks roughly where playback
  /// is. It does NOT move in lockstep with [currentTime] and is NOT guaranteed
  /// to be monotonic: it can jump forward when catching up, and step backward
  /// when playback is re-synced to the server clock or resumed. It also reflects
  /// internal scheduling, not necessarily the device's physical position (the
  /// actuator can lag), so the real position may trail what this suggests. Treat
  /// it as an approximate position marker, not as an exact or ever-increasing
  /// count of points reached, and do NOT assume it corresponds to [currentTime]
  /// — if you need the point the clock is currently between, compute it yourself
  /// from [currentTime] and the point list. Source: `HspState.current_point` in
  /// `protos/constants.proto`.
  final int currentPoint;

  final bool pauseOnStarving;

  /// Max number of points the buffer can hold; depends on the device. Source:
  /// `HspState.max_points` in `protos/constants.proto`.
  final int maxPoints;

  /// True if the buffer is looping after the last point. Source:
  /// `HspState.loop` in `protos/constants.proto`.
  final bool loop;

  /// The current playback rate. Source: `HspState.playback_rate` in
  /// `protos/constants.proto`.
  final double playbackRate;

  /// The stream id of the current stream. Source: `HspState.stream_id` in
  /// `protos/constants.proto`.
  final int streamId;

  /// The current point playing; -1 when playing an absolute index. Source:
  /// `HspState.tail_point_stream_index` in `protos/constants.proto`.
  final int tailPointStreamIndex;

  /// When to trigger a threshold notification. Source:
  /// `HspState.tail_point_stream_index_threshold` in `protos/constants.proto`.
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

  /// Builds an adapter from the native BLE/HDSP protobuf [HspState].
  factory HspStateAdapter.fromNativeState(HspState state) {
    final playState = switch (state.playState) {
      HspPlayState.HSP_STATE_NOT_INITIALIZED =>
        HspStateAdapterPlayState.hspStateNotInitialized,
      HspPlayState.HSP_STATE_PAUSED => HspStateAdapterPlayState.hspStatePaused,
      HspPlayState.HSP_STATE_PLAYING =>
        HspStateAdapterPlayState.hspStatePlaying,
      HspPlayState.HSP_STATE_STARVING =>
        HspStateAdapterPlayState.hspStateStarving,
      HspPlayState.HSP_STATE_STOPPED =>
        HspStateAdapterPlayState.hspStateStopped,
      _ => throw UnimplementedError("Unknown playState"),
    };
    return HspStateAdapter(
      playState: playState,
      firstPointTime: state.firstPointTime,
      lastPointTime: state.lastPointTime,
      currentTime: state.currentTime,
      points: state.points,
      currentPoint: state.currentPoint,
      loop: state.loop,
      maxPoints: state.maxPoints,
      pauseOnStarving: state.pauseOnStarving,
      playbackRate: state.playbackRate,
      streamId: state.streamId,
      tailPointStreamIndex: state.tailPointStreamIndex,
      tailPointStreamIndexThreshold: state.tailPointStreamIndexThreshold,
    );
  }

  /// Builds an adapter from the Handy Web API's [HandyHspState] JSON model,
  /// whose [HandyHspState.playState] is an integer code rather than an enum.
  factory HspStateAdapter.fromWebState(HandyHspState state) {
    final playState = switch (state.playState) {
      0 => HspStateAdapterPlayState.hspStateNotInitialized,
      1 => HspStateAdapterPlayState.hspStatePlaying,
      2 => HspStateAdapterPlayState.hspStateStopped,
      3 => HspStateAdapterPlayState.hspStatePaused,
      4 => HspStateAdapterPlayState.hspStateStarving,
      _ => throw UnimplementedError("Unknown playState"),
    };
    return HspStateAdapter(
      playState: playState,
      firstPointTime: state.firstPointTime,
      lastPointTime: state.lastPointTime,
      currentTime: state.currentTime,
      points: state.points,
      currentPoint: state.currentPoint,
      loop: state.loop,
      maxPoints: state.maxPoints,
      pauseOnStarving: state.pauseOnStarving,
      playbackRate: state.playbackRate,
      streamId: state.streamId,
      tailPointStreamIndex: state.tailPointStreamIndex,
      tailPointStreamIndexThreshold: state.tailPointStreamIndexThreshold,
    );
  }

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

/// The HSP stream commands a device transport (BLE or Web) exposes. Both
/// `HandyBle` and `HandyWeb` implement this so the two backend bases can share a
/// single set of forwarders via [HandyHspCommandDelegation].
abstract interface class IHspCommands {
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
  void positionWithDuration(double relPos, int moveOverTimeMs);
}

abstract class IHandyHspBase implements IHspCommands {
  ReadonlySignal<HspStateAdapter?> get hspStateAdapter;
}

/// Forwards every [IHspCommands] call to [hspCommandTarget] — the live transport,
/// or null when disconnected. Both backend bases mix this in so they don't each
/// hand-write the same ten one-line forwarders; they only supply the target.
mixin HandyHspCommandDelegation implements IHspCommands {
  IHspCommands? get hspCommandTarget;

  @override
  void hspSetup({int? streamId}) =>
      hspCommandTarget?.hspSetup(streamId: streamId);

  @override
  void hspFlush() => hspCommandTarget?.hspFlush();

  @override
  void hspAdd(
    List<FunscriptAction> points, {
    required bool flush,
    required int? tailPointStreamIndex,
    required int? tailPointThreshold,
  }) => hspCommandTarget?.hspAdd(
    points,
    flush: flush,
    tailPointStreamIndex: tailPointStreamIndex,
    tailPointThreshold: tailPointThreshold,
  );

  @override
  void hspPlay({
    required int startTime,
    required double playbackRate,
    required bool loop,
    required bool pauseOnStarving,
  }) => hspCommandTarget?.hspPlay(
    startTime: startTime,
    playbackRate: playbackRate,
    loop: loop,
    pauseOnStarving: pauseOnStarving,
  );

  @override
  void hspResume() => hspCommandTarget?.hspResume();

  @override
  void hspPause() => hspCommandTarget?.hspPause();

  @override
  void hspCurrentTimeSet({required int currentTime, required double filter}) =>
      hspCommandTarget?.hspCurrentTimeSet(
        currentTime: currentTime,
        filter: filter,
      );

  @override
  void hspStop() => hspCommandTarget?.hspStop();

  @override
  void hspLoop(bool loop) => hspCommandTarget?.hspLoop(loop);

  @override
  void positionWithDuration(double relPos, int moveOverTimeMs) =>
      hspCommandTarget?.positionWithDuration(relPos, moveOverTimeMs);
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
        final _ = currentActions.value;
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

    _reconcileInternalPlayingState(hspState);

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

  /// Fallback that nudges [_internalHandyPlaying] back toward what the device
  /// actually reports, on a 200ms debounce, whenever the two disagree. Ideally
  /// this never fires; it guards against our optimistic local flag drifting from
  /// the device's real play state.
  void _reconcileInternalPlayingState(HspStateAdapter hspState) {
    final devicePlaying = switch (hspState.playState) {
      HspStateAdapterPlayState.hspStateNotInitialized => false,
      HspStateAdapterPlayState.hspStatePlaying => true,
      HspStateAdapterPlayState.hspStateStopped => false,
      HspStateAdapterPlayState.hspStatePaused => false,
      // I think it only turns starving when pauseWhenStarving is turned on
      HspStateAdapterPlayState.hspStateStarving => false,
    };
    if (devicePlaying == _internalHandyPlaying) return;

    if (kDebugMode) {
      debugPrint(
        "playingDevice: $devicePlaying internalPlayState: $_internalHandyPlaying",
      );
    }
    _internalHandyPlayStateDebouncer.run(() {
      if (_internalHandyPlaying != devicePlaying) {
        if (kDebugMode) {
          debugPrint("DEBOUNCER SET _internalHandyPlaying=$devicePlaying");
        }
        // Ideally this case never happens
        _internalHandyPlaying = devicePlaying;
        _hspStateChange(hspState);
      }
    });
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
      _cancelSyncTimer();
      return;
    }

    final actions = currentActions.value;

    // Re-bootstrap if the script itself changed under us.
    if (_bufferedActionsReference != actions) {
      _resetPlayback(actions);
    }
    if (actions == null) return;

    final isPlaying = !timesource.paused.value;
    final currentTime = timesource.currentRawMs;

    if (isPlaying) {
      _maintainBuffer(state, actions, currentTime);
      _scheduleClockSync();
    } else {
      _cancelSyncTimer();
    }
  }

  /// Keeps the device buffer fed while playing. Bootstraps from scratch when
  /// nothing is buffered; re-bootstraps on a stall (the playhead has fallen
  /// outside the buffered window); otherwise eagerly buffers the next chunk.
  void _maintainBuffer(
    HspStateAdapter state,
    List<FunscriptAction> actions,
    int currentTime,
  ) {
    if (_internalActionBuffer.isEmpty) {
      hspSetup();
      _bootstrapBuffer(actions);
      return;
    }

    final expectedFirstTime = _internalActionBuffer.firstAt;
    final expectedLastTime = _internalActionBuffer.lastAt;
    final playheadOutsideBuffer =
        currentTime < expectedFirstTime || currentTime > expectedLastTime;

    if (playheadOutsideBuffer) {
      if (state.points > 0) {
        if (kDebugMode) {
          debugPrint(
            "STALL currentTime: $currentTime expectedFirstTime: $expectedFirstTime expectedLastTime: $expectedLastTime",
          );
        }
        _resetPlayback(actions);
      }
      return;
    }

    _eagerBufferThrottle.run(
      () => _eagerBufferAhead(state, actions, currentTime),
    );
  }

  /// Buffers the next [ActionBuffer] ahead of the playhead, unless the device is
  /// near its point ceiling or we already have [_eagerBufferLimitMs] buffered.
  void _eagerBufferAhead(
    HspStateAdapter state,
    List<FunscriptAction> actions,
    int currentTime,
  ) {
    if (_internalActionBuffer.isEmpty) return;
    if (kDebugMode) debugPrint("EAGER BUFFER");
    final bufferId = _internalActionBuffer.lastBufferId + 1;
    final actionBuffer = ActionBuffer.fromActions(bufferId, actions);
    if (actionBuffer == null) return;

    final bufferLength = actionBuffer.bufferLength;
    if (_exceedsSoftPointLimit(state, bufferLength)) {
      // soft limit reached — stop buffering
      return;
    }

    final delta = _internalActionBuffer.lastAt - currentTime;
    if (delta >= _eagerBufferLimitMs) {
      // already have _eagerBufferLimitMs of actions buffered
      return;
    }

    _bufferPoints([actionBuffer], flush: false);
  }

  /// Arms the self-rescheduling timer that keeps the device clock in sync: one
  /// hard sync (filter 0.9) then progressively softer ones (0.5), backing off
  /// from 1s toward 10s between attempts. No-op if a timer is already armed.
  void _scheduleClockSync() {
    _syncTimer ??= Timer(
      Duration(seconds: _syncCounter < 3 ? _syncCounter + 1 : 10),
      () {
        try {
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
        } finally {
          _syncTimer = null;
        }
      },
    );
  }

  void _cancelSyncTimer() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }

  // The device's hard point ceiling is maxPoints; buffering stops a little below
  // it, rounded down to a multiple of this, to keep headroom.
  static const int _softPointLimitGranularity = 100;

  /// Whether adding [additionalPoints] would push the device past its soft point
  /// ceiling (maxPoints rounded down to [_softPointLimitGranularity]).
  bool _exceedsSoftPointLimit(HspStateAdapter state, int additionalPoints) {
    final softMaxPoints =
        (state.maxPoints ~/ _softPointLimitGranularity) *
        _softPointLimitGranularity;
    return state.points + additionalPoints > softMaxPoints;
  }

  void _resetPlayback(List<FunscriptAction>? actions) {
    if (actions != null) {
      Logger.debug("Handy stalled restarting...");
      hspSetup();
      _bootstrapBuffer(actions);
    } else {
      hspStop();
      hspFlush();
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
    var tailPointThreshold = 0;
    for (final buffer in buffers) {
      if (_internalActionBuffer.containsBuffer(buffer.id)) {
        continue;
      }
      _internalActionBuffer.addToBuffer(buffer);
      final bufferActions = buffer.toActions();
      points.addAll(bufferActions);
      tailPointIndex = buffer.tailPointIndex;
      tailPointThreshold = buffer.tailPointThreshold;
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
        tailPointThreshold = lastBuffer.tailPointThreshold;
      }
    }

    // 100 is the limit but I want to keep messages small
    assert(points.length <= 80, "Too many points.");

    if (points.isNotEmpty) {
      hspAdd(
        points,
        flush: flush,
        tailPointStreamIndex: tailPointIndex,
        tailPointThreshold: tailPointThreshold,
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
      if (_exceedsSoftPointLimit(hspState, bufferLength)) {
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
