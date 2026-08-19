import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';

import 'package:syncopathy/helper/constants.dart';
import 'package:syncopathy/model/home_target.dart';
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
                border: Border.all(color: successColor, width: 2),
              ),
            ),

          // The Button. The house icon mirrors what the mode does — sends the
          // device "home" — rather than the old plane metaphor.
          IconButton(
            isSelected: enabled,
            icon: const Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: successColor),
            onPressed: () => settings.homeDeviceEnabled.value = !enabled,
            tooltip: enabled
                ? 'Home Mode on — device parked at ${target.position}, script '
                      'paused. Tap to resume playback, long-press or '
                      'right-click to park at ${target.opposite.position}.'
                : 'Home Mode — park the device at ${target.position} and '
                      'ignore the script. Tap to enable, long-press or '
                      'right-click to choose the other end.',
          ),
        ],
      ),
    );
  }
}
