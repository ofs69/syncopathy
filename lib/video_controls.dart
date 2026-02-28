import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/heatmap.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/player/media_kit_player.dart';

class VideoControls extends StatefulWidget {
  final VoidCallback? onFullscreenToggle;
  final VoidCallback? onInteractionStart;
  final VoidCallback? onInteractionEnd;
  final Signal<bool>? showFunscriptGraph;
  final Signal<bool>? showSettings;

  const VideoControls({
    super.key,
    this.onFullscreenToggle,
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
    final player = context.read<MediaKitPlayer>();
    final playerModel = context.read<PlayerModel>();
    final iconSize = Theme.of(context).iconTheme.size ?? 24.0;

    // Use a breakpoint to detect mobile
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Material(
      type: MaterialType.transparency,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black87, Colors.transparent],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. Heatmap Row (Remains the same)
            _buildHeatmapRow(player, playerModel, iconSize),

            const SizedBox(height: 4.0),

            // 2. Main Controls Row
            Row(
              children: [
                // Play/Pause
                Watch.builder(
                  builder: (context) => IconButton(
                    icon: Icon(
                      player.paused.value ? Icons.play_arrow : Icons.pause,
                    ),
                    onPressed: player.togglePause,
                  ),
                ),

                _buildVolumeSlider(player),

                const SizedBox(width: 4.0),

                // Time Display - Simplified for Mobile
                Watch.builder(
                  builder: (context) {
                    return Text(
                      _formatResponsiveTimestamp(player, isMobile),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                    );
                  },
                ),

                const Spacer(),

                // Action Buttons
                if (widget.showFunscriptGraph != null) _buildGraphButton(),
                if (widget.showSettings != null) _buildSettingsButton(),

                IconButton(
                  icon: const Icon(Icons.fullscreen),
                  onPressed: widget.onFullscreenToggle,
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

  String _formatResponsiveTimestamp(MediaKitPlayer player, bool isMobile) {
    final current = Duration(
      milliseconds: (player.rawPosition.value * 1000).toInt(),
    );
    final total = Duration(
      milliseconds: (player.duration.value * 1000).toInt(),
    );

    String format(Duration d) {
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      final hours = d.inHours;
      final mins = twoDigits(d.inMinutes.remainder(60));
      final secs = twoDigits(d.inSeconds.remainder(60));

      // Hide milliseconds on mobile, hide hours if video is short
      String base = hours > 0 ? "$hours:$mins:$secs" : "$mins:$secs";
      if (!isMobile) {
        final ms = d.inMilliseconds.remainder(1000).toString().padLeft(3, "0");
        return "$base.$ms";
      }
      return base;
    }

    return "${format(current)} / ${format(total)}";
  }

  Widget _buildHeatmapRow(
    MediaKitPlayer player,
    PlayerModel playerModel,
    double iconSize,
  ) {
    return Row(
      children: [
        Expanded(
          child: MouseRegion(
            onEnter: (_) => setState(() => _hovering = true),
            onExit: (_) => setState(() => _hovering = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              height: _hovering ? iconSize * 2.5 : iconSize * 1.0,
              child: Watch.builder(
                builder: (context) {
                  final funscript = playerModel.currentFunscript.value;
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
    );
  }

  Widget _buildMuteButton(MediaKitPlayer player) {
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

  Widget _buildGraphButton() {
    return IconButton(
      icon: Icon(
        widget.showFunscriptGraph!.watch(context)
            ? Icons.timeline
            : Icons.timeline_outlined,
      ),
      onPressed: () =>
          widget.showFunscriptGraph!.value = !widget.showFunscriptGraph!.value,
    );
  }

  Widget _buildSettingsButton() {
    return IconButton(
      icon: Icon(
        widget.showSettings!.watch(context)
            ? Icons.settings
            : Icons.settings_outlined,
      ),
      onPressed: () => widget.showSettings!.value = !widget.showSettings!.value,
    );
  }

  Widget _buildVolumeSlider(MediaKitPlayer player) {
    return Watch.builder(
      builder: (context) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMuteButton(player),
            SizedBox(
              width: 75,
              child: Slider(
                padding: EdgeInsets.fromLTRB(4.0, 0.0, 16.0, 0.0),
                value: player.volume.value,
                max: 100,
                onChanged: player.setVolume,
              ),
            ),
          ],
        );
      },
    );
  }
}
