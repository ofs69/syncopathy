import 'package:syncopathy/media_library/filter/media_filter.dart';
import 'package:syncopathy/persistence/entities/media_file.dart';

enum SortOption {
  title('Title'),
  speed('Speed'),
  depth('Depth'),
  duration('Duration'),
  lastModified('Modified'),
  playCount('Play Count'),
  random('Random');

  const SortOption(this.label);
  final String label;
}

enum VideoFilter {
  hideFavorite('Hide Favorite'),
  hideDisliked('Hide Disliked'),
  hideUnrated('Hide Unrated');

  const VideoFilter(this.label);
  final String label;
}

class MediaFilterLogic {
  static List<MediaFile> filterAndSort({
    required List<MediaFile> media,
    required MediaFilter customFilter,
    required SortOption sortOption,
    required bool isSortAscending,
    required Set<VideoFilter> visibilityFilters,
    required bool separateFavorites,
    int? randomSeed,
    dynamic playlistState,
  }) {
    // 0. Pre-calculate filter state
    final hideFavorite = visibilityFilters.contains(VideoFilter.hideFavorite);
    final hideDisliked = visibilityFilters.contains(VideoFilter.hideDisliked);
    final hideUnrated = visibilityFilters.contains(VideoFilter.hideUnrated);
    final groupsWithFilters = customFilter.filterGroups
        .where((g) => g.filters.isNotEmpty)
        .toList();

    // 1. Single pass Filtering
    List<MediaFile> filtered = media.where((m) {
      if (hideFavorite && m.isFavorite) return false;
      if (hideDisliked && m.isDislike) return false;
      if (hideUnrated && m.rating == MediaRating.noRating) return false;

      // Custom Filters
      for (var group in groupsWithFilters) {
        if (!_matchesGroup(m, group)) return false;
      }
      return true;
    }).toList();

    // 2. Sorting
    // Schwartzian transform: pre-calculate sort keys and lowercase titles
    // to avoid expensive relation lookups and string operations during sort comparisons.
    final mapped = filtered.map((m) {
      return (
        media: m,
        sortKey: _getSortKey(m, sortOption, randomSeed),
        titleKey: m.name.toLowerCase(),
      );
    }).toList();

    mapped.sort((a, b) {
      if (separateFavorites) {
        if (a.media.isFavorite && !b.media.isFavorite) return -1;
        if (!a.media.isFavorite && b.media.isFavorite) return 1;
        if (a.media.isDislike && !b.media.isDislike) return 1;
        if (!a.media.isDislike && b.media.isDislike) return -1;
      }

      int cmp = 0;
      final keyA = a.sortKey;
      final keyB = b.sortKey;

      if (keyA is Comparable && keyB is Comparable) {
        cmp = keyA.compareTo(keyB);
      }

      if (cmp == 0) {
        // Fallback to title
        cmp = a.titleKey.compareTo(b.titleKey);
      }
      return isSortAscending ? cmp : -cmp;
    });

    filtered = mapped.map((e) => e.media).toList();

    return filtered;
  }

  static dynamic _getSortKey(
    MediaFile m,
    SortOption option, [
    int? randomSeed,
  ]) {
    switch (option) {
      case SortOption.title:
        return m.name.toLowerCase();
      case SortOption.duration:
        return m.metadata.target?.duration ?? 0.0;
      case SortOption.playCount:
        return m.playCount;
      case SortOption.lastModified:
        return m.metadata.target?.creationTime?.millisecondsSinceEpoch ?? 0;
      case SortOption.speed:
        return m.mainFunscript.target?.averageSpeed ?? 0.0;
      case SortOption.depth:
        final target = m.mainFunscript.target;
        return (target?.averageMax ?? 0.0) - (target?.averageMin ?? 0.0);
      case SortOption.random:
        // Stable random sort based on ID and seed
        final seed = randomSeed ?? 0;
        var x = m.id + seed + 0x9E3779B9;
        x = ((x >> 30) ^ x) * 0xBF58476D1CE4E5B9;
        x = ((x >> 27) ^ x) * 0x94D049BB133111EB;
        x = (x >> 31) ^ x;
        return x;
    }
  }

  static bool _matchesGroup(MediaFile media, FilterGroup group) {
    if (group.filters.isEmpty) return true;

    if (group.operator.value == FilterGroupOperator.and) {
      return group.filters.every((f) => f.matches(media));
    } else {
      return group.filters.any((f) => f.matches(media));
    }
  }
}
