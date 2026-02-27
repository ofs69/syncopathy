import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/focus_numeric_input.dart';
import 'package:syncopathy/helper/extensions.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/player/media_kit_player.dart';

class ScriptPlayerSettingsOverlay extends StatelessWidget {
  final Function toggleSettings;

  const ScriptPlayerSettingsOverlay({super.key, required this.toggleSettings});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      // Prevents the blur from spreading outside the container
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(color: Colors.black.withAlphaF(0.7)),
        alignment: Alignment.topCenter,
        child: DesktopGlassSettings(),
      ),
    );
  }
}

class DesktopGlassSettings extends StatefulWidget {
  const DesktopGlassSettings({super.key});

  @override
  State<DesktopGlassSettings> createState() => _DesktopGlassSettingsState();
}

class _DesktopGlassSettingsState extends State<DesktopGlassSettings> {
  // double _fov = 90;
  // double _volume = 0.75;
  // bool _vsync = true;
  // bool _bloom = false;
  // String _quality = 'Ultra';

  @override
  Widget build(BuildContext context) {
    final cards = [
      _settingsCard(
        width: 450,
        title: 'Funscript',
        children: [
          _buildRdpEpsilonSettings(context),
          _buildSlewRateSettings(context),
          _buildInvertSettings(context),
          _buildRemapFullRangeSettings(context),
        ],
      ),

      _settingsCard(
        width: 450,
        title: 'Stroke Range',
        children: [_buildMinMaxSettings(context)],
      ),

      _settingsCard(
        width: 450,
        title: 'Timing',
        children: [_buildTimingSettings(context)],
      ),

      // Card 1: Video (Multiple Sliders + Switch)
      // _settingsCard(
      //   width: 450,
      //   title: "Graphics & Viewport",
      //   children: [
      //     _rowLabel("Field of View", "${_fov.toInt()}°"),
      //     Slider(
      //       value: _fov,
      //       min: 60,
      //       max: 120,
      //       onChanged: (v) => setState(() => _fov = v),
      //     ),
      //     _rowLabel("Render Scale", "100%"),
      //     const Slider(value: 1.0, onChanged: null), // Disabled example
      //     const Divider(color: Colors.white12, height: 32),
      //     SwitchListTile(
      //       title: const Text(
      //         "Vertical Sync",
      //         style: TextStyle(color: Colors.white, fontSize: 14),
      //       ),
      //       subtitle: const Text(
      //         "Prevents screen tearing",
      //         style: TextStyle(color: Colors.white54, fontSize: 12),
      //       ),
      //       value: _vsync,
      //       onChanged: (v) => setState(() => _vsync = v),
      //       contentPadding: EdgeInsets.zero,
      //     ),
      //   ],
      // ),

      // // Card 2: Audio (Mixed Input Types)
      // _settingsCard(
      //   width: 380,
      //   title: "Audio Engine",
      //   children: [
      //     _rowLabel("Master Volume", "${(_volume * 100).toInt()}%"),
      //     Slider(value: _volume, onChanged: (v) => setState(() => _volume = v)),
      //     const SizedBox(height: 16),
      //     _rowLabel("Dynamic Range", ""),
      //     DropdownButton<String>(
      //       value: _quality,
      //       dropdownColor: Colors.grey[900],
      //       isExpanded: true,
      //       underline: Container(height: 1, color: Colors.white24),
      //       style: const TextStyle(color: Colors.white),
      //       items: ['Low', 'Medium', 'High', 'Ultra'].map((String value) {
      //         return DropdownMenuItem<String>(value: value, child: Text(value));
      //       }).toList(),
      //       onChanged: (v) => setState(() => _quality = v!),
      //     ),
      //   ],
      // ),

      // // Card 3: Advanced (Numeric Fields & Toggles)
      // _settingsCard(
      //   width: 320,
      //   title: "Advanced",
      //   children: [
      //     _numericField("Max Frame Rate", "144"),
      //     const SizedBox(height: 12),
      //     _numericField("Gamma Correction", "2.2"),
      //     const SizedBox(height: 20),
      //     _customToggle(
      //       "Post-Processing Bloom",
      //       _bloom,
      //       (v) => setState(() => _bloom = v),
      //     ),
      //   ],
      // ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
        ),
        child: MasonryGridView.count(
          shrinkWrap: true,
          crossAxisCount: (MediaQuery.of(context).size.width / 500.0)
              .clamp(1, 3)
              .toInt(),
          mainAxisSpacing: 24, // Vertical gap between cards
          crossAxisSpacing: 24, // Horizontal gap between
          itemCount: cards.length,
          itemBuilder: (context, index) {
            return cards[index];
          },
        ),
      ),
    );
  }

  Widget _buildSliderWithNumericInput(
    BuildContext context, {
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              label: value.round().toString(),
              onChanged: onChanged,
            ),
          ),
          Expanded(
            flex: 1,
            child: FocusNumericInput(
              value: value,
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRdpEpsilonSettings(BuildContext context) {
    final settings = context.read<SettingsModel>();
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Funscript Simplification (RDP Epsilon)'),
          subtitle: const Text(
            'Reduces the number of points in the funscript. Higher values mean more simplification.',
          ),
          value: settings.rdpEpsilon.watch(context) != null,
          onChanged: (value) {
            settings.rdpEpsilon.value = value ? 7.0 : null;
          },
          secondary: const Icon(Icons.timeline),
          isThreeLine: true,
        ),
        if (settings.rdpEpsilon.watch(context) != null)
          _buildSliderWithNumericInput(
            context,
            value: settings.rdpEpsilon.watch(context)!,
            min: 0,
            max: 50,
            divisions: 50,
            onChanged: (value) {
              settings.rdpEpsilon.value = value;
            },
          ),
      ],
    );
  }

  Widget _buildSlewRateSettings(BuildContext context) {
    final settings = context.read<SettingsModel>();
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Slew Rate Limit'),
          subtitle: const Text(
            'Modify the funscript limiting the rate of change, preventing jerky movements. Measured in percent per second.',
          ),
          value: settings.slewMaxRateOfChange.watch(context) != null,
          onChanged: (value) {
            settings.slewMaxRateOfChange.value = value ? 400 : null;
          },
          secondary: const Icon(Icons.speed),
          isThreeLine: true,
        ),
        if (settings.slewMaxRateOfChange.watch(context) != null)
          _buildSliderWithNumericInput(
            context,
            value: settings.slewMaxRateOfChange.watch(context)!,
            min: 100,
            max: 1000,
            divisions: 90,
            onChanged: (value) {
              settings.slewMaxRateOfChange.value = value;
            },
          ),
      ],
    );
  }

  Widget _buildInvertSettings(BuildContext context) {
    final settings = context.read<SettingsModel>();
    return SwitchListTile(
      title: const Text('Invert'),
      subtitle: const Text('Inverts the funscript actions.'),
      value: settings.invert.watch(context),
      onChanged: (value) {
        settings.invert.value = value;
      },
      secondary: const Icon(Icons.swap_vert),
      isThreeLine: true,
    );
  }

  Widget _buildRemapFullRangeSettings(BuildContext context) {
    final settings = context.read<SettingsModel>();
    return SwitchListTile(
      title: const Text('Remap to Full Range'),
      subtitle: const Text(
        "Remaps the funscript actions to use the full 0-100 range. The Handy will still remap into the range specified by the stroke range setting.",
      ),
      value: settings.remapFullRange.watch(context),
      onChanged: (value) {
        settings.remapFullRange.value = value;
      },
      secondary: const Icon(Icons.fullscreen),
      isThreeLine: true,
    );
  }

  Widget _buildMinMaxSettings(BuildContext context) {
    final settings = context.read<SettingsModel>();
    return Column(
      children: [
        RangeSlider(
          values: settings.minMaxRange.watch(context),
          min: 0,
          max: 100,
          divisions: 100,
          labels: RangeLabels(
            settings.min.value.round().toString(),
            settings.max.value.round().toString(),
          ),
          onChanged: (values) {
            settings.min.value = values.start.toInt();
            settings.max.value = values.end.toInt();
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: FocusNumericInput(
                label: 'Min',
                value: settings.min.watch(context).toDouble(),
                min: 0,
                max: 100,
                onChanged: (value) {
                  settings.min.value = value.toInt();
                  if (settings.min.value > settings.max.value) {
                    settings.max.value = settings.min.value;
                  }
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: FocusNumericInput(
                label: 'Max',
                value: settings.max.watch(context).toDouble(),
                min: 0,
                max: 100,
                onChanged: (value) {
                  settings.max.value = value.toInt();
                  if (settings.max.value < settings.min.value) {
                    settings.min.value = settings.max.value;
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimingSettings(BuildContext context) {
    final settings = context.read<SettingsModel>();
    final player = context.read<MediaKitPlayer>();
    final playerModel = context.read<PlayerModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ListTile(
          leading: Icon(Icons.speed_outlined),
          title: Text('Playback Speed'),
          subtitle: Text('Adjust playback speed while the video is paused.'),
          isThreeLine: true,
        ),
        Slider(
          value: player.playbackSpeed.watch(context),
          min: 0.5,
          max: 2.0,
          divisions: 15,
          label: player.playbackSpeed.watch(context).toStringAsFixed(2),
          onChanged: player.paused.watch(context)
              ? (value) => player.setSpeed(value)
              : null,
        ),

        const ListTile(
          leading: Icon(Icons.timer_outlined),
          title: Text('Timing Offset'),
          subtitle: Text(
            'Adjusts the timing of the script. A positive value makes actions happen earlier, a negative value makes them happen later. Change is applied immediately.',
          ),
          isThreeLine: true,
        ),
        _buildSliderWithNumericInput(
          context,
          value: settings.offsetMs.watch(context).toDouble(),
          min: -500,
          max: 500,
          divisions: 200,
          onChanged: (value) {
            settings.offsetMs.value = value.toInt();
          },
        ),
        Watch.builder(
          builder: (context) {
            final currentDelta =
                playerModel.playerBackend.value?.playbackDelta.value;
            if (currentDelta == null) return const SizedBox.shrink();
            return ListTile(
              leading: const Icon(Icons.timer_outlined),
              title: Text('Playback Delta: $currentDelta ms'),
              subtitle: const Text(
                "This is calculated by taking the current video player time and subtracting the current time the handy sends back.\nTake this with a grain of salt but it's useful for tweaking the time offset.",
              ),
              isThreeLine: true,
            );
          },
        ),
      ],
    );
  }

  Widget _settingsCard({
    required double width,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withAlphaF(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withAlphaF(0.15), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Height scales with content
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  // Widget _rowLabel(String label, String value) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Text(
  //         label,
  //         style: const TextStyle(color: Colors.white70, fontSize: 14),
  //       ),
  //       Text(
  //         value,
  //         style: const TextStyle(
  //           color: Colors.white,
  //           fontWeight: FontWeight.w600,
  //           fontSize: 14,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _numericField(String label, String initial) {
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: Text(
  //           label,
  //           style: const TextStyle(color: Colors.white70, fontSize: 14),
  //         ),
  //       ),
  //       SizedBox(
  //         width: 60,
  //         child: TextField(
  //           controller: TextEditingController(text: initial),
  //           textAlign: TextAlign.right,
  //           style: const TextStyle(color: Colors.white, fontSize: 14),
  //           decoration: const InputDecoration(
  //             isDense: true,
  //             enabledBorder: UnderlineInputBorder(
  //               borderSide: BorderSide(color: Colors.white24),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _customToggle(String label, bool value, Function(bool) onChanged) {
  //   return InkWell(
  //     onTap: () => onChanged(!value),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(
  //           label,
  //           style: const TextStyle(color: Colors.white, fontSize: 14),
  //         ),
  //         Checkbox(
  //           value: value,
  //           onChanged: (v) => onChanged(v!),
  //           side: const BorderSide(color: Colors.white38),
  //           activeColor: Colors.white,
  //           checkColor: Colors.black,
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
