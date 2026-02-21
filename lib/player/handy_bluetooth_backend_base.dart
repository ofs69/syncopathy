import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/player/handy_ble.dart';
import 'package:syncopathy/player/player_backend.dart';

abstract class HandyBluetoothBackendBase extends PlayerBackend {
  @override
  ReadonlySignal<bool> get connected => _connected;
  final Signal<bool> _connected = signal(false);

  @override
  ReadonlySignal<bool> get isConnecting => _isConnecting;
  final Signal<bool> _isConnecting = signal(false);

  HandyBle? handyBle;

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
          handyBle = null;
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
    handyBle = null;

    _isConnecting.value = true;
    handyBle = await HandyBle.startScanning(
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
      effect(() {
        _connected.value = handyBle?.isConnected.value ?? false;
      }),
    ]);
  }

  @override
  Future<void> dispose() async {
    effectDispose();
    await handyBle?.dispose();
  }
}
