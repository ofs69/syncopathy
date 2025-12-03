import 'package:flutter/material.dart';
import 'package:syncopathy/media_manager.dart';
import 'package:syncopathy/sqlite/database_helper.dart';
import 'package:syncopathy/sqlite/models/user_category.dart';
import 'package:syncopathy/notification_feed.dart';

class CategorySelectionDialog extends StatefulWidget {
  final UserCategory? initialSelectedCategory;
  final bool showAddCategory;
  final MediaManager mediaManager;
  final UserCategory uncategorized;
  final bool showUncategorizedOption;
  final bool showAllCategoriesOption;

  const CategorySelectionDialog({
    super.key,
    this.initialSelectedCategory,
    this.showAddCategory = true,
    required this.mediaManager,
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

  @override
  void dispose() {
    _searchController.dispose();
    _newCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            // TODO: perhaps use a query for this
            final filteredCategoriesFuture = DatabaseHelper()
                .getAllUserCategories()
                .then((value) {
                  return value
                      .where(
                        (item) => item.name.toLowerCase().contains(
                          _searchController.text.toLowerCase(),
                        ),
                      )
                      .toList();
                });

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
                  child: FutureBuilder(
                    future: filteredCategoriesFuture,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator.adaptive();
                      }

                      final filteredCategories = snapshot.data!;

                      return ListView.builder(
                        controller: scrollController,
                        itemCount:
                            filteredCategories.length +
                            (widget.showAllCategoriesOption ? 1 : 0) +
                            (widget.showUncategorizedOption ? 1 : 0),
                        itemBuilder: (context, index) {
                          int actualIndex = index;

                          if (widget.showAllCategoriesOption) {
                            if (index == 0) {
                              return ListTile(
                                title: const Text('All Categories'),
                                onTap: () => Navigator.of(context).pop(null),
                              );
                            }
                            actualIndex--;
                          }

                          if (widget.showUncategorizedOption) {
                            if (actualIndex == 0) {
                              return ListTile(
                                title: const Text('Uncategorized'),
                                onTap: () => Navigator.of(
                                  context,
                                ).pop(widget.uncategorized),
                              );
                            }
                            actualIndex--;
                          }

                          final item = filteredCategories[actualIndex];
                          return ListTile(
                            title: Text(item.name),
                            onTap: () => Navigator.of(context).pop(item),
                            trailing:
                                widget
                                    .showAddCategory // Only show delete if adding is allowed
                                ? IconButton(
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
                                        await widget.mediaManager
                                            .deleteCategory(item);
                                        if (!context.mounted) return;
                                        NotificationFeedManager.showSuccessNotification(
                                          context,
                                          'Category "${item.name}" deleted',
                                        );
                                        setState(() {}); // Refresh the list
                                      }
                                    },
                                  )
                                : null,
                          );
                        },
                      );
                    },
                  ),
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
                                await widget.mediaManager.createCategory(value);
                                _newCategoryController.clear();
                                _searchController.clear();
                                setState(() {});
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () async {
                            if (_newCategoryController.text.isNotEmpty) {
                              await widget.mediaManager.createCategory(
                                _newCategoryController.text,
                              );
                              _newCategoryController.clear();
                              _searchController.clear();
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
  }
}
