import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncopathy/media_library/filter/media_filter.dart';
import 'package:syncopathy/media_library/funscript_metadata_filter_bottom_sheet.dart';
import 'package:syncopathy/model/json/funscript_metadata.dart';
import 'package:syncopathy/persistence/entities/funscript_file.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';

/// [MetadataFilter] keeps its selections in `Signal<Set<String>>` fields whose
/// mutating helpers edit the set in place. Its `stateChange` — the signal the
/// media grid watches to know it must re-filter — has to reflect those edits.
void main() {
  /// The registry entry rather than a hand-rolled instance, so the retriever
  /// under test is the one the app actually runs.
  MetadataFilter buildFilter() =>
      availableFilters['Metadata']!() as MetadataFilter;

  test('stateChange fires when a selection is toggled', () {
    final filter = buildFilter();
    var notifications = 0;
    final dispose = effect(() {
      filter.stateChange.value;
      notifications++;
    });
    addTearDown(dispose);

    expect(notifications, 1);

    filter.selectedAuthors.add('author');
    expect(notifications, 2, reason: 'adding an author must re-trigger');

    filter.selectedTags.add('tag');
    expect(notifications, 3, reason: 'adding a tag must re-trigger');

    filter.selectedPerformers.add('performer');
    expect(notifications, 4, reason: 'adding a performer must re-trigger');

    filter.selectedAuthors.remove('author');
    expect(notifications, 5, reason: 'removing an author must re-trigger');

    filter.selectedTags.clear();
    expect(notifications, 6, reason: 'clearing tags must re-trigger');
  });

  test('stateChange propagates through the enclosing MediaFilter', () {
    final filter = buildFilter();
    final mediaFilter = MediaFilter()
      ..replaceGroups([
        FilterGroup(FilterGroupOperator.and, [filter]),
      ]);

    var notifications = 0;
    final dispose = effect(() {
      mediaFilter.stateChange.value;
      notifications++;
    });
    addTearDown(dispose);

    expect(notifications, 1);
    filter.selectedTags.add('tag');
    expect(notifications, 2);
  });

  testWidgets('toggling a row in the sheet reaches the filter', (tester) async {
    final filter = buildFilter();
    var notifications = 0;
    final dispose = effect(() {
      filter.stateChange.value;
      notifications++;
    });
    addTearDown(dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FunscriptMetadataFilterBottomSheet(
            allAuthors: const ['alpha', 'beta'],
            allTags: const ['tag'],
            allPerformers: const ['performer'],
            selectedAuthors: filter.selectedAuthors,
            selectedTags: filter.selectedTags,
            selectedPerformers: filter.selectedPerformers,
          ),
        ),
      ),
    );

    tester.widget<ListTile>(find.widgetWithText(ListTile, 'alpha')).onTap!();
    await tester.pumpAndSettle();

    expect(filter.selectedAuthors.peek(), {'alpha'});
    expect(
      notifications,
      2,
      reason: 'the media grid must be told to re-filter',
    );
    expect(
      tester.widget<ListTile>(find.widgetWithText(ListTile, 'alpha')).trailing,
      isNotNull,
      reason: 'the sheet must show the row as selected',
    );
    expect(
      find.descendant(of: find.byType(Badge), matching: find.text('1')),
      findsOneWidget,
      reason: 'the Author tab must show the selection count',
    );
  });

  MediaFile mediaWith({
    String? creator,
    List<String> tags = const [],
    List<String> performers = const [],
    bool withMetadata = true,
  }) {
    final media = MediaFile(
      name: 'clip',
      mediaPath: '/library/clip.mp4',
      fileHash: 'clip',
      playCount: 0,
      fileNotFound: false,
      type: MediaType.video,
    );
    media.mainFunscript.target = FunscriptFile(
      path: 'clip.funscript',
      averageSpeed: 0,
      averageMin: 0,
      averageMax: 0,
      isScriptToken: false,
      fileNotFound: false,
      funscriptHash: 'clip',
      metadata: withMetadata
          ? FunscriptMetadata(
              creator: creator,
              tags: tags,
              performers: performers,
            )
          : null,
    );
    return media;
  }

  group('field matching', () {
    test('an empty selection matches everything', () {
      final filter = buildFilter();
      expect(filter.matches(mediaWith(creator: 'anna')), isTrue);
      expect(filter.matches(mediaWith()), isTrue);
    });

    test('selections in different tabs must all match', () {
      final filter = buildFilter()
        ..selectedAuthors.value = {'anna'}
        ..selectedTags.value = {'cowgirl'};

      expect(
        filter.matches(mediaWith(creator: 'anna', tags: ['cowgirl'])),
        isTrue,
      );
      expect(
        filter.matches(mediaWith(creator: 'anna', tags: ['solo'])),
        isFalse,
        reason: 'the tag constraint is not satisfied',
      );
      expect(
        filter.matches(mediaWith(creator: 'bob', tags: ['cowgirl'])),
        isFalse,
        reason: 'the author constraint is not satisfied',
      );
    });

    test('selections within one tab widen the match', () {
      final filter = buildFilter()..selectedAuthors.value = {'anna', 'bob'};

      expect(filter.matches(mediaWith(creator: 'anna')), isTrue);
      expect(filter.matches(mediaWith(creator: 'bob')), isTrue);
      expect(filter.matches(mediaWith(creator: 'carol')), isFalse);
    });

    test('a selection only matches its own field', () {
      final filter = buildFilter()..selectedAuthors.value = {'cowgirl'};

      expect(
        filter.matches(mediaWith(tags: ['cowgirl'])),
        isFalse,
        reason: 'an author selection must not match a tag of the same name',
      );
    });

    test('performers are matched on their own field', () {
      final filter = buildFilter()..selectedPerformers.value = {'dana'};

      expect(filter.matches(mediaWith(performers: ['dana'])), isTrue);
      expect(filter.matches(mediaWith(performers: ['eve'])), isFalse);
    });

    test('media without funscript metadata never matches', () {
      final filter = buildFilter();
      expect(filter.matches(mediaWith(withMetadata: false)), isFalse);
    });

    test('negation inverts the whole match', () {
      final filter = buildFilter()
        ..selectedTags.value = {'cowgirl'}
        ..negated.value = true;

      expect(filter.matches(mediaWith(tags: ['cowgirl'])), isFalse);
      expect(filter.matches(mediaWith(tags: ['solo'])), isTrue);
    });
  });
}
