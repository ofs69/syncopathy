// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_library_settings.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMediaLibrarySettingsEntityCollection on Isar {
  IsarCollection<MediaLibrarySettingsEntity> get mediaLibrarySettingsEntitys =>
      this.collection();
}

const MediaLibrarySettingsEntitySchema = CollectionSchema(
  name: r'MediaLibrarySettingsEntity',
  id: -7077921284057987650,
  properties: {
    r'isSortAscending': PropertySchema(
      id: 0,
      name: r'isSortAscending',
      type: IsarType.bool,
    ),
    r'showAverageMinMax': PropertySchema(
      id: 1,
      name: r'showAverageMinMax',
      type: IsarType.bool,
    ),
    r'showAverageSpeed': PropertySchema(
      id: 2,
      name: r'showAverageSpeed',
      type: IsarType.bool,
    ),
    r'showDuration': PropertySchema(
      id: 3,
      name: r'showDuration',
      type: IsarType.bool,
    ),
    r'showVideoTitles': PropertySchema(
      id: 4,
      name: r'showVideoTitles',
      type: IsarType.bool,
    ),
    r'sortOption': PropertySchema(
      id: 5,
      name: r'sortOption',
      type: IsarType.byte,
      enumMap: _MediaLibrarySettingsEntitysortOptionEnumValueMap,
    ),
    r'videosPerRow': PropertySchema(
      id: 6,
      name: r'videosPerRow',
      type: IsarType.long,
    ),
    r'visibilityFilters': PropertySchema(
      id: 7,
      name: r'visibilityFilters',
      type: IsarType.stringList,
    ),
  },
  estimateSize: _mediaLibrarySettingsEntityEstimateSize,
  serialize: _mediaLibrarySettingsEntitySerialize,
  deserialize: _mediaLibrarySettingsEntityDeserialize,
  deserializeProp: _mediaLibrarySettingsEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _mediaLibrarySettingsEntityGetId,
  getLinks: _mediaLibrarySettingsEntityGetLinks,
  attach: _mediaLibrarySettingsEntityAttach,
  version: '3.1.0+1',
);

