import 'package:syncopathy/media_library/filter/media_filter.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';

const _filterLabelsById = <String, String>{
  'title': 'Title',
  'type': 'Type',
  'category': 'Category',
  'rating': 'Rating',
  'duration': 'Duration',
  'dateAdded': 'Date Added',
  'path': 'Path',
  'funscriptCount': 'Funscript Count',
  'averageSpeed': 'Average Speed',
  'metadata': 'Metadata',
  'scriptTokens': 'Script Tokens',
  'playCount': 'Play Count',
  'playlist': 'Playlist',
  'playable': 'Playable',
  'missingFiles': 'Missing Files',
};

/// Persistence id for each entry in [availableFilters], keyed by filter label.
/// Every available filter needs one — see `media_filter_preset_test.dart`.
final filterPersistenceIdsByLabel = {
  for (final entry in _filterLabelsById.entries) entry.value: entry.key,
};

class MediaFilterSnapshot {
  final List<MediaFilterGroupSnapshot> groups;

  const MediaFilterSnapshot(this.groups);

  factory MediaFilterSnapshot.capture(MediaFilter filter) =>
      MediaFilterSnapshot(
        filter.filterGroups
            .map(
              (group) => MediaFilterGroupSnapshot(
                group.operator.value.name,
                group.filters.map(MediaFilterEntrySnapshot.capture).toList(),
              ),
            )
            .toList(),
      );

  factory MediaFilterSnapshot.fromJson(Map<String, dynamic> json) {
    final rawGroups = json['groups'];
    if (rawGroups is! List) return const MediaFilterSnapshot([]);
    return MediaFilterSnapshot(
      rawGroups
          .whereType<Map>()
          .map((group) => MediaFilterGroupSnapshot.fromJson(group.cast()))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'groups': groups.map((group) => group.toJson()).toList(),
  };

  void applyTo(MediaFilter target) {
    final restored = groups.map((group) => group.restore()).toList();
    target.replaceGroups(
      restored.isEmpty ? [FilterGroup(FilterGroupOperator.and, [])] : restored,
    );
  }
}

class MediaFilterGroupSnapshot {
  final String operator;
  final List<MediaFilterEntrySnapshot> filters;

  const MediaFilterGroupSnapshot(this.operator, this.filters);

