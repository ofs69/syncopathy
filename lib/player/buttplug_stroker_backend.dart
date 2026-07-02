import 'package:flutter/foundation.dart';
import 'package:syncopathy/player/buttplug_base_backend.dart';
import 'package:syncopathy/player/player_backend.dart';
import 'package:syncopathy/player/player_backend_type.dart';

class ButtplugStrokerBackend extends ButtplugBaseBackend
    with CommandPacketBackend {
  ButtplugStrokerBackend({
    required super.timesource,
    required super.currentlyOpen,
    required super.settingsModel,
    required super.batteryModel,
    required super.settings,
  }) : super(backendType: PlayerBackendType.buttplugStrokerCommand) {
    effectAdd([commandEffect(timesource, settingsModel, currentActions)]);
  }

  @override
  Future<void> updateCommand(CommandPacket cmd) async {
    // No device to clamp the range, so the pre-clamped logical position is sent.
    // In debug mode commands are still emitted without a connection for testing.
    sendCommand(
      cmd,
      moveToPos: cmd.logicalMoveToPos,
      shouldSend: connected.value || kDebugMode,
    );
  }
}
