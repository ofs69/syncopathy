import 'package:flutter/material.dart' show Icons;
import 'package:flutter_test/flutter_test.dart';
import 'package:syncopathy/media_library/filter/media_filter.dart';
import 'package:syncopathy/media_library/filter/media_filter_logic.dart';
import 'package:syncopathy/persistence/entities/funscript_file.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';

/// Exercises [MediaFilterLogic.filterAndSort]: visibility filters, custom
/// filter groups (AND/OR), the sort options and the stable random shuffle.
/// This is the single pure entry point the media grid relies on, so its
/// behaviour must survive the filter/sort refactor intact.
void main() {
  MediaFile media(
    String name, {
    MediaRating rating = MediaRating.noRating,
    int playCount = 0,
    int id = 0,
    FunscriptFile? mainFunscript,
  }) {
    final m = MediaFile(
      name: name,
      mediaPath: '/library/$name.mp4',
      fileHash: name,
      playCount: playCount,
      fileNotFound: false,
      rating: rating,
      type: MediaType.video,
    );
    m.id = id;
    if (mainFunscript != null) m.mainFunscript.target = mainFunscript;
    return m;
  }

  FunscriptFile script({
    double speed = 0,
    double min = 0,
    double max = 0,
  }) => FunscriptFile(
    path: 'x.funscript',
    averageSpeed: speed,
    averageMin: min,
    averageMax: max,
    isScriptToken: false,
    fileNotFound: false,
    funscriptHash: 'h$speed$min$max',
  );

  StringFilter titleContains(String query) {
    final f = StringFilter(
      label: 'Title',
      icon: Icons.title,
      category: FilterCategory.media,
      sortOrder: 0,
      retriever: (m) => [m.name],
    );
    f.operator.value = StringFilterOperator.stringContains;
    f.value.value = query;
    return f;
  }

  NumberFilter playCountAtLeast(num value) {
    final f = NumberFilter(
      label: 'Play Count',
      icon: Icons.analytics,
      category: FilterCategory.status,
      sortOrder: 0,
      retriever: (m) => [m.playCount],
    );
    f.operator.value = FilterOperator.greaterEqual;
    f.value.value = value.toString();
    return f;
  }

  MediaFilter filterWith(FilterGroupOperator op, List<FilterBase> filters) {
    final mf = MediaFilter();
    mf.clearFilter();
    mf.defaultGroup.operator.value = op;
    for (final f in filters) {
      mf.defaultGroup.filters.add(f);
    }
    return mf;
  }

  List<MediaFile> run(
    List<MediaFile> items, {
    MediaFilter? filter,
    SortOption sort = SortOption.title,
    bool ascending = true,
    Set<VideoFilter> visibility = const {},
    bool separateFavorites = false,
    int? randomSeed,
  }) {
    return MediaFilterLogic.filterAndSort(
      media: items,
      customFilter: filter ?? MediaFilter(),
      sortOption: sort,
      isSortAscending: ascending,
      visibilityFilters: visibility,
      separateFavorites: separateFavorites,
      randomSeed: randomSeed,
    );
  }

  List<String> names(List<MediaFile> m) => m.map((e) => e.name).toList();

  group('no filters', () {
    test('returns everything sorted by title ascending by default', () {
      final result = run([media('Charlie'), media('alpha'), media('Bravo')]);
      expect(names(result), ['alpha', 'Bravo', 'Charlie']);
    });

    test('descending reverses the title order', () {
      final result = run([
        media('alpha'),
        media('Bravo'),
        media('Charlie'),
      ], ascending: false);
      expect(names(result), ['Charlie', 'Bravo', 'alpha']);
    });
  });

  group('visibility filters', () {
    test('hideFavorite drops liked media', () {
      final result = run(
        [
          media('liked', rating: MediaRating.like),
          media('plain'),
        ],
        visibility: {VideoFilter.hideFavorite},
      );
      expect(names(result), ['plain']);
    });

    test('hideDisliked drops disliked media', () {
      final result = run(
        [
          media('nope', rating: MediaRating.dislike),
          media('plain'),
        ],
        visibility: {VideoFilter.hideDisliked},
      );
      expect(names(result), ['plain']);
    });

    test('hideUnrated drops media with no rating', () {
      final result = run(
        [
          media('rated', rating: MediaRating.like),
          media('unrated'),
        ],
        visibility: {VideoFilter.hideUnrated},
      );
      expect(names(result), ['rated']);
    });
  });

  group('custom filter groups', () {
    test('a single title filter narrows the list', () {
      final result = run(
        [media('holiday clip'), media('work meeting'), media('holiday trip')],
        filter: filterWith(FilterGroupOperator.and, [titleContains('holiday')]),
      );
      expect(names(result)..sort(), ['holiday clip', 'holiday trip']);
    });

    test('AND requires every filter in the group to match', () {
      final result = run(
        [
          media('holiday', playCount: 10),
          media('holiday', playCount: 0),
          media('other', playCount: 10),
        ],
        filter: filterWith(FilterGroupOperator.and, [
          titleContains('holiday'),
          playCountAtLeast(5),
        ]),
      );
      expect(result.length, 1);
      expect(result.single.playCount, 10);
      expect(result.single.name, 'holiday');
    });

    test('OR keeps media matching any filter in the group', () {
      final result = run(
        [
          media('holiday', playCount: 0),
          media('other', playCount: 10),
          media('nothing', playCount: 0),
        ],
        filter: filterWith(FilterGroupOperator.or, [
          titleContains('holiday'),
          playCountAtLeast(5),
        ]),
      );
      expect(names(result)..sort(), ['holiday', 'other']);
    });

    test('a disabled filter does not constrain results', () {
      final f = titleContains('holiday');
      f.enabled.value = false;
      final result = run(
        [media('holiday'), media('other')],
        filter: filterWith(FilterGroupOperator.and, [f]),
      );
      expect(result.length, 2);
    });

    test('a negated filter inverts the match', () {
      final f = titleContains('holiday');
      f.negated.value = true;
      final result = run(
        [media('holiday'), media('other')],
        filter: filterWith(FilterGroupOperator.and, [f]),
      );
      expect(names(result), ['other']);
    });
  });

  group('sorting', () {
    test('by play count', () {
      final result = run([
        media('a', playCount: 5),
        media('b', playCount: 1),
        media('c', playCount: 9),
      ], sort: SortOption.playCount);
      expect(names(result), ['b', 'a', 'c']);
    });

    test('by funscript speed via the main funscript relation', () {
      final result = run([
        media('fast', mainFunscript: script(speed: 300)),
        media('slow', mainFunscript: script(speed: 50)),
        media('mid', mainFunscript: script(speed: 150)),
      ], sort: SortOption.speed);
      expect(names(result), ['slow', 'mid', 'fast']);
    });

    test('by depth (max minus min of the main funscript)', () {
      final result = run([
        media('shallow', mainFunscript: script(min: 40, max: 60)), // 20
        media('deep', mainFunscript: script(min: 0, max: 100)), // 100
        media('mid', mainFunscript: script(min: 20, max: 80)), // 60
      ], sort: SortOption.depth);
      expect(names(result), ['shallow', 'mid', 'deep']);
    });

    test('ties fall back to title order', () {
      final result = run([
        media('zebra', playCount: 5),
        media('apple', playCount: 5),
      ], sort: SortOption.playCount);
      expect(names(result), ['apple', 'zebra']);
    });
  });

  group('separateFavorites', () {
    test('favorites float to the top and dislikes sink to the bottom', () {
      final result = run(
        [
          media('plain'),
          media('liked', rating: MediaRating.like),
          media('nope', rating: MediaRating.dislike),
        ],
        separateFavorites: true,
      );
      expect(names(result), ['liked', 'plain', 'nope']);
    });
  });

  group('random sort', () {
    test('is a stable permutation for a given seed', () {
      final items = List.generate(20, (i) => media('m$i', id: i + 1));
      final a = names(run(items, sort: SortOption.random, randomSeed: 42));
      final b = names(run(items, sort: SortOption.random, randomSeed: 42));
      expect(a, b);
      // A permutation, not a filter: same set of names, order shuffled.
      expect(a.toSet(), items.map((e) => e.name).toSet());
    });

    test('different seeds generally produce different orders', () {
      final items = List.generate(20, (i) => media('m$i', id: i + 1));
      final a = names(run(items, sort: SortOption.random, randomSeed: 1));
      final b = names(run(items, sort: SortOption.random, randomSeed: 2));
      expect(a, isNot(equals(b)));
    });
  });
}
