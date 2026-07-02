import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/media_library/funscript_metadata_filter_bottom_sheet.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';
import 'package:syncopathy/persistence/entities/user_category.dart';
import 'package:syncopathy/player/video_player.dart';

/// Sentinel category id used by [CategoryFilter] to represent media that has no
/// user categories assigned ("Uncategorized").
const int kUncategorizedCategoryId = -2;

/// Shared operator-selection menu used by the number/string/date filter rows.
/// [values] are the selectable operators, [labelOf] renders each one.
Widget _operatorMenu<T>({
  required List<T> values,
  required T current,
  required String Function(T) labelOf,
  required ValueChanged<T> onSelected,
}) {
  return PopupMenuButton<T>(
    icon: const Icon(Icons.filter_list),
    tooltip: labelOf(current),
    onSelected: onSelected,
    itemBuilder: (context) => values
        .map(
          (op) => CheckedPopupMenuItem<T>(
            value: op,
            checked: current == op,
            child: Text(labelOf(op)),
          ),
        )
        .toList(),
  );
}

final Map<String, FilterBase Function()> availableFilters = {
  "Title": () => StringFilter(
    label: "Title",
    icon: Icons.title,
    category: FilterCategory.media,
    sortOrder: 0,
    retriever: (media) => [media.name, ...media.aliases],
  ),
  "Type": () => EnumFilter<MediaType>(
    label: "Type",
    icon: Icons.category,
    category: FilterCategory.media,
    sortOrder: 1,
    retriever: (media) => [(media.type ?? MediaType.unknown).id],
    enumValues: MediaType.values,
  ),
  "Category": () => CategoryFilter(
    label: "Category",
    icon: Icons.label,
    category: FilterCategory.media,
    sortOrder: 2,
    retriever: (media) => media.categories.isEmpty
        ? [kUncategorizedCategoryId]
        : media.categories.map((c) => c.id).toList(),
    categories: oBox.userCategoryService.getAllUserCategories(),
  ),
  "Rating": () => EnumFilter<MediaRating>(
    label: "Rating",
    icon: Icons.star,
    category: FilterCategory.media,
    sortOrder: 3,
    retriever: (media) => [(media.rating ?? MediaRating.noRating).id],
    enumValues: MediaRating.values,
  ),
  "Date Added": () => DateFilter(
    label: "Date Added",
    icon: Icons.calendar_today,
    category: FilterCategory.media,
    sortOrder: 4,
    retriever: (media) => [media.firstIndexedOn],
  ),
  "Path": () => StringFilter(
    label: "Path",
    icon: Icons.folder,
    category: FilterCategory.media,
    sortOrder: 5,
    retriever: (media) => [media.mediaPath],
  ),
  "Funscript Count": () => NumberFilter(
    label: "Funscript Count",
    icon: Icons.numbers,
    category: FilterCategory.funscript,
    sortOrder: 0,
    retriever: (media) => [media.funscripts.length],
  ),
  "Average Speed": () => NumberFilter(
    label: "Average Speed",
    icon: Icons.speed,
    category: FilterCategory.funscript,
    sortOrder: 1,
    retriever: (media) => [media.mainFunscript.target?.averageSpeed],
  ),
  "Metadata": () => MetadataFilter(
    label: "Metadata",
    icon: Icons.tag,
    category: FilterCategory.funscript,
    sortOrder: 2,
    retriever: (media) {
      final fs = media.mainFunscript.target;
      if (fs == null || fs.metadata == null) return [];
      final meta = fs.metadata!;
      return [
        if (meta.creator != null) meta.creator!,
        ...meta.tags,
        ...meta.performers,
      ];
    },
  ),
  "Script Tokens": () => BoolFilter(
    label: "Script Tokens",
    icon: Icons.generating_tokens,
    category: FilterCategory.funscript,
    sortOrder: 3,
    retriever: (media) => [media.mainFunscript.target?.isScriptToken ?? false],
  ),
  "Play Count": () => NumberFilter(
    label: "Play Count",
    icon: Icons.analytics,
    category: FilterCategory.status,
    sortOrder: 0,
    retriever: (media) => [media.playCount],
  ),
  "Playlist": () => PlaylistFilter(
    label: "Playlist",
    icon: Icons.playlist_play,
    category: FilterCategory.status,
    sortOrder: 1,
    retriever: (media) => [media.mediaPath],
  ),
  "Playable": () => BoolFilter(
    label: "Playable",
    icon: Icons.play_circle_outline,
    category: FilterCategory.status,
    sortOrder: 2,
    retriever: (media) => [media.isPlayable],
  ),
  "Missing Files": () => BoolFilter(
    label: "Missing Files",
    icon: Icons.error_outline,
    category: FilterCategory.status,
    sortOrder: 3,
    retriever: (media) => [
      media.fileNotFound ||
          media.mainFunscript.target == null ||
          media.funscripts.any((fs) => fs.fileNotFound),
    ],
  ),
};

