import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/floating_toolbar.dart';
import 'package:syncopathy/helper/constants.dart';
import 'package:syncopathy/helper/effect_dispose_mixin.dart';
import 'package:syncopathy/ioc.dart'
    show activePageIndex, getIt, mediaPageIndex, oBox;
import 'package:syncopathy/media_library/category_selection_dialog.dart';
import 'package:syncopathy/media_library/filter/media_filter.dart';
import 'package:syncopathy/media_library/filter/media_filter_logic.dart';
import 'package:syncopathy/media_library/media_filter_overlay.dart';
import 'package:syncopathy/media_library/media_item.dart';
import 'package:syncopathy/media_library/delete_media_dialog.dart';
import 'package:syncopathy/media_library/media_manager.dart';
import 'package:syncopathy/media_library/move_media_dialog.dart';
import 'package:syncopathy/media_library/search_bar.dart';
import 'package:syncopathy/media_library/wheel_of_fortune.dart';
import 'package:syncopathy/notification_feed.dart';
import 'package:syncopathy/model/media_library_settings_model.dart';
import 'package:syncopathy/model/settings_model.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';
import 'package:syncopathy/player/video_player.dart';
import 'package:syncopathy/settings_overlay.dart';

class MediaLibrary extends StatefulWidget {
  const MediaLibrary({super.key});

  @override
  State<MediaLibrary> createState() => _MediaLibraryState();
}

