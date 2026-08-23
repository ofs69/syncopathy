import 'package:json_annotation/json_annotation.dart';
import 'package:syncopathy/media_library/filter/media_filter_logic.dart';
import 'package:syncopathy/media_library/media_badge.dart';

part 'media_library_settings.g.dart';

@JsonSerializable(createJsonSchema: true)
class MediaLibrarySettings {
  @JsonKey(unknownEnumValue: SortOption.title)
  SortOption sortOption;
  bool isSortAscending;
  int videosPerRow;
  bool showVideoTitles;

  /// Ids of the enabled card badges, from [availableBadges]. Replaces the old
  /// per-badge `show*` booleans — see [_badgesFromLegacyToggles].
  @JsonKey(fromJson: _enabledBadgesFromJson)
  List<String> enabledBadges;
  bool separateFavorites;
  @JsonKey(fromJson: _visibilityFiltersFromJson)
  List<VideoFilter> visibilityFilters;

  static const String key = "MediaLibrarySettings";

  MediaLibrarySettings({
    this.sortOption = SortOption.title,
    this.isSortAscending = true,
    this.videosPerRow = 4,
    this.showVideoTitles = false,
    List<String>? enabledBadges,
    this.separateFavorites = true,
    this.visibilityFilters = const [],
  }) : enabledBadges = enabledBadges ?? defaultBadgeIds;

  factory MediaLibrarySettings.fromJson(Map<String, dynamic> json) {
    try {
      final settings = _$MediaLibrarySettingsFromJson(json);
      if (!json.containsKey('enabledBadges')) {
        settings.enabledBadges = _badgesFromLegacyToggles(json);
      }
      return settings;
    } catch (_) {
      // Corrupted or incompatible persisted data (e.g. removed enum value,
      // type mismatch). Fall back to defaults rather than crashing.
      return MediaLibrarySettings();
    }
  }

  Map<String, dynamic> toJson() => _$MediaLibrarySettingsToJson(this);

  static const jsonSchema = _$MediaLibrarySettingsJsonSchema;
}

/// Tolerantly decodes the persisted badge ids, dropping any that no longer map
/// to a registered badge. An empty list is a real choice (every badge turned
/// off) and is preserved; an absent key is handled by [MediaLibrarySettings
/// .fromJson], which hands over to the legacy migration instead.
List<String> _enabledBadgesFromJson(List<dynamic>? json) {
  if (json == null) return defaultBadgeIds;
  return json.whereType<String>().where(badgesById.containsKey).toList();
}

/// The pre-registry badge toggles, and the badge each one now maps to.
const Map<String, String> _legacyBadgeToggles = {
  'showDuration': 'duration',
  'showPlayCount': 'playCount',
  'showAverageSpeed': 'averageSpeed',
  'showAverageMinMax': 'averageMinMax',
};

/// Seeds the badge set from the old `show*` booleans so an existing library
/// keeps exactly the badges it had. Runs once, on the first load after the
/// upgrade; the next save writes `enabledBadges` and the legacy keys are never
/// read again.
List<String> _badgesFromLegacyToggles(Map<String, dynamic> json) {
  final legacyIdToKey = {
    for (final entry in _legacyBadgeToggles.entries) entry.value: entry.key,
  };
  final ids = <String>[];
  for (final spec in availableBadges) {
    final legacyValue = json[legacyIdToKey[spec.id]];
    // A badge with no legacy toggle, or whose toggle predates this stored
    // blob, starts at its own default rather than being treated as off.
    final enabled = legacyValue is bool ? legacyValue : spec.defaultOn;
    if (enabled) ids.add(spec.id);
  }
  return ids;
}

/// Tolerantly decodes the persisted visibility filters, silently dropping any
/// values that no longer map to a known [VideoFilter] (e.g. a removed enum
/// member) instead of throwing.
List<VideoFilter> _visibilityFiltersFromJson(List<dynamic>? json) {
  if (json == null) return const [];
  final result = <VideoFilter>[];
  for (final value in json) {
    for (final entry in _$VideoFilterEnumMap.entries) {
      if (entry.value == value) {
        result.add(entry.key);
        break;
      }
    }
  }
  return result;
}
