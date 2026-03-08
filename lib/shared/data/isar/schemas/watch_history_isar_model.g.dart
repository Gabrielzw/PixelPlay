// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watch_history_isar_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWatchHistoryIsarModelCollection on Isar {
  IsarCollection<WatchHistoryIsarModel> get watchHistoryIsarModels =>
      this.collection();
}

const WatchHistoryIsarModelSchema = CollectionSchema(
  name: r'WatchHistoryIsarModel',
  id: 2079788924307747941,
  properties: {
    r'durationMs': PropertySchema(
      id: 0,
      name: r'durationMs',
      type: IsarType.long,
    ),
    r'isRemote': PropertySchema(id: 1, name: r'isRemote', type: IsarType.bool),
    r'localVideoDateModified': PropertySchema(
      id: 2,
      name: r'localVideoDateModified',
      type: IsarType.long,
    ),
    r'localVideoId': PropertySchema(
      id: 3,
      name: r'localVideoId',
      type: IsarType.long,
    ),
    r'mediaId': PropertySchema(id: 4, name: r'mediaId', type: IsarType.string),
    r'mediaPath': PropertySchema(
      id: 5,
      name: r'mediaPath',
      type: IsarType.string,
    ),
    r'positionMs': PropertySchema(
      id: 6,
      name: r'positionMs',
      type: IsarType.long,
    ),
    r'sourceLabel': PropertySchema(
      id: 7,
      name: r'sourceLabel',
      type: IsarType.string,
    ),
    r'title': PropertySchema(id: 8, name: r'title', type: IsarType.string),
    r'watchedAtMs': PropertySchema(
      id: 9,
      name: r'watchedAtMs',
      type: IsarType.long,
    ),
    r'webDavAccountId': PropertySchema(
      id: 10,
      name: r'webDavAccountId',
      type: IsarType.string,
    ),
  },

  estimateSize: _watchHistoryIsarModelEstimateSize,
  serialize: _watchHistoryIsarModelSerialize,
  deserialize: _watchHistoryIsarModelDeserialize,
  deserializeProp: _watchHistoryIsarModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'mediaId': IndexSchema(
      id: -8001372983137409759,
      name: r'mediaId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'mediaId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _watchHistoryIsarModelGetId,
  getLinks: _watchHistoryIsarModelGetLinks,
  attach: _watchHistoryIsarModelAttach,
  version: '3.3.0',
);

int _watchHistoryIsarModelEstimateSize(
  WatchHistoryIsarModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.mediaId.length * 3;
  {
    final value = object.mediaPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.sourceLabel.length * 3;
  bytesCount += 3 + object.title.length * 3;
  {
    final value = object.webDavAccountId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _watchHistoryIsarModelSerialize(
  WatchHistoryIsarModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.durationMs);
  writer.writeBool(offsets[1], object.isRemote);
  writer.writeLong(offsets[2], object.localVideoDateModified);
  writer.writeLong(offsets[3], object.localVideoId);
  writer.writeString(offsets[4], object.mediaId);
  writer.writeString(offsets[5], object.mediaPath);
  writer.writeLong(offsets[6], object.positionMs);
  writer.writeString(offsets[7], object.sourceLabel);
  writer.writeString(offsets[8], object.title);
  writer.writeLong(offsets[9], object.watchedAtMs);
  writer.writeString(offsets[10], object.webDavAccountId);
}

WatchHistoryIsarModel _watchHistoryIsarModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WatchHistoryIsarModel();
  object.durationMs = reader.readLong(offsets[0]);
  object.id = id;
  object.isRemote = reader.readBool(offsets[1]);
  object.localVideoDateModified = reader.readLongOrNull(offsets[2]);
  object.localVideoId = reader.readLongOrNull(offsets[3]);
  object.mediaId = reader.readString(offsets[4]);
  object.mediaPath = reader.readStringOrNull(offsets[5]);
  object.positionMs = reader.readLong(offsets[6]);
  object.sourceLabel = reader.readString(offsets[7]);
  object.title = reader.readString(offsets[8]);
  object.watchedAtMs = reader.readLong(offsets[9]);
  object.webDavAccountId = reader.readStringOrNull(offsets[10]);
  return object;
}

P _watchHistoryIsarModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _watchHistoryIsarModelGetId(WatchHistoryIsarModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _watchHistoryIsarModelGetLinks(
  WatchHistoryIsarModel object,
) {
  return [];
}

void _watchHistoryIsarModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  WatchHistoryIsarModel object,
) {
  object.id = id;
}

extension WatchHistoryIsarModelByIndex
    on IsarCollection<WatchHistoryIsarModel> {
  Future<WatchHistoryIsarModel?> getByMediaId(String mediaId) {
    return getByIndex(r'mediaId', [mediaId]);
  }

  WatchHistoryIsarModel? getByMediaIdSync(String mediaId) {
    return getByIndexSync(r'mediaId', [mediaId]);
  }

  Future<bool> deleteByMediaId(String mediaId) {
    return deleteByIndex(r'mediaId', [mediaId]);
  }

  bool deleteByMediaIdSync(String mediaId) {
    return deleteByIndexSync(r'mediaId', [mediaId]);
  }

  Future<List<WatchHistoryIsarModel?>> getAllByMediaId(
    List<String> mediaIdValues,
  ) {
    final values = mediaIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'mediaId', values);
  }

  List<WatchHistoryIsarModel?> getAllByMediaIdSync(List<String> mediaIdValues) {
    final values = mediaIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'mediaId', values);
  }

  Future<int> deleteAllByMediaId(List<String> mediaIdValues) {
    final values = mediaIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'mediaId', values);
  }

  int deleteAllByMediaIdSync(List<String> mediaIdValues) {
    final values = mediaIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'mediaId', values);
  }

  Future<Id> putByMediaId(WatchHistoryIsarModel object) {
    return putByIndex(r'mediaId', object);
  }

  Id putByMediaIdSync(WatchHistoryIsarModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'mediaId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByMediaId(List<WatchHistoryIsarModel> objects) {
    return putAllByIndex(r'mediaId', objects);
  }

  List<Id> putAllByMediaIdSync(
    List<WatchHistoryIsarModel> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'mediaId', objects, saveLinks: saveLinks);
  }
}

