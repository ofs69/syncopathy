import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/helper/extensions.dart';
import 'package:syncopathy/model/player_model.dart';

class ConnectionButton extends StatelessWidget {
  const ConnectionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final playerModel = context.read<PlayerModel>();

    return Watch.builder(
      builder: (context) {
        final backend = playerModel.playerBackend.value;
        final isConnecting = backend?.isConnecting.value ?? false;

        if (isConnecting) {
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
                  (backend?.isBluetooth ?? true)
                      ? "Scanning for device..."
                      : "Connecting...",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
          );
        }
        return Watch.builder(
          builder: (context) {
            final connected = backend?.connected.value ?? false;
            final connectedIcon = (backend?.isBluetooth ?? true)
                ? Icons.bluetooth_connected
                : Icons.wifi;
            final disconnectedIcon = (backend?.isBluetooth ?? true)
                ? Icons.bluetooth_disabled
                : Icons.wifi_off;

            return Tooltip(
              message: connected ? "Connected" : "Disconnected",
              child: TextButton.icon(
                label: Text(connected ? "Connected" : "Disconnected"),
                icon: Icon(
                  connected ? connectedIcon : disconnectedIcon,
                  color: connected ? Colors.green : Colors.red,
                ),
                onPressed: isConnecting ? null : () => backend?.tryConnect(),
                style: TextButton.styleFrom(
                  side: BorderSide(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withAlphaF(0.5),
                    width: 1.0,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
