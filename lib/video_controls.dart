import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/heatmap.dart';
import 'package:syncopathy/model/app_model.dart';

class VideoControls extends StatefulWidget {
  final bool isFullscreen;
  final VoidCallback onFullscreenToggle;

  const VideoControls({
    super.key,
    required this.isFullscreen,
    required this.onFullscreenToggle,
  });

  @override
  State<VideoControls> createState() => _VideoControlsState();
}

class _VideoControlsState extends State<VideoControls> {
  @override
  Widget build(BuildContext context) {
    final model = context.watch<SyncopathyModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Play/Pause Button
              ValueListenableBuilder<bool>(
                valueListenable: model.paused,
                builder: (context, isPaused, child) {
                  return IconButton(
                    icon: Icon(isPaused ? Icons.play_arrow : Icons.pause),
                    iconSize: 48.0,
                    onPressed: model.togglePause,
                  );
                },
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 200, // Smaller width for sliders
                child: Column(
                  children: [
                    // Volume Slider
                    Row(
                      children: [
                        Tooltip(
                          message: "Volume",
                          child: const Text(
                            "Vol",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        Expanded(
                          child: ValueListenableBuilder<double>(
                            valueListenable: model.volume,
                            builder: (context, volume, child) {
                              return Slider(
                                value: volume,
                                min: 0,
                                max: 100,
                                divisions: 100,
                                label: '${volume.round()}%',
                                onChanged: model.setVolume,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    // Playback Speed Controls
                    ValueListenableBuilder<bool>(
                      valueListenable: model.paused,
                      builder: (context, isPaused, child) {
                        return Row(
                          children: [
                            Tooltip(
                              message: "Playback Speed",
                              child: const Text(
                                "Spd",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            Expanded(
                              child: ValueListenableBuilder<double>(
                                valueListenable: model.playbackSpeed,
                                builder: (context, speed, child) {
                                  return Slider(
                                    value: speed,
                                    min: 0.5,
                                    max: 2.0,
                                    divisions: 15,
                                    label: '${speed.toStringAsFixed(1)}x',
                                    onChanged: isPaused
                                        ? model.setPlaybackSpeed
                                        : null, // Disable when not paused
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Heatmap
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ValueListenableBuilder(
                    valueListenable: model.funscript,
                    builder: (context, funscript, child) {
                      if (funscript == null) {
                        return const Center(child: Text("No funscript loaded"));
                      }
                      return Heatmap(
                        funscript: funscript,
                        totalDuration: model.duration,
                        videoPosition: model.positionNoOffset,
                        onClick: (d) => model.seekTo(d.inSeconds.toDouble()),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Fullscreen Button
              IconButton(
                icon: Icon(
                  widget.isFullscreen
                      ? Icons.fullscreen_exit
                      : Icons.fullscreen,
                ),
                onPressed: widget.onFullscreenToggle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
