// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetVideoCollection on Isar {
  IsarCollection<Video> get videos => this.collection();
}

const VideoSchema = CollectionSchema(
  name: r'Video',
  id: 113594071489080673,
  properties: {
    r'averageMax': PropertySchema(
      id: 0,
      name: r'averageMax',
      type: IsarType.double,
    ),
    r'averageMin': PropertySchema(
      id: 1,
      name: r'averageMin',
      type: IsarType.double,
    ),
    r'averageSpeed': PropertySchema(
      id: 2,
      name: r'averageSpeed',
      type: IsarType.double,
    ),
    r'dateFirstFound': PropertySchema(
      id: 3,
      name: r'dateFirstFound',
      type: IsarType.dateTime,
    ),
    r'duration': PropertySchema(
      id: 4,
      name: r'duration',
      type: IsarType.double,
    ),
    r'funscriptMetadata': PropertySchema(
      id: 5,
      name: r'funscriptMetadata',
      type: IsarType.object,
      target: r'FunscriptMetadata',
    ),
    r'funscriptPath': PropertySchema(
      id: 6,
      name: r'funscriptPath',
      type: IsarType.string,
    ),
    r'isDislike': PropertySchema(
      id: 7,
      name: r'isDislike',
      type: IsarType.bool,
    ),
    r'isFavorite': PropertySchema(
      id: 8,
      name: r'isFavorite',
      type: IsarType.bool,
    ),
    r'title': PropertySchema(id: 9, name: r'title', type: IsarType.string),
    r'videoHash': PropertySchema(
      id: 10,
      name: r'videoHash',
      type: IsarType.string,
    ),
    r'videoPath': PropertySchema(
      id: 11,
      name: r'videoPath',
      type: IsarType.string,
    ),
  },
  estimateSize: _videoEstimateSize,
  serialize: _videoSerialize,
  deserialize: _videoDeserialize,
  deserializeProp: _videoDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'categories': LinkSchema(
      id: 3364589698365908318,
      name: r'categories',
      target: r'UserCategory',
      single: false,
    ),
  },
  embeddedSchemas: {
    r'FunscriptMetadata': FunscriptMetadataSchema,
    r'Bookmark': BookmarkSchema,
    r'Chapter': ChapterSchema,
  },
  getId: _videoGetId,
  getLinks: _videoGetLinks,
  attach: _videoAttach,
  version: '3.1.0+1',
);

int _videoEstimateSize(
  Video object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.funscriptMetadata;
    if (value != null) {
      bytesCount +=
          3 +
          FunscriptMetadataSchema.estimateSize(
            value,
            allOffsets[FunscriptMetadata]!,
            allOffsets,
          );
    }
  }
  bytesCount += 3 + object.funscriptPath.length * 3;
  bytesCount += 3 + object.title.length * 3;
  bytesCount += 3 + object.videoHash.length * 3;
  bytesCount += 3 + object.videoPath.length * 3;
  return bytesCount;
}

void _videoSerialize(
  Video object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.averageMax);
  writer.writeDouble(offsets[1], object.averageMin);
  writer.writeDouble(offsets[2], object.averageSpeed);
  writer.writeDateTime(offsets[3], object.dateFirstFound);
  writer.writeDouble(offsets[4], object.duration);
  writer.writeObject<FunscriptMetadata>(
    offsets[5],
    allOffsets,
    FunscriptMetadataSchema.serialize,
    object.funscriptMetadata,
  );
  writer.writeString(offsets[6], object.funscriptPath);
  writer.writeBool(offsets[7], object.isDislike);
  writer.writeBool(offsets[8], object.isFavorite);
  writer.writeString(offsets[9], object.title);
  writer.writeString(offsets[10], object.videoHash);
  writer.writeString(offsets[11], object.videoPath);
}

