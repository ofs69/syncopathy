import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/model/app_model.dart';

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
  late double _currentSlewMaxRateOfChange;
  late bool _slewMaxRateOfChangeEnabled;
  late bool _remapFullRange;

  late final SyncopathyModel _model;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Tooltip(
                    message:
                        "Adjusts the timing of the script. A positive value makes actions happen earlier, a negative value makes them happen later.\nChange is applied immediately.",
                    child: Text(
                      'Offset: ${_currentOffsetMs.round()} ms',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
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
                      });
                    },
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: _rdpEpsilonEnabled,
                        onChanged: (value) {
                          setState(() {
                            _rdpEpsilonEnabled = value ?? false;
                          });
                        },
                      ),
                      Tooltip(
                        message:
                            "Reduces the number of points in the funscript. Higher values mean more simplification. This is the Ramer-Douglas-Peucker algorithm's epsilon value.\nChanges are applied when loading a funscript.",
                        child: Text(
                          'Funscript Simplification (RDP Epsilon): ${_rdpEpsilonEnabled ? _currentRdpEpsilon.toStringAsFixed(2) : 'Disabled'}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _currentRdpEpsilon,
                    min: 0.5,
                    max: 50,
                    divisions: 50,
                    label: _currentRdpEpsilon.toStringAsFixed(2),
                    onChanged: _rdpEpsilonEnabled
                        ? (value) {
                            setState(() {
                              _currentRdpEpsilon = value.roundToDouble();
                            });
                          }
                        : null,
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: _slewMaxRateOfChangeEnabled,
                        onChanged: (value) {
                          setState(() {
                            _slewMaxRateOfChangeEnabled = value ?? false;
                          });
                        },
                      ),
                      Tooltip(
                        message:
                            "Modify the funscript limiting the rate of change, preventing jerky movements. Measured in percent per second.\nChanges are applied when loading a funscript.",
                        child: Text(
                          'Slew Rate Limit: ${_slewMaxRateOfChangeEnabled ? _currentSlewMaxRateOfChange.round() : 'Disabled'}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _currentSlewMaxRateOfChange,
                    min: 100,
                    max: 1000,
                    divisions: 1000,
                    label: _currentSlewMaxRateOfChange.round().toString(),
                    onChanged: _slewMaxRateOfChangeEnabled
                        ? (value) {
                            setState(() {
                              _currentSlewMaxRateOfChange = value;
                            });
                          }
                        : null,
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: _remapFullRange,
                        onChanged: (value) {
                          setState(() {
                            _remapFullRange = value ?? true;
                          });
                        },
                      ),
                      Tooltip(
                        message:
                            "Remaps the funscript actions to use the full 0-100 range. Useful for scripts that don't use the full range.\nThe Handy will still remap into the range specified below.\nChanges are applied when loading a funscript.",
                        child: Text(
                          'Remap to Full Range',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSliderColumn(
                        label: 'Min',
                        tooltip:
                            "The minimum stroke length as a percentage of the device's full range.\nChange is applied when connected and apply button is pressed.",
                        value: _currentMin,
                        onChanged: (value) {
                          setState(() {
                            _currentMin = value;
                            _currentMax = max(_currentMin, _currentMax);
                          });
                        },
                      ),
                      _buildSliderColumn(
                        label: 'Max',
                        tooltip:
                            "The maximum stroke length as a percentage of the device's full range.\nChange is applied when connected and apply button is pressed.",
                        value: _currentMax,
                        onChanged: (value) {
                          setState(() {
                            _currentMax = value;
                            _currentMin = min(_currentMin, _currentMax);
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () async {
                      final currentMin = _currentMin.round();
                      final currentMax = _currentMax.round();

                      final currentOffset = _currentOffsetMs.round();
                      final currentRdpEpsilon = _rdpEpsilonEnabled
                          ? _currentRdpEpsilon
                          : null;
                      final currentSlewRate = _slewMaxRateOfChangeEnabled
                          ? _currentSlewMaxRateOfChange
                          : null;
                      final remapFullRange = _remapFullRange;

                      _model.settings.setMinMax(currentMin, currentMax);
                      _model.settings.setOffsetMs(currentOffset);
                      _model.settings.setRdpEpsilon(currentRdpEpsilon);
                      _model.settings.setSlewMaxRateOfChange(currentSlewRate);
                      _model.settings.setRemapFullRange(remapFullRange);
                      setState(() {});
                    },
                    child: const Text('Save Settings and Apply'),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Tooltip(
                    message: "Folders to search for videos and funscripts.",
                    child: Text(
                      'Media Library Paths',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '(paths are searched recursively for videos with matching .funscript files)',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
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
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _addPath,
                    icon: const Icon(Icons.folder_open),
                    label: const Text('Add Media Path'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderColumn({
    required String label,
    required String tooltip,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Tooltip(
          message: tooltip,
          child: SizedBox(
            width: 120, // Set a fixed width for the text
            child: Text(
              '$label: ${value.round()}',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200, // Give the slider a fixed height
          child: RotatedBox(
            quarterTurns: -1,
            child: Slider(
              value: value,
              min: 0,
              max: 100,
              divisions: 100,
              label: value.round().toString(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
