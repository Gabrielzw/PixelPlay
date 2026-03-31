// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_folder_isar_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFavoriteFolderIsarModelCollection on Isar {
  IsarCollection<FavoriteFolderIsarModel> get favoriteFolderIsarModels =>
      this.collection();
}

const FavoriteFolderIsarModelSchema = CollectionSchema(
  name: r'FavoriteFolderIsarModel',
  id: -9038930448134034385,
  properties: {
    r'createdAtMs': PropertySchema(
      id: 0,
      name: r'createdAtMs',
      type: IsarType.long,
    ),
    r'folderId': PropertySchema(
      id: 1,
      name: r'folderId',
      type: IsarType.string,
    ),
    r'title': PropertySchema(id: 2, name: r'title', type: IsarType.string),
    r'videos': PropertySchema(
      id: 3,
      name: r'videos',
      type: IsarType.objectList,

      target: r'FavoriteVideoIsarModel',
    ),
  },

  estimateSize: _favoriteFolderIsarModelEstimateSize,
  serialize: _favoriteFolderIsarModelSerialize,
  deserialize: _favoriteFolderIsarModelDeserialize,
  deserializeProp: _favoriteFolderIsarModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'folderId': IndexSchema(
      id: 6340065978996931043,
      name: r'folderId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'folderId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {
    r'FavoriteVideoIsarModel': FavoriteVideoIsarModelSchema,
    r'FavoriteThumbnailRequestIsarModel':
        FavoriteThumbnailRequestIsarModelSchema,
  },

  getId: _favoriteFolderIsarModelGetId,
  getLinks: _favoriteFolderIsarModelGetLinks,
  attach: _favoriteFolderIsarModelAttach,
  version: '3.3.0',
);

int _favoriteFolderIsarModelEstimateSize(
  FavoriteFolderIsarModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.folderId.length * 3;
  bytesCount += 3 + object.title.length * 3;
  bytesCount += 3 + object.videos.length * 3;
  {
    final offsets = allOffsets[FavoriteVideoIsarModel]!;
    for (var i = 0; i < object.videos.length; i++) {
      final value = object.videos[i];
      bytesCount += FavoriteVideoIsarModelSchema.estimateSize(
        value,
        offsets,
        allOffsets,
      );
    }
  }
  return bytesCount;
}

void _favoriteFolderIsarModelSerialize(
  FavoriteFolderIsarModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.createdAtMs);
  writer.writeString(offsets[1], object.folderId);
  writer.writeString(offsets[2], object.title);
  writer.writeObjectList<FavoriteVideoIsarModel>(
    offsets[3],
    allOffsets,
    FavoriteVideoIsarModelSchema.serialize,
    object.videos,
  );
}

FavoriteFolderIsarModel _favoriteFolderIsarModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FavoriteFolderIsarModel();
  object.createdAtMs = reader.readLong(offsets[0]);
  object.folderId = reader.readString(offsets[1]);
  object.id = id;
  object.title = reader.readString(offsets[2]);
  object.videos =
      reader.readObjectList<FavoriteVideoIsarModel>(
        offsets[3],
        FavoriteVideoIsarModelSchema.deserialize,
        allOffsets,
        FavoriteVideoIsarModel(),
      ) ??
      [];
  return object;
}

P _favoriteFolderIsarModelDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readObjectList<FavoriteVideoIsarModel>(
                offset,
                FavoriteVideoIsarModelSchema.deserialize,
                allOffsets,
                FavoriteVideoIsarModel(),
              ) ??
              [])
          as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _favoriteFolderIsarModelGetId(FavoriteFolderIsarModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _favoriteFolderIsarModelGetLinks(
  FavoriteFolderIsarModel object,
) {
  return [];
}

void _favoriteFolderIsarModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  FavoriteFolderIsarModel object,
) {
  object.id = id;
}

