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
  final FocusNode _focusNode = FocusNode();

  // The combination captured so far. Kept in state (rather than committed on the
  // first keypress) so the user can see it, re-press to change it, and confirm
  // with Save.
  ShortcutBinding? _captured;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  static bool _isModifier(LogicalKeyboardKey key) {
    return key == LogicalKeyboardKey.controlLeft ||
        key == LogicalKeyboardKey.controlRight ||
        key == LogicalKeyboardKey.shiftLeft ||
        key == LogicalKeyboardKey.shiftRight ||
        key == LogicalKeyboardKey.altLeft ||
        key == LogicalKeyboardKey.altRight ||
        key == LogicalKeyboardKey.metaLeft ||
        key == LogicalKeyboardKey.metaRight;
  }

  void _handleKey(KeyEvent event) {
    if (event is! KeyDownEvent) return;
    final key = event.logicalKey;
    // Escape cancels the rebind instead of being captured as a binding.
    if (key == LogicalKeyboardKey.escape) {
      Navigator.of(context).pop();
      return;
    }
    // A modifier on its own isn't a trigger; wait for a real key.
    if (_isModifier(key)) return;

    setState(() {
      _captured = ShortcutBinding(
        keyId: key.keyId,
        control: HardwareKeyboard.instance.isControlPressed,
        shift: HardwareKeyboard.instance.isShiftPressed,
        alt: HardwareKeyboard.instance.isAltPressed,
        meta: HardwareKeyboard.instance.isMetaPressed,
      );
    });
  }

  /// The name of another shortcut already bound to [binding], or null if the
  /// combination is free. Compares against each shortcut's effective binding
  /// (custom override, falling back to its default).
  String? _conflictName(SettingsModel settings, ShortcutBinding binding) {
    final custom = settings.customShortcuts.value;
    for (final s in ShortcutDefinitions.all) {
      if (s.id == widget.shortcut.id) continue;
      final effective = custom[s.id] ?? s.defaultBinding;
      if (effective == binding) return s.name;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.read<SettingsModel>();
    final scheme = Theme.of(context).colorScheme;
    final current =
        settings.customShortcuts.value[widget.shortcut.id] ??
        widget.shortcut.defaultBinding;
    final captured = _captured;
    final conflictName = captured == null
        ? null
        : _conflictName(settings, captured);

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKey,
      child: AlertDialog(
        title: Text('Rebind ${widget.shortcut.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Press the new key combination…'),
            const SizedBox(height: 16),
            Text(
              'Current: $current',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            // Preview of what Save will commit, so nothing is bound sight unseen.
            Row(
              children: [
                Text('New: ', style: Theme.of(context).textTheme.bodyMedium),
                Text(
                  captured?.toString() ?? '—',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            if (conflictName != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 18,
                    color: scheme.error,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      'Already assigned to "$conflictName".',
                      style: TextStyle(color: scheme.error),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              settings.customShortcuts.remove(widget.shortcut.id);
              Navigator.of(context).pop();
            },
            child: const Text('Reset to Default'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: captured == null
                ? null
                : () => Navigator.of(context).pop(captured),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
