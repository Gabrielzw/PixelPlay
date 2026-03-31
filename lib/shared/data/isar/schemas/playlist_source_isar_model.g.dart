// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_source_isar_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPlaylistSourceIsarModelCollection on Isar {
  IsarCollection<PlaylistSourceIsarModel> get playlistSourceIsarModels =>
      this.collection();
}

const PlaylistSourceIsarModelSchema = CollectionSchema(
  name: r'PlaylistSourceIsarModel',
  id: -8913679084799759190,
  properties: {
    r'createdAtMs': PropertySchema(
      id: 0,
      name: r'createdAtMs',
      type: IsarType.long,
    ),
    r'entryId': PropertySchema(id: 1, name: r'entryId', type: IsarType.string),
    r'localAlbumBucketId': PropertySchema(
      id: 2,
      name: r'localAlbumBucketId',
      type: IsarType.string,
    ),
    r'localAlbumLatestDateAddedSeconds': PropertySchema(
      id: 3,
      name: r'localAlbumLatestDateAddedSeconds',
      type: IsarType.long,
    ),
    r'localAlbumLatestVideoDateModified': PropertySchema(
      id: 4,
      name: r'localAlbumLatestVideoDateModified',
      type: IsarType.long,
    ),
    r'localAlbumLatestVideoId': PropertySchema(
      id: 5,
      name: r'localAlbumLatestVideoId',
      type: IsarType.long,
    ),
    r'localAlbumLatestVideoPath': PropertySchema(
      id: 6,
      name: r'localAlbumLatestVideoPath',
      type: IsarType.string,
    ),
    r'localAlbumName': PropertySchema(
      id: 7,
      name: r'localAlbumName',
      type: IsarType.string,
    ),
    r'localAlbumVideoCount': PropertySchema(
      id: 8,
      name: r'localAlbumVideoCount',
      type: IsarType.long,
    ),
    r'sourceKindKey': PropertySchema(
      id: 9,
      name: r'sourceKindKey',
      type: IsarType.string,
    ),
    r'title': PropertySchema(id: 10, name: r'title', type: IsarType.string),
    r'webDavAccountAlias': PropertySchema(
      id: 11,
      name: r'webDavAccountAlias',
      type: IsarType.string,
    ),
    r'webDavAccountId': PropertySchema(
      id: 12,
      name: r'webDavAccountId',
      type: IsarType.string,
    ),
    r'webDavDirectoryPath': PropertySchema(
      id: 13,
      name: r'webDavDirectoryPath',
      type: IsarType.string,
    ),
  },

  estimateSize: _playlistSourceIsarModelEstimateSize,
  serialize: _playlistSourceIsarModelSerialize,
  deserialize: _playlistSourceIsarModelDeserialize,
  deserializeProp: _playlistSourceIsarModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'entryId': IndexSchema(
      id: 3733379884318738402,
      name: r'entryId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'entryId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _playlistSourceIsarModelGetId,
  getLinks: _playlistSourceIsarModelGetLinks,
  attach: _playlistSourceIsarModelAttach,
  version: '3.3.0',
);

int _playlistSourceIsarModelEstimateSize(
  PlaylistSourceIsarModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.entryId.length * 3;
  {
    final value = object.localAlbumBucketId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.localAlbumLatestVideoPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.localAlbumName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.sourceKindKey.length * 3;
  bytesCount += 3 + object.title.length * 3;
  {
    final value = object.webDavAccountAlias;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.webDavAccountId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.webDavDirectoryPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _playlistSourceIsarModelSerialize(
  PlaylistSourceIsarModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.createdAtMs);
  writer.writeString(offsets[1], object.entryId);
  writer.writeString(offsets[2], object.localAlbumBucketId);
  writer.writeLong(offsets[3], object.localAlbumLatestDateAddedSeconds);
  writer.writeLong(offsets[4], object.localAlbumLatestVideoDateModified);
  writer.writeLong(offsets[5], object.localAlbumLatestVideoId);
  writer.writeString(offsets[6], object.localAlbumLatestVideoPath);
  writer.writeString(offsets[7], object.localAlbumName);
  writer.writeLong(offsets[8], object.localAlbumVideoCount);
  writer.writeString(offsets[9], object.sourceKindKey);
  writer.writeString(offsets[10], object.title);
  writer.writeString(offsets[11], object.webDavAccountAlias);
  writer.writeString(offsets[12], object.webDavAccountId);
  writer.writeString(offsets[13], object.webDavDirectoryPath);
}

PlaylistSourceIsarModel _playlistSourceIsarModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PlaylistSourceIsarModel();
  object.createdAtMs = reader.readLong(offsets[0]);
  object.entryId = reader.readString(offsets[1]);
  object.id = id;
  object.localAlbumBucketId = reader.readStringOrNull(offsets[2]);
  object.localAlbumLatestDateAddedSeconds = reader.readLongOrNull(offsets[3]);
  object.localAlbumLatestVideoDateModified = reader.readLongOrNull(offsets[4]);
  object.localAlbumLatestVideoId = reader.readLongOrNull(offsets[5]);
  object.localAlbumLatestVideoPath = reader.readStringOrNull(offsets[6]);
  object.localAlbumName = reader.readStringOrNull(offsets[7]);
  object.localAlbumVideoCount = reader.readLongOrNull(offsets[8]);
  object.sourceKindKey = reader.readString(offsets[9]);
  object.title = reader.readString(offsets[10]);
  object.webDavAccountAlias = reader.readStringOrNull(offsets[11]);
  object.webDavAccountId = reader.readStringOrNull(offsets[12]);
  object.webDavDirectoryPath = reader.readStringOrNull(offsets[13]);
  return object;
}

P _playlistSourceIsarModelDeserializeProp<P>(
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
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readLongOrNull(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _playlistSourceIsarModelGetId(PlaylistSourceIsarModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _playlistSourceIsarModelGetLinks(
  PlaylistSourceIsarModel object,
) {
  return [];
}

void _playlistSourceIsarModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  PlaylistSourceIsarModel object,
) {
  object.id = id;
}

extension PlaylistSourceIsarModelByIndex
    on IsarCollection<PlaylistSourceIsarModel> {
  Future<PlaylistSourceIsarModel?> getByEntryId(String entryId) {
    return getByIndex(r'entryId', [entryId]);
  }

  PlaylistSourceIsarModel? getByEntryIdSync(String entryId) {
    return getByIndexSync(r'entryId', [entryId]);
  }

  Future<bool> deleteByEntryId(String entryId) {
    return deleteByIndex(r'entryId', [entryId]);
  }

  bool deleteByEntryIdSync(String entryId) {
    return deleteByIndexSync(r'entryId', [entryId]);
  }

  Future<List<PlaylistSourceIsarModel?>> getAllByEntryId(
    List<String> entryIdValues,
  ) {
    final values = entryIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'entryId', values);
  }

  List<PlaylistSourceIsarModel?> getAllByEntryIdSync(
    List<String> entryIdValues,
  ) {
    final values = entryIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'entryId', values);
  }

  Future<int> deleteAllByEntryId(List<String> entryIdValues) {
    final values = entryIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'entryId', values);
  }

  int deleteAllByEntryIdSync(List<String> entryIdValues) {
    final values = entryIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'entryId', values);
  }

  Future<Id> putByEntryId(PlaylistSourceIsarModel object) {
    return putByIndex(r'entryId', object);
  }

  Id putByEntryIdSync(PlaylistSourceIsarModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'entryId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByEntryId(List<PlaylistSourceIsarModel> objects) {
    return putAllByIndex(r'entryId', objects);
  }

  List<Id> putAllByEntryIdSync(
    List<PlaylistSourceIsarModel> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'entryId', objects, saveLinks: saveLinks);
  }
}