extension FavoriteFolderIsarModelByIndex
    on IsarCollection<FavoriteFolderIsarModel> {
  Future<FavoriteFolderIsarModel?> getByFolderId(String folderId) {
    return getByIndex(r'folderId', [folderId]);
  }

  FavoriteFolderIsarModel? getByFolderIdSync(String folderId) {
    return getByIndexSync(r'folderId', [folderId]);
  }

  Future<bool> deleteByFolderId(String folderId) {
    return deleteByIndex(r'folderId', [folderId]);
  }

  bool deleteByFolderIdSync(String folderId) {
    return deleteByIndexSync(r'folderId', [folderId]);
  }

  Future<List<FavoriteFolderIsarModel?>> getAllByFolderId(
    List<String> folderIdValues,
  ) {
    final values = folderIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'folderId', values);
  }

  List<FavoriteFolderIsarModel?> getAllByFolderIdSync(
    List<String> folderIdValues,
  ) {
    final values = folderIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'folderId', values);
  }

  Future<int> deleteAllByFolderId(List<String> folderIdValues) {
    final values = folderIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'folderId', values);
  }

  int deleteAllByFolderIdSync(List<String> folderIdValues) {
    final values = folderIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'folderId', values);
  }

  Future<Id> putByFolderId(FavoriteFolderIsarModel object) {
    return putByIndex(r'folderId', object);
  }

  Id putByFolderIdSync(
    FavoriteFolderIsarModel object, {
    bool saveLinks = true,
  }) {
    return putByIndexSync(r'folderId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByFolderId(List<FavoriteFolderIsarModel> objects) {
    return putAllByIndex(r'folderId', objects);
  }

  List<Id> putAllByFolderIdSync(
    List<FavoriteFolderIsarModel> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'folderId', objects, saveLinks: saveLinks);
  }
}

