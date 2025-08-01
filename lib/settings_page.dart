import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/helper/debouncer.dart';
import 'package:syncopathy/model/app_model.dart';
import 'package:syncopathy/logging.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late double _currentMin;
  late double _currentMax;
  late double _currentOffsetMs;

  late double _currentRdpEpsilon;
  late bool _rdpEpsilonEnabled;
  late bool _skipToAction;
  late double _currentSlewMaxRateOfChange;
  late bool _slewMaxRateOfChangeEnabled;
  late bool _remapFullRange;

  late final SyncopathyModel _model;
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _model = context.read<SyncopathyModel>();
    _model.settings.addListener(_onSettingsChanged);
    _updateStateFromSettings();
  }

  @override
  void dispose() {
    _model.settings.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onSettingsChanged() {
    if (mounted) {
      setState(_updateStateFromSettings);
    }
  }

  void _updateStateFromSettings() {
    _currentMin = _model.settings.min.toDouble();
    _currentMax = _model.settings.max.toDouble();
    _currentOffsetMs = _model.settings.offsetMs.toDouble();
    _currentRdpEpsilon = _model.settings.rdpEpsilon ?? 15.0;
    _rdpEpsilonEnabled = _model.settings.rdpEpsilon != null;
    _currentSlewMaxRateOfChange = _model.settings.slewMaxRateOfChange ?? 400.0;
    _slewMaxRateOfChangeEnabled = _model.settings.slewMaxRateOfChange != null;
    _remapFullRange = _model.settings.remapFullRange;
    _skipToAction = _model.settings.skipToAction;
  }

  Future<void> _addPath() async {
    final String? selectedDirectory = await FilePicker.platform
        .getDirectoryPath();

    if (selectedDirectory != null) {
      await _model.settings.addPath(selectedDirectory);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Added path: $selectedDirectory')));
    }
  }

  void _saveSettings() {
    final currentMin = _currentMin.round();
    final currentMax = _currentMax.round();

    final currentOffset = _currentOffsetMs.round();
    final currentRdpEpsilon = _rdpEpsilonEnabled ? _currentRdpEpsilon : null;
    final currentSlewRate = _slewMaxRateOfChangeEnabled
        ? _currentSlewMaxRateOfChange
        : null;
    final remapFullRange = _remapFullRange;
    final skipToAction = _skipToAction;

    _model.settings.setMinMax(currentMin, currentMax);
    _model.settings.setOffsetMs(currentOffset);
    _model.settings.setRdpEpsilon(currentRdpEpsilon);
    _model.settings.setSlewMaxRateOfChange(currentSlewRate);
    _model.settings.setRemapFullRange(remapFullRange);
    _model.settings.setSkipToAction(skipToAction);
    Logger.info('Settings saved.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool useTwoColumns = constraints.maxWidth > 600;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: useTwoColumns
                      ? _buildTwoColumnLayout(context)
                      : _buildSingleColumnLayout(context),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSingleColumnLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSettingsCard(
          context,
          title: 'Media Library Paths',
          subtitle:
              'Folders to search for videos and funscripts (searched recursively).',
          children: [_buildMediaPaths(context)],
        ),
        const SizedBox(height: 16),
        _buildSettingsCard(
          context,
          title: 'Funscript Processing',
          children: [
            _buildRdpEpsilonSettings(context),
            const Divider(),
            _buildSlewRateSettings(context),
            const Divider(),
            _buildRemapFullRangeSettings(context),
            const Divider(),
            _buildSkipToActionSettings(context),
          ],
        ),
        const SizedBox(height: 16),
        _buildSettingsCard(
          context,
          title: 'Stroke Range',
          subtitle:
              "The min/max stroke length as a percentage of the device's full range.",
          children: [_buildMinMaxSettings(context)],
        ),
        const SizedBox(height: 16),
        _buildSettingsCard(
          context,
          title: 'Timing',
          children: [_buildOffsetSettings(context)],
        ),
      ],
    );
  }

  Widget _buildTwoColumnLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSettingsCard(
                context,
                title: 'Media Library Paths',
                subtitle:
                    'Folders to search for videos and funscripts (searched recursively).',
                children: [_buildMediaPaths(context)],
              ),
              const SizedBox(height: 16),
              _buildSettingsCard(
                context,
                title: 'Funscript Processing',
                children: [
                  _buildRdpEpsilonSettings(context),
                  const Divider(),
                  _buildSlewRateSettings(context),
                  const Divider(),
                  _buildRemapFullRangeSettings(context),
                  const Divider(),
                  _buildSkipToActionSettings(context),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSettingsCard(
                context,
                title: 'Stroke Range',
                subtitle:
                    "The min/max stroke length as a percentage of the device's full range.",
                children: [_buildMinMaxSettings(context)],
              ),
              const SizedBox(height: 16),
              _buildSettingsCard(
                context,
                title: 'Timing',
                children: [_buildOffsetSettings(context)],
              ),
            ],
          ),
        ),
      ],
    );
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

  Widget _buildMediaPaths(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView.builder(
            itemCount: _model.settings.mediaPaths.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final path = _model.settings.mediaPaths[index];
              return ListTile(
                title: Text(path),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Remove path',
                  onPressed: () async {
                    await _model.settings.removePath(path);
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: _addPath,
          icon: const Icon(Icons.folder_open),
          label: const Text('Add Media Path'),
        ),
      ],
    );
  }

  Widget _buildRdpEpsilonSettings(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Funscript Simplification (RDP Epsilon)'),
          subtitle: const Text(
            'Reduces the number of points in the funscript. Higher values mean more simplification. Changes are applied when loading a funscript.',
          ),
          value: _rdpEpsilonEnabled,
          onChanged: (value) {
            setState(() {
              _rdpEpsilonEnabled = value;
              _saveSettings();
            });
          },
          secondary: const Icon(Icons.timeline),
          isThreeLine: true,
        ),
        if (_rdpEpsilonEnabled)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Slider(
                  value: _currentRdpEpsilon,
                  min: 0,
                  max: 50,
                  divisions: 50,
                  label: _currentRdpEpsilon.round().toString(),
                  onChanged: (value) {
                    setState(() {
                      _currentRdpEpsilon = value;
                      _debouncer.run(_saveSettings);
                    });
                  },
                ),
                Text('Value: ${_currentRdpEpsilon.toStringAsFixed(2)}'),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSlewRateSettings(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Slew Rate Limit'),
          subtitle: const Text(
            'Modify the funscript limiting the rate of change, preventing jerky movements. Measured in percent per second. Changes are applied when loading a funscript.',
          ),
          value: _slewMaxRateOfChangeEnabled,
          onChanged: (value) {
            setState(() {
              _slewMaxRateOfChangeEnabled = value;
              _saveSettings();
            });
          },
          secondary: const Icon(Icons.speed),
          isThreeLine: true,
        ),
        if (_slewMaxRateOfChangeEnabled)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Slider(
                  value: _currentSlewMaxRateOfChange,
                  min: 100,
                  max: 1000,
                  divisions: 90,
                  label: _currentSlewMaxRateOfChange.round().toString(),
                  onChanged: (value) {
                    setState(() {
                      _currentSlewMaxRateOfChange = value;
                      _debouncer.run(_saveSettings);
                    });
                  },
                ),
                Text('Value: ${_currentSlewMaxRateOfChange.round()}'),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildRemapFullRangeSettings(BuildContext context) {
    return SwitchListTile(
      title: const Text('Remap to Full Range'),
      subtitle: const Text(
        "Remaps the funscript actions to use the full 0-100 range. The Handy will still remap into the range specified below. Changes are applied when loading a funscript.",
      ),
      value: _remapFullRange,
      onChanged: (value) {
        setState(() {
          _remapFullRange = value;
          _saveSettings();
        });
      },
      secondary: const Icon(Icons.fullscreen),
      isThreeLine: true,
    );
  }

  Widget _buildSkipToActionSettings(BuildContext context) {
    return SwitchListTile(
      title: const Text('Skip to action'),
      subtitle: const Text('Skips to the part where the funscript begins.'),
      value: _skipToAction,
      onChanged: (value) {
        setState(() {
          _skipToAction = value;
          _saveSettings();
        });
      },
      secondary: const Icon(Icons.skip_next),
    );
  }

  Widget _buildMinMaxSettings(BuildContext context) {
    return Column(
      children: [
        RangeSlider(
          values: RangeValues(_currentMin, _currentMax),
          min: 0,
          max: 100,
          divisions: 100,
          labels: RangeLabels(
            _currentMin.round().toString(),
            _currentMax.round().toString(),
          ),
          onChanged: (values) {
            setState(() {
              _currentMin = values.start;
              _currentMax = values.end;
              _debouncer.run(_saveSettings);
            });
          },
        ),
        Text('Min: ${_currentMin.round()}, Max: ${_currentMax.round()}'),
      ],
    );
  }

  Widget _buildOffsetSettings(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ListTile(
          leading: Icon(Icons.timer_outlined),
          title: Text('Timing Offset'),
          subtitle: Text(
            'Adjusts the timing of the script. A positive value makes actions happen earlier, a negative value makes them happen later. Change is applied immediately.',
          ),
          isThreeLine: true,
        ),
        Slider(
          value: _currentOffsetMs,
          min: -200,
          max: 200,
          divisions: 400,
          label: _currentOffsetMs.round().toString(),
          onChanged: (value) {
            setState(() {
              _currentOffsetMs = value;
              _debouncer.run(_saveSettings);
            });
          },
        ),
        Center(child: Text('${_currentOffsetMs.round()} ms')),
      ],
    );
  }
}
