import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/model/shortcut_settings.dart';
import 'package:syncopathy/player/video_player.dart';

class TogglePauseIntent extends Intent {
  const TogglePauseIntent();
}

class NextTrackIntent extends Intent {
  const NextTrackIntent();
}

class PreviousTrackIntent extends Intent {
  const PreviousTrackIntent();
}

class ToggleHomeModeIntent extends Intent {
  const ToggleHomeModeIntent();
}

class GlobalShortcutManager extends ShortcutManager {
  bool _isTextInputFocused() {
    final focus = FocusManager.instance.primaryFocus;
    if (focus == null) return false;
    final context = focus.context;
    if (context == null) return false;

    bool isEditable = false;
    context.visitAncestorElements((element) {
      if (element.widget is EditableText) {
        isEditable = true;
        return false;
      }
      return true;
    });
    if (isEditable) return true;

    return context.findRenderObject() is RenderEditable;
  }

  @override
  KeyEventResult handleKeypress(BuildContext context, KeyEvent event) {
    if (_isTextInputFocused()) {
      return KeyEventResult.ignored;
    }
    return super.handleKeypress(context, event);
  }
}

class GlobalShortcuts extends StatefulWidget {
  final Widget child;
  const GlobalShortcuts({super.key, required this.child});

  @override
  State<GlobalShortcuts> createState() => _GlobalShortcutsState();
}

class _GlobalShortcutsState extends State<GlobalShortcuts> {
  // Reused across rebuilds; only its `shortcuts` map is reassigned when the
  // custom bindings change, instead of allocating a new manager each build.
  final GlobalShortcutManager _shortcutManager = GlobalShortcutManager();

  @override
  void dispose() {
    _shortcutManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoPlayer = context.read<VideoPlayer>();
    final settingsModel = context.read<SettingsModel>();

    return Watch((context) {
      final customShortcuts = settingsModel.customShortcuts.value;

      ShortcutActivator getActivator(AppShortcut shortcut) {
        return (customShortcuts[shortcut.id] ?? shortcut.defaultBinding)
            .toActivator();
      }

      _shortcutManager.shortcuts = <ShortcutActivator, Intent>{
        getActivator(ShortcutDefinitions.togglePause):
            const TogglePauseIntent(),
        getActivator(ShortcutDefinitions.nextTrack): const NextTrackIntent(),
        getActivator(ShortcutDefinitions.previousTrack):
            const PreviousTrackIntent(),
        getActivator(ShortcutDefinitions.toggleHomeMode):
            const ToggleHomeModeIntent(),
      };

      return Shortcuts.manager(
        manager: _shortcutManager,
        child: Actions(
          actions: <Type, Action<Intent>>{
            TogglePauseIntent: CallbackAction<TogglePauseIntent>(
              onInvoke: (intent) => videoPlayer.togglePause(),
            ),
            NextTrackIntent: CallbackAction<NextTrackIntent>(
              onInvoke: (intent) => videoPlayer.jumpNextPlaylistEntry(),
            ),
            PreviousTrackIntent: CallbackAction<PreviousTrackIntent>(
              onInvoke: (intent) => videoPlayer.jumpPreviousPlaylistEntry(),
            ),
            ToggleHomeModeIntent: CallbackAction<ToggleHomeModeIntent>(
              onInvoke: (intent) => settingsModel.homeDeviceEnabled.value =
                  !settingsModel.homeDeviceEnabled.value,
            ),
          },
          child: widget.child,
        ),
      );
    });
  }
}
