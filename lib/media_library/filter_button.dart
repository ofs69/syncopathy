import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/media_library/category_selection_dialog.dart';
import 'package:syncopathy/media_library/filter.dart';
import 'package:syncopathy/media_library/funscript_metadata_filter_bottom_sheet.dart';

class FilterButton extends StatefulWidget {
  final Signal<MediaFilter> filter;
  const FilterButton({super.key, required this.filter});

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  void _openAdvancedFilters() async {
    await showDialog(
      context: context,
      builder: (context) => _FilterDialog(filter: widget.filter),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCustomized = widget.filter.watch(context).isCustomized;
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.tune),
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
          ),
          color: Theme.of(context).colorScheme.primary,
          onPressed: _openAdvancedFilters,
        ),
        if (isCustomized)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}

class _FilterDialog extends StatefulWidget {
  final Signal<MediaFilter> filter;
  const _FilterDialog({required this.filter});

  @override
  State<_FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<_FilterDialog> with SignalsMixin {
  late final Signal<Set<String>> selectedAuthors = createSignal({});
  late final Signal<Set<String>> selectedTags = createSignal({});
  late final Signal<Set<String>> selectedPerformers = createSignal({});

  @override
  Widget build(BuildContext context) {
    final filter = widget.filter.watch(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 500,
        ), // Standard dialog width
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Dialog shrinks to content
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Filters",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => widget.filter.value = MediaFilter(),
                        child: const Text("Reset All"),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(),
              // Flexible allows the content to scroll if the list is long
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildFilterTile(
                        title: "Categories",
                        onTap: _showCategoryBottomSheet,
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            _buildTagGroup(
                              "Categories:",
                              filter.filterCategory != null
                                  ? {filter.filterCategory.toString()}
                                  : {},
                            ),
                          ],
                        ),
                      ),
                      //const Divider(),
                      _buildFilterTile(
                        title: "Funscript Metadata",
                        onTap: _showFunscriptMetadataFilterBottomSheet,
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            _buildTagGroup(
                              "Authors:",
                              filter.funscriptAuthors ?? {},
                            ),
                            const SizedBox(height: 8),
                            _buildTagGroup("Tags:", filter.funscriptTags ?? {}),
                            const SizedBox(height: 8),
                            _buildTagGroup(
                              "Performers:",
                              filter.funscriptPerformers ?? {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTagGroup(String label, Set<String> tags) {
    if (tags.isEmpty) return const SizedBox.shrink();

    final tagWidgets = tags
        .map(
          (tag) => Chip(
            label: Text(tag, style: const TextStyle(fontSize: 12)),
            visualDensity:
                VisualDensity.compact, // Makes chips smaller for the tile
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        )
        .toList();
    return Wrap(
      spacing: 2.0,
      runSpacing: 2.0,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        ...tagWidgets,
      ],
    );
  }

  // Helper to keep the build method clean
  Widget _buildFilterTile({
    required String title,
    required VoidCallback onTap,
    required Widget subtitle,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: const Icon(Icons.chevron_right), // Standard UI for "more"
      onTap: onTap,
      subtitle: subtitle,
    );
  }

  // Sub-menus remain Bottom Sheets
  Future<void> _showFunscriptMetadataFilterBottomSheet() async {
    final authors = oBox.funscriptService.getAllAuthors();
    final tags = oBox.funscriptService.getAllTags();
    final performers = oBox.funscriptService.getAllPerformers();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true, // Ensures it appears over the dialog
      builder: (BuildContext context) {
        return FunscriptMetadataFilterBottomSheet(
          allAuthors: authors,
          allTags: tags,
          allPerformers: performers,
          selectedAuthors: selectedAuthors,
          selectedTags: selectedTags,
          selectedPerformers: selectedPerformers,
        );
      },
    );

    widget.filter.value = widget.filter.value.copyWith(
      funscriptAuthors: selectedAuthors.value,
      funscriptPerformers: selectedPerformers.value,
      funscriptTags: selectedTags.value,
    );
  }

  Future<void> _showCategoryBottomSheet() async {
    final selected = await showModalBottomSheet<int?>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true, // Ensures it appears over the dialog
      builder: (BuildContext context) {
        return CategorySelectionDialog(
          showAllCategoriesOption: true,
          showUncategorizedOption: true,
        );
      },
    );
    widget.filter.value = widget.filter.value.copyWith(
      filterCategory: selected,
    );
  }
}
