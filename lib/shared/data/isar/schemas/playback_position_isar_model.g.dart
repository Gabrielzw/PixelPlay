// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playback_position_isar_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPlaybackPositionIsarModelCollection on Isar {
  IsarCollection<PlaybackPositionIsarModel> get playbackPositionIsarModels =>
      this.collection();
}

const PlaybackPositionIsarModelSchema = CollectionSchema(
  name: r'PlaybackPositionIsarModel',
  id: 3709067379806721393,
  properties: {
    r'durationMs': PropertySchema(
      id: 0,
      name: r'durationMs',
      type: IsarType.long,
    ),
    r'mediaId': PropertySchema(id: 1, name: r'mediaId', type: IsarType.string),
    r'positionMs': PropertySchema(
      id: 2,
      name: r'positionMs',
      type: IsarType.long,
    ),
  },

  estimateSize: _playbackPositionIsarModelEstimateSize,
  serialize: _playbackPositionIsarModelSerialize,
  deserialize: _playbackPositionIsarModelDeserialize,
  deserializeProp: _playbackPositionIsarModelDeserializeProp,
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

  getId: _playbackPositionIsarModelGetId,
  getLinks: _playbackPositionIsarModelGetLinks,
  attach: _playbackPositionIsarModelAttach,
  version: '3.3.0',
);

int _playbackPositionIsarModelEstimateSize(
  PlaybackPositionIsarModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.mediaId.length * 3;
  return bytesCount;
}

void _playbackPositionIsarModelSerialize(
  PlaybackPositionIsarModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.durationMs);
  writer.writeString(offsets[1], object.mediaId);
  writer.writeLong(offsets[2], object.positionMs);
}

PlaybackPositionIsarModel _playbackPositionIsarModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PlaybackPositionIsarModel();
  object.durationMs = reader.readLong(offsets[0]);
  object.id = id;
  object.mediaId = reader.readString(offsets[1]);
  object.positionMs = reader.readLong(offsets[2]);
  return object;
}

P _playbackPositionIsarModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _playbackPositionIsarModelGetId(PlaybackPositionIsarModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _playbackPositionIsarModelGetLinks(
  PlaybackPositionIsarModel object,
) {
  return [];
}

void _playbackPositionIsarModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  PlaybackPositionIsarModel object,
) {
  object.id = id;
}

extension PlaybackPositionIsarModelByIndex
    on IsarCollection<PlaybackPositionIsarModel> {
  Future<PlaybackPositionIsarModel?> getByMediaId(String mediaId) {
    return getByIndex(r'mediaId', [mediaId]);
  }

  PlaybackPositionIsarModel? getByMediaIdSync(String mediaId) {
    return getByIndexSync(r'mediaId', [mediaId]);
  }

  Future<bool> deleteByMediaId(String mediaId) {
    return deleteByIndex(r'mediaId', [mediaId]);
  }

  bool deleteByMediaIdSync(String mediaId) {
    return deleteByIndexSync(r'mediaId', [mediaId]);
  }

  Future<List<PlaybackPositionIsarModel?>> getAllByMediaId(
    List<String> mediaIdValues,
  ) {
    final values = mediaIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'mediaId', values);
  }

  List<PlaybackPositionIsarModel?> getAllByMediaIdSync(
    List<String> mediaIdValues,
  ) {
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

  Future<Id> putByMediaId(PlaybackPositionIsarModel object) {
    return putByIndex(r'mediaId', object);
  }

  Id putByMediaIdSync(
    PlaybackPositionIsarModel object, {
    bool saveLinks = true,
  }) {
    return putByIndexSync(r'mediaId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByMediaId(List<PlaybackPositionIsarModel> objects) {
    return putAllByIndex(r'mediaId', objects);
  }

  List<Id> putAllByMediaIdSync(
    List<PlaybackPositionIsarModel> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'mediaId', objects, saveLinks: saveLinks);
  }
}

