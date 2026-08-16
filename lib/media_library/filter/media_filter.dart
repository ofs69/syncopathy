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
  final currentLabel = labelOf(current);
  return Builder(
    builder: (context) => PopupMenuButton<T>(
      tooltip: 'Filter operator: $currentLabel',
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
      child: Semantics(
        button: true,
        label: 'Filter operator',
        value: currentLabel,
        child: Container(
          height: 48,
          constraints: const BoxConstraints(minWidth: 56),
          padding: const EdgeInsets.only(left: 12, right: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.outline),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(currentLabel),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    ),
  );
}

/// Relative windows for [DateFilter], resolved against the current date every
/// time the filter runs.
///
/// Each entry is the *start* of its window, so it composes with the existing
/// operators: "on or after · This Month" is everything added since the 1st,
/// "before · Last 30 Days" is everything older than that.
enum DateFilterPeriod {
  today('Today'),
  thisWeek('This Week'),
  thisMonth('This Month'),
  thisYear('This Year'),
  last7Days('Last 7 Days'),
  last30Days('Last 30 Days'),
  last90Days('Last 90 Days');

  final String label;
  const DateFilterPeriod(this.label);

  /// The first day of this window relative to [now].
  ///
  /// Built from calendar fields rather than [Duration] arithmetic: subtracting
  /// days as a duration lands on 23:00 of the previous day across a DST
  /// boundary, which would shift the window by a day. Weeks start on Monday.
  DateTime startFrom(DateTime now) => switch (this) {
    DateFilterPeriod.today => DateTime(now.year, now.month, now.day),
    DateFilterPeriod.thisWeek => DateTime(
      now.year,
      now.month,
      now.day - (now.weekday - 1),
    ),
    DateFilterPeriod.thisMonth => DateTime(now.year, now.month),
    DateFilterPeriod.thisYear => DateTime(now.year),
    DateFilterPeriod.last7Days => DateTime(now.year, now.month, now.day - 6),
    DateFilterPeriod.last30Days => DateTime(now.year, now.month, now.day - 29),
    DateFilterPeriod.last90Days => DateTime(now.year, now.month, now.day - 89),
  };
}

/// The "pick an exact date" entry of the date menu. It sits alongside the
/// [DateFilterPeriod] entries, so it needs a value of its own — `null` is not
/// usable there, `PopupMenuButton` reads it as a cancelled menu.
enum _CustomDateChoice { pick }

String _dateOperatorLabel(FilterOperator operator) => switch (operator) {
  FilterOperator.equals => 'On',
  FilterOperator.greater => 'After',
  FilterOperator.lesser => 'Before',
  FilterOperator.greaterEqual => 'On or after',
  FilterOperator.lesserEqual => 'On or before',
};

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
  "Duration": () => DurationFilter(
    label: "Duration",
    icon: Icons.timer,
    category: FilterCategory.media,
    sortOrder: 4,
    retriever: (media) => [media.metadata.target?.duration],
  ),
  "Date Added": () => DateFilter(
    label: "Date Added",
    icon: Icons.calendar_today,
    category: FilterCategory.media,
    sortOrder: 5,
    retriever: (media) => [media.firstIndexedOn],
  ),
  "Path": () => StringFilter(
    label: "Path",
    icon: Icons.folder,
    category: FilterCategory.media,
    sortOrder: 6,
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

  late final ReadonlySignal<dynamic> baseStateChange = computed(
    () => (negated.value, enabled.value),
  );

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
  equals('='),
  greater('>'),
  lesser('<'),
  greaterEqual('≥'),
  lesserEqual('≤');

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
  late final ReadonlySignal<dynamic> stateChange = computed(
    () => (operator.value, value.value, baseStateChange.value),
  );

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
    final currentOperator = operator.value;
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: value.value,
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

/// Filters on media duration, which `MediaMetadata` stores in seconds.
///
/// Typing raw seconds would be miserable for a library of hour-long videos, so
/// the input is minute-first: a bare number is minutes ("90"), and colon
/// notation reads right-to-left from seconds ("5:30" is 5m30s, "1:05:30" is
/// 1h5m30s) the way every media player writes it.
class DurationFilter extends FilterBase<num> {
  final Signal<FilterOperator> operator = signal(FilterOperator.greaterEqual);
  final Signal<String> value = signal("");

  @override
  late final ReadonlySignal<dynamic> stateChange = computed(
    () => (operator.value, value.value, baseStateChange.value),
  );

  DurationFilter({
    required super.label,
    required super.icon,
    required super.category,
    required super.sortOrder,
    required super.retriever,
  });

  /// Parses a duration input into a target in [seconds], plus the [tolerance]
  /// an `==` comparison should allow.
  ///
  /// The tolerance tracks how precisely the input was expressed — bare minutes
  /// match to the half-minute, colon notation to the half-second — so `== 90`
  /// finds everything that rounds to 90 minutes rather than only what is
  /// exactly 5400.0 seconds long. Returns null for anything unparseable, which
  /// callers treat as "no constraint".
  static ({double seconds, double tolerance})? parseInput(String input) {
    final text = input.trim();
    if (text.isEmpty) return null;

    if (!text.contains(':')) {
      final minutes = double.tryParse(text);
      if (minutes == null || minutes.isNegative) return null;
      return (seconds: minutes * 60, tolerance: 30);
    }

    final parts = text.split(':');
    if (parts.length > 3) return null;

    var seconds = 0.0;
    for (final part in parts) {
      final component = double.tryParse(part.trim());
      if (component == null || component.isNegative) return null;
      seconds = seconds * 60 + component;
    }
    return (seconds: seconds, tolerance: 0.5);
  }

  @override
  bool performMatch(num value) {
    final target = parseInput(this.value.value);
    if (target == null) return true;

    final seconds = value.toDouble();
    return switch (operator.value) {
      FilterOperator.equals =>
        (seconds - target.seconds).abs() <= target.tolerance,
      FilterOperator.greater => seconds > target.seconds,
      FilterOperator.lesser => seconds < target.seconds,
      FilterOperator.greaterEqual => seconds >= target.seconds,
      FilterOperator.lesserEqual => seconds <= target.seconds,
    };
  }

  @override
  Widget filterRowWidget(BuildContext context) {
    final currentOperator = operator.value;
    return Row(
      children: [
        Expanded(
          // No TextEditingController: filters have no dispose hook, so the
          // field owns its own text and the signal only mirrors it.
          child: TextFormField(
            initialValue: value.value,
            onChanged: (v) => value.value = v,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.:]')),
            ],
            decoration: InputDecoration(
              labelText: label,
              hintText: "minutes, or m:ss",
              prefixIcon: Icon(icon),
              border: const OutlineInputBorder(),
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
  late final ReadonlySignal<dynamic> stateChange = computed(
    () => (operator.value, value.value, baseStateChange.value),
  );

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
    final currentOperator = operator.value;
    return Row(
      children: [
        Expanded(
          child: Tooltip(
            message: label,
            child: TextFormField(
              initialValue: value.value,
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

  /// The relative window to compare against, or null when [value] holds a
  /// fixed date. The two are mutually exclusive — see [selectPeriod] and
  /// [selectDate].
  final Signal<DateFilterPeriod?> period = signal(null);

  @override
  late final ReadonlySignal<dynamic> stateChange = computed(
    () => (operator.value, value.value, period.value, baseStateChange.value),
  );

  DateFilter({
    required super.label,
    required super.icon,
    required super.category,
    required super.sortOrder,
    required super.retriever,
  });

  /// The date this filter currently compares against, with a relative window
  /// resolved against today.
  DateTime? get comparisonDate =>
      period.value?.startFrom(DateTime.now()) ?? value.value;

  void selectPeriod(DateFilterPeriod selected) {
    period.value = selected;
    value.value = null;
    // "On" would pin a multi-day window to its first day, which is never what
    // picking a window means.
    if (operator.value == FilterOperator.equals) {
      operator.value = FilterOperator.greaterEqual;
    }
  }

  void selectDate(DateTime date) {
    value.value = date;
    period.value = null;
  }

  @override
  bool performMatch(DateTime value) {
    final filterValue = comparisonDate;
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

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: comparisonDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) selectDate(picked);
  }

  static String _formatDate(DateTime d) =>
      "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

  @override
  Widget filterRowWidget(BuildContext context) {
    final currentOperator = operator.value;
    final currentValue = value.value;
    final currentPeriod = period.value;
    final resolved = comparisonDate;
    return Row(
      children: [
        // Reads the signals directly instead of mirroring into a
        // TextEditingController (the filter has no dispose hook, so a
        // controller here would leak).
        Expanded(
          child: PopupMenuButton<Object>(
            tooltip: currentPeriod == null
                ? 'Pick the date to compare against'
                : '${currentPeriod.label} — since ${_formatDate(resolved!)}',
            onSelected: (choice) => choice is DateFilterPeriod
                ? selectPeriod(choice)
                : _pickDate(context),
            itemBuilder: (context) => [
              for (final option in DateFilterPeriod.values)
                CheckedPopupMenuItem<Object>(
                  value: option,
                  checked: currentPeriod == option,
                  child: Text(option.label),
                ),
              const PopupMenuDivider(),
              CheckedPopupMenuItem<Object>(
                value: _CustomDateChoice.pick,
                checked: currentValue != null,
                child: const Text('Pick a date…'),
              ),
            ],
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: label,
                prefixIcon: Icon(icon),
                suffixIcon: const Icon(Icons.arrow_drop_down),
                border: const OutlineInputBorder(),
              ),
              child: Text(
                currentPeriod?.label ??
                    (currentValue != null ? _formatDate(currentValue) : ""),
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        _operatorMenu<FilterOperator>(
          // A window spans several days, so "on" drops out while one is
          // selected — [selectPeriod] keeps the current operator off it too.
          values: currentPeriod == null
              ? FilterOperator.values
              : FilterOperator.values
                    .where((op) => op != FilterOperator.equals)
                    .toList(),
          current: currentOperator,
          labelOf: _dateOperatorLabel,
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
  late final ReadonlySignal<dynamic> stateChange = computed(
    () => (selectedValue.value, baseStateChange.value),
  );

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
      initialSelection: selectedValue.value,
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
  late final ReadonlySignal<dynamic> stateChange = computed(
    () => (selectedCategoryId.value, baseStateChange.value),
  );

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
    final currentSelected = selectedCategoryId.value;

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
    final authors = selectedAuthors.value;
    final tags = selectedTags.value;
    final performers = selectedPerformers.value;

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
    replaceGroups([FilterGroup(FilterGroupOperator.and, [])]);
  }

  void replaceGroups(List<FilterGroup> groups) {
    filterGroups.value = groups;
  }
}

class PlaylistFilter extends FilterBase<String> {
  @override
  late final ReadonlySignal<dynamic> stateChange = computed(
    () => (baseStateChange.value),
  );

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
  late final ReadonlySignal<dynamic> stateChange = computed(
    () => (baseStateChange.value),
  );

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
