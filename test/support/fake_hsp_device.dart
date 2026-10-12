import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:signals/signals.dart';
import 'package:syncopathy/model/battery_model.dart';
import 'package:syncopathy/model/json/funscript_json.dart';
import 'package:syncopathy/player/handy_native_hsp_mixin.dart';
import 'package:syncopathy/player/player_backend.dart';
import 'package:syncopathy/player/player_backend_type.dart';

/// A Handy in HSP mode as the BLE transport sees it.
///
/// Commands are applied strictly in the order they were sent, each after its own
/// latency, and every one answers with the device state *after* applying it —
/// the same shape `HandyBle._resultHandler` feeds into `hspState`. That ordering
/// is what makes the stream-id races reproducible: a setup sent now is answered
/// only after every command sent before it, each answer still naming the old
/// stream.
class FakeHspDevice implements IHspCommands {
  FakeHspDevice({
    required this.random,
    this.minLatencyMs = 20,
    this.maxLatencyMs = 150,
  });

  final Random random;
  final int minLatencyMs;
  final int maxLatencyMs;

  /// What the backend reads as `hspStateAdapter`.
  final Signal<HspStateAdapter?> reported = signal(null);

  int streamId = 0;
  HspStateAdapterPlayState playState =
      HspStateAdapterPlayState.hspStateNotInitialized;
  final List<FunscriptAction> points = [];
  int currentTime = 0;
  final int maxPoints = 4000;

  final List<String> log = [];
  final List<_Pending> _inFlight = [];
  int _nowMs = 0;
  int _lastDeliveryAt = 0;
  int _nextNotificationAt = 0;

  /// What `HandyBle.hspThresholdReached` is wired to.
  void Function(bool starving)? onThresholdReached;

  /// Stream ids of every setup the app has sent, in order.
  final List<int> setupsSent = [];

  void _send(String name, void Function() apply, {bool reports = true}) {
    // BLE writes are ordered, so a command never overtakes an earlier one.
    final latency =
        minLatencyMs + random.nextInt(maxLatencyMs - minLatencyMs + 1);
    final due = max(_nowMs + latency, _lastDeliveryAt);
    _lastDeliveryAt = due;
    _inFlight.add(_Pending(due, name, apply, reports: reports));
    log.add('$_nowMs  -> $name');
  }

  /// Advances device time to [nowMs], applying and answering whatever is due.
  void advanceTo(int nowMs) {
    final elapsed = nowMs - _nowMs;
    _nowMs = nowMs;
    if (playState == HspStateAdapterPlayState.hspStatePlaying) {
      currentTime += elapsed;
    }
    while (_inFlight.isNotEmpty && _inFlight.first.dueMs <= nowMs) {
      final cmd = _inFlight.removeAt(0);
      final before = playState;
      cmd.apply();
      if (!cmd.reports) {
        log.add(
          '$nowMs  applied ${cmd.name}  [stream $streamId $playState points ${points.length}]',
        );
        continue;
      }
      _report('<- ${cmd.name}');
      // The firmware also announces a play-state change on its own.
      if (playState != before) _report('<~ stateChanged');
    }
    // A playing device keeps notifying (threshold reached etc.), stamped with
    // whatever stream it is on.
    if (playState == HspStateAdapterPlayState.hspStatePlaying &&
        nowMs >= _nextNotificationAt) {
      _nextNotificationAt = nowMs + 500;
      _report('<~ thresholdReached');
      onThresholdReached?.call(false);
    }
  }

  void _report(String what) {
    log.add(
      '$_nowMs  $what  [stream $streamId $playState points ${points.length}]',
    );
    reported.value = snapshot();
  }

  HspStateAdapter snapshot() => HspStateAdapter(
    playState: playState,
    firstPointTime: points.isEmpty ? 0 : points.first.at,
    lastPointTime: points.isEmpty ? 0 : points.last.at,
    currentTime: currentTime,
    points: points.length,
    currentPoint: 0,
    pauseOnStarving: false,
    maxPoints: maxPoints,
    loop: false,
    playbackRate: 1.0,
    streamId: streamId,
    tailPointStreamIndex: 0,
    tailPointStreamIndexThreshold: 0,
  );

