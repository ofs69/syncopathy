import 'dart:async';

import 'package:async_locks/async_locks.dart';
import 'package:syncopathy/logging.dart';
import 'package:universal_ble/universal_ble.dart';

class BtDevice {
  BleDevice device;
  BleCharacteristic tx;
  BleCharacteristic rx;

  BtDevice(this.device, this.tx, this.rx);
}

class BluetoothConnector {
  static final BluetoothConnector _instance = BluetoothConnector._internal();
  factory BluetoothConnector() => _instance;

  final StreamController<BleDevice> _deviceScanController =
      StreamController.broadcast();
  Stream<BleDevice> get deviceScan => _deviceScanController.stream;

  final Lock _scanLock = Lock();

  BluetoothConnector._internal() {
    UniversalBle.onScanResult = _handleScanResults;
  }

  void _handleScanResults(BleDevice scanResult) =>
      _deviceScanController.add(scanResult);

  Future<BtDevice?> scanForDevice(
    String serviceId,
    String txId,
    String rxId,
  ) async {
    try {
      await _scanLock.acquire();
      final connectLock = Lock();
      final Completer<BtDevice?> btDeviceCompleter = Completer();
      final subscription = deviceScan.listen((device) async {
        try {
          await connectLock.acquire();
          for (var i = 0; i < 3; i += 1) {
            if (btDeviceCompleter.isCompleted) return;
            Logger.info("Attemping ${i + 1} to connect to ${device.name}");
            try {
              await device.connect();
              await Future.delayed(Duration(seconds: 1));
              final tx = await device.getCharacteristic(
                "77835032-40f7-11ee-be56-0242ac120002",
                service: "77834d26-40f7-11ee-be56-0242ac120002",
              );
              final rx = await device.getCharacteristic(
                "77835410-40f7-11ee-be56-0242ac120002",
                service: "77834d26-40f7-11ee-be56-0242ac120002",
              );
              btDeviceCompleter.complete(BtDevice(device, tx, rx));
              break;
            } catch (ex) {
              Logger.error("Exception while connecting: $ex");
              await device.disconnect();
              await Future.delayed(Duration(seconds: 1));
            }
          }
        } finally {
          connectLock.release();
        }
      });

      await UniversalBle.startScan(
        scanFilter: ScanFilter(withServices: [serviceId]),
      );
      final device = await btDeviceCompleter.future;
      await subscription.cancel();
      return device;
    } finally {
      _scanLock.release();
    }
  }
}
