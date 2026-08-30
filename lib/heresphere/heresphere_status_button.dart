import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/heresphere/heresphere_controller.dart';
import 'package:syncopathy/heresphere/heresphere_server.dart';
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/model/settings_model.dart';

/// HereSphere's state, in the app bar, from every tab.
///
/// The playback overlay only covers the player page, so with the media library
/// or settings open there was nothing at all to say a headset had taken over —
/// which reads as the feature not working. This is deliberately always visible
/// while the feature is on, including when nothing is playing: "the server is
/// up and idle" and "the server never started" look identical otherwise.
class HereSphereStatusButton extends StatelessWidget {
  const HereSphereStatusButton({super.key});

  /// The controller, or null in a build that has none — simple mode, or web.
  static HereSphereController? get _controller =>
      getIt.isRegistered<HereSphereController>()
      ? getIt.get<HereSphereController>()
      : null;

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller == null) return const SizedBox.shrink();
    final settings = context.read<SettingsModel>();

    return SignalBuilder(
      builder: (context) {
        if (!settings.hereSphereEnabled.value) return const SizedBox.shrink();
        final status = _Status.of(controller, settings);

        return MenuAnchor(
          menuChildren: [_detail(context, controller, settings, status)],
          builder: (context, menu, _) => IconButton(
            icon: Icon(status.icon, color: status.color(context)),
            tooltip: status.tooltip,
            onPressed: () => menu.isOpen ? menu.close() : menu.open(),
          ),
        );
      },
    );
  }

  Widget _detail(
    BuildContext context,
    HereSphereController controller,
    SettingsModel settings,
    _Status status,
  ) {
    final theme = Theme.of(context);
    final session = controller.session;
    final media = session.currentMedia.value;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('HereSphere', style: theme.textTheme.titleSmall),
            const SizedBox(height: 4),
            Text(status.tooltip, style: theme.textTheme.bodyMedium),
            if (media != null) ...[
              const SizedBox(height: 12),
              Text(
                media.name,
                style: theme.textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                _position(session.smoothPosition.value, session.duration.value),
                style: theme.textTheme.bodySmall?.copyWith(
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
            if (status.detail != null) ...[
              const SizedBox(height: 12),
              Text(
                status.detail!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Text(
              controller.server.activeSessions.value == 1
                  ? '1 signed-in device'
                  : '${controller.server.activeSessions.value} signed-in '
                        'devices',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  static String _position(double position, double? duration) {
    final elapsed = _clock(position);
    return duration == null || duration <= 0
        ? elapsed
        : '$elapsed / ${_clock(duration)}';
  }

  static String _clock(double seconds) {
    final total = seconds.isFinite && seconds > 0 ? seconds.round() : 0;
    final minutes = (total ~/ 60).toString().padLeft(2, '0');
    final rest = (total % 60).toString().padLeft(2, '0');
    final hours = total ~/ 3600;
    return hours > 0
        ? '$hours:${(total ~/ 60 % 60).toString().padLeft(2, '0')}:$rest'
        : '$minutes:$rest';
  }
}

/// The one thing the button is saying, resolved from every signal that feeds
/// it. Kept apart from the widget so the precedence between "playing" and
/// "broken" is stated once: a fault always wins, because a stroker that has
/// silently stopped is the case the user needs to see.
class _Status {
  final IconData icon;
  final String tooltip;
  final String? detail;
  final _Severity severity;

  const _Status(this.icon, this.tooltip, {this.detail, required this.severity});

  Color? color(BuildContext context) => switch (severity) {
    _Severity.fault => Theme.of(context).colorScheme.error,
    _Severity.active => Theme.of(context).colorScheme.primary,
    _Severity.idle => null,
  };

  static _Status of(HereSphereController controller, SettingsModel settings) {
    final server = controller.server;

    if (server.state.value == HereSphereServerState.failed) {
      return _Status(
        Icons.error_outline,
        'HereSphere server failed to start',
        detail: server.lastError.value,
        severity: _Severity.fault,
      );
    }
    if (server.state.value != HereSphereServerState.running) {
      return const _Status(
        Icons.vrpano_outlined,
        'HereSphere server is starting',
        severity: _Severity.idle,
      );
    }

    // Nothing is signed in until a password exists, so say that rather than
    // reporting an idle server that in fact cannot be used.
    if (!settings.hereSphereHasPassword.value) {
      return const _Status(
        Icons.lock_outline,
        'HereSphere is running but has no password set, so no headset can '
        'sign in',
        severity: _Severity.fault,
      );
    }

    if (!settings.hereSphereDeviceOwner.value.drivesDevice) {
      return const _Status(
        Icons.vrpano_outlined,
        'HereSphere is serving the library and driving the device itself',
        severity: _Severity.idle,
      );
    }

    if (!controller.externalPlaybackActive.value) {
      return const _Status(
        Icons.vrpano_outlined,
        'HereSphere is connected. Nothing is playing yet.',
        severity: _Severity.idle,
      );
    }

    // Playing, so the only remaining question is whether the clock that drives
    // the device is actually arriving.
    if (!controller.session.connected.value) {
      return _Status(
        Icons.vrpano,
        'HereSphere is playing, but the timestamp channel is not connected — '
        'the device is stopped',
        detail:
            controller.timestamps.lastError.value ??
            'Check the HereSphere address under Settings.',
        severity: _Severity.fault,
      );
    }

    return const _Status(
      Icons.vrpano,
      'HereSphere is playing and driving the device',
      severity: _Severity.active,
    );
  }
}

enum _Severity { idle, active, fault }
