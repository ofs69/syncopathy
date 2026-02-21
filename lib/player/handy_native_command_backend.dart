import 'package:flutter/foundation.dart';
import 'package:syncopathy/player/handy_bluetooth_backend_base.dart';
import 'package:syncopathy/player/player_backend.dart';

class HandyNativeCommandBackend extends HandyBluetoothBackendBase
    with CommandPacketBackend {
  HandyNativeCommandBackend({
    required super.settingsModel,
    required super.batteryModel,
    required super.timesource,
    required super.currentFunscript,
  }) {
    effectAdd([commandEffect(timesource, settingsModel, currentActions)]);
  }

  int _lastPosition = -1;
  final int _ignoreSpeedThreshold = 500; // TODO: add this to settings

  @override
  Future<void> updateCommand(CommandPacket cmd) async {
    if ((!connected.value || handyBle == null) && !kDebugMode) return;

    if (cmd.moveOverTimeMs > 0 && cmd.logicalMoveToPos != _lastPosition) {
      final speed =
          (_lastPosition - cmd.logicalMoveToPos).abs().toDouble() /
          (cmd.moveOverTimeMs / 1000.0);

      if (speed >= _ignoreSpeedThreshold) {
        debugPrint(
          "IGNORED speed: ${speed.toStringAsFixed(1)} to: ${cmd.logicalMoveToPos} over ${cmd.moveOverTimeMs}ms",
        );
        return;
      }
      // stroke range is handled by the device itself which is why actualMovePos is passed
      handyBle?.positionWithDuration(
        (cmd.actualMoveToPos / 100.0).clamp(0.0, 1.0),
        cmd.moveOverTimeMs,
      );
      debugPrint(
        "speed: ${speed.toStringAsFixed(1)} to: ${cmd.logicalMoveToPos} over ${cmd.moveOverTimeMs}ms",
      );
      _lastPosition = cmd.logicalMoveToPos;
    }
  }
}
