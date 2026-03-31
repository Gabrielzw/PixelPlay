// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_backup_record_isar_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDataBackupRecordIsarModelCollection on Isar {
  IsarCollection<DataBackupRecordIsarModel> get dataBackupRecordIsarModels =>
      this.collection();
}

const DataBackupRecordIsarModelSchema = CollectionSchema(
  name: r'DataBackupRecordIsarModel',
  id: -7333482686728574771,
  properties: {
    r'backupId': PropertySchema(
      id: 0,
      name: r'backupId',
      type: IsarType.string,
    ),
    r'backupRecordCount': PropertySchema(
      id: 1,
      name: r'backupRecordCount',
      type: IsarType.long,
    ),
    r'createdAtMs': PropertySchema(
      id: 2,
      name: r'createdAtMs',
      type: IsarType.long,
    ),
    r'favoriteFolderCount': PropertySchema(
      id: 3,
      name: r'favoriteFolderCount',
      type: IsarType.long,
    ),
    r'fileName': PropertySchema(
      id: 4,
      name: r'fileName',
      type: IsarType.string,
    ),
    r'filePath': PropertySchema(
      id: 5,
      name: r'filePath',
      type: IsarType.string,
    ),
    r'playlistSourceCount': PropertySchema(
      id: 6,
      name: r'playlistSourceCount',
      type: IsarType.long,
    ),
    r'schemaVersion': PropertySchema(
      id: 7,
      name: r'schemaVersion',
      type: IsarType.long,
    ),
    r'webDavAccountCount': PropertySchema(
      id: 8,
      name: r'webDavAccountCount',
      type: IsarType.long,
    ),
  },

  estimateSize: _dataBackupRecordIsarModelEstimateSize,
  serialize: _dataBackupRecordIsarModelSerialize,
  deserialize: _dataBackupRecordIsarModelDeserialize,
  deserializeProp: _dataBackupRecordIsarModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'backupId': IndexSchema(
      id: -7401405900740166301,
      name: r'backupId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'backupId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _dataBackupRecordIsarModelGetId,
  getLinks: _dataBackupRecordIsarModelGetLinks,
  attach: _dataBackupRecordIsarModelAttach,
  version: '3.3.0',
);

int _dataBackupRecordIsarModelEstimateSize(
  DataBackupRecordIsarModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.backupId.length * 3;
  bytesCount += 3 + object.fileName.length * 3;
  {
    final value = object.filePath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _dataBackupRecordIsarModelSerialize(
  DataBackupRecordIsarModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.backupId);
  writer.writeLong(offsets[1], object.backupRecordCount);
  writer.writeLong(offsets[2], object.createdAtMs);
  writer.writeLong(offsets[3], object.favoriteFolderCount);
  writer.writeString(offsets[4], object.fileName);
  writer.writeString(offsets[5], object.filePath);
  writer.writeLong(offsets[6], object.playlistSourceCount);
  writer.writeLong(offsets[7], object.schemaVersion);
  writer.writeLong(offsets[8], object.webDavAccountCount);
}

DataBackupRecordIsarModel _dataBackupRecordIsarModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DataBackupRecordIsarModel();
  object.backupId = reader.readString(offsets[0]);
  object.backupRecordCount = reader.readLong(offsets[1]);
  object.createdAtMs = reader.readLong(offsets[2]);
  object.favoriteFolderCount = reader.readLong(offsets[3]);
  object.fileName = reader.readString(offsets[4]);
  object.filePath = reader.readStringOrNull(offsets[5]);
  object.id = id;
  object.playlistSourceCount = reader.readLong(offsets[6]);
  object.schemaVersion = reader.readLong(offsets[7]);
  object.webDavAccountCount = reader.readLong(offsets[8]);
  return object;
}

P _dataBackupRecordIsarModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dataBackupRecordIsarModelGetId(DataBackupRecordIsarModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _dataBackupRecordIsarModelGetLinks(
  DataBackupRecordIsarModel object,
) {
  return [];
}

void _dataBackupRecordIsarModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  DataBackupRecordIsarModel object,
) {
  object.id = id;
}

extension DataBackupRecordIsarModelByIndex
    on IsarCollection<DataBackupRecordIsarModel> {
  Future<DataBackupRecordIsarModel?> getByBackupId(String backupId) {
    return getByIndex(r'backupId', [backupId]);
  }

  DataBackupRecordIsarModel? getByBackupIdSync(String backupId) {
    return getByIndexSync(r'backupId', [backupId]);
  }

  Future<bool> deleteByBackupId(String backupId) {
    return deleteByIndex(r'backupId', [backupId]);
  }

  bool deleteByBackupIdSync(String backupId) {
    return deleteByIndexSync(r'backupId', [backupId]);
  }

  Future<List<DataBackupRecordIsarModel?>> getAllByBackupId(
    List<String> backupIdValues,
  ) {
    final values = backupIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'backupId', values);
  }

  List<DataBackupRecordIsarModel?> getAllByBackupIdSync(
    List<String> backupIdValues,
  ) {
    final values = backupIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'backupId', values);
  }

  Future<int> deleteAllByBackupId(List<String> backupIdValues) {
    final values = backupIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'backupId', values);
  }

  int deleteAllByBackupIdSync(List<String> backupIdValues) {
    final values = backupIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'backupId', values);
  }

  Future<Id> putByBackupId(DataBackupRecordIsarModel object) {
    return putByIndex(r'backupId', object);
  }

  Id putByBackupIdSync(
    DataBackupRecordIsarModel object, {
    bool saveLinks = true,
  }) {
    return putByIndexSync(r'backupId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByBackupId(List<DataBackupRecordIsarModel> objects) {
    return putAllByIndex(r'backupId', objects);
  }

  List<Id> putAllByBackupIdSync(
    List<DataBackupRecordIsarModel> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'backupId', objects, saveLinks: saveLinks);
  }
}