extension PlaybackPositionIsarModelQueryWhereSort
    on
        QueryBuilder<
          PlaybackPositionIsarModel,
          PlaybackPositionIsarModel,
          QWhere
        > {
  QueryBuilder<
    PlaybackPositionIsarModel,
    PlaybackPositionIsarModel,
    QAfterWhere
  >
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PlaybackPositionIsarModelQueryWhere
    on
        QueryBuilder<
          PlaybackPositionIsarModel,
          PlaybackPositionIsarModel,
          QWhereClause
        > {
  QueryBuilder<
    PlaybackPositionIsarModel,
    PlaybackPositionIsarModel,
    QAfterWhereClause
  >
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<
    PlaybackPositionIsarModel,
    PlaybackPositionIsarModel,
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
    PlaybackPositionIsarModel,
    PlaybackPositionIsarModel,
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
    PlaybackPositionIsarModel,
    PlaybackPositionIsarModel,
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
    PlaybackPositionIsarModel,
    PlaybackPositionIsarModel,
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

  QueryBuilder<
    PlaybackPositionIsarModel,
    PlaybackPositionIsarModel,
    QAfterWhereClause
  >
  mediaIdEqualTo(String mediaId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'mediaId', value: [mediaId]),
      );
    });
  }

  QueryBuilder<
    PlaybackPositionIsarModel,
    PlaybackPositionIsarModel,
    QAfterWhereClause
  >
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

extension PlaybackPositionIsarModelQueryFilter
    on
        QueryBuilder<
          PlaybackPositionIsarModel,
          PlaybackPositionIsarModel,
          QFilterCondition
        > {
  QueryBuilder<
    PlaybackPositionIsarModel,
    PlaybackPositionIsarModel,
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
    PlaybackPositionIsarModel,
    PlaybackPositionIsarModel,
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
    PlaybackPositionIsarModel,
    PlaybackPositionIsarModel,
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
    PlaybackPositionIsarModel,
    PlaybackPositionIsarModel,
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
    PlaybackPositionIsarModel,
    PlaybackPositionIsarModel,
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
    PlaybackPositionIsarModel,
    PlaybackPositionIsarModel,
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
    PlaybackPositionIsarModel,
    PlaybackPositionIsarModel,
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
    PlaybackPositionIsarModel,
    PlaybackPositionIsarModel,
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
    PlaybackPositionIsarModel,
    PlaybackPositionIsarModel,
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
    PlaybackPositionIsarModel,
    PlaybackPositionIsarModel,
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
    PlaybackPositionIsarModel,
    PlaybackPositionIsarModel,
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
    PlaybackPositionIsarModel,
    PlaybackPositionIsarModel,
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
    PlaybackPositionIsarModel,
    PlaybackPositionIsarModel,
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
    PlaybackPositionIsarModel,
    PlaybackPositionIsarModel,
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
    PlaybackPositionIsarModel,
    PlaybackPositionIsarModel,
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
    PlaybackPositionIsarModel,
    PlaybackPositionIsarModel,
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
    PlaybackPositionIsarModel,
    PlaybackPositionIsarModel,
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
    PlaybackPositionIsarModel,
    PlaybackPositionIsarModel,
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
    PlaybackPositionIsarModel,
    PlaybackPositionIsarModel,
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
    PlaybackPositionIsarModel,
    PlaybackPositionIsarModel,
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
    PlaybackPositionIsarModel,
    PlaybackPositionIsarModel,
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
    PlaybackPositionIsarModel,
    PlaybackPositionIsarModel,
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
}

extension PlaybackPositionIsarModelQueryObject
    on
        QueryBuilder<
          PlaybackPositionIsarModel,
          PlaybackPositionIsarModel,
          QFilterCondition
        > {}

extension PlaybackPositionIsarModelQueryLinks
    on
        QueryBuilder<
          PlaybackPositionIsarModel,
          PlaybackPositionIsarModel,
          QFilterCondition
        > {}

