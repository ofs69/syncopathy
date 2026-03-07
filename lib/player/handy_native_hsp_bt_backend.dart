import 'package:syncopathy/player/handy_bluetooth_backend_base.dart';
import 'package:syncopathy/player/handy_native_hsp_mixin.dart';
import 'package:syncopathy/player/player_backend_type.dart';

class HandyNativeHspBluetoothBackend extends HandyBluetoothBackendBase
    with HandyNativeHspMixin {
  HandyNativeHspBluetoothBackend({
    required super.settingsModel,
    required super.batteryModel,
    required super.timesource,
    required super.currentFunscript,
  }) : super(backendType: PlayerBackendType.handyStrokerStreamingBluetooth) {
    effectAdd(addEffects());
  }

  @override
  Future<void> tryConnect() async {
    await super.tryConnect();
    hspThresholdReachedHandler = handleThresholdReached;
    hspLoopHandler = handleLoop;
    hspSetup();
  }
}
