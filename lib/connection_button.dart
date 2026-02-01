import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/model/player_model.dart';

class ConnectionButton extends StatelessWidget {
  const ConnectionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerModel>();
    return Watch.builder(
      builder: (context) {
        final scanning = player.isScanning.value;
        if (scanning) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(),
                ),
                const SizedBox(width: 8),
                Text(
                  "Scanning for device...",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
          );
        }
        return Watch.builder(
          builder: (context) {
            final connected = player.isConnected.value;
            return Tooltip(
              message: connected ? "Connected" : "Disconnected",
              child: TextButton.icon(
                label: Text(connected ? "Connected" : "Disconnected"),
                icon: Icon(
                  connected
                      ? Icons.bluetooth_connected
                      : Icons.bluetooth_disabled,
                  color: connected ? Colors.green : Colors.red,
                ),
                onPressed: scanning ? null : () => player.tryConnect(),
              ),
            );
          },
        );
      },
    );
  }
}
