import 'dart:async';

import 'package:async_locks/async_locks.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/helper/platform_utils.dart';
import 'package:syncopathy/media_manager.dart';
import 'package:syncopathy/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncopathy/model/media_library_settings_model.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/player/player_backend_type.dart';
import 'package:syncopathy/sqlite/database_helper.dart';
import 'package:syncopathy/update_checker.dart';
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

  final isUpdateCheckingSignal = signal<bool>(false);
  final statusUpdateMessageSignal = signal<String?>(null);

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

    final allCards = _buildAllSettingsCards(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.0),
      child: MasonryGridView.count(
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
        title: 'Media Library Paths',
        subtitle:
            'Folders to search for videos and funscripts (searched recursively).',
        children: [_buildMediaPaths(context)],
      ),
      _buildSettingsCard(
        context,
        title: 'Video Player',
        children: [
          _buildEmbeddedVideoPlayerSettings(context),
          _buildAutoSwitchToVideoPlayerTabSettings(context),
          _buildSkipToActionSettings(context),
        ],
      ),
      _buildSettingsCard(
        context,
        title: 'Data Management',
        children: [_buildAppDataSettings(context)],
      ),
      _buildSettingsCard(
        context,
        title: 'App',
        children: [_buildUpdateChecker(context)],
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

  Widget _buildAppDataSettings(BuildContext context) {
    final withMedia = context.read<MediaManager?>() != null;
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

  Widget _buildUpdateChecker(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<PackageInfo>(
          future: PackageInfo.fromPlatform(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox.shrink();
            final info = snapshot.data!;

            // 2. Watch the status message signal
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
        // 3. Watch the loading signal to swap the icon
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
                    // 4. Update signal values directly
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

  void _callGenerateMissingThumbnails() {
    _generateMissingThumbnails(context);
  }

  Future<void> _resetAllVideoPlayCount() async {
    final mediaSettings = context.read<MediaLibrarySettingsModel?>();
    final mediaManager = context.read<MediaManager?>();
    if (mediaManager == null || mediaSettings == null) {
      return;
    }
    await DatabaseHelper().resetAllVideosPlayCount();
    // HACK: trigger a UI refresh
    await mediaManager.load();
    mediaSettings.isSortAscending.set(
      mediaSettings.isSortAscending.value,
      force: true,
    );
  }

  void _generateMissingThumbnails(BuildContext context) {
    final mediaManager = context.read<MediaManager?>();
    if (mediaManager == null) {
      return;
    }
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
