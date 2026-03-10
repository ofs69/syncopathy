import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/player/video_player.dart';

class ToggleVideoIntent extends Intent {
  const ToggleVideoIntent();
}

class GlobalShortcuts extends StatelessWidget {
  final Widget child;
  const GlobalShortcuts({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final videoPlayer = context.read<VideoPlayer>();
    return Shortcuts(
      shortcuts: <ShortcutActivator, Intent>{
        LogicalKeySet(LogicalKeyboardKey.space): const ToggleVideoIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          ToggleVideoIntent: CallbackAction<ToggleVideoIntent>(
            onInvoke: (intent) => videoPlayer.togglePause(),
          ),
        },
        child: child,
      ),
    );
  }
}