extension WatchHistoryIsarModelQueryWhereSort
    on QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QWhere> {
  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension WatchHistoryIsarModelQueryWhere
    on
        QueryBuilder<
          WatchHistoryIsarModel,
          WatchHistoryIsarModel,
          QWhereClause
        > {
  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterWhereClause>
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

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterWhereClause>
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

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterWhereClause>
  mediaIdEqualTo(String mediaId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'mediaId', value: [mediaId]),
      );
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterWhereClause>
  mediaIdNotEqualTo(String mediaId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'mediaId',
                lower: [],
                upper: [mediaId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'mediaId',
                lower: [mediaId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'mediaId',
                lower: [mediaId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'mediaId',
                lower: [],
                upper: [mediaId],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension WatchHistoryIsarModelQueryFilter
    on
        QueryBuilder<
          WatchHistoryIsarModel,
          WatchHistoryIsarModel,
          QFilterCondition
        > {
  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  durationMsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'durationMs', value: value),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  durationMsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'durationMs',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  durationMsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'durationMs',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  durationMsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'durationMs',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
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
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
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
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
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
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
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
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  isRemoteEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isRemote', value: value),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  localVideoDateModifiedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'localVideoDateModified'),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  localVideoDateModifiedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'localVideoDateModified'),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  localVideoDateModifiedEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'localVideoDateModified',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  localVideoDateModifiedGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'localVideoDateModified',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  localVideoDateModifiedLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'localVideoDateModified',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  localVideoDateModifiedBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'localVideoDateModified',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  localVideoIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'localVideoId'),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  localVideoIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'localVideoId'),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  localVideoIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'localVideoId', value: value),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  localVideoIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'localVideoId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  localVideoIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'localVideoId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  localVideoIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'localVideoId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  mediaIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'mediaId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  mediaIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'mediaId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  mediaIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'mediaId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  mediaIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'mediaId',
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
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  mediaIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'mediaId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  mediaIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'mediaId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  mediaIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'mediaId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  mediaIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'mediaId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  mediaIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'mediaId', value: ''),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  mediaIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'mediaId', value: ''),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  mediaPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'mediaPath'),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  mediaPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'mediaPath'),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  mediaPathEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'mediaPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  mediaPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'mediaPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  mediaPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'mediaPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  mediaPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'mediaPath',
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
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  mediaPathStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'mediaPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  mediaPathEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'mediaPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  mediaPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'mediaPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  mediaPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'mediaPath',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  mediaPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'mediaPath', value: ''),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  mediaPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'mediaPath', value: ''),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  positionMsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'positionMs', value: value),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  positionMsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'positionMs',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  positionMsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'positionMs',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  positionMsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'positionMs',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  sourceLabelEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'sourceLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  sourceLabelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sourceLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  sourceLabelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sourceLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  sourceLabelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sourceLabel',
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
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  sourceLabelStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'sourceLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  sourceLabelEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'sourceLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  sourceLabelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'sourceLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  sourceLabelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'sourceLabel',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  sourceLabelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sourceLabel', value: ''),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  sourceLabelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'sourceLabel', value: ''),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  titleEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  titleGreaterThan(
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

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  titleLessThan(
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

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  titleBetween(
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

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  titleStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  titleEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  titleContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  titleMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  watchedAtMsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'watchedAtMs', value: value),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  watchedAtMsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'watchedAtMs',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  watchedAtMsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'watchedAtMs',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  watchedAtMsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'watchedAtMs',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  webDavAccountIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'webDavAccountId'),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  webDavAccountIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'webDavAccountId'),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  webDavAccountIdEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'webDavAccountId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  webDavAccountIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'webDavAccountId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  webDavAccountIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'webDavAccountId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  webDavAccountIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'webDavAccountId',
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
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  webDavAccountIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'webDavAccountId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  webDavAccountIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'webDavAccountId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  webDavAccountIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'webDavAccountId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  webDavAccountIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'webDavAccountId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  webDavAccountIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'webDavAccountId', value: ''),
      );
    });
  }

  QueryBuilder<
    WatchHistoryIsarModel,
    WatchHistoryIsarModel,
    QAfterFilterCondition
  >
  webDavAccountIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'webDavAccountId', value: ''),
      );
    });
  }
}

