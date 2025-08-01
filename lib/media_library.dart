import 'dart:math';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:syncopathy/main.dart';
import 'package:syncopathy/media_manager.dart';
import 'package:syncopathy/model/user_category.dart';
import 'package:syncopathy/video_item.dart';
import 'package:syncopathy/model/video_model.dart';
import 'package:syncopathy/wheel_of_fortune.dart';

enum SortOption {
  none('Default'),
  titleAsc('Title A-Z'),
  titleDesc('Title Z-A'),
  speedAsc('Speed (Slowest)'),
  speedDesc('Speed (Fastest)'),
  depthAsc('Depth (Shallowest)'),
  depthDesc('Depth (Deepest)'),
  lastModifiedDesc('Recently Changed');

  const SortOption(this.label);
  final String label;
}

class MediaLibrary extends StatefulWidget {
  final List<String> mediaPaths;
  final void Function(Video) onVideoTapped;

  const MediaLibrary({
    super.key,
    required this.onVideoTapped,
    required this.mediaPaths,
  });

  @override
  State<MediaLibrary> createState() => _MediaLibraryState();
}

final _uncategorized = UserCategory(name: 'Uncategorized');

class _MediaLibraryState extends State<MediaLibrary> {
  late final MediaManager _mediaManager;
  late List<Video> _filteredVideos;
  final _searchController = TextEditingController();
  SortOption _currentSortOrder = SortOption.none;
  String? _selectedAuthor;
  String? _selectedTag;
  String? _selectedPerformer;
  UserCategory? _selectedCategory;
  bool _isLoading = false;
  int videosPerRow = 6;

  @override
  void initState() {
    super.initState();
    _mediaManager = MediaManager(widget.mediaPaths);
    _refreshVideos();

    _filteredVideos = _mediaManager.allVideos;
    _searchController.addListener(_updateDisplayedVideos);
  }

