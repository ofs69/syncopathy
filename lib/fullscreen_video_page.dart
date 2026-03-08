import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncopathy/player/video_player.dart';
import 'package:syncopathy/video_controls.dart';
import 'package:syncopathy/video_widget.dart';

class FullscreenVideoPage extends StatefulWidget {
  final VideoPlayer player;
  final bool isEmbeddedPlayerEnabled;

  const FullscreenVideoPage({
    super.key,
    required this.player,
    required this.isEmbeddedPlayerEnabled,
  });

  @override
  State<FullscreenVideoPage> createState() => _FullscreenVideoPageState();
}

class _FullscreenVideoPageState extends State<FullscreenVideoPage> {
  bool _showControls = true;
  Timer? _hideControlsTimer;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _startHideControlsTimer();
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
      if (_showControls) {
        _startHideControlsTimer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isEmbeddedPlayerEnabled
          ? Colors.black
          : Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return MouseRegion(
            onHover: (_) {
              if (!_showControls) {
                setState(() {
                  _showControls = true;
                });
              }
              _startHideControlsTimer();
            },
            child: GestureDetector(
              onTap: _toggleControls,
              onLongPressStart: (_) {
                if (!_showControls) {
                  setState(() {
                    _showControls = true;
                  });
                }
                _hideControlsTimer?.cancel();
              },
              onLongPressEnd: (_) {
                _startHideControlsTimer();
              },
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Center(
                    child: Hero(
                      tag: 'videoPlayer',
                      child: VideoWidget(
                        player: widget.player,
                        controller: widget.player.controller!,
                        isFullscreen: true,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: AnimatedOpacity(
                      opacity: _showControls ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: IgnorePointer(
                        ignoring: !_showControls,
                        child: Hero(
                          tag: 'videoControls',
                          child: VideoControls(
                            onFullscreenToggle: () => Navigator.pop(context),
                            onInteractionStart: () {
                              _hideControlsTimer?.cancel();
                            },
                            onInteractionEnd: () {
                              _startHideControlsTimer();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
