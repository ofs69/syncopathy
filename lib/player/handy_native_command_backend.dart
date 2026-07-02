import 'package:syncopathy/player/handy_bluetooth_backend_base.dart';
import 'package:syncopathy/player/player_backend.dart';
import 'package:syncopathy/player/player_backend_type.dart';

class HandyNativeCommandBackend extends HandyBluetoothBackendBase
    with CommandPacketBackend {
  HandyNativeCommandBackend({
    required super.settingsModel,
    required super.batteryModel,
    required super.timesource,
    required super.currentlyOpen,
  }) : super(backendType: PlayerBackendType.handyStrokerCommand) {
    effectAdd([commandEffect(timesource, settingsModel, currentActions)]);
  }

  @override
  Future<void> updateCommand(CommandPacket cmd) async {
    // The device handles the stroke range itself, so the raw position is sent.
    // TODO: listen to the handy's command-finished notification to compute the
    // playback delta.
    sendCommand(
      cmd,
      moveToPos: cmd.actualMoveToPos,
      shouldSend: connected.value,
    );
  }
}