extension DataBackupRecordIsarModelQueryWhereSort
    on
        QueryBuilder<
          DataBackupRecordIsarModel,
          DataBackupRecordIsarModel,
          QWhere
        > {
  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterWhere
  >
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DataBackupRecordIsarModelQueryWhere
    on
        QueryBuilder<
          DataBackupRecordIsarModel,
          DataBackupRecordIsarModel,
          QWhereClause
        > {
  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterWhereClause
  >
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
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
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
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
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
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
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
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
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterWhereClause
  >
  backupIdEqualTo(String backupId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'backupId', value: [backupId]),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterWhereClause
  >
  backupIdNotEqualTo(String backupId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'backupId',
                lower: [],
                upper: [backupId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'backupId',
                lower: [backupId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'backupId',
                lower: [backupId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'backupId',
                lower: [],
                upper: [backupId],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension DataBackupRecordIsarModelQueryFilter
    on
        QueryBuilder<
          DataBackupRecordIsarModel,
          DataBackupRecordIsarModel,
          QFilterCondition
        > {
  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  backupIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'backupId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  backupIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'backupId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  backupIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'backupId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  backupIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'backupId',
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
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  backupIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'backupId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  backupIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'backupId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  backupIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'backupId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  backupIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'backupId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  backupIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'backupId', value: ''),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  backupIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'backupId', value: ''),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  backupRecordCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'backupRecordCount', value: value),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  backupRecordCountGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'backupRecordCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  backupRecordCountLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'backupRecordCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  backupRecordCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'backupRecordCount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
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
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
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
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
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
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
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
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  favoriteFolderCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'favoriteFolderCount', value: value),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  favoriteFolderCountGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'favoriteFolderCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  favoriteFolderCountLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'favoriteFolderCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  favoriteFolderCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'favoriteFolderCount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  fileNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'fileName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  fileNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'fileName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  fileNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'fileName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  fileNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'fileName',
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
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  fileNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'fileName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  fileNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'fileName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  fileNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'fileName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  fileNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'fileName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  fileNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'fileName', value: ''),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  fileNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'fileName', value: ''),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  filePathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'filePath'),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  filePathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'filePath'),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  filePathEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'filePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  filePathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'filePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  filePathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'filePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  filePathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'filePath',
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
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  filePathStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'filePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  filePathEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'filePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  filePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'filePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  filePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'filePath',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  filePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'filePath', value: ''),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  filePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'filePath', value: ''),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
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
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
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
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
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
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
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
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  playlistSourceCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'playlistSourceCount', value: value),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  playlistSourceCountGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'playlistSourceCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  playlistSourceCountLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'playlistSourceCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  playlistSourceCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'playlistSourceCount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  schemaVersionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'schemaVersion', value: value),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  schemaVersionGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'schemaVersion',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  schemaVersionLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'schemaVersion',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  schemaVersionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'schemaVersion',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  webDavAccountCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'webDavAccountCount', value: value),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  webDavAccountCountGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'webDavAccountCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  webDavAccountCountLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'webDavAccountCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterFilterCondition
  >
  webDavAccountCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'webDavAccountCount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension DataBackupRecordIsarModelQueryObject
    on
        QueryBuilder<
          DataBackupRecordIsarModel,
          DataBackupRecordIsarModel,
          QFilterCondition
        > {}

