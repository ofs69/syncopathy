import 'package:flutter/foundation.dart';
import 'package:syncopathy/player/handy_native_hsp_mixin.dart';
import 'package:syncopathy/player/handy_web_backend_base.dart';
import 'package:syncopathy/player/player_backend_type.dart';

class HandyNativeHspWebBackend extends HandyWebBackendBase
    with HandyNativeHspMixin {
  HandyNativeHspWebBackend({
    required super.timesource,
    required super.currentFunscript,
    required super.settingsModel,
    required super.batteryModel,
    required super.webSettings,
  }) : super(backendType: PlayerBackendType.handyStrokerStreamingWeb) {
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
    hspThresholdReachedHandler = handleThresholdReached;
    hspLoopedHandler = handleLoop;
    hspSetup();
  }
}
