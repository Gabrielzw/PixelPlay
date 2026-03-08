// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'webdav_account_isar_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWebDavAccountIsarModelCollection on Isar {
  IsarCollection<WebDavAccountIsarModel> get webDavAccountIsarModels =>
      this.collection();
}

const WebDavAccountIsarModelSchema = CollectionSchema(
  name: r'WebDavAccountIsarModel',
  id: 9138976223735228766,
  properties: {
    r'accountId': PropertySchema(
      id: 0,
      name: r'accountId',
      type: IsarType.string,
    ),
    r'alias': PropertySchema(id: 1, name: r'alias', type: IsarType.string),
    r'rootPath': PropertySchema(
      id: 2,
      name: r'rootPath',
      type: IsarType.string,
    ),
    r'url': PropertySchema(id: 3, name: r'url', type: IsarType.string),
    r'username': PropertySchema(
      id: 4,
      name: r'username',
      type: IsarType.string,
    ),
  },

  estimateSize: _webDavAccountIsarModelEstimateSize,
  serialize: _webDavAccountIsarModelSerialize,
  deserialize: _webDavAccountIsarModelDeserialize,
  deserializeProp: _webDavAccountIsarModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'accountId': IndexSchema(
      id: -1591555361937770434,
      name: r'accountId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'accountId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _webDavAccountIsarModelGetId,
  getLinks: _webDavAccountIsarModelGetLinks,
  attach: _webDavAccountIsarModelAttach,
  version: '3.3.0',
);

int _webDavAccountIsarModelEstimateSize(
  WebDavAccountIsarModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.accountId.length * 3;
  bytesCount += 3 + object.alias.length * 3;
  bytesCount += 3 + object.rootPath.length * 3;
  bytesCount += 3 + object.url.length * 3;
  bytesCount += 3 + object.username.length * 3;
  return bytesCount;
}

void _webDavAccountIsarModelSerialize(
  WebDavAccountIsarModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.accountId);
  writer.writeString(offsets[1], object.alias);
  writer.writeString(offsets[2], object.rootPath);
  writer.writeString(offsets[3], object.url);
  writer.writeString(offsets[4], object.username);
}

WebDavAccountIsarModel _webDavAccountIsarModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WebDavAccountIsarModel();
  object.accountId = reader.readString(offsets[0]);
  object.alias = reader.readString(offsets[1]);
  object.id = id;
  object.rootPath = reader.readString(offsets[2]);
  object.url = reader.readString(offsets[3]);
  object.username = reader.readString(offsets[4]);
  return object;
}

P _webDavAccountIsarModelDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _webDavAccountIsarModelGetId(WebDavAccountIsarModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _webDavAccountIsarModelGetLinks(
  WebDavAccountIsarModel object,
) {
  return [];
}

void _webDavAccountIsarModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  WebDavAccountIsarModel object,
) {
  object.id = id;
}

extension WebDavAccountIsarModelByIndex
    on IsarCollection<WebDavAccountIsarModel> {
  Future<WebDavAccountIsarModel?> getByAccountId(String accountId) {
    return getByIndex(r'accountId', [accountId]);
  }

  WebDavAccountIsarModel? getByAccountIdSync(String accountId) {
    return getByIndexSync(r'accountId', [accountId]);
  }

  Future<bool> deleteByAccountId(String accountId) {
    return deleteByIndex(r'accountId', [accountId]);
  }

  bool deleteByAccountIdSync(String accountId) {
    return deleteByIndexSync(r'accountId', [accountId]);
  }

  Future<List<WebDavAccountIsarModel?>> getAllByAccountId(
    List<String> accountIdValues,
  ) {
    final values = accountIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'accountId', values);
  }

  List<WebDavAccountIsarModel?> getAllByAccountIdSync(
    List<String> accountIdValues,
  ) {
    final values = accountIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'accountId', values);
  }

  Future<int> deleteAllByAccountId(List<String> accountIdValues) {
    final values = accountIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'accountId', values);
  }

  int deleteAllByAccountIdSync(List<String> accountIdValues) {
    final values = accountIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'accountId', values);
  }

  Future<Id> putByAccountId(WebDavAccountIsarModel object) {
    return putByIndex(r'accountId', object);
  }

  Id putByAccountIdSync(
    WebDavAccountIsarModel object, {
    bool saveLinks = true,
  }) {
    return putByIndexSync(r'accountId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByAccountId(List<WebDavAccountIsarModel> objects) {
    return putAllByIndex(r'accountId', objects);
  }

  List<Id> putAllByAccountIdSync(
    List<WebDavAccountIsarModel> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'accountId', objects, saveLinks: saveLinks);
  }
}

