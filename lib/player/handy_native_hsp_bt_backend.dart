import 'package:flutter/foundation.dart';
import 'package:syncopathy/player/handy_bluetooth_backend_base.dart';
import 'package:syncopathy/player/handy_native_hsp_mixin.dart';

class HandyNativeHspBluetoothBackend extends HandyBluetoothBackendBase
    with HandyNativeHspMixin {
  HandyNativeHspBluetoothBackend({
    required super.settingsModel,
    required super.batteryModel,
    required super.timesource,
    required super.currentFunscript,
  }) {
    effectAdd(addEffects());
  }

  @override
  void handleThresholdReached(bool starving) {
    debugPrint("Handy threshold reached.");
    super.handleThresholdReached(starving);
  }

  @override
  Future<void> tryConnect() async {
    await super.tryConnect();
    hspSetup();
  }
}
