import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncopathy/media_manager.dart';
import 'package:syncopathy/sqlite/database_helper.dart';
import 'package:syncopathy/sqlite/models/user_category.dart';
import 'package:syncopathy/notification_feed.dart';

class CategorySelectionDialog extends StatefulWidget {
  final UserCategory? initialSelectedCategory;
  final bool showAddCategory;
  final UserCategory uncategorized;
  final bool showUncategorizedOption;
  final bool showAllCategoriesOption;

  const CategorySelectionDialog({
    super.key,
    this.initialSelectedCategory,
    this.showAddCategory = true,
    required this.uncategorized,
    this.showUncategorizedOption = false,
    this.showAllCategoriesOption = false,
  });

  @override
  State<CategorySelectionDialog> createState() =>
      _CategorySelectionDialogState();
}

class _CategorySelectionDialogState extends State<CategorySelectionDialog> {
  final _searchController = TextEditingController();
  final _newCategoryController = TextEditingController();
  List<UserCategory> _userCategories = [];
  bool _isLoading = true;

  List<UserCategory> get _metaCategories {
    final List<UserCategory> meta = [];
    if (widget.showAllCategoriesOption) {
      meta.add(
        UserCategory(id: -1, name: 'All Categories', sortOrder: -1),
      ); // Sentinel for "All Categories"
    }
    if (widget.showUncategorizedOption) {
      meta.add(widget.uncategorized);
    }
    return meta;
  }

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
    });
    final categories = await DatabaseHelper().getAllUserCategories();
    setState(() {
      _userCategories = categories;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _newCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaManager = context.read<MediaManager>();
    final filteredUserCategories = _userCategories
        .where(
          (item) => item.name.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          ),
        )
        .toList();

    final bool isSearching = _searchController.text.isNotEmpty;

    return DraggableScrollableSheet(
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
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
              child: _isLoading
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
                        onSubmitted: (value) async {
                          if (value.isNotEmpty) {
                            await mediaManager.createCategory(value);
                            _newCategoryController.clear();
                            _searchController.clear();
                            await _loadCategories();
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () async {
                        if (_newCategoryController.text.isNotEmpty) {
                          await mediaManager.createCategory(
                            _newCategoryController.text,
                          );
                          _newCategoryController.clear();
                          _searchController.clear();
                          await _loadCategories();
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
  }

  Widget _buildSearchResults(List<UserCategory> filteredCategories) {
    return ListView.builder(
      itemCount: _metaCategories.length + filteredCategories.length,
      itemBuilder: (context, index) {
        if (index < _metaCategories.length) {
          final item = _metaCategories[index];
          // Special handling for "All Categories" sentinel and "Uncategorized"
          if (item.id == -1) {
            return ListTile(
              title: const Text('All Categories'),
              onTap: () => Navigator.of(context).pop(null),
            );
          } else {
            return ListTile(
              title: Text(item.name),
              onTap: () => Navigator.of(context).pop(widget.uncategorized),
            );
          }
        } else {
          final item = filteredCategories[index - _metaCategories.length];
          return ListTile(
            key: ValueKey(item.id),
            title: Text(item.name),
            onTap: () => Navigator.of(context).pop(item),
          );
        }
      },
    );
  }

  Widget _buildReorderableList(List<UserCategory> categories) {
    final mediaManager = context.read<MediaManager>();
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
              onTap: () => Navigator.of(context).pop(widget.uncategorized),
            );
          }
        }),
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
                    color: Colors.transparent, // Keeps the background clean
                    child: IgnorePointer(
                      ignoring: true, // Stops the tooltip/hover crash
                      child: child,
                    ),
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
                onTap: () => Navigator.of(context).pop(item),
                contentPadding: EdgeInsets.fromLTRB(16.0, 0.0, 40.0, 0.0),
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
                                    onPressed: () =>
                                        Navigator.of(dialogContext).pop(false),
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
                            await mediaManager.deleteCategory(item);
                            if (!context.mounted) return;
                            NotificationFeedManager.showSuccessNotification(
                              context,
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
            onReorder: (int oldIndex, int newIndex) async {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final UserCategory item = _userCategories.removeAt(oldIndex);
              _userCategories.insert(newIndex, item);
              setState(() {});
              await DatabaseHelper().updateUserCategorySortOrder(
                _userCategories,
              );
            },
          ),
        ),
      ],
    );
  }
}
