import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/heatmap.dart';
import 'package:syncopathy/heresphere/heresphere_controller.dart';
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/player/playback_session.dart';

/// Covers the player page while HereSphere owns playback.
///
/// Two jobs. It says plainly who is in charge, which is otherwise invisible —
/// the local player sits idle with no video in it and every local control does
/// nothing. And it reports whether the device is actually being driven, since
/// the answer depends on a network connection the user cannot see.
///
/// Covering the surface *is* the way local controls are disabled: they belong
/// to a player that is not the one playing, and offering them would be offering
/// buttons that quietly do nothing.
class HereSpherePlaybackOverlay extends StatelessWidget {
  const HereSpherePlaybackOverlay({super.key});

  /// The controller, or null in a build that has none — simple mode, or web.
  ///
  /// Read from the service locator rather than the widget tree: the provider
  /// only exists in some builds, and a missing `Provider` throws rather than
  /// returning null.
  static HereSphereController? get _controller =>
      getIt.isRegistered<HereSphereController>()
      ? getIt.get<HereSphereController>()
      : null;

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller == null) return const SizedBox.shrink();

    return SignalBuilder(
      builder: (context) {
        if (!controller.externalPlaybackActive.value) {
          return const SizedBox.shrink();
        }
        return _panel(context, controller);
      },
    );
  }

  Widget _panel(BuildContext context, HereSphereController controller) {
    final theme = Theme.of(context);
    final session = controller.session;
    final media = session.currentMedia.value;
    final connected = session.connected.value;
    final buffering = session.buffering.value;
    final paused = session.paused.value;

    return Positioned.fill(
      child: ColoredBox(
        color: Colors.black.withValues(alpha: 0.88),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.vrpano, size: 40, color: Colors.white70),
                  const SizedBox(height: 12),
                  Text(
                    'HereSphere is playing',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    media?.name ?? 'Unknown media',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _timestamp(
                      session.smoothPosition.value,
                      session.duration.value,
                    ),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _heatmap(context, controller),
                  const SizedBox(height: 16),
                  _deviceStatus(
                    context,
                    connected: connected,
                    buffering: buffering,
                    paused: paused,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    session.supports(PlaybackCapability.seek)
                        ? 'Click the heatmap to seek. Everything else is in '
                              'the headset while HereSphere owns the video.'
                        : 'Playback controls are in the headset while '
                              'HereSphere owns the video.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// The script being played, with the playhead on it.
  ///
  /// The real answer to "is anything happening": a name and a clock could both
  /// be stale, but a heatmap with the marker travelling across it is the
  /// funscript pipeline visibly running on HereSphere's clock. It is the same
  /// widget the local player's seek bar uses, driven from the session that owns
  /// playback rather than from the idle local player under this overlay.
  Widget _heatmap(BuildContext context, HereSphereController controller) {
    final playerModel = context.read<PlayerModel>();
    final settings = context.read<SettingsModel>();
    final session = controller.session;

    final funscript = playerModel.currentlyOpen.value?.funscript;
    if (funscript == null) {
      return Text(
        'No funscript loaded for this entry.',
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: Colors.white54),
      );
    }

    return SizedBox(
      height: 40,
      child: Heatmap(
        actions: funscript.processedActions.value,
        totalDuration: session.duration,
        videoPositionFixedStep: session.currentPositionFixedStep,
        playbackSpeed: session.playbackSpeed,
        strokeRange: settings.minMaxRange,
        // Seeking is a capability, not a given: without remote control enabled
        // this session cannot steer the player, and a bar that silently
        // swallows clicks is worse than one that does not accept them.
        onClick: session.supports(PlaybackCapability.seek)
            ? session.seekTo
            : (_) {},
      ),
    );
  }

  /// Says whether the device is being driven, and if not, why not.
  ///
  /// "Stopped" is never left to be inferred: a stroker that is not moving looks
  /// the same whether that is deliberate or a connection failure, and only one
  /// of those is worth going to fix.
  Widget _deviceStatus(
    BuildContext context, {
    required bool connected,
    required bool buffering,
    required bool paused,
  }) {
    final theme = Theme.of(context);
    final (icon, color, label) = switch ((connected, buffering, paused)) {
      (false, _, _) => (
        Icons.link_off,
        theme.colorScheme.error,
        'No timestamp connection — the device is stopped.',
      ),
      (true, true, _) => (
        Icons.hourglass_top,
        Colors.amber,
        'HereSphere is buffering — the device is held.',
      ),
      (true, false, true) => (
        Icons.pause_circle_outline,
        Colors.white70,
        'Paused.',
      ),
      (true, false, false) => (
        Icons.play_circle_outline,
        Colors.lightGreenAccent,
        'Following HereSphere, driving the device.',
      ),
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(color: color),
          ),
        ),
      ],
    );
  }

  static String _timestamp(double positionSeconds, double? durationSeconds) {
    final position = Duration(milliseconds: (positionSeconds * 1000).round());
    final total = Duration(
      milliseconds: ((durationSeconds ?? 0) * 1000).round(),
    );
    final hasHours = total.inHours >= 1;

    String format(Duration d) {
      String two(int n) => n.toString().padLeft(2, '0');
      final mins = two(d.inMinutes.remainder(60));
      final secs = two(d.inSeconds.remainder(60));
      return hasHours ? '${two(d.inHours)}:$mins:$secs' : '$mins:$secs';
    }

    return '${format(position)} / ${format(total)}';
  }
}