extension PlaylistSourceIsarModelQueryWhereSort
    on QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QWhere> {
  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PlaylistSourceIsarModelQueryWhere
    on
        QueryBuilder<
          PlaylistSourceIsarModel,
          PlaylistSourceIsarModel,
          QWhereClause
        > {
  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterWhereClause
  >
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
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
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
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
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
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
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
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
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterWhereClause
  >
  entryIdEqualTo(String entryId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'entryId', value: [entryId]),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterWhereClause
  >
  entryIdNotEqualTo(String entryId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'entryId',
                lower: [],
                upper: [entryId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'entryId',
                lower: [entryId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'entryId',
                lower: [entryId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'entryId',
                lower: [],
                upper: [entryId],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension PlaylistSourceIsarModelQueryFilter
    on
        QueryBuilder<
          PlaylistSourceIsarModel,
          PlaylistSourceIsarModel,
          QFilterCondition
        > {
  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  createdAtMsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAtMs', value: value),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  createdAtMsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'createdAtMs',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  createdAtMsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'createdAtMs',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  createdAtMsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'createdAtMs',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  entryIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'entryId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  entryIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'entryId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  entryIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'entryId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  entryIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'entryId',
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
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  entryIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'entryId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  entryIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'entryId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  entryIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'entryId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  entryIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'entryId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  entryIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'entryId', value: ''),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  entryIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'entryId', value: ''),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
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
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
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
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
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
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
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
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumBucketIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'localAlbumBucketId'),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumBucketIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'localAlbumBucketId'),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumBucketIdEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'localAlbumBucketId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumBucketIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'localAlbumBucketId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumBucketIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'localAlbumBucketId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumBucketIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'localAlbumBucketId',
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
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumBucketIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'localAlbumBucketId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumBucketIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'localAlbumBucketId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumBucketIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'localAlbumBucketId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumBucketIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'localAlbumBucketId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumBucketIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'localAlbumBucketId', value: ''),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumBucketIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'localAlbumBucketId', value: ''),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumLatestDateAddedSecondsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'localAlbumLatestDateAddedSeconds',
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumLatestDateAddedSecondsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'localAlbumLatestDateAddedSeconds',
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumLatestDateAddedSecondsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'localAlbumLatestDateAddedSeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumLatestDateAddedSecondsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'localAlbumLatestDateAddedSeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumLatestDateAddedSecondsLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'localAlbumLatestDateAddedSeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumLatestDateAddedSecondsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'localAlbumLatestDateAddedSeconds',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumLatestVideoDateModifiedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'localAlbumLatestVideoDateModified',
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumLatestVideoDateModifiedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'localAlbumLatestVideoDateModified',
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumLatestVideoDateModifiedEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'localAlbumLatestVideoDateModified',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumLatestVideoDateModifiedGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'localAlbumLatestVideoDateModified',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumLatestVideoDateModifiedLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'localAlbumLatestVideoDateModified',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumLatestVideoDateModifiedBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'localAlbumLatestVideoDateModified',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumLatestVideoIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'localAlbumLatestVideoId'),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumLatestVideoIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'localAlbumLatestVideoId'),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumLatestVideoIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'localAlbumLatestVideoId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumLatestVideoIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'localAlbumLatestVideoId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumLatestVideoIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'localAlbumLatestVideoId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumLatestVideoIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'localAlbumLatestVideoId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumLatestVideoPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'localAlbumLatestVideoPath'),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumLatestVideoPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'localAlbumLatestVideoPath'),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumLatestVideoPathEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'localAlbumLatestVideoPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumLatestVideoPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'localAlbumLatestVideoPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumLatestVideoPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'localAlbumLatestVideoPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumLatestVideoPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'localAlbumLatestVideoPath',
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
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumLatestVideoPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'localAlbumLatestVideoPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumLatestVideoPathEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'localAlbumLatestVideoPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumLatestVideoPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'localAlbumLatestVideoPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumLatestVideoPathMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'localAlbumLatestVideoPath',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumLatestVideoPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'localAlbumLatestVideoPath',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumLatestVideoPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'localAlbumLatestVideoPath',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'localAlbumName'),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'localAlbumName'),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumNameEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'localAlbumName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'localAlbumName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'localAlbumName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'localAlbumName',
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
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'localAlbumName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'localAlbumName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'localAlbumName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'localAlbumName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'localAlbumName', value: ''),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'localAlbumName', value: ''),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumVideoCountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'localAlbumVideoCount'),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumVideoCountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'localAlbumVideoCount'),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumVideoCountEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'localAlbumVideoCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumVideoCountGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'localAlbumVideoCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumVideoCountLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'localAlbumVideoCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  localAlbumVideoCountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'localAlbumVideoCount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  sourceKindKeyEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'sourceKindKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  sourceKindKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sourceKindKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  sourceKindKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sourceKindKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  sourceKindKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sourceKindKey',
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
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  sourceKindKeyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'sourceKindKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  sourceKindKeyEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'sourceKindKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  sourceKindKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'sourceKindKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  sourceKindKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'sourceKindKey',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  sourceKindKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sourceKindKey', value: ''),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  sourceKindKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'sourceKindKey', value: ''),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
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
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
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
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
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
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
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
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
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
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
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
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
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
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
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
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
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
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
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
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  webDavAccountAliasIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'webDavAccountAlias'),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  webDavAccountAliasIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'webDavAccountAlias'),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  webDavAccountAliasEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'webDavAccountAlias',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  webDavAccountAliasGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'webDavAccountAlias',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  webDavAccountAliasLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'webDavAccountAlias',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  webDavAccountAliasBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'webDavAccountAlias',
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
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  webDavAccountAliasStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'webDavAccountAlias',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  webDavAccountAliasEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'webDavAccountAlias',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  webDavAccountAliasContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'webDavAccountAlias',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  webDavAccountAliasMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'webDavAccountAlias',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  webDavAccountAliasIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'webDavAccountAlias', value: ''),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  webDavAccountAliasIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'webDavAccountAlias', value: ''),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
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
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
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
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
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
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
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
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
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
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
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
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
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
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
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
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
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
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
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
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
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
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  webDavAccountIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'webDavAccountId', value: ''),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  webDavDirectoryPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'webDavDirectoryPath'),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  webDavDirectoryPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'webDavDirectoryPath'),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  webDavDirectoryPathEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'webDavDirectoryPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  webDavDirectoryPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'webDavDirectoryPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  webDavDirectoryPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'webDavDirectoryPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  webDavDirectoryPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'webDavDirectoryPath',
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
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  webDavDirectoryPathStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'webDavDirectoryPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  webDavDirectoryPathEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'webDavDirectoryPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  webDavDirectoryPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'webDavDirectoryPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  webDavDirectoryPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'webDavDirectoryPath',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  webDavDirectoryPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'webDavDirectoryPath', value: ''),
      );
    });
  }

  QueryBuilder<
    PlaylistSourceIsarModel,
    PlaylistSourceIsarModel,
    QAfterFilterCondition
  >
  webDavDirectoryPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'webDavDirectoryPath',
          value: '',
        ),
      );
    });
  }
}

