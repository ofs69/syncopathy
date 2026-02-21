import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/helper/extensions.dart';

import 'package:syncopathy/logging.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/update_checker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:syncopathy/notification_feed.dart';

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
        // The Swirl: Only shows when selected
        if (settings.homeDeviceEnabled.watch(context))
          const SizedBox(
            width: 40, // Standard IconButton touch target size
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

    return IconButton(
      isSelected: settings.homeDeviceEnabled.watch(context),
      icon: const Icon(Icons.vertical_align_bottom),
      selectedIcon: const Icon(
        Icons.vertical_align_bottom,
        color: Colors.green,
      ),
      onPressed: () =>
          settings.homeDeviceEnabled.value = !settings.homeDeviceEnabled.value,
      tooltip: 'Home',
    );
  }
}
