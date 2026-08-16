import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:syncopathy/media_library/filter/media_filter.dart';

/// Covers [DateFilter]'s relative windows: where each one starts, and how a
/// window behaves once the operator is applied to it.
void main() {
  DateFilter dateFilter() => DateFilter(
    label: 'Date Added',
    icon: Icons.calendar_today,
    category: FilterCategory.media,
    sortOrder: 0,
    retriever: (m) => [m.firstIndexedOn],
  );

  group('DateFilterPeriod.startFrom', () {
    final now = DateTime(2026, 3, 12, 22, 30); // a Thursday

    test('today starts at midnight', () {
      expect(
        DateFilterPeriod.today.startFrom(now),
        DateTime(2026, 3, 12),
      );
    });

    test('this week starts on Monday', () {
      expect(
        DateFilterPeriod.thisWeek.startFrom(now),
        DateTime(2026, 3, 9),
      );
    });

    test('a Monday is already the start of its week', () {
      expect(
        DateFilterPeriod.thisWeek.startFrom(DateTime(2026, 3, 9, 6)),
        DateTime(2026, 3, 9),
      );
    });

    test('this month and this year start at their first day', () {
      expect(DateFilterPeriod.thisMonth.startFrom(now), DateTime(2026, 3));
      expect(DateFilterPeriod.thisYear.startFrom(now), DateTime(2026));
    });

    test('rolling windows include today as their last day', () {
      expect(
        DateFilterPeriod.last7Days.startFrom(now),
        DateTime(2026, 3, 6),
      );
      expect(
        DateFilterPeriod.last30Days.startFrom(now),
        DateTime(2026, 2, 11),
      );
      expect(
        DateFilterPeriod.last90Days.startFrom(now),
        DateTime(2025, 12, 13),
      );
    });

    test('rolling windows cross a year boundary by calendar days', () {
      expect(
        DateFilterPeriod.last7Days.startFrom(DateTime(2026, 1, 3)),
        DateTime(2025, 12, 28),
      );
    });
  });

  group('matching', () {
    test('an unset filter matches everything', () {
      final filter = dateFilter();
      expect(filter.performMatch(DateTime(1999)), isTrue);
    });

    test('a window matches from its first day onwards', () {
      final filter = dateFilter()..selectPeriod(DateFilterPeriod.thisYear);
      final now = DateTime.now();

      expect(filter.performMatch(DateTime(now.year)), isTrue);
      expect(filter.performMatch(now), isTrue);
      expect(filter.performMatch(DateTime(now.year - 1, 12, 31)), isFalse);
    });

    test('"before" a window matches everything older than it', () {
      final filter = dateFilter()
        ..selectPeriod(DateFilterPeriod.thisYear)
        ..operator.value = FilterOperator.lesser;
      final now = DateTime.now();

      expect(filter.performMatch(DateTime(now.year - 1, 12, 31)), isTrue);
      expect(filter.performMatch(DateTime(now.year)), isFalse);
    });
  });

  group('mutual exclusion', () {
    test('picking a window clears a fixed date and drops the "on" operator', () {
      final filter = dateFilter()..selectDate(DateTime(2024, 5, 6));
      expect(filter.operator.value, FilterOperator.equals);

      filter.selectPeriod(DateFilterPeriod.thisMonth);

      expect(filter.value.value, isNull);
      expect(filter.operator.value, FilterOperator.greaterEqual);
    });

    test('picking a window keeps an operator that already fits', () {
      final filter = dateFilter()..operator.value = FilterOperator.lesser;
      filter.selectPeriod(DateFilterPeriod.thisMonth);
      expect(filter.operator.value, FilterOperator.lesser);
    });

    test('picking a date clears the window', () {
      final filter = dateFilter()..selectPeriod(DateFilterPeriod.thisWeek);
      filter.selectDate(DateTime(2024, 5, 6));

      expect(filter.period.value, isNull);
      expect(filter.comparisonDate, DateTime(2024, 5, 6));
    });
  });
}
