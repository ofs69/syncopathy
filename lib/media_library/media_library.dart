import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/floating_toolbar.dart';
import 'package:syncopathy/helper/effect_dispose_mixin.dart';
import 'package:syncopathy/ioc.dart' show getIt, oBox;
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/media_library/category_selection_dialog.dart';
import 'package:syncopathy/media_library/filter/media_filter.dart';
import 'package:syncopathy/media_library/media_filter_overlay.dart';
import 'package:syncopathy/media_library/media_item.dart';
import 'package:syncopathy/media_library/media_manager.dart';
import 'package:syncopathy/media_library/search_bar.dart';
import 'package:syncopathy/model/media_library_settings_model.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';
import 'package:syncopathy/player/video_player.dart';
import 'package:syncopathy/settings_overlay.dart';

enum SortOption {
  title('Title'),
  speed('Speed'),
  depth('Depth'),
  duration('Duration'),
  lastModified('Modified'),
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
  late final ReadonlySignal<List<MediaFile>> filteredMedia = computed(
    _filterSignal,
  );

  // filters
  final MediaFilter mediaFilter = MediaFilter();
  late final Signal<String> searchQuery = createSignal("");
  late final Signal<bool> _showFilterSettings = createSignal(false);

  // selection
  late final SetSignal<MediaFile> selectedVideos = createSetSignal({});
  late final ReadonlySignal<bool> _isSelecting = computed(() {
    return selectedVideos.isNotEmpty;
  });

  // media manager is busy indexing
  late final ReadonlySignal<bool> isIndexing;
  late final Signal<bool> isFiltering = createSignal(false);

  @override
  void initState() {
    super.initState();
    isIndexing = getIt.get<MediaManager>().isIndexing;
  }

  @override
  void dispose() {
    super.dispose();
    effectDispose();
  }

