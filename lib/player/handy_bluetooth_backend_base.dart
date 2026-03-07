import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/generated/constants.pb.dart';
import 'package:syncopathy/model/funscript.dart';
import 'package:syncopathy/player/handy_ble.dart';
import 'package:syncopathy/player/handy_native_hsp_mixin.dart';
import 'package:syncopathy/player/player_backend.dart';

abstract class HandyBluetoothBackendBase extends PlayerBackend
    implements IHandyHspBase, ICommandBackendBase {
  @override
  ReadonlySignal<bool> get connected => _connected;
  late final ReadonlySignal<bool> _connected = computed(() {
    return _handyBle.value?.isConnected.value ?? false;
  });

  @override
  ReadonlySignal<bool> get isConnecting => _isConnecting;
  final Signal<bool> _isConnecting = signal(false);

  @override
  bool get isBluetooth => true;

  final Signal<HandyBle?> _handyBle = signal(null);
  late final ReadonlySignal<HspState?> hspState = computed(() {
    return _handyBle.value?.hspState.value;
  });

  Function(bool)? hspThresholdReachedHandler;
  Function()? hspLoopHandler;

  @override
  ReadonlySignal<HspStateAdapter?> get hspStateAdapter => _hspStateAdapter;
  late final ReadonlySignal<HspStateAdapter?> _hspStateAdapter;

  HandyBluetoothBackendBase({
    required super.settingsModel,
    required super.batteryModel,
    required super.timesource,
    required super.currentFunscript,
    required super.backendType,
  }) {
    _hspStateAdapter = computed(() {
      final state = hspState.value;
      if (state == null) return null;
      final playState = switch (state.playState) {
        HspPlayState.HSP_STATE_NOT_INITIALIZED =>
          HspStateAdapterPlayState.hspStateNotInitialized,
        HspPlayState.HSP_STATE_PAUSED =>
          HspStateAdapterPlayState.hspStatePaused,
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
    });
    effectAdd([
      effect(() {
        if (!connected.value) {
          _handyBle.value?.dispose();
          _handyBle.value = null;
          batteryModel.hasBattery.value = false;
        }
      }),
    ]);
  }

  @override
  Widget settingsWidget(BuildContext context) {
    return Text("Only use this with firmware v4.1.1+");
  }

  @override
  Future<void> tryConnect() async {
    await _handyBle.value?.dispose();
    _handyBle.value = null;

    _isConnecting.value = true;
    _handyBle.value = await HandyBle.startScanning(
      settingsModel.min,
      settingsModel.max,
    );
    await _handyBle.value?.init();
    _isConnecting.value = false;

    // TODO: this is jank
    _handyBle.value?.hspThresholdReached = (starving) =>
        hspThresholdReachedHandler?.call(starving);
    _handyBle.value?.hspLooped = () => hspLoopHandler?.call();

    effectAdd([
      effect(() {
        final battery = _handyBle.value?.batteryState.value;
        batteryModel.hasBattery.value = battery != null;
        if (battery != null) {
          batteryModel.chargerConntected.value = battery.chargerConnected;
          batteryModel.batteryLevel.value = battery.level;
        }
      }),
    ]);
  }

  @override
  Future<void> dispose() async {
    await super.dispose();
    await _handyBle.value?.dispose();
  }

  @override
  void hspAdd(
    List<FunscriptAction> points, {
    required bool flush,
    required int? tailPointStreamIndex,
    required int? tailPointThreshold,
  }) => _handyBle.value?.hspAdd(
    points.map((a) => Point(t: a.at, x: a.pos)).toList(),
    flush: flush,
    tailPointStreamIndex: tailPointStreamIndex,
    tailPointThreshold: tailPointThreshold,
  );

  @override
  void hspCurrentTimeSet({required int currentTime, required double filter}) =>
      _handyBle.value?.hspCurrentTimeSet(
        currentTime: currentTime,
        filter: filter,
      );

  @override
  void hspFlush() => _handyBle.value?.hspFlush();

  @override
  void hspPause() => _handyBle.value?.hspPause();

  @override
  void hspPlay({
    required int startTime,
    required double playbackRate,
    required bool loop,
    required bool pauseOnStarving,
  }) => _handyBle.value?.hspPlay(
    startTime: startTime,
    playbackRate: playbackRate,
    loop: loop,
    pauseOnStarving: pauseOnStarving,
  );

  @override
  void hspResume() => _handyBle.value?.hspResume();

  @override
  void hspSetup({int? streamId}) =>
      _handyBle.value?.hspSetup(streamId: streamId);

  @override
  void hspStop() => _handyBle.value?.hspStop();

  @override
  void hspLoop(bool loop) => _handyBle.value?.hspLoop(loop);

  @override
  void positionWithDuration(double relPos, int moveOverTimeMs) =>
      _handyBle.value?.positionWithDuration(relPos, moveOverTimeMs);
}
