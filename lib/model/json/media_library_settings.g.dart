// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_library_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaLibrarySettings _$MediaLibrarySettingsFromJson(
  Map<String, dynamic> json,
) => MediaLibrarySettings(
  sortOption:
      $enumDecodeNullable(
        _$SortOptionEnumMap,
        json['sortOption'],
        unknownValue: SortOption.title,
      ) ??
      SortOption.title,
  isSortAscending: json['isSortAscending'] as bool? ?? true,
  videosPerRow: (json['videosPerRow'] as num?)?.toInt() ?? 4,
  showVideoTitles: json['showVideoTitles'] as bool? ?? false,
  enabledBadges: _enabledBadgesFromJson(json['enabledBadges'] as List?),
  separateFavorites: json['separateFavorites'] as bool? ?? true,
  visibilityFilters: json['visibilityFilters'] == null
      ? const []
      : _visibilityFiltersFromJson(json['visibilityFilters'] as List?),
);

Map<String, dynamic> _$MediaLibrarySettingsToJson(
  MediaLibrarySettings instance,
) => <String, dynamic>{
  'sortOption': _$SortOptionEnumMap[instance.sortOption]!,
  'isSortAscending': instance.isSortAscending,
  'videosPerRow': instance.videosPerRow,
  'showVideoTitles': instance.showVideoTitles,
  'enabledBadges': instance.enabledBadges,
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
    'isSortAscending': {'type': 'boolean', 'default': true},
    'videosPerRow': {'type': 'integer', 'default': 4},
    'showVideoTitles': {'type': 'boolean', 'default': false},
    'enabledBadges': {
      'type': 'array',
      'items': {'type': 'string'},
      'description':
          'Ids of the enabled card badges, from [availableBadges]. Replaces the old\nper-badge `show*` booleans — see [_badgesFromLegacyToggles].',
    },
    'separateFavorites': {'type': 'boolean', 'default': true},
    'visibilityFilters': {
      'type': 'array',
      'items': {'type': 'object'},
      'default': [],
    },
  },
};

const _$SortOptionEnumMap = {
  SortOption.title: 'title',
  SortOption.speed: 'speed',
  SortOption.depth: 'depth',
  SortOption.duration: 'duration',
  SortOption.dateAdded: 'dateAdded',
  SortOption.playCount: 'playCount',
  SortOption.random: 'random',
};

const _$VideoFilterEnumMap = {
  VideoFilter.hideFavorite: 'hideFavorite',
  VideoFilter.hideDisliked: 'hideDisliked',
  VideoFilter.hideUnrated: 'hideUnrated',
};