Video _videoDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Video(
    averageMax: reader.readDouble(offsets[0]),
    averageMin: reader.readDouble(offsets[1]),
    averageSpeed: reader.readDouble(offsets[2]),
    duration: reader.readDoubleOrNull(offsets[4]),
    funscriptMetadata: reader.readObjectOrNull<FunscriptMetadata>(
      offsets[5],
      FunscriptMetadataSchema.deserialize,
      allOffsets,
    ),
    funscriptPath: reader.readString(offsets[6]),
    title: reader.readString(offsets[9]),
    videoPath: reader.readString(offsets[11]),
  );
  object.dateFirstFound = reader.readDateTime(offsets[3]);
  object.id = id;
  object.isDislike = reader.readBool(offsets[7]);
  object.isFavorite = reader.readBool(offsets[8]);
  return object;
}

P _videoDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readDoubleOrNull(offset)) as P;
    case 5:
      return (reader.readObjectOrNull<FunscriptMetadata>(
            offset,
            FunscriptMetadataSchema.deserialize,
            allOffsets,
          ))
          as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _videoGetId(Video object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _videoGetLinks(Video object) {
  return [object.categories];
}

void _videoAttach(IsarCollection<dynamic> col, Id id, Video object) {
  object.id = id;
  object.categories.attach(
    col,
    col.isar.collection<UserCategory>(),
    r'categories',
    id,
  );
}

extension VideoQueryWhereSort on QueryBuilder<Video, Video, QWhere> {
  QueryBuilder<Video, Video, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension VideoQueryWhere on QueryBuilder<Video, Video, QWhereClause> {
  QueryBuilder<Video, Video, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<Video, Video, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Video, Video, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterWhereClause> idBetween(
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

extension VideoQueryFilter on QueryBuilder<Video, Video, QFilterCondition> {
  QueryBuilder<Video, Video, QAfterFilterCondition> averageMaxEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'averageMax',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> averageMaxGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'averageMax',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> averageMaxLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'averageMax',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> averageMaxBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'averageMax',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> averageMinEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'averageMin',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> averageMinGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'averageMin',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> averageMinLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'averageMin',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> averageMinBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'averageMin',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> averageSpeedEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'averageSpeed',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> averageSpeedGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'averageSpeed',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> averageSpeedLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'averageSpeed',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> averageSpeedBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'averageSpeed',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> dateFirstFoundEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dateFirstFound', value: value),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> dateFirstFoundGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dateFirstFound',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> dateFirstFoundLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dateFirstFound',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> dateFirstFoundBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dateFirstFound',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> durationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'duration'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> durationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'duration'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> durationEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'duration',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> durationGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'duration',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> durationLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'duration',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> durationBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'duration',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> funscriptMetadataIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'funscriptMetadata'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition>
  funscriptMetadataIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'funscriptMetadata'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> funscriptPathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'funscriptPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> funscriptPathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'funscriptPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> funscriptPathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'funscriptPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> funscriptPathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'funscriptPath',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> funscriptPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'funscriptPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> funscriptPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'funscriptPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> funscriptPathContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'funscriptPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> funscriptPathMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'funscriptPath',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> funscriptPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'funscriptPath', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> funscriptPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'funscriptPath', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
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

  QueryBuilder<Video, Video, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
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

  QueryBuilder<Video, Video, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Video, Video, QAfterFilterCondition> isDislikeEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isDislike', value: value),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> isFavoriteEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isFavorite', value: value),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'title',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> titleContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> titleMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'title',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> videoHashEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'videoHash',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> videoHashGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'videoHash',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> videoHashLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'videoHash',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> videoHashBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'videoHash',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> videoHashStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'videoHash',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> videoHashEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'videoHash',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> videoHashContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'videoHash',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> videoHashMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'videoHash',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> videoHashIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'videoHash', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> videoHashIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'videoHash', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> videoPathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'videoPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> videoPathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'videoPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> videoPathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'videoPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> videoPathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'videoPath',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> videoPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'videoPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> videoPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'videoPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> videoPathContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'videoPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> videoPathMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'videoPath',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> videoPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'videoPath', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> videoPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'videoPath', value: ''),
      );
    });
  }
}

extension VideoQueryObject on QueryBuilder<Video, Video, QFilterCondition> {
  QueryBuilder<Video, Video, QAfterFilterCondition> funscriptMetadata(
    FilterQuery<FunscriptMetadata> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'funscriptMetadata');
    });
  }
}

