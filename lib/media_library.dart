import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/events/event_bus.dart';
import 'package:syncopathy/events/player_event.dart';

import 'package:syncopathy/funscript_metadata_filter_bottom_sheet.dart';

import 'package:syncopathy/media_manager.dart';
import 'package:syncopathy/media_search_service.dart';
import 'package:syncopathy/model/media_library_settings_model.dart';
import 'package:syncopathy/sqlite/database_helper.dart';
import 'package:syncopathy/sqlite/models/user_category.dart';
import 'package:syncopathy/video_item.dart';
import 'package:syncopathy/search_expression_visualizer.dart';
import 'package:syncopathy/sqlite/models/video_model.dart';
import 'package:syncopathy/wheel_of_fortune.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/category_selection_dialog.dart';
import 'package:syncopathy/notification_feed.dart';
import 'package:syncopathy/pca_calculator.dart';
import 'package:syncopathy/pca_progress_dialog.dart';
import 'package:syncopathy/search_bar.dart';

enum SortOption {
  title('Title'),
  speed('Speed'),
  depth('Depth'),
  duration('Duration'),
  lastModified('Last Modified'),
  playCount('Play Count'),
  random('Random'),
  pca('PCA (Experimental)');

  const SortOption(this.label);
  final String label;
}

enum VideoFilter {
  hideFavorite('Hide Favorite'),
  hideDisliked('Hide Disliked'),
  hideUnrated('Hide Unrated');

  const VideoFilter(this.label);
  final String label;
}

class MediaLibrary extends StatefulWidget {
  final void Function(Video) onVideoTapped;

  const MediaLibrary({super.key, required this.onVideoTapped});

  @override
  State<MediaLibrary> createState() => _MediaLibraryState();
}

final _uncategorized = UserCategory(name: 'Uncategorized');

class _MediaLibraryState extends State<MediaLibrary> {
  late final PcaCalculator _pcaCalculator;
  late final MediaSearchService _mediaSearchService;

  final Signal<String> _searchQuery = signal('');
  final Signal<List<Video>> _filteredVideos = listSignal([]);

  final Signal<UserCategory?> _selectedCategory = signal(null);
  final Signal<Set<String>> _selectedAuthors = setSignal({});
  final Signal<Set<String>> _selectedTags = setSignal({});
  final Signal<Set<String>> _selectedPerformers = setSignal({});
  final Signal<bool> _isLoading = signal(false);

  SortOption? _previousSortOption;
  int? _randomSeed;
  final Map<String, List<double>> _pcaScoresByPath = {};
  final Map<Video, List<double>> _videoPcaScores = {};

  final Signal<Set<Video>> _selectedVideos = setSignal({});
  bool get _isSelectionMode => _selectedVideos.isNotEmpty;

  late final Function _videoUpdateEffectDispose;

  @override
  void initState() {
    super.initState();
    final mediaManager = context.read<MediaManager>();
    _pcaCalculator = PcaCalculator(mediaManager);
    _mediaSearchService = MediaSearchService();

    _refreshVideos();
    _filteredVideos.value = [];

    _videoUpdateEffectDispose = effect(() {
      _updateVideosFromMediaSettings();
    });
  }

  @override
  void dispose() {
    _videoUpdateEffectDispose();
    super.dispose();
  }

  Future<void> _updateVideosFromMediaSettings() async {
    if (_isLoading.value) {
      return;
    }
    final mediaSettings = context.read<MediaLibrarySettingsModel>();
    final filteredVideos = await _updateDisplayedVideos(
      context.read<MediaManager>().allVideos,
      mediaSettings.visibilityFilters.value,
      mediaSettings.sortOption.value,
      mediaSettings.separateFavorites.value,
      mediaSettings.isSortAscending.value,
      _selectedAuthors.value,
      _selectedTags.value,
      _selectedPerformers.value,
      _selectedCategory.value,
      _searchQuery.value,
    );
    _filteredVideos.value = filteredVideos;
  }

  List<String> get _allAuthors {
    final authors = context
        .read<MediaManager>()
        .allVideos
        .map((v) => v.funscriptMetadata?.creator)
        .where((c) => c != null && c.isNotEmpty)
        .cast<String>()
        .toSet()
        .toList();
    authors.sort();
    return authors;
  }

