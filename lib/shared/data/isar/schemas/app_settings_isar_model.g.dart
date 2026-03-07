// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings_isar_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAppSettingsIsarModelCollection on Isar {
  IsarCollection<AppSettingsIsarModel> get appSettingsIsarModels =>
      this.collection();
}

const AppSettingsIsarModelSchema = CollectionSchema(
  name: r'AppSettingsIsarModel',
  id: -142477573158583996,
  properties: {
    r'autoPlayNext': PropertySchema(
      id: 0,
      name: r'autoPlayNext',
      type: IsarType.bool,
    ),
    r'defaultAspectRatioName': PropertySchema(
      id: 1,
      name: r'defaultAspectRatioName',
      type: IsarType.string,
    ),
    r'defaultPlaybackSpeed': PropertySchema(
      id: 2,
      name: r'defaultPlaybackSpeed',
      type: IsarType.double,
    ),
    r'gestureSeekSecondsPerSwipe': PropertySchema(
      id: 3,
      name: r'gestureSeekSecondsPerSwipe',
      type: IsarType.long,
    ),
    r'rememberPlaybackPosition': PropertySchema(
      id: 4,
      name: r'rememberPlaybackPosition',
      type: IsarType.bool,
    ),
    r'seedColorValue': PropertySchema(
      id: 5,
      name: r'seedColorValue',
      type: IsarType.long,
    ),
    r'themeModeName': PropertySchema(
      id: 6,
      name: r'themeModeName',
      type: IsarType.string,
    ),
  },

  estimateSize: _appSettingsIsarModelEstimateSize,
  serialize: _appSettingsIsarModelSerialize,
  deserialize: _appSettingsIsarModelDeserialize,
  deserializeProp: _appSettingsIsarModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _appSettingsIsarModelGetId,
  getLinks: _appSettingsIsarModelGetLinks,
  attach: _appSettingsIsarModelAttach,
  version: '3.3.0',
);

int _appSettingsIsarModelEstimateSize(
  AppSettingsIsarModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.defaultAspectRatioName.length * 3;
  bytesCount += 3 + object.themeModeName.length * 3;
  return bytesCount;
}

void _appSettingsIsarModelSerialize(
  AppSettingsIsarModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.autoPlayNext);
  writer.writeString(offsets[1], object.defaultAspectRatioName);
  writer.writeDouble(offsets[2], object.defaultPlaybackSpeed);
  writer.writeLong(offsets[3], object.gestureSeekSecondsPerSwipe);
  writer.writeBool(offsets[4], object.rememberPlaybackPosition);
  writer.writeLong(offsets[5], object.seedColorValue);
  writer.writeString(offsets[6], object.themeModeName);
}

AppSettingsIsarModel _appSettingsIsarModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AppSettingsIsarModel();
  object.autoPlayNext = reader.readBool(offsets[0]);
  object.defaultAspectRatioName = reader.readString(offsets[1]);
  object.defaultPlaybackSpeed = reader.readDouble(offsets[2]);
  object.gestureSeekSecondsPerSwipe = reader.readLong(offsets[3]);
  object.id = id;
  object.rememberPlaybackPosition = reader.readBool(offsets[4]);
  object.seedColorValue = reader.readLong(offsets[5]);
  object.themeModeName = reader.readString(offsets[6]);
  return object;
}

P _appSettingsIsarModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _appSettingsIsarModelGetId(AppSettingsIsarModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _appSettingsIsarModelGetLinks(
  AppSettingsIsarModel object,
) {
  return [];
}

void _appSettingsIsarModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  AppSettingsIsarModel object,
) {
  object.id = id;
}

