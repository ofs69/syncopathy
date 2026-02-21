import 'package:buttplug/buttplug.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/helper/debouncer.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/model/json/buttplug_stroker_backend_settings.dart';
import 'package:syncopathy/player/player_backend.dart';
import 'package:syncopathy/sqlite/key_value_store.dart';

class ButtplugStrokerBackend extends PlayerBackend with CommandPacketBackend {
  final Signal<bool> _connected = signal(false);
  final Signal<bool> _isConnecting = signal(false);

  @override
  ReadonlySignal<bool> get connected => _connected;

  @override
  ReadonlySignal<bool> get isConnecting => _isConnecting;

  ButtplugWebsocketClientConnector? _connector;
  ButtplugClient? _client;
  ButtplugClientDevice? _device;
  int _lastPosition = -1;

  ButtplugStrokerBackendSettings settings;
  final _formKey = GlobalKey<FormState>();
  final _saveDebounce = Debouncer(milliseconds: 500);

  // TODO: turn _ignoreSpeedThreshold this into a command slewing variable
  final int _ignoreSpeedThreshold = 500; // TODO: add this to settings

  String get serverUrl => "ws://${settings.host}:${settings.port}";

  ButtplugStrokerBackend({
    required super.timesource,
    required super.currentFunscript,
    required super.settingsModel,
    required super.batteryModel,
    required this.settings,
  }) {
    effectAdd([commandEffect(timesource, settingsModel, currentActions)]);
  }

  Future<void> _saveSettings() async {
    _saveDebounce.run(() async {
      await KeyValueStore.put(
        ButtplugStrokerBackendSettings.key,
        settings.toJson(),
      );
    });
  }

  @override
  Future<void> updateCommand(CommandPacket cmd) async {
    if ((!connected.value || _device == null) && !kDebugMode) return;

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
      final output = DeviceOutput.positionWithDuration.percent(
        (cmd.logicalMoveToPos / 100.0).clamp(0.0, 1.0),
        cmd.moveOverTimeMs,
      );
      await _device?.runOutput(output);
      // debugPrint(
      //   "$_lastPosition to ${cmd.logicalMoveToPos} over ${cmd.moveOverTimeMs}ms speed: ${speed.toStringAsFixed(1)}",
      // );
      _lastPosition = cmd.logicalMoveToPos;
    }
  }

  @override
  Future<void> dispose() async {
    await _disconnect();
  }

  Future<void> _disconnect() async {
    try {
      await _client?.disconnect();
      await _connector?.disconnect();
    } catch (_) {}
    _connector = null;
    _client = null;
    _device = null;
    _connected.value = false;
    _isConnecting.value = false;
  }

  @override
  Future<void> tryConnect() async {
    await _disconnect();
    _isConnecting.value = true;
    _connector = ButtplugWebsocketClientConnector(serverUrl);
    _client = ButtplugClient('Syncopathy');

    try {
      await _client!.connect(_connector!);
      Logger.warning("Successfully connected to Buttplug server.");

      Logger.warning("Waiting for device...");
      await _client!.startScanning();
      await Future.delayed(Duration(seconds: 3));

      final strokerDevice = _client!.devices.values.firstWhereOrNull(
        (x) => x.features.values.any(
          (feature) => feature.hasOutput(OutputType.hwPositionWithDuration),
        ),
      );

      if (strokerDevice != null) {
        Logger.warning(
          "Found device: ${strokerDevice.displayName ?? strokerDevice.name}",
        );
        _device = strokerDevice;
        _connected.value = true;
      } else {
        await _client!.disconnect();
      }
      await _client!.stopScanning();
    } catch (e) {
      Logger.error("Connection error: $e");
      _connected.value = false;
      _client = null;
      _connector = null;
    }
    _isConnecting.value = false;
  }

  @override
  Widget settingsWidget(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: () {
        if (_formKey.currentState?.validate() ?? false) {
          _formKey.currentState?.save();
          _saveSettings();
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hostname/IP Field
          Expanded(
            flex: 3,
            child: TextFormField(
              initialValue: settings.host,
              onSaved: (newValue) => settings.host = newValue ?? settings.host,
              decoration: InputDecoration(
                labelText: 'Server Address',
                hintText: 'localhost',
                prefixText: 'ws://',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                // Regex for valid hostname or IP address
                final hostRegex = RegExp(
                  r'^((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4}$|^([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])(\.([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]{0,61}[a-zA-Z0-9]))*$',
                );

                if (value == null || value.isEmpty) {
                  return 'Hostname is required';
                }
                if (!hostRegex.hasMatch(value)) {
                  return 'Invalid hostname or IP address';
                }
                return null;
              },
            ),
          ),
          SizedBox(width: 8),
          // Port Field
          Expanded(
            flex: 1,
            child: TextFormField(
              initialValue: settings.port.toString(),
              onSaved: (newValue) {
                if (newValue != null) {
                  settings.port = int.tryParse(newValue) ?? settings.port;
                }
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Port',
                hintText: '12345',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final port = int.tryParse(value ?? '');
                if (port == null || port < 1 || port > 65535) {
                  return 'Invalid Port';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 16.0),
            child: IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Reset to Defaults',
              onPressed: () {
                settings = ButtplugStrokerBackendSettings();
                _formKey.currentState?.reset();
                _saveSettings();
              },
            ),
          ),
        ],
      ),
    );
  }
}
