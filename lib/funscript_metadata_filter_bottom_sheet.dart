import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class FunscriptMetadataFilterBottomSheet extends StatefulWidget {
  final List<String> allAuthors;
  final List<String> allTags;
  final List<String> allPerformers;
  final Signal<Set<String>> selectedAuthors;
  final Signal<Set<String>> selectedTags;
  final Signal<Set<String>> selectedPerformers;

  const FunscriptMetadataFilterBottomSheet({
    super.key,
    required this.allAuthors,
    required this.allTags,
    required this.allPerformers,
    required this.selectedAuthors,
    required this.selectedPerformers,
    required this.selectedTags,
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _authorSearchController = TextEditingController();
    _tagSearchController = TextEditingController();
    _performerSearchController = TextEditingController();
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
                    currentSelectedItems: widget.selectedAuthors.watch(context),
                    onItemToggled: (value) {
                      batch(() {
                        if (widget.selectedAuthors.contains(value)) {
                          widget.selectedAuthors.remove(value);
                        } else {
                          widget.selectedAuthors.add(value);
                        }
                      });
                    },
                    onAllSelected: () {
                      widget.selectedAuthors.clear();
                    },
                  ),
                  _buildSearchableList(
                    title: 'Tag',
                    items: widget.allTags,
                    searchController: _tagSearchController,
                    currentSelectedItems: widget.selectedTags.watch(context),
                    onItemToggled: (value) {
                      batch(() {
                        if (widget.selectedTags.contains(value)) {
                          widget.selectedTags.remove(value);
                        } else {
                          widget.selectedTags.add(value);
                        }
                      });
                    },
                    onAllSelected: () {
                      widget.selectedTags.clear();
                    },
                  ),
                  _buildSearchableList(
                    title: 'Performer',
                    items: widget.allPerformers,
                    searchController: _performerSearchController,
                    currentSelectedItems: widget.selectedPerformers.watch(
                      context,
                    ),
                    onItemToggled: (value) {
                      batch(() {
                        if (widget.selectedPerformers.contains(value)) {
                          widget.selectedPerformers.remove(value);
                        } else {
                          widget.selectedPerformers.add(value);
                        }
                      });
                    },
                    onAllSelected: () {
                      widget.selectedPerformers.clear();
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
