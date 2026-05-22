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
  }
}
