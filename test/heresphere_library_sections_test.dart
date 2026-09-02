import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:syncopathy/heresphere/heresphere_library.dart';
import 'package:syncopathy/heresphere/library_sections.dart';
import 'package:syncopathy/media_library/filter/media_filter.dart';
import 'package:syncopathy/media_library/filter/media_filter_preset.dart';
import 'package:syncopathy/model/media_filter_presets_model.dart';
import 'package:syncopathy/persistence/entities/funscript_file.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';

/// A library entry, with only the fields the shelves actually read.
///
/// Detached from any store: relations on a new entity behave as plain fields,
/// which is what lets section composition be tested without ObjectBox.
MediaFile clip(
  String name, {
  bool scripted = false,
  bool scriptToken = false,
  bool scriptMissing = false,
  int playCount = 0,
  DateTime? addedOn,
  MediaRating? rating,
}) {
  final media = MediaFile(
    name: name,
    mediaPath: 'Q:\\media\\$name.mp4',
    fileHash: 'hash-$name',
    playCount: playCount,
    fileNotFound: false,
    rating: rating,
  );
  media.firstIndexedOn = addedOn;
  if (scripted || scriptToken || scriptMissing) {
    media.mainFunscript.target = FunscriptFile(
      path: 'Q:\\media\\$name.funscript',
      averageSpeed: 150,
      averageMin: 10,
      averageMax: 90,
      isScriptToken: scriptToken,
      fileNotFound: scriptMissing,
      funscriptHash: 'script-$name',
    );
  }
  return media;
}

DateTime day(int n) => DateTime(2026, 1, n);

List<String> namesIn(List<HereSphereShelf> shelves, String name) =>
    shelves
        .firstWhere((shelf) => shelf.name == name)
        .media
        .map((media) => media.name)
        .toList();

bool hasShelf(List<HereSphereShelf> shelves, String name) =>
    shelves.any((shelf) => shelf.name == name);

/// A preset built from live filters, round-tripped the way a saved one is.
MediaFilterPreset preset(String name, List<FilterBase> filters) {
  final filter = MediaFilter()
    ..replaceGroups([FilterGroup(FilterGroupOperator.and, filters)]);
  return MediaFilterPreset(
    id: name,
    name: name,
    snapshot: MediaFilterSnapshot.fromJson(
      MediaFilterSnapshot.capture(filter).toJson(),
    ),
  );
}