int _mediaLibrarySettingsEntityEstimateSize(
  MediaLibrarySettingsEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.visibilityFilters.length * 3;
  {
    for (var i = 0; i < object.visibilityFilters.length; i++) {
      final value = object.visibilityFilters[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _mediaLibrarySettingsEntitySerialize(
  MediaLibrarySettingsEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.isSortAscending);
  writer.writeBool(offsets[1], object.showAverageMinMax);
  writer.writeBool(offsets[2], object.showAverageSpeed);
  writer.writeBool(offsets[3], object.showDuration);
  writer.writeBool(offsets[4], object.showVideoTitles);
  writer.writeByte(offsets[5], object.sortOption.index);
  writer.writeLong(offsets[6], object.videosPerRow);
  writer.writeStringList(offsets[7], object.visibilityFilters);
}

MediaLibrarySettingsEntity _mediaLibrarySettingsEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MediaLibrarySettingsEntity();
  object.id = id;
  object.isSortAscending = reader.readBool(offsets[0]);
  object.showAverageMinMax = reader.readBool(offsets[1]);
  object.showAverageSpeed = reader.readBool(offsets[2]);
  object.showDuration = reader.readBool(offsets[3]);
  object.showVideoTitles = reader.readBool(offsets[4]);
  object.sortOption =
      _MediaLibrarySettingsEntitysortOptionValueEnumMap[reader.readByteOrNull(
        offsets[5],
      )] ??
      SortOption.title;
  object.videosPerRow = reader.readLong(offsets[6]);
  object.visibilityFilters = reader.readStringList(offsets[7]) ?? [];
  return object;
}

P _mediaLibrarySettingsEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (_MediaLibrarySettingsEntitysortOptionValueEnumMap[reader
                  .readByteOrNull(offset)] ??
              SortOption.title)
          as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readStringList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _MediaLibrarySettingsEntitysortOptionEnumValueMap = {
  'title': 0,
  'speed': 1,
  'depth': 2,
  'duration': 3,
  'lastModified': 4,
};
const _MediaLibrarySettingsEntitysortOptionValueEnumMap = {
  0: SortOption.title,
  1: SortOption.speed,
  2: SortOption.depth,
  3: SortOption.duration,
  4: SortOption.lastModified,
};

Id _mediaLibrarySettingsEntityGetId(MediaLibrarySettingsEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _mediaLibrarySettingsEntityGetLinks(
  MediaLibrarySettingsEntity object,
) {
  return [];
}

void _mediaLibrarySettingsEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  MediaLibrarySettingsEntity object,
) {
  object.id = id;
}

extension MediaLibrarySettingsEntityQueryWhereSort
    on
        QueryBuilder<
          MediaLibrarySettingsEntity,
          MediaLibrarySettingsEntity,
          QWhere
        > {
  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterWhere
  >
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MediaLibrarySettingsEntityQueryWhere
    on
        QueryBuilder<
          MediaLibrarySettingsEntity,
          MediaLibrarySettingsEntity,
          QWhereClause
        > {
  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterWhereClause
  >
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterWhereClause
  >
  idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterWhereClause
  >
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterWhereClause
  >
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterWhereClause
  >
  idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension MediaLibrarySettingsEntityQueryFilter
    on
        QueryBuilder<
          MediaLibrarySettingsEntity,
          MediaLibrarySettingsEntity,
          QFilterCondition
        > {
  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterFilterCondition
  >
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterFilterCondition
  >
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterFilterCondition
  >
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterFilterCondition
  >
  idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterFilterCondition
  >
  isSortAscendingEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isSortAscending', value: value),
      );
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterFilterCondition
  >
  showAverageMinMaxEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'showAverageMinMax', value: value),
      );
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterFilterCondition
  >
  showAverageSpeedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'showAverageSpeed', value: value),
      );
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterFilterCondition
  >
  showDurationEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'showDuration', value: value),
      );
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterFilterCondition
  >
  showVideoTitlesEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'showVideoTitles', value: value),
      );
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterFilterCondition
  >
  sortOptionEqualTo(SortOption value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sortOption', value: value),
      );
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterFilterCondition
  >
  sortOptionGreaterThan(SortOption value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sortOption',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterFilterCondition
  >
  sortOptionLessThan(SortOption value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sortOption',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterFilterCondition
  >
  sortOptionBetween(
    SortOption lower,
    SortOption upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sortOption',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterFilterCondition
  >
  videosPerRowEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'videosPerRow', value: value),
      );
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterFilterCondition
  >
  videosPerRowGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'videosPerRow',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterFilterCondition
  >
  videosPerRowLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'videosPerRow',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterFilterCondition
  >
  videosPerRowBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'videosPerRow',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterFilterCondition
  >
  visibilityFiltersElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'visibilityFilters',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterFilterCondition
  >
  visibilityFiltersElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'visibilityFilters',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterFilterCondition
  >
  visibilityFiltersElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'visibilityFilters',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterFilterCondition
  >
  visibilityFiltersElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'visibilityFilters',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterFilterCondition
  >
  visibilityFiltersElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'visibilityFilters',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterFilterCondition
  >
  visibilityFiltersElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'visibilityFilters',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterFilterCondition
  >
  visibilityFiltersElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'visibilityFilters',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterFilterCondition
  >
  visibilityFiltersElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'visibilityFilters',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterFilterCondition
  >
  visibilityFiltersElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'visibilityFilters', value: ''),
      );
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterFilterCondition
  >
  visibilityFiltersElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'visibilityFilters', value: ''),
      );
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterFilterCondition
  >
  visibilityFiltersLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'visibilityFilters', length, true, length, true);
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterFilterCondition
  >
  visibilityFiltersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'visibilityFilters', 0, true, 0, true);
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterFilterCondition
  >
  visibilityFiltersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'visibilityFilters', 0, false, 999999, true);
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterFilterCondition
  >
  visibilityFiltersLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'visibilityFilters', 0, true, length, include);
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterFilterCondition
  >
  visibilityFiltersLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'visibilityFilters',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterFilterCondition
  >
  visibilityFiltersLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'visibilityFilters',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension MediaLibrarySettingsEntityQueryObject
    on
        QueryBuilder<
          MediaLibrarySettingsEntity,
          MediaLibrarySettingsEntity,
          QFilterCondition
        > {}

extension MediaLibrarySettingsEntityQueryLinks
    on
        QueryBuilder<
          MediaLibrarySettingsEntity,
          MediaLibrarySettingsEntity,
          QFilterCondition
        > {}

extension MediaLibrarySettingsEntityQuerySortBy
    on
        QueryBuilder<
          MediaLibrarySettingsEntity,
          MediaLibrarySettingsEntity,
          QSortBy
        > {
  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterSortBy
  >
  sortByIsSortAscending() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSortAscending', Sort.asc);
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterSortBy
  >
  sortByIsSortAscendingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSortAscending', Sort.desc);
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterSortBy
  >
  sortByShowAverageMinMax() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showAverageMinMax', Sort.asc);
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterSortBy
  >
  sortByShowAverageMinMaxDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showAverageMinMax', Sort.desc);
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterSortBy
  >
  sortByShowAverageSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showAverageSpeed', Sort.asc);
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterSortBy
  >
  sortByShowAverageSpeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showAverageSpeed', Sort.desc);
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterSortBy
  >
  sortByShowDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showDuration', Sort.asc);
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterSortBy
  >
  sortByShowDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showDuration', Sort.desc);
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterSortBy
  >
  sortByShowVideoTitles() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showVideoTitles', Sort.asc);
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterSortBy
  >
  sortByShowVideoTitlesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showVideoTitles', Sort.desc);
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterSortBy
  >
  sortBySortOption() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOption', Sort.asc);
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterSortBy
  >
  sortBySortOptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOption', Sort.desc);
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterSortBy
  >
  sortByVideosPerRow() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videosPerRow', Sort.asc);
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterSortBy
  >
  sortByVideosPerRowDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videosPerRow', Sort.desc);
    });
  }
}

