import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/helper/debouncer.dart';
import 'package:syncopathy/model/app_model.dart';
import 'package:syncopathy/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late double _currentMin;
  late double _currentMax;
  late double _currentOffsetMs;

  late double _currentRdpEpsilon;
  late bool _rdpEpsilonEnabled;
  late bool _skipToAction;
  late double _currentSlewMaxRateOfChange;
  late bool _slewMaxRateOfChangeEnabled;
  late bool _remapFullRange;
  late bool _embeddedVideoPlayer;

  late final SyncopathyModel _model;
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _model = context.read<SyncopathyModel>();
    _model.settings.min.addListener(_onSettingsChanged);
    _model.settings.max.addListener(_onSettingsChanged);
    _model.settings.offsetMs.addListener(_onSettingsChanged);
    _model.settings.mediaPaths.addListener(_onSettingsChanged);
    _model.settings.slewMaxRateOfChange.addListener(_onSettingsChanged);
    _model.settings.rdpEpsilon.addListener(_onSettingsChanged);
    _model.settings.remapFullRange.addListener(_onSettingsChanged);
    _model.settings.skipToAction.addListener(_onSettingsChanged);
    _model.settings.embeddedVideoPlayer.addListener(_onSettingsChanged);
    _updateStateFromSettings();
  }

  @override
  void dispose() {
    _model.settings.min.removeListener(_onSettingsChanged);
    _model.settings.max.removeListener(_onSettingsChanged);
    _model.settings.offsetMs.removeListener(_onSettingsChanged);
    _model.settings.mediaPaths.removeListener(_onSettingsChanged);
    _model.settings.slewMaxRateOfChange.removeListener(_onSettingsChanged);
    _model.settings.rdpEpsilon.removeListener(_onSettingsChanged);
    _model.settings.remapFullRange.removeListener(_onSettingsChanged);
    _model.settings.skipToAction.removeListener(_onSettingsChanged);
    _model.settings.embeddedVideoPlayer.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onSettingsChanged() {
    if (mounted) {
      setState(_updateStateFromSettings);
    }
  }

  void _updateStateFromSettings() {
    _currentMin = _model.settings.min.value.toDouble();
    _currentMax = _model.settings.max.value.toDouble();
    _currentOffsetMs = _model.settings.offsetMs.value.toDouble();
    _currentRdpEpsilon = _model.settings.rdpEpsilon.value ?? 15.0;
    _rdpEpsilonEnabled = _model.settings.rdpEpsilon.value != null;
    _currentSlewMaxRateOfChange =
        _model.settings.slewMaxRateOfChange.value ?? 400.0;
    _slewMaxRateOfChangeEnabled =
        _model.settings.slewMaxRateOfChange.value != null;
    _remapFullRange = _model.settings.remapFullRange.value;
    _skipToAction = _model.settings.skipToAction.value;
    _embeddedVideoPlayer = _model.settings.embeddedVideoPlayer.value;
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
    final embeddedVideoPlayer = _embeddedVideoPlayer;

    _model.settings.setMinMax(currentMin, currentMax);
    _model.settings.setOffsetMs(currentOffset);
    _model.settings.setRdpEpsilon(currentRdpEpsilon);
    _model.settings.setSlewMaxRateOfChange(currentSlewRate);
    _model.settings.setRemapFullRange(remapFullRange);
    _model.settings.setSkipToAction(skipToAction);
    _model.settings.setEmbeddedVideoPlayer(embeddedVideoPlayer);
    Logger.info('Settings saved.');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Call super.build(context)
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
        const SizedBox(height: 16),
        _buildSettingsCard(
          context,
          title: 'Video Player',
          children: [_buildEmbeddedVideoPlayerSettings(context)],
        ),
        const SizedBox(height: 16),
        _buildSettingsCard(
          context,
          title: 'App Data',
          children: [_buildAppDataSettings(context)],
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
              const SizedBox(height: 16),
              _buildSettingsCard(
                context,
                title: 'Video Player',
                children: [_buildEmbeddedVideoPlayerSettings(context)],
              ),
              const SizedBox(height: 16),
              _buildSettingsCard(
                context,
                title: 'App Data',
                children: [_buildAppDataSettings(context)],
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
            itemCount: _model.settings.mediaPaths.value.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final path = _model.settings.mediaPaths.value[index];
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
          _buildSliderWithNumericInput(
            context,
            value: _currentRdpEpsilon,
            min: 0,
            max: 50,
            divisions: 50,
            onChanged: (value) {
              setState(() {
                _currentRdpEpsilon = value;
              });
            },
            onSave: _saveSettings,
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
          _buildSliderWithNumericInput(
            context,
            value: _currentSlewMaxRateOfChange,
            min: 100,
            max: 1000,
            divisions: 90,
            onChanged: (value) {
              setState(() {
                _currentSlewMaxRateOfChange = value;
              });
            },
            onSave: _saveSettings,
          ),
      ],
    );
  }

  Widget _buildRemapFullRangeSettings(BuildContext context) {
    return SwitchListTile(
      title: const Text('Remap to Full Range'),
      subtitle: const Text(
        "Remaps the funscript actions to use the full 0-100 range. The Handy will still remap into the range specified by the stroke range setting. Changes are applied when loading a funscript.",
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

  Widget _buildEmbeddedVideoPlayerSettings(BuildContext context) {
    return SwitchListTile(
      title: const Text('Use Embedded Video Player'),
      subtitle: const Text(
        'Enables an embedded video player (requires restart, Windows only).',
      ),
      value: _embeddedVideoPlayer,
      onChanged: (value) {
        setState(() {
          _embeddedVideoPlayer = value;
          _saveSettings();
        });
      },
      secondary: const Icon(Icons.video_collection),
      isThreeLine: true,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: FocusNumericInput(
                label: 'Min',
                value: _currentMin,
                min: 0,
                max: 100,
                onChanged: (value) {
                  setState(() {
                    _currentMin = value;
                    if (_currentMin > _currentMax) {
                      _currentMax = _currentMin;
                    }
                    _saveSettings();
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: FocusNumericInput(
                label: 'Max',
                value: _currentMax,
                min: 0,
                max: 100,
                onChanged: (value) {
                  setState(() {
                    _currentMax = value;
                    if (_currentMax < _currentMin) {
                      _currentMin = _currentMax;
                    }
                    _saveSettings();
                  });
                },
              ),
            ),
          ],
        ),
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
        _buildSliderWithNumericInput(
          context,
          value: _currentOffsetMs,
          min: -200,
          max: 200,
          divisions: 400,
          onChanged: (value) {
            setState(() {
              _currentOffsetMs = value;
            });
          },
          onSave: _saveSettings,
        ),
      ],
    );
  }

  Widget _buildSliderWithNumericInput(
    BuildContext context, {
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
    required VoidCallback onSave,
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
              onChangeEnd: (value) => onSave(),
            ),
          ),
          Expanded(
            flex: 1,
            child: FocusNumericInput(
              value: value,
              min: min,
              max: max,
              onChanged: (newValue) {
                onChanged(newValue);
                onSave();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppDataSettings(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text('Open App Data Directory'),
          subtitle: const Text(
            'Opens the directory where application data (e.g., database, thumbnails) are stored.',
          ),
          trailing: const Icon(Icons.folder_open),
          onTap: () async {
            try {
              final directory = await getApplicationSupportDirectory();
              final directoryPath = directory.path;
              if (Platform.isWindows) {
                await launchUrl(Uri.parse('file:///$directoryPath'));
              } else {
                await launchUrl(Uri.parse(directoryPath));
              }
            } catch (e) {
              Logger.error('Error opening app data directory: $e');
              if (!context.mounted) return;
              final messenger = ScaffoldMessenger.of(context);
              messenger.showSnackBar(
                SnackBar(content: Text('Error opening directory: $e')),
              );
            }
          },
        ),
      ],
    );
  }
}

class FocusNumericInput extends StatefulWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final double? min;
  final double? max;
  final String? label;

  const FocusNumericInput({
    super.key,
    required this.value,
    required this.onChanged,
    this.min,
    this.max,
    this.label,
  });

  @override
  State<FocusNumericInput> createState() => _FocusNumericInputState();
}

class _FocusNumericInputState extends State<FocusNumericInput> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.round().toString());
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(FocusNumericInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _controller.text = widget.value.round().toString();
    }
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      var text = _controller.text;
      if (text.isEmpty) {
        text = '0';
      }
      var parsedValue = double.tryParse(text);
      if (parsedValue != null) {
        if (widget.min != null) {
          parsedValue = parsedValue.clamp(widget.min!, widget.max!);
        }
        widget.onChanged(parsedValue);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      decoration: InputDecoration(
        labelText: widget.label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
    );
  }
}
