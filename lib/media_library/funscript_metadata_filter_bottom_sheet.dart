import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class FunscriptMetadataFilterBottomSheet extends SignalStatefulWidget {
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

  final _authorSearchText = signal("");
  final _tagSearchText = signal("");
  final _performerSearchText = signal("");

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _authorSearchController = TextEditingController();
    _tagSearchController = TextEditingController();
    _performerSearchController = TextEditingController();

    _authorSearchController.addListener(() {
      _authorSearchText.value = _authorSearchController.text;
    });
    _tagSearchController.addListener(() {
      _tagSearchText.value = _tagSearchController.text;
    });
    _performerSearchController.addListener(() {
      _performerSearchText.value = _performerSearchController.text;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _authorSearchController.dispose();
    _tagSearchController.dispose();
    _performerSearchController.dispose();
    _authorSearchText.dispose();
    _tagSearchText.dispose();
    _performerSearchText.dispose();
    super.dispose();
  }

  /// Toggles [value] in [selection] by writing a *new* set.
  ///
  /// The mutating helpers on a collection signal — `Signal<Set<T>>` here, but
  /// `ListSignal`/`SetSignal`/`MapSignal` behave the same — edit the collection
  /// in place and re-emit the same instance. A batch reconciles every write
  /// against a snapshot taken when it opened, and an in-place edit still
  /// compares equal to that snapshot, so the signal's version is rolled back
  /// and the queued listeners never run: the selection changes but nothing
  /// repaints or re-filters. Writing a fresh set keeps the change visible.
  void _toggle(Signal<Set<String>> selection, String value) {
    final next = {...selection.value};
    if (!next.add(value)) next.remove(value);
    selection.value = next;
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
                  subtitle: const Text('No filter — matches everything'),
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

  Widget _buildTab(String label, int selectedCount) {
    return Tab(
      child: Badge(
        isLabelVisible: selectedCount > 0,
        label: Text('$selectedCount'),
        offset: const Offset(16, -6),
        child: Text(label),
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Metadata filters'),
        content: const Text(
          'These filters apply to author, tag, and performer metadata embedded '
          'within funscripts. Selecting none in a tab matches everything. A '
          'script has to satisfy every tab you do select in — to match on any '
          'one of them instead, add a metadata filter per field and join them '
          'in an OR group.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Read to subscribe. The search text is consumed further down inside the
    // DraggableScrollableSheet builder, which runs outside this element's build
    // and so cannot establish the subscription itself.
    _authorSearchText.value;
    _tagSearchText.value;
    _performerSearchText.value;

    final authorCount = widget.selectedAuthors.value.length;
    final tagCount = widget.selectedTags.value.length;
    final performerCount = widget.selectedPerformers.value.length;

    return DraggableScrollableSheet(
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: [
                _buildTab('Author', authorCount),
                _buildTab('Tag', tagCount),
                _buildTab('Performer', performerCount),
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
                    currentSelectedItems: widget.selectedAuthors.value,
                    onItemToggled: (value) =>
                        _toggle(widget.selectedAuthors, value),
                    onAllSelected: () {
                      widget.selectedAuthors.clear();
                    },
                  ),
                  _buildSearchableList(
                    title: 'Tag',
                    items: widget.allTags,
                    searchController: _tagSearchController,
                    currentSelectedItems: widget.selectedTags.value,
                    onItemToggled: (value) =>
                        _toggle(widget.selectedTags, value),
                    onAllSelected: () {
                      widget.selectedTags.clear();
                    },
                  ),
                  _buildSearchableList(
                    title: 'Performer',
                    items: widget.allPerformers,
                    searchController: _performerSearchController,
                    currentSelectedItems: widget.selectedPerformers.value,
                    onItemToggled: (value) =>
                        _toggle(widget.selectedPerformers, value),
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
                  TextButton.icon(
                    icon: const Icon(Icons.restart_alt),
                    label: const Text("Reset"),
                    onPressed: () {
                      widget.selectedAuthors.clear();
                      widget.selectedPerformers.clear();
                      widget.selectedTags.clear();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.info_outline),
                    tooltip: 'About these filters',
                    onPressed: _showInfoDialog,
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