extension WatchHistoryIsarModelQueryObject
    on
        QueryBuilder<
          WatchHistoryIsarModel,
          WatchHistoryIsarModel,
          QFilterCondition
        > {}

extension WatchHistoryIsarModelQueryLinks
    on
        QueryBuilder<
          WatchHistoryIsarModel,
          WatchHistoryIsarModel,
          QFilterCondition
        > {}

extension WatchHistoryIsarModelQuerySortBy
    on QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QSortBy> {
  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  sortByDurationMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMs', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  sortByDurationMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMs', Sort.desc);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  sortByIsRemote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRemote', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  sortByIsRemoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRemote', Sort.desc);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  sortByLocalVideoDateModified() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localVideoDateModified', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  sortByLocalVideoDateModifiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localVideoDateModified', Sort.desc);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  sortByLocalVideoId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localVideoId', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  sortByLocalVideoIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localVideoId', Sort.desc);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  sortByMediaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaId', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  sortByMediaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaId', Sort.desc);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  sortByMediaPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaPath', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  sortByMediaPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaPath', Sort.desc);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  sortByPositionMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'positionMs', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  sortByPositionMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'positionMs', Sort.desc);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  sortBySourceLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceLabel', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  sortBySourceLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceLabel', Sort.desc);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  sortByWatchedAtMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'watchedAtMs', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  sortByWatchedAtMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'watchedAtMs', Sort.desc);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  sortByWebDavAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'webDavAccountId', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  sortByWebDavAccountIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'webDavAccountId', Sort.desc);
    });
  }
}