extension PlaybackPositionIsarModelQuerySortBy
    on
        QueryBuilder<
          PlaybackPositionIsarModel,
          PlaybackPositionIsarModel,
          QSortBy
        > {
  QueryBuilder<
    PlaybackPositionIsarModel,
    PlaybackPositionIsarModel,
    QAfterSortBy
  >
  sortByDurationMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMs', Sort.asc);
    });
  }

  QueryBuilder<
    PlaybackPositionIsarModel,
    PlaybackPositionIsarModel,
    QAfterSortBy
  >
  sortByDurationMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMs', Sort.desc);
    });
  }

  QueryBuilder<
    PlaybackPositionIsarModel,
    PlaybackPositionIsarModel,
    QAfterSortBy
  >
  sortByMediaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaId', Sort.asc);
    });
  }

  QueryBuilder<
    PlaybackPositionIsarModel,
    PlaybackPositionIsarModel,
    QAfterSortBy
  >
  sortByMediaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaId', Sort.desc);
    });
  }

  QueryBuilder<
    PlaybackPositionIsarModel,
    PlaybackPositionIsarModel,
    QAfterSortBy
  >
  sortByPositionMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'positionMs', Sort.asc);
    });
  }

  QueryBuilder<
    PlaybackPositionIsarModel,
    PlaybackPositionIsarModel,
    QAfterSortBy
  >
  sortByPositionMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'positionMs', Sort.desc);
    });
  }
}

extension PlaybackPositionIsarModelQuerySortThenBy
    on
        QueryBuilder<
          PlaybackPositionIsarModel,
          PlaybackPositionIsarModel,
          QSortThenBy
        > {
  QueryBuilder<
    PlaybackPositionIsarModel,
    PlaybackPositionIsarModel,
    QAfterSortBy
  >
  thenByDurationMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMs', Sort.asc);
    });
  }

  QueryBuilder<
    PlaybackPositionIsarModel,
    PlaybackPositionIsarModel,
    QAfterSortBy
  >
  thenByDurationMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMs', Sort.desc);
    });
  }

  QueryBuilder<
    PlaybackPositionIsarModel,
    PlaybackPositionIsarModel,
    QAfterSortBy
  >
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<
    PlaybackPositionIsarModel,
    PlaybackPositionIsarModel,
    QAfterSortBy
  >
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<
    PlaybackPositionIsarModel,
    PlaybackPositionIsarModel,
    QAfterSortBy
  >
  thenByMediaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaId', Sort.asc);
    });
  }

  QueryBuilder<
    PlaybackPositionIsarModel,
    PlaybackPositionIsarModel,
    QAfterSortBy
  >
  thenByMediaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaId', Sort.desc);
    });
  }

  QueryBuilder<
    PlaybackPositionIsarModel,
    PlaybackPositionIsarModel,
    QAfterSortBy
  >
  thenByPositionMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'positionMs', Sort.asc);
    });
  }

  QueryBuilder<
    PlaybackPositionIsarModel,
    PlaybackPositionIsarModel,
    QAfterSortBy
  >
  thenByPositionMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'positionMs', Sort.desc);
    });
  }
}

extension PlaybackPositionIsarModelQueryWhereDistinct
    on
        QueryBuilder<
          PlaybackPositionIsarModel,
          PlaybackPositionIsarModel,
          QDistinct
        > {
  QueryBuilder<PlaybackPositionIsarModel, PlaybackPositionIsarModel, QDistinct>
  distinctByDurationMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationMs');
    });
  }

  QueryBuilder<PlaybackPositionIsarModel, PlaybackPositionIsarModel, QDistinct>
  distinctByMediaId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mediaId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlaybackPositionIsarModel, PlaybackPositionIsarModel, QDistinct>
  distinctByPositionMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'positionMs');
    });
  }
}

extension PlaybackPositionIsarModelQueryProperty
    on
        QueryBuilder<
          PlaybackPositionIsarModel,
          PlaybackPositionIsarModel,
          QQueryProperty
        > {
  QueryBuilder<PlaybackPositionIsarModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PlaybackPositionIsarModel, int, QQueryOperations>
  durationMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationMs');
    });
  }

  QueryBuilder<PlaybackPositionIsarModel, String, QQueryOperations>
  mediaIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mediaId');
    });
  }

  QueryBuilder<PlaybackPositionIsarModel, int, QQueryOperations>
  positionMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'positionMs');
    });
  }
}