extension VideoQueryLinks on QueryBuilder<Video, Video, QFilterCondition> {
  QueryBuilder<Video, Video, QAfterFilterCondition> categories(
    FilterQuery<UserCategory> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'categories');
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> categoriesLengthEqualTo(
    int length,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'categories', length, true, length, true);
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> categoriesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'categories', 0, true, 0, true);
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> categoriesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'categories', 0, false, 999999, true);
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> categoriesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'categories', 0, true, length, include);
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> categoriesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'categories', length, include, 999999, true);
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> categoriesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
        r'categories',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension VideoQuerySortBy on QueryBuilder<Video, Video, QSortBy> {
  QueryBuilder<Video, Video, QAfterSortBy> sortByAverageMax() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageMax', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByAverageMaxDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageMax', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByAverageMin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageMin', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByAverageMinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageMin', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByAverageSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageSpeed', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByAverageSpeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageSpeed', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByDateFirstFound() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateFirstFound', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByDateFirstFoundDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateFirstFound', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByFunscriptPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'funscriptPath', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByFunscriptPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'funscriptPath', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByIsDislike() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDislike', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByIsDislikeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDislike', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByIsFavoriteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByVideoHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoHash', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByVideoHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoHash', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByVideoPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoPath', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByVideoPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoPath', Sort.desc);
    });
  }
}

extension VideoQuerySortThenBy on QueryBuilder<Video, Video, QSortThenBy> {
  QueryBuilder<Video, Video, QAfterSortBy> thenByAverageMax() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageMax', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByAverageMaxDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageMax', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByAverageMin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageMin', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByAverageMinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageMin', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByAverageSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageSpeed', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByAverageSpeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageSpeed', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByDateFirstFound() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateFirstFound', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByDateFirstFoundDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateFirstFound', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByFunscriptPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'funscriptPath', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByFunscriptPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'funscriptPath', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByIsDislike() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDislike', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByIsDislikeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDislike', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByIsFavoriteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByVideoHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoHash', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByVideoHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoHash', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByVideoPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoPath', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByVideoPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoPath', Sort.desc);
    });
  }
}

extension VideoQueryWhereDistinct on QueryBuilder<Video, Video, QDistinct> {
  QueryBuilder<Video, Video, QDistinct> distinctByAverageMax() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'averageMax');
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByAverageMin() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'averageMin');
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByAverageSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'averageSpeed');
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByDateFirstFound() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateFirstFound');
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'duration');
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByFunscriptPath({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'funscriptPath',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByIsDislike() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDislike');
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isFavorite');
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByTitle({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByVideoHash({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'videoHash', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByVideoPath({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'videoPath', caseSensitive: caseSensitive);
    });
  }
}

extension VideoQueryProperty on QueryBuilder<Video, Video, QQueryProperty> {
  QueryBuilder<Video, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Video, double, QQueryOperations> averageMaxProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'averageMax');
    });
  }

  QueryBuilder<Video, double, QQueryOperations> averageMinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'averageMin');
    });
  }

  QueryBuilder<Video, double, QQueryOperations> averageSpeedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'averageSpeed');
    });
  }

  QueryBuilder<Video, DateTime, QQueryOperations> dateFirstFoundProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateFirstFound');
    });
  }

  QueryBuilder<Video, double?, QQueryOperations> durationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'duration');
    });
  }

  QueryBuilder<Video, FunscriptMetadata?, QQueryOperations>
  funscriptMetadataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'funscriptMetadata');
    });
  }

  QueryBuilder<Video, String, QQueryOperations> funscriptPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'funscriptPath');
    });
  }

  QueryBuilder<Video, bool, QQueryOperations> isDislikeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDislike');
    });
  }

  QueryBuilder<Video, bool, QQueryOperations> isFavoriteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isFavorite');
    });
  }

  QueryBuilder<Video, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<Video, String, QQueryOperations> videoHashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'videoHash');
    });
  }

  QueryBuilder<Video, String, QQueryOperations> videoPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'videoPath');
    });
  }
}
