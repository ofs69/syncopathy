import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/helper/debouncer.dart';
import 'package:syncopathy/model/funscript.dart';
import 'package:syncopathy/model/json/handy_native_web_backend_settings.dart';
import 'package:syncopathy/platform/key_value_store/key_value_store.dart';
import 'package:syncopathy/player/handy_native_hsp_mixin.dart';
import 'package:syncopathy/player/handy_web.dart';
import 'package:syncopathy/player/player_backend.dart';

abstract class HandyWebBackendBase extends PlayerBackend
    implements IHandyHspBase, ICommandBackendBase {
  @override
  ReadonlySignal<HspStateAdapter?> get hspStateAdapter => handy.hspStateAdapter;

  late final HandyWeb handy;

  HandyWebBackendBase({
    required super.timesource,
    required super.currentlyOpen,
    required super.settingsModel,
    required super.batteryModel,
    required this.webSettings,
    required super.backendType,
  }) {
    handy = HandyWeb(settingsModel.min, settingsModel.max);
  }

  @override
  bool get isBluetooth => false;

  @override
  ReadonlySignal<bool> get connected => handy.connected;

  @override
  ReadonlySignal<bool> get isConnecting => _isConnecting;
  final Signal<bool> _isConnecting = signal(false);

  Function(bool)? hspThresholdReachedHandler;
  Function()? hspLoopedHandler;

  static const String applicationKey = String.fromEnvironment(
    'HANDY_APPLICATION_ID',
    defaultValue: 'YOUR_OWN_APP_KEY',
  );

  final _formKey = GlobalKey<FormState>();
  final _saveDebounce = Debouncer(milliseconds: 500);
  HandyNativeWebBackendSettings webSettings;
  Future<void> _saveSettings() async {
    _saveDebounce.run(() async {
      await KVStore.put(
        HandyNativeWebBackendSettings.key,
        webSettings.toJson(),
      );
    });
  }

  @override
  Widget settingsWidget(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: () {
        if (_formKey.currentState?.validate() ?? false) {
          _formKey.currentState?.save();
          _saveSettings();
        }
      },
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: "Connection Key",
              border: OutlineInputBorder(),
            ),
            initialValue: webSettings.connectionKey,
            onSaved: (value) =>
                webSettings.connectionKey = value ?? webSettings.connectionKey,
          ),
        ],
      ),
    );
  }

  @override
  Future<void> dispose() async {
    await super.dispose();
    await handy.disconnect();
  }

  @override
  Future<void> tryConnect() async {
    try {
      _isConnecting.value = true;
      await handy.disconnect();
      await handy.connect(
        webSettings.connectionKey,
        webSettings.applicationKeyOverride ?? applicationKey,
      );
      // TODO: this is jank
      handy.hspThresholdReached = (starving) =>
          hspThresholdReachedHandler?.call(starving);
      handy.hspLooped = () => hspLoopedHandler?.call();
    } finally {
      _isConnecting.value = false;
    }
  }

  @override
  void hspAdd(
    List<FunscriptAction> points, {
    required bool flush,
    required int? tailPointStreamIndex,
    required int? tailPointThreshold,
  }) => handy.hspAdd(
    points,
    flush: flush,
    tailPointStreamIndex: tailPointStreamIndex,
    tailPointThreshold: tailPointThreshold,
  );

  @override
  void hspCurrentTimeSet({required int currentTime, required double filter}) =>
      handy.hspCurrentTimeSet(currentTime: currentTime, filter: filter);

  @override
  void hspFlush() => handy.hspFlush();

  @override
  void hspPause() => handy.hspPause();

  @override
  void hspPlay({
    required int startTime,
    required double playbackRate,
    required bool loop,
    required bool pauseOnStarving,
  }) => handy.hspPlay(
    startTime: startTime,
    playbackRate: playbackRate,
    loop: loop,
    pauseOnStarving: pauseOnStarving,
  );

  @override
  void hspResume() => handy.hspResume();

  @override
  void hspSetup({int? streamId}) => handy.hspSetup(streamId: streamId);

  @override
  void hspStop() => handy.hspStop();

  @override
  void hspLoop(bool loop) => handy.hspLoop(loop);

  @override
  void positionWithDuration(double relPos, int moveOverTimeMs) =>
      handy.positionWithDuration(relPos, moveOverTimeMs);
}