enum FilterCategory {
  media("Media"),
  funscript("Funscript"),
  status("Status & Playback");

  final String label;
  const FilterCategory(this.label);
}

abstract class FilterBase<T> {
  final String label;
  final IconData icon;
  final FilterCategory category;
  final int sortOrder;
  final Signal<bool> negated = signal(false);
  final Signal<bool> enabled = signal(true);

  List<T?> Function(MediaFile) retriever;

  late final ReadonlySignal<dynamic> baseStateChange =
      computed(() => (negated.value, enabled.value));

  ReadonlySignal<dynamic> get stateChange;

  FilterBase({
    required this.label,
    required this.icon,
    required this.category,
    required this.sortOrder,
    required this.retriever,
  });

  bool matches(MediaFile media) {
    if (!enabled.value) return true;
    final values = retriever(media);
    if (values.isEmpty) return false;
    bool result = values.any((v) => v != null && performMatch(v));
    return negated.value ? !result : result;
  }

  bool performMatch(T value);

  Widget filterRowWidget(BuildContext context);
}

enum FilterOperator {
  equals('=='),
  greater('>'),
  lesser('<'),
  greaterEqual('>='),
  lesserEqual('<=');

  final String label;
  const FilterOperator(this.label);
}

enum StringFilterOperator {
  stringContains("Contains"),
  stringStartsWith("Starts With"),
  stringEndsWith("Ends With"),
  stringEquals("Equals");

  final String label;
  const StringFilterOperator(this.label);
}

class NumberFilter extends FilterBase<num> {
  final Signal<FilterOperator> operator = signal(FilterOperator.equals);
  final Signal<String> value = signal("");

  @override
  late final ReadonlySignal<dynamic> stateChange =
      computed(() => (operator.value, value.value, baseStateChange.value));

  NumberFilter({
    required super.label,
    required super.icon,
    required super.category,
    required super.sortOrder,
    required super.retriever,
  });

  @override
  bool performMatch(num value) {
    final double? filterValue = double.tryParse(this.value.value);
    if (filterValue == null) return true;

    return switch (operator.value) {
      FilterOperator.equals => value == filterValue,
      FilterOperator.greater => value > filterValue,
      FilterOperator.lesser => value < filterValue,
      FilterOperator.greaterEqual => value >= filterValue,
      FilterOperator.lesserEqual => value <= filterValue,
    };
  }

  @override
  Widget filterRowWidget(BuildContext context) {
    final currentOperator = operator.watch(context);
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: (v) => value.value = v,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            decoration: InputDecoration(
              labelText: label,
              hintText: label,
              prefixIcon: Icon(icon),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 4),
        _operatorMenu<FilterOperator>(
          values: FilterOperator.values,
          current: currentOperator,
          labelOf: (op) => op.label,
          onSelected: (op) => operator.value = op,
        ),
      ],
    );
  }
}

class StringFilter extends FilterBase<String> {
  final Signal<StringFilterOperator> operator = signal(
    StringFilterOperator.stringContains,
  );
  final Signal<String> value = signal("");

  @override
  late final ReadonlySignal<dynamic> stateChange =
      computed(() => (operator.value, value.value, baseStateChange.value));

  StringFilter({
    required super.label,
    required super.icon,
    required super.category,
    required super.sortOrder,
    required super.retriever,
  });

  @override
  bool performMatch(String value) {
    final filterValue = this.value.value.toLowerCase();
    if (filterValue.isEmpty) return true;
    final val = value.toLowerCase();

    return switch (operator.value) {
      StringFilterOperator.stringContains => val.contains(filterValue),
      StringFilterOperator.stringStartsWith => val.startsWith(filterValue),
      StringFilterOperator.stringEndsWith => val.endsWith(filterValue),
      StringFilterOperator.stringEquals => val == filterValue,
    };
  }