extension AppSettingsIsarModelQueryWhereSort
    on QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QWhere> {
  QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AppSettingsIsarModelQueryWhere
    on QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QWhereClause> {
  QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QAfterWhereClause>
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

  QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QAfterWhereClause>
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

extension AppSettingsIsarModelQueryFilter
    on
        QueryBuilder<
          AppSettingsIsarModel,
          AppSettingsIsarModel,
          QFilterCondition
        > {
  QueryBuilder<
    AppSettingsIsarModel,
    AppSettingsIsarModel,
    QAfterFilterCondition
  >
  autoPlayNextEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'autoPlayNext', value: value),
      );
    });
  }

  QueryBuilder<
    AppSettingsIsarModel,
    AppSettingsIsarModel,
    QAfterFilterCondition
  >
  defaultAspectRatioNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'defaultAspectRatioName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AppSettingsIsarModel,
    AppSettingsIsarModel,
    QAfterFilterCondition
  >
  defaultAspectRatioNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'defaultAspectRatioName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AppSettingsIsarModel,
    AppSettingsIsarModel,
    QAfterFilterCondition
  >
  defaultAspectRatioNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'defaultAspectRatioName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AppSettingsIsarModel,
    AppSettingsIsarModel,
    QAfterFilterCondition
  >
  defaultAspectRatioNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'defaultAspectRatioName',
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
    AppSettingsIsarModel,
    AppSettingsIsarModel,
    QAfterFilterCondition
  >
  defaultAspectRatioNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'defaultAspectRatioName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AppSettingsIsarModel,
    AppSettingsIsarModel,
    QAfterFilterCondition
  >
  defaultAspectRatioNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'defaultAspectRatioName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AppSettingsIsarModel,
    AppSettingsIsarModel,
    QAfterFilterCondition
  >
  defaultAspectRatioNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'defaultAspectRatioName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AppSettingsIsarModel,
    AppSettingsIsarModel,
    QAfterFilterCondition
  >
  defaultAspectRatioNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'defaultAspectRatioName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AppSettingsIsarModel,
    AppSettingsIsarModel,
    QAfterFilterCondition
  >
  defaultAspectRatioNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'defaultAspectRatioName', value: ''),
      );
    });
  }

  QueryBuilder<
    AppSettingsIsarModel,
    AppSettingsIsarModel,
    QAfterFilterCondition
  >
  defaultAspectRatioNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'defaultAspectRatioName',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<
    AppSettingsIsarModel,
    AppSettingsIsarModel,
    QAfterFilterCondition
  >
  defaultPlaybackSpeedEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'defaultPlaybackSpeed',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    AppSettingsIsarModel,
    AppSettingsIsarModel,
    QAfterFilterCondition
  >
  defaultPlaybackSpeedGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'defaultPlaybackSpeed',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    AppSettingsIsarModel,
    AppSettingsIsarModel,
    QAfterFilterCondition
  >
  defaultPlaybackSpeedLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'defaultPlaybackSpeed',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    AppSettingsIsarModel,
    AppSettingsIsarModel,
    QAfterFilterCondition
  >
  defaultPlaybackSpeedBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'defaultPlaybackSpeed',
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
    AppSettingsIsarModel,
    AppSettingsIsarModel,
    QAfterFilterCondition
  >
  gestureSeekSecondsPerSwipeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'gestureSeekSecondsPerSwipe',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    AppSettingsIsarModel,
    AppSettingsIsarModel,
    QAfterFilterCondition
  >
  gestureSeekSecondsPerSwipeGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'gestureSeekSecondsPerSwipe',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    AppSettingsIsarModel,
    AppSettingsIsarModel,
    QAfterFilterCondition
  >
  gestureSeekSecondsPerSwipeLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'gestureSeekSecondsPerSwipe',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    AppSettingsIsarModel,
    AppSettingsIsarModel,
    QAfterFilterCondition
  >
  gestureSeekSecondsPerSwipeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'gestureSeekSecondsPerSwipe',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    AppSettingsIsarModel,
    AppSettingsIsarModel,
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
    AppSettingsIsarModel,
    AppSettingsIsarModel,
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
    AppSettingsIsarModel,
    AppSettingsIsarModel,
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
    AppSettingsIsarModel,
    AppSettingsIsarModel,
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
    AppSettingsIsarModel,
    AppSettingsIsarModel,
    QAfterFilterCondition
  >
  rememberPlaybackPositionEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'rememberPlaybackPosition',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    AppSettingsIsarModel,
    AppSettingsIsarModel,
    QAfterFilterCondition
  >
  seedColorValueEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'seedColorValue', value: value),
      );
    });
  }

  QueryBuilder<
    AppSettingsIsarModel,
    AppSettingsIsarModel,
    QAfterFilterCondition
  >
  seedColorValueGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'seedColorValue',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    AppSettingsIsarModel,
    AppSettingsIsarModel,
    QAfterFilterCondition
  >
  seedColorValueLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'seedColorValue',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    AppSettingsIsarModel,
    AppSettingsIsarModel,
    QAfterFilterCondition
  >
  seedColorValueBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'seedColorValue',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    AppSettingsIsarModel,
    AppSettingsIsarModel,
    QAfterFilterCondition
  >
  themeModeNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'themeModeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AppSettingsIsarModel,
    AppSettingsIsarModel,
    QAfterFilterCondition
  >
  themeModeNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'themeModeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AppSettingsIsarModel,
    AppSettingsIsarModel,
    QAfterFilterCondition
  >
  themeModeNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'themeModeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AppSettingsIsarModel,
    AppSettingsIsarModel,
    QAfterFilterCondition
  >
  themeModeNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'themeModeName',
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
    AppSettingsIsarModel,
    AppSettingsIsarModel,
    QAfterFilterCondition
  >
  themeModeNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'themeModeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AppSettingsIsarModel,
    AppSettingsIsarModel,
    QAfterFilterCondition
  >
  themeModeNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'themeModeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AppSettingsIsarModel,
    AppSettingsIsarModel,
    QAfterFilterCondition
  >
  themeModeNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'themeModeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AppSettingsIsarModel,
    AppSettingsIsarModel,
    QAfterFilterCondition
  >
  themeModeNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'themeModeName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AppSettingsIsarModel,
    AppSettingsIsarModel,
    QAfterFilterCondition
  >
  themeModeNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'themeModeName', value: ''),
      );
    });
  }

  QueryBuilder<
    AppSettingsIsarModel,
    AppSettingsIsarModel,
    QAfterFilterCondition
  >
  themeModeNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'themeModeName', value: ''),
      );
    });
  }
}