  @override
  void dispose() {
    _searchController.removeListener(_updateDisplayedVideos);
    _searchController.dispose();
    _mediaManager.dispose();
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

  void _updateDisplayedVideos() {
    if (!mounted) return;

    final query = _searchController.text.toLowerCase();
    List<Video> videos = _mediaManager.allVideos.where((video) {
      final authorMatch =
          _selectedAuthor == null ||
          video.funscriptMetadata?.creator == _selectedAuthor;
      if (!authorMatch) return false;

      final tagMatch =
          _selectedTag == null ||
          video.funscriptMetadata?.tags.contains(_selectedTag) == true;
      if (!tagMatch) return false;

      final performerMatch =
          _selectedPerformer == null ||
          video.funscriptMetadata?.performers.contains(_selectedPerformer) ==
              true;
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

      return video.title.toLowerCase().contains(query);
    }).toList();

    videos.sort((a, b) {
      // Favorites always come first, and disliked videos are never favorites.
      if (a.isFavorite != b.isFavorite) {
        return a.isFavorite ? -1 : 1;
      }

      // Then, sort by dislike status. Disliked videos go to the bottom.
      if (a.isDislike != b.isDislike) {
        return a.isDislike ? 1 : -1;
      }

      // Within each group (favorites, normal, disliked), sort by the selected option.
      switch (_currentSortOrder) {
        case SortOption.titleAsc:
          return a.title.compareTo(b.title);
        case SortOption.titleDesc:
          return b.title.compareTo(a.title);
        case SortOption.speedAsc:
          return a.averageSpeed.compareTo(b.averageSpeed);
        case SortOption.speedDesc:
          return b.averageSpeed.compareTo(a.averageSpeed);
        case SortOption.depthAsc:
          final depthA = a.averageMax - a.averageMin;
          final depthB = b.averageMax - b.averageMin;
          return depthA.compareTo(depthB);
        case SortOption.depthDesc:
          final depthA = a.averageMax - a.averageMin;
          final depthB = b.averageMax - b.averageMin;
          return depthB.compareTo(depthA);
        case SortOption.lastModifiedDesc:
          return b.dateFirstFound.compareTo(a.dateFirstFound);
        case SortOption.none:
          return 0; // Keep original order within each group
      }
    });

    setState(() {
      _filteredVideos = videos;
    });
  }

  Future<void> _refreshVideos() async {
    setState(() => _isLoading = true);
    await _mediaManager.refreshVideos();
    if (mounted) {
      _updateDisplayedVideos();
      setState(() => _isLoading = false);
    }
  }

  void _showRandomVideoPicker() {
    var availableVideos = _filteredVideos.where((v) => !v.isDislike).toList();

    if (availableVideos.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No videos available to choose from!')),
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

  Future<void> _showFilterDialog({
    required String title,
    required List<String> items,
    required String? selectedItem,
    required Function(String?) onItemSelected,
  }) async {
    final selected = await showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        final searchController = TextEditingController();
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            final filteredItems = items
                .where(
                  (item) => item.toLowerCase().contains(
                    searchController.text.toLowerCase(),
                  ),
                )
                .toList();

            return DraggableScrollableSheet(
              expand: false,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextField(
                            controller: searchController,
                            onChanged: (value) => setState(() {}),
                            decoration: InputDecoration(
                              labelText: 'Search $title',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: filteredItems.length + 1,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return ListTile(
                                  title: Text('All ${title}s'),
                                  onTap: () => Navigator.of(context).pop(null),
                                );
                              }
                              final item = filteredItems[index - 1];
                              return ListTile(
                                title: Text(item),
                                onTap: () => Navigator.of(context).pop(item),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
            );
          },
        );
      },
    );

    if (selected != selectedItem) {
      onItemSelected(selected);
    }
  }

  Future<void> _showCategoryDialog() async {
    final selected = await showModalBottomSheet<UserCategory?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        final searchController = TextEditingController();
        final newCategoryController = TextEditingController();

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return DraggableScrollableSheet(
              expand: false,
              builder: (BuildContext context, ScrollController scrollController) {
                final filteredItems = isar.userCategorys
                    .where()
                    .findAllSync()
                    .where(
                      (item) => item.name.toLowerCase().contains(
                        searchController.text.toLowerCase(),
                      ),
                    )
                    .toList();

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) => setState(() {}),
                        decoration: InputDecoration(
                          labelText: 'Search Categories',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: filteredItems.length + 2,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return ListTile(
                              title: const Text('All Categories'),
                              onTap: () => Navigator.of(context).pop(null),
                            );
                          }
                          if (index == 1) {
                            return ListTile(
                              title: const Text('Uncategorized'),
                              onTap: () =>
                                  Navigator.of(context).pop(_uncategorized),
                            );
                          }
                          final item = filteredItems[index - 2];
                          return ListTile(
                            title: Text(item.name),
                            onTap: () => Navigator.of(context).pop(item),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              tooltip: "Delete Category",
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return AlertDialog(
                                      title: const Text('Confirm Delete'),
                                      content: Text(
                                        'Are you sure you want to delete the category "${item.name}"? Videos in this category will become uncategorized.',
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () => Navigator.of(
                                            dialogContext,
                                          ).pop(false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.of(
                                            dialogContext,
                                          ).pop(true),
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (confirm == true) {
                                  await _mediaManager.deleteCategory(item);
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Category "${item.name}" deleted',
                                      ),
                                    ),
                                  );
                                  setState(() {});
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: newCategoryController,
                              decoration: const InputDecoration(
                                labelText: 'New Category Name',
                                border: OutlineInputBorder(),
                              ),
                              onSubmitted: (value) async {
                                if (value.isNotEmpty) {
                                  await _mediaManager.createCategory(value);
                                  newCategoryController.clear();
                                  searchController.clear();
                                  setState(() {});
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () async {
                              if (newCategoryController.text.isNotEmpty) {
                                await _mediaManager.createCategory(
                                  newCategoryController.text,
                                );
                                newCategoryController.clear();
                                searchController.clear();
                                setState(() {});
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Media Library'),
        actions: [
          TextButton.icon(
            label: const Text("Surprise Me!"),
            icon: const Icon(Icons.shuffle),
            onPressed: _showRandomVideoPicker,
          ),
          const SizedBox(width: 16),
          // Sorting Dropdown
          DropdownButton<SortOption>(
            value: _currentSortOrder,
            icon: const Icon(Icons.sort),
            underline: const SizedBox.shrink(), // Hides the default underline
            onChanged: (SortOption? newValue) {
              if (newValue != null) {
                setState(() {
                  _currentSortOrder = newValue;
                });
                _updateDisplayedVideos();
              }
            },
            items: SortOption.values.map((SortOption option) {
              return DropdownMenuItem<SortOption>(
                value: option,
                child: Text(option.label),
              );
            }).toList(),
          ),
          const SizedBox(width: 16),
          // Filter Buttons
          ActionChip(
            avatar: const Icon(Icons.person_outline),
            label: Text(_selectedAuthor ?? 'Author'),
            onPressed: () => _showFilterDialog(
              title: 'Authors',
              items: _allAuthors,
              selectedItem: _selectedAuthor,
              onItemSelected: (selected) {
                setState(() => _selectedAuthor = selected);
                _updateDisplayedVideos();
              },
            ),
          ),
          const SizedBox(width: 16),
          ActionChip(
            avatar: const Icon(Icons.tag),
            label: Text(_selectedTag ?? 'Tag'),
            onPressed: () => _showFilterDialog(
              title: 'Tags',
              items: _allTags,
              selectedItem: _selectedTag,
              onItemSelected: (selected) {
                setState(() => _selectedTag = selected);
                _updateDisplayedVideos();
              },
            ),
          ),
          const SizedBox(width: 16),
          ActionChip(
            avatar: const Icon(Icons.person_search),
            label: Text(_selectedPerformer ?? 'Performer'),
            onPressed: () => _showFilterDialog(
              title: 'Performers',
              items: _allPerformers,
              selectedItem: _selectedPerformer,
              onItemSelected: (selected) {
                setState(() => _selectedPerformer = selected);
                _updateDisplayedVideos();
              },
            ),
          ),
          const SizedBox(width: 16),
          ActionChip(
            avatar: const Icon(Icons.category_outlined),
            label: Text(_selectedCategory?.name ?? 'Category'),
            onPressed: _showCategoryDialog,
          ),
          const SizedBox(width: 16),

          // Videos Per Row Dropdown)
          Tooltip(
            message: 'Videos per row',
            child: DropdownButton<int>(
              value: videosPerRow,
              onChanged: (int? newValue) {
                if (newValue != null) {
                  setState(() {
                    videosPerRow = newValue;
                  });
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
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
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
                    child: widget.mediaPaths.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.folder_off_outlined, size: 48),
                              SizedBox(height: 16),
                              Text(
                                'No media paths configured.',
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Please add media library paths in the Settings page. And refresh.',
                              ),
                            ],
                          )
                        : Text(
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
                        crossAxisCount: videosPerRow,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio:
                            16 / 9, // Standard 16:9 video aspect ratio
                      ),
                      itemCount: _filteredVideos.length,
                      itemBuilder: (context, index) {
                        final video = _filteredVideos[index];
                        return VideoItem(
                          video: video,
                          onVideoTapped: widget.onVideoTapped,
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
