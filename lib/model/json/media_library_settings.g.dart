// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_library_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaLibrarySettings _$MediaLibrarySettingsFromJson(
  Map<String, dynamic> json,
) => MediaLibrarySettings(
  sortOption:
      $enumDecodeNullable(_$SortOptionEnumMap, json['sortOption']) ??
      SortOption.title,
  isSortAscending: json['isSortAscending'] as bool? ?? true,
  videosPerRow: (json['videosPerRow'] as num?)?.toInt() ?? 6,
  showVideoTitles: json['showVideoTitles'] as bool? ?? true,
  showAverageSpeed: json['showAverageSpeed'] as bool? ?? true,
  showAverageMinMax: json['showAverageMinMax'] as bool? ?? true,
  showDuration: json['showDuration'] as bool? ?? true,
  showPlayCount: json['showPlayCount'] as bool? ?? true,
  separateFavorites: json['separateFavorites'] as bool? ?? true,
  visibilityFilters:
      (json['visibilityFilters'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$VideoFilterEnumMap, e))
          .toList() ??
      const [],
);

Map<String, dynamic> _$MediaLibrarySettingsToJson(
  MediaLibrarySettings instance,
) => <String, dynamic>{
  'sortOption': _$SortOptionEnumMap[instance.sortOption]!,
  'isSortAscending': instance.isSortAscending,
  'videosPerRow': instance.videosPerRow,
  'showVideoTitles': instance.showVideoTitles,
  'showAverageSpeed': instance.showAverageSpeed,
  'showAverageMinMax': instance.showAverageMinMax,
  'showDuration': instance.showDuration,
  'showPlayCount': instance.showPlayCount,
  'separateFavorites': instance.separateFavorites,
  'visibilityFilters': instance.visibilityFilters
      .map((e) => _$VideoFilterEnumMap[e]!)
      .toList(),
};

const _$MediaLibrarySettingsJsonSchema = {
  r'$schema': 'https://json-schema.org/draft/2020-12/schema',
  'type': 'object',
  'properties': {
    'sortOption': {'type': 'object'},
    'isSortAscending': {'type': 'boolean'},
    'videosPerRow': {'type': 'integer'},
    'showVideoTitles': {'type': 'boolean'},
    'showAverageSpeed': {'type': 'boolean'},
    'showAverageMinMax': {'type': 'boolean'},
    'showDuration': {'type': 'boolean'},
    'showPlayCount': {'type': 'boolean'},
    'separateFavorites': {'type': 'boolean'},
    'visibilityFilters': {
      'type': 'array',
      'items': {'type': 'object'},
    },
  },
  'required': [
    'sortOption',
    'isSortAscending',
    'videosPerRow',
    'showVideoTitles',
    'showAverageSpeed',
    'showAverageMinMax',
    'showDuration',
    'showPlayCount',
    'separateFavorites',
    'visibilityFilters',
  ],
};

const _$SortOptionEnumMap = {
  SortOption.title: 'title',
  SortOption.speed: 'speed',
  SortOption.depth: 'depth',
  SortOption.duration: 'duration',
  SortOption.lastModified: 'lastModified',
  SortOption.playCount: 'playCount',
  SortOption.random: 'random',
  SortOption.pca: 'pca',
};

const _$VideoFilterEnumMap = {
  VideoFilter.hideFavorite: 'hideFavorite',
  VideoFilter.hideDisliked: 'hideDisliked',
  VideoFilter.hideUnrated: 'hideUnrated',
};