extension AppSettingsIsarModelQueryObject
    on
        QueryBuilder<
          AppSettingsIsarModel,
          AppSettingsIsarModel,
          QFilterCondition
        > {}

extension AppSettingsIsarModelQueryLinks
    on
        QueryBuilder<
          AppSettingsIsarModel,
          AppSettingsIsarModel,
          QFilterCondition
        > {}

extension AppSettingsIsarModelQuerySortBy
    on QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QSortBy> {
  QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QAfterSortBy>
  sortByAutoPlayNext() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoPlayNext', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QAfterSortBy>
  sortByAutoPlayNextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoPlayNext', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QAfterSortBy>
  sortByDefaultAspectRatioName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultAspectRatioName', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QAfterSortBy>
  sortByDefaultAspectRatioNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultAspectRatioName', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QAfterSortBy>
  sortByDefaultPlaybackSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultPlaybackSpeed', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QAfterSortBy>
  sortByDefaultPlaybackSpeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultPlaybackSpeed', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QAfterSortBy>
  sortByGestureSeekSecondsPerSwipe() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gestureSeekSecondsPerSwipe', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QAfterSortBy>
  sortByGestureSeekSecondsPerSwipeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gestureSeekSecondsPerSwipe', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QAfterSortBy>
  sortByRememberPlaybackPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rememberPlaybackPosition', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QAfterSortBy>
  sortByRememberPlaybackPositionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rememberPlaybackPosition', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QAfterSortBy>
  sortBySeedColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seedColorValue', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QAfterSortBy>
  sortBySeedColorValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seedColorValue', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QAfterSortBy>
  sortByThemeModeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeModeName', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QAfterSortBy>
  sortByThemeModeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeModeName', Sort.desc);
    });
  }
}