  factory MediaFilterGroupSnapshot.fromJson(Map<String, dynamic> json) {
    final rawFilters = json['filters'];
    return MediaFilterGroupSnapshot(
      json['operator'] is String ? json['operator'] as String : 'and',
      rawFilters is List
          ? rawFilters
                .whereType<Map>()
                .map(
                  (filter) => MediaFilterEntrySnapshot.fromJson(filter.cast()),
                )
                .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() => {
    'operator': operator,
    'filters': filters.map((filter) => filter.toJson()).toList(),
  };

  FilterGroup restore() {
    final groupOperator = FilterGroupOperator.values
        .where((value) => value.name == operator)
        .firstOrNull;
    return FilterGroup(
      groupOperator ?? FilterGroupOperator.and,
      filters
          .map((filter) => filter.restore())
          .whereType<FilterBase>()
          .toList(),
    );
  }
}

class MediaFilterEntrySnapshot {
  final String type;
  final bool enabled;
  final bool negated;
  final Map<String, dynamic> value;

  const MediaFilterEntrySnapshot({
    required this.type,
    required this.enabled,
    required this.negated,
    required this.value,
  });

  factory MediaFilterEntrySnapshot.capture(FilterBase filter) {
    final type = filterPersistenceIdsByLabel[filter.label];
    if (type == null) {
      throw StateError('Filter ${filter.label} has no persistence id');
    }
    return MediaFilterEntrySnapshot(
      type: type,
      enabled: filter.enabled.value,
      negated: filter.negated.value,
      value: switch (filter) {
        DurationFilter f => {
          'operator': f.operator.value.name,
          'value': f.value.value,
        },
        NumberFilter f => {
          'operator': f.operator.value.name,
          'value': f.value.value,
        },
        StringFilter f => {
          'operator': f.operator.value.name,
          'value': f.value.value,
        },
        DateFilter f => {
          'operator': f.operator.value.name,
          'value': f.value.value?.toIso8601String(),
          // Stored by name, never as a resolved date, so the preset keeps
          // meaning "this month" instead of the month it was saved in. Omitted
          // when unset so presets saved before relative windows existed still
          // capture identically and do not read as modified.
          if (f.period.value != null) 'period': f.period.value!.name,
        },
        EnumFilter f => {'value': f.selectedValue.value?.name},
        CategoryFilter f => {'value': f.selectedCategoryId.value},
        // Sorted so that reselecting the same values in a different order does
        // not make an unchanged preset compare as modified.
        MetadataFilter f => {
          'authors': _sorted(f.selectedAuthors.value),
          'tags': _sorted(f.selectedTags.value),
          'performers': _sorted(f.selectedPerformers.value),
        },
        _ => const {},
      },
    );
  }

  factory MediaFilterEntrySnapshot.fromJson(Map<String, dynamic> json) =>
      MediaFilterEntrySnapshot(
        type: json['type'] is String ? json['type'] as String : '',
        enabled: json['enabled'] is bool ? json['enabled'] as bool : true,
        negated: json['negated'] is bool ? json['negated'] as bool : false,
        value: json['value'] is Map
            ? (json['value'] as Map).cast<String, dynamic>()
            : const {},
      );

  Map<String, dynamic> toJson() => {
    'type': type,
    'enabled': enabled,
    'negated': negated,
    'value': value,
  };

  FilterBase? restore() {
    final label = _filterLabelsById[type];
    final filter = label == null ? null : availableFilters[label]?.call();
    if (filter == null) return null;
    filter.enabled.value = enabled;
    filter.negated.value = negated;

    final operatorName = value['operator'];
    if (filter is DurationFilter ||
        filter is NumberFilter ||
        filter is DateFilter) {
      final operator = FilterOperator.values
          .where((item) => item.name == operatorName)
          .firstOrNull;
      if (filter is DurationFilter) {
        if (operator != null) filter.operator.value = operator;
        filter.value.value = value['value'] is String
            ? value['value'] as String
            : '';
      } else if (filter is NumberFilter) {
        if (operator != null) filter.operator.value = operator;
        filter.value.value = value['value'] is String
            ? value['value'] as String
            : '';
      } else if (filter is DateFilter) {
        if (operator != null) filter.operator.value = operator;
        final period = _enumByName(DateFilterPeriod.values, value['period']);
        if (period != null) {
          filter.period.value = period;
        } else {
          filter.value.value = value['value'] is String
              ? DateTime.tryParse(value['value'] as String)
              : null;
        }
      }
    } else if (filter is StringFilter) {
      final operator = StringFilterOperator.values
          .where((item) => item.name == operatorName)
          .firstOrNull;
      if (operator != null) filter.operator.value = operator;
      filter.value.value = value['value'] is String
          ? value['value'] as String
          : '';
    } else if (filter is EnumFilter<MediaType>) {
      filter.selectedValue.value = _enumByName(
        filter.enumValues,
        value['value'],
      );
    } else if (filter is EnumFilter<MediaRating>) {
      filter.selectedValue.value = _enumByName(
        filter.enumValues,
        value['value'],
      );
    } else if (filter is CategoryFilter) {
      final categoryId = (value['value'] as num?)?.toInt();
      // The category may have been deleted since the preset was saved. Dropping
      // the stale id keeps the dropdown and the actual filtering in agreement —
      // otherwise the menu shows nothing selected while filtering on a dead id.
      final known =
          categoryId == kUncategorizedCategoryId ||
          filter.categories.any((category) => category.id == categoryId);
      filter.selectedCategoryId.value = known ? categoryId : null;
    } else if (filter is MetadataFilter) {
      filter.selectedAuthors.value = _stringSet(value['authors']);
      filter.selectedTags.value = _stringSet(value['tags']);
      filter.selectedPerformers.value = _stringSet(value['performers']);
    }
    return filter;
  }
}

E? _enumByName<E extends Enum>(List<E> values, Object? name) =>
    values.where((value) => value.name == name).firstOrNull;

List<String> _sorted(Set<String> values) => values.toList()..sort();

Set<String> _stringSet(Object? values) =>
    values is List ? values.whereType<String>().toSet() : <String>{};
