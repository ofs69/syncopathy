import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/heatmap.dart';
import 'package:syncopathy/model/app_model.dart';
import 'package:syncopathy/model/funscript.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/helper/debouncer.dart';

class VideoControls extends StatefulWidget {
  final VoidCallback onFullscreenToggle;
  final VoidCallback? onInteractionStart;
  final VoidCallback? onInteractionEnd;

  const VideoControls({
    super.key,
    required this.onFullscreenToggle,
    this.onInteractionStart,
    this.onInteractionEnd,
  });

  @override
  State<VideoControls> createState() => _VideoControlsState();
}

class _VideoControlsState extends State<VideoControls> {
  RangeValues minMax = RangeValues(0, 100);
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    final model = context.read<SyncopathyModel>();
    minMax = RangeValues(
      model.settings.min.value.toDouble(),
      model.settings.max.value.toDouble(),
    );

    model.settings.min.addListener(
      () => setState(() {
        minMax = RangeValues(model.settings.min.value.toDouble(), minMax.end);
      }),
    );
    model.settings.max.addListener(
      () => setState(() {
        minMax = RangeValues(minMax.start, model.settings.max.value.toDouble());
      }),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerModel>();
    final model = context.watch<SyncopathyModel>();

    const sliderHeight = 30.0;

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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Play/Pause Button
                  ValueListenableBuilder<bool>(
                    valueListenable: player.paused,
                    builder: (context, isPaused, child) {
                      return IconButton(
                        icon: Icon(isPaused ? Icons.play_arrow : Icons.pause),
                        iconSize: 48.0,
                        onPressed: player.togglePause,
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
                            const Tooltip(
                              message: "Volume",
                              child: Text(
                                "Vol",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            Expanded(
                              child: ValueListenableBuilder<double>(
                                valueListenable: player.volume,
                                builder: (context, volume, child) {
                                  return SizedBox(
                                    height: sliderHeight,
                                    child: Slider(
                                      value: volume,
                                      min: 0,
                                      max: 100,
                                      divisions: 100,
                                      label: '${volume.round()}%',
                                      onChanged: player.setVolume,
                                      onChangeStart: (_) =>
                                          widget.onInteractionStart?.call(),
                                      onChangeEnd: (_) =>
                                          widget.onInteractionEnd?.call(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        // Playback Speed Controls
                        ValueListenableBuilder<bool>(
                          valueListenable: player.paused,
                          builder: (context, isPaused, child) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Tooltip(
                                  message: "Playback Speed",
                                  child: Text(
                                    "Spd",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                                Expanded(
                                  child: ValueListenableBuilder<double>(
                                    valueListenable: player.playbackSpeed,
                                    builder: (context, speed, child) {
                                      return SizedBox(
                                        height: sliderHeight,
                                        child: Slider(
                                          value: speed,
                                          min: 0.5,
                                          max: 2.0,
                                          divisions: 15,
                                          label: '${speed.toStringAsFixed(1)}x',
                                          onChanged: isPaused
                                              ? player.setPlaybackSpeed
                                              : null, // Disable when not paused
                                          onChangeStart: (_) =>
                                              widget.onInteractionStart?.call(),
                                          onChangeEnd: (_) =>
                                              widget.onInteractionEnd?.call(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        // Min/Max Range Slider
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Tooltip(
                              message: "Min/Max Stroke Range",
                              child: Text(
                                "Rng",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                height: sliderHeight,
                                child: RangeSlider(
                                  values: minMax,
                                  min: 0,
                                  max: 100,
                                  divisions: 100,
                                  labels: RangeLabels(
                                    minMax.start.round().toString(),
                                    minMax.end.round().toString(),
                                  ),
                                  onChanged: (values) {
                                    setState(() {
                                      minMax = values;
                                      _debouncer.run(() {
                                        model.settings.setMinMax(
                                          values.start.round(),
                                          values.end.round(),
                                        );
                                      });
                                    });
                                  },
                                  onChangeStart: (_) =>
                                      widget.onInteractionStart?.call(),
                                  onChangeEnd: (_) =>
                                      widget.onInteractionEnd?.call(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Heatmap
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ValueListenableBuilder<Funscript?>(
                        valueListenable: player.funscript,
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
                  const SizedBox(width: 16),
                  // Fullscreen Button
                  IconButton(
                    icon: const Icon(Icons.fullscreen),
                    onPressed: widget.onFullscreenToggle,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
