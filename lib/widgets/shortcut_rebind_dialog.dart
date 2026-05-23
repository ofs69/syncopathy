import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/model/shortcut_settings.dart';

class ShortcutRebindDialog extends StatefulWidget {
  final AppShortcut shortcut;
  const ShortcutRebindDialog({super.key, required this.shortcut});

  @override
  State<ShortcutRebindDialog> createState() => _ShortcutRebindDialogState();
}

class _ShortcutRebindDialogState extends State<ShortcutRebindDialog> {
  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      autofocus: true,
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          final key = event.logicalKey;
          // Ignore modifier keys as triggers
          if (key == LogicalKeyboardKey.controlLeft ||
              key == LogicalKeyboardKey.controlRight ||
              key == LogicalKeyboardKey.shiftLeft ||
              key == LogicalKeyboardKey.shiftRight ||
              key == LogicalKeyboardKey.altLeft ||
              key == LogicalKeyboardKey.altRight ||
              key == LogicalKeyboardKey.metaLeft ||
              key == LogicalKeyboardKey.metaRight) {
            return;
          }

          final binding = ShortcutBinding(
            keyId: key.keyId,
            control: HardwareKeyboard.instance.isControlPressed,
            shift: HardwareKeyboard.instance.isShiftPressed,
            alt: HardwareKeyboard.instance.isAltPressed,
            meta: HardwareKeyboard.instance.isMetaPressed,
          );
          Navigator.of(context).pop(binding);
        }
      },
      child: AlertDialog(
        title: Text('Rebind ${widget.shortcut.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Press the new key combination...'),
            const SizedBox(height: 16),
            Text(
              'Current: ${(context.read<SettingsModel>().customShortcuts.value[widget.shortcut.id] ?? widget.shortcut.defaultBinding).toString()}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final settings = context.read<SettingsModel>();
              settings.customShortcuts.remove(widget.shortcut.id);
              Navigator.of(context).pop();
            },
            child: const Text('Reset to Default'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
