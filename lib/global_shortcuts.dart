import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/player/video_player.dart';

/// A widget that installs global keyboard shortcuts using [HardwareKeyboard].
///
/// Unlike [Focus]-based approaches, this bypasses the focus tree entirely.
/// Shortcuts fire reliably regardless of which widget has focus, while
/// text field input is protected by the [_isEditingText] guard.
class GlobalShortcuts extends StatefulWidget {
  final Widget child;
  const GlobalShortcuts({super.key, required this.child});

  @override
  State<GlobalShortcuts> createState() => _GlobalShortcutsState();
}

class _GlobalShortcutsState extends State<GlobalShortcuts> {
  late final bool Function(KeyEvent) _keyHandler;

  /// Returns true when the user is actively typing in a text field.
  /// Prevents shortcuts from firing mid-input.
  bool _isEditingText() {
    final focus = FocusManager.instance.primaryFocus;
    if (focus == null) return false;

    final widget = focus.context?.widget;
    if (widget is EditableText) return true;

    // Robust check: see if any ancestor is an EditableText.
    // This handles cases where focus is on a TextField/TextFormField wrapper.
    bool found = false;
    focus.context?.visitAncestorElements((element) {
      if (element.widget is EditableText) {
        found = true;
        return false;
      }
      return true;
    });
    return found;
  }

  @override
  void initState() {
    super.initState();

    _keyHandler = (KeyEvent event) {
      // Only act on key-down events; ignore repeats and key-up
      if (event is! KeyDownEvent) return false;

      // Sacred rule: never steal from text fields
      if (_isEditingText()) return false;

      final videoPlayer = getIt<VideoPlayer>();
      final ctrl = HardwareKeyboard.instance.isControlPressed;

      switch (event.logicalKey) {
        case LogicalKeyboardKey.space:
          videoPlayer.togglePause();
          return true;

        case LogicalKeyboardKey.arrowLeft:
          if (ctrl) {
            videoPlayer.jumpPreviousPlaylistEntry();
          } else {
            videoPlayer.seekBackward();
          }
          return true;

        case LogicalKeyboardKey.arrowRight:
          if (ctrl) {
            videoPlayer.jumpNextPlaylistEntry();
          } else {
            videoPlayer.seekForward();
          }
          return true;

        case LogicalKeyboardKey.pageUp:
          videoPlayer.jumpPreviousPlaylistEntry();
          return true;

        case LogicalKeyboardKey.pageDown:
          videoPlayer.jumpNextPlaylistEntry();
          return true;

        default:
          return false;
      }
    };

    HardwareKeyboard.instance.addHandler(_keyHandler);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_keyHandler);
    super.dispose();
  }

  /// No Focus wrapper — just pass the child through.
  /// The handler is registered at the hardware level, not the widget tree level.
  @override
  Widget build(BuildContext context) => widget.child;
}