extension AppSettingsIsarModelQuerySortThenBy
    on QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QSortThenBy> {
  QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QAfterSortBy>
  thenByAutoPlayNext() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoPlayNext', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QAfterSortBy>
  thenByAutoPlayNextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoPlayNext', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QAfterSortBy>
  thenByDefaultAspectRatioName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultAspectRatioName', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QAfterSortBy>
  thenByDefaultAspectRatioNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultAspectRatioName', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QAfterSortBy>
  thenByDefaultPlaybackSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultPlaybackSpeed', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QAfterSortBy>
  thenByDefaultPlaybackSpeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultPlaybackSpeed', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QAfterSortBy>
  thenByGestureSeekSecondsPerSwipe() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gestureSeekSecondsPerSwipe', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QAfterSortBy>
  thenByGestureSeekSecondsPerSwipeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gestureSeekSecondsPerSwipe', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QAfterSortBy>
  thenByRememberPlaybackPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rememberPlaybackPosition', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QAfterSortBy>
  thenByRememberPlaybackPositionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rememberPlaybackPosition', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QAfterSortBy>
  thenBySeedColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seedColorValue', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QAfterSortBy>
  thenBySeedColorValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seedColorValue', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QAfterSortBy>
  thenByThemeModeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeModeName', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QAfterSortBy>
  thenByThemeModeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeModeName', Sort.desc);
    });
  }
}

extension AppSettingsIsarModelQueryWhereDistinct
    on QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QDistinct> {
  QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QDistinct>
  distinctByAutoPlayNext() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'autoPlayNext');
    });
  }

  QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QDistinct>
  distinctByDefaultAspectRatioName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'defaultAspectRatioName',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QDistinct>
  distinctByDefaultPlaybackSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultPlaybackSpeed');
    });
  }

  QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QDistinct>
  distinctByGestureSeekSecondsPerSwipe() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gestureSeekSecondsPerSwipe');
    });
  }

  QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QDistinct>
  distinctByRememberPlaybackPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rememberPlaybackPosition');
    });
  }

  QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QDistinct>
  distinctBySeedColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'seedColorValue');
    });
  }

  QueryBuilder<AppSettingsIsarModel, AppSettingsIsarModel, QDistinct>
  distinctByThemeModeName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'themeModeName',
        caseSensitive: caseSensitive,
      );
    });
  }
}

extension AppSettingsIsarModelQueryProperty
    on
        QueryBuilder<
          AppSettingsIsarModel,
          AppSettingsIsarModel,
          QQueryProperty
        > {
  QueryBuilder<AppSettingsIsarModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AppSettingsIsarModel, bool, QQueryOperations>
  autoPlayNextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoPlayNext');
    });
  }

  QueryBuilder<AppSettingsIsarModel, String, QQueryOperations>
  defaultAspectRatioNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultAspectRatioName');
    });
  }

  QueryBuilder<AppSettingsIsarModel, double, QQueryOperations>
  defaultPlaybackSpeedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultPlaybackSpeed');
    });
  }

  QueryBuilder<AppSettingsIsarModel, int, QQueryOperations>
  gestureSeekSecondsPerSwipeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gestureSeekSecondsPerSwipe');
    });
  }

  QueryBuilder<AppSettingsIsarModel, bool, QQueryOperations>
  rememberPlaybackPositionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rememberPlaybackPosition');
    });
  }

  QueryBuilder<AppSettingsIsarModel, int, QQueryOperations>
  seedColorValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'seedColorValue');
    });
  }

  QueryBuilder<AppSettingsIsarModel, String, QQueryOperations>
  themeModeNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'themeModeName');
    });
  }
}
