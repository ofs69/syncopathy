import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/player/video_player.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isEmbeddedPlayerEnabled
          ? Colors.black
          : Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Center(
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
            ],
          );
        },
      ),
    );
  }
}
