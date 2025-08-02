import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/heatmap.dart';
import 'package:syncopathy/model/app_model.dart';

class VideoControls extends StatelessWidget {
  final bool isFullscreen;
  final VoidCallback onFullscreenToggle;

  const VideoControls({
    super.key,
    required this.isFullscreen,
    required this.onFullscreenToggle,
  });

  @override
  Widget build(BuildContext context) {
    final model = context.watch<SyncopathyModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          SizedBox(
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
              const SizedBox(width: 24),
              // Volume Slider
              const Text("Volume"),
              Expanded(
                child: ValueListenableBuilder<double>(
                  valueListenable: model.volume,
                  builder: (context, volume, child) {
                    return Slider(
                      value: volume,
                      min: 0,
                      max: 100,
                      onChanged: model.setVolume,
                    );
                  },
                ),
              ),
              const SizedBox(width: 24),
              // Playback Speed Controls
              ValueListenableBuilder<double>(
                valueListenable: model.playbackSpeed,
                builder: (context, speed, child) {
                  return Text('Speed: ${speed.toStringAsFixed(1)}x');
                },
              ),
              Expanded(
                child: ValueListenableBuilder<double>(
                  valueListenable: model.playbackSpeed,
                  builder: (context, speed, child) {
                    return Slider(
                      value: speed,
                      min: 0.5,
                      max: 2.0,
                      divisions: 15, // (2.0 - 0.5) / 0.1 = 15 steps
                      label: '${speed.toStringAsFixed(1)}x',
                      onChanged: model.setPlaybackSpeed,
                    );
                  },
                ),
              ),
              // Fullscreen Button
              IconButton(
                icon: Icon(
                  isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
                ),
                onPressed: onFullscreenToggle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
