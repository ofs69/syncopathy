import 'package:flutter/material.dart';

class FunscriptMetadataFilterBottomSheet extends StatefulWidget {
  final List<String> allAuthors;
  final List<String> allTags;
  final List<String> allPerformers;
  final String? initialAuthor;
  final String? initialTag;
  final String? initialPerformer;

  const FunscriptMetadataFilterBottomSheet({
    super.key,
    required this.allAuthors,
    required this.allTags,
    required this.allPerformers,
    this.initialAuthor,
    this.initialTag,
    this.initialPerformer,
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

  String? _selectedAuthor;
  String? _selectedTag;
  String? _selectedPerformer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _authorSearchController = TextEditingController();
    _tagSearchController = TextEditingController();
    _performerSearchController = TextEditingController();

    _selectedAuthor = widget.initialAuthor;
    _selectedTag = widget.initialTag;
    _selectedPerformer = widget.initialPerformer;
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
    required String? currentSelectedItem,
    required ValueChanged<String?> onItemSelected,
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
                  onTap: () {
                    onItemSelected(null);
                  },
                  selected: currentSelectedItem == null,
                );
              }
              final item = filteredItems[index - 1];
              return ListTile(
                title: Text(item),
                onTap: () {
                  onItemSelected(item);
                },
                selected: item == currentSelectedItem,
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
                    currentSelectedItem: _selectedAuthor,
                    onItemSelected: (value) {
                      setState(() {
                        _selectedAuthor = value;
                      });
                    },
                  ),
                  _buildSearchableList(
                    title: 'Tag',
                    items: widget.allTags,
                    searchController: _tagSearchController,
                    currentSelectedItem: _selectedTag,
                    onItemSelected: (value) {
                      setState(() {
                        _selectedTag = value;
                      });
                    },
                  ),
                  _buildSearchableList(
                    title: 'Performer',
                    items: widget.allPerformers,
                    searchController: _performerSearchController,
                    currentSelectedItem: _selectedPerformer,
                    onItemSelected: (value) {
                      setState(() {
                        _selectedPerformer = value;
                      });
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
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(
                            context,
                          ).pop(null); // Dismiss without applying
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop({
                            'author': _selectedAuthor,
                            'tag': _selectedTag,
                            'performer': _selectedPerformer,
                          });
                        },
                        child: const Text('Apply'),
                      ),
                    ],
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