extension WebDavAccountIsarModelQueryWhereSort
    on QueryBuilder<WebDavAccountIsarModel, WebDavAccountIsarModel, QWhere> {
  QueryBuilder<WebDavAccountIsarModel, WebDavAccountIsarModel, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension WebDavAccountIsarModelQueryWhere
    on
        QueryBuilder<
          WebDavAccountIsarModel,
          WebDavAccountIsarModel,
          QWhereClause
        > {
  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterWhereClause
  >
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
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
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
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
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
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
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
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
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterWhereClause
  >
  accountIdEqualTo(String accountId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'accountId', value: [accountId]),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterWhereClause
  >
  accountIdNotEqualTo(String accountId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'accountId',
                lower: [],
                upper: [accountId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'accountId',
                lower: [accountId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'accountId',
                lower: [accountId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'accountId',
                lower: [],
                upper: [accountId],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension WebDavAccountIsarModelQueryFilter
    on
        QueryBuilder<
          WebDavAccountIsarModel,
          WebDavAccountIsarModel,
          QFilterCondition
        > {
  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  accountIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'accountId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  accountIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'accountId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  accountIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'accountId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  accountIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'accountId',
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
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  accountIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'accountId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  accountIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'accountId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  accountIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'accountId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  accountIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'accountId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  accountIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'accountId', value: ''),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  accountIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'accountId', value: ''),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  aliasEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'alias',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  aliasGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'alias',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  aliasLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'alias',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  aliasBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'alias',
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
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  aliasStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'alias',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  aliasEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'alias',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  aliasContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'alias',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  aliasMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'alias',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  aliasIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'alias', value: ''),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  aliasIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'alias', value: ''),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
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
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
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
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
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
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
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
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  rootPathEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'rootPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  rootPathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'rootPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  rootPathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'rootPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  rootPathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'rootPath',
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
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  rootPathStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'rootPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  rootPathEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'rootPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  rootPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'rootPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  rootPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'rootPath',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  rootPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'rootPath', value: ''),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  rootPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'rootPath', value: ''),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  urlEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'url',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  urlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'url',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  urlLessThan(String value, {bool include = false, bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'url',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  urlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'url',
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
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  urlStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'url',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  urlEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'url',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  urlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'url',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  urlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'url',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  urlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'url', value: ''),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  urlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'url', value: ''),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  usernameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'username',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  usernameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'username',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  usernameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'username',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  usernameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'username',
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
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  usernameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'username',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  usernameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'username',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  usernameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'username',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  usernameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'username',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  usernameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'username', value: ''),
      );
    });
  }

  QueryBuilder<
    WebDavAccountIsarModel,
    WebDavAccountIsarModel,
    QAfterFilterCondition
  >
  usernameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'username', value: ''),
      );
    });
  }
}

extension WebDavAccountIsarModelQueryObject
    on
        QueryBuilder<
          WebDavAccountIsarModel,
          WebDavAccountIsarModel,
          QFilterCondition
        > {}

extension WebDavAccountIsarModelQueryLinks
    on
        QueryBuilder<
          WebDavAccountIsarModel,
          WebDavAccountIsarModel,
          QFilterCondition
        > {}

extension WebDavAccountIsarModelQuerySortBy
    on QueryBuilder<WebDavAccountIsarModel, WebDavAccountIsarModel, QSortBy> {
  QueryBuilder<WebDavAccountIsarModel, WebDavAccountIsarModel, QAfterSortBy>
  sortByAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.asc);
    });
  }

  QueryBuilder<WebDavAccountIsarModel, WebDavAccountIsarModel, QAfterSortBy>
  sortByAccountIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.desc);
    });
  }

  QueryBuilder<WebDavAccountIsarModel, WebDavAccountIsarModel, QAfterSortBy>
  sortByAlias() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alias', Sort.asc);
    });
  }

  QueryBuilder<WebDavAccountIsarModel, WebDavAccountIsarModel, QAfterSortBy>
  sortByAliasDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alias', Sort.desc);
    });
  }

  QueryBuilder<WebDavAccountIsarModel, WebDavAccountIsarModel, QAfterSortBy>
  sortByRootPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rootPath', Sort.asc);
    });
  }

  QueryBuilder<WebDavAccountIsarModel, WebDavAccountIsarModel, QAfterSortBy>
  sortByRootPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rootPath', Sort.desc);
    });
  }

  QueryBuilder<WebDavAccountIsarModel, WebDavAccountIsarModel, QAfterSortBy>
  sortByUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.asc);
    });
  }

  QueryBuilder<WebDavAccountIsarModel, WebDavAccountIsarModel, QAfterSortBy>
  sortByUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.desc);
    });
  }

  QueryBuilder<WebDavAccountIsarModel, WebDavAccountIsarModel, QAfterSortBy>
  sortByUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.asc);
    });
  }

  QueryBuilder<WebDavAccountIsarModel, WebDavAccountIsarModel, QAfterSortBy>
  sortByUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.desc);
    });
  }
}

