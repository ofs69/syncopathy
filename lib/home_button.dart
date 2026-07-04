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

        // The Button
        IconButton(
          isSelected: enabled,
          icon: const Icon(Icons.flight_takeoff),
          selectedIcon: Icon(Icons.flight_land, color: successColor),
          onPressed: () =>
              settings.homeDeviceEnabled.value = !enabled,
          tooltip: enabled ? 'Home Mode is on — tap to turn off' : 'Home Mode — tap to turn on',
        ),
      ],
    );
  }
}