void main() {
  group('what counts as interactive', () {
    test('a playable script does', () {
      expect(hasPlayableFunscript(clip('a', scripted: true)), isTrue);
    });

    test('no script does not', () {
      expect(hasPlayableFunscript(clip('a')), isFalse);
    });

    test('an encrypted token does not', () {
      // It cannot drive the device, so the entry is not interactive whatever
      // the file beside it looks like.
      expect(hasPlayableFunscript(clip('a', scriptToken: true)), isFalse);
    });

    test('a script that has gone missing does not', () {
      expect(hasPlayableFunscript(clip('a', scriptMissing: true)), isFalse);
    });
  });

  group('shelves', () {
    test('recently added is newest first', () {
      final shelves = hereSphereShelves([
        clip('old', addedOn: day(1)),
        clip('newest', addedOn: day(9)),
        clip('middle', addedOn: day(5)),
      ]);

      expect(namesIn(shelves, 'Recently Added'), [
        'newest',
        'middle',
        'old',
      ]);
    });

    test('media the library never dated is left off recently added', () {
      // A shelf named for recency should not be padded with entries whose
      // recency is unknown.
      final shelves = hereSphereShelves([
        clip('dated', addedOn: day(1)),
        clip('undated'),
      ]);

      expect(namesIn(shelves, 'Recently Added'), ['dated']);
    });

    test('a library with no dates has no recently added shelf', () {
      final shelves = hereSphereShelves([clip('a'), clip('b')]);
      expect(hasShelf(shelves, 'Recently Added'), isFalse);
    });

    test('unwatched covers scripted media that was never played', () {
      final shelves = hereSphereShelves([
        clip('played', scripted: true, playCount: 3, addedOn: day(1)),
        clip('fresh', scripted: true, addedOn: day(2)),
        // Unscripted, so not on this shelf however new it is.
        clip('unscripted', addedOn: day(3)),
      ]);

      expect(namesIn(shelves, 'Unwatched Interactive'), ['fresh']);
    });

    test('unwatched leads with the newest arrivals, not with A', () {
      final shelves = hereSphereShelves([
        clip('aaa', scripted: true, addedOn: day(1)),
        clip('zzz', scripted: true, addedOn: day(2)),
      ]);

      expect(namesIn(shelves, 'Unwatched Interactive'), ['zzz', 'aaa']);
    });

    test('favourites is what the user liked, and only that', () {
      final shelves = hereSphereShelves([
        clip('liked', rating: MediaRating.like),
        clip('disliked', rating: MediaRating.dislike),
        clip('unrated'),
      ]);

      expect(namesIn(shelves, 'Favourites'), ['liked']);
    });

    test('the random shelf draws from scripted media', () {
      final shelves = hereSphereShelves([
        clip('scripted', scripted: true),
        clip('plain'),
      ], random: Random(1));

      expect(namesIn(shelves, 'Random Interactive'), ['scripted']);
    });

    test('the random shelf changes between requests', () {
      final library = [
        for (var i = 0; i < 200; i++) clip('clip$i', scripted: true),
      ];

      final first = namesIn(hereSphereShelves(library), 'Random Interactive');
      final second = namesIn(hereSphereShelves(library), 'Random Interactive');

      // Reshuffled per request on purpose: a shelf answering with the same
      // forty entries every time is not a way to browse.
      expect(first, isNot(second));
    });

    test('no shelf is a sample of what it names', () {
      // A shelf is an ordering and a question, not a top-N view: the point of
      // "Unwatched Interactive" is that it is everything unwatched.
      final library = [
        for (var i = 0; i < 200; i++)
          clip(
            'clip$i',
            scripted: true,
            rating: MediaRating.like,
            addedOn: day(1).add(Duration(days: i)),
          ),
      ];

      final shelves = hereSphereShelves(library);
      for (final name in [
        'Recently Added',
        'Unwatched Interactive',
        'Favourites',
        'Random Interactive',
      ]) {
        expect(namesIn(shelves, name), hasLength(200), reason: name);
      }
    });

    test('recently added still leads with the newest', () {
      final library = [
        for (var i = 0; i < 200; i++)
          clip('clip$i', addedOn: day(1).add(Duration(days: i))),
      ];

      expect(
        namesIn(hereSphereShelves(library), 'Recently Added').first,
        'clip199',
      );
    });

    test('an empty library publishes no shelves at all', () {
      expect(hereSphereShelves(const []), isEmpty);
    });

    test('a shelf with nothing in it is left out', () {
      // Nothing rated and nothing unwatched are ordinary states, not errors.
      final shelves = hereSphereShelves([
        clip('watched', scripted: true, playCount: 1, addedOn: day(1)),
      ]);

      expect(hasShelf(shelves, 'Recently Added'), isTrue);
      expect(hasShelf(shelves, 'Favourites'), isFalse);
      expect(hasShelf(shelves, 'Unwatched Interactive'), isFalse);
    });

    test('composing does not disturb the list it was given', () {
      final library = [
        clip('b', scripted: true, addedOn: day(1)),
        clip('a', scripted: true, addedOn: day(2)),
      ];

      hereSphereShelves(library);

      expect(library.map((media) => media.name), ['b', 'a']);
    });
  });

  group('saved filter presets', () {
    test('a preset becomes a section named as the user named it', () {
      final shelves = hereSpherePresetShelves(
        [clip('Holiday One'), clip('Something Else')],
        [
          preset('Holidays', [
            availableFilters['Title']!() as StringFilter
              ..operator.value = StringFilterOperator.stringStartsWith
              ..value.value = 'Holiday',
          ]),
        ],
      );

      expect(shelves, hasLength(1));
      expect(shelves.single.name, 'Holidays');
      expect(shelves.single.media.map((media) => media.name), ['Holiday One']);
    });

    test('a preset matching nothing is left out', () {
      final shelves = hereSpherePresetShelves(
        [clip('Something Else')],
        [
          preset('Holidays', [
            availableFilters['Title']!() as StringFilter
              ..operator.value = StringFilterOperator.stringStartsWith
              ..value.value = 'Holiday',
          ]),
        ],
      );

      expect(shelves, isEmpty);
    });

    test('a preset with no name is left out', () {
      final shelves = hereSpherePresetShelves(
        [clip('anything')],
        [preset('   ', [availableFilters['Playable']!()])],
      );

      expect(shelves, isEmpty);
    });

    test('a preset that cannot be evaluated costs only its own section', () {
      // PlaylistFilter reads the locally loaded playlist through GetIt, which
      // is not registered here — the shape of a filter reaching for state the
      // server has no business depending on. The library must survive it.
      final shelves = hereSpherePresetShelves(
        [clip('Holiday One')],
        [
          preset('Broken', [availableFilters['Playlist']!()]),
          preset('Titles', [
            availableFilters['Title']!() as StringFilter
              ..operator.value = StringFilterOperator.stringStartsWith
              ..value.value = 'Holiday',
          ]),
        ],
      );

      expect(shelves.map((shelf) => shelf.name), ['Titles']);
    });

    test('presets are published in the order they were saved', () {
      final shelves = hereSpherePresetShelves(
        [clip('a')],
        [
          preset('First', [availableFilters['Playable']!()..negated.value = true]),
          preset('Second', [availableFilters['Playable']!()..negated.value = true]),
        ],
      );

      expect(shelves.map((shelf) => shelf.name), ['First', 'Second']);
    });
  });

  group('section names', () {
    HereSphereSection section(String name) =>
        HereSphereSection(name: name, entries: const []);

    test('a repeated name is made distinct, first claim winning', () {
      final sections = withDistinctNames([
        section('Favourites'),
        section('Favourites'),
        section('Favourites'),
      ]);

      expect(sections.map((s) => s.name), [
        'Favourites',
        'Favourites (2)',
        'Favourites (3)',
      ]);
    });

    test('names that differ only in case still collide', () {
      // Not a distinction anyone reads at a glance, least of all in a headset.
      final sections = withDistinctNames([
        section('Favourites'),
        section('favourites'),
      ]);

      expect(sections.map((s) => s.name), ['Favourites', 'favourites (2)']);
    });

    test('distinct names are left alone', () {
      final sections = withDistinctNames([
        section('Interactive'),
        section('Other Videos'),
      ]);

      expect(sections.map((s) => s.name), ['Interactive', 'Other Videos']);
    });

    test('entries are carried through untouched', () {
      const entry = HereSphereEntry(
        id: 'a',
        title: 'a',
        mediaPath: r'Q:\media\a.mp4',
      );
      final sections = withDistinctNames([
        HereSphereSection(name: 'One', entries: const [entry]),
      ]);

      expect(sections.single.entries, [entry]);
    });
  });
}
