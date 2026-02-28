import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/player/player_backend_type.dart';
import 'package:flutter/foundation.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final isUpdateCheckingSignal = signal<bool>(false);
  final statusUpdateMessageSignal = signal<String?>(null);

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final allCards = _buildAllSettingsCards(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.0),
      child: MasonryGridView.count(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: (MediaQuery.of(context).size.width / 500.0)
            .clamp(1, 3)
            .toInt(),
        itemCount: allCards.length,
        mainAxisSpacing: 24, // Vertical gap between cards
        crossAxisSpacing: 24, // Horizontal gap between
        itemBuilder: (context, index) {
          return allCards[index];
        },
      ),
    );
  }

  List<Widget> _buildAllSettingsCards(BuildContext context) {
    return [
      _buildSettingsCard(
        context,
        title: 'Player Backend',
        children: [_buildPlayerBackendSettings(context)],
      ),
      _buildSettingsCard(
        context,
        title: 'Video Player',
        children: [_buildSkipToActionSettings(context)],
      ),
      if (kDebugMode)
        _buildSettingsCard(
          context,
          title: 'Debug',
          children: [_buildDebugSettings(context)],
        ),
    ];
  }

  Widget _buildSettingsCard(
    BuildContext context, {
    required String title,
    String? subtitle,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            ],
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSkipToActionSettings(BuildContext context) {
    final settings = context.read<SettingsModel>();
    return SwitchListTile(
      title: const Text('Skip to action'),
      subtitle: const Text('Skips to the part where the funscript begins.'),
      value: settings.skipToAction.watch(context),
      onChanged: (value) {
        settings.skipToAction.value = value;
      },
      secondary: const Icon(Icons.skip_next),
    );
  }

  Widget _buildDebugSettings(BuildContext context) {
    final settings = context.read<SettingsModel>();
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Toggle debug notifications'),
          subtitle: const Text(
            'Shows extra notifications with debug information.',
          ),
          value: settings.showDebugNotifications.value,
          onChanged: (value) {
            settings.showDebugNotifications.value = value;
          },
          secondary: const Icon(Icons.bug_report),
        ),
      ],
    );
  }

  Widget _buildPlayerBackendSettings(BuildContext context) {
    final settings = context.read<SettingsModel>();
    final playerModel = context.read<PlayerModel>();
    final backend = playerModel.playerBackend.watch(context);

    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 0.0,
          ),
          title: DropdownButton<String>(
            value: settings.playerBackendType.watch(context).toString(),
            underline: const SizedBox.shrink(), // Hides the default underline
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            borderRadius: BorderRadius.circular(16.0),
            isExpanded: true,
            items: PlayerBackendType.values
                .map(
                  (e) => DropdownMenuItem<String>(
                    value: e.toString(),
                    child: Text(e.toDisplayString()),
                  ),
                )
                .toList(),
            onChanged: (selected) {
              final selectedEnum = PlayerBackendType.values.firstWhere(
                (e) => e.toString() == selected,
              );
              settings.playerBackendType.value = selectedEnum;
            },
          ),
        ),
        if (backend != null) ListTile(title: backend.settingsWidget(context)),
      ],
    );
  }
}
