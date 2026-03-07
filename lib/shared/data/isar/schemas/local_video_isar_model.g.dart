// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_video_isar_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLocalVideoIsarModelCollection on Isar {
  IsarCollection<LocalVideoIsarModel> get localVideoIsarModels =>
      this.collection();
}

const LocalVideoIsarModelSchema = CollectionSchema(
  name: r'LocalVideoIsarModel',
  id: -8585158109980162123,
  properties: {
    r'bucketId': PropertySchema(
      id: 0,
      name: r'bucketId',
      type: IsarType.string,
    ),
    r'bucketName': PropertySchema(
      id: 1,
      name: r'bucketName',
      type: IsarType.string,
    ),
    r'dateAdded': PropertySchema(
      id: 2,
      name: r'dateAdded',
      type: IsarType.long,
    ),
    r'dateModified': PropertySchema(
      id: 3,
      name: r'dateModified',
      type: IsarType.long,
    ),
    r'durationMs': PropertySchema(
      id: 4,
      name: r'durationMs',
      type: IsarType.long,
    ),
    r'height': PropertySchema(id: 5, name: r'height', type: IsarType.long),
    r'isFavorite': PropertySchema(
      id: 6,
      name: r'isFavorite',
      type: IsarType.bool,
    ),
    r'lastPlayPositionMs': PropertySchema(
      id: 7,
      name: r'lastPlayPositionMs',
      type: IsarType.long,
    ),
    r'path': PropertySchema(id: 8, name: r'path', type: IsarType.string),
    r'size': PropertySchema(id: 9, name: r'size', type: IsarType.long),
    r'title': PropertySchema(id: 10, name: r'title', type: IsarType.string),
    r'width': PropertySchema(id: 11, name: r'width', type: IsarType.long),
  },

  estimateSize: _localVideoIsarModelEstimateSize,
  serialize: _localVideoIsarModelSerialize,
  deserialize: _localVideoIsarModelDeserialize,
  deserializeProp: _localVideoIsarModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'path': IndexSchema(
      id: 8756705481922369689,
      name: r'path',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'path',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'bucketId': IndexSchema(
      id: -6654471401330852794,
      name: r'bucketId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'bucketId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _localVideoIsarModelGetId,
  getLinks: _localVideoIsarModelGetLinks,
  attach: _localVideoIsarModelAttach,
  version: '3.3.0',
);

int _localVideoIsarModelEstimateSize(
  LocalVideoIsarModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.bucketId.length * 3;
  bytesCount += 3 + object.bucketName.length * 3;
  bytesCount += 3 + object.path.length * 3;
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _localVideoIsarModelSerialize(
  LocalVideoIsarModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.bucketId);
  writer.writeString(offsets[1], object.bucketName);
  writer.writeLong(offsets[2], object.dateAdded);
  writer.writeLong(offsets[3], object.dateModified);
  writer.writeLong(offsets[4], object.durationMs);
  writer.writeLong(offsets[5], object.height);
  writer.writeBool(offsets[6], object.isFavorite);
  writer.writeLong(offsets[7], object.lastPlayPositionMs);
  writer.writeString(offsets[8], object.path);
  writer.writeLong(offsets[9], object.size);
  writer.writeString(offsets[10], object.title);
  writer.writeLong(offsets[11], object.width);
}

LocalVideoIsarModel _localVideoIsarModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LocalVideoIsarModel();
  object.bucketId = reader.readString(offsets[0]);
  object.bucketName = reader.readString(offsets[1]);
  object.dateAdded = reader.readLong(offsets[2]);
  object.dateModified = reader.readLong(offsets[3]);
  object.durationMs = reader.readLong(offsets[4]);
  object.height = reader.readLong(offsets[5]);
  object.id = id;
  object.isFavorite = reader.readBool(offsets[6]);
  object.lastPlayPositionMs = reader.readLongOrNull(offsets[7]);
  object.path = reader.readString(offsets[8]);
  object.size = reader.readLong(offsets[9]);
  object.title = reader.readString(offsets[10]);
  object.width = reader.readLong(offsets[11]);
  return object;
}

P _localVideoIsarModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readLongOrNull(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _localVideoIsarModelGetId(LocalVideoIsarModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _localVideoIsarModelGetLinks(
  LocalVideoIsarModel object,
) {
  return [];
}

void _localVideoIsarModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  LocalVideoIsarModel object,
) {
  object.id = id;
}

extension LocalVideoIsarModelByIndex on IsarCollection<LocalVideoIsarModel> {
  Future<LocalVideoIsarModel?> getByPath(String path) {
    return getByIndex(r'path', [path]);
  }

  LocalVideoIsarModel? getByPathSync(String path) {
    return getByIndexSync(r'path', [path]);
  }

  Future<bool> deleteByPath(String path) {
    return deleteByIndex(r'path', [path]);
  }

  bool deleteByPathSync(String path) {
    return deleteByIndexSync(r'path', [path]);
  }

  Future<List<LocalVideoIsarModel?>> getAllByPath(List<String> pathValues) {
    final values = pathValues.map((e) => [e]).toList();
    return getAllByIndex(r'path', values);
  }

  List<LocalVideoIsarModel?> getAllByPathSync(List<String> pathValues) {
    final values = pathValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'path', values);
  }

  Future<int> deleteAllByPath(List<String> pathValues) {
    final values = pathValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'path', values);
  }

  int deleteAllByPathSync(List<String> pathValues) {
    final values = pathValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'path', values);
  }

  Future<Id> putByPath(LocalVideoIsarModel object) {
    return putByIndex(r'path', object);
  }

  Id putByPathSync(LocalVideoIsarModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'path', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByPath(List<LocalVideoIsarModel> objects) {
    return putAllByIndex(r'path', objects);
  }

  List<Id> putAllByPathSync(
    List<LocalVideoIsarModel> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'path', objects, saveLinks: saveLinks);
  }
}