class _MediaLibraryState extends State<MediaLibrary>
    with SignalsMixin, EffectDispose {
  // Upper bound for the shuffle seed; any large range works, this just keeps
  // seeds human-readable.
  static const int _randomSeedRange = 1000000;

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
  late final Signal<bool> isFiltering = createSignal(false);

  // Random seed for shuffle
  late final Signal<int?> randomSeed = createSignal(null);

  @override
  void initState() {
    super.initState();

    final mediaSettings = context.read<MediaLibrarySettingsModel>();
    effect(() {
      final sortOption = mediaSettings.sortOption.value;
      if (sortOption == SortOption.random) {
        if (randomSeed.peek() == null) {
          randomSeed.value = Random().nextInt(_randomSeedRange);
        }
      } else {
        if (randomSeed.peek() != null) {
          randomSeed.value = null;
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    effectDispose();
  }

  List<MediaFile> _filterSignal() {
    // Suspend the grid's reactivity while the media page isn't the visible page.
    // Reading activePageIndex first makes it the only dependency when inactive,
    // so DB writes during video playback (e.g. the view-count bump) don't re-run
    // filterAndSort or rebuild the off-screen grid on the UI thread. When the
    // page becomes visible again this recomputes once with fresh data.
    if (activePageIndex.value != mediaPageIndex) {
      return _lastFiltered;
    }

    final mediaSettings = context.read<MediaLibrarySettingsModel>();

    // Watch all relevant signals to trigger re-computation.
    // We use .value or .watch() to track dependencies in a computed signal.
    // .watch(context) should only be used in build() methods.
    final query = searchQuery.value;
    mediaFilter.stateChange.value;
    final sortOption = mediaSettings.sortOption.value;
    final isSortAscending = mediaSettings.isSortAscending.value;
    final visibilityFilters = mediaSettings.visibilityFilters.value;
    final separateFavorites = mediaSettings.separateFavorites.value;
    final seed = randomSeed.value;

    // Re-trigger on any DB change
    final allMedia = oBox.mediaService.allMediaFiles.value;

    // Re-trigger on playlist change (PlaylistFilter reads the live playlist via
    // getIt during matching; we only watch it here to recompute on change).
    getIt.get<VideoPlayer>().currentPlaylist.value.entries.value;

    final List<MediaFile> searchedMedia;
    if (query.isEmpty) {
      searchedMedia = allMedia;
    } else {
      searchedMedia = oBox.mediaService.findByQuery(query);
    }

    _lastFiltered = MediaFilterLogic.filterAndSort(
      media: searchedMedia,
      customFilter: mediaFilter,
      sortOption: sortOption,
      isSortAscending: isSortAscending,
      visibilityFilters: visibilityFilters,
      separateFavorites: separateFavorites,
      randomSeed: seed,
    );
    return _lastFiltered;
  }

  // Last computed result, returned as-is while the page is off-screen so the
  // grid keeps its content without re-running the filter/sort pipeline.
  List<MediaFile> _lastFiltered = const [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildToolbar(context),
        Expanded(child: _buildBody(context)),
      ],
    );
  }

  Widget _buildToolbar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
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
            _buildSortMenu(context),
            _buildSortDirectionButton(context),
            const SizedBox(width: 8),
            _buildFilterToggleButton(context),
            const SizedBox(width: 8),
            _buildViewOptionsMenu(context),
            const SizedBox(width: 8),
            IconButton(
              tooltip: "Surprise Me!",
              style: IconButton.styleFrom(
                backgroundColor: colorScheme.onInverseSurface,
              ),
              icon: const Icon(Icons.attractions),
              color: colorScheme.primary,
              onPressed: _showRandomVideoPicker,
            ),
            const SizedBox(width: 8),
            IconButton(
              tooltip: "Start Playlist",
              style: IconButton.styleFrom(
                backgroundColor: colorScheme.onInverseSurface,
              ),
              color: colorScheme.primary,
              icon: const Icon(Icons.playlist_play),
              onPressed: _startPlaylist,
            ),
            const SizedBox(width: 8),
            _buildStatusText(context),
            Tooltip(
              message: 'Long-press or right-click an item for more options.',
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.info_outline,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(width: 8),
            _buildRefreshButton(context),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildSortMenu(BuildContext context) {
    final mediaSettings = context.read<MediaLibrarySettingsModel>();
    final sortOption = mediaSettings.sortOption.watch(context);
    return PopupMenuButton<SortOption>(
      menuPadding: EdgeInsets.zero,
      tooltip: "Sorting",
      borderRadius: BorderRadius.circular(16.0),
      onSelected: (option) {
        if (option == SortOption.random &&
            mediaSettings.sortOption.peek() == SortOption.random) {
          randomSeed.value = Random().nextInt(_randomSeedRange);
        }
        mediaSettings.sortOption.value = option;
      },
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
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
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
    );
  }

  Widget _buildSortDirectionButton(BuildContext context) {
    final mediaSettings = context.read<MediaLibrarySettingsModel>();
    final sortOption = mediaSettings.sortOption.watch(context);
    final isSortAscending = mediaSettings.isSortAscending.watch(context);
    return IconButton(
      icon: Icon(
        sortOption == SortOption.random
            ? Icons.shuffle
            : isSortAscending
            ? Icons.arrow_upward
            : Icons.arrow_downward,
      ),
      onPressed: sortOption == SortOption.random
          ? () => randomSeed.value = Random().nextInt(_randomSeedRange)
          : () {
              mediaSettings.isSortAscending.value =
                  !mediaSettings.isSortAscending.value;
            },
      tooltip: sortOption == SortOption.random
          ? 'Randomize'
          : (isSortAscending ? 'Sort Descending' : 'Sort Ascending'),
    );
  }

  Widget _buildFilterToggleButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final showFilterSettings = _showFilterSettings.watch(context);
    final isCustomized = mediaFilter.isCustomized.watch(context);
    return IconButton(
      icon: const Icon(Icons.tune),
      isSelected: showFilterSettings,
      style: IconButton.styleFrom(
        backgroundColor: showFilterSettings
            ? colorScheme.secondaryContainer
            : isCustomized
            ? colorScheme.primaryContainer
            : colorScheme.onInverseSurface,
        foregroundColor: showFilterSettings
            ? colorScheme.onSecondaryContainer
            : isCustomized
            ? colorScheme.onPrimaryContainer
            : colorScheme.primary,
        side: isCustomized
            ? BorderSide(color: colorScheme.primary, width: 1.0)
            : BorderSide.none,
      ),
      color: colorScheme.primary,
      onPressed: () => _showFilterSettings.value = !showFilterSettings,
    );
  }

  Widget _buildViewOptionsMenu(BuildContext context) {
    final mediaSettings = context.read<MediaLibrarySettingsModel>();
    final videosPerRow = mediaSettings.videosPerRow.watch(context);
    final visibilityFilters = mediaSettings.visibilityFilters.watch(context);
    final separateFavorites = mediaSettings.separateFavorites.watch(context);
    final showTitle = mediaSettings.showVideoTitles.watch(context);
    final showAverageSpeed = mediaSettings.showAverageSpeed.watch(context);
    final showAverageMinMax = mediaSettings.showAverageMinMax.watch(context);
    final showDuration = mediaSettings.showDuration.watch(context);
    final showPlayCount = mediaSettings.showPlayCount.watch(context);
    return MenuAnchor(
      style: MenuStyle(padding: WidgetStatePropertyAll(EdgeInsets.zero)),
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
            backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
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
          menuChildren: List.generate(9, (i) => i + 2).map((int value) {
            final isSelected = videosPerRow == value;
            return MenuItemButton(
              onPressed: () => mediaSettings.videosPerRow.value = value,
              closeOnActivate: false,
              trailingIcon: isSelected
                  ? const Icon(Icons.check, size: 16)
                  : null,
              child: Text('$value per row'),
            );
          }).toList(),
          child: Text('Videos per row ($videosPerRow)'),
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
              mediaSettings.visibilityFilters.value = currentFilters;
            },
          );
        }),
        // display changes
        const Divider(height: 1, thickness: 1),
        _buildToggleItem(
          context: context,
          label: 'Separate Favorites/Dislikes',
          value: separateFavorites,
          onTap: () =>
              mediaSettings.separateFavorites.value = !separateFavorites,
        ),
        const Divider(height: 1, thickness: 1),
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
    );
  }

  Widget _buildStatusText(BuildContext context) {
    final currentlyFiltering = isFiltering.watch(context);
    if (currentlyFiltering) return const SizedBox.shrink();

    final mediaFiles = filteredMedia.watch(context);
    final mediaManager = getIt.get<MediaManager>();
    return Padding(
      padding: EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Watch((context) {
            if (mediaManager.isIndexing.value) {
              return Text(
                mediaManager.indexingStatus.value ?? "Indexing...",
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.merge(GoogleFonts.robotoMono()),
              );
            } else {
              final total = oBox.mediaService.allMediaFiles.value.length;
              return Text(
                '${mediaFiles.length} / $total videos',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.merge(GoogleFonts.robotoMono()),
              );
            }
          }),
        ],
      ),
    );
  }

  Widget _buildRefreshButton(BuildContext context) {
    final mediaManager = getIt.get<MediaManager>();
    return Watch((context) {
      final isIndexing = mediaManager.isIndexing.value;
      final progress = mediaManager.indexingProgress.value;
      return Stack(
        alignment: Alignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: isIndexing ? null : mediaManager.startIndexing,
            tooltip: 'Refresh',
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
            ),
            color: Theme.of(context).colorScheme.primary,
          ),
          if (isIndexing)
            SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 3,
              ),
            ),
        ],
      );
    });
  }

  Widget _buildBody(BuildContext context) {
    final currentlyFiltering = isFiltering.watch(context);
    final showFilterSettings = _showFilterSettings.watch(context);
    final isSelecting = _isSelecting.watch(context);
    final mediaFiles = filteredMedia.watch(context);

    return Stack(
      children: [
        if (!currentlyFiltering && mediaFiles.isEmpty)
          Center(
            child: Text(
              'No videos found.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          )
        else
          _fade(ExcludeFocus(child: _buildGrid(context, mediaFiles))),
        if (isSelecting) _buildFloatingToolbar(),
        SettingsOverlay(
          showSettings: showFilterSettings,
          child: MediaFilterOverlay(filter: mediaFilter),
        ),
      ],
    );
  }

  Widget _buildGrid(BuildContext context, List<MediaFile> mediaFiles) {
    final mediaSettings = context.read<MediaLibrarySettingsModel>();
    final videosPerRow = mediaSettings.videosPerRow.watch(context);
    final showDuration = mediaSettings.showDuration.watch(context);
    final showPlayCount = mediaSettings.showPlayCount.watch(context);
    final showTitle = mediaSettings.showVideoTitles.watch(context);
    final showAverageSpeed = mediaSettings.showAverageSpeed.watch(context);
    final showAverageMinMax = mediaSettings.showAverageMinMax.watch(context);
    final isSelecting = _isSelecting.watch(context);

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 0.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: videosPerRow,
        childAspectRatio: 16 / 9,
      ),
      itemCount: mediaFiles.length,
      itemBuilder: (context, index) {
        final media = mediaFiles[index];
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
              final reason = media.unplayableReason;
              if (reason != null) {
                AlertManager.showError(
                  '${media.name} cannot be played: $reason',
                );
                return;
              }
              getIt.get<VideoPlayer>().openSingleVideo(media);
            }
          },
          toggleDislike: () =>
              oBox.mediaRepository.toggleRating(media, MediaRating.dislike),
          toggleFavorite: () =>
              oBox.mediaRepository.toggleRating(media, MediaRating.like),
          onDelete: () => _deleteMedia(media),
        );
      },
    );
  }

  Widget _buildFloatingToolbar() {
    final colorScheme = Theme.of(context).colorScheme;
    return Stack(
      children: [
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
                    icon: Icon(Icons.close, color: colorScheme.error),
                    label: Text(
                      '${selectedVideos.length}',
                      style: TextStyle(color: colorScheme.error),
                    ),
                    onPressed: () => selectedVideos.clear(),
                  ),
                ),
                const VerticalDivider(),
                Tooltip(
                  message: 'Select All',
                  child: IconButton(
                    icon: const Icon(Icons.select_all),
                    onPressed: () => selectedVideos.addAll(filteredMedia.value),
                  ),
                ),
                const VerticalDivider(),
                Tooltip(
                  message: 'Like',
                  child: IconButton(
                    icon: Icon(Icons.star, color: favoriteColor),
                    onPressed: () => _bulkSetRating(MediaRating.like),
                  ),
                ),
                Tooltip(
                  message: 'Dislike',
                  child: IconButton(
                    icon: Icon(Icons.thumb_down, color: dislikeColor),
                    onPressed: () => _bulkSetRating(MediaRating.dislike),
                  ),
                ),
                Tooltip(
                  message: 'Unrate',
                  child: IconButton(
                    icon: const Icon(Icons.star_outline),
                    onPressed: () => _bulkSetRating(MediaRating.noRating),
                  ),
                ),
                const VerticalDivider(),
                Tooltip(
                  message: 'Add to category',
                  child: IconButton(
                    icon: const Icon(Icons.category),
                    onPressed: _showBulkAddCategoryDialog,
                  ),
                ),
                Tooltip(
                  message: 'Remove from category',
                  child: IconButton(
                    icon: const Icon(Icons.layers_clear),
                    onPressed: _showBulkRemoveCategoryDialog,
                  ),
                ),
                const VerticalDivider(),
                Tooltip(
                  message: 'Reset Play Count',
                  child: IconButton(
                    icon: const Icon(Icons.history),
                    onPressed: _bulkResetPlayCount,
                  ),
                ),
                const VerticalDivider(),
                Tooltip(
                  message: 'Move Files',
                  child: IconButton(
                    icon: const Icon(Icons.drive_file_move),
                    onPressed: _showMoveMediaDialog,
                  ),
                ),
                const VerticalDivider(),
                Tooltip(
                  message: 'Remove from Library',
                  child: IconButton(
                    icon: Icon(Icons.delete_forever, color: colorScheme.error),
                    onPressed: _bulkDeleteMedia,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _bulkSetRating(MediaRating rating) {
    oBox.mediaRepository.bulkSetRating(selectedVideos.value, rating);
    selectedVideos.clear();
  }

  Future<void> _bulkResetPlayCount() async {
    final count = selectedVideos.length;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reset Play Count for $count Items?'),
        content: Text(
          'Are you sure you want to reset the play count for $count selected items?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      oBox.mediaRepository.bulkResetPlayCount(selectedVideos.value);
      selectedVideos.clear();
    }
  }

  Future<void> _deleteMedia(MediaFile media) async {
    await showDialog<bool>(
      context: context,
      builder: (context) => DeleteMediaDialog(selectedMedia: {media}),
    );
  }

  Future<void> _showMoveMediaDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => MoveMediaDialog(
        selectedMedia: Set.from(selectedVideos.value),
        searchPaths: context.read<SettingsModel>().mediaPaths.value,
      ),
    );
    if (result == true) selectedVideos.clear();
  }

  Future<void> _bulkDeleteMedia() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) =>
          DeleteMediaDialog(selectedMedia: Set.from(selectedVideos.value)),
    );
    if (result == true) selectedVideos.clear();
  }

  Future<void> _showBulkAddCategoryDialog() async {
    final categoryId = await _showCategorySelectionDialog();
    final category = categoryId != null
        ? oBox.userCategoryService.getById(categoryId)
        : null;
    if (category != null) {
      oBox.mediaRepository.bulkAddCategory(selectedVideos.value, category);
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
      oBox.mediaRepository.bulkRemoveCategory(selectedVideos.value, category);
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
        .where((video) => !video.isDislike && video.isPlayable)
        .toList();
    if (playlistVideos.isEmpty) {
      if (!mounted) return;
      AlertManager.showError('No playable videos in the current filter.');
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
      return !v.isDislike && !shouldHideUnrated && v.isPlayable;
    }).toList();

    if (availableVideos.isEmpty) {
      if (mounted) {
        AlertManager.showError('No playable videos available to choose from.');
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
          mediaFiles: availableVideos,
          onMediaSelected: (media) {
            getIt.get<VideoPlayer>().openSingleVideo(media);
          },
        );
      },
    );
  }
}
