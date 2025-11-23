import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:syncopathy/funscript_metadata_filter_bottom_sheet.dart';

import 'package:syncopathy/media_manager.dart';
import 'package:syncopathy/model/user_category.dart';
import 'package:syncopathy/video_item.dart';
import 'package:syncopathy/model/video_model.dart';
import 'package:syncopathy/wheel_of_fortune.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/model/player_model.dart';
import 'package:syncopathy/model/media_library_settings.dart';
import 'package:syncopathy/category_selection_dialog.dart';
import 'package:syncopathy/notification_feed.dart';
import 'package:syncopathy/pca.dart';
import 'package:syncopathy/model/funscript.dart';

enum SortOption {
  title('Title'),
  speed('Speed'),
  depth('Depth'),
  duration('Duration'),
  lastModified('Last Modified'),
  random('Random'),
  pca('PCA (Experimental)');

  const SortOption(this.label);
  final String label;
}

class VideoFilter {
  final String label;
  final String id;

  const VideoFilter._(this.label, this.id);

  static const VideoFilter hideFavorite = VideoFilter._(
    'Hide Favorite',
    'hideFavorite',
  );
  static const VideoFilter hideDisliked = VideoFilter._(
    'Hide Disliked',
    'hideDisliked',
  );
  static const VideoFilter hideUnrated = VideoFilter._(
    'Hide Unrated',
    'hideUnrated',
  );

