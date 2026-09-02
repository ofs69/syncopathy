import 'dart:math';

import 'package:syncopathy/heresphere/heresphere_library.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/media_library/filter/media_filter.dart';
import 'package:syncopathy/media_library/filter/media_filter_logic.dart';
import 'package:syncopathy/model/media_filter_presets_model.dart';
import 'package:syncopathy/persistence/entities/funscript_file.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';

/// A named group of media, before it is turned into API entries.
///
/// Composition works in [MediaFile]s so it can be tested without a database or
/// a thumbnail generator; the library source maps the result to entries.
typedef HereSphereShelf = ({String name, List<MediaFile> media});

/// Whether a script Syncopathy could actually play is attached.
///
/// An encrypted token counts as none: it cannot drive the device, so treating
/// the entry as interactive would be a lie to the shelves and to the tag alike.
bool hasPlayableFunscript(MediaFile media) {
  final main = media.mainFunscript.target;
  return main != null && !main.fileNotFound && !main.isScriptToken;
}

/// The entry's scripts, main axis first, with anything unplayable dropped.
///
/// Order is the identity: a script's position here is what its URL names, so
/// it has to be derived the same way every time rather than from whatever
/// order the relation happens to return.
List<FunscriptFile> playableScripts(MediaFile media) {
  // The same rule the Interactive tag and the shelves use, so one entry
  // cannot be non-interactive in the library and scripted in its metadata.
  // It matters most in the case that made the two disagree: a stroke script
  // that is an encrypted token beside a real secondary-axis one. The main
  // script is chosen by axis before playability — rightly, since a twist
  // script is not a stroke script — so handing that twist script over as the
  // entry's first script would drive the stroke axis from data describing a
  // different one. Nothing is the better answer.
  if (!hasPlayableFunscript(media)) return const [];

  final usable = media.funscripts
      .where((script) => !script.fileNotFound && !script.isScriptToken)
      .toList();
  usable.sort((a, b) => a.path.toLowerCase().compareTo(b.path.toLowerCase()));

  // Non-null past the guard, which is exactly the statement that this entry
  // has a usable main script.
  final main = media.mainFunscript.target!;
  final mainIndex = usable.indexWhere((script) => script.id == main.id);
  if (mainIndex <= 0) return usable;
  // The stroke script leads, so a player taking the first entry takes the
  // one that matters.
  return [usable.removeAt(mainIndex), ...usable];
}

/// The shelves that open the library.
///
/// These answer "what do I watch now", which is the question a headset is
/// opened with. The complete lists are still published below them, but they
/// answer "where is that file" — and the player's own search over `/scan`
/// answers that better than a list of several thousand ever will.
///
/// Every shelf is complete. A shelf is an ordering and a question, not a
/// sample: the whole point of "Unwatched Interactive" is that it is everything
/// unwatched, and a shelf that quietly showed the first forty would be a
/// section that lied about its own name. The index carries nothing per entry
/// but a URL, so length was never what made it expensive.
///
/// [random] is injectable so a test can assert which entries were picked rather
/// than merely that some were. Left null, every call picks afresh, which is
/// what makes the shelf worth having.
List<HereSphereShelf> hereSphereShelves(
  List<MediaFile> playable, {
  Random? random,
}) {
  final scripted = playable.where(hasPlayableFunscript).toList();
  return [
    (name: 'Recently Added', media: _recentlyAdded(playable)),
    (name: 'Unwatched Interactive', media: _unwatched(scripted)),
    (name: 'Favourites', media: _favourites(playable)),
    (name: 'Random Interactive', media: _randomPick(scripted, random)),
    // An empty shelf is only a dead end to navigate into, and the reasons for
    // one are ordinary: nothing rated yet, or nothing left unwatched.
  ].where((shelf) => shelf.media.isNotEmpty).toList();
}

/// The newest arrivals.
///
/// Entries the library never dated are left out rather than sorted to one end:
/// a shelf named for recency should not be padded with media whose recency is
/// unknown.
List<MediaFile> _recentlyAdded(List<MediaFile> playable) =>
    playable.where((media) => media.firstIndexedOn != null).toList()
      ..sort((a, b) => b.firstIndexedOn!.compareTo(a.firstIndexedOn!));