extension LocalVideoIsarModelQueryWhereSort
    on QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QWhere> {
  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LocalVideoIsarModelQueryWhere
    on QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QWhereClause> {
  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterWhereClause>
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

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterWhereClause>
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

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterWhereClause>
  pathEqualTo(String path) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'path', value: [path]),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterWhereClause>
  pathNotEqualTo(String path) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'path',
                lower: [],
                upper: [path],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'path',
                lower: [path],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'path',
                lower: [path],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'path',
                lower: [],
                upper: [path],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterWhereClause>
  bucketIdEqualTo(String bucketId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'bucketId', value: [bucketId]),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterWhereClause>
  bucketIdNotEqualTo(String bucketId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'bucketId',
                lower: [],
                upper: [bucketId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'bucketId',
                lower: [bucketId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'bucketId',
                lower: [bucketId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'bucketId',
                lower: [],
                upper: [bucketId],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension LocalVideoIsarModelQueryFilter
    on
        QueryBuilder<
          LocalVideoIsarModel,
          LocalVideoIsarModel,
          QFilterCondition
        > {
  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  bucketIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'bucketId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  bucketIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'bucketId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  bucketIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'bucketId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  bucketIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'bucketId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  bucketIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'bucketId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  bucketIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'bucketId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  bucketIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'bucketId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  bucketIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'bucketId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  bucketIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'bucketId', value: ''),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  bucketIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'bucketId', value: ''),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  bucketNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'bucketName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  bucketNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'bucketName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  bucketNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'bucketName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  bucketNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'bucketName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  bucketNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'bucketName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  bucketNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'bucketName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  bucketNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'bucketName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  bucketNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'bucketName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  bucketNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'bucketName', value: ''),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  bucketNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'bucketName', value: ''),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  dateAddedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dateAdded', value: value),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  dateAddedGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dateAdded',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  dateAddedLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dateAdded',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  dateAddedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dateAdded',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  dateModifiedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dateModified', value: value),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
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

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
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

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
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

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  durationMsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'durationMs', value: value),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
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

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
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

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
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

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  heightEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'height', value: value),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  heightGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'height',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  heightLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'height',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  heightBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'height',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
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

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
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

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
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

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  isFavoriteEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isFavorite', value: value),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  lastPlayPositionMsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastPlayPositionMs'),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  lastPlayPositionMsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastPlayPositionMs'),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  lastPlayPositionMsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastPlayPositionMs', value: value),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  lastPlayPositionMsGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastPlayPositionMs',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  lastPlayPositionMsLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastPlayPositionMs',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  lastPlayPositionMsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastPlayPositionMs',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  pathEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  pathGreaterThan(
    String value, {
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

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  pathLessThan(
    String value, {
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

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  pathBetween(
    String lower,
    String upper, {
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

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
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

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
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

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
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

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
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

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  pathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'path', value: ''),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  pathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'path', value: ''),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  sizeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'size', value: value),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  sizeGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'size',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  sizeLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'size',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  sizeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'size',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
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

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
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

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
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

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
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

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
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

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
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

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
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

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
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

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  widthEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'width', value: value),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  widthGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'width',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  widthLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'width',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterFilterCondition>
  widthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'width',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension LocalVideoIsarModelQueryObject
    on
        QueryBuilder<
          LocalVideoIsarModel,
          LocalVideoIsarModel,
          QFilterCondition
        > {}

extension LocalVideoIsarModelQueryLinks
    on
        QueryBuilder<
          LocalVideoIsarModel,
          LocalVideoIsarModel,
          QFilterCondition
        > {}

extension LocalVideoIsarModelQuerySortBy
    on QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QSortBy> {
  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  sortByBucketId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bucketId', Sort.asc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  sortByBucketIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bucketId', Sort.desc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  sortByBucketName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bucketName', Sort.asc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  sortByBucketNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bucketName', Sort.desc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  sortByDateAdded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateAdded', Sort.asc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  sortByDateAddedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateAdded', Sort.desc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  sortByDateModified() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateModified', Sort.asc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  sortByDateModifiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateModified', Sort.desc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  sortByDurationMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMs', Sort.asc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  sortByDurationMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMs', Sort.desc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  sortByHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'height', Sort.asc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  sortByHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'height', Sort.desc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  sortByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.asc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  sortByIsFavoriteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.desc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  sortByLastPlayPositionMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPlayPositionMs', Sort.asc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  sortByLastPlayPositionMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPlayPositionMs', Sort.desc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  sortByPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.asc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  sortByPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.desc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  sortBySize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'size', Sort.asc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  sortBySizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'size', Sort.desc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  sortByWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'width', Sort.asc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  sortByWidthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'width', Sort.desc);
    });
  }
}

