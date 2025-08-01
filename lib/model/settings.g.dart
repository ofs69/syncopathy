// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSettingsEntityCollection on Isar {
  IsarCollection<SettingsEntity> get settingsEntitys => this.collection();
}

const SettingsEntitySchema = CollectionSchema(
  name: r'SettingsEntity',
  id: -7271317039764597112,
  properties: {
    r'embeddedVideoPlayer': PropertySchema(
      id: 0,
      name: r'embeddedVideoPlayer',
      type: IsarType.bool,
    ),
    r'max': PropertySchema(
      id: 1,
      name: r'max',
      type: IsarType.long,
    ),
    r'mediaPaths': PropertySchema(
      id: 2,
      name: r'mediaPaths',
      type: IsarType.stringList,
    ),
    r'min': PropertySchema(
      id: 3,
      name: r'min',
      type: IsarType.long,
    ),
    r'offsetMs': PropertySchema(
      id: 4,
      name: r'offsetMs',
      type: IsarType.long,
    ),
    r'rdpEpsilon': PropertySchema(
      id: 5,
      name: r'rdpEpsilon',
      type: IsarType.double,
    ),
    r'remapFullRange': PropertySchema(
      id: 6,
      name: r'remapFullRange',
      type: IsarType.bool,
    ),
    r'skipToAction': PropertySchema(
      id: 7,
      name: r'skipToAction',
      type: IsarType.bool,
    ),
    r'slewMaxRateOfChange': PropertySchema(
      id: 8,
      name: r'slewMaxRateOfChange',
      type: IsarType.double,
    )
  },
  estimateSize: _settingsEntityEstimateSize,
  serialize: _settingsEntitySerialize,
  deserialize: _settingsEntityDeserialize,
  deserializeProp: _settingsEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _settingsEntityGetId,
  getLinks: _settingsEntityGetLinks,
  attach: _settingsEntityAttach,
  version: '3.1.0+1',
);

int _settingsEntityEstimateSize(
  SettingsEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.mediaPaths.length * 3;
  {
    for (var i = 0; i < object.mediaPaths.length; i++) {
      final value = object.mediaPaths[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _settingsEntitySerialize(
  SettingsEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.embeddedVideoPlayer);
  writer.writeLong(offsets[1], object.max);
  writer.writeStringList(offsets[2], object.mediaPaths);
  writer.writeLong(offsets[3], object.min);
  writer.writeLong(offsets[4], object.offsetMs);
  writer.writeDouble(offsets[5], object.rdpEpsilon);
  writer.writeBool(offsets[6], object.remapFullRange);
  writer.writeBool(offsets[7], object.skipToAction);
  writer.writeDouble(offsets[8], object.slewMaxRateOfChange);
}

SettingsEntity _settingsEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SettingsEntity();
  object.embeddedVideoPlayer = reader.readBool(offsets[0]);
  object.id = id;
  object.max = reader.readLong(offsets[1]);
  object.mediaPaths = reader.readStringList(offsets[2]) ?? [];
  object.min = reader.readLong(offsets[3]);
  object.offsetMs = reader.readLong(offsets[4]);
  object.rdpEpsilon = reader.readDoubleOrNull(offsets[5]);
  object.remapFullRange = reader.readBool(offsets[6]);
  object.skipToAction = reader.readBool(offsets[7]);
  object.slewMaxRateOfChange = reader.readDoubleOrNull(offsets[8]);
  return object;
}

P _settingsEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readStringList(offset) ?? []) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readDoubleOrNull(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readDoubleOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _settingsEntityGetId(SettingsEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _settingsEntityGetLinks(SettingsEntity object) {
  return [];
}

void _settingsEntityAttach(
    IsarCollection<dynamic> col, Id id, SettingsEntity object) {
  object.id = id;
}

extension SettingsEntityQueryWhereSort
    on QueryBuilder<SettingsEntity, SettingsEntity, QWhere> {
  QueryBuilder<SettingsEntity, SettingsEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SettingsEntityQueryWhere
    on QueryBuilder<SettingsEntity, SettingsEntity, QWhereClause> {
  QueryBuilder<SettingsEntity, SettingsEntity, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SettingsEntityQueryFilter
    on QueryBuilder<SettingsEntity, SettingsEntity, QFilterCondition> {
  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      embeddedVideoPlayerEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'embeddedVideoPlayer',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      maxEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'max',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      maxGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'max',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      maxLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'max',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      maxBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'max',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      mediaPathsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mediaPaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      mediaPathsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mediaPaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      mediaPathsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mediaPaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      mediaPathsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mediaPaths',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      mediaPathsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mediaPaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      mediaPathsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mediaPaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      mediaPathsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mediaPaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      mediaPathsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mediaPaths',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      mediaPathsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mediaPaths',
        value: '',
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      mediaPathsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mediaPaths',
        value: '',
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      mediaPathsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mediaPaths',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      mediaPathsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mediaPaths',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      mediaPathsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mediaPaths',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      mediaPathsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mediaPaths',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      mediaPathsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mediaPaths',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      mediaPathsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mediaPaths',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      minEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'min',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      minGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'min',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      minLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'min',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      minBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'min',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      offsetMsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'offsetMs',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      offsetMsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'offsetMs',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      offsetMsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'offsetMs',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      offsetMsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'offsetMs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      rdpEpsilonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rdpEpsilon',
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      rdpEpsilonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rdpEpsilon',
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      rdpEpsilonEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rdpEpsilon',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      rdpEpsilonGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rdpEpsilon',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      rdpEpsilonLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rdpEpsilon',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      rdpEpsilonBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rdpEpsilon',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      remapFullRangeEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remapFullRange',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      skipToActionEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'skipToAction',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      slewMaxRateOfChangeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'slewMaxRateOfChange',
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      slewMaxRateOfChangeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'slewMaxRateOfChange',
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      slewMaxRateOfChangeEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'slewMaxRateOfChange',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      slewMaxRateOfChangeGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'slewMaxRateOfChange',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      slewMaxRateOfChangeLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'slewMaxRateOfChange',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
      slewMaxRateOfChangeBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'slewMaxRateOfChange',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension SettingsEntityQueryObject
    on QueryBuilder<SettingsEntity, SettingsEntity, QFilterCondition> {}

extension SettingsEntityQueryLinks
    on QueryBuilder<SettingsEntity, SettingsEntity, QFilterCondition> {}

extension SettingsEntityQuerySortBy
    on QueryBuilder<SettingsEntity, SettingsEntity, QSortBy> {
  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByEmbeddedVideoPlayer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'embeddedVideoPlayer', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByEmbeddedVideoPlayerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'embeddedVideoPlayer', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy> sortByMax() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'max', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy> sortByMaxDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'max', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy> sortByMin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'min', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy> sortByMinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'min', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy> sortByOffsetMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'offsetMs', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByOffsetMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'offsetMs', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByRdpEpsilon() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rdpEpsilon', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByRdpEpsilonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rdpEpsilon', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByRemapFullRange() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remapFullRange', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortByRemapFullRangeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remapFullRange', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortBySkipToAction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skipToAction', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortBySkipToActionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skipToAction', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortBySlewMaxRateOfChange() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slewMaxRateOfChange', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      sortBySlewMaxRateOfChangeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slewMaxRateOfChange', Sort.desc);
    });
  }
}

extension SettingsEntityQuerySortThenBy
    on QueryBuilder<SettingsEntity, SettingsEntity, QSortThenBy> {
  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByEmbeddedVideoPlayer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'embeddedVideoPlayer', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByEmbeddedVideoPlayerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'embeddedVideoPlayer', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy> thenByMax() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'max', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy> thenByMaxDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'max', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy> thenByMin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'min', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy> thenByMinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'min', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy> thenByOffsetMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'offsetMs', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByOffsetMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'offsetMs', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByRdpEpsilon() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rdpEpsilon', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByRdpEpsilonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rdpEpsilon', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByRemapFullRange() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remapFullRange', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenByRemapFullRangeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remapFullRange', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenBySkipToAction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skipToAction', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenBySkipToActionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skipToAction', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenBySlewMaxRateOfChange() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slewMaxRateOfChange', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
      thenBySlewMaxRateOfChangeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slewMaxRateOfChange', Sort.desc);
    });
  }
}