extension DataBackupRecordIsarModelQueryLinks
    on
        QueryBuilder<
          DataBackupRecordIsarModel,
          DataBackupRecordIsarModel,
          QFilterCondition
        > {}

extension DataBackupRecordIsarModelQuerySortBy
    on
        QueryBuilder<
          DataBackupRecordIsarModel,
          DataBackupRecordIsarModel,
          QSortBy
        > {
  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterSortBy
  >
  sortByBackupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backupId', Sort.asc);
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterSortBy
  >
  sortByBackupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backupId', Sort.desc);
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterSortBy
  >
  sortByBackupRecordCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backupRecordCount', Sort.asc);
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterSortBy
  >
  sortByBackupRecordCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backupRecordCount', Sort.desc);
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterSortBy
  >
  sortByCreatedAtMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtMs', Sort.asc);
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterSortBy
  >
  sortByCreatedAtMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtMs', Sort.desc);
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterSortBy
  >
  sortByFavoriteFolderCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favoriteFolderCount', Sort.asc);
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterSortBy
  >
  sortByFavoriteFolderCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favoriteFolderCount', Sort.desc);
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterSortBy
  >
  sortByFileName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileName', Sort.asc);
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterSortBy
  >
  sortByFileNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileName', Sort.desc);
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterSortBy
  >
  sortByFilePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filePath', Sort.asc);
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterSortBy
  >
  sortByFilePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filePath', Sort.desc);
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterSortBy
  >
  sortByPlaylistSourceCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playlistSourceCount', Sort.asc);
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterSortBy
  >
  sortByPlaylistSourceCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playlistSourceCount', Sort.desc);
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterSortBy
  >
  sortBySchemaVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schemaVersion', Sort.asc);
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterSortBy
  >
  sortBySchemaVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schemaVersion', Sort.desc);
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterSortBy
  >
  sortByWebDavAccountCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'webDavAccountCount', Sort.asc);
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterSortBy
  >
  sortByWebDavAccountCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'webDavAccountCount', Sort.desc);
    });
  }
}

extension DataBackupRecordIsarModelQuerySortThenBy
    on
        QueryBuilder<
          DataBackupRecordIsarModel,
          DataBackupRecordIsarModel,
          QSortThenBy
        > {
  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterSortBy
  >
  thenByBackupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backupId', Sort.asc);
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterSortBy
  >
  thenByBackupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backupId', Sort.desc);
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterSortBy
  >
  thenByBackupRecordCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backupRecordCount', Sort.asc);
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterSortBy
  >
  thenByBackupRecordCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backupRecordCount', Sort.desc);
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterSortBy
  >
  thenByCreatedAtMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtMs', Sort.asc);
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterSortBy
  >
  thenByCreatedAtMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtMs', Sort.desc);
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterSortBy
  >
  thenByFavoriteFolderCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favoriteFolderCount', Sort.asc);
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterSortBy
  >
  thenByFavoriteFolderCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favoriteFolderCount', Sort.desc);
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterSortBy
  >
  thenByFileName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileName', Sort.asc);
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterSortBy
  >
  thenByFileNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileName', Sort.desc);
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterSortBy
  >
  thenByFilePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filePath', Sort.asc);
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterSortBy
  >
  thenByFilePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filePath', Sort.desc);
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterSortBy
  >
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterSortBy
  >
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterSortBy
  >
  thenByPlaylistSourceCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playlistSourceCount', Sort.asc);
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterSortBy
  >
  thenByPlaylistSourceCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playlistSourceCount', Sort.desc);
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterSortBy
  >
  thenBySchemaVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schemaVersion', Sort.asc);
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterSortBy
  >
  thenBySchemaVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schemaVersion', Sort.desc);
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterSortBy
  >
  thenByWebDavAccountCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'webDavAccountCount', Sort.asc);
    });
  }

  QueryBuilder<
    DataBackupRecordIsarModel,
    DataBackupRecordIsarModel,
    QAfterSortBy
  >
  thenByWebDavAccountCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'webDavAccountCount', Sort.desc);
    });
  }
}

