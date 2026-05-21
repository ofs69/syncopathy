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

  factory MediaLibrarySettings.fromJson(Map<String, dynamic> json) =>
      _$MediaLibrarySettingsFromJson(json);

  Map<String, dynamic> toJson() => _$MediaLibrarySettingsToJson(this);

  static const jsonSchema = _$MediaLibrarySettingsJsonSchema;
}
