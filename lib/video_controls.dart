import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/heatmap.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/player/mpv.dart';

class VideoControls extends StatefulWidget {
  final VoidCallback onFullscreenToggle;
  final VoidCallback? onInteractionStart;
  final VoidCallback? onInteractionEnd;
  final Signal<bool>? showFunscriptGraph;
  final Signal<bool>? showSettings;

  const VideoControls({
    super.key,
    required this.onFullscreenToggle,
    this.onInteractionStart,
    this.onInteractionEnd,
    this.showFunscriptGraph,
    this.showSettings,
  });

  @override
  State<VideoControls> createState() => _VideoControlsState();
}

class _VideoControlsState extends State<VideoControls> {
  bool _hovering = false;
  Timer? _hoverEnterTimer;
  Timer? _hoverExitTimer;

  double _lastVolume = 100.0;

  @override
  Widget build(BuildContext context) {
    final player = context.read<MpvVideoplayer>();
    final playerModel = context.read<PlayerModel>();
    final iconSize = Theme.of(context).iconTheme.size ?? 24.0;

    final showFunscriptGraph = widget.showFunscriptGraph;
    final showSettings = widget.showSettings;

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
                        _hoverEnterTimer = Timer(
                          const Duration(milliseconds: 250),
                          () => setState(() => _hovering = true),
                        );
                      },
                      onExit: (_) {
                        _hoverEnterTimer?.cancel();
                        _hoverExitTimer = Timer(
                          const Duration(milliseconds: 500),
                          () => setState(() => _hovering = false),
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeInOut,
                        height: _hovering ? iconSize * 2.5 : iconSize * 1.0,
                        child: Watch.builder(
                          builder: (context) {
                            final funscript =
                                playerModel.currentFunscript.value;

                            final actions = funscript?.actions.value ?? [];
                            return Heatmap(
                              actions: actions,
                              totalDuration: player.duration,
                              videoPosition: player.rawPosition,
                              onClick: (d) => player.seekTo(d),
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
                  // Padding
                  const SizedBox(width: 8.0),
                  // Volume Slider + Mute/Unmute Button
                  Watch.builder(
                    builder: (context) {
                      final volume = player.volume.value;
                      return Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              volume <= 0.1
                                  ? Icons.volume_off
                                  : Icons.volume_up,
                            ),
                            onPressed: () {
                              if (volume <= 0.1) {
                                player.setVolume(_lastVolume);
                              } else {
                                player.setVolume(0.0);
                                _lastVolume = player.volume.value;
                              }
                            },
                          ),
                          SizedBox(
                            width: 150, // Adjust width as needed
                            height: Theme.of(context).iconTheme.size ?? 24.0,
                            child: Slider(
                              padding: EdgeInsets.symmetric(
                                vertical: 0.0,
                                horizontal: 8.0,
                              ),
                              value: volume,
                              min: 0,
                              max: 130,
                              divisions: 130 ~/ 5,
                              label: '${volume.round()}%',
                              onChanged: player.setVolume,
                              onChangeStart: (_) =>
                                  widget.onInteractionStart?.call(),
                              onChangeEnd: (_) =>
                                  widget.onInteractionEnd?.call(),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  // Time / Duration Display
                  Watch.builder(
                    builder: (context) {
                      final currentTime = Duration(
                        milliseconds: (player.rawPosition.value * 1000.0)
                            .toInt(),
                      );
                      final duration = Duration(
                        milliseconds: (player.duration.value * 1000.0).toInt(),
                      );
                      return Text(
                        "${_formatFullTimestamp(currentTime)} / "
                        "${_formatFullTimestamp(duration)}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'monospace',
                        ),
                      );
                    },
                  ),
                  const Spacer(),
                  // Toggle Graph Button
                  showFunscriptGraph != null
                      ? IconButton(
                          icon: Icon(
                            showFunscriptGraph.watch(context)
                                ? Icons.timeline
                                : Icons.timeline_sharp,
                          ),
                          tooltip: showFunscriptGraph.watch(context)
                              ? "Hide Graph"
                              : "Show Graph",
                          onPressed: () => showFunscriptGraph.value =
                              !showFunscriptGraph.value,
                        )
                      : const SizedBox.shrink(),
                  // Settings
                  showSettings != null
                      ? IconButton(
                          onPressed: () =>
                              showSettings.value = !showSettings.value,
                          icon: Icon(
                            showSettings.watch(context)
                                ? Icons.settings
                                : Icons.settings_outlined,
                          ),
                        )
                      : const SizedBox.shrink(),
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
    _hoverEnterTimer?.cancel();
    super.dispose();
  }

  String _formatFullTimestamp(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String threeDigits(int n) => n.toString().padLeft(3, "0");

    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    final ms = threeDigits(duration.inMilliseconds.remainder(1000));

    return "$hours:$minutes:$seconds.$ms";
  }
}
