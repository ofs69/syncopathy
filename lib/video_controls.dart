import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/heatmap.dart';
import 'package:syncopathy/helper/constants.dart';
import 'package:syncopathy/helper/extensions.dart';
import 'package:syncopathy/helper/platform_utils.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/player/video_player.dart';

class VideoControls extends StatefulWidget {
  final VoidCallback? onFullscreenToggle;
  final Signal<bool> showFunscriptGraph;
  final Signal<bool> showSettings;

  const VideoControls({
    super.key,
    required this.onFullscreenToggle,
    required this.showFunscriptGraph,
    required this.showSettings,
  });

  @override
  State<VideoControls> createState() => _VideoControlsState();
}

class _VideoControlsState extends State<VideoControls> {
  Timer? _hoverEnterTimer;
  Timer? _hoverExitTimer;

  double _lastVolume = 100.0;

  @override
  Widget build(BuildContext context) {
    final player = context.read<VideoPlayer>();
    final playerModel = context.read<PlayerModel>();

    final isPortrait = PlatformUtils.isPortrait(context);

    return Material(
      type: MaterialType.transparency,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        decoration: stdBoxShadow(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. Heatmap Row (Remains the same)
            _buildHeatmapRow(player, playerModel),

            const SizedBox(height: 8.0),

            // 2. Main Controls Row
            Row(
              children: [
                // Play/Pause
                _wrapInContainer(
                  Watch.builder(
                    builder: (context) => IconButton(
                      icon: Icon(
                        player.paused.value ? Icons.play_arrow : Icons.pause,
                      ),
                      onPressed: player.togglePause,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                _wrapInContainer(_buildVolumeSlider(player, isPortrait)),
                const SizedBox(width: 4),

                // Time Display
                _wrapInContainer(
                  Watch.builder(
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          _formatResponsiveTimestamp(player, isPortrait),
                          style: const TextStyle(fontFamily: 'monospace'),
                        ),
                      );
                    },
                  ),
                ),

                const Spacer(),

                // Action Buttons
                _wrapInContainer(
                  Row(
                    children: [
                      _buildGraphButton(),
                      _buildSettingsButton(),
                      IconButton(
                        icon: const Icon(Icons.fullscreen),
                        onPressed: widget.onFullscreenToggle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
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

  String _formatResponsiveTimestamp(VideoPlayer player, bool isPortrait) {
    final current = Duration(
      milliseconds: (player.rawPosition.value * 1000.0).toInt(),
    );
    final total = Duration(
      milliseconds: ((player.duration.value ?? 0.0) * 1000.0).toInt(),
    );
    final hasHours = total.inHours >= 1;

    String format(Duration d, bool hasHours) {
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      final hours = twoDigits(d.inHours);
      final mins = twoDigits(d.inMinutes.remainder(60));
      final secs = twoDigits(d.inSeconds.remainder(60));
      String base = hasHours ? "$hours:$mins:$secs" : "$mins:$secs";
      return base;
    }

    return "${format(current, hasHours)} / ${format(total, hasHours)}";
  }

  Widget _buildHeatmapRow(VideoPlayer player, PlayerModel playerModel) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 24.0,
            child: Watch.builder(
              builder: (context) {
                final funscript = playerModel.currentlyOpen.value?.funscript;
                final actions = funscript?.processedActions.value ?? [];
                return Heatmap(
                  actions: actions,
                  totalDuration: player.duration,
                  videoPosition: player.rawPosition,
                  onClick: (d) => player.seekTo(d),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMuteButton(VideoPlayer player) {
    return Watch.builder(
      builder: (context) {
        final volume = player.volume.value;
        return IconButton(
          icon: Icon(volume <= 0.1 ? Icons.volume_off : Icons.volume_up),
          onPressed: () {
            if (volume <= 0.1) {
              player.setVolume(_lastVolume);
            } else {
              _lastVolume = volume;
              player.setVolume(0.0);
            }
          },
        );
      },
    );
  }

  Widget _wrapInContainer(Widget child) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: ShapeDecoration(
        color: Colors.black.withAlphaF(0.25),
        shape: const StadiumBorder(),
      ),
      child: child,
    );
  }

  Widget _buildGraphButton() {
    return IconButton(
      icon: Icon(
        widget.showFunscriptGraph.watch(context)
            ? Icons.timeline
            : Icons.timeline_sharp,
      ),
      onPressed: () =>
          widget.showFunscriptGraph.value = !widget.showFunscriptGraph.value,
    );
  }

  Widget _buildSettingsButton() {
    return IconButton(
      icon: Icon(
        widget.showSettings.watch(context)
            ? Icons.settings
            : Icons.settings_outlined,
      ),
      onPressed: () => widget.showSettings.value = !widget.showSettings.value,
    );
  }

  Widget _buildVolumeSlider(VideoPlayer player, bool isPortrait) {
    return Watch.builder(
      builder: (context) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMuteButton(player),
            SizedBox(
              width: isPortrait ? 75 : 150,
              height: 32,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.redAccent,
                  inactiveTrackColor: Theme.of(
                    context,
                  ).colorScheme.onInverseSurface,
                  thumbColor: Colors.red,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 8.0,
                  ),
                ),
                child: Slider(
                  value: player.volume.value,
                  max: 100,
                  onChanged: player.setVolume,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