extension MediaLibrarySettingsEntityQuerySortThenBy
    on
        QueryBuilder<
          MediaLibrarySettingsEntity,
          MediaLibrarySettingsEntity,
          QSortThenBy
        > {
  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterSortBy
  >
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterSortBy
  >
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterSortBy
  >
  thenByIsSortAscending() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSortAscending', Sort.asc);
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterSortBy
  >
  thenByIsSortAscendingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSortAscending', Sort.desc);
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterSortBy
  >
  thenByShowAverageMinMax() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showAverageMinMax', Sort.asc);
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterSortBy
  >
  thenByShowAverageMinMaxDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showAverageMinMax', Sort.desc);
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterSortBy
  >
  thenByShowAverageSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showAverageSpeed', Sort.asc);
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterSortBy
  >
  thenByShowAverageSpeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showAverageSpeed', Sort.desc);
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterSortBy
  >
  thenByShowDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showDuration', Sort.asc);
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterSortBy
  >
  thenByShowDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showDuration', Sort.desc);
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterSortBy
  >
  thenByShowVideoTitles() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showVideoTitles', Sort.asc);
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterSortBy
  >
  thenByShowVideoTitlesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showVideoTitles', Sort.desc);
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterSortBy
  >
  thenBySortOption() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOption', Sort.asc);
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterSortBy
  >
  thenBySortOptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOption', Sort.desc);
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterSortBy
  >
  thenByVideosPerRow() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videosPerRow', Sort.asc);
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QAfterSortBy
  >
  thenByVideosPerRowDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videosPerRow', Sort.desc);
    });
  }
}

extension MediaLibrarySettingsEntityQueryWhereDistinct
    on
        QueryBuilder<
          MediaLibrarySettingsEntity,
          MediaLibrarySettingsEntity,
          QDistinct
        > {
  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QDistinct
  >
  distinctByIsSortAscending() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSortAscending');
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QDistinct
  >
  distinctByShowAverageMinMax() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showAverageMinMax');
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QDistinct
  >
  distinctByShowAverageSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showAverageSpeed');
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QDistinct
  >
  distinctByShowDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showDuration');
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QDistinct
  >
  distinctByShowVideoTitles() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showVideoTitles');
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QDistinct
  >
  distinctBySortOption() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sortOption');
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QDistinct
  >
  distinctByVideosPerRow() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'videosPerRow');
    });
  }

  QueryBuilder<
    MediaLibrarySettingsEntity,
    MediaLibrarySettingsEntity,
    QDistinct
  >
  distinctByVisibilityFilters() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'visibilityFilters');
    });
  }
}

extension MediaLibrarySettingsEntityQueryProperty
    on
        QueryBuilder<
          MediaLibrarySettingsEntity,
          MediaLibrarySettingsEntity,
          QQueryProperty
        > {
  QueryBuilder<MediaLibrarySettingsEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MediaLibrarySettingsEntity, bool, QQueryOperations>
  isSortAscendingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSortAscending');
    });
  }

  QueryBuilder<MediaLibrarySettingsEntity, bool, QQueryOperations>
  showAverageMinMaxProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showAverageMinMax');
    });
  }

  QueryBuilder<MediaLibrarySettingsEntity, bool, QQueryOperations>
  showAverageSpeedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showAverageSpeed');
    });
  }

  QueryBuilder<MediaLibrarySettingsEntity, bool, QQueryOperations>
  showDurationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showDuration');
    });
  }

  QueryBuilder<MediaLibrarySettingsEntity, bool, QQueryOperations>
  showVideoTitlesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showVideoTitles');
    });
  }

  QueryBuilder<MediaLibrarySettingsEntity, SortOption, QQueryOperations>
  sortOptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sortOption');
    });
  }

  QueryBuilder<MediaLibrarySettingsEntity, int, QQueryOperations>
  videosPerRowProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'videosPerRow');
    });
  }

  QueryBuilder<MediaLibrarySettingsEntity, List<String>, QQueryOperations>
  visibilityFiltersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'visibilityFilters');
    });
  }
}
