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
                  "Scanning for device...",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
          );
        }

        return Watch.builder(
          builder: (context) {
            final connected = backend?.connected.value ?? false;
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