  List<MediaFile> _filterSignal() {
    final _ = oBox.mediaService.allMediaFiles.value;
    final query = searchQuery.value;
    return oBox.mediaService.findByQuery(query);
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
    final visibilityFilters = mediaSettings.visibilityFilters.watch(context);
    final separateFavorites = mediaSettings.separateFavorites.watch(context);
    final sortOption = mediaSettings.sortOption.watch(context);
    final isSortAscending = mediaSettings.isSortAscending.watch(context);
    final isSelecting = _isSelecting.watch(context);
    final showFilterSettings = _showFilterSettings.watch(context);

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: MediaSearchBar(
                    onFilterChanged: (query) => searchQuery.value = query,
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<SortOption>(
                  menuPadding: EdgeInsets.zero,
                  tooltip: "Sorting",
                  borderRadius: BorderRadius.circular(16.0),
                  onSelected: (option) =>
                      mediaSettings.sortOption.value = option,
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 8.0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 70,
                          child: Text(
                            sortOption.label,
                            style: Theme.of(context).textTheme.labelLarge,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down),
                      ],
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
                  tooltip: isSortAscending
                      ? 'Sort Descending'
                      : 'Sort Ascending',
                ),
                const SizedBox(width: 8),
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.tune),
                      isSelected: showFilterSettings,
                      style: IconButton.styleFrom(
                        backgroundColor: showFilterSettings
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(context).colorScheme.onInverseSurface,
                        foregroundColor: showFilterSettings
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : Theme.of(context).colorScheme.primary,
                      ),
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () =>
                          _showFilterSettings.value = !showFilterSettings,
                    ),
                    if (mediaFilter.isCustomized.watch(context))
                      Positioned(
                        right: 0,
                        top: 0,
                        child: IgnorePointer(
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 8),
                MenuAnchor(
                  style: MenuStyle(
                    padding: WidgetStatePropertyAll(EdgeInsets.zero),
                  ),
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
                      style: IconButton.styleFrom(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.onInverseSurface,
                      ),
                      color: Theme.of(context).colorScheme.primary,
                    );
                  },
                  menuChildren: [
                    // videos per row
                    SubmenuButton(
                      menuStyle: MenuStyle(
                        padding: WidgetStatePropertyAll(EdgeInsets.zero),
                      ),
                      leadingIcon: const Icon(Icons.grid_view),
                      menuChildren: List.generate(9, (i) => i + 2).map((
                        int value,
                      ) {
                        final isSelected =
                            mediaSettings.videosPerRow.value == value;
                        return MenuItemButton(
                          onPressed: () =>
                              mediaSettings.videosPerRow.value = value,
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
                    const Divider(height: 1, thickness: 1),
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
                          mediaSettings.visibilityFilters.value =
                              currentFilters;
                        },
                      );
                    }),
                    // display changes
                    const Divider(height: 1, thickness: 1),
                    _buildToggleItem(
                      context: context,
                      label: 'Separate Favorites/Dislikes',
                      value: separateFavorites,
                      onTap: () => mediaSettings.separateFavorites.value =
                          !separateFavorites,
                    ),
                    const Divider(height: 1, thickness: 1),
                    _buildToggleItem(
                      context: context,
                      label: 'Show Titles',
                      value: showTitle,
                      onTap: () =>
                          mediaSettings.showVideoTitles.value = !showTitle,
                    ),
                    _buildToggleItem(
                      context: context,
                      label: 'Show Average Speed',
                      value: showAverageSpeed,
                      onTap: () => mediaSettings.showAverageSpeed.value =
                          !showAverageSpeed,
                    ),
                    _buildToggleItem(
                      context: context,
                      label: 'Show Average Min/Max',
                      value: showAverageMinMax,
                      onTap: () => mediaSettings.showAverageMinMax.value =
                          !showAverageMinMax,
                    ),
                    _buildToggleItem(
                      context: context,
                      label: 'Show Duration',
                      value: showDuration,
                      onTap: () =>
                          mediaSettings.showDuration.value = !showDuration,
                    ),
                    _buildToggleItem(
                      context: context,
                      label: 'Show Play Count',
                      value: showPlayCount,
                      onTap: () =>
                          mediaSettings.showPlayCount.value = !showPlayCount,
                    ),
                  ],
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
                  color: Theme.of(context).colorScheme.primary,
                  icon: const Icon(Icons.playlist_play),
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
                  message:
                      'Long-press or right-click an item for more options.',
                  child: IconButton(
                    icon: const Icon(Icons.info_outline, size: 16),
                    onPressed: () {},
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: isIndexing.watch(context)
                      ? null
                      : getIt.get<MediaManager>().startIndexing,
                  tooltip: 'Refresh',
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.onInverseSurface,
                  ),
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 4),
              ],
            ),
          ),
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
                        return FadeTransition(opacity: animation, child: child);
                      },
                  child: _fade(
                    ExcludeFocus(
                      child: GridView.builder(
                        key: ValueKey(filteredMedia.length),
                        padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 0.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: videosPerRow,
                          childAspectRatio: 16 / 9,
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
                            onLongPress: () {
                              if (isSelected) {
                                selectedVideos.remove(media);
                              } else {
                                selectedVideos.add(media);
                              }
                            },
                            onTap: () {
                              if (isSelecting) {
                                if (isSelected) {
                                  selectedVideos.remove(media);
                                } else {
                                  selectedVideos.add(media);
                                }
                              } else {
                                // play media
                                getIt.get<VideoPlayer>().openSingleVideo(media);
                              }
                            },
                            toggleDislike: () {
                              media.rating = media.rating != MediaRating.dislike
                                  ? MediaRating.dislike
                                  : MediaRating.noRating;
                              oBox.mediaService.save(media);
                            },
                            toggleFavorite: () {
                              media.rating = media.rating != MediaRating.like
                                  ? MediaRating.like
                                  : MediaRating.noRating;
                              oBox.mediaService.save(media);
                            },
                            onDelete: () {},
                          );
                        },
                      ),
                    ),
                  ),
                ),
              if (isSelecting) _buildFloatingToolbar(),
              SettingsOverlay(
                showSettings: showFilterSettings,
                child: MediaFilterOverlay(filter: mediaFilter),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingToolbar() {
    return Stack(
      children: [
        // Your main content here
        Positioned(
          bottom: 24.0, // Floating distance from bottom
          left: 0,
          right: 0,
          child: Center(
            child: FloatingToolbar(
              children: [
                Tooltip(
                  message: "Exit Selection Mode",
                  child: TextButton.icon(
                    icon: const Icon(Icons.close),
                    label: Text('${selectedVideos.length}'),
                    onPressed: () => selectedVideos.clear(),
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.history),
                  label: const Text('Reset Play Count'),
                  onPressed: () => throw UnimplementedError(),
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
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showBulkAddCategoryDialog() async {
    final categoryId = await _showCategorySelectionDialog();
    final category = categoryId != null
        ? oBox.userCategoryService.getById(categoryId)
        : null;
    if (category != null) {
      for (final video in selectedVideos.value) {
        video.categories.add(category);
        oBox.mediaService.save(video);
      }
      selectedVideos.clear();
    }
  }

  Future<int?> _showCategorySelectionDialog({
    bool showAddCategory = true,
    Set<int>? preFilterCategories,
  }) async {
    return await showModalBottomSheet<int?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return CategorySelectionDialog(
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
        video.categories.removeWhere((c) => c.id == category);
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
