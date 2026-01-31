import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/heatmap.dart';
import 'package:syncopathy/model/funscript.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/settings_popup_menu.dart';

class VideoControls extends StatefulWidget {
  final VoidCallback onFullscreenToggle;
  final VoidCallback? onInteractionStart;
  final VoidCallback? onInteractionEnd;
  final ValueChanged<bool>? onToggleFunscriptGraph;
  final ValueNotifier<bool> showFunscriptGraphNotifier;

  const VideoControls({
    super.key,
    required this.onFullscreenToggle,
    this.onInteractionStart,
    this.onInteractionEnd,
    this.onToggleFunscriptGraph,
    required this.showFunscriptGraphNotifier,
  });

  @override
  State<VideoControls> createState() => _VideoControlsState();
}

class _VideoControlsState extends State<VideoControls> {
  bool _hovering = false;
  Timer? _hoverExitTimer;

  @override
  Widget build(BuildContext context) {
    final player = context.read<PlayerModel>();
    final iconSize = Theme.of(context).iconTheme.size ?? 24.0;

    return Material(
      type: MaterialType.transparency,

      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black, Colors.black, Colors.transparent],
            stops: [0.0, 0.1, 1.0],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Heatmap
                  Expanded(
                    child: MouseRegion(
                      onEnter: (_) {
                        _hoverExitTimer?.cancel();
                        setState(() => _hovering = true);
                      },
                      onExit: (_) {
                        _hoverExitTimer = Timer(
                          const Duration(milliseconds: 1000),
                          () {
                            if (mounted) {
                              setState(() => _hovering = false);
                            }
                          },
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        height: _hovering ? iconSize * 2.5 : iconSize * 1.0,
                        child: ValueListenableBuilder<Funscript?>(
                          valueListenable: player.currentFunscript,
                          builder: (context, funscript, child) {
                            if (funscript == null) {
                              return const Center(
                                child: Text("No funscript loaded"),
                              );
                            }
                            return Heatmap(
                              funscript: funscript,
                              totalDuration: player.duration,
                              videoPosition: player.positionNoOffset,
                              onClick: (d) =>
                                  player.seekTo(d.inSeconds.toDouble()),
                              onInteractionStart: widget.onInteractionStart,
                              onInteractionEnd: widget.onInteractionEnd,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Play/Pause Button
                  Watch.builder(
                    builder: (context) {
                      final isPaused = player.paused.value;
                      return IconButton(
                        icon: Icon(isPaused ? Icons.play_arrow : Icons.pause),
                        iconSize:
                            (Theme.of(context).iconTheme.size ?? 24.0) * 1.5,
                        onPressed: player.togglePause,
                      );
                    },
                  ),
                  // Volume Slider
                  Watch.builder(
                    builder: (context) {
                      final volume = player.volume.value;
                      return SizedBox(
                        width: 200, // Adjust width as needed
                        height: Theme.of(context).iconTheme.size ?? 24.0,
                        child: Slider(
                          value: volume,
                          min: 0,
                          max: 130,
                          divisions: 130 ~/ 5,
                          label: '${volume.round()}%',
                          onChanged: player.setVolume,
                          onChangeStart: (_) =>
                              widget.onInteractionStart?.call(),
                          onChangeEnd: (_) => widget.onInteractionEnd?.call(),
                        ),
                      );
                    },
                  ),
                  const Spacer(),
                  // Toggle Graph Button
                  ValueListenableBuilder<bool>(
                    valueListenable: widget.showFunscriptGraphNotifier,
                    builder: (context, showGraph, child) {
                      return IconButton(
                        icon: Icon(
                          showGraph ? Icons.timeline : Icons.timeline_sharp,
                        ),
                        tooltip: showGraph ? "Hide Graph" : "Show Graph",
                        onPressed: () =>
                            widget.onToggleFunscriptGraph?.call(!showGraph),
                      );
                    },
                  ),
                  // Settings
                  SettingsPopupMenu(
                    onInteractionStart: widget.onInteractionStart,
                    onInteractionEnd: widget.onInteractionEnd,
                  ),
                  const SizedBox(width: 8.0),
                  // Fullscreen Button
                  IconButton(
                    icon: const Icon(Icons.fullscreen),
                    tooltip: "Fullscreen",
                    onPressed: widget.onFullscreenToggle,
                    alignment: AlignmentDirectional.centerEnd,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _hoverExitTimer?.cancel();
    super.dispose();
  }
}
