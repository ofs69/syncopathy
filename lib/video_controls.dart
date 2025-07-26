import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/model/app_model.dart';

class VideoControls extends StatelessWidget {
  const VideoControls({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<SyncopathyModel>();

    // Disable controls if no video is loaded
    final onToggle = model.togglePause;
    final onSpeedChanged = model.setPlaybackSpeed;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
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
                onPressed: onToggle,
              );
            },
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
            child: ValueListenableBuilder(
              valueListenable: model.paused,
              builder: (context, paused, child) {
                return ValueListenableBuilder<double>(
                  valueListenable: model.playbackSpeed,
                  builder: (context, speed, child) {
                    return Slider(
                      value: speed,
                      min: 0.5,
                      max: 2.0,
                      divisions: 15, // (2.0 - 0.5) / 0.1 = 15 steps
                      label: '${speed.toStringAsFixed(1)}x',
                      onChanged: paused ? onSpeedChanged : null,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
