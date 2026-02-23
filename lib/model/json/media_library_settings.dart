import 'package:json_annotation/json_annotation.dart';
import 'package:syncopathy/media_library.dart';

part 'media_library_settings.g.dart';

@JsonSerializable(createJsonSchema: true)
class MediaLibrarySettings {
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
    this.videosPerRow = 6,
    this.showVideoTitles = true,
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
