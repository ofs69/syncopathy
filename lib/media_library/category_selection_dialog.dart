import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/notification_feed.dart';
import 'package:syncopathy/persistence/entities/user_category.dart';

class CategorySelectionDialog extends StatefulWidget {
  final UserCategory? initialSelectedCategory;
  final bool showAddCategory;
  final bool showUncategorizedOption;
  final bool showAllCategoriesOption;
  final Set<int>? preFilterCategoriesIds;

  const CategorySelectionDialog({
    super.key,
    this.initialSelectedCategory,
    this.preFilterCategoriesIds,
    this.showAddCategory = true,
    this.showUncategorizedOption = false,
    this.showAllCategoriesOption = false,
  });

  @override
  State<CategorySelectionDialog> createState() =>
      _CategorySelectionDialogState();
}

class _CategorySelectionDialogState extends State<CategorySelectionDialog>
    with SignalsMixin {
  final _searchController = TextEditingController();
  final _newCategoryController = TextEditingController();
  late final ListSignal<UserCategory> _userCategories = createListSignal([]);
  late final Signal<bool> _isLoading = createSignal(true);
  late final Signal<String> _searchText = createSignal("");

  int allCategoriesCategoryId = -1;
  int uncategorizedCategoryId = -2;

  List<UserCategory> get _metaCategories {
    final List<UserCategory> meta = [];
    if (widget.showAllCategoriesOption) {
      meta.add(
        UserCategory(name: 'All Categories', sortOrder: -1)
          ..id = allCategoriesCategoryId,
      );
    }
    if (widget.showUncategorizedOption) {
      meta.add(
        UserCategory(name: 'Uncategorized')..id = uncategorizedCategoryId,
      );
    }
    return meta;
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _searchText.value = _searchController.text;
    });
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    _isLoading.value = true;
    final categories = oBox.userCategoryService.getAllUserCategories();
    _userCategories.value = categories;
    _isLoading.value = false;
  }

  /// Shared by the text field's submit and the add button. Trims the name,
  /// ignores empty/whitespace-only input, and rejects case-insensitive
  /// duplicates so both entry points behave identically.
  Future<void> _addCategory() async {
    final name = _newCategoryController.text.trim();
    if (name.isEmpty) return;

    final duplicate = _userCategories.value.any(
      (c) => c.name.toLowerCase() == name.toLowerCase(),
    );
    if (duplicate) {
      AlertManager.showError('A category named "$name" already exists.');
      return;
    }

    await oBox.userCategoryService.createCategory(name);
    _newCategoryController.clear();
    _searchController.clear();
    await _loadCategories();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _newCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userCategories = _userCategories.watch(context);
    final isLoading = _isLoading.watch(context);
    final searchText = _searchText.watch(context);

    final filteredUserCategories = userCategories
        .where(
          (item) => item.name.toLowerCase().contains(searchText.toLowerCase()),
        )
        .where(
          (item) => widget.preFilterCategoriesIds?.contains(item.id) ?? true,
        )
        .toList();

    final isSearching = searchText.isNotEmpty;
    return DraggableScrollableSheet(
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
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
              child: isLoading
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : isSearching
                  ? _buildSearchResults(filteredUserCategories)
                  : _buildReorderableList(filteredUserCategories),
            ),
            if (widget.showAddCategory)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _newCategoryController,
                        decoration: const InputDecoration(
                          labelText: 'New Category Name',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => _addCategory(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.add),
                      tooltip: 'Add category',
                      onPressed: _addCategory,
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildSearchResults(List<UserCategory> filteredCategories) {
    if (_metaCategories.isEmpty && filteredCategories.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text('No categories match your search.'),
        ),
      );
    }
    return ListView.builder(
      itemCount: _metaCategories.length + filteredCategories.length,
      itemBuilder: (context, index) {
        if (index < _metaCategories.length) {
          final item = _metaCategories[index];
          // Special handling for "All Categories" sentinel and "Uncategorized"
          if (item.id == allCategoriesCategoryId) {
            return ListTile(
              title: const Text('All Categories'),
              onTap: () => Navigator.of(context).pop(null),
            );
          } else if (item.id == uncategorizedCategoryId) {
            return ListTile(
              title: Text(item.name),
              onTap: () => Navigator.of(context).pop(item.id),
            );
          }
          return const SizedBox.shrink();
        } else {
          final item = filteredCategories[index - _metaCategories.length];
          return ListTile(
            key: ValueKey(item.id),
            title: Text(item.name),
            onTap: () => Navigator.of(context).pop(item.id),
          );
        }
      },
    );
  }

  Widget _buildReorderableList(List<UserCategory> categories) {
    return Column(
      children: [
        ..._metaCategories.map((item) {
          if (item.id == -1) {
            return ListTile(
              key: const ValueKey('all_categories'),
              title: const Text('All Categories'),
              onTap: () => Navigator.of(context).pop(null),
            );
          } else {
            return ListTile(
              key: const ValueKey('uncategorized'),
              title: const Text('Uncategorized'),
              onTap: () => Navigator.of(context).pop(item.id),
            );
          }
        }),
        if (categories.isEmpty)
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  widget.showAddCategory
                      ? 'No categories yet.\nAdd one below to get started.'
                      : 'No categories yet.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        else
          Expanded(
            child: ReorderableListView.builder(
              buildDefaultDragHandles: true,
              itemCount: categories.length,
              proxyDecorator: (child, index, animation) {
                return AnimatedBuilder(
                  animation: animation,
                  builder: (BuildContext context, Widget? child) {
                    return Material(
                      elevation: 1.0,
                      color: Colors.transparent,
                      child: IgnorePointer(ignoring: true, child: child),
                    );
                  },
                  child: child,
                );
              },
              itemBuilder: (context, index) {
                final item = categories[index];
                return ListTile(
                  key: ValueKey(item.id),
                  title: Text(item.name),
                  onTap: () => Navigator.of(context).pop(item.id),
                  contentPadding: const EdgeInsets.fromLTRB(
                    16.0,
                    0.0,
                    40.0,
                    0.0,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.showAddCategory)
                        IconButton(
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
                                      onPressed: () =>
                                          Navigator.of(dialogContext).pop(true),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirm == true) {
                              oBox.userCategoryService.deleteCategory(item.id);
                              if (!context.mounted) return;
                              AlertManager.showSuccess(
                                'Category "${item.name}" deleted',
                              );
                              await _loadCategories(); // Refresh the list
                            }
                          },
                        ),
                    ],
                  ),
                );
              },
              onReorderItem: (int oldIndex, int newIndex) async {
                final UserCategory item = _userCategories.removeAt(oldIndex);
                _userCategories.insert(newIndex, item);
                setState(() {}); // without this the UI does ugly things
                for (var i = 0; i < _userCategories.length; i++) {
                  _userCategories[i].sortOrder = i;
                }
                // Single transaction instead of one write per category.
                oBox.userCategoryService.saveAll(_userCategories.value);
              },
            ),
          ),
      ],
    );
  }
}