extension WebDavAccountIsarModelQuerySortThenBy
    on
        QueryBuilder<
          WebDavAccountIsarModel,
          WebDavAccountIsarModel,
          QSortThenBy
        > {
  QueryBuilder<WebDavAccountIsarModel, WebDavAccountIsarModel, QAfterSortBy>
  thenByAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.asc);
    });
  }

  QueryBuilder<WebDavAccountIsarModel, WebDavAccountIsarModel, QAfterSortBy>
  thenByAccountIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.desc);
    });
  }

  QueryBuilder<WebDavAccountIsarModel, WebDavAccountIsarModel, QAfterSortBy>
  thenByAlias() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alias', Sort.asc);
    });
  }

  QueryBuilder<WebDavAccountIsarModel, WebDavAccountIsarModel, QAfterSortBy>
  thenByAliasDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alias', Sort.desc);
    });
  }

  QueryBuilder<WebDavAccountIsarModel, WebDavAccountIsarModel, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WebDavAccountIsarModel, WebDavAccountIsarModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WebDavAccountIsarModel, WebDavAccountIsarModel, QAfterSortBy>
  thenByRootPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rootPath', Sort.asc);
    });
  }

  QueryBuilder<WebDavAccountIsarModel, WebDavAccountIsarModel, QAfterSortBy>
  thenByRootPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rootPath', Sort.desc);
    });
  }

  QueryBuilder<WebDavAccountIsarModel, WebDavAccountIsarModel, QAfterSortBy>
  thenByUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.asc);
    });
  }

  QueryBuilder<WebDavAccountIsarModel, WebDavAccountIsarModel, QAfterSortBy>
  thenByUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.desc);
    });
  }

  QueryBuilder<WebDavAccountIsarModel, WebDavAccountIsarModel, QAfterSortBy>
  thenByUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.asc);
    });
  }

  QueryBuilder<WebDavAccountIsarModel, WebDavAccountIsarModel, QAfterSortBy>
  thenByUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.desc);
    });
  }
}

extension WebDavAccountIsarModelQueryWhereDistinct
    on QueryBuilder<WebDavAccountIsarModel, WebDavAccountIsarModel, QDistinct> {
  QueryBuilder<WebDavAccountIsarModel, WebDavAccountIsarModel, QDistinct>
  distinctByAccountId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accountId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WebDavAccountIsarModel, WebDavAccountIsarModel, QDistinct>
  distinctByAlias({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'alias', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WebDavAccountIsarModel, WebDavAccountIsarModel, QDistinct>
  distinctByRootPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rootPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WebDavAccountIsarModel, WebDavAccountIsarModel, QDistinct>
  distinctByUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'url', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WebDavAccountIsarModel, WebDavAccountIsarModel, QDistinct>
  distinctByUsername({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'username', caseSensitive: caseSensitive);
    });
  }
}

extension WebDavAccountIsarModelQueryProperty
    on
        QueryBuilder<
          WebDavAccountIsarModel,
          WebDavAccountIsarModel,
          QQueryProperty
        > {
  QueryBuilder<WebDavAccountIsarModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WebDavAccountIsarModel, String, QQueryOperations>
  accountIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accountId');
    });
  }

  QueryBuilder<WebDavAccountIsarModel, String, QQueryOperations>
  aliasProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'alias');
    });
  }

  QueryBuilder<WebDavAccountIsarModel, String, QQueryOperations>
  rootPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rootPath');
    });
  }

  QueryBuilder<WebDavAccountIsarModel, String, QQueryOperations> urlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'url');
    });
  }

  QueryBuilder<WebDavAccountIsarModel, String, QQueryOperations>
  usernameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'username');
    });
  }
}