extension PlaylistSourceIsarModelQueryObject
    on
        QueryBuilder<
          PlaylistSourceIsarModel,
          PlaylistSourceIsarModel,
          QFilterCondition
        > {}

extension PlaylistSourceIsarModelQueryLinks
    on
        QueryBuilder<
          PlaylistSourceIsarModel,
          PlaylistSourceIsarModel,
          QFilterCondition
        > {}

extension PlaylistSourceIsarModelQuerySortBy
    on QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QSortBy> {
  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  sortByCreatedAtMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtMs', Sort.asc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  sortByCreatedAtMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtMs', Sort.desc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  sortByEntryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entryId', Sort.asc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  sortByEntryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entryId', Sort.desc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  sortByLocalAlbumBucketId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localAlbumBucketId', Sort.asc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  sortByLocalAlbumBucketIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localAlbumBucketId', Sort.desc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  sortByLocalAlbumLatestDateAddedSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localAlbumLatestDateAddedSeconds', Sort.asc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  sortByLocalAlbumLatestDateAddedSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localAlbumLatestDateAddedSeconds', Sort.desc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  sortByLocalAlbumLatestVideoDateModified() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localAlbumLatestVideoDateModified', Sort.asc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  sortByLocalAlbumLatestVideoDateModifiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localAlbumLatestVideoDateModified', Sort.desc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  sortByLocalAlbumLatestVideoId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localAlbumLatestVideoId', Sort.asc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  sortByLocalAlbumLatestVideoIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localAlbumLatestVideoId', Sort.desc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  sortByLocalAlbumLatestVideoPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localAlbumLatestVideoPath', Sort.asc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  sortByLocalAlbumLatestVideoPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localAlbumLatestVideoPath', Sort.desc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  sortByLocalAlbumName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localAlbumName', Sort.asc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  sortByLocalAlbumNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localAlbumName', Sort.desc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  sortByLocalAlbumVideoCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localAlbumVideoCount', Sort.asc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  sortByLocalAlbumVideoCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localAlbumVideoCount', Sort.desc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  sortBySourceKindKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceKindKey', Sort.asc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  sortBySourceKindKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceKindKey', Sort.desc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  sortByWebDavAccountAlias() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'webDavAccountAlias', Sort.asc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  sortByWebDavAccountAliasDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'webDavAccountAlias', Sort.desc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  sortByWebDavAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'webDavAccountId', Sort.asc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  sortByWebDavAccountIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'webDavAccountId', Sort.desc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  sortByWebDavDirectoryPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'webDavDirectoryPath', Sort.asc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  sortByWebDavDirectoryPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'webDavDirectoryPath', Sort.desc);
    });
  }
}