  @override
  Widget filterRowWidget(BuildContext context) {
    final currentOperator = operator.watch(context);
    return Row(
      children: [
        Expanded(
          child: Tooltip(
            message: label,
            child: TextField(
              onChanged: (v) => value.value = v,
              decoration: InputDecoration(
                labelText: label,
                hintText: label,
                prefixIcon: Icon(icon),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        _operatorMenu<StringFilterOperator>(
          values: StringFilterOperator.values,
          current: currentOperator,
          labelOf: (op) => op.label,
          onSelected: (op) => operator.value = op,
        ),
      ],
    );
  }
}

class DateFilter extends FilterBase<DateTime> {
  final Signal<FilterOperator> operator = signal(FilterOperator.equals);
  final Signal<DateTime?> value = signal(null);

  @override
  late final ReadonlySignal<dynamic> stateChange =
      computed(() => (operator.value, value.value, baseStateChange.value));

  DateFilter({
    required super.label,
    required super.icon,
    required super.category,
    required super.sortOrder,
    required super.retriever,
  });

  @override
  bool performMatch(DateTime value) {
    final filterValue = this.value.value;
    if (filterValue == null) return true;

    // Compare only dates (ignoring time)
    final v = DateTime(value.year, value.month, value.day);
    final f = DateTime(filterValue.year, filterValue.month, filterValue.day);

    return switch (operator.value) {
      FilterOperator.equals => v.isAtSameMomentAs(f),
      FilterOperator.greater => v.isAfter(f),
      FilterOperator.lesser => v.isBefore(f),
      FilterOperator.greaterEqual => v.isAtSameMomentAs(f) || v.isAfter(f),
      FilterOperator.lesserEqual => v.isAtSameMomentAs(f) || v.isBefore(f),
    };
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: value.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) value.value = picked;
  }

  static String _formatDate(DateTime d) =>
      "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

  @override
  Widget filterRowWidget(BuildContext context) {
    final currentOperator = operator.watch(context);
    final currentValue = value.watch(context);
    return Row(
      children: [
        // Reads the signal directly instead of mirroring into a
        // TextEditingController (the filter has no dispose hook, so a
        // controller here would leak).
        Expanded(
          child: InkWell(
            onTap: () => _selectDate(context),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: label,
                prefixIcon: Icon(icon),
                suffixIcon: const Icon(Icons.calendar_today, size: 18),
                border: const OutlineInputBorder(),
              ),
              child: Text(
                currentValue != null ? _formatDate(currentValue) : "",
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        _operatorMenu<FilterOperator>(
          values: FilterOperator.values,
          current: currentOperator,
          labelOf: (op) => op.label,
          onSelected: (op) => operator.value = op,
        ),
      ],
    );
  }
}

class EnumFilter<E extends Enum> extends FilterBase<int> {
  final List<E> enumValues;
  final Signal<E?> selectedValue = signal(null);

  @override
  late final ReadonlySignal<dynamic> stateChange =
      computed(() => (selectedValue.value, baseStateChange.value));

  EnumFilter({
    required super.label,
    required super.icon,
    required super.category,
    required super.sortOrder,
    required super.retriever,
    required this.enumValues,
  });

  @override
  bool performMatch(int value) {
    final filterValue = selectedValue.value;
    if (filterValue == null) return true;
    return value == filterValue.index;
  }

  @override
  Widget filterRowWidget(BuildContext context) {
    return DropdownMenu<E>(
      onSelected: (v) => selectedValue.value = v,
      expandedInsets: EdgeInsets.zero,
      label: Text(label),
      leadingIcon: Icon(icon),
      dropdownMenuEntries: enumValues
          .map((s) => DropdownMenuEntry<E>(value: s, label: s.name))
          .toList(),
    );
  }
}

class CategoryFilter extends FilterBase<int> {
  final Signal<int?> selectedCategoryId = signal(null);
  final List<UserCategory> categories;

  @override
  late final ReadonlySignal<dynamic> stateChange =
      computed(() => (selectedCategoryId.value, baseStateChange.value));

  CategoryFilter({
    required super.label,
    required super.icon,
    required super.category,
    required super.sortOrder,
    required super.retriever,
    required this.categories,
  });

  @override
  bool performMatch(int value) {
    final filterValue = selectedCategoryId.value;
    if (filterValue == null) return true;
    return value == filterValue;
  }

  @override
  Widget filterRowWidget(BuildContext context) {
    final currentSelected = selectedCategoryId.watch(context);

    // Add "Uncategorized" option to the list for display
    final List<DropdownMenuEntry<int>> entries = [
      const DropdownMenuEntry<int>(
        value: kUncategorizedCategoryId,
        label: "Uncategorized",
      ),
      ...categories.map(
        (c) => DropdownMenuEntry<int>(value: c.id, label: c.name),
      ),
    ];

    return DropdownMenu<int>(
      initialSelection: currentSelected,
      onSelected: (v) => selectedCategoryId.value = v,
      expandedInsets: EdgeInsets.zero,
      label: Text(label),
      leadingIcon: Icon(icon),
      dropdownMenuEntries: entries,
    );
  }
}

class MetadataFilter extends FilterBase<String> {
  final Signal<Set<String>> selectedAuthors = signal({});
  final Signal<Set<String>> selectedTags = signal({});
  final Signal<Set<String>> selectedPerformers = signal({});

  @override
  late final ReadonlySignal<dynamic> stateChange = computed(
    () => (
      selectedAuthors.value,
      selectedTags.value,
      selectedPerformers.value,
      baseStateChange.value,
    ),
  );

  MetadataFilter({
    required super.label,
    required super.icon,
    required super.category,
    required super.sortOrder,
    required super.retriever,
  });

  @override
  bool performMatch(String value) {
    if (selectedAuthors.value.isEmpty &&
        selectedTags.value.isEmpty &&
        selectedPerformers.value.isEmpty) {
      return true;
    }

    return selectedAuthors.value.contains(value) ||
        selectedTags.value.contains(value) ||
        selectedPerformers.value.contains(value);
  }

  @override
  Widget filterRowWidget(BuildContext context) {
    final authors = selectedAuthors.watch(context);
    final tags = selectedTags.watch(context);
    final performers = selectedPerformers.watch(context);

    final totalCount = authors.length + tags.length + performers.length;
    final summary = totalCount == 0 ? "All Metadata" : "$totalCount selected";

    return ListTile(
      title: Text(label),
      subtitle: Text(summary),
      leading: Icon(icon),
      dense: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      onTap: () async {
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => FunscriptMetadataFilterBottomSheet(
            allAuthors: oBox.funscriptService.getAllAuthors(),
            allTags: oBox.funscriptService.getAllTags(),
            allPerformers: oBox.funscriptService.getAllPerformers(),
            selectedAuthors: selectedAuthors,
            selectedTags: selectedTags,
            selectedPerformers: selectedPerformers,
          ),
        );
      },
    );
  }
}

enum FilterGroupOperator {
  and("AND", Icons.join_inner),
  or("OR", Icons.join_full);

  final String label;
  final IconData icon;
  const FilterGroupOperator(this.label, this.icon);
}

class FilterGroup {
  final Signal<FilterGroupOperator> operator;
  final ListSignal<FilterBase> filters;

  late final ReadonlySignal<dynamic> stateChange = computed(() {
    final ops = operator.value;
    final fs = filters.toList();
    final filterStates = fs.map((f) => f.stateChange.value).toList();
    return (ops, filterStates);
  });

  FilterGroup(FilterGroupOperator operator, List<FilterBase> filters)
    : operator = signal(operator),
      filters = listSignal(filters);
}

class MediaFilter {
  final ListSignal<FilterGroup> filterGroups = listSignal([
    FilterGroup(FilterGroupOperator.and, []),
  ]);

  late final ReadonlySignal<dynamic> stateChange = computed(() {
    final groups = filterGroups.toList();
    final groupStates = groups.map((g) => g.stateChange.value).toList();
    return groupStates;
  });

  FilterGroup get defaultGroup => filterGroups[0];
  late final ReadonlySignal<bool> isCustomized = computed(() {
    return filterGroups.any((f) => f.filters.isNotEmpty);
  });

  MediaFilter();

  void clearFilter() {
    filterGroups.clear();
    filterGroups.add(FilterGroup(FilterGroupOperator.and, []));
  }
}

class PlaylistFilter extends FilterBase<String> {
  @override
  late final ReadonlySignal<dynamic> stateChange =
      computed(() => (baseStateChange.value));

  PlaylistFilter({
    required super.label,
    required super.icon,
    required super.category,
    required super.sortOrder,
    required super.retriever,
  });

  @override
  bool performMatch(String value) {
    final videoPlayer = getIt.get<VideoPlayer>();
    final playlist = videoPlayer.currentPlaylist.peek();

    final canonValue = p.canonicalize(value);
    return playlist.canonicalFilenames.value.contains(canonValue);
  }

  @override
  Widget filterRowWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 8),
          const Text("In active playlist"),
        ],
      ),
    );
  }
}

class BoolFilter extends FilterBase<bool> {
  @override
  late final ReadonlySignal<dynamic> stateChange =
      computed(() => (baseStateChange.value));

  BoolFilter({
    required super.label,
    required super.icon,
    required super.category,
    required super.sortOrder,
    required super.retriever,
  });

  @override
  bool performMatch(bool value) {
    return value;
  }

  @override
  Widget filterRowWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [Icon(icon, size: 16), const SizedBox(width: 8), Text(label)],
      ),
    );
  }
}