  static List<VideoFilter> get values => [
    hideFavorite,
    hideUnrated,
    hideDisliked,
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoFilter &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class MediaLibrary extends StatefulWidget {
  final void Function(Video) onVideoTapped;
  final MediaManager mediaManager;

  const MediaLibrary({
    super.key,
    required this.onVideoTapped,
    required this.mediaManager,
  });

  @override
  State<MediaLibrary> createState() => _MediaLibraryState();
}

// Helper class to hold stroke data
class _Stroke {
  final double startPos;
  final double endPos;
  final int startTime;
  final int endTime;

  _Stroke({
    required this.startPos,
    required this.endPos,
    required this.startTime,
    required this.endTime,
  });

  double get length => (endPos - startPos).abs();
  int get duration => endTime - startTime;
  double get speed => duration > 0 ? length / duration : 0;
}

final _uncategorized = UserCategory(name: 'Uncategorized');

class _MediaLibraryState extends State<MediaLibrary> {
  late final MediaManager _mediaManager;
  late final MediaLibrarySettings _mediaLibrarySettings;
  late List<Video> _filteredVideos;
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  UserCategory? _selectedCategory;
  Set<String> _selectedAuthors = {};
  Set<String> _selectedTags = {};
  Set<String> _selectedPerformers = {};
  bool _isLoading = false;
  SortOption? _previousSortOption;
  int? _randomSeed;
  final Map<String, List<double>> _pcaScoresByPath = {};
  final Map<Video, List<double>> _videoPcaScores = {};
  Set<String> _videoPathsForPca = {};

  final Set<Video> _selectedVideos = {};
  bool get _isSelectionMode => _selectedVideos.isNotEmpty;

  StreamSubscription? _videoUpdateSubscription;
  StreamSubscription? _settingsSaveSubscription;

  @override
  void initState() {
    super.initState();
    _mediaManager = widget.mediaManager;
    _mediaLibrarySettings = MediaLibrarySettings();
    _mediaLibrarySettings.load().then((_) {
      _updateDisplayedVideos();
      _settingsSaveSubscription = _mediaLibrarySettings.saveNotifier.stream
          .listen((_) => _updateDisplayedVideos());
    });

    _refreshVideos();

    _filteredVideos = [];
    _searchController.addListener(_updateDisplayedVideos);
    _videoUpdateSubscription = _mediaManager.videoUpdates.listen((_) {
      _updateDisplayedVideos();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_updateDisplayedVideos);
    _searchController.dispose();
    _searchFocusNode.dispose();
    _videoUpdateSubscription?.cancel();
    _settingsSaveSubscription?.cancel();
    super.dispose();
  }

  List<String> get _allAuthors {
    final authors = _mediaManager.allVideos
        .map((v) => v.funscriptMetadata?.creator)
        .where((c) => c != null && c.isNotEmpty)
        .cast<String>()
        .toSet()
        .toList();
    authors.sort();
    return authors;
  }

  List<String> get _allTags {
    final tags = _mediaManager.allVideos
        .expand<String>((v) => v.funscriptMetadata?.tags ?? [])
        .toSet()
        .toList();
    tags.sort();
    return tags;
  }

  List<String> get _allPerformers {
    final performers = _mediaManager.allVideos
        .expand<String>((v) => v.funscriptMetadata?.performers ?? [])
        .toSet()
        .toList();
    performers.sort();
    return performers;
  }

  Future<void> _updateDisplayedVideos() async {
    if (!mounted) return;
    if (_isLoading) return;

    final query = _searchController.text.toLowerCase();
    List<Video> videos = _mediaManager.allVideos.where((video) {
      final authorMatch =
          _selectedAuthors.isEmpty ||
          (_selectedAuthors.isNotEmpty &&
              video.funscriptMetadata?.creator != null &&
              _selectedAuthors.contains(video.funscriptMetadata!.creator));
      if (!authorMatch) return false;

      final tagMatch =
          _selectedTags.isEmpty ||
          (_selectedTags.isNotEmpty &&
              video.funscriptMetadata?.tags != null &&
              video.funscriptMetadata!.tags.any(
                (tag) => _selectedTags.contains(tag),
              ));
      if (!tagMatch) return false;

      final performerMatch =
          _selectedPerformers.isEmpty ||
          (_selectedPerformers.isNotEmpty &&
              video.funscriptMetadata?.performers != null &&
              video.funscriptMetadata!.performers.any(
                (performer) => _selectedPerformers.contains(performer),
              ));
      if (!performerMatch) return false;

      if (_selectedCategory != null) {
        if (_selectedCategory == _uncategorized) {
          if (video.categories.isNotEmpty) {
            return false;
          }
        } else if (!video.categories.any(
          (c) => c.id == _selectedCategory!.id,
        )) {
          return false;
        }
      }

      if (_mediaLibrarySettings.visibilityFilters.value.contains(
            VideoFilter.hideFavorite,
          ) &&
          video.isFavorite) {
        return false;
      }

      if (_mediaLibrarySettings.visibilityFilters.value.contains(
            VideoFilter.hideDisliked,
          ) &&
          video.isDislike) {
        return false;
      }

      if (_mediaLibrarySettings.visibilityFilters.value.contains(
            VideoFilter.hideUnrated,
          ) &&
          !video.isFavorite &&
          !video.isDislike) {
        return false;
      }

      return video.title.toLowerCase().contains(query);
    }).toList();

    _videoPcaScores.clear();
    if (_mediaLibrarySettings.sortOption.value == SortOption.pca) {
      final allVideos = _mediaManager.allVideos;
      final allVideoPaths = allVideos.map((v) => v.videoPath).toSet();

      if (!_videoPathsForPca.containsAll(allVideoPaths) ||
          allVideoPaths.length != _videoPathsForPca.length) {
        _videoPathsForPca = allVideoPaths;
        _pcaScoresByPath.clear();

        if (!mounted) return;
        NotificationFeedManager.showSuccessNotification(
          context,
          'Loading funscripts for PCA sorting...',
        );
        int loadedCount = 0;
        final videosWithFunscript = <Video>[];
        for (var video in allVideos) {
          await video.loadFunscript();
          if (video.funscript != null) {
            videosWithFunscript.add(video);
          }
          loadedCount++;
          if (loadedCount % 100 == 0) {
            if (!mounted) return;
            NotificationFeedManager.showSuccessNotification(
              context,
              'Loaded $loadedCount funscripts...',
            );
          }
        }
        if (!mounted) return;
        NotificationFeedManager.showSuccessNotification(
          context,
          'Finished loading funscripts for PCA sorting. Total: $loadedCount',
        );

        if (videosWithFunscript.length >= 2) {
          final features = videosWithFunscript.map((v) {
            final funscript = v.funscript!;
            final positions =
                funscript.actions.map((a) => a.pos.toDouble()).toList();
            final speeds = <double>[];
            for (var i = 0; i < funscript.actions.length - 1; i++) {
              final a1 = funscript.actions[i];
              final a2 = funscript.actions[i + 1];
              final timeDiff = a2.at - a1.at;
              if (timeDiff > 0) {
                speeds.add(
                  (a2.pos.toDouble() - a1.pos.toDouble()).abs() / timeDiff,
                );
              }
            }

            final accelerations = <double>[];
            for (var i = 0; i < speeds.length - 1; i++) {
              final timeDiff =
                  funscript.actions[i + 1].at - funscript.actions[i].at;
              if (timeDiff > 0) {
                accelerations.add((speeds[i + 1] - speeds[i]) / timeDiff);
              }
            }

            final strokes = _extractStrokes(funscript);
            final strokeLengths = strokes.map((s) => s.length).toList();
            final strokeDurations =
                strokes.map((s) => s.duration.toDouble()).toList();

            if (positions.isEmpty) {
              positions.add(0);
            }

            if (speeds.isEmpty) {
              speeds.add(0);
            }

            if (accelerations.isEmpty) {
              accelerations.add(0);
            }

            if (strokeLengths.isEmpty) {
              strokeLengths.add(0);
            }

            if (strokeDurations.isEmpty) {
              strokeDurations.add(0);
            }

            final positionQuantiles = _calculateQuantiles(positions, 16);
            final speedQuantiles = _calculateQuantiles(speeds, 16);
            final accelerationQuantiles =
                _calculateQuantiles(accelerations, 16);
            final positionSkewness = _calculateSkewness(positions);
            final speedSkewness = _calculateSkewness(speeds);
            final accelerationSkewness = _calculateSkewness(accelerations);
            final positionKurtosis = _calculateKurtosis(positions);
            final speedKurtosis = _calculateKurtosis(speeds);
            final accelerationKurtosis = _calculateKurtosis(accelerations);
            final strokeLengthVariance = _calculateVariance(strokeLengths);
            final strokeDurationVariance = _calculateVariance(strokeDurations);
            final averageStrokeLength = strokeLengths.isEmpty
                ? 0.0
                : strokeLengths.reduce((a, b) => a + b) / strokeLengths.length;
            final averageStrokeDuration = strokeDurations.isEmpty
                ? 0.0
                : strokeDurations.reduce((a, b) => a + b) /
                    strokeDurations.length;

            return [
              positionSkewness,
              speedSkewness,
              accelerationSkewness,
              positionKurtosis,
              speedKurtosis,
              accelerationKurtosis,
              strokeLengthVariance,
              strokeDurationVariance,
              averageStrokeLength,
              averageStrokeDuration,
              ...speedQuantiles,
              ...positionQuantiles,
              ...accelerationQuantiles,
            ];
          }).toList();

          final standardizedFeatures = _standardizeFeatures(features);
          final pca = PCA(components: 2);
          final pcaResult = pca.fitTransform(standardizedFeatures);
          final principalComponents =
              pcaResult['projected'] as List<List<double>>;

          for (var i = 0; i < videosWithFunscript.length; i++) {
            _pcaScoresByPath[videosWithFunscript[i].videoPath] =
                principalComponents[i];
          }
        }
      }

      for (var video in videos) {
        if (_pcaScoresByPath.containsKey(video.videoPath)) {
          _videoPcaScores[video] = _pcaScoresByPath[video.videoPath]!;
        }
      }
    }

    if (_mediaLibrarySettings.sortOption.value == SortOption.random) {
      if (_previousSortOption != SortOption.random) {
        _randomSeed = Random().nextInt(1000000); // Generate new seed
      }
      videos.shuffle(Random(_randomSeed!)); // Shuffle with seed
    } else {
      _randomSeed = null; // Clear seed if not random sort
    }

    videos.sort((a, b) {
      if (_mediaLibrarySettings.separateFavorites.value) {
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
      switch (_mediaLibrarySettings.sortOption.value) {
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

      return _mediaLibrarySettings.isSortAscending.value
          ? compareResult
          : -compareResult;
    });

    setState(() {
      _filteredVideos = videos;
    });
    _previousSortOption =
        _mediaLibrarySettings.sortOption.value; // Update previous sort option
  }

  List<List<double>> _standardizeFeatures(List<List<double>> features) {
    if (features.isEmpty) {
      return [];
    }

    final numFeatures = features[0].length;
    final means = List.filled(numFeatures, 0.0);
    final stdDevs = List.filled(numFeatures, 0.0);

    // Calculate means
    for (var i = 0; i < features.length; i++) {
      for (var j = 0; j < numFeatures; j++) {
        means[j] += features[i][j];
      }
    }
    for (var j = 0; j < numFeatures; j++) {
      means[j] /= features.length;
    }

    // Calculate standard deviations
    for (var i = 0; i < features.length; i++) {
      for (var j = 0; j < numFeatures; j++) {
        stdDevs[j] += pow(features[i][j] - means[j], 2);
      }
    }
    for (var j = 0; j < numFeatures; j++) {
      stdDevs[j] = sqrt(stdDevs[j] / features.length);
    }

    // Standardize features
    final standardizedFeatures =
        List.generate(features.length, (i) => List.filled(numFeatures, 0.0));
    for (var i = 0; i < features.length; i++) {
      for (var j = 0; j < numFeatures; j++) {
        if (stdDevs[j] > 0) {
          standardizedFeatures[i][j] =
              (features[i][j] - means[j]) / stdDevs[j];
        } else {
          standardizedFeatures[i][j] = 0.0;
        }
      }
    }

    return standardizedFeatures;
  }

  List<double> _calculateQuantiles(List<double> data, int numQuantiles) {
    if (data.isEmpty) {
      return List.filled(numQuantiles, 0.0);
    }
    data.sort();
    final quantiles = <double>[];
    for (var i = 1; i <= numQuantiles; i++) {
      final index = (data.length * i / numQuantiles) - 1;
      quantiles.add(data[index.round().clamp(0, data.length - 1)]);
    }
    return quantiles;
  }

  double _calculateVariance(List<double> data) {
    if (data.length < 2) {
      return 0.0;
    }
    final mean = data.reduce((a, b) => a + b) / data.length;
    return data.map((x) => (x - mean) * (x - mean)).reduce((a, b) => a + b) /
        data.length;
  }

  double _calculateSkewness(List<double> data) {
    if (data.length < 3) {
      return 0.0;
    }
    final n = data.length.toDouble();
    final mean = data.reduce((a, b) => a + b) / n;
    final variance =
        data.map((x) => pow(x - mean, 2)).reduce((a, b) => a + b) / n;
    if (variance == 0) {
      return 0.0;
    }
    final stdDev = sqrt(variance);
    final m3 = data.map((x) => pow(x - mean, 3)).reduce((a, b) => a + b) / n;
    return m3 / pow(stdDev, 3);
  }

  double _calculateKurtosis(List<double> data) {
    if (data.length < 4) {
      return 0.0;
    }
    final n = data.length.toDouble();
    final mean = data.reduce((a, b) => a + b) / n;
    final variance =
        data.map((x) => pow(x - mean, 2)).reduce((a, b) => a + b) / n;
    if (variance == 0) {
      return 0.0;
    }
    final stdDev = sqrt(variance);
    final m4 = data.map((x) => pow(x - mean, 4)).reduce((a, b) => a + b) / n;
    return m4 / pow(stdDev, 4);
  }

  // Function to extract strokes
  List<_Stroke> _extractStrokes(Funscript funscript) {
    final strokes = <_Stroke>[];
    if (funscript.actions.length < 2) {
      return strokes;
    }

    int direction = 0; // 0 = unknown, 1 = up, -1 = down
    int strokeStartIndex = 0;

    for (int i = 0; i < funscript.actions.length - 1; i++) {
      final p1 = funscript.actions[i].pos;
      final p2 = funscript.actions[i + 1].pos;

      int currentDirection = (p2 > p1) ? 1 : ((p2 < p1) ? -1 : 0);

      if (direction == 0 && currentDirection != 0) {
        direction = currentDirection;
      }

      if (currentDirection != 0 && currentDirection != direction) {
        // Direction changed, end of a stroke
        final startAction = funscript.actions[strokeStartIndex];
        final endAction = funscript.actions[i];
        strokes.add(_Stroke(
          startPos: startAction.pos.toDouble(),
          endPos: endAction.pos.toDouble(),
          startTime: startAction.at,
          endTime: endAction.at,
        ));
        strokeStartIndex = i;
        direction = currentDirection;
      }
    }

    // Add the last stroke
    final startAction = funscript.actions[strokeStartIndex];
    final endAction = funscript.actions.last;
    strokes.add(_Stroke(
      startPos: startAction.pos.toDouble(),
      endPos: endAction.pos.toDouble(),
      startTime: startAction.at,
      endTime: endAction.at,
    ));

    return strokes;
  }

  Future<void> _refreshVideos() async {
    setState(() {
      _isLoading = true;
      _filteredVideos = []; // Clear videos when loading starts
    });
    await _mediaManager.refreshVideos();
    if (mounted) {
      setState(() => _isLoading = false);
      await _updateDisplayedVideos();
    }
  }

  void _startPlaylist() {
    final playlistVideos = _filteredVideos
        .where((video) => !video.isDislike)
        .toList();
    if (playlistVideos.isEmpty) {
      NotificationFeedManager.showErrorNotification(
        context,
        'No non-disliked videos to create a playlist!',
      );
      return;
    }
    Provider.of<PlayerModel>(
      context,
      listen: false,
    ).setPlaylist(playlistVideos, 0);
    NotificationFeedManager.showSuccessNotification(
      context,
      'Playlist created with ${playlistVideos.length} videos!',
    );
  }

  void _showRandomVideoPicker() {
    var availableVideos = _filteredVideos.where((v) {
      bool shouldHideUnrated =
          _mediaLibrarySettings.visibilityFilters.value.contains(
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
          initialAuthors: _selectedAuthors,
          initialTags: _selectedTags,
          initialPerformers: _selectedPerformers,
          onAuthorsChanged: (selectedAuthors) {
            setState(() {
              _selectedAuthors = selectedAuthors;
            });
            _updateDisplayedVideos();
          },
          onTagsChanged: (selectedTags) {
            setState(() {
              _selectedTags = selectedTags;
            });
            _updateDisplayedVideos();
          },
          onPerformersChanged: (selectedPerformers) {
            setState(() {
              _selectedPerformers = selectedPerformers;
            });
            _updateDisplayedVideos();
          },
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
          mediaManager: _mediaManager,
          uncategorized: _uncategorized,
          showAllCategoriesOption: true,
          showUncategorizedOption: true,
        );
      },
    );

    if (selected != _selectedCategory) {
      setState(() {
        _selectedCategory = selected;
      });
      _updateDisplayedVideos();
    }
  }

  Future<void> _showBulkAddCategoryDialog() async {
    final category = await _showCategorySelectionDialog();
    if (category != null) {
      await _mediaManager.addVideosToCategory(
        _selectedVideos.toList(),
        category,
      );
      setState(() {
        _selectedVideos.clear();
      });
      _updateDisplayedVideos();
    }
  }

  Future<void> _showBulkRemoveCategoryDialog() async {
    final category = await _showCategorySelectionDialog(showAddCategory: false);
    if (category != null) {
      await _mediaManager.removeVideosFromCategory(
        _selectedVideos.toList(),
        category,
      );
      setState(() {
        _selectedVideos.clear();
      });
      _updateDisplayedVideos();
    }
  }

  void _selectAllVideos() {
    setState(() {
      _selectedVideos.clear();
      _selectedVideos.addAll(_filteredVideos);
    });
  }

  Future<void> _deleteVideo(Video video) async {
    await _mediaManager.deleteVideo(video);
    _updateDisplayedVideos();
  }

  Future<UserCategory?> _showCategorySelectionDialog({
    bool showAddCategory = true,
  }) async {
    return await showModalBottomSheet<UserCategory?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return CategorySelectionDialog(
          mediaManager: _mediaManager,
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
    return AppBar(
      title: Text('${_selectedVideos.length} selected'),
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          setState(() {
            _selectedVideos.clear();
          });
        },
      ),
      actions: [
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
      ],
    );
  }

  AppBar _buildDefaultAppBar() {
    return AppBar(
      title: Row(
        children: [
          const Text('Media Library'),
          const SizedBox(width: 8),
          Tooltip(
            message: 'Long-press or right-click an item for more options.',
            child: IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {},
            ),
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
          value: _mediaLibrarySettings.sortOption.value,
          icon: const Icon(Icons.sort),
          underline: const SizedBox.shrink(), // Hides the default underline
          onChanged: (SortOption? newValue) {
            if (newValue != null) {
              _mediaLibrarySettings.setSortOption(newValue);
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
            _mediaLibrarySettings.isSortAscending.value
                ? Icons.arrow_upward
                : Icons.arrow_downward,
          ),
          onPressed: () {
            _mediaLibrarySettings.setIsSortAscending(
              !_mediaLibrarySettings.isSortAscending.value,
            );
          },
          tooltip: _mediaLibrarySettings.isSortAscending.value
              ? 'Sort Descending'
              : 'Sort Ascending',
        ),
        const SizedBox(width: 8),
        PopupMenuButton<dynamic>(
          icon: const Icon(Icons.visibility),
          tooltip: 'View Options',
          onSelected: (dynamic value) {
            if (value is VideoFilter) {
              final currentFilters = _mediaLibrarySettings
                  .visibilityFilters
                  .value
                  .toSet();
              if (currentFilters.contains(value)) {
                currentFilters.remove(value);
              } else {
                currentFilters.add(value);
              }
              _mediaLibrarySettings.setVisibilityFilters(currentFilters);
            } else if (value == 'toggle_titles') {
              _mediaLibrarySettings.setShowVideoTitles(
                !_mediaLibrarySettings.showVideoTitles.value,
              );
            } else if (value == 'show_average_speed') {
              _mediaLibrarySettings.setShowAverageSpeed(
                !_mediaLibrarySettings.showAverageSpeed.value,
              );
            } else if (value == 'show_average_min_max') {
              _mediaLibrarySettings.setShowAverageMinMax(
                !_mediaLibrarySettings.showAverageMinMax.value,
              );
            } else if (value == 'show_duration') {
              _mediaLibrarySettings.setShowDuration(
                !_mediaLibrarySettings.showDuration.value,
              );
            } else if (value == 'separate_favorites') {
              _mediaLibrarySettings.setSeparateFavorites(
                !_mediaLibrarySettings.separateFavorites.value,
              );
            }
          },
          itemBuilder: (BuildContext context) {
            return <PopupMenuEntry<dynamic>>[
              ...VideoFilter.values.map((VideoFilter filter) {
                return CheckedPopupMenuItem<VideoFilter>(
                  value: filter,
                  checked: _mediaLibrarySettings.visibilityFilters.value
                      .contains(filter),
                  child: Text(filter.label),
                );
              }),
              const PopupMenuDivider(),
              CheckedPopupMenuItem<String>(
                value: 'separate_favorites',
                checked: _mediaLibrarySettings.separateFavorites.value,
                child: const Text('Separate Favorites/Dislikes'),
              ),
              const PopupMenuDivider(),
              CheckedPopupMenuItem<String>(
                value: 'toggle_titles',
                checked: _mediaLibrarySettings.showVideoTitles.value,
                child: const Text('Show Titles'),
              ),
              CheckedPopupMenuItem<String>(
                value: 'show_average_speed',
                checked: _mediaLibrarySettings.showAverageSpeed.value,
                child: const Text('Show Average Speed'),
              ),
              CheckedPopupMenuItem<String>(
                value: 'show_average_min_max',
                checked: _mediaLibrarySettings.showAverageMinMax.value,
                child: const Text('Show Average Min/Max'),
              ),
              CheckedPopupMenuItem<String>(
                value: 'show_duration',
                checked: _mediaLibrarySettings.showDuration.value,
                child: const Text('Show Duration'),
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
          label: Text(_selectedCategory?.name ?? 'Category'),
          onPressed: _showCategoryDialog,
        ),
        const SizedBox(width: 8),
        // Videos Per Row Dropdown)
        Tooltip(
          message: 'Videos per row',
          child: DropdownButton<int>(
            value: _mediaLibrarySettings.videosPerRow.value,
            onChanged: (int? newValue) {
              if (newValue != null) {
                _mediaLibrarySettings.setVideosPerRow(newValue);
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
          onPressed: _isLoading ? null : _refreshVideos,
          tooltip: 'Refresh',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isSelectionMode
          ? _buildSelectionAppBar()
          : _buildDefaultAppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FocusScope(
              child: TextField(
                focusNode: _searchFocusNode, // Assign the focus node
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search Videos',
                  hintText: 'What are you looking for?',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ),
          ),
          if (!_isLoading)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Showing ${_filteredVideos.length} of ${_mediaManager.allVideos.length} videos',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          Expanded(
            child: Stack(
              children: [
                if (_isLoading)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        ValueListenableBuilder<int>(
                          valueListenable: _mediaManager.videoCountNotifier,
                          builder: (context, value, child) {
                            return Text('Found $value videos...');
                          },
                        ),
                      ],
                    ),
                  ),
                if (!_isLoading && _filteredVideos.isEmpty)
                  Center(
                    child: Text(
                      _searchController.text.isEmpty
                          ? 'No videos found in configured paths.'
                          : 'No videos found for "${_searchController.text}".',
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
                      key: ValueKey(_filteredVideos.length),
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            _mediaLibrarySettings.videosPerRow.value,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio:
                            16 / 9, // Standard 16:9 video aspect ratio
                      ),
                      itemCount: _filteredVideos.length,
                      itemBuilder: (context, index) {
                        final video = _filteredVideos[index];
                        final isSelected = _selectedVideos.contains(video);
                        return VideoItem(
                          video: video,
                          isSelected: isSelected,
                          showTitle:
                              _mediaLibrarySettings.showVideoTitles.value,
                          showAverageSpeed:
                              _mediaLibrarySettings.showAverageSpeed.value,
                          showAverageMinMax:
                              _mediaLibrarySettings.showAverageMinMax.value,
                          showDuration:
                              _mediaLibrarySettings.showDuration.value,
                          onVideoTapped: (video) {
                            if (_isSelectionMode) {
                              setState(() {
                                if (isSelected) {
                                  _selectedVideos.remove(video);
                                } else {
                                  _selectedVideos.add(video);
                                }
                              });
                            } else {
                              widget.onVideoTapped(video);
                            }
                          },
                          onLongPress: () {
                            setState(() {
                              if (isSelected) {
                                _selectedVideos.remove(video);
                              } else {
                                _selectedVideos.add(video);
                              }
                            });
                          },
                          onFavoriteChanged: (video) {
                            _mediaManager.saveFavorite(video);
                            _updateDisplayedVideos();
                          },
                          onDislikeChanged: (video) {
                            _mediaManager.saveDislike(video);
                            _updateDisplayedVideos();
                          },
                          onCategoryChanged: (video, category, removeCategory) {
                            if (removeCategory) {
                              _mediaManager.removeVideoCategory(
                                video,
                                category,
                              );
                            } else {
                              _mediaManager.setVideoCategory(video, category);
                            }
                            _updateDisplayedVideos();
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
}
