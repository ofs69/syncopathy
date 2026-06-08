import 'package:json_annotation/json_annotation.dart';
import 'package:syncopathy/media_library/filter/media_filter_logic.dart';

part 'media_library_settings.g.dart';

@JsonSerializable(createJsonSchema: true)
class MediaLibrarySettings {
  @JsonKey(unknownEnumValue: SortOption.title)
  SortOption sortOption;
  bool isSortAscending;
  int videosPerRow;
  bool showVideoTitles;
  bool showAverageSpeed;
  bool showAverageMinMax;
  bool showDuration;
  bool showPlayCount;
  bool separateFavorites;
  @JsonKey(fromJson: _visibilityFiltersFromJson)
  List<VideoFilter> visibilityFilters;

  static const String key = "MediaLibrarySettings";

  MediaLibrarySettings({
    this.sortOption = SortOption.title,
    this.isSortAscending = true,
    this.videosPerRow = 4,
    this.showVideoTitles = false,
    this.showAverageSpeed = true,
    this.showAverageMinMax = true,
    this.showDuration = true,
    this.showPlayCount = true,
    this.separateFavorites = true,
    this.visibilityFilters = const [],
  });

  factory MediaLibrarySettings.fromJson(Map<String, dynamic> json) {
    try {
      return _$MediaLibrarySettingsFromJson(json);
    } catch (_) {
      // Corrupted or incompatible persisted data (e.g. removed enum value,
      // type mismatch). Fall back to defaults rather than crashing.
      return MediaLibrarySettings();
    }
  }

  Map<String, dynamic> toJson() => _$MediaLibrarySettingsToJson(this);

  static const jsonSchema = _$MediaLibrarySettingsJsonSchema;
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