extension FavoriteFolderIsarModelQueryWhereSort
    on QueryBuilder<FavoriteFolderIsarModel, FavoriteFolderIsarModel, QWhere> {
  QueryBuilder<FavoriteFolderIsarModel, FavoriteFolderIsarModel, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension FavoriteFolderIsarModelQueryWhere
    on
        QueryBuilder<
          FavoriteFolderIsarModel,
          FavoriteFolderIsarModel,
          QWhereClause
        > {
  QueryBuilder<
    FavoriteFolderIsarModel,
    FavoriteFolderIsarModel,
    QAfterWhereClause
  >
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<
    FavoriteFolderIsarModel,
    FavoriteFolderIsarModel,
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
    FavoriteFolderIsarModel,
    FavoriteFolderIsarModel,
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
    FavoriteFolderIsarModel,
    FavoriteFolderIsarModel,
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
    FavoriteFolderIsarModel,
    FavoriteFolderIsarModel,
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
    FavoriteFolderIsarModel,
    FavoriteFolderIsarModel,
    QAfterWhereClause
  >
  folderIdEqualTo(String folderId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'folderId', value: [folderId]),
      );
    });
  }

  QueryBuilder<
    FavoriteFolderIsarModel,
    FavoriteFolderIsarModel,
    QAfterWhereClause
  >
  folderIdNotEqualTo(String folderId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'folderId',
                lower: [],
                upper: [folderId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'folderId',
                lower: [folderId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'folderId',
                lower: [folderId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'folderId',
                lower: [],
                upper: [folderId],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension FavoriteFolderIsarModelQueryFilter
    on
        QueryBuilder<
          FavoriteFolderIsarModel,
          FavoriteFolderIsarModel,
          QFilterCondition
        > {
  QueryBuilder<
    FavoriteFolderIsarModel,
    FavoriteFolderIsarModel,
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
    FavoriteFolderIsarModel,
    FavoriteFolderIsarModel,
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
    FavoriteFolderIsarModel,
    FavoriteFolderIsarModel,
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
    FavoriteFolderIsarModel,
    FavoriteFolderIsarModel,
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
    FavoriteFolderIsarModel,
    FavoriteFolderIsarModel,
    QAfterFilterCondition
  >
  folderIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'folderId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteFolderIsarModel,
    FavoriteFolderIsarModel,
    QAfterFilterCondition
  >
  folderIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'folderId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteFolderIsarModel,
    FavoriteFolderIsarModel,
    QAfterFilterCondition
  >
  folderIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'folderId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteFolderIsarModel,
    FavoriteFolderIsarModel,
    QAfterFilterCondition
  >
  folderIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'folderId',
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
    FavoriteFolderIsarModel,
    FavoriteFolderIsarModel,
    QAfterFilterCondition
  >
  folderIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'folderId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteFolderIsarModel,
    FavoriteFolderIsarModel,
    QAfterFilterCondition
  >
  folderIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'folderId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteFolderIsarModel,
    FavoriteFolderIsarModel,
    QAfterFilterCondition
  >
  folderIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'folderId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteFolderIsarModel,
    FavoriteFolderIsarModel,
    QAfterFilterCondition
  >
  folderIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'folderId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteFolderIsarModel,
    FavoriteFolderIsarModel,
    QAfterFilterCondition
  >
  folderIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'folderId', value: ''),
      );
    });
  }

  QueryBuilder<
    FavoriteFolderIsarModel,
    FavoriteFolderIsarModel,
    QAfterFilterCondition
  >
  folderIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'folderId', value: ''),
      );
    });
  }

  QueryBuilder<
    FavoriteFolderIsarModel,
    FavoriteFolderIsarModel,
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
    FavoriteFolderIsarModel,
    FavoriteFolderIsarModel,
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
    FavoriteFolderIsarModel,
    FavoriteFolderIsarModel,
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
    FavoriteFolderIsarModel,
    FavoriteFolderIsarModel,
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
    FavoriteFolderIsarModel,
    FavoriteFolderIsarModel,
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
    FavoriteFolderIsarModel,
    FavoriteFolderIsarModel,
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
    FavoriteFolderIsarModel,
    FavoriteFolderIsarModel,
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
    FavoriteFolderIsarModel,
    FavoriteFolderIsarModel,
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
    FavoriteFolderIsarModel,
    FavoriteFolderIsarModel,
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
    FavoriteFolderIsarModel,
    FavoriteFolderIsarModel,
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
    FavoriteFolderIsarModel,
    FavoriteFolderIsarModel,
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
    FavoriteFolderIsarModel,
    FavoriteFolderIsarModel,
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
    FavoriteFolderIsarModel,
    FavoriteFolderIsarModel,
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
    FavoriteFolderIsarModel,
    FavoriteFolderIsarModel,
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
    FavoriteFolderIsarModel,
    FavoriteFolderIsarModel,
    QAfterFilterCondition
  >
  videosLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'videos', length, true, length, true);
    });
  }

  QueryBuilder<
    FavoriteFolderIsarModel,
    FavoriteFolderIsarModel,
    QAfterFilterCondition
  >
  videosIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'videos', 0, true, 0, true);
    });
  }

  QueryBuilder<
    FavoriteFolderIsarModel,
    FavoriteFolderIsarModel,
    QAfterFilterCondition
  >
  videosIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'videos', 0, false, 999999, true);
    });
  }

  QueryBuilder<
    FavoriteFolderIsarModel,
    FavoriteFolderIsarModel,
    QAfterFilterCondition
  >
  videosLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'videos', 0, true, length, include);
    });
  }

  QueryBuilder<
    FavoriteFolderIsarModel,
    FavoriteFolderIsarModel,
    QAfterFilterCondition
  >
  videosLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'videos', length, include, 999999, true);
    });
  }

  QueryBuilder<
    FavoriteFolderIsarModel,
    FavoriteFolderIsarModel,
    QAfterFilterCondition
  >
  videosLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'videos',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension FavoriteFolderIsarModelQueryObject
    on
        QueryBuilder<
          FavoriteFolderIsarModel,
          FavoriteFolderIsarModel,
          QFilterCondition
        > {
  QueryBuilder<
    FavoriteFolderIsarModel,
    FavoriteFolderIsarModel,
    QAfterFilterCondition
  >
  videosElement(FilterQuery<FavoriteVideoIsarModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'videos');
    });
  }
}

extension FavoriteFolderIsarModelQueryLinks
    on
        QueryBuilder<
          FavoriteFolderIsarModel,
          FavoriteFolderIsarModel,
          QFilterCondition
        > {}

