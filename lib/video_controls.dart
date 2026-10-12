import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/heatmap.dart';
import 'package:syncopathy/helper/constants.dart';
import 'package:syncopathy/helper/extensions.dart';
import 'package:syncopathy/helper/platform_utils.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/player/playback_session.dart';
import 'package:syncopathy/player/video_player.dart';

class VideoControls extends SignalStatefulWidget {
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
  double _lastVolume = _maxVolume;

  // The player's volume scale runs 0..100 rather than 0..1.
  static const double _maxVolume = 100.0;

  // At/below this volume the player is treated as muted.
  static const double _muteThreshold = 0.1;

  @override
  Widget build(BuildContext context) {
    final activeSession = context.read<ActivePlaybackSession>();
    final player = context.read<VideoPlayer>();
    final playerModel = context.read<PlayerModel>();
    final settingsModel = context.read<SettingsModel>();

    final isPortrait = PlatformUtils.isPortrait(context);

    return Material(
      type: MaterialType.transparency,
      child: SignalBuilder(
        builder: (context) {
          // Every clock-bound control is aimed at whichever session owns
          // playback, not at the local player. While an external player is in
          // charge these *are* its controls: the seek bar follows its clock,
          // and a command it will not accept is disabled rather than replaced
          // by a panel explaining that pressing it would do nothing.
          final session = activeSession.session.value;
          final localOwnsPlayback = activeSession.localOwnsPlayback.value;

          return Container(
            padding: const EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 4.0),
            decoration: stdBoxShadow(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 1. Heatmap Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: _buildHeatmapRow(session, playerModel, settingsModel),
                ),

                const SizedBox(height: 8.0),

                // 2. Main Controls Row
                ExcludeFocus(
                  excluding: true,
                  child: Row(
                    children: [
                      // Play/Pause
                      _wrapInContainer(_buildPlayPauseButton(session)),
                      const SizedBox(width: 4),
                      // Audio belongs to the local player, and an external
                      // session has no answer for it. Its state takes the same
                      // slot, so the row keeps its shape either way.
                      _wrapInContainer(
                        localOwnsPlayback
                            ? _buildVolumeSlider(player, isPortrait)
                            : _buildSessionStatus(session),
                      ),
                      const SizedBox(width: 4),

                      // Time Display
                      _wrapInContainer(
                        SignalBuilder(
                          builder: (context) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                _formatResponsiveTimestamp(session, isPortrait),
                                style: GoogleFonts.robotoMono(),
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
                            _buildFunscriptDropdown(playerModel, session),
                            _buildGraphButton(),
                            _buildSettingsButton(),
                            IconButton(
                              icon: const Icon(Icons.fullscreen),
                              tooltip: 'Toggle fullscreen',
                              onPressed: widget.onFullscreenToggle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatResponsiveTimestamp(PlaybackSession session, bool isPortrait) {
    final current = Duration(seconds: session.currentPositionSeconds.value);
    final total = Duration(
      milliseconds: ((session.duration.value ?? 0.0) * 1000.0).toInt(),
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

  Widget _buildPlayPauseButton(PlaybackSession session) {
    return SignalBuilder(
      builder: (context) {
        final paused = session.paused.value;
        final canToggle = session.supports(PlaybackCapability.playPause);
        return IconButton(
          icon: Icon(paused ? Icons.play_arrow : Icons.pause),
          tooltip: canToggle
              ? (paused ? 'Play' : 'Pause')
              : 'Play and pause are in ${session.sessionName}',
          onPressed: canToggle ? session.togglePause : null,
        );
      },
    );
  }

  /// What the session that owns playback is doing, and so whether the device is
  /// being driven at all.
  ///
  /// "Stopped" is never left to be inferred: a stroker that is not moving looks
  /// the same whether that is deliberate or a lost connection, and only one of
  /// those is worth going to fix. It takes the volume slider's slot, which is
  /// free precisely because the local player — whose volume that is — is not
  /// the one playing.
  Widget _buildSessionStatus(PlaybackSession session) {
    return SignalBuilder(
      builder: (context) {
        final name = session.sessionName;
        final (icon, color, label, detail) = switch ((
          session.connected.value,
          session.buffering.value,
          session.paused.value,
        )) {
          (false, _, _) => (
            Icons.link_off,
            Theme.of(context).colorScheme.error,
            'Disconnected',
            '$name is not sending its clock — the device is stopped.',
          ),
          (true, true, _) => (
            Icons.hourglass_top,
            Colors.amber,
            'Buffering',
            '$name is buffering — the device is held.',
          ),
          (true, false, true) => (
            Icons.pause_circle_outline,
            Colors.white70,
            'Paused',
            '$name is paused.',
          ),
          (true, false, false) => (
            Icons.play_circle_outline,
            Colors.lightGreenAccent,
            'Playing',
            'Following $name, driving the device.',
          ),
        };

        return Tooltip(
          message: detail,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 8),
                Text('$name · $label', style: TextStyle(color: color)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeatmapRow(
    PlaybackSession session,
    PlayerModel playerModel,
    SettingsModel settingsModel,
  ) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 24.0,
            child: SignalBuilder(
              builder: (context) {
                final funscript = playerModel.currentlyOpen.value?.funscript;
                final actions = funscript?.processedActions.value ?? [];
                return Heatmap(
                  actions: actions,
                  totalDuration: session.duration,
                  videoPositionFixedStep: session.currentPositionFixedStep,
                  // Seeking is a capability, not a given: an external session
                  // Syncopathy only observes cannot be steered, so the bar
                  // shows the playhead without accepting clicks.
                  onClick: session.supports(PlaybackCapability.seek)
                      ? session.seekTo
                      : null,
                  playbackSpeed: session.playbackSpeed,
                  strokeRange: settingsModel.minMaxRange,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMuteButton(VideoPlayer player) {
    return SignalBuilder(
      builder: (context) {
        final volume = player.volume.value;
        final muted = volume <= _muteThreshold;
        return IconButton(
          icon: Icon(muted ? Icons.volume_off : Icons.volume_up),
          tooltip: muted ? 'Unmute' : 'Mute',
          onPressed: () {
            if (muted) {
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
    final showing = widget.showFunscriptGraph.value;
    return IconButton(
      isSelected: showing,
      icon: const Icon(Icons.show_chart),
      tooltip: showing ? 'Hide funscript graph' : 'Show funscript graph',
      onPressed: () =>
          widget.showFunscriptGraph.value = !widget.showFunscriptGraph.value,
    );
  }

  Widget _buildFunscriptDropdown(
    PlayerModel playerModel,
    PlaybackSession session,
  ) {
    return SignalBuilder(
      builder: (context) {
        final media = session.currentMedia.value;
        if (media == null || media.funscripts.isEmpty) {
          return const SizedBox.shrink();
        }

        final funscripts = media.funscripts;
        if (funscripts.length <= 1) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: playerModel.selectedFunscriptIndex.value,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              dropdownColor: Colors.black87,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              onChanged: (int? newValue) {
                if (newValue != null) {
                  playerModel.selectedFunscriptIndex.value = newValue;
                }
              },
              items: List.generate(funscripts.length, (index) {
                final fs = funscripts[index];
                return DropdownMenuItem<int>(
                  value: index,
                  child: Tooltip(
                    message: fs.fileName,
                    waitDuration: Durations.extralong1,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 150),
                      child: Text(fs.fileName, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingsButton() {
    final showing = widget.showSettings.value;
    return IconButton(
      isSelected: showing,
      icon: Icon(showing ? Icons.settings : Icons.settings_outlined),
      tooltip: showing ? 'Hide settings' : 'Show settings',
      onPressed: () => widget.showSettings.value = !widget.showSettings.value,
    );
  }

  Widget _buildVolumeSlider(VideoPlayer player, bool isPortrait) {
    return SignalBuilder(
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
                  // YouTube-style red volume bar (intentional, not themed).
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
                  max: _maxVolume,
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
