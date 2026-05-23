import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/helper/platform_utils.dart';
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/media_library/media_manager.dart';
import 'package:syncopathy/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncopathy/media_library/thumbnail_generator.dart';
import 'package:syncopathy/model/media_library_settings_model.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/notification_feed.dart';
import 'package:syncopathy/player/player_backend_type.dart';
import 'package:syncopathy/model/shortcut_settings.dart';
import 'package:syncopathy/widgets/shortcut_rebind_dialog.dart';
import 'package:syncopathy/update_checker.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final isUpdateCheckingSignal = signal<bool>(false);
  final statusUpdateMessageSignal = signal<String?>(null);

  Future<void> _addPath() async {
    final settings = context.read<SettingsModel>();
    final String? selectedDirectory = await FilePicker.getDirectoryPath();

    if (selectedDirectory != null) {
      settings.mediaPaths.add(selectedDirectory);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardBuilders = _getCardBuilders();
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.0),
      child: MasonryGridView.count(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: (MediaQuery.of(context).size.width / 500.0)
            .clamp(1, 3)
            .toInt(),
        itemCount: cardBuilders.length,
        mainAxisSpacing: 24, // Vertical gap between cards
        crossAxisSpacing: 24, // Horizontal gap between
        itemBuilder: (context, index) {
          return cardBuilders[index](context);
        },
      ),
    );
  }

  List<Widget Function(BuildContext)> _getCardBuilders() {
    return [
      (context) => _buildSettingsCard(
        context,
        title: 'Player Backend',
        children: [_buildPlayerBackendSettings(context)],
      ),
      if (!syncopathySimpleMode)
        (context) => _buildSettingsCard(
          context,
          title: 'Media Library Paths',
          subtitle:
              'Folders to search for videos and funscripts (searched recursively).',
          children: [_buildMediaPaths(context)],
        ),
      (context) => _buildSettingsCard(
        context,
        title: 'Video Player',
        children: [
          if (!kIsWeb) _buildEmbeddedVideoPlayerSettings(context),
          if (!syncopathySimpleMode)
            _buildAutoSwitchToVideoPlayerTabSettings(context),
          _buildSkipToActionSettings(context),
        ],
      ),
      (context) => _buildSettingsCard(
        context,
        title: 'Shortcuts',
        children: [_buildShortcutSettings(context)],
      ),
      if (!kIsWeb)
        (context) => _buildSettingsCard(
          context,
          title: 'Data Management',
          children: [_buildAppDataSettings(context)],
        ),
      (context) => _buildSettingsCard(
        context,
        title: 'App',
        children: [_buildUpdateChecker(context)],
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

  Widget _buildSkipToActionSettings(BuildContext context) {
    final settings = context.read<SettingsModel>();
    return Watch(
      (context) => SwitchListTile(
        title: const Text('Skip to action'),
        subtitle: const Text('Skips to the part where the funscript begins.'),
        value: settings.skipToAction.value,
        onChanged: (value) {
          settings.skipToAction.value = value;
        },
        secondary: const Icon(Icons.skip_next),
      ),
    );
  }

  Widget _buildShortcutSettings(BuildContext context) {
    final settings = context.read<SettingsModel>();
    return Watch((context) {
      final customShortcuts = settings.customShortcuts.value;
      return Column(
        children: ShortcutDefinitions.all.map((shortcut) {
          final binding =
              customShortcuts[shortcut.id] ?? shortcut.defaultBinding;
          return ListTile(
            title: Text(shortcut.name),
            subtitle: Text(shortcut.description),
            trailing: OutlinedButton(
              onPressed: () => _showRebindDialog(context, shortcut),
              child: Text(binding.toString()),
            ),
          );
        }).toList(),
      );
    });
  }

  Future<void> _showRebindDialog(
    BuildContext context,
    AppShortcut shortcut,
  ) async {
    final settings = context.read<SettingsModel>();

    final ShortcutBinding? newBinding = await showDialog<ShortcutBinding>(
      context: context,
      builder: (context) => ShortcutRebindDialog(shortcut: shortcut),
    );

    if (newBinding != null) {
      settings.customShortcuts[shortcut.id] = newBinding;
    }
  }

  Widget _buildEmbeddedVideoPlayerSettings(BuildContext context) {
    final settings = context.read<SettingsModel>();
    return Watch(
      (context) => SwitchListTile(
        title: const Text('Use Embedded Video Player'),
        subtitle: const Text(
          'Enables an embedded video player (Requires Restart).',
        ),
        value: settings.embeddedVideoPlayer.value,
        onChanged: (value) {
          settings.embeddedVideoPlayer.value = value;
        },
        secondary: const Icon(Icons.video_collection),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildAutoSwitchToVideoPlayerTabSettings(BuildContext context) {
    final settings = context.read<SettingsModel>();
    return Watch(
      (context) => SwitchListTile(
        title: const Text('Auto Switch to Video Player Tab'),
        subtitle: const Text(
          'Automatically switches to the video player tab when a video is loaded.',
        ),
        value: settings.autoSwitchToVideoPlayerTab.value,
        onChanged: (value) {
          settings.autoSwitchToVideoPlayerTab.value = value;
        },
        secondary: const Icon(Icons.tab),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildAppDataSettings(BuildContext context) {
    final withMedia = !syncopathySimpleMode;
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
              final message = 'Error opening app data directory: $e';
              Logger.error(message);
              AlertManager.showError(message);
            }
          },
        ),
        if (Logger.logFilePath != null)
          ListTile(
            title: const Text('Open Log File'),
            subtitle: const Text('Opens the current log file.'),
            trailing: const Icon(Icons.description_outlined),
            onTap: () async {
              final path = Logger.logFilePath;
              if (path != null) {
                PlatformUtils.openFileExplorer(path);
              }
            },
          ),
        if (withMedia)
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
        if (withMedia)
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

  Widget _buildUpdateChecker(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<PackageInfo>(
          future: PackageInfo.fromPlatform(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox.shrink();
            final info = snapshot.data!;

            return Watch(
              (context) => ListTile(
                title: Text(
                  '${info.appName} v${info.version}+${info.buildNumber}',
                ),
                subtitle: statusUpdateMessageSignal.value != null
                    ? Text(statusUpdateMessageSignal.value!)
                    : null,
                onTap: () => UpdateChecker.openReleasePage(),
              ),
            );
          },
        ),
        Watch((context) {
          final isChecking = isUpdateCheckingSignal.value;

          return ListTile(
            title: const Text('Check for updates'),
            subtitle: const Text(
              "Check the github repository for new releases.",
            ),
            trailing: isChecking
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.update),
            onTap: isChecking
                ? null
                : () async {
                    isUpdateCheckingSignal.value = true;
                    statusUpdateMessageSignal.value = "Checking...";

                    try {
                      final latestVersion =
                          await UpdateChecker.checkForUpdates();
                      statusUpdateMessageSignal.value = latestVersion == null
                          ? "Up to date!"
                          : "New version: $latestVersion";
                    } finally {
                      isUpdateCheckingSignal.value = false;
                    }
                  },
          );
        }),
      ],
    );
  }

  Widget _buildPlayerBackendSettings(BuildContext context) {
    final settings = context.read<SettingsModel>();
    final playerModel = context.read<PlayerModel>();

    return Watch((context) {
      final backend = playerModel.playerBackend.value;
      final backendType = settings.playerBackendType.value;
      final isLoaded =
          backend?.backendType != null && backend?.backendType == backendType;

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
            child: !isLoaded
                ? Center(child: CircularProgressIndicator())
                : DropdownMenu<PlayerBackendType>(
                    initialSelection: backendType,
                    expandedInsets: EdgeInsets.zero,
                    requestFocusOnTap: false,
                    enableSearch: false,
                    inputDecorationTheme: const InputDecorationTheme(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 8.0,
                      ),
                    ),
                    dropdownMenuEntries: PlayerBackendType.values.map((e) {
                      return DropdownMenuEntry<PlayerBackendType>(
                        value: e,
                        label: e.toDisplayString(),
                      );
                    }).toList(),
                    onSelected: (selectedEnum) {
                      if (selectedEnum != null) {
                        settings.playerBackendType.value = selectedEnum;
                      }
                    },
                  ),
          ),
          if (backend != null && isLoaded)
            ListTile(title: backend.settingsWidget(context)),
        ],
      );
    });
  }

  void _callGenerateMissingThumbnails() {
    _generateMissingThumbnails(context);
  }

  Future<void> _resetAllVideoPlayCount() async {
    final mediaSettings = context.read<MediaLibrarySettingsModel?>();
    final mediaManager = context.read<MediaManager?>();
    if (mediaManager == null || mediaSettings == null) {
      return;
    }
    oBox.mediaService.resetAllVideosPlayCount();
  }

  void _generateMissingThumbnails(BuildContext context) {
    final mediaManager = context.read<MediaManager?>();
    if (mediaManager == null) {
      return;
    }
    final videos = oBox.mediaService.getAll();
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
                final futures = <Future>[];
                for (final media in videos) {
                  var future = ThumbnailGenerator()
                      .addRequest(ThumbnailRequest(file: media))
                      .then((_) {
                        setState(() {
                          generatedCount += 1;
                        });
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
        Logger.info('Thumbnail generation complete. Generated: $count');
      }
    });
  }
}