  List<String> get _allTags {
    final tags = context
        .read<MediaManager>()
        .allVideos
        .expand<String>((v) => v.funscriptMetadata?.tags ?? [])
        .toSet()
        .toList();
    tags.sort();
    return tags;
  }

  List<String> get _allPerformers {
    final performers = context
        .read<MediaManager>()
        .allVideos
        .expand<String>((v) => v.funscriptMetadata?.performers ?? [])
        .toSet()
        .toList();
    performers.sort();
    return performers;
  }

  Future<List<Video>> _updateDisplayedVideos(
    List<Video> allVideos,
    Set<VideoFilter> videoFilter,
    SortOption sortOption,
    bool separateFavorites,
    bool isSortAscending,
    Set<String> selectedAuthors,
    Set<String> selectedTags,
    Set<String> selectedPerformers,
    UserCategory? selectedCategory,
    String searchQuery,
  ) async {
    List<Video> videos = allVideos.where((video) {
      final authorMatch =
          selectedAuthors.isEmpty ||
          (selectedAuthors.isNotEmpty &&
              video.funscriptMetadata?.creator != null &&
              selectedAuthors.contains(video.funscriptMetadata!.creator));
      if (!authorMatch) return false;

      final tagMatch =
          selectedTags.isEmpty ||
          (selectedTags.isNotEmpty &&
              video.funscriptMetadata?.tags != null &&
              video.funscriptMetadata!.tags.any(
                (tag) => selectedTags.contains(tag),
              ));
      if (!tagMatch) return false;

      final performerMatch =
          selectedPerformers.isEmpty ||
          (selectedPerformers.isNotEmpty &&
              video.funscriptMetadata?.performers != null &&
              video.funscriptMetadata!.performers.any(
                (performer) => selectedPerformers.contains(performer),
              ));
      if (!performerMatch) return false;

      if (selectedCategory != null) {
        if (selectedCategory == _uncategorized) {
          if (video.categories.isNotEmpty) {
            return false;
          }
        } else if (!video.categories.any((c) => c.id == selectedCategory.id)) {
          return false;
        }
      }

      if (videoFilter.contains(VideoFilter.hideFavorite) && video.isFavorite) {
        return false;
      }

      if (videoFilter.contains(VideoFilter.hideDisliked) && video.isDislike) {
        return false;
      }

      if (videoFilter.contains(VideoFilter.hideUnrated) &&
          !video.isFavorite &&
          !video.isDislike) {
        return false;
      }
      return true; // Explicitly return true if no filters exclude the video
    }).toList(); // Convert to List after all initial filters

    videos = _mediaSearchService.filterVideos(videos, searchQuery);

    _videoPcaScores.clear();
    if (sortOption == SortOption.pca) {
      if (_pcaScoresByPath.isEmpty) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return PcaProgressDialog(
              pcaCalculator: _pcaCalculator,
              onCalculationComplete: (scores) {
                setState(() {
                  _pcaScoresByPath.clear();
                  _pcaScoresByPath.addAll(scores);
                });
              },
            );
          },
        );
      }

      for (var video in videos) {
        if (_pcaScoresByPath.containsKey(video.videoPath)) {
          _videoPcaScores[video] = _pcaScoresByPath[video.videoPath]!;
        }
      }
    }

    if (sortOption == SortOption.random) {
      if (_previousSortOption != SortOption.random) {
        _randomSeed = Random().nextInt(1000000); // Generate new seed
      }
      videos.shuffle(Random(_randomSeed!)); // Shuffle with seed
    } else {
      _randomSeed = null; // Clear seed if not random sort
    }

    videos.sort((a, b) {
      if (separateFavorites) {
        // Favorites always come first, and disliked videos are never favorites.
        if (a.isFavorite != b.isFavorite) {
          return a.isFavorite ? -1 : 1;
        }

        // Then, sort by dislike status. Disliked videos go to the bottom.
        if (a.isDislike != b.isDislike) {
          return a.isDislike ? 1 : -1;
        }
      }

      // Within each group (favorites, normal, disliked), sort by the selected option.
      int compareResult = 0;
      switch (sortOption) {
        case SortOption.title:
          compareResult = a.title.compareTo(b.title);
          break;
        case SortOption.speed:
          compareResult = a.averageSpeed.compareTo(b.averageSpeed);
          break;
        case SortOption.depth:
          final depthA = a.averageMax - a.averageMin;
          final depthB = b.averageMax - b.averageMin;
          compareResult = depthA.compareTo(depthB);
          break;
        case SortOption.duration:
          compareResult = (a.duration ?? 0).compareTo(b.duration ?? 0);
          break;
        case SortOption.lastModified:
          compareResult = a.dateFirstFound.compareTo(b.dateFirstFound);
          break;
        case SortOption.playCount:
          compareResult = a.playCount.compareTo(b.playCount);
          break;
        case SortOption.random:
          compareResult = 0;
          break;
        case SortOption.pca:
          final scoreA = _videoPcaScores[a];
          final scoreB = _videoPcaScores[b];

          if (scoreA == null && scoreB == null) {
            compareResult = 0;
          } else if (scoreA == null) {
            compareResult = 1;
          } else if (scoreB == null) {
            compareResult = -1;
          } else {
            compareResult = scoreA[0].compareTo(scoreB[0]);
          }
          break;
      }

      return isSortAscending ? compareResult : -compareResult;
    });

    _previousSortOption = sortOption; // Update previous sort option
    return videos;
  }

  Future<void> _refreshVideos() async {
    _isLoading.value = true;
    _filteredVideos.value = []; // Clear videos when loading starts
    await context.read<MediaManager>().refreshVideos();
    if (mounted) {
      _isLoading.value = false;
      await _updateVideosFromMediaSettings();
    }
  }

  void _startPlaylist() {
    final playlistVideos = _filteredVideos
        .where((video) => !video.isDislike)
        .toList();
    if (playlistVideos.isEmpty) {
      if (!mounted) return;
      NotificationFeedManager.showErrorNotification(
        context,
        'No non-disliked videos to create a playlist!',
      );
      return;
    }
    if (!mounted) return;
    Events.emit(OpenPlaylistEvent(playlistVideos));
    NotificationFeedManager.showSuccessNotification(
      context,
      'Playlist created with ${playlistVideos.length} videos!',
    );
  }

  void _showRandomVideoPicker() {
    final mediaSettings = context.read<MediaLibrarySettingsModel>();
    var availableVideos = _filteredVideos.where((v) {
      bool shouldHideUnrated =
          mediaSettings.visibilityFilters.value.contains(
            VideoFilter.hideUnrated,
          ) &&
          !v.isFavorite &&
          !v.isDislike;
      return !v.isDislike && !shouldHideUnrated;
    }).toList();

    if (availableVideos.isEmpty) {
      if (mounted) {
        NotificationFeedManager.showErrorNotification(
          context,
          'No videos available to choose from!',
        );
      }
      return;
    }

    // shuffle the list
    availableVideos.shuffle();
    // Determine the number of items to take (up to 12).
    final count = min(12, availableVideos.length);
    // Take the first 'count' elements from the shuffled list.
    availableVideos = availableVideos.take(count).toList();

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return WheelOfFortuneDialog(
          videos: availableVideos,
          onVideoSelected: widget.onVideoTapped,
        );
      },
    );
  }

  Future<void> _showFunscriptMetadataFilterDialog() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FunscriptMetadataFilterBottomSheet(
          allAuthors: _allAuthors,
          allTags: _allTags,
          allPerformers: _allPerformers,
          selectedAuthors: _selectedAuthors,
          selectedTags: _selectedTags,
          selectedPerformers: _selectedPerformers,
        );
      },
    );
  }

  Future<void> _showCategoryDialog() async {
    final selected = await showModalBottomSheet<UserCategory?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return CategorySelectionDialog(
          uncategorized: _uncategorized,
          showAllCategoriesOption: true,
          showUncategorizedOption: true,
        );
      },
    );

    if (selected != _selectedCategory.value) {
      _selectedCategory.value = selected;
    }
  }

  Future<void> _showBulkAddCategoryDialog() async {
    final mediaManager = context.read<MediaManager>();
    final category = await _showCategorySelectionDialog();
    if (category != null) {
      await mediaManager.addVideosToCategory(
        _selectedVideos.toList(),
        category,
      );
      _selectedVideos.clear();
    }
  }

  Future<void> _showBulkRemoveCategoryDialog() async {
    final mediaManager = context.read<MediaManager>();
    final category = await _showCategorySelectionDialog(showAddCategory: false);
    if (category != null) {
      await mediaManager.removeVideosFromCategory(
        _selectedVideos.toList(),
        category,
      );
      _selectedVideos.clear();
    }
  }

  void _selectAllVideos() {
    _selectedVideos.clear();
    _selectedVideos.addAll(_filteredVideos.value);
  }

  Future<void> _deleteVideo(Video video) async {
    await context.read<MediaManager>().deleteVideo(video);
    await _updateVideosFromMediaSettings();
  }

  Future<UserCategory?> _showCategorySelectionDialog({
    bool showAddCategory = true,
  }) async {
    return await showModalBottomSheet<UserCategory?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return CategorySelectionDialog(
          uncategorized: _uncategorized,
          showAddCategory: showAddCategory,
          showAllCategoriesOption: false,
          showUncategorizedOption: false,
        );
      },
    );
  }

  List<Widget> confirmDialogActions(
    BuildContext context,
    void Function() onDelete,
  ) {
    return <Widget>[
      TextButton(
        onPressed: () => Navigator.of(context).pop(false),
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: () {
          onDelete();
        },
        child: const Text('Delete'),
      ),
    ];
  }

  AppBar _buildSelectionAppBar() {
    final selectedVideos = _selectedVideos.watch(context);
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      title: Text('${selectedVideos.length} selected'),
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          _selectedVideos.clear();
        },
      ),
      actions: [
        TextButton.icon(
          icon: const Icon(Icons.history),
          label: const Text('Reset Play Count'),
          onPressed: _showResetPlayCountDialog,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: VerticalDivider(color: Colors.white54, thickness: 1),
        ),
        Tooltip(
          message: 'Selects all currently displayed videos.',
          child: TextButton.icon(
            icon: const Icon(Icons.select_all),
            label: const Text('Select All'),
            onPressed: _selectAllVideos,
          ),
        ),
        TextButton.icon(
          icon: const Icon(Icons.category),
          label: const Text('Add to category'),
          onPressed: _showBulkAddCategoryDialog,
        ),
        TextButton.icon(
          icon: const Icon(Icons.remove_circle_outline),
          label: const Text('Remove from category'),
          onPressed: _showBulkRemoveCategoryDialog,
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  AppBar _buildDefaultAppBar(
    bool isLoading,
    String searchQuery,
    SortOption sortOption,
    bool isSortAscending,
    Set<VideoFilter> visibilityFilters,
    bool separateFavorites,
    bool showVideoTitles,
    bool showAverageSpeed,
    bool showAverageMinMax,
    bool showDuration,
    bool showPlayCount,
    UserCategory? selectedCategory,
    int videosPerRow,
  ) {
    final mediaSettings = context.read<MediaLibrarySettingsModel>();
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      title: Row(
        children: [
          if (_searchQuery.isEmpty)
            const Text('Media Library')
          else
            ExpressionVisualizer(
              expression: searchQuery,
              style: Theme.of(context).textTheme.titleLarge,
            ),
        ],
      ),
      actions: [
        TextButton.icon(
          label: const Text("Surprise Me!"),
          icon: const Icon(Icons.shuffle),
          onPressed: _showRandomVideoPicker,
        ),
        const SizedBox(width: 8),
        TextButton.icon(
          label: const Text("Start Playlist"),
          icon: const Icon(Icons.playlist_play),
          onPressed: _startPlaylist,
        ),
        const SizedBox(width: 8),
        // Sorting Dropdown
        DropdownButton<SortOption>(
          value: sortOption,
          icon: const Icon(Icons.sort),
          underline: const SizedBox.shrink(), // Hides the default underline
          isDense: true,
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          borderRadius: BorderRadius.circular(16.0),
          onChanged: (SortOption? newValue) {
            if (newValue != null) {
              mediaSettings.sortOption.value = newValue;
            }
          },
          items: SortOption.values.map((SortOption option) {
            return DropdownMenuItem<SortOption>(
              value: option,
              child: Text(option.label),
            );
          }).toList(),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: Icon(
            isSortAscending ? Icons.arrow_upward : Icons.arrow_downward,
          ),
          onPressed: () {
            mediaSettings.isSortAscending.value =
                !mediaSettings.isSortAscending.value;
          },
          tooltip: isSortAscending ? 'Sort Descending' : 'Sort Ascending',
        ),
        const SizedBox(width: 8),
        PopupMenuButton<dynamic>(
          icon: const Icon(Icons.visibility),
          tooltip: 'View Options',
          onSelected: (dynamic value) {
            if (value is VideoFilter) {
              final currentFilters = visibilityFilters.toSet();
              if (currentFilters.contains(value)) {
                currentFilters.remove(value);
              } else {
                currentFilters.add(value);
              }
              mediaSettings.visibilityFilters.value = currentFilters;
            } else if (value == 'toggle_titles') {
              mediaSettings.showVideoTitles.value =
                  !mediaSettings.showVideoTitles.value;
            } else if (value == 'show_average_speed') {
              mediaSettings.showAverageSpeed.value =
                  !mediaSettings.showAverageSpeed.value;
            } else if (value == 'show_average_min_max') {
              mediaSettings.showAverageMinMax.value =
                  !mediaSettings.showAverageMinMax.value;
            } else if (value == 'show_duration') {
              mediaSettings.showDuration.value =
                  !mediaSettings.showDuration.value;
            } else if (value == 'separate_favorites') {
              mediaSettings.separateFavorites.value =
                  !mediaSettings.separateFavorites.value;
            } else if (value == 'show_play_count') {
              mediaSettings.showPlayCount.value =
                  !mediaSettings.showPlayCount.value;
            }
          },
          itemBuilder: (BuildContext context) {
            return <PopupMenuEntry<dynamic>>[
              ...VideoFilter.values.map((VideoFilter filter) {
                return CheckedPopupMenuItem<VideoFilter>(
                  value: filter,
                  checked: visibilityFilters.contains(filter),
                  child: Text(filter.label),
                );
              }),
              const PopupMenuDivider(),
              CheckedPopupMenuItem<String>(
                value: 'separate_favorites',
                checked: separateFavorites,
                child: const Text('Separate Favorites/Dislikes'),
              ),
              const PopupMenuDivider(),
              CheckedPopupMenuItem<String>(
                value: 'toggle_titles',
                checked: showVideoTitles,
                child: const Text('Show Titles'),
              ),
              CheckedPopupMenuItem<String>(
                value: 'show_average_speed',
                checked: showAverageSpeed,
                child: const Text('Show Average Speed'),
              ),
              CheckedPopupMenuItem<String>(
                value: 'show_average_min_max',
                checked: showAverageMinMax,
                child: const Text('Show Average Min/Max'),
              ),
              CheckedPopupMenuItem<String>(
                value: 'show_duration',
                checked: showDuration,
                child: const Text('Show Duration'),
              ),
              CheckedPopupMenuItem<String>(
                value: 'show_play_count',
                checked: showPlayCount,
                child: const Text('Show Play Count'),
              ),
            ];
          },
        ),
        const SizedBox(width: 8),
        // Filter Buttons
        ActionChip(
          avatar: const Icon(Icons.filter_list),
          label: const Text('Metadata'),
          onPressed: _showFunscriptMetadataFilterDialog,
        ),
        const SizedBox(width: 8),
        ActionChip(
          avatar: const Icon(Icons.category_outlined),
          label: Text(selectedCategory?.name ?? 'Category'),
          onPressed: _showCategoryDialog,
        ),
        const SizedBox(width: 8),
        // Videos Per Row Dropdown)
        Tooltip(
          message: 'Videos per row',
          child: DropdownButton<int>(
            value: videosPerRow,
            isDense: true,
            underline: const SizedBox.shrink(), // Hides the default underline
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            borderRadius: BorderRadius.circular(16.0),
            onChanged: (int? newValue) {
              if (newValue != null) {
                mediaSettings.videosPerRow.value = newValue;
              }
            },
            items:
                List.generate(9, (i) => i + 2) // 2 to 10
                    .map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    })
                    .toList(),
          ),
        ),
        const SizedBox(width: 8),
        // Refresh Button
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: isLoading ? null : _refreshVideos,
          tooltip: 'Refresh',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaManager = context.read<MediaManager>();
    final mediaSettings = context.read<MediaLibrarySettingsModel>();

    // Snapshot the signals
    final filteredVideos = _filteredVideos.watch(context);
    final isLoading = _isLoading.watch(context);
    final showTitle = mediaSettings.showVideoTitles.watch(context);
    final showAverageSpeed = mediaSettings.showAverageSpeed.watch(context);
    final showAverageMinMax = mediaSettings.showAverageMinMax.watch(context);
    final showDuration = mediaSettings.showDuration.watch(context);
    final showPlayCount = mediaSettings.showPlayCount.watch(context);
    final searchQuery = _searchQuery.watch(context);
    final sortOption = mediaSettings.sortOption.watch(context);
    final isSortAscending = mediaSettings.isSortAscending.watch(context);
    final visiblityFilters = mediaSettings.visibilityFilters.watch(context);
    final separateFavorites = mediaSettings.separateFavorites.watch(context);
    final showVideoTitle = mediaSettings.showVideoTitles.watch(context);
    final selectedCategory = _selectedCategory.watch(context);
    final videosPerRow = mediaSettings.videosPerRow.watch(context);

    final selectedVideos = _selectedVideos.watch(context);

    return Scaffold(
      appBar: _isSelectionMode
          ? _buildSelectionAppBar()
          : _buildDefaultAppBar(
              isLoading,
              searchQuery,
              sortOption,
              isSortAscending,
              visiblityFilters,
              separateFavorites,
              showVideoTitle,
              showAverageSpeed,
              showAverageMinMax,
              showDuration,
              showPlayCount,
              selectedCategory,
              videosPerRow,
            ),
      body: Column(
        children: [
          MediaSearchBar(
            onSearchChanged: (query) {
              if (_searchQuery.value == query) {
                return;
              }
              _searchQuery.value = query;
            },
          ),

          if (!isLoading)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Showing ${filteredVideos.length} of ${mediaManager.allVideos.length} videos',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Tooltip(
                    message:
                        'Long-press or right-click an item for more options.',
                    child: IconButton(
                      icon: const Icon(Icons.info_outline, size: 16),
                      onPressed: () {},
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: Stack(
              children: [
                if (isLoading)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Watch.builder(
                          builder: (context) {
                            final value = context
                                .read<MediaManager>()
                                .videoCountNotifier
                                .value;
                            return Text('Found $value videos...');
                          },
                        ),
                      ],
                    ),
                  ),
                if (!isLoading && filteredVideos.isEmpty)
                  Center(
                    child: Text(
                      _searchQuery.isEmpty
                          ? 'No videos found in configured paths.'
                          : 'No videos found for "$_searchQuery".',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  )
                else
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                    child: GridView.builder(
                      key: ValueKey(filteredVideos.length),
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: videosPerRow,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio:
                            16 / 9, // Standard 16:9 video aspect ratio
                      ),
                      itemCount: filteredVideos.length,
                      itemBuilder: (context, index) {
                        final video = filteredVideos[index];
                        final isSelected = selectedVideos.contains(video);
                        return VideoItem(
                          key: Key(video.videoHash),
                          video: video,
                          isSelected: isSelected,
                          showAverageMinMax: showAverageMinMax,
                          showAverageSpeed: showAverageSpeed,
                          showDuration: showDuration,
                          showPlayCount: showPlayCount,
                          showTitle: showTitle,
                          onVideoTapped: (video) {
                            if (_isSelectionMode) {
                              if (isSelected) {
                                _selectedVideos.remove(video);
                              } else {
                                _selectedVideos.add(video);
                              }
                            } else {
                              widget.onVideoTapped(video);
                            }
                          },
                          onLongPress: () {
                            if (isSelected) {
                              _selectedVideos.remove(video);
                            } else {
                              _selectedVideos.add(video);
                            }
                          },
                          onFavoriteChanged: (video) {
                            mediaManager.saveFavorite(video);
                            _updateVideosFromMediaSettings();
                          },
                          onDislikeChanged: (video) {
                            mediaManager.saveDislike(video);
                            _updateVideosFromMediaSettings();
                          },
                          onCategoryChanged: (video, category, removeCategory) {
                            if (removeCategory) {
                              mediaManager.removeVideoCategory(video, category);
                            } else {
                              mediaManager.setVideoCategory(video, category);
                            }
                            _updateVideosFromMediaSettings();
                          },
                          onDelete: _deleteVideo,
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showResetPlayCountDialog() async {
    for (var video in _selectedVideos.value) {
      video.playCount = 0;
      await DatabaseHelper().updateVideo(video);
    }
    _selectedVideos.clear();
  }
}
