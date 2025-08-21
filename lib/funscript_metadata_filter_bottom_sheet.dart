import 'package:flutter/material.dart';

class FunscriptMetadataFilterBottomSheet extends StatefulWidget {
  final List<String> allAuthors;
  final List<String> allTags;
  final List<String> allPerformers;
  final Set<String> initialAuthors;
  final Set<String> initialTags;
  final Set<String> initialPerformers;
  final ValueChanged<Set<String>>? onAuthorsChanged;
  final ValueChanged<Set<String>>? onTagsChanged;
  final ValueChanged<Set<String>>? onPerformersChanged;

  const FunscriptMetadataFilterBottomSheet({
    super.key,
    required this.allAuthors,
    required this.allTags,
    required this.allPerformers,
    this.initialAuthors = const {},
    this.initialTags = const {},
    this.initialPerformers = const {},
    this.onAuthorsChanged,
    this.onTagsChanged,
    this.onPerformersChanged,
  });

  @override
  State<FunscriptMetadataFilterBottomSheet> createState() =>
      _FunscriptMetadataFilterBottomSheetState();
}

class _FunscriptMetadataFilterBottomSheetState
    extends State<FunscriptMetadataFilterBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _authorSearchController;
  late TextEditingController _tagSearchController;
  late TextEditingController _performerSearchController;

  Set<String> _selectedAuthors = {};
  Set<String> _selectedTags = {};
  Set<String> _selectedPerformers = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _authorSearchController = TextEditingController();
    _tagSearchController = TextEditingController();
    _performerSearchController = TextEditingController();

    _selectedAuthors = Set.from(widget.initialAuthors);
    _selectedTags = Set.from(widget.initialTags);
    _selectedPerformers = Set.from(widget.initialPerformers);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _authorSearchController.dispose();
    _tagSearchController.dispose();
    _performerSearchController.dispose();
    super.dispose();
  }

  Widget _buildSearchableList({
    required String title,
    required List<String> items,
    required TextEditingController searchController,
    required Set<String> currentSelectedItems,
    required ValueChanged<String> onItemToggled,
    required VoidCallback onAllSelected,
  }) {
    final filteredItems = items
        .where(
          (item) =>
              item.toLowerCase().contains(searchController.text.toLowerCase()),
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
            itemCount: filteredItems.length + 1, // +1 for "All" option
            itemBuilder: (context, index) {
              if (index == 0) {
                return ListTile(
                  title: const Text('All'),
                  trailing: currentSelectedItems.isEmpty
                      ? const Icon(Icons.check)
                      : null,
                  onTap: () {
                    onAllSelected();
                  },
                );
              }
              final item = filteredItems[index - 1];
              return ListTile(
                title: Text(item),
                trailing: currentSelectedItems.contains(item)
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  onItemToggled(item);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Author'),
                Tab(text: 'Tag'),
                Tab(text: 'Performer'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildSearchableList(
                    title: 'Author',
                    items: widget.allAuthors,
                    searchController: _authorSearchController,
                    currentSelectedItems: _selectedAuthors,
                    onItemToggled: (value) {
                      setState(() {
                        if (_selectedAuthors.contains(value)) {
                          _selectedAuthors.remove(value);
                        } else {
                          _selectedAuthors.add(value);
                        }
                      });
                      widget.onAuthorsChanged?.call(_selectedAuthors);
                    },
                    onAllSelected: () {
                      setState(() {
                        _selectedAuthors.clear();
                      });
                      widget.onAuthorsChanged?.call(_selectedAuthors);
                    },
                  ),
                  _buildSearchableList(
                    title: 'Tag',
                    items: widget.allTags,
                    searchController: _tagSearchController,
                    currentSelectedItems: _selectedTags,
                    onItemToggled: (value) {
                      setState(() {
                        if (_selectedTags.contains(value)) {
                          _selectedTags.remove(value);
                        } else {
                          _selectedTags.add(value);
                        }
                      });
                      widget.onTagsChanged?.call(_selectedTags);
                    },
                    onAllSelected: () {
                      setState(() {
                        _selectedTags.clear();
                      });
                      widget.onTagsChanged?.call(_selectedTags);
                    },
                  ),
                  _buildSearchableList(
                    title: 'Performer',
                    items: widget.allPerformers,
                    searchController: _performerSearchController,
                    currentSelectedItems: _selectedPerformers,
                    onItemToggled: (value) {
                      setState(() {
                        if (_selectedPerformers.contains(value)) {
                          _selectedPerformers.remove(value);
                        } else {
                          _selectedPerformers.add(value);
                        }
                      });
                      widget.onPerformersChanged?.call(_selectedPerformers);
                    },
                    onAllSelected: () {
                      setState(() {
                        _selectedPerformers.clear();
                      });
                      widget.onPerformersChanged?.call(_selectedPerformers);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Tooltip(
                    message:
                        'These filters apply to metadata embedded within funscripts.',
                    child: IconButton(
                      icon: const Icon(Icons.info_outline),
                      onPressed: () {}, // No action needed for info icon
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
