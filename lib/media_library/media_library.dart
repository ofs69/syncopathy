import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/helper/effect_dispose_mixin.dart';
import 'package:syncopathy/ioc.dart' show getIt, oBox;
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/media_library/category_selection_dialog.dart';
import 'package:syncopathy/media_library/funscript_metadata_filter_bottom_sheet.dart';
import 'package:syncopathy/media_library/media_item.dart';
import 'package:syncopathy/media_library/media_manager.dart';
import 'package:syncopathy/media_library/search_bar.dart';
import 'package:syncopathy/model/media_library_settings_model.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';
import 'package:syncopathy/persistence/entities/user_category.dart';
import 'package:syncopathy/player/video_player.dart';

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
  const MediaLibrary({super.key});

  @override
  State<MediaLibrary> createState() => _MediaLibraryState();
}

class _MediaLibraryState extends State<MediaLibrary>
    with SignalsMixin, EffectDispose {
  // filtered media
  late final ReadonlySignal<List<MediaFile>> filteredMedia = computed(() {
    final _ = oBox.mediaService.allMediaFiles.value;
    final query = searchQuery.value;
    return oBox.mediaService.findByQuery(query);
  });

  // filters
  late final Signal<String> searchQuery = createSignal("");
  late final Signal<UserCategory?> selectedCategory = createSignal(null);
  late final SetSignal<String> selectedAuthors = createSetSignal({});
  late final SetSignal<String> selectedTags = createSetSignal({});
  late final SetSignal<String> selectedPerformers = createSetSignal({});

  final _uncategorized = UserCategory(name: 'Uncategorized');

  // selection
  late final SetSignal<MediaFile> selectedVideos = createSetSignal({});
  late final ReadonlySignal<bool> isSelecting = computed(() {
    return selectedVideos.isNotEmpty;
  });

  // media manager is busy indexing
  late final ReadonlySignal<bool> isIndexing;
  late final Signal<bool> isFiltering = createSignal(false);

  @override
  void initState() {
    super.initState();
    isIndexing = getIt.get<MediaManager>().isIndexing;
    effectAdd([
      // effect(() {
      //   final _ = oBox.mediaService.allMediaFiles.value;
      // }),
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    effectDispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentlyFiltering = isFiltering.watch(context);
    final mediaSettings = context.read<MediaLibrarySettingsModel>();
    final videosPerRow = mediaSettings.videosPerRow.watch(context);
    final allMediaFilesCount = oBox.mediaService.allMediaFiles
        .watch(context)
        .length;

    final showDuration = mediaSettings.showDuration.watch(context);
    final showPlayCount = mediaSettings.showPlayCount.watch(context);
    final showTitle = mediaSettings.showVideoTitles.watch(context);
    final showAverageSpeed = mediaSettings.showAverageSpeed.watch(context);
    final showAverageMinMax = mediaSettings.showAverageMinMax.watch(context);

    return Scaffold(
      appBar: isSelecting.watch(context)
          ? _buildSelectionAppBar()
          : _buildDefaultAppBar(
              showDuration: showDuration,
              showPlayCount: showPlayCount,
              showTitle: showTitle,
              showAverageSpeed: showAverageSpeed,
              showAverageMinMax: showAverageMinMax,
            ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: MediaSearchBar(
                  onSearchChanged: (query) {
                    if (searchQuery.value == query) {
                      return;
                    }
                    searchQuery.value = query;
                  },
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: "Surprise Me!",
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.onInverseSurface,
                ),
                icon: const Icon(Icons.attractions),
                color: Theme.of(context).colorScheme.primary,
                onPressed: _showRandomVideoPicker,
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: "Start Playlist",
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.onInverseSurface,
                ),
                icon: const Icon(Icons.playlist_play),
                color: Theme.of(context).colorScheme.primary,
                onPressed: _startPlaylist,
              ),
              const SizedBox(width: 8),
              if (!currentlyFiltering)
                Padding(
                  padding: EdgeInsets.zero,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${filteredMedia.length} / $allMediaFilesCount videos',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              Tooltip(
                message: 'Long-press or right-click an item for more options.',
                child: IconButton(
                  icon: const Icon(Icons.info_outline, size: 16),
                  onPressed: () {},
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),

          Expanded(
            child: Stack(
              children: [
                // if (isLoading)
                //   Center(
                //     child: Column(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         const CircularProgressIndicator(),
                //         const SizedBox(height: 16),
                //         Watch.builder(
                //           builder: (context) {
                //             final value = context
                //                 .read<MediaManager>()
                //                 .videoCountNotifier
                //                 .value;
                //             return Text('Found $value videos...');
                //           },
                //         ),
                //       ],
                //     ),
                //   ),
                if (!currentlyFiltering && filteredMedia.isEmpty)
                  Center(
                    child: Text(
                      'No videos found.',
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
                    child: _fade(
                      GridView.builder(
                        //key: ValueKey(filteredMedia.length),
                        padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 0.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: videosPerRow,
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 4.0,
                          childAspectRatio:
                              16 / 9, // Standard 16:9 video aspect ratio
                        ),
                        itemCount: filteredMedia.length,
                        itemBuilder: (context, index) {
                          final media = filteredMedia[index];
                          final isSelected = selectedVideos.contains(media);

                          return MediaItem(
                            key: Key(media.mediaPath),
                            media: media,
                            isSelected: isSelected,
                            showAverageMinMax: showAverageMinMax,
                            showAverageSpeed: showAverageSpeed,
                            showDuration: showDuration,
                            showPlayCount: showPlayCount,
                            showTitle: showTitle,

                            // onVideoTapped: (video) {
                            //   if (_isSelectionMode) {
                            //     if (isSelected) {
                            //       _selectedVideos.remove(video);
                            //     } else {
                            //       _selectedVideos.add(video);
                            //     }
                            //   } else {
                            //     widget.onVideoTapped(video);
                            //   }
                            // },
                            // onLongPress: () {
                            //   if (isSelected) {
                            //     _selectedVideos.remove(video);
                            //   } else {
                            //     _selectedVideos.add(video);
                            //   }
                            // },
                            // onFavoriteChanged: (video) {
                            //   mediaManager.saveFavorite(video);
                            //   _updateVideosFromMediaSettings();
                            // },
                            // onDislikeChanged: (video) {
                            //   mediaManager.saveDislike(video);
                            //   _updateVideosFromMediaSettings();
                            // },
                            // onCategoryChanged:
                            //     (video, category, removeCategory) {
                            //       if (removeCategory) {
                            //         mediaManager.removeVideoCategory(
                            //           video,
                            //           category,
                            //         );
                            //       } else {
                            //         mediaManager.setVideoCategory(
                            //           video,
                            //           category,
                            //         );
                            //       }
                            //       _updateVideosFromMediaSettings();
                            //     },
                            // onDelete: _deleteVideo,
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildDefaultAppBar({
    required bool showDuration,
    required bool showPlayCount,
    required bool showTitle,
    required bool showAverageSpeed,
    required bool showAverageMinMax,
  }) {
    final mediaSettings = context.read<MediaLibrarySettingsModel>();
    final currentSelectedCategory = selectedCategory.watch(context);
    final visibilityFilters = mediaSettings.visibilityFilters.watch(context);
    final separateFavorites = mediaSettings.separateFavorites.watch(context);
    final sortOption = mediaSettings.sortOption.watch(context);
    final isSortAscending = mediaSettings.isSortAscending.watch(context);

    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      title: Row(
        children: [
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: const Text('Media Library'),
            ),
          ),
        ],
      ),
      actions: [
        ActionChip(
          avatar: const Icon(Icons.filter_list),
          label: const Text('Metadata'),
          onPressed: _showFunscriptMetadataFilterDialog,
        ),
        const SizedBox(width: 8),
        ActionChip(
          avatar: const Icon(Icons.category_outlined),
          label: Text(currentSelectedCategory?.name ?? 'Category'),
          onPressed: _showCategoryDialog,
        ),
        const SizedBox(width: 8),
        MenuAnchor(
          builder: (context, controller, child) {
            return IconButton(
              onPressed: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
              icon: const Icon(Icons.visibility),
              tooltip: 'View Options',
            );
          },
          menuChildren: [
            // videos per row
            SubmenuButton(
              leadingIcon: const Icon(Icons.grid_view),
              menuChildren: List.generate(9, (i) => i + 2).map((int value) {
                final isSelected = mediaSettings.videosPerRow.value == value;
                return MenuItemButton(
                  onPressed: () => mediaSettings.videosPerRow.value = value,
                  closeOnActivate: false,
                  trailingIcon: isSelected
                      ? const Icon(Icons.check, size: 16)
                      : null,
                  child: Text('$value per row'),
                );
              }).toList(),
              child: Text(
                'Videos per row (${mediaSettings.videosPerRow.value})',
              ),
            ),
            const Divider(),
            // filters
            ...VideoFilter.values.map((VideoFilter filter) {
              return _buildToggleItem(
                context: context,
                label: filter.label,
                value: visibilityFilters.contains(filter),
                onTap: () {
                  final currentFilters = visibilityFilters.toSet();
                  if (currentFilters.contains(filter)) {
                    currentFilters.remove(filter);
                  } else {
                    currentFilters.add(filter);
                  }
                  mediaSettings.visibilityFilters.value = currentFilters;
                },
              );
            }),
            const Divider(),
            // display changes
            _buildToggleItem(
              context: context,
              label: 'Separate Favorites/Dislikes',
              value: separateFavorites,
              onTap: () =>
                  mediaSettings.separateFavorites.value = !separateFavorites,
            ),
            const Divider(),
            _buildToggleItem(
              context: context,
              label: 'Show Titles',
              value: showTitle,
              onTap: () => mediaSettings.showVideoTitles.value = !showTitle,
            ),
            _buildToggleItem(
              context: context,
              label: 'Show Average Speed',
              value: showAverageSpeed,
              onTap: () =>
                  mediaSettings.showAverageSpeed.value = !showAverageSpeed,
            ),
            _buildToggleItem(
              context: context,
              label: 'Show Average Min/Max',
              value: showAverageMinMax,
              onTap: () =>
                  mediaSettings.showAverageMinMax.value = !showAverageMinMax,
            ),
            _buildToggleItem(
              context: context,
              label: 'Show Duration',
              value: showDuration,
              onTap: () => mediaSettings.showDuration.value = !showDuration,
            ),
            _buildToggleItem(
              context: context,
              label: 'Show Play Count',
              value: showPlayCount,
              onTap: () => mediaSettings.showPlayCount.value = !showPlayCount,
            ),
          ],
        ),
        const SizedBox(width: 8),
        // Sorting Dropdown
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PopupMenuButton<SortOption>(
              tooltip: "Sorting",
              borderRadius: BorderRadius.circular(16.0),
              onSelected: (option) => mediaSettings.sortOption.value = option,
              itemBuilder: (context) => SortOption.values.map((option) {
                return PopupMenuItem<SortOption>(
                  value: option,
                  child: Row(
                    children: [
                      Icon(
                        Icons.check,
                        color: option == sortOption
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                      ),
                      const SizedBox(width: 8),
                      Text(option.label),
                    ],
                  ),
                );
              }).toList(),
              child: SizedBox(
                width: 170,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 8.0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        sortOption.label,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
            ),
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
          ],
        ),
        const SizedBox(width: 8),
        // Refresh Button
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: isIndexing.watch(context)
              ? null
              : getIt.get<MediaManager>().startIndexing,
          tooltip: 'Refresh',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  AppBar _buildSelectionAppBar() {
    final currentSelectedVideos = selectedVideos.watch(context);
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      title: Text('${selectedVideos.length} selected'),
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          currentSelectedVideos.clear();
        },
      ),
      actions: [
        TextButton.icon(
          icon: const Icon(Icons.history),
          label: const Text('Reset Play Count'),
          onPressed: () => throw UnimplementedError(),
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
            onPressed: () => selectedVideos.addAll(filteredMedia.value),
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

  Future<void> _showFunscriptMetadataFilterDialog() async {
    final authors = oBox.funscriptService.getAllAuthors();
    final tags = oBox.funscriptService.getAllTags();
    final performers = oBox.funscriptService.getAllPerformers();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FunscriptMetadataFilterBottomSheet(
          allAuthors: authors,
          allTags: tags,
          allPerformers: performers,
          selectedAuthors: selectedAuthors,
          selectedTags: selectedTags,
          selectedPerformers: selectedPerformers,
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
    if (selected != selectedCategory.value) {
      selectedCategory.value = selected;
    }
  }

  Future<void> _showBulkAddCategoryDialog() async {
    final category = await _showCategorySelectionDialog();
    if (category != null) {
      for (final video in selectedVideos.value) {
        video.categories.add(category);
        oBox.mediaService.save(video);
      }
      selectedVideos.clear();
    }
  }

  Future<UserCategory?> _showCategorySelectionDialog({
    bool showAddCategory = true,
    Set<int>? preFilterCategories,
  }) async {
    return await showModalBottomSheet<UserCategory?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return CategorySelectionDialog(
          uncategorized: _uncategorized,
          showAddCategory: showAddCategory,
          preFilterCategoriesIds: preFilterCategories,
          showAllCategoriesOption: false,
          showUncategorizedOption: false,
        );
      },
    );
  }

  Future<void> _showBulkRemoveCategoryDialog() async {
    final categoriesToSelect = selectedVideos.value
        .expand((v) => v.categories)
        .map((c) => c.id)
        .toSet();
    final category = await _showCategorySelectionDialog(
      showAddCategory: false,
      preFilterCategories: categoriesToSelect,
    );
    if (category != null) {
      for (final video in selectedVideos.value) {
        video.categories.remove(category);
        oBox.mediaService.save(video);
      }
      selectedVideos.clear();
    }
  }

  Widget _fade(Widget child) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.white,
            Colors.white,
            Colors.transparent,
          ],
          stops: [0.0, 0.02, 0.98, 1.0],
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: child,
    );
  }

  Widget _buildToggleItem({
    required BuildContext context,
    required String label,
    required bool value,
    required VoidCallback onTap,
  }) {
    return MenuItemButton(
      onPressed: onTap,
      closeOnActivate: false,
      leadingIcon: Icon(
        value ? Icons.check_box : Icons.check_box_outline_blank,
        color: value
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      child: Text(label),
    );
  }

  void _startPlaylist() {
    final playlistVideos = filteredMedia
        .where((video) => !video.isDislike)
        .toList();
    if (playlistVideos.isEmpty) {
      if (!mounted) return;
      Logger.error('No non-disliked videos to create a playlist');
      return;
    }
    if (!mounted) return;
    getIt.get<VideoPlayer>().openMultipleVideos(playlistVideos);
  }

  void _showRandomVideoPicker() {
    final mediaSettings = context.read<MediaLibrarySettingsModel>();
    var availableVideos = filteredMedia.where((v) {
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
        Logger.error('No videos available to choose from');
      }
      return;
    }
  }
}