/// Scripted media that has never been played, newest first.
///
/// Newest first rather than alphabetical because a headset reads the front of a
/// row and rarely the end of it, and the newest arrivals are what that row is
/// worth opening for; A-to-Z would put the same entries there until every one
/// of them had been watched.
List<MediaFile> _unwatched(List<MediaFile> scripted) =>
    scripted.where((media) => media.playCount == 0).toList()
      ..sort(_newestFirst);

/// Everything the user liked.
List<MediaFile> _favourites(List<MediaFile> playable) =>
    playable.where((media) => media.isFavorite).toList()..sort(_byName);

/// The scripted library, in an order nothing else offers.
///
/// Reshuffled per request on purpose. Scrolling a long grid in a headset is
/// slow enough that "show me something" is a real way to browse, and what makes
/// this shelf that is the reshuffle rather than any cut: the front of the row
/// is different every time it is opened, and the rest is still all there.
List<MediaFile> _randomPick(List<MediaFile> scripted, Random? random) =>
    [...scripted]..shuffle(random ?? Random());

/// One shelf per saved filter preset, named as the user named it.
///
/// Nothing here invents a taxonomy. These are the questions the user already
/// decided were worth keeping, phrased in the filter language the desktop
/// library uses and evaluated by the code that evaluates them there — so a
/// preset means the same thing in the headset as it does on the monitor.
List<HereSphereShelf> hereSpherePresetShelves(
  List<MediaFile> playable,
  List<MediaFilterPreset> presets,
) {
  final shelves = <HereSphereShelf>[];
  for (final preset in presets) {
    final name = preset.name.trim();
    if (name.isEmpty) continue;
    try {
      final filter = MediaFilter();
      preset.snapshot.applyTo(filter);
      final matched = MediaFilterLogic.filterAndSort(
        media: playable,
        customFilter: filter,
        sortOption: SortOption.title,
        isSortAscending: true,
        // The desktop's visibility toggles are view state rather than part of
        // what was saved, so leaving them out is what makes the preset mean the
        // same thing in both places.
        visibilityFilters: const {},
        separateFavorites: false,
      );
      if (matched.isEmpty) continue;
      shelves.add((name: name, media: matched));
    } catch (e) {
      // One preset that cannot be evaluated must never cost the library its
      // index. A filter can reach for state the server has no business
      // depending on — the loaded playlist, a category deleted since the preset
      // was saved — and a headset with no library at all is a far worse outcome
      // than one missing a section.
      Logger.warning('HereSphere: skipping the "$name" filter preset: $e');
    }
  }
  return shelves;
}

/// Makes every section name unique, first claim winning.
///
/// A name is all a section has in the headset, so two reading the same is two
/// the user cannot tell apart — and it is easy to arrive at, since a preset or
/// a category can be called anything, including what a shelf is already called.
List<HereSphereSection> withDistinctNames(List<HereSphereSection> sections) {
  final taken = <String>{};
  return [
    for (final section in sections)
      HereSphereSection(
        name: _distinctName(section.name, taken),
        entries: section.entries,
      ),
  ];
}

String _distinctName(String name, Set<String> taken) {
  // Compared without case: "Favourites" beside "favourites" is a distinction
  // nobody reads at a glance, least of all in a headset.
  if (taken.add(name.toLowerCase())) return name;
  for (var suffix = 2; ; suffix++) {
    final candidate = '$name ($suffix)';
    if (taken.add(candidate.toLowerCase())) return candidate;
  }
}

int _byName(MediaFile a, MediaFile b) =>
    a.name.toLowerCase().compareTo(b.name.toLowerCase());

/// Newest first, with undated entries last and ties broken by name so the order
/// is the same on every request.
int _newestFirst(MediaFile a, MediaFile b) {
  final left = a.firstIndexedOn;
  final right = b.firstIndexedOn;
  if (left != null && right != null && left != right) {
    return right.compareTo(left);
  }
  if (left == null && right != null) return 1;
  if (left != null && right == null) return -1;
  return _byName(a, b);
}