extension PlaylistSourceIsarModelQuerySortThenBy
    on
        QueryBuilder<
          PlaylistSourceIsarModel,
          PlaylistSourceIsarModel,
          QSortThenBy
        > {
  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  thenByCreatedAtMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtMs', Sort.asc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  thenByCreatedAtMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtMs', Sort.desc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  thenByEntryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entryId', Sort.asc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  thenByEntryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entryId', Sort.desc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  thenByLocalAlbumBucketId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localAlbumBucketId', Sort.asc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  thenByLocalAlbumBucketIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localAlbumBucketId', Sort.desc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  thenByLocalAlbumLatestDateAddedSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localAlbumLatestDateAddedSeconds', Sort.asc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  thenByLocalAlbumLatestDateAddedSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localAlbumLatestDateAddedSeconds', Sort.desc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  thenByLocalAlbumLatestVideoDateModified() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localAlbumLatestVideoDateModified', Sort.asc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  thenByLocalAlbumLatestVideoDateModifiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localAlbumLatestVideoDateModified', Sort.desc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  thenByLocalAlbumLatestVideoId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localAlbumLatestVideoId', Sort.asc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  thenByLocalAlbumLatestVideoIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localAlbumLatestVideoId', Sort.desc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  thenByLocalAlbumLatestVideoPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localAlbumLatestVideoPath', Sort.asc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  thenByLocalAlbumLatestVideoPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localAlbumLatestVideoPath', Sort.desc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  thenByLocalAlbumName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localAlbumName', Sort.asc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  thenByLocalAlbumNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localAlbumName', Sort.desc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  thenByLocalAlbumVideoCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localAlbumVideoCount', Sort.asc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  thenByLocalAlbumVideoCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localAlbumVideoCount', Sort.desc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  thenBySourceKindKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceKindKey', Sort.asc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  thenBySourceKindKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceKindKey', Sort.desc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  thenByWebDavAccountAlias() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'webDavAccountAlias', Sort.asc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  thenByWebDavAccountAliasDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'webDavAccountAlias', Sort.desc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  thenByWebDavAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'webDavAccountId', Sort.asc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  thenByWebDavAccountIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'webDavAccountId', Sort.desc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  thenByWebDavDirectoryPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'webDavDirectoryPath', Sort.asc);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QAfterSortBy>
  thenByWebDavDirectoryPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'webDavDirectoryPath', Sort.desc);
    });
  }
}

