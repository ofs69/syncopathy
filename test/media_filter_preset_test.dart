import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:syncopathy/media_library/filter/media_filter.dart';
import 'package:syncopathy/media_library/filter/media_filter_preset.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';

void main() {
  group('media filter presets', () {
    test('round trips groups and filter-specific state', () {
      final title = availableFilters['Title']!() as StringFilter;
      title.operator.value = StringFilterOperator.stringStartsWith;
      title.value.value = 'Holiday';
      title.negated.value = true;

      final duration = availableFilters['Duration']!() as DurationFilter;
      duration.operator.value = FilterOperator.lesserEqual;
      duration.value.value = '45:30';
      duration.enabled.value = false;

      final original = MediaFilter()
        ..replaceGroups([
          FilterGroup(FilterGroupOperator.or, [title, duration]),
          FilterGroup(FilterGroupOperator.and, [
            availableFilters['Playable']!(),
          ]),
        ]);

      final json = MediaFilterSnapshot.capture(original).toJson();
      final restored = MediaFilter();
      MediaFilterSnapshot.fromJson(json).applyTo(restored);

      expect(restored.filterGroups, hasLength(2));
      expect(
        restored.filterGroups.first.operator.value,
        FilterGroupOperator.or,
      );
      final restoredTitle =
          restored.filterGroups.first.filters[0] as StringFilter;
      expect(
        restoredTitle.operator.value,
        StringFilterOperator.stringStartsWith,
      );
      expect(restoredTitle.value.value, 'Holiday');
      expect(restoredTitle.negated.value, isTrue);
      final restoredDuration =
          restored.filterGroups.first.filters[1] as DurationFilter;
      expect(restoredDuration.operator.value, FilterOperator.lesserEqual);
      expect(restoredDuration.value.value, '45:30');
      expect(restoredDuration.enabled.value, isFalse);
    });

    test('round trips enum values by stable name', () {
      final type = availableFilters['Type']!() as EnumFilter<MediaType>;
      type.selectedValue.value = MediaType.video;

      final original = MediaFilter()
        ..replaceGroups([
          FilterGroup(FilterGroupOperator.and, [type]),
        ]);
      final restored = MediaFilter();
      MediaFilterSnapshot.fromJson(
        MediaFilterSnapshot.capture(original).toJson(),
      ).applyTo(restored);

      final restoredType =
          restored.defaultGroup.filters.single as EnumFilter<MediaType>;
      expect(restoredType.selectedValue.value, MediaType.video);
    });

    test('drops unknown filters while preserving valid ones', () {
      final snapshot = MediaFilterSnapshot.fromJson({
        'groups': [
          {
            'operator': 'and',
            'filters': [
              {
                'type': 'removedInAFutureVersion',
                'enabled': true,
                'negated': false,
                'value': <String, dynamic>{},
              },
              {
                'type': 'title',
                'enabled': true,
                'negated': false,
                'value': {'operator': 'stringContains', 'value': 'keep me'},
              },
            ],
          },
        ],
      });
      final restored = MediaFilter();
      snapshot.applyTo(restored);

      expect(restored.defaultGroup.filters, hasLength(1));
      expect(
        (restored.defaultGroup.filters.single as StringFilter).value.value,
        'keep me',
      );
    });

    test('every available filter has a persistence id', () {
      // Guards against adding a filter to availableFilters without a
      // persistence id: MediaFilterSnapshot.capture throws on an unmapped
      // label, and it runs from the dirty-state computed on every filter edit.
      expect(
        availableFilters.keys.toSet().difference(
          filterPersistenceIdsByLabel.keys.toSet(),
        ),
        isEmpty,
        reason: 'filters without a persistence id cannot be saved',
      );
      expect(
        filterPersistenceIdsByLabel.keys.toSet().difference(
          availableFilters.keys.toSet(),
        ),
        isEmpty,
        reason: 'persistence ids referencing filters that no longer exist',
      );
    });

    test('a freshly loaded preset does not read as modified', () {
      // Category is omitted: its constructor reads user categories from the DB.
      final original = MediaFilter()
        ..replaceGroups([
          FilterGroup(FilterGroupOperator.or, [
            availableFilters['Title']!() as StringFilter
              ..operator.value = StringFilterOperator.stringEndsWith
              ..value.value = 'part 2',
            availableFilters['Play Count']!() as NumberFilter
              ..operator.value = FilterOperator.greater
              ..value.value = '3',
            availableFilters['Duration']!() as DurationFilter
              ..operator.value = FilterOperator.lesser
              ..value.value = '10:00',
            availableFilters['Date Added']!() as DateFilter
              ..operator.value = FilterOperator.greater
              ..value.value = DateTime(2024, 5, 6, 7, 8, 9),
            availableFilters['Type']!() as EnumFilter<MediaType>
              ..selectedValue.value = MediaType.video,
          ]),
          FilterGroup(FilterGroupOperator.and, [
            availableFilters['Rating']!() as EnumFilter<MediaRating>
              ..selectedValue.value = MediaRating.like,
            availableFilters['Metadata']!() as MetadataFilter
              ..selectedAuthors.value = {'b', 'a'}
              ..selectedTags.value = {'z'}
              ..selectedPerformers.value = {'p'},
            availableFilters['Playable']!()..negated.value = true,
            availableFilters['Playlist']!(),
          ]),
        ]);

      final saved = MediaFilterSnapshot.fromJson(
        jsonDecode(jsonEncode(MediaFilterSnapshot.capture(original).toJson()))
            as Map<String, dynamic>,
      );
      final target = MediaFilter();
      saved.applyTo(target);

      expect(
        jsonEncode(MediaFilterSnapshot.capture(target).toJson()),
        jsonEncode(saved.toJson()),
      );
    });

    test('metadata selections compare equal regardless of order', () {
      MediaFilter withAuthors(Set<String> authors) => MediaFilter()
        ..replaceGroups([
          FilterGroup(FilterGroupOperator.and, [
            availableFilters['Metadata']!() as MetadataFilter
              ..selectedAuthors.value = authors,
          ]),
        ]);

      expect(
        jsonEncode(
          MediaFilterSnapshot.capture(withAuthors({'a', 'b'})).toJson(),
        ),
        jsonEncode(
          MediaFilterSnapshot.capture(withAuthors({'b', 'a'})).toJson(),
        ),
      );
    });

    test('invalid operators and values fall back safely', () {
      final snapshot = MediaFilterSnapshot.fromJson({
        'groups': [
          {
            'operator': 'unknown',
            'filters': [
              {
                'type': 'duration',
                'enabled': 'invalid',
                'negated': null,
                'value': {'operator': 'unknown', 'value': 42},
              },
            ],
          },
        ],
      });
      final restored = MediaFilter();
      snapshot.applyTo(restored);

      expect(restored.defaultGroup.operator.value, FilterGroupOperator.and);
      final duration = restored.defaultGroup.filters.single as DurationFilter;
      expect(duration.operator.value, FilterOperator.greaterEqual);
      expect(duration.value.value, isEmpty);
      expect(duration.enabled.value, isTrue);
      expect(duration.negated.value, isFalse);
    });
  });
}
