import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/helper/constants.dart';
import 'package:syncopathy/helper/extensions.dart';
import 'package:syncopathy/model/player_model.dart';

class ConnectionButton extends StatelessWidget {
  const ConnectionButton({super.key});

  Future<void> _confirmDisconnect(
    BuildContext context,
    PlayerModel playerModel,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Disconnect device?'),
        content: const Text(
          'Reconnecting requires scanning for the device again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Disconnect'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      playerModel.disconnectBackend();
    }
  }

  @override
  Widget build(BuildContext context) {
    final playerModel = context.read<PlayerModel>();

    return Watch.builder(
      builder: (context) {
        final backend = playerModel.playerBackend.value;
        final isConnecting = backend?.isConnecting.value ?? false;
        final isBluetooth = backend?.isBluetooth ?? true;
        final colorScheme = Theme.of(context).colorScheme;

        // Shared border so all three states keep the same footprint and swapping
        // between them doesn't reshape the control or shift toolbar neighbours.
        final buttonStyle = TextButton.styleFrom(
          side: BorderSide(
            color: colorScheme.outline.withAlphaF(0.5),
            width: 1.0,
          ),
        );

        final Widget child;
        if (isConnecting) {
          // The scan/connect can otherwise spin forever; tapping tears the
          // backend down, aborting it.
          child = Tooltip(
            key: const ValueKey('connecting'),
            message: 'Tap to cancel',
            child: TextButton.icon(
              icon: const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              label: Text(isBluetooth ? "Scanning…" : "Connecting…"),
              onPressed: () => playerModel.disconnectBackend(),
              style: buttonStyle,
            ),
          );
        } else {
          final connected = backend?.connected.value ?? false;
          final connectedIcon = isBluetooth
              ? Icons.bluetooth_connected
              : Icons.wifi;
          final disconnectedIcon = isBluetooth
              ? Icons.bluetooth_disabled
              : Icons.wifi_off;

          child = Tooltip(
            key: const ValueKey('idle'),
            message: connected
                ? "Connected — tap to disconnect"
                : "Disconnected — tap to connect",
            child: TextButton.icon(
              label: Text(connected ? "Connected" : "Disconnected"),
              icon: Icon(
                connected ? connectedIcon : disconnectedIcon,
                color: connected ? successColor : colorScheme.error,
              ),
              onPressed: () => connected
                  ? _confirmDisconnect(context, playerModel)
                  : playerModel.connectBackend(),
              style: buttonStyle,
            ),
          );
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: child,
        );
      },
    );
  }
}
