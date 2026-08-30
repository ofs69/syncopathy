import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';

import 'package:syncopathy/helper/constants.dart';
import 'package:syncopathy/model/home_target.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/model/settings_model.dart';

class HomeButton extends SignalStatefulWidget {
  const HomeButton({super.key});

  @override
  State<HomeButton> createState() => _HomeButtonState();
}

class _HomeButtonState extends State<HomeButton> {
  /// Picking a target parks the device there right away rather than only
  /// arming it for the next tap — the menu entries read as actions, and
  /// switching ends mid-session is the whole point of having two of them.
  Future<void> _showTargetMenu(Offset globalPosition) async {
    final settings = context.read<SettingsModel>();
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    final selected = await showMenu<HomeTarget>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(globalPosition.dx, globalPosition.dy, 0, 0),
        overlay.localToGlobal(Offset.zero) & overlay.size,
      ),
      elevation: 8.0,
      items: [
        for (final target in HomeTarget.values)
          CheckedPopupMenuItem<HomeTarget>(
            value: target,
            checked: settings.homeTarget.value == target,
            child: Row(
              spacing: 8,
              children: [Icon(_arrowFor(target), size: 16), Text(target.label)],
            ),
          ),
      ],
    );

    if (selected == null) return;
    settings.homeTarget.value = selected;
    settings.homeDeviceEnabled.value = true;
  }

  static IconData _arrowFor(HomeTarget target) =>
      target == HomeTarget.low ? Icons.south : Icons.north;

  @override
  Widget build(BuildContext context) {
    final settings = context.read<SettingsModel>();
    final enabled = settings.homeDeviceEnabled.value;
    final target = settings.homeTarget.value;
    // Parked by "Home on pause" rather than by the user. Tapping still works
    // and takes the park over, which is why the button stays a plain toggle.
    final automatic =
        enabled && context.read<PlayerModel>().autoHomeEngaged.value;
    final activeColor = automatic ? autoHomeColor : successColor;

    return GestureDetector(
      // Both gestures open the same menu: long-press carries over from touch,
      // right-click is what a desktop user reaches for first.
      onLongPressStart: (details) => _showTargetMenu(details.globalPosition),
      onSecondaryTapUp: (details) => _showTargetMenu(details.globalPosition),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // When active, show a static ring — not a spinner, which would imply
          // ongoing work rather than a steady "on" state.
          if (enabled)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: activeColor, width: 2),
              ),
            ),

          // Badge marking an automatic park, so the ring's colour is not the
          // only thing telling the two apart.
          if (automatic)
            Positioned(
              right: 2,
              bottom: 2,
              child: Container(
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: Icon(Icons.pause, size: 11, color: activeColor),
              ),
            ),

          // The Button. The house icon mirrors what the mode does — sends the
          // device "home" — rather than the old plane metaphor.
          IconButton(
            isSelected: enabled,
            icon: const Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: activeColor),
            onPressed: () => settings.homeDeviceEnabled.value = !enabled,
            tooltip: switch ((enabled, automatic)) {
              (true, true) =>
                'Home Mode on automatically — playback is paused, so the '
                    'device is parked at ${target.position}. It is released '
                    'again when playback resumes. Tap to release it now.',
              (true, false) =>
                'Home Mode on — device parked at ${target.position}, script '
                    'paused. Tap to resume playback, long-press or '
                    'right-click to park at ${target.opposite.position}.',
              _ =>
                'Home Mode — park the device at ${target.position} and '
                    'ignore the script. Tap to enable, long-press or '
                    'right-click to choose the other end.',
            },
          ),
        ],
      ),
    );
  }
}