extension WatchHistoryIsarModelQuerySortThenBy
    on QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QSortThenBy> {
  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  thenByDurationMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMs', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  thenByDurationMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMs', Sort.desc);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  thenByIsRemote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRemote', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  thenByIsRemoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRemote', Sort.desc);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  thenByLocalVideoDateModified() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localVideoDateModified', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  thenByLocalVideoDateModifiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localVideoDateModified', Sort.desc);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  thenByLocalVideoId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localVideoId', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  thenByLocalVideoIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localVideoId', Sort.desc);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  thenByMediaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaId', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  thenByMediaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaId', Sort.desc);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  thenByMediaPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaPath', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  thenByMediaPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaPath', Sort.desc);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  thenByPositionMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'positionMs', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  thenByPositionMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'positionMs', Sort.desc);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  thenBySourceLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceLabel', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  thenBySourceLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceLabel', Sort.desc);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  thenByWatchedAtMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'watchedAtMs', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  thenByWatchedAtMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'watchedAtMs', Sort.desc);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  thenByWebDavAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'webDavAccountId', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QAfterSortBy>
  thenByWebDavAccountIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'webDavAccountId', Sort.desc);
    });
  }
}

extension WatchHistoryIsarModelQueryWhereDistinct
    on QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QDistinct> {
  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QDistinct>
  distinctByDurationMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationMs');
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QDistinct>
  distinctByIsRemote() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isRemote');
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QDistinct>
  distinctByLocalVideoDateModified() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'localVideoDateModified');
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QDistinct>
  distinctByLocalVideoId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'localVideoId');
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QDistinct>
  distinctByMediaId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mediaId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QDistinct>
  distinctByMediaPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mediaPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QDistinct>
  distinctByPositionMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'positionMs');
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QDistinct>
  distinctBySourceLabel({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceLabel', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QDistinct>
  distinctByTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QDistinct>
  distinctByWatchedAtMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'watchedAtMs');
    });
  }

  QueryBuilder<WatchHistoryIsarModel, WatchHistoryIsarModel, QDistinct>
  distinctByWebDavAccountId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'webDavAccountId',
        caseSensitive: caseSensitive,
      );
    });
  }
}

extension WatchHistoryIsarModelQueryProperty
    on
        QueryBuilder<
          WatchHistoryIsarModel,
          WatchHistoryIsarModel,
          QQueryProperty
        > {
  QueryBuilder<WatchHistoryIsarModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WatchHistoryIsarModel, int, QQueryOperations>
  durationMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationMs');
    });
  }

  QueryBuilder<WatchHistoryIsarModel, bool, QQueryOperations>
  isRemoteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isRemote');
    });
  }

  QueryBuilder<WatchHistoryIsarModel, int?, QQueryOperations>
  localVideoDateModifiedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'localVideoDateModified');
    });
  }

  QueryBuilder<WatchHistoryIsarModel, int?, QQueryOperations>
  localVideoIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'localVideoId');
    });
  }

  QueryBuilder<WatchHistoryIsarModel, String, QQueryOperations>
  mediaIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mediaId');
    });
  }

  QueryBuilder<WatchHistoryIsarModel, String?, QQueryOperations>
  mediaPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mediaPath');
    });
  }

  QueryBuilder<WatchHistoryIsarModel, int, QQueryOperations>
  positionMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'positionMs');
    });
  }

  QueryBuilder<WatchHistoryIsarModel, String, QQueryOperations>
  sourceLabelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceLabel');
    });
  }

  QueryBuilder<WatchHistoryIsarModel, String, QQueryOperations>
  titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<WatchHistoryIsarModel, int, QQueryOperations>
  watchedAtMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'watchedAtMs');
    });
  }

  QueryBuilder<WatchHistoryIsarModel, String?, QQueryOperations>
  webDavAccountIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'webDavAccountId');
    });
  }
}