extension FavoriteFolderIsarModelQuerySortBy
    on QueryBuilder<FavoriteFolderIsarModel, FavoriteFolderIsarModel, QSortBy> {
  QueryBuilder<FavoriteFolderIsarModel, FavoriteFolderIsarModel, QAfterSortBy>
  sortByCreatedAtMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtMs', Sort.asc);
    });
  }

  QueryBuilder<FavoriteFolderIsarModel, FavoriteFolderIsarModel, QAfterSortBy>
  sortByCreatedAtMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtMs', Sort.desc);
    });
  }

  QueryBuilder<FavoriteFolderIsarModel, FavoriteFolderIsarModel, QAfterSortBy>
  sortByFolderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folderId', Sort.asc);
    });
  }

  QueryBuilder<FavoriteFolderIsarModel, FavoriteFolderIsarModel, QAfterSortBy>
  sortByFolderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folderId', Sort.desc);
    });
  }

  QueryBuilder<FavoriteFolderIsarModel, FavoriteFolderIsarModel, QAfterSortBy>
  sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<FavoriteFolderIsarModel, FavoriteFolderIsarModel, QAfterSortBy>
  sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension FavoriteFolderIsarModelQuerySortThenBy
    on
        QueryBuilder<
          FavoriteFolderIsarModel,
          FavoriteFolderIsarModel,
          QSortThenBy
        > {
  QueryBuilder<FavoriteFolderIsarModel, FavoriteFolderIsarModel, QAfterSortBy>
  thenByCreatedAtMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtMs', Sort.asc);
    });
  }

  QueryBuilder<FavoriteFolderIsarModel, FavoriteFolderIsarModel, QAfterSortBy>
  thenByCreatedAtMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtMs', Sort.desc);
    });
  }

  QueryBuilder<FavoriteFolderIsarModel, FavoriteFolderIsarModel, QAfterSortBy>
  thenByFolderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folderId', Sort.asc);
    });
  }

  QueryBuilder<FavoriteFolderIsarModel, FavoriteFolderIsarModel, QAfterSortBy>
  thenByFolderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folderId', Sort.desc);
    });
  }

  QueryBuilder<FavoriteFolderIsarModel, FavoriteFolderIsarModel, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FavoriteFolderIsarModel, FavoriteFolderIsarModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FavoriteFolderIsarModel, FavoriteFolderIsarModel, QAfterSortBy>
  thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<FavoriteFolderIsarModel, FavoriteFolderIsarModel, QAfterSortBy>
  thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension FavoriteFolderIsarModelQueryWhereDistinct
    on
        QueryBuilder<
          FavoriteFolderIsarModel,
          FavoriteFolderIsarModel,
          QDistinct
        > {
  QueryBuilder<FavoriteFolderIsarModel, FavoriteFolderIsarModel, QDistinct>
  distinctByCreatedAtMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAtMs');
    });
  }

  QueryBuilder<FavoriteFolderIsarModel, FavoriteFolderIsarModel, QDistinct>
  distinctByFolderId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'folderId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FavoriteFolderIsarModel, FavoriteFolderIsarModel, QDistinct>
  distinctByTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }
}

extension FavoriteFolderIsarModelQueryProperty
    on
        QueryBuilder<
          FavoriteFolderIsarModel,
          FavoriteFolderIsarModel,
          QQueryProperty
        > {
  QueryBuilder<FavoriteFolderIsarModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FavoriteFolderIsarModel, int, QQueryOperations>
  createdAtMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAtMs');
    });
  }

  QueryBuilder<FavoriteFolderIsarModel, String, QQueryOperations>
  folderIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'folderId');
    });
  }

  QueryBuilder<FavoriteFolderIsarModel, String, QQueryOperations>
  titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<
    FavoriteFolderIsarModel,
    List<FavoriteVideoIsarModel>,
    QQueryOperations
  >
  videosProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'videos');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const FavoriteVideoIsarModelSchema = Schema(
  name: r'FavoriteVideoIsarModel',
  id: -6135824088411133212,
  properties: {
    r'durationMs': PropertySchema(
      id: 0,
      name: r'durationMs',
      type: IsarType.long,
    ),
    r'durationText': PropertySchema(
      id: 1,
      name: r'durationText',
      type: IsarType.string,
    ),
    r'lastKnownPositionMs': PropertySchema(
      id: 2,
      name: r'lastKnownPositionMs',
      type: IsarType.long,
    ),
    r'localVideoDateModified': PropertySchema(
      id: 3,
      name: r'localVideoDateModified',
      type: IsarType.long,
    ),
    r'localVideoId': PropertySchema(
      id: 4,
      name: r'localVideoId',
      type: IsarType.long,
    ),
    r'mediaId': PropertySchema(id: 5, name: r'mediaId', type: IsarType.string),
    r'path': PropertySchema(id: 6, name: r'path', type: IsarType.string),
    r'previewAspectRatio': PropertySchema(
      id: 7,
      name: r'previewAspectRatio',
      type: IsarType.double,
    ),
    r'previewSeed': PropertySchema(
      id: 8,
      name: r'previewSeed',
      type: IsarType.long,
    ),
    r'resolutionText': PropertySchema(
      id: 9,
      name: r'resolutionText',
      type: IsarType.string,
    ),
    r'sourceKindKey': PropertySchema(
      id: 10,
      name: r'sourceKindKey',
      type: IsarType.string,
    ),
    r'sourceLabel': PropertySchema(
      id: 11,
      name: r'sourceLabel',
      type: IsarType.string,
    ),
    r'sourceUri': PropertySchema(
      id: 12,
      name: r'sourceUri',
      type: IsarType.string,
    ),
    r'thumbnailRequest': PropertySchema(
      id: 13,
      name: r'thumbnailRequest',
      type: IsarType.object,

      target: r'FavoriteThumbnailRequestIsarModel',
    ),
    r'title': PropertySchema(id: 14, name: r'title', type: IsarType.string),
    r'updatedAtMs': PropertySchema(
      id: 15,
      name: r'updatedAtMs',
      type: IsarType.long,
    ),
    r'webDavAccountId': PropertySchema(
      id: 16,
      name: r'webDavAccountId',
      type: IsarType.string,
    ),
  },

  estimateSize: _favoriteVideoIsarModelEstimateSize,
  serialize: _favoriteVideoIsarModelSerialize,
  deserialize: _favoriteVideoIsarModelDeserialize,
  deserializeProp: _favoriteVideoIsarModelDeserializeProp,
);

