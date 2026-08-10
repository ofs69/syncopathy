import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:syncopathy/media_library/filter/media_filter.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';
import 'package:syncopathy/persistence/entities/media_metadata.dart';

/// Covers [DurationFilter]'s minute-first input parsing and its matching
/// against media duration, which is stored in seconds.
void main() {
  DurationFilter filterFor(String input, FilterOperator operator) {
    final f = DurationFilter(
      label: 'Duration',
      icon: Icons.timer,
      category: FilterCategory.media,
      sortOrder: 0,
      retriever: (m) => [m.metadata.target?.duration],
    );
    f.value.value = input;
    f.operator.value = operator;
    return f;
  }

  MediaFile mediaOfSeconds(double? seconds) {
    final m = MediaFile(
      name: 'clip',
      mediaPath: '/library/clip.mp4',
      fileHash: 'clip',
      playCount: 0,
      fileNotFound: false,
      rating: MediaRating.noRating,
      type: MediaType.video,
    );
    if (seconds != null) {
      m.metadata.target = MediaMetadata(duration: seconds);
    }
    return m;
  }

  group('parseInput', () {
    test('reads a bare number as minutes', () {
      expect(DurationFilter.parseInput('90')?.seconds, 5400);
      expect(DurationFilter.parseInput('1.5')?.seconds, 90);
    });

    test('reads colon notation right-to-left from seconds', () {
      expect(DurationFilter.parseInput('5:30')?.seconds, 330);
      expect(DurationFilter.parseInput('1:05:30')?.seconds, 3930);
    });

    test('tolerance follows the precision of the input', () {
      // A bare minute count matches to the half-minute, colon notation to the
      // half-second.
      expect(DurationFilter.parseInput('90')?.tolerance, 30);
      expect(DurationFilter.parseInput('5:30')?.tolerance, 0.5);
    });

    test('tolerates surrounding and inner whitespace', () {
      expect(DurationFilter.parseInput('  90  ')?.seconds, 5400);
      expect(DurationFilter.parseInput(' 5 : 30 ')?.seconds, 330);
    });

    test('rejects unparseable, negative and over-long inputs', () {
      expect(DurationFilter.parseInput(''), isNull);
      expect(DurationFilter.parseInput('   '), isNull);
      expect(DurationFilter.parseInput(':30'), isNull);
      expect(DurationFilter.parseInput('5:'), isNull);
      expect(DurationFilter.parseInput('-5'), isNull);
      expect(DurationFilter.parseInput('1:2:3:4'), isNull);
    });
  });

  group('formatSeconds', () {
    test('omits the hour component below an hour', () {
      expect(DurationFilter.formatSeconds(330), '5:30');
      expect(DurationFilter.formatSeconds(9), '0:09');
    });

    test('includes and zero-pads the hour component above an hour', () {
      expect(DurationFilter.formatSeconds(3930), '1:05:30');
    });
  });

  group('matching', () {
    test('an empty input constrains nothing', () {
      final f = filterFor('', FilterOperator.greaterEqual);
      expect(f.matches(mediaOfSeconds(1)), isTrue);
      expect(f.matches(mediaOfSeconds(100000)), isTrue);
    });

    test('greaterEqual keeps media at or above the target', () {
      final f = filterFor('10', FilterOperator.greaterEqual);
      expect(f.matches(mediaOfSeconds(599)), isFalse);
      expect(f.matches(mediaOfSeconds(600)), isTrue);
      expect(f.matches(mediaOfSeconds(601)), isTrue);
    });

    test('lesser keeps media strictly below the target', () {
      final f = filterFor('10', FilterOperator.lesser);
      expect(f.matches(mediaOfSeconds(599)), isTrue);
      expect(f.matches(mediaOfSeconds(600)), isFalse);
    });

    test('equals on bare minutes matches within half a minute', () {
      final f = filterFor('10', FilterOperator.equals);
      expect(f.matches(mediaOfSeconds(600)), isTrue);
      expect(f.matches(mediaOfSeconds(629)), isTrue);
      expect(f.matches(mediaOfSeconds(571)), isTrue);
      expect(f.matches(mediaOfSeconds(631)), isFalse);
    });

    test('equals on colon notation matches within half a second', () {
      final f = filterFor('10:00', FilterOperator.equals);
      expect(f.matches(mediaOfSeconds(600)), isTrue);
      expect(f.matches(mediaOfSeconds(602)), isFalse);
    });

    test('negation inverts the result', () {
      final f = filterFor('10', FilterOperator.greaterEqual);
      f.negated.value = true;
      expect(f.matches(mediaOfSeconds(600)), isFalse);
      expect(f.matches(mediaOfSeconds(599)), isTrue);
    });

    test('a disabled filter constrains nothing', () {
      final f = filterFor('10', FilterOperator.greaterEqual);
      f.enabled.value = false;
      expect(f.matches(mediaOfSeconds(1)), isTrue);
    });

    test('media with no metadata does not match', () {
      final f = filterFor('10', FilterOperator.lesser);
      expect(f.matches(mediaOfSeconds(null)), isFalse);
    });
  });

  group('filter row widget', () {
    testWidgets('echoes back how the typed input was read', (tester) async {
      final f = filterFor('', FilterOperator.greaterEqual);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(builder: (context) => f.filterRowWidget(context)),
          ),
        ),
      );

      expect(find.text('e.g. 90, 5:30, 1:05:30'), findsOneWidget);

      await tester.enterText(find.byType(TextField), '90');
      await tester.pump();

      expect(f.value.value, '90');
      expect(find.text('1:30:00'), findsOneWidget);
    });
  });
}