extension LocalVideoIsarModelQuerySortThenBy
    on QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QSortThenBy> {
  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  thenByBucketId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bucketId', Sort.asc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  thenByBucketIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bucketId', Sort.desc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  thenByBucketName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bucketName', Sort.asc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  thenByBucketNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bucketName', Sort.desc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  thenByDateAdded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateAdded', Sort.asc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  thenByDateAddedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateAdded', Sort.desc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  thenByDateModified() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateModified', Sort.asc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  thenByDateModifiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateModified', Sort.desc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  thenByDurationMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMs', Sort.asc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  thenByDurationMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMs', Sort.desc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  thenByHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'height', Sort.asc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  thenByHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'height', Sort.desc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  thenByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.asc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  thenByIsFavoriteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.desc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  thenByLastPlayPositionMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPlayPositionMs', Sort.asc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  thenByLastPlayPositionMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPlayPositionMs', Sort.desc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  thenByPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.asc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  thenByPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.desc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  thenBySize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'size', Sort.asc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  thenBySizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'size', Sort.desc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  thenByWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'width', Sort.asc);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QAfterSortBy>
  thenByWidthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'width', Sort.desc);
    });
  }
}

extension LocalVideoIsarModelQueryWhereDistinct
    on QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QDistinct> {
  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QDistinct>
  distinctByBucketId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bucketId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QDistinct>
  distinctByBucketName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bucketName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QDistinct>
  distinctByDateAdded() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateAdded');
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QDistinct>
  distinctByDateModified() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateModified');
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QDistinct>
  distinctByDurationMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationMs');
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QDistinct>
  distinctByHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'height');
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QDistinct>
  distinctByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isFavorite');
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QDistinct>
  distinctByLastPlayPositionMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastPlayPositionMs');
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QDistinct>
  distinctByPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'path', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QDistinct>
  distinctBySize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'size');
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QDistinct>
  distinctByTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QDistinct>
  distinctByWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'width');
    });
  }
}

extension LocalVideoIsarModelQueryProperty
    on QueryBuilder<LocalVideoIsarModel, LocalVideoIsarModel, QQueryProperty> {
  QueryBuilder<LocalVideoIsarModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LocalVideoIsarModel, String, QQueryOperations>
  bucketIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bucketId');
    });
  }

  QueryBuilder<LocalVideoIsarModel, String, QQueryOperations>
  bucketNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bucketName');
    });
  }

  QueryBuilder<LocalVideoIsarModel, int, QQueryOperations> dateAddedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateAdded');
    });
  }

  QueryBuilder<LocalVideoIsarModel, int, QQueryOperations>
  dateModifiedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateModified');
    });
  }

  QueryBuilder<LocalVideoIsarModel, int, QQueryOperations>
  durationMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationMs');
    });
  }

  QueryBuilder<LocalVideoIsarModel, int, QQueryOperations> heightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'height');
    });
  }

  QueryBuilder<LocalVideoIsarModel, bool, QQueryOperations>
  isFavoriteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isFavorite');
    });
  }

  QueryBuilder<LocalVideoIsarModel, int?, QQueryOperations>
  lastPlayPositionMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastPlayPositionMs');
    });
  }

  QueryBuilder<LocalVideoIsarModel, String, QQueryOperations> pathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'path');
    });
  }

  QueryBuilder<LocalVideoIsarModel, int, QQueryOperations> sizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'size');
    });
  }

  QueryBuilder<LocalVideoIsarModel, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<LocalVideoIsarModel, int, QQueryOperations> widthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'width');
    });
  }
}
