import 'package:flutter/foundation.dart';
import 'package:syncopathy/player/buttplug_base_backend.dart';
import 'package:syncopathy/player/player_backend.dart';
import 'package:syncopathy/player/player_backend_type.dart';

class ButtplugStrokerBackend extends ButtplugBaseBackend
    with CommandPacketBackend {
  int _lastPosition = -1;

  // TODO: turn _ignoreSpeedThreshold this into a command slewing variable
  final int _ignoreSpeedThreshold = 500; // TODO: add this to settings

  ButtplugStrokerBackend({
    required super.timesource,
    required super.currentFunscript,
    required super.settingsModel,
    required super.batteryModel,
    required super.settings,
  }) : super(backendType: PlayerBackendType.buttplugStrokerCommand) {
    effectAdd([commandEffect(timesource, settingsModel, currentActions)]);
  }

  @override
  Future<void> updateCommand(CommandPacket cmd) async {
    if ((!connected.value) && !kDebugMode) return;

    if (cmd.moveOverTimeMs > 0 && cmd.logicalMoveToPos != _lastPosition) {
      final speed =
          (_lastPosition - cmd.logicalMoveToPos).abs().toDouble() /
          (cmd.moveOverTimeMs / 1000.0);

      if (speed >= _ignoreSpeedThreshold) {
        // TODO: this can be improved by doing some dynamic slewing instead
        // debugPrint(
        //   "IGNORED $_lastPosition to ${cmd.logicalMoveToPos} over ${cmd.moveOverTimeMs}ms speed: ${speed.toStringAsFixed(1)}",
        // );
        return;
      }
      positionWithDuration(
        (cmd.logicalMoveToPos / 100.0).clamp(0.0, 1.0),
        cmd.moveOverTimeMs,
      );
      // debugPrint(
      //   "$_lastPosition to ${cmd.logicalMoveToPos} over ${cmd.moveOverTimeMs}ms speed: ${speed.toStringAsFixed(1)}",
      // );
      _lastPosition = cmd.logicalMoveToPos;
    }
  }
}
