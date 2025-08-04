import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Text(
            'Help & Shortcuts',
            style: Theme.of(
              context,
            ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'General Information',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Syncopathy is a desktop application designed to synchronize video playback with external devices. It provides a clean interface for managing your media library and visualizing funscripts.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),

                    const SizedBox(height: 48),
                    Text(
                      'Getting Started',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'To begin, navigate to the "Settings" tab (accessible via the \'3\' shortcut or by clicking the gear icon). Under "Media Library Paths", add the directories where your video and funscript files are stored. Syncopathy will automatically scan these directories for compatible media.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Video Players',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoPoint(
                          context,
                          'Embedded Player: This MPV-based player is integrated directly into the application and is currently only available on Windows. It offers the same core video playback functionality as the external player. You can enable or disable the embedded player in the settings.',
                        ),
                        _buildInfoPoint(
                          context,
                          'External Player: When the embedded player is disabled, Syncopathy will utilize an external MPV player. This option offers the same core video playback functionality as the embedded player, but is available across all supported platforms. To use it, ensure MPV is installed on your system and disable the embedded player in the settings.',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available Shortcuts',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildShortcutItem(
                      context,
                      Icons.space_bar,
                      'Toggle video playback (Play/Pause)',
                      'Spacebar',
                    ),
                    _buildShortcutItem(
                      context,
                      Icons.looks_one,
                      'Switch to Media tab',
                      '1',
                    ),
                    _buildShortcutItem(
                      context,
                      Icons.looks_two,
                      'Switch to Video Player tab',
                      '2',
                    ),
                    _buildShortcutItem(
                      context,
                      Icons.looks_3,
                      'Switch to Settings tab',
                      '3',
                    ),
                    _buildShortcutItem(
                      context,
                      Icons.looks_4,
                      'Switch to Help tab',
                      '4',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShortcutItem(
    BuildContext context,
    IconData icon,
    String title,
    String shortcut,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 28),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              Text(
                shortcut,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPoint(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}
