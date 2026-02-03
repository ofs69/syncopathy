import 'dart:async';

import 'package:async_locks/async_locks.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/helper/platform_utils.dart';
import 'package:syncopathy/media_manager.dart';
import 'package:syncopathy/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncopathy/model/media_library_settings_model.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/sqlite/database_helper.dart';
import 'package:syncopathy/video_thumbnail.dart';
import 'package:syncopathy/notification_feed.dart';
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

  Future<void> _addPath() async {
    final settings = context.read<SettingsModel>();
    final String? selectedDirectory = await FilePicker.platform
        .getDirectoryPath();

    if (selectedDirectory != null) {
      settings.mediaPaths.add(selectedDirectory);
      if (!mounted) return;
      NotificationFeedManager.showSuccessNotification(
        context,
        'Added path: $selectedDirectory',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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

  List<Widget> _buildAllSettingsCards(BuildContext context) {
    return [
      _buildSettingsCard(
        context,
        title: 'Media Library Paths',
        subtitle:
            'Folders to search for videos and funscripts (searched recursively).',
        children: [_buildMediaPaths(context)],
      ),
      _buildSettingsCard(
        context,
        title: 'Funscript Processing',
        children: [
          _buildRdpEpsilonSettings(context),
          const Divider(),
          _buildSlewRateSettings(context),
          const Divider(),
          _buildInvertSettings(context),
          const Divider(),
          _buildRemapFullRangeSettings(context),
          const Divider(),
          _buildSkipToActionSettings(context),
        ],
      ),
      _buildSettingsCard(
        context,
        title: 'Stroke Range',
        subtitle:
            "The min/max stroke length as a percentage of the device's full range.",
        children: [_buildMinMaxSettings(context)],
      ),
      _buildSettingsCard(
        context,
        title: 'Timing',
        children: [_buildOffsetSettings(context)],
      ),
      _buildSettingsCard(
        context,
        title: 'Video Player',
        children: [
          _buildEmbeddedVideoPlayerSettings(context),
          const Divider(),
          _buildAutoSwitchToVideoPlayerTabSettings(context),
          const Divider(),
          _buildAutoPlaySettings(context),
        ],
      ),
      _buildSettingsCard(
        context,
        title: 'Data Management',
        children: [_buildAppDataSettings(context)],
      ),
      if (kDebugMode)
        _buildSettingsCard(
          context,
          title: 'Debug',
          children: [_buildDebugSettings(context)],
        ),
    ];
  }

  List<Widget> _addSpacingBetweenWidgets(List<Widget> widgets, double spacing) {
    if (widgets.isEmpty) {
      return [];
    }
    return widgets
        .expand((widget) => [widget, SizedBox(height: spacing)])
        .toList()
      ..removeLast();
  }

  Widget _buildSingleColumnLayout(BuildContext context) {
    final allCards = _buildAllSettingsCards(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _addSpacingBetweenWidgets(allCards, 16.0),
    );
  }

  Widget _buildTwoColumnLayout(BuildContext context) {
    final allCards = _buildAllSettingsCards(context);

    // Explicitly assign cards to columns based on the original layout
    final List<Widget> column1Cards = [
      allCards[0], // Media Library Paths
      allCards[1], // Funscript Processing
    ];

    if (allCards.length > 6) {
      column1Cards.add(allCards[6]); // Debug Card
    }

    final List<Widget> column2Cards = [
      allCards[2], // Stroke Range
      allCards[3], // Timing
      allCards[4], // Video Player
      allCards[5], // App Data
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _addSpacingBetweenWidgets(column1Cards, 16.0),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _addSpacingBetweenWidgets(column2Cards, 16.0),
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
    final settings = context.read<SettingsModel>();
    return Column(
      children: [
        Container(
          constraints: BoxConstraints(minHeight: 100, maxHeight: 300),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Watch.builder(
            builder: (context) => ListView.builder(
              itemCount: settings.mediaPaths.watch(context).length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final path = settings.mediaPaths.value[index];
                return ListTile(
                  contentPadding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                  title: Text(path),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'Remove path',
                    onPressed: () {
                      settings.mediaPaths.remove(path);
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
    );
  }

  Widget _buildRdpEpsilonSettings(BuildContext context) {
    final settings = context.read<SettingsModel>();
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Funscript Simplification (RDP Epsilon)'),
          subtitle: const Text(
            'Reduces the number of points in the funscript. Higher values mean more simplification. Changes are applied when loading a funscript.',
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
            'Modify the funscript limiting the rate of change, preventing jerky movements. Measured in percent per second. Changes are applied when loading a funscript.',
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

  Widget _buildRemapFullRangeSettings(BuildContext context) {
    final settings = context.read<SettingsModel>();
    return SwitchListTile(
      title: const Text('Remap to Full Range'),
      subtitle: const Text(
        "Remaps the funscript actions to use the full 0-100 range. The Handy will still remap into the range specified by the stroke range setting. Changes are applied when loading a funscript.",
      ),
      value: settings.remapFullRange.watch(context),
      onChanged: (value) {
        settings.remapFullRange.value = value;
      },
      secondary: const Icon(Icons.fullscreen),
      isThreeLine: true,
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

  Widget _buildEmbeddedVideoPlayerSettings(BuildContext context) {
    final settings = context.read<SettingsModel>();
    return SwitchListTile(
      title: const Text('Use Embedded Video Player'),
      subtitle: const Text(
        'Enables an embedded video player (requires restart, Windows only).',
      ),
      value: settings.embeddedVideoPlayer.watch(context),
      onChanged: (value) {
        settings.embeddedVideoPlayer.value = value;
      },
      secondary: const Icon(Icons.video_collection),
      isThreeLine: true,
    );
  }

  Widget _buildAutoSwitchToVideoPlayerTabSettings(BuildContext context) {
    final settings = context.read<SettingsModel>();
    return SwitchListTile(
      title: const Text('Auto Switch to Video Player Tab'),
      subtitle: const Text(
        'Automatically switches to the video player tab when a video is loaded.',
      ),
      value: settings.autoSwitchToVideoPlayerTab.watch(context),
      onChanged: (value) {
        settings.autoSwitchToVideoPlayerTab.value = value;
      },
      secondary: const Icon(Icons.tab),
      isThreeLine: true,
    );
  }

  Widget _buildAutoPlaySettings(BuildContext context) {
    final settings = context.read<SettingsModel>();
    return SwitchListTile(
      title: const Text('Auto Play'),
      subtitle: const Text('Automatically plays the video when loaded.'),
      value: settings.autoPlay.watch(context),
      onChanged: (value) {
        settings.autoPlay.value = value;
      },
      secondary: const Icon(Icons.play_arrow),
    );
  }

  Widget _buildInvertSettings(BuildContext context) {
    final settings = context.read<SettingsModel>();
    return SwitchListTile(
      title: const Text('Invert'),
      subtitle: const Text(
        'Inverts the funscript actions. Changes are applied when loading a funscript.',
      ),
      value: settings.invert.watch(context),
      onChanged: (value) {
        settings.invert.value = value;
      },
      secondary: const Icon(Icons.swap_vert),
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

  Widget _buildOffsetSettings(BuildContext context) {
    final settings = context.read<SettingsModel>();
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
          value: settings.offsetMs.watch(context).toDouble(),
          min: -200,
          max: 200,
          divisions: 400,
          onChanged: (value) {
            settings.offsetMs.value = value.toInt();
          },
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
              PlatformUtils.openFileExplorer(directory.path);
            } catch (e) {
              Logger.error('Error opening app data directory: $e');
              if (!context.mounted) return;
              NotificationFeedManager.showErrorNotification(
                context,
                'Error opening directory: $e',
              );
            }
          },
        ),
        ListTile(
          title: const Text('Generate Missing Thumbnails'),
          subtitle: const Text(
            'Scans all videos and generates thumbnails for those that are missing one.',
          ),
          trailing: const Icon(Icons.image_search),
          onTap: () async {
            final shouldGenerate = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirm Thumbnail Generation'),
                  content: const Text(
                    'This may take a long time depending on the number of videos. Are you sure you want to continue?',
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Generate'),
                    ),
                  ],
                );
              },
            );

            if (shouldGenerate == true) {
              if (!mounted) return;
              _callGenerateMissingThumbnails();
            }
          },
        ),
        ListTile(
          title: const Text('Reset Video Play Count'),
          subtitle: const Text(
            'Resets the video play count to zero for all videos.',
          ),
          trailing: const Icon(Icons.history),
          onTap: () async {
            final resetViewCount = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirm Video Play Count Reset'),
                  content: const Text('Are you sure you want to continue?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Reset'),
                    ),
                  ],
                );
              },
            );

            if (resetViewCount == true) {
              if (!mounted) return;
              _resetAllVideoPlayCount();
            }
          },
        ),
      ],
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
            setState(() {
              settings.showDebugNotifications.value = value;
            });
          },
          secondary: const Icon(Icons.bug_report),
        ),
      ],
    );
  }

  void _callGenerateMissingThumbnails() {
    _generateMissingThumbnails(context);
  }

  Future<void> _resetAllVideoPlayCount() async {
    final mediaSettings = context.read<MediaLibrarySettingsModel>();
    final mediaManager = context.read<MediaManager>();
    await DatabaseHelper().resetAllVideosPlayCount();
    // HACK: trigger a UI refresh
    await mediaManager.load();
    mediaSettings.isSortAscending.set(
      mediaSettings.isSortAscending.value,
      force: true,
    );
  }

  void _generateMissingThumbnails(BuildContext context) {
    final mediaManager = context.read<MediaManager>();
    final videos = mediaManager.allVideos;
    int generatedCount = 0;
    bool generationStarted = false;
    int successCount = 0;

    showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            if (!generationStarted) {
              generationStarted = true;
              Future(() async {
                final ffmpegSemaphore = Semaphore(2);
                final futures = <Future>[];
                for (final video in videos) {
                  final future =
                      VideoThumbnailState.generateThumbnailAndGetPath(
                        video,
                        0.05,
                        ffmpegSemaphore,
                      ).then((path) {
                        if (path != null) {
                          successCount++;
                        }
                        if (dialogContext.mounted) {
                          setState(() {
                            generatedCount++;
                          });
                        }
                      });
                  futures.add(future);
                }

                await Future.wait(futures);

                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop(successCount);
                }
              });
            }

            return AlertDialog(
              title: const Text('Generating Thumbnails'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LinearProgressIndicator(
                    value: videos.isEmpty ? 0 : generatedCount / videos.length,
                  ),
                  const SizedBox(height: 16),
                  Text('Processed $generatedCount of ${videos.length} videos.'),
                ],
              ),
            );
          },
        );
      },
    ).then((count) {
      if (context.mounted && count != null) {
        NotificationFeedManager.showSuccessNotification(
          context,
          'Thumbnail generation complete. Generated: $count',
        );
      }
    });
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
