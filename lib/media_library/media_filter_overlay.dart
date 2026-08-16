import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/media_library/filter/media_filter.dart';
import 'package:syncopathy/media_library/filter/media_filter_preset.dart';
import 'package:syncopathy/model/media_filter_presets_model.dart';
import 'package:syncopathy/settings_overlay.dart';

class MediaFilterOverlay extends StatefulWidget {
  final MediaFilter filter;
  final MediaFilterPresetsModel presets;
  final ReadonlySignal<bool> isPresetDirty;
  final ValueChanged<String> onLoadPreset;
  const MediaFilterOverlay({
    super.key,
    required this.filter,
    required this.presets,
    required this.isPresetDirty,
    required this.onLoadPreset,
  });

  @override
  State<MediaFilterOverlay> createState() => MediaFilterOverlayState();
}

class MediaFilterOverlayState extends State<MediaFilterOverlay> {
  Future<String?> _askForName(
    String title, {
    String initialValue = '',
    String confirmLabel = 'Save',
  }) async {
    final controller = TextEditingController(text: initialValue);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Preset name'),
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) Navigator.pop(context, value.trim());
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Navigator.pop(context, controller.text.trim());
              }
            },
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    controller.dispose();
    return result;
  }

  Future<void> _saveAsPreset() async {
    final name = await _askForName('Save filter preset');
    if (name == null || !mounted) return;
    await widget.presets.add(name, MediaFilterSnapshot.capture(widget.filter));
  }

  Future<void> _updatePreset() async {
    final active = widget.presets.activePreset.value;
    if (active == null) return;
    await widget.presets.update(
      active.id,
      MediaFilterSnapshot.capture(widget.filter),
    );
  }

  Future<void> _renamePreset() async {
    final active = widget.presets.activePreset.value;
    if (active == null) return;
    final name = await _askForName(
      'Rename filter preset',
      initialValue: active.name,
      confirmLabel: 'Rename',
    );
    if (name != null) await widget.presets.rename(active.id, name);
  }

  Future<void> _deletePreset() async {
    final active = widget.presets.activePreset.value;
    if (active == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete filter preset?'),
        content: Text(
          'Delete “${active.name}”? The current filters will remain.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) await widget.presets.remove(active.id);
  }

  /// Gear menu holding the actions that operate on the selected preset itself.
  Widget _buildPresetMenu(MediaFilterPreset? active, bool dirty) {
    return MenuAnchor(
      style: const MenuStyle(padding: WidgetStatePropertyAll(EdgeInsets.zero)),
      builder: (context, controller, child) => IconButton(
        icon: const Icon(Icons.settings),
        tooltip: 'Preset Options',
        onPressed: active == null
            ? null
            : () => controller.isOpen ? controller.close() : controller.open(),
      ),
      menuChildren: [
        MenuItemButton(
          leadingIcon: const Icon(Icons.save),
          onPressed: dirty ? _updatePreset : null,
          child: const Text('Update Preset'),
        ),
        MenuItemButton(
          leadingIcon: const Icon(Icons.drive_file_rename_outline),
          onPressed: _renamePreset,
          child: const Text('Rename Preset'),
        ),
        MenuItemButton(
          leadingIcon: const Icon(Icons.bookmark_remove),
          onPressed: _deletePreset,
          child: const Text('Delete Preset'),
        ),
      ],
    );
  }

  /// The preset picker and its actions.
  ///
  /// This has to carry its own [SignalBuilder]: the card is produced by the
  /// [MasonryGridView] item builder, which runs during layout — outside the
  /// tracking scope of the [SignalBuilder] in [build].
  Widget _buildPresetControls() {
    return SignalBuilder(
      builder: (context) {
        final presets = widget.presets.presets.value;
        final active = widget.presets.activePreset.value;
        final dirty = widget.isPresetDirty.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              // The buttons sit next to the field, not next to the field plus
              // its helper text, so align to the top and nudge them down by the
              // difference between the field and icon-button heights.
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: DropdownMenu<String>(
                    // DropdownMenu only refreshes its text field when
                    // initialSelection changes, so key it on the displayed name
                    // too — otherwise a rename leaves the old name in the field.
                    key: ValueKey('${active?.id}|${active?.name}'),
                    initialSelection: active?.id,
                    enabled: presets.isNotEmpty,
                    expandedInsets: EdgeInsets.zero,
                    requestFocusOnTap: false,
                    enableSearch: false,
                    label: const Text('Preset'),
                    hintText: presets.isEmpty
                        ? 'No saved presets'
                        : 'Select a preset',
                    helperText: active == null
                        ? null
                        : dirty
                        ? 'Modified'
                        : 'Saved',
                    leadingIcon: const Icon(Icons.bookmarks_outlined),
                    onSelected: (id) {
                      if (id != null) widget.onLoadPreset(id);
                    },
                    dropdownMenuEntries: presets
                        .map(
                          (preset) => DropdownMenuEntry<String>(
                            value: preset.id,
                            label: preset.name,
                            leadingIcon: const Icon(Icons.bookmark_outline),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: IconButton(
                    icon: const Icon(Icons.filter_alt),
                    tooltip: 'Apply Preset',
                    onPressed: active == null || !dirty
                        ? null
                        : () => widget.onLoadPreset(active.id),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: _buildPresetMenu(active, dirty),
                ),
              ],
            ),
            const SizedBox(height: 4),
            ListTile(
              title: const Text('Save As New Preset'),
              leading: const Icon(Icons.bookmark_add),
              onTap: _saveAsPreset,
            ),
          ],
        );
      },
    );
  }

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
    return SignalBuilder(
      builder: (context) {
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
                  child: KeyedSubtree(
                    key: ObjectKey(filters[index]),
                    child: _buildFilterListItem(
                      filters[index],
                      onDelete: () {
                        filterGroup.filters.remove(filters[index]);
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 4),
            _buildAddFilterItem(filterGroup),
          ],
        );
      },
    );
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
    return SignalBuilder(
      builder: (context) {
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
        ),
        child: SignalBuilder(
          builder: (context) {
            final filterGroups = widget.filter.filterGroups.value;
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
                    children: [
                      _buildPresetControls(),
                      const Divider(),
                      _buildFilterStatus(),
                      _buildAddGroup(),
                    ],
                  );
                }
                final groupIndex = index - 1;
                final filterGroup = filterGroups[groupIndex];
                // Keyed on the group instance: loading a preset swaps in fresh
                // groups, and without a key the recycled elements would keep
                // the previous group's text-field contents.
                return KeyedSubtree(
                  key: ObjectKey(filterGroup),
                  child: SettingsOverlay.settingsCard(
                    width: 600,
                    title: 'Group ${groupIndex + 1}',
                    closeTooltip: 'Remove group',
                    onClose: groupIndex == 0
                        ? null
                        : () {
                            widget.filter.filterGroups.remove(filterGroup);
                          },
                    children: [_buildFilterGroup(filterGroup)],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
