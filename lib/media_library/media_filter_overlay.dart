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

  Future<void> _clearFilter() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear all filters?'),
        content: const Text(
          'This removes every filter group and all of its filters.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear all'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      widget.filter.clearFilter();
    }
  }

  Widget _buildFilterGroup(FilterGroup filterGroup) {
    return Watch((context) {
      final operator = filterGroup.operator.value;
      final filters = filterGroup.filters.value;
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
                          leadingIcon: Icon(value.icon),
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
    });
  }

  Widget _buildAddFilterItem(FilterGroup filterGroup) {
    return SearchAnchor(
      viewShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          controller: controller,
          constraints: const BoxConstraints(
            minWidth: double.infinity,
            minHeight: 48,
            maxHeight: 48,
          ),
          padding: const WidgetStatePropertyAll<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 16.0),
          ),
          onTap: () {
            controller.openView();
          },
          onChanged: (_) {
            controller.openView();
          },
          leading: const Icon(Icons.add),
          hintText: "Add filter...",
          elevation: const WidgetStatePropertyAll<double>(0),
          shape: const WidgetStatePropertyAll<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
          ),
          side: WidgetStatePropertyAll<BorderSide>(
            BorderSide(color: Theme.of(context).dividerColor),
          ),
          backgroundColor: const WidgetStatePropertyAll<Color>(
            Colors.transparent,
          ),
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        final query = controller.text.toLowerCase();

        // View 1: Categorized List (Empty Query)
        if (query.isEmpty) {
          final List<Widget> suggestions = [];

          for (final category in FilterCategory.values) {
            final categoryFilters = availableFilters.entries.where((entry) {
              final f = entry.value();
              return f.category == category;
            }).toList();

            // Sort by sortOrder
            categoryFilters.sort((a, b) {
              return a.value().sortOrder.compareTo(b.value().sortOrder);
            });

            if (categoryFilters.isNotEmpty) {
              suggestions.add(
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    category.label,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              );

              for (final entry in categoryFilters) {
                final f = entry.value();
                suggestions.add(
                  ListTile(
                    title: Text(f.label),
                    leading: Icon(f.icon),
                    onTap: () {
                      filterGroup.filters.add(entry.value());
                      controller.closeView(null);
                    },
                  ),
                );
              }
            }
          }
          return suggestions;
        }

        // View 2: Search Results
        final matches = availableFilters.entries.where((entry) {
          return entry.key.toLowerCase().contains(query);
        });

        return matches.map((entry) {
          final f = entry.value();
          return ListTile(
            title: Text(f.label),
            leading: Icon(f.icon),
            onTap: () {
              filterGroup.filters.add(entry.value());
              controller.closeView(null);
            },
          );
        });
      },
    );
  }

  Widget _buildFilterListItem(
    FilterBase filter, {
    required void Function() onDelete,
  }) {
    return Watch((context) {
      final enabled = filter.enabled.value;
      final negated = filter.negated.value;
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
              color: negated
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            tooltip: negated
                ? 'Excluding matches — tap to include'
                : 'Including matches — tap to exclude',
            onPressed: () {
              filter.negated.value = !filter.negated.value;
            },
          ),
          const SizedBox(width: 4),
          Expanded(child: filter.filterRowWidget(context)),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Remove filter',
            onPressed: onDelete,
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
        ),
        child: Watch.builder(
          builder: (context) {
            final filterGroups = widget.filter.filterGroups.watch(context);
            final itemCount = 1 + filterGroups.length;

            return MasonryGridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: (MediaQuery.of(context).size.width / 600.0)
                  .clamp(1, 2)
                  .toInt(),
              mainAxisSpacing: 24,
              crossAxisSpacing: 24,
              itemCount: itemCount,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return SettingsOverlay.settingsCard(
                    width: 600,
                    title: 'Filter',
                    children: [_buildFilterStatus(), _buildAddGroup()],
                  );
                }
                final groupIndex = index - 1;
                final filterGroup = filterGroups[groupIndex];
                return SettingsOverlay.settingsCard(
                  width: 600,
                  title: 'Group ${groupIndex + 1}',
                  closeTooltip: 'Remove group',
                  onClose: groupIndex == 0
                      ? null
                      : () {
                          widget.filter.filterGroups.remove(filterGroup);
                        },
                  children: [_buildFilterGroup(filterGroup)],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
