import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';

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
    return Stack(
      alignment: Alignment.center,
      children: [
        // When active display an animation
        if (settings.homeDeviceEnabled.watch(context))
          const SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ),

        // The Button
        IconButton(
          isSelected: settings.homeDeviceEnabled.watch(context),
          icon: const Icon(Icons.flight_takeoff),
          selectedIcon: const Icon(Icons.flight_land, color: Colors.green),
          onPressed: () => settings.homeDeviceEnabled.value =
              !settings.homeDeviceEnabled.value,
          tooltip: 'Home Mode',
        ),
      ],
    );
  }
}