  @override
  void hspSetup({int? streamId}) {
    setupsSent.add(streamId!);
    _send('setup($streamId)', () {
      this.streamId = streamId;
      points.clear();
      playState = HspStateAdapterPlayState.hspStateStopped;
    });
  }

  @override
  void hspFlush() => _send('flush', points.clear);

  @override
  void hspAdd(
    List<FunscriptAction> points, {
    required bool flush,
    required int? tailPointStreamIndex,
    required int? tailPointThreshold,
  }) {
    final copy = [...points];
    _send(
      'add(${copy.length}, flush: $flush, ${copy.first.at}..${copy.last.at})',
      () {
        if (flush) this.points.clear();
        this.points.addAll(copy);
      },
    );
  }

  @override
  void hspPlay({
    required int startTime,
    required double playbackRate,
    required bool loop,
    required bool pauseOnStarving,
  }) => _send('play($startTime)', () {
    if (playState == HspStateAdapterPlayState.hspStateNotInitialized) return;
    playState = HspStateAdapterPlayState.hspStatePlaying;
    currentTime = startTime;
  });

  @override
  void hspResume() => _send('resume', () {
    playState = HspStateAdapterPlayState.hspStatePlaying;
  });

  @override
  void hspPause() => _send('pause', () {
    if (playState == HspStateAdapterPlayState.hspStatePlaying) {
      playState = HspStateAdapterPlayState.hspStatePaused;
    }
  });

  @override
  void hspCurrentTimeSet({required int currentTime, required double filter}) =>
      _send('timeSet($currentTime)', () => this.currentTime = currentTime);

  @override
  void hspStop() => _send('stop', () {
    if (playState != HspStateAdapterPlayState.hspStateNotInitialized) {
      playState = HspStateAdapterPlayState.hspStateStopped;
    }
  });

  @override
  void hspLoop(bool loop) => _send('loop($loop)', () {});

  /// An HDSP command, as Home Mode sends to park the device. It takes the Handy
  /// out of HSP: the stream drops to 0 and the buffer goes, as the trace of a
  /// real device shows. The transport has no HSP response for it, so nothing is
  /// reported.
  @override
  void positionWithDuration(double relPos, int moveOverTimeMs) =>
      _send('xpt($relPos, $moveOverTimeMs)', () {
        streamId = 0;
        points.clear();
        playState = HspStateAdapterPlayState.hspStateStopped;
      }, reports: false);
}

class _Pending {
  _Pending(this.dueMs, this.name, this.apply, {required this.reports});
  final int dueMs;
  final String name;
  final void Function() apply;
  final bool reports;
}

abstract class _FakeHspBackendBase extends PlayerBackend
    with HandyHspCommandDelegation
    implements IHandyHspBase, ICommandBackendBase {
  _FakeHspBackendBase({
    required this.device,
    required super.timesource,
    required super.currentlyOpen,
    required super.settingsModel,
  }) : super(
         batteryModel: BatteryModel(),
         backendType: PlayerBackendType.handyStrokerStreamingBluetooth,
       );

  final FakeHspDevice device;

  @override
  final Signal<bool> connected = signal(true);

  @override
  ReadonlySignal<bool> get isConnecting => signal(false);

  @override
  bool get isBluetooth => true;

  @override
  ReadonlySignal<HspStateAdapter?> get hspStateAdapter => device.reported;

  @override
  IHspCommands? get hspCommandTarget => device;

  @override
  Widget settingsWidget(BuildContext context) => const SizedBox();

  @override
  Future<void> tryConnect() async {}
}

/// The production HSP mixin over [FakeHspDevice] instead of `HandyBle`.
class FakeHspBackend extends _FakeHspBackendBase with HandyNativeHspMixin {
  FakeHspBackend({
    required super.device,
    required super.timesource,
    required super.currentlyOpen,
    required super.settingsModel,
  }) {
    effectAdd(addEffects());
    device.onThresholdReached = handleThresholdReached;
    // What HandyNativeHspBluetoothBackend.tryConnect does once connected.
    hspSetup();
  }
}
