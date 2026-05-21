import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/media_library/filter/media_filter.dart';
import 'package:syncopathy/settings_overlay.dart';

class MediaFilterOverlay extends StatefulWidget {
  final MediaFilter filter;
  const MediaFilterOverlay({super.key, required this.filter});

  @override
  State<MediaFilterOverlay> createState() => MediaFilterOverlayState();
}

class MediaFilterOverlayState extends State<MediaFilterOverlay>
    with SignalsMixin {
  // late final Signal<Set<String>> selectedAuthors = createSignal({});
  // late final Signal<Set<String>> selectedTags = createSignal({});
  // late final Signal<Set<String>> selectedPerformers = createSignal({});

  // Widget _buildFunscriptMetadataFilter(MediaFilter filter) {
  //   return ListTile(
  //     title: const Text("Metadata"),
  //     subtitle: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Text("Filter based on the metadata inside funscript files."),
  //         if (filter.funscriptAuthors?.isNotEmpty ?? false)
  //           const SizedBox(height: 8),
  //         _buildTagGroup("Authors: ", filter.funscriptAuthors ?? {}),
  //         if (filter.funscriptTags?.isNotEmpty ?? false)
  //           const SizedBox(height: 8),
  //         _buildTagGroup("Tags: ", filter.funscriptTags ?? {}),
  //         if (filter.funscriptPerformers?.isNotEmpty ?? false)
  //           const SizedBox(height: 8),
  //         _buildTagGroup("Performers: ", filter.funscriptPerformers ?? {}),
  //       ],
  //     ),
  //     onTap: () {
  //       _showFunscriptMetadataFilterBottomSheet();
  //     },
  //   );
  // }

  Widget _buildFilterStatus() {
    return ListTile(
      title: const Text("Clear All Filters"),
      leading: const Icon(Icons.delete_sweep),
      onTap: _clearFilter,
    );
  }

  Widget _buildAddGroup() {
    return ListTile(
      title: const Text("Add Filter Group"),
      leading: const Icon(Icons.add),
      onTap: () {
        widget.filter.filterGroups.add(
          FilterGroup(FilterGroupOperator.and, []),
        );
      },
    );
  }

  void _clearFilter() {
    widget.filter.clearFilter();
  }

  Widget _buildFilterGroup(FilterGroup filterGroup) {
    final operator = filterGroup.operator.watch(context);
    final filters = filterGroup.filters.watch(context);
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownMenu<FilterGroupOperator>(
                initialSelection: operator,
                expandedInsets: EdgeInsets.zero,
                requestFocusOnTap: false,
                enableSearch: false,
                label: const Text('Operator'),
                onSelected: (newValue) {
                  if (newValue == null) return;
                  filterGroup.operator.value = newValue;
                },
                dropdownMenuEntries: FilterGroupOperator.values
                    .map<DropdownMenuEntry<FilterGroupOperator>>((value) {
                      return DropdownMenuEntry<FilterGroupOperator>(
                        value: value,
                        label: value.label,
                        leadingIcon: Icon(value.icon, size: 12),
                      );
                    })
                    .toList(),
              ),
            ),
            const SizedBox(width: 8),
            Icon(operator.icon),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: filters.length,

          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 4),
              child: _buildFilterListItem(
                filters[index],
                onDelete: () {
                  filterGroup.filters.remove(filters[index]);
                },
              ),
            );
          },
        ),
        const SizedBox(height: 4),
        _buildAddFilterItem(filterGroup),
      ],
    );
  }

  Widget _buildAddFilterItem(FilterGroup filterGroup) {
    return DropdownMenu<String?>(
      initialSelection: null,
      expandedInsets: EdgeInsets.zero,
      dropdownMenuEntries: availableFilters.entries.map((filter) {
        final f = filter.value();
        return DropdownMenuEntry<String?>(
          value: filter.key,
          label: f.label,
          leadingIcon: Icon(f.icon),
        );
      }).toList(),
      onSelected: (selectedFilter) {
        if (selectedFilter == null) return;
        final filter = availableFilters[selectedFilter];
        if (filter != null) {
          filterGroup.filters.add(filter());
        }
      },
    );
  }

  Widget _buildFilterListItem(
    FilterBase filter, {
    required void Function() onDelete,
  }) {
    final enabled = filter.enabled.watch(context);
    final negated = filter.negated.watch(context);
    return Row(
      children: [
        Checkbox(
          value: enabled,
          onChanged: (value) {
            filter.enabled.value = value ?? true;
          },
        ),
        IconButton(
          icon: Icon(
            negated ? Icons.remove : Icons.add,
            color: negated ? Colors.red : Colors.grey,
          ),
          onPressed: () {
            filter.negated.value = !filter.negated.value;
          },
        ),
        const SizedBox(width: 4),
        Expanded(child: filter.filterRowWidget(context)),
        IconButton(icon: Icon(Icons.delete), onPressed: onDelete),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final filterGroups = widget.filter.filterGroups.watch(context);
    final cards = [
      SettingsOverlay.settingsCard(
        width: 450,
        title: 'Filter',
        children: [_buildFilterStatus(), _buildAddGroup()],
      ),

      for (int i = 0; i < filterGroups.length; i += 1)
        SettingsOverlay.settingsCard(
          width: 450,
          title: 'Group ${i + 1}',
          onClose: i == 0
              ? null
              : () {
                  widget.filter.filterGroups.remove(filterGroups[i]);
                },
          children: [_buildFilterGroup(filterGroups[i])],
        ),
      // SettingsOverlay.settingsCard(
      //   width: 450,
      //   title: 'Funscript',
      //   children: [_buildFunscriptMetadataFilter(filter)],
      // ),
      // SettingsOverlay.settingsCard(width: 450, title: 'Category', children: []),
    ];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
        ),
        child: MasonryGridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: (MediaQuery.of(context).size.width / 500.0)
              .clamp(1, 3)
              .toInt(),
          mainAxisSpacing: 24,
          crossAxisSpacing: 24,
          itemCount: cards.length,
          itemBuilder: (context, index) {
            return cards[index];
          },
        ),
      ),
    );
    //return SingleChildScrollView(child:);
    // return Dialog(
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    //   child: ConstrainedBox(
    //     constraints: const BoxConstraints(
    //       maxWidth: 500,
    //     ), // Standard dialog width
    //     child: Padding(
    //       padding: const EdgeInsets.all(16.0),
    //       child: Column(
    //         mainAxisSize: MainAxisSize.min, // Dialog shrinks to content
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               Text(
    //                 "Filters",
    //                 style: Theme.of(context).textTheme.headlineSmall,
    //               ),
    //               Row(
    //                 children: [
    //                   TextButton(
    //                     onPressed: () => widget.filter.value = MediaFilter(),
    //                     child: const Text("Reset All"),
    //                   ),
    //                   IconButton(
    //                     onPressed: () => Navigator.of(context).pop(),
    //                     icon: const Icon(Icons.close),
    //                   ),
    //                 ],
    //               ),
    //             ],
    //           ),
    //           const Divider(),
    //           // Flexible allows the content to scroll if the list is long
    //           Flexible(
    //             child: SingleChildScrollView(
    //               child: Column(
    //                 children: [
    //                   _buildFilterTile(
    //                     title: "Categories",
    //                     onTap: _showCategoryBottomSheet,
    //                     subtitle: Column(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         const SizedBox(height: 8),
    //                         _buildTagGroup(
    //                           "Categories:",
    //                           filter.filterCategory != null
    //                               ? {filter.filterCategory.toString()}
    //                               : {},
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                   //const Divider(),
    //                   _buildFilterTile(
    //                     title: "Funscript Metadata",
    //                     onTap: _showFunscriptMetadataFilterBottomSheet,
    //                     subtitle: Column(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         const SizedBox(height: 8),
    //                         _buildTagGroup(
    //                           "Authors:",
    //                           filter.funscriptAuthors ?? {},
    //                         ),
    //                         const SizedBox(height: 8),
    //                         _buildTagGroup("Tags:", filter.funscriptTags ?? {}),
    //                         const SizedBox(height: 8),
    //                         _buildTagGroup(
    //                           "Performers:",
    //                           filter.funscriptPerformers ?? {},
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  // Widget _buildTagGroup(String label, Set<String> tags) {
  //   if (tags.isEmpty) return const SizedBox.shrink();

  //   final tagWidgets = tags
  //       .map(
  //         (tag) => Chip(
  //           label: Text(tag, style: const TextStyle(fontSize: 12)),
  //           visualDensity:
  //               VisualDensity.compact, // Makes chips smaller for the tile
  //           materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  //         ),
  //       )
  //       .toList();
  //   return Wrap(
  //     spacing: 2.0,
  //     runSpacing: 2.0,
  //     crossAxisAlignment: WrapCrossAlignment.center,
  //     children: [
  //       Text(
  //         label,
  //         style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
  //       ),
  //       ...tagWidgets,
  //     ],
  //   );
  // }

  // // Helper to keep the build method clean
  // Widget _buildFilterTile({
  //   required String title,
  //   required VoidCallback onTap,
  //   required Widget subtitle,
  // }) {
  //   return ListTile(
  //     contentPadding: EdgeInsets.zero,
  //     title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
  //     trailing: const Icon(Icons.chevron_right), // Standard UI for "more"
  //     onTap: onTap,
  //     subtitle: subtitle,
  //   );
  // }

  // Sub-menus remain Bottom Sheets
  // Future<void> _showFunscriptMetadataFilterBottomSheet() async {
  //   final authors = oBox.funscriptService.getAllAuthors();
  //   final tags = oBox.funscriptService.getAllTags();
  //   final performers = oBox.funscriptService.getAllPerformers();

  //   await showModalBottomSheet<void>(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (BuildContext context) {
  //       return FunscriptMetadataFilterBottomSheet(
  //         allAuthors: authors,
  //         allTags: tags,
  //         allPerformers: performers,
  //         selectedAuthors: selectedAuthors,
  //         selectedTags: selectedTags,
  //         selectedPerformers: selectedPerformers,
  //       );
  //     },
  //   );

  //   widget.filter.value = widget.filter.value.copyWith(
  //     funscriptAuthors: selectedAuthors.value.isEmpty
  //         ? null
  //         : Set.from(selectedAuthors.value),
  //     funscriptPerformers: selectedPerformers.value.isEmpty
  //         ? null
  //         : Set.from(selectedPerformers.value),
  //     funscriptTags: selectedTags.value.isEmpty
  //         ? null
  //         : Set.from(selectedTags.value),
  //   );
  // }

  // Future<void> _showCategoryBottomSheet() async {
  //   final selected = await showModalBottomSheet<int?>(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (BuildContext context) {
  //       return CategorySelectionDialog(
  //         showAllCategoriesOption: true,
  //         showUncategorizedOption: true,
  //       );
  //     },
  //   );
  //   widget.filter.value = widget.filter.value.copyWith(
  //     filterCategory: selected,
  //   );
  // }
}