extension PlaylistSourceIsarModelQueryWhereDistinct
    on
        QueryBuilder<
          PlaylistSourceIsarModel,
          PlaylistSourceIsarModel,
          QDistinct
        > {
  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QDistinct>
  distinctByCreatedAtMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAtMs');
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QDistinct>
  distinctByEntryId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'entryId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QDistinct>
  distinctByLocalAlbumBucketId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'localAlbumBucketId',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QDistinct>
  distinctByLocalAlbumLatestDateAddedSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'localAlbumLatestDateAddedSeconds');
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QDistinct>
  distinctByLocalAlbumLatestVideoDateModified() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'localAlbumLatestVideoDateModified');
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QDistinct>
  distinctByLocalAlbumLatestVideoId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'localAlbumLatestVideoId');
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QDistinct>
  distinctByLocalAlbumLatestVideoPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'localAlbumLatestVideoPath',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QDistinct>
  distinctByLocalAlbumName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'localAlbumName',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QDistinct>
  distinctByLocalAlbumVideoCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'localAlbumVideoCount');
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QDistinct>
  distinctBySourceKindKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'sourceKindKey',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QDistinct>
  distinctByTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QDistinct>
  distinctByWebDavAccountAlias({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'webDavAccountAlias',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QDistinct>
  distinctByWebDavAccountId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'webDavAccountId',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, PlaylistSourceIsarModel, QDistinct>
  distinctByWebDavDirectoryPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'webDavDirectoryPath',
        caseSensitive: caseSensitive,
      );
    });
  }
}

