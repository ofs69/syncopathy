import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/ioc.dart';
import 'package:syncopathy/media_library/funscript_metadata_filter_bottom_sheet.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';
import 'package:syncopathy/persistence/entities/user_category.dart';
import 'package:syncopathy/player/video_player.dart';

final Map<String, FilterBase Function()> availableFilters = {
  "Title": () => StringFilter(
    label: "Title",
    icon: Icons.movie,
    retriever: (media) => [media.name, ...media.aliases],
  ),
  "Path": () => StringFilter(
    label: "Path",
    icon: Icons.movie,
    retriever: (media) => [media.mediaPath],
  ),
  "Play Count": () => NumberFilter(
    label: "Play Count",
    icon: Icons.movie,
    retriever: (media) => [media.playCount],
  ),
  "Type": () => EnumFilter<MediaType>(
    label: "Type",
    icon: Icons.movie,
    retriever: (media) => [(media.type ?? MediaType.unknown).id],
    enumValues: MediaType.values,
  ),
  "Category": () => CategoryFilter(
    label: "Category",
    icon: Icons.movie,
    retriever: (media) => media.categories.isEmpty
        ? [-2]
        : media.categories.map((c) => c.id).toList(),
    categories: oBox.userCategoryService.getAllUserCategories(),
  ),
  "Rating": () => EnumFilter<MediaRating>(
    label: "Rating",
    icon: Icons.movie,
    retriever: (media) => [(media.rating ?? MediaRating.noRating).id],
    enumValues: MediaRating.values,
  ),
  "Playlist": () => PlaylistFilter(
    label: "Playlist",
    icon: Icons.playlist_play,
    retriever: (media) => [media.mediaPath],
  ),
  "Funscript Count": () => NumberFilter(
    label: "Funscript Count",
    icon: Icons.description,
    retriever: (media) => [media.funscripts.length],
  ),
  "Average Speed": () => NumberFilter(
    label: "Average Speed",
    icon: Icons.description,
    retriever: (media) => [media.mainFunscript.target?.averageSpeed],
  ),
  "Metadata": () => MetadataFilter(
    label: "Metadata",
    icon: Icons.description,
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
  "Playable": () => BoolFilter(
    label: "Playable",
    icon: Icons.play_circle_outline,
    retriever: (media) => [media.isPlayable],
  ),
  "Missing Files": () => BoolFilter(
    label: "Missing Files",
    icon: Icons.file_open_outlined,
    retriever: (media) => [
      media.fileNotFound ||
          media.mainFunscript.target == null ||
          media.funscripts.any((fs) => fs.fileNotFound),
    ],
  ),
  "Script Tokens": () => BoolFilter(
    label: "Script Tokens",
    icon: Icons.generating_tokens,
    retriever: (media) => [media.mainFunscript.target?.isScriptToken ?? false],
  ),
  "Date Added": () => DateFilter(
    label: "Date Added",
    icon: Icons.calendar_today,
    retriever: (media) => [media.firstIndexedOn],
  ),
};

abstract class FilterBase<T> {
  final String label;
  final IconData icon;
  final Signal<bool> negated = signal(false);
  final Signal<bool> enabled = signal(true);

  List<T?> Function(MediaFile) retriever;

  ReadonlySignal<dynamic> get baseStateChange =>
      computed(() => (negated.value, enabled.value));

  ReadonlySignal<dynamic> get stateChange;

  FilterBase({
    required this.label,
    required this.icon,
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
  ReadonlySignal<dynamic> get stateChange =>
      computed(() => (operator.value, value.value, baseStateChange.value));

  NumberFilter({
    required super.label,
    required super.icon,
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
        PopupMenuButton<FilterOperator>(
          icon: const Icon(Icons.filter_list),
          tooltip: currentOperator.label,
          onSelected: (op) {
            operator.value = op;
          },
          itemBuilder: (context) => FilterOperator.values
              .map(
                (op) => CheckedPopupMenuItem<FilterOperator>(
                  value: op,
                  checked: currentOperator == op,
                  child: Text(op.label),
                ),
              )
              .toList(),
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
  ReadonlySignal<dynamic> get stateChange =>
      computed(() => (operator.value, value.value, baseStateChange.value));

  StringFilter({
    required super.label,
    required super.icon,
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
        PopupMenuButton<StringFilterOperator>(
          icon: const Icon(Icons.filter_list),
          tooltip: currentOperator.label,
          onSelected: (op) {
            operator.value = op;
          },
          itemBuilder: (context) => StringFilterOperator.values
              .map(
                (op) => CheckedPopupMenuItem<StringFilterOperator>(
                  value: op,
                  checked: currentOperator == op,
                  child: Text(op.label),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class DateFilter extends FilterBase<DateTime> {
  final Signal<FilterOperator> operator = signal(FilterOperator.equals);
  final Signal<DateTime?> value = signal(null);

  @override
  ReadonlySignal<dynamic> get stateChange =>
      computed(() => (operator.value, value.value, baseStateChange.value));

  DateFilter({
    required super.label,
    required super.icon,
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

  final TextEditingController _dateController = TextEditingController();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: value.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    value.value = picked;
    _dateController.text = picked != null
        ? "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}"
        : "";
  }

  @override
  Widget filterRowWidget(BuildContext context) {
    final currentOperator = operator.watch(context);
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _dateController,
            readOnly: true,
            onTap: () => _selectDate(context),
            decoration: InputDecoration(
              labelText: label,
              hintText: label,
              prefixIcon: Icon(icon),
              suffixIcon: const Icon(Icons.calendar_today, size: 18),
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 4),
        PopupMenuButton<FilterOperator>(
          icon: const Icon(Icons.filter_list),
          tooltip: currentOperator.label,
          onSelected: (op) {
            operator.value = op;
          },
          itemBuilder: (context) => FilterOperator.values
              .map(
                (op) => CheckedPopupMenuItem<FilterOperator>(
                  value: op,
                  checked: currentOperator == op,
                  child: Text(op.label),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class EnumFilter<E extends Enum> extends FilterBase<int> {
  final List<E> enumValues;
  final Signal<E?> selectedValue = signal(null);

  @override
  ReadonlySignal<dynamic> get stateChange =>
      computed(() => (selectedValue.value, baseStateChange.value));

  EnumFilter({
    required super.label,
    required super.icon,
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
  ReadonlySignal<dynamic> get stateChange =>
      computed(() => (selectedCategoryId.value, baseStateChange.value));

  CategoryFilter({
    required super.label,
    required super.icon,
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
      const DropdownMenuEntry<int>(value: -2, label: "Uncategorized"),
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
  ReadonlySignal<dynamic> get stateChange => computed(
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
  ReadonlySignal<dynamic> get stateChange =>
      computed(() => (baseStateChange.value));

  PlaylistFilter({
    required super.label,
    required super.icon,
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
  ReadonlySignal<dynamic> get stateChange =>
      computed(() => (baseStateChange.value));

  BoolFilter({
    required super.label,
    required super.icon,
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