extension SettingsEntityQueryWhereDistinct
    on QueryBuilder<SettingsEntity, SettingsEntity, QDistinct> {
  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct>
      distinctByEmbeddedVideoPlayer() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'embeddedVideoPlayer');
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct> distinctByMax() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'max');
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct>
      distinctByMediaPaths() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mediaPaths');
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct> distinctByMin() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'min');
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct> distinctByOffsetMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'offsetMs');
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct>
      distinctByRdpEpsilon() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rdpEpsilon');
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct>
      distinctByRemapFullRange() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remapFullRange');
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct>
      distinctBySkipToAction() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'skipToAction');
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct>
      distinctBySlewMaxRateOfChange() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'slewMaxRateOfChange');
    });
  }
}

extension SettingsEntityQueryProperty
    on QueryBuilder<SettingsEntity, SettingsEntity, QQueryProperty> {
  QueryBuilder<SettingsEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SettingsEntity, bool, QQueryOperations>
      embeddedVideoPlayerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'embeddedVideoPlayer');
    });
  }

  QueryBuilder<SettingsEntity, int, QQueryOperations> maxProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'max');
    });
  }

  QueryBuilder<SettingsEntity, List<String>, QQueryOperations>
      mediaPathsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mediaPaths');
    });
  }

  QueryBuilder<SettingsEntity, int, QQueryOperations> minProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'min');
    });
  }

  QueryBuilder<SettingsEntity, int, QQueryOperations> offsetMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'offsetMs');
    });
  }

  QueryBuilder<SettingsEntity, double?, QQueryOperations> rdpEpsilonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rdpEpsilon');
    });
  }

  QueryBuilder<SettingsEntity, bool, QQueryOperations>
      remapFullRangeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remapFullRange');
    });
  }

  QueryBuilder<SettingsEntity, bool, QQueryOperations> skipToActionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'skipToAction');
    });
  }

  QueryBuilder<SettingsEntity, double?, QQueryOperations>
      slewMaxRateOfChangeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'slewMaxRateOfChange');
    });
  }
}
