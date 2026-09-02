import 'dart:math';

import 'package:syncopathy/heresphere/heresphere_library.dart';
import 'package:syncopathy/logging.dart';
import 'package:syncopathy/media_library/filter/media_filter.dart';
import 'package:syncopathy/media_library/filter/media_filter_logic.dart';
import 'package:syncopathy/model/media_filter_presets_model.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';

/// How many entries a shelf shows.
///
/// A shelf is a top-N view by definition — "Recently Added" means the newest
/// few, not the library in date order — so this is the shelf, not a truncation
/// of one. That is what separates it from the section cap that was removed: a
/// capped *category* silently hid media with no other way to reach it, where
/// everything on a shelf is also in `Interactive`, `Other Videos` or a category
/// below it. Sized to stay scrollable in a headset, where reading a title is
/// slow and a long grid is worse than a short one.
const int hereSphereShelfSize = 40;

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

/// The shelves that open the library.
///
/// These answer "what do I watch now", which is the question a headset is
/// opened with. The complete lists are still published below them, but they
/// answer "where is that file" — and the player's own search over `/scan`
/// answers that better than a list of several thousand ever will.
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
List<MediaFile> _recentlyAdded(List<MediaFile> playable) {
  final dated = playable.where((media) => media.firstIndexedOn != null).toList()
    ..sort((a, b) => b.firstIndexedOn!.compareTo(a.firstIndexedOn!));
  return _capped(dated);
}

/// Scripted media that has never been played, newest first.
///
/// Newest first rather than alphabetical because the cap has to choose, and the
/// newest arrivals are the ones worth surfacing; A-to-Z would show the same
/// forty entries until every one of them had been watched.
List<MediaFile> _unwatched(List<MediaFile> scripted) {
  final never = scripted.where((media) => media.playCount == 0).toList()
    ..sort(_newestFirst);
  return _capped(never);
}

/// Everything the user liked. Uncapped: it is a list they built by hand, so it
/// is short by construction, and cutting it would drop a deliberate choice.
List<MediaFile> _favourites(List<MediaFile> playable) =>
    playable.where((media) => media.isFavorite).toList()..sort(_byName);

/// A fresh handful of scripted media, in the order it was drawn.
///
/// Reshuffled per request on purpose. Scrolling a long grid in a headset is
/// slow enough that "show me something" is a real way to browse, and a shelf
/// answering with the same forty entries every time would not be one.
List<MediaFile> _randomPick(List<MediaFile> scripted, Random? random) {
  final pool = [...scripted]..shuffle(random ?? Random());
  return _capped(pool);
}

/// One shelf per saved filter preset, named as the user named it.
///
/// Nothing here invents a taxonomy. These are the questions the user already
/// decided were worth keeping, phrased in the filter language the desktop
/// library uses and evaluated by the code that evaluates them there — so a
/// preset means the same thing in the headset as it does on the monitor.
///
/// Uncapped, unlike a shelf: a preset is a query the way a category is, and
/// answering one with the first forty matches would make a filter that lies
/// about its own result.
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

List<MediaFile> _capped(List<MediaFile> media) =>
    media.length <= hereSphereShelfSize
    ? media
    : media.sublist(0, hereSphereShelfSize);

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