extension DataBackupRecordIsarModelQueryWhereDistinct
    on
        QueryBuilder<
          DataBackupRecordIsarModel,
          DataBackupRecordIsarModel,
          QDistinct
        > {
  QueryBuilder<DataBackupRecordIsarModel, DataBackupRecordIsarModel, QDistinct>
  distinctByBackupId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'backupId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DataBackupRecordIsarModel, DataBackupRecordIsarModel, QDistinct>
  distinctByBackupRecordCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'backupRecordCount');
    });
  }

  QueryBuilder<DataBackupRecordIsarModel, DataBackupRecordIsarModel, QDistinct>
  distinctByCreatedAtMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAtMs');
    });
  }

  QueryBuilder<DataBackupRecordIsarModel, DataBackupRecordIsarModel, QDistinct>
  distinctByFavoriteFolderCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'favoriteFolderCount');
    });
  }

  QueryBuilder<DataBackupRecordIsarModel, DataBackupRecordIsarModel, QDistinct>
  distinctByFileName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fileName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DataBackupRecordIsarModel, DataBackupRecordIsarModel, QDistinct>
  distinctByFilePath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'filePath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DataBackupRecordIsarModel, DataBackupRecordIsarModel, QDistinct>
  distinctByPlaylistSourceCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'playlistSourceCount');
    });
  }

  QueryBuilder<DataBackupRecordIsarModel, DataBackupRecordIsarModel, QDistinct>
  distinctBySchemaVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'schemaVersion');
    });
  }

  QueryBuilder<DataBackupRecordIsarModel, DataBackupRecordIsarModel, QDistinct>
  distinctByWebDavAccountCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'webDavAccountCount');
    });
  }
}

extension DataBackupRecordIsarModelQueryProperty
    on
        QueryBuilder<
          DataBackupRecordIsarModel,
          DataBackupRecordIsarModel,
          QQueryProperty
        > {
  QueryBuilder<DataBackupRecordIsarModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DataBackupRecordIsarModel, String, QQueryOperations>
  backupIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'backupId');
    });
  }

  QueryBuilder<DataBackupRecordIsarModel, int, QQueryOperations>
  backupRecordCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'backupRecordCount');
    });
  }

  QueryBuilder<DataBackupRecordIsarModel, int, QQueryOperations>
  createdAtMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAtMs');
    });
  }

  QueryBuilder<DataBackupRecordIsarModel, int, QQueryOperations>
  favoriteFolderCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'favoriteFolderCount');
    });
  }

  QueryBuilder<DataBackupRecordIsarModel, String, QQueryOperations>
  fileNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fileName');
    });
  }

  QueryBuilder<DataBackupRecordIsarModel, String?, QQueryOperations>
  filePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'filePath');
    });
  }

  QueryBuilder<DataBackupRecordIsarModel, int, QQueryOperations>
  playlistSourceCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'playlistSourceCount');
    });
  }

  QueryBuilder<DataBackupRecordIsarModel, int, QQueryOperations>
  schemaVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'schemaVersion');
    });
  }

  QueryBuilder<DataBackupRecordIsarModel, int, QQueryOperations>
  webDavAccountCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'webDavAccountCount');
    });
  }
}
