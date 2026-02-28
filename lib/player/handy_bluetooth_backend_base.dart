import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/player/handy_ble.dart';
import 'package:syncopathy/player/player_backend.dart';

abstract class HandyBluetoothBackendBase extends PlayerBackend {
  @override
  ReadonlySignal<bool> get connected => _connected;
  late final ReadonlySignal<bool> _connected = computed(() {
    return handyBle?.isConnected.value ?? false;
  });

  @override
  ReadonlySignal<bool> get isConnecting => _isConnecting;
  final Signal<bool> _isConnecting = signal(false);

  HandyBle? get handyBle => _handyBle.value;
  final Signal<HandyBle?> _handyBle = signal(null);

  HandyBluetoothBackendBase({
    required super.settingsModel,
    required super.batteryModel,
    required super.timesource,
    required super.currentFunscript,
  }) {
    effectAdd([
      effect(() {
        if (!connected.value) {
          handyBle?.dispose();
          _handyBle.value = null;
          batteryModel.hasBattery.value = false;
        }
      }),
    ]);
  }

  @override
  Widget settingsWidget(BuildContext context) {
    return Text("Only use this with Firmware 4.1.0+");
  }

  @override
  Future<void> tryConnect() async {
    await handyBle?.dispose();
    _handyBle.value = null;

    _isConnecting.value = true;
    _handyBle.value = await HandyBle.startScanning(
      settingsModel.min,
      settingsModel.max,
    );
    await handyBle?.init();
    _isConnecting.value = false;

    effectAdd([
      effect(() {
        final battery = handyBle?.batteryState.value;
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
    effectDispose();
    await handyBle?.dispose();
  }
}