int _favoriteVideoIsarModelEstimateSize(
  FavoriteVideoIsarModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.durationText.length * 3;
  bytesCount += 3 + object.mediaId.length * 3;
  {
    final value = object.path;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.resolutionText;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.sourceKindKey;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.sourceLabel;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.sourceUri;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.thumbnailRequest;
    if (value != null) {
      bytesCount +=
          3 +
          FavoriteThumbnailRequestIsarModelSchema.estimateSize(
            value,
            allOffsets[FavoriteThumbnailRequestIsarModel]!,
            allOffsets,
          );
    }
  }
  bytesCount += 3 + object.title.length * 3;
  {
    final value = object.webDavAccountId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _favoriteVideoIsarModelSerialize(
  FavoriteVideoIsarModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.durationMs);
  writer.writeString(offsets[1], object.durationText);
  writer.writeLong(offsets[2], object.lastKnownPositionMs);
  writer.writeLong(offsets[3], object.localVideoDateModified);
  writer.writeLong(offsets[4], object.localVideoId);
  writer.writeString(offsets[5], object.mediaId);
  writer.writeString(offsets[6], object.path);
  writer.writeDouble(offsets[7], object.previewAspectRatio);
  writer.writeLong(offsets[8], object.previewSeed);
  writer.writeString(offsets[9], object.resolutionText);
  writer.writeString(offsets[10], object.sourceKindKey);
  writer.writeString(offsets[11], object.sourceLabel);
  writer.writeString(offsets[12], object.sourceUri);
  writer.writeObject<FavoriteThumbnailRequestIsarModel>(
    offsets[13],
    allOffsets,
    FavoriteThumbnailRequestIsarModelSchema.serialize,
    object.thumbnailRequest,
  );
  writer.writeString(offsets[14], object.title);
  writer.writeLong(offsets[15], object.updatedAtMs);
  writer.writeString(offsets[16], object.webDavAccountId);
}

FavoriteVideoIsarModel _favoriteVideoIsarModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FavoriteVideoIsarModel();
  object.durationMs = reader.readLongOrNull(offsets[0]);
  object.durationText = reader.readString(offsets[1]);
  object.lastKnownPositionMs = reader.readLongOrNull(offsets[2]);
  object.localVideoDateModified = reader.readLongOrNull(offsets[3]);
  object.localVideoId = reader.readLongOrNull(offsets[4]);
  object.mediaId = reader.readString(offsets[5]);
  object.path = reader.readStringOrNull(offsets[6]);
  object.previewAspectRatio = reader.readDoubleOrNull(offsets[7]);
  object.previewSeed = reader.readLong(offsets[8]);
  object.resolutionText = reader.readStringOrNull(offsets[9]);
  object.sourceKindKey = reader.readStringOrNull(offsets[10]);
  object.sourceLabel = reader.readStringOrNull(offsets[11]);
  object.sourceUri = reader.readStringOrNull(offsets[12]);
  object.thumbnailRequest = reader
      .readObjectOrNull<FavoriteThumbnailRequestIsarModel>(
        offsets[13],
        FavoriteThumbnailRequestIsarModelSchema.deserialize,
        allOffsets,
      );
  object.title = reader.readString(offsets[14]);
  object.updatedAtMs = reader.readLong(offsets[15]);
  object.webDavAccountId = reader.readStringOrNull(offsets[16]);
  return object;
}