extension PlaylistSourceIsarModelQueryProperty
    on
        QueryBuilder<
          PlaylistSourceIsarModel,
          PlaylistSourceIsarModel,
          QQueryProperty
        > {
  QueryBuilder<PlaylistSourceIsarModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, int, QQueryOperations>
  createdAtMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAtMs');
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, String, QQueryOperations>
  entryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'entryId');
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, String?, QQueryOperations>
  localAlbumBucketIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'localAlbumBucketId');
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, int?, QQueryOperations>
  localAlbumLatestDateAddedSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'localAlbumLatestDateAddedSeconds');
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, int?, QQueryOperations>
  localAlbumLatestVideoDateModifiedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'localAlbumLatestVideoDateModified');
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, int?, QQueryOperations>
  localAlbumLatestVideoIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'localAlbumLatestVideoId');
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, String?, QQueryOperations>
  localAlbumLatestVideoPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'localAlbumLatestVideoPath');
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, String?, QQueryOperations>
  localAlbumNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'localAlbumName');
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, int?, QQueryOperations>
  localAlbumVideoCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'localAlbumVideoCount');
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, String, QQueryOperations>
  sourceKindKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceKindKey');
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, String, QQueryOperations>
  titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, String?, QQueryOperations>
  webDavAccountAliasProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'webDavAccountAlias');
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, String?, QQueryOperations>
  webDavAccountIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'webDavAccountId');
    });
  }

  QueryBuilder<PlaylistSourceIsarModel, String?, QQueryOperations>
  webDavDirectoryPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'webDavDirectoryPath');
    });
  }
}
