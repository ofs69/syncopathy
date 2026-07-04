import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';

import 'package:syncopathy/helper/constants.dart';
import 'package:syncopathy/model/settings_model.dart';

class HomeButton extends StatefulWidget {
  const HomeButton({super.key});

  @override
  State<HomeButton> createState() => _HomeButtonState();
}

class _HomeButtonState extends State<HomeButton> {
  @override
  Widget build(BuildContext context) {
    final settings = context.read<SettingsModel>();
    final enabled = settings.homeDeviceEnabled.watch(context);
    return Stack(
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
              ? 'Home Mode on — device parked at its rest position, script '
                    'paused. Tap to resume playback.'
              : 'Home Mode — park the device at its rest position and ignore '
                    'the script. Tap to enable.',
        ),
      ],
    );
  }
}