P _favoriteVideoIsarModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readDoubleOrNull(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readObjectOrNull<FavoriteThumbnailRequestIsarModel>(
            offset,
            FavoriteThumbnailRequestIsarModelSchema.deserialize,
            allOffsets,
          ))
          as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readLong(offset)) as P;
    case 16:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension FavoriteVideoIsarModelQueryFilter
    on
        QueryBuilder<
          FavoriteVideoIsarModel,
          FavoriteVideoIsarModel,
          QFilterCondition
        > {
  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  durationMsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'durationMs'),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  durationMsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'durationMs'),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  durationMsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'durationMs', value: value),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  durationMsGreaterThan(int? value, {bool include = false}) {
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  durationMsLessThan(int? value, {bool include = false}) {
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  durationMsBetween(
    int? lower,
    int? upper, {
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  durationTextEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'durationText',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  durationTextGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'durationText',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  durationTextLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'durationText',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  durationTextBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'durationText',
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  durationTextStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'durationText',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  durationTextEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'durationText',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  durationTextContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'durationText',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  durationTextMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'durationText',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  durationTextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'durationText', value: ''),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  durationTextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'durationText', value: ''),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  lastKnownPositionMsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastKnownPositionMs'),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  lastKnownPositionMsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastKnownPositionMs'),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  lastKnownPositionMsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastKnownPositionMs', value: value),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  lastKnownPositionMsGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastKnownPositionMs',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  lastKnownPositionMsLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastKnownPositionMs',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  lastKnownPositionMsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastKnownPositionMs',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  pathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'path'),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  pathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'path'),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  pathEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'path',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  pathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'path',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  pathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'path',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  pathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'path',
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  pathStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'path',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  pathEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'path',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  pathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'path',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  pathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'path',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  pathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'path', value: ''),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  pathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'path', value: ''),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  previewAspectRatioIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'previewAspectRatio'),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  previewAspectRatioIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'previewAspectRatio'),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  previewAspectRatioEqualTo(double? value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'previewAspectRatio',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  previewAspectRatioGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'previewAspectRatio',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  previewAspectRatioLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'previewAspectRatio',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  previewAspectRatioBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'previewAspectRatio',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  previewSeedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'previewSeed', value: value),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  previewSeedGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'previewSeed',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  previewSeedLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'previewSeed',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  previewSeedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'previewSeed',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  resolutionTextIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'resolutionText'),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  resolutionTextIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'resolutionText'),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  resolutionTextEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'resolutionText',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  resolutionTextGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'resolutionText',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  resolutionTextLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'resolutionText',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  resolutionTextBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'resolutionText',
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  resolutionTextStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'resolutionText',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  resolutionTextEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'resolutionText',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  resolutionTextContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'resolutionText',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  resolutionTextMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'resolutionText',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  resolutionTextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'resolutionText', value: ''),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  resolutionTextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'resolutionText', value: ''),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  sourceKindKeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'sourceKindKey'),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  sourceKindKeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'sourceKindKey'),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  sourceKindKeyEqualTo(String? value, {bool caseSensitive = true}) {
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  sourceKindKeyGreaterThan(
    String? value, {
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  sourceKindKeyLessThan(
    String? value, {
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  sourceKindKeyBetween(
    String? lower,
    String? upper, {
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  sourceLabelIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'sourceLabel'),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  sourceLabelIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'sourceLabel'),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  sourceLabelEqualTo(String? value, {bool caseSensitive = true}) {
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  sourceLabelGreaterThan(
    String? value, {
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  sourceLabelLessThan(
    String? value, {
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  sourceLabelBetween(
    String? lower,
    String? upper, {
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  sourceUriIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'sourceUri'),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  sourceUriIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'sourceUri'),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  sourceUriEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'sourceUri',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  sourceUriGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sourceUri',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  sourceUriLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sourceUri',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  sourceUriBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sourceUri',
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  sourceUriStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'sourceUri',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  sourceUriEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'sourceUri',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  sourceUriContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'sourceUri',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  sourceUriMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'sourceUri',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  sourceUriIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sourceUri', value: ''),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  sourceUriIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'sourceUri', value: ''),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  thumbnailRequestIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'thumbnailRequest'),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  thumbnailRequestIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'thumbnailRequest'),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  updatedAtMsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAtMs', value: value),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  updatedAtMsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'updatedAtMs',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  updatedAtMsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'updatedAtMs',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  updatedAtMsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'updatedAtMs',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
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

extension FavoriteVideoIsarModelQueryObject
    on
        QueryBuilder<
          FavoriteVideoIsarModel,
          FavoriteVideoIsarModel,
          QFilterCondition
        > {
  QueryBuilder<
    FavoriteVideoIsarModel,
    FavoriteVideoIsarModel,
    QAfterFilterCondition
  >
  thumbnailRequest(FilterQuery<FavoriteThumbnailRequestIsarModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'thumbnailRequest');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const FavoriteThumbnailRequestIsarModelSchema = Schema(
  name: r'FavoriteThumbnailRequestIsarModel',
  id: -4678615181289768483,
  properties: {
    r'dateModified': PropertySchema(
      id: 0,
      name: r'dateModified',
      type: IsarType.long,
    ),
    r'targetHeight': PropertySchema(
      id: 1,
      name: r'targetHeight',
      type: IsarType.long,
    ),
    r'targetWidth': PropertySchema(
      id: 2,
      name: r'targetWidth',
      type: IsarType.long,
    ),
    r'videoId': PropertySchema(id: 3, name: r'videoId', type: IsarType.long),
    r'videoPath': PropertySchema(
      id: 4,
      name: r'videoPath',
      type: IsarType.string,
    ),
  },

  estimateSize: _favoriteThumbnailRequestIsarModelEstimateSize,
  serialize: _favoriteThumbnailRequestIsarModelSerialize,
  deserialize: _favoriteThumbnailRequestIsarModelDeserialize,
  deserializeProp: _favoriteThumbnailRequestIsarModelDeserializeProp,
);

int _favoriteThumbnailRequestIsarModelEstimateSize(
  FavoriteThumbnailRequestIsarModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.videoPath.length * 3;
  return bytesCount;
}

void _favoriteThumbnailRequestIsarModelSerialize(
  FavoriteThumbnailRequestIsarModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.dateModified);
  writer.writeLong(offsets[1], object.targetHeight);
  writer.writeLong(offsets[2], object.targetWidth);
  writer.writeLong(offsets[3], object.videoId);
  writer.writeString(offsets[4], object.videoPath);
}

FavoriteThumbnailRequestIsarModel _favoriteThumbnailRequestIsarModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FavoriteThumbnailRequestIsarModel();
  object.dateModified = reader.readLong(offsets[0]);
  object.targetHeight = reader.readLong(offsets[1]);
  object.targetWidth = reader.readLong(offsets[2]);
  object.videoId = reader.readLong(offsets[3]);
  object.videoPath = reader.readString(offsets[4]);
  return object;
}

P _favoriteThumbnailRequestIsarModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension FavoriteThumbnailRequestIsarModelQueryFilter
    on
        QueryBuilder<
          FavoriteThumbnailRequestIsarModel,
          FavoriteThumbnailRequestIsarModel,
          QFilterCondition
        > {
  QueryBuilder<
    FavoriteThumbnailRequestIsarModel,
    FavoriteThumbnailRequestIsarModel,
    QAfterFilterCondition
  >
  dateModifiedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dateModified', value: value),
      );
    });
  }

  QueryBuilder<
    FavoriteThumbnailRequestIsarModel,
    FavoriteThumbnailRequestIsarModel,
    QAfterFilterCondition
  >
  dateModifiedGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dateModified',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteThumbnailRequestIsarModel,
    FavoriteThumbnailRequestIsarModel,
    QAfterFilterCondition
  >
  dateModifiedLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dateModified',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteThumbnailRequestIsarModel,
    FavoriteThumbnailRequestIsarModel,
    QAfterFilterCondition
  >
  dateModifiedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dateModified',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteThumbnailRequestIsarModel,
    FavoriteThumbnailRequestIsarModel,
    QAfterFilterCondition
  >
  targetHeightEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'targetHeight', value: value),
      );
    });
  }

  QueryBuilder<
    FavoriteThumbnailRequestIsarModel,
    FavoriteThumbnailRequestIsarModel,
    QAfterFilterCondition
  >
  targetHeightGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'targetHeight',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteThumbnailRequestIsarModel,
    FavoriteThumbnailRequestIsarModel,
    QAfterFilterCondition
  >
  targetHeightLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'targetHeight',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteThumbnailRequestIsarModel,
    FavoriteThumbnailRequestIsarModel,
    QAfterFilterCondition
  >
  targetHeightBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'targetHeight',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteThumbnailRequestIsarModel,
    FavoriteThumbnailRequestIsarModel,
    QAfterFilterCondition
  >
  targetWidthEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'targetWidth', value: value),
      );
    });
  }

  QueryBuilder<
    FavoriteThumbnailRequestIsarModel,
    FavoriteThumbnailRequestIsarModel,
    QAfterFilterCondition
  >
  targetWidthGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'targetWidth',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteThumbnailRequestIsarModel,
    FavoriteThumbnailRequestIsarModel,
    QAfterFilterCondition
  >
  targetWidthLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'targetWidth',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteThumbnailRequestIsarModel,
    FavoriteThumbnailRequestIsarModel,
    QAfterFilterCondition
  >
  targetWidthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'targetWidth',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteThumbnailRequestIsarModel,
    FavoriteThumbnailRequestIsarModel,
    QAfterFilterCondition
  >
  videoIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'videoId', value: value),
      );
    });
  }

  QueryBuilder<
    FavoriteThumbnailRequestIsarModel,
    FavoriteThumbnailRequestIsarModel,
    QAfterFilterCondition
  >
  videoIdGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'videoId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteThumbnailRequestIsarModel,
    FavoriteThumbnailRequestIsarModel,
    QAfterFilterCondition
  >
  videoIdLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'videoId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteThumbnailRequestIsarModel,
    FavoriteThumbnailRequestIsarModel,
    QAfterFilterCondition
  >
  videoIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'videoId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    FavoriteThumbnailRequestIsarModel,
    FavoriteThumbnailRequestIsarModel,
    QAfterFilterCondition
  >
  videoPathEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    FavoriteThumbnailRequestIsarModel,
    FavoriteThumbnailRequestIsarModel,
    QAfterFilterCondition
  >
  videoPathGreaterThan(
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

  QueryBuilder<
    FavoriteThumbnailRequestIsarModel,
    FavoriteThumbnailRequestIsarModel,
    QAfterFilterCondition
  >
  videoPathLessThan(
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

  QueryBuilder<
    FavoriteThumbnailRequestIsarModel,
    FavoriteThumbnailRequestIsarModel,
    QAfterFilterCondition
  >
  videoPathBetween(
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

  QueryBuilder<
    FavoriteThumbnailRequestIsarModel,
    FavoriteThumbnailRequestIsarModel,
    QAfterFilterCondition
  >
  videoPathStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    FavoriteThumbnailRequestIsarModel,
    FavoriteThumbnailRequestIsarModel,
    QAfterFilterCondition
  >
  videoPathEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    FavoriteThumbnailRequestIsarModel,
    FavoriteThumbnailRequestIsarModel,
    QAfterFilterCondition
  >
  videoPathContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    FavoriteThumbnailRequestIsarModel,
    FavoriteThumbnailRequestIsarModel,
    QAfterFilterCondition
  >
  videoPathMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<
    FavoriteThumbnailRequestIsarModel,
    FavoriteThumbnailRequestIsarModel,
    QAfterFilterCondition
  >
  videoPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'videoPath', value: ''),
      );
    });
  }

  QueryBuilder<
    FavoriteThumbnailRequestIsarModel,
    FavoriteThumbnailRequestIsarModel,
    QAfterFilterCondition
  >
  videoPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'videoPath', value: ''),
      );
    });
  }
}

extension FavoriteThumbnailRequestIsarModelQueryObject
    on
        QueryBuilder<
          FavoriteThumbnailRequestIsarModel,
          FavoriteThumbnailRequestIsarModel,
          QFilterCondition
        > {}
