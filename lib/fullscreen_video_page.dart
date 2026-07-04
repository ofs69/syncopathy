import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/player/video_player.dart';
import 'package:syncopathy/simple/simple_mode/simple_mode.dart';
import 'package:syncopathy/video_widget.dart';

class FullscreenVideoPage extends StatefulWidget {
  final VideoPlayer player;
  final Signal<bool> showFunscriptGraph;
  final Signal<bool> showSettings;
  final Signal<bool> showControls;
  final bool isEmbeddedPlayerEnabled;

  const FullscreenVideoPage({
    super.key,
    required this.player,
    required this.isEmbeddedPlayerEnabled,
    required this.showFunscriptGraph,
    required this.showSettings,
    required this.showControls,
  });

  @override
  State<FullscreenVideoPage> createState() => _FullscreenVideoPageState();
}

class _FullscreenVideoPageState extends State<FullscreenVideoPage> {
  // Every exit routes through here so leaving fullscreen always restores the
  // OS/browser window. Popping the route directly (e.g. system back or a
  // predictive-back gesture) would otherwise strand the window fullscreen.
  Future<void> _exitFullscreen() async {
    if (!kIsWeb) await SimpleMode.exitFullscreen();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _exitFullscreen();
      },
      child: Focus(
        autofocus: true,
        // Escape is a keyboard exit even while the auto-hiding controls (and
        // their fullscreen toggle) are hidden. As an ancestor Focus it still
        // receives the key when a descendant control holds primary focus.
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.escape) {
            _exitFullscreen();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: Scaffold(
          backgroundColor: widget.isEmbeddedPlayerEnabled
              ? Colors.black
              : Colors.transparent,
          body: Center(
            child: Hero(
              tag: 'videoPlayer',
              child: VideoWidget(
                player: widget.player,
                isFullscreen: true,
                showControls: widget.showControls,
                showFunscriptGraph: widget.showFunscriptGraph,
                showSettings: widget.showSettings,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
