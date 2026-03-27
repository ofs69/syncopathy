import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';

final Map<String, FilterBase Function()> availableFilters = {
  "Media Title": () => StringFilter(
    label: "Media Title",
    retriever: (media) => [media.name, ...media.aliases],
  ),
  "Media Path": () => StringFilter(
    label: "Media Path",
    retriever: (media) => [media.mediaPath],
  ),
  "Play Count": () => NumberFilter(
    label: "Play Count",
    retriever: (media) => [media.playCount],
  ),
  "Media Type": () => EnumFilter<MediaType>(
    label: "Media Type",
    retriever: (media) => [(media.type ?? MediaType.unknown).id],
    enumValues: MediaType.values,
  ),
  "Media Rating": () => EnumFilter<MediaRating>(
    label: "Media Rating",
    retriever: (media) => [(media.rating ?? MediaRating.noRating).id],
    enumValues: MediaRating.values,
  ),
  "Media Creation Date": () => DateFilter(
    label: "Media Creation Date",
    retriever: (media) => [?media.metadata.target?.creationTime],
  ),
};

abstract class FilterBase<T> {
  final String label;
  bool negated;
  bool enabled;
  List<T> Function(MediaFile) retriever;
  bool Function(MediaFile, T) matcher;

  FilterBase({
    required this.label,
    required this.retriever,
    required this.matcher,
    this.negated = false,
    this.enabled = true,
  });

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
  FilterOperator operator;
  NumberFilter({
    required super.label,
    required super.retriever,
    this.operator = FilterOperator.equals,
  }) : super(matcher: _matcher);

  static bool _matcher(MediaFile mediaFile, num number) {
    return false;
  }

  @override
  Widget filterRowWidget(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              labelText: label,
              hintText: label,
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 4),
        PopupMenuButton<FilterOperator>(
          icon: const Icon(Icons.filter_list),
          tooltip: operator.label,
          onSelected: (op) {
            operator = op;
          },
          itemBuilder: (context) => FilterOperator.values
              .map(
                (op) => CheckedPopupMenuItem<FilterOperator>(
                  value: op,
                  checked: operator == op,
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
  StringFilterOperator operator;
  StringFilter({
    required super.label,
    required super.retriever,
    this.operator = StringFilterOperator.stringContains,
  }) : super(matcher: _matcher);

  static bool _matcher(MediaFile mediaFile, String string) {
    return false;
  }

  @override
  Widget filterRowWidget(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Tooltip(
            message: label,
            child: TextField(
              decoration: InputDecoration(
                labelText: label,
                hintText: label,
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        PopupMenuButton<StringFilterOperator>(
          icon: const Icon(Icons.filter_list),
          tooltip: operator.label,
          onSelected: (op) {
            operator = op;
          },
          itemBuilder: (context) => StringFilterOperator.values
              .map(
                (op) => CheckedPopupMenuItem<StringFilterOperator>(
                  value: op,
                  checked: operator == op,
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
  FilterOperator operator;
  DateTime? value;

  DateFilter({
    required super.label,
    required super.retriever,
    this.operator = FilterOperator.equals,
  }) : super(matcher: _matcher);

  static bool _matcher(MediaFile mediaFile, DateTime date) {
    return false;
  }

  final TextEditingController _dateController = TextEditingController();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    value = picked;
    _dateController.text = picked != null
        ? "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}"
        : "";
  }

  @override
  Widget filterRowWidget(BuildContext context) {
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
              suffixIcon: const Icon(Icons.calendar_today, size: 18),
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 4),
        PopupMenuButton<FilterOperator>(
          icon: const Icon(Icons.filter_list),
          tooltip: operator.label,
          onSelected: (op) {
            operator = op;
          },
          itemBuilder: (context) => FilterOperator.values
              .map(
                (op) => CheckedPopupMenuItem<FilterOperator>(
                  value: op,
                  checked: operator == op,
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
  E? selectedValue;

  EnumFilter({
    required super.label,
    required super.retriever,
    required this.enumValues,
  }) : super(matcher: _matcher);

  static bool _matcher(MediaFile mediaFile, int enumValue) {
    return false;
  }

  @override
  Widget filterRowWidget(BuildContext context) {
    return DropdownMenu<E>(
      expandedInsets: EdgeInsets.zero,
      label: Text(label),
      dropdownMenuEntries: enumValues
          .map((s) => DropdownMenuEntry<E>(value: s, label: s.name))
          .toList(),
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
  FilterGroup(FilterGroupOperator operator, List<FilterBase> filters)
    : operator = signal(operator),
      filters = listSignal(filters);
}

class MediaFilter {
  final ListSignal<FilterGroup> filterGroups = listSignal([
    FilterGroup(FilterGroupOperator.and, []),
  ]);
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
