import 'package:isar_community/isar.dart';

import '../../../../features/playlist_sources/presentation/playlist_source_models.dart';

part 'playlist_source_isar_model.g.dart';

@collection
class PlaylistSourceIsarModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String entryId;

  late String title;
  late int createdAtMs;
  late String sourceKindKey;
  String? localAlbumBucketId;
  String? localAlbumName;
  int? localAlbumVideoCount;
  int? localAlbumLatestDateAddedSeconds;
  int? localAlbumLatestVideoId;
  String? localAlbumLatestVideoPath;
  int? localAlbumLatestVideoDateModified;
  String? webDavAccountId;
  String? webDavAccountAlias;
  String? webDavDirectoryPath;

  PlaylistSourceEntry toDomain() {
    return PlaylistSourceEntry(
      id: entryId,
      title: title,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtMs),
      sourceKind: _parseSourceKind(sourceKindKey),
      localAlbumBucketId: localAlbumBucketId,
      localAlbumName: localAlbumName,
      localAlbumVideoCount: localAlbumVideoCount,
      localAlbumLatestDateAddedSeconds: localAlbumLatestDateAddedSeconds,
      localAlbumLatestVideoId: localAlbumLatestVideoId,
      localAlbumLatestVideoPath: localAlbumLatestVideoPath,
      localAlbumLatestVideoDateModified: localAlbumLatestVideoDateModified,
      webDavAccountId: webDavAccountId,
      webDavAccountAlias: webDavAccountAlias,
      webDavDirectoryPath: webDavDirectoryPath,
    );
  }

  static PlaylistSourceIsarModel fromDomain(
    PlaylistSourceEntry entry, {
    Id? id,
  }) {
    return PlaylistSourceIsarModel()
      ..id = id ?? Isar.autoIncrement
      ..entryId = entry.id
      ..title = entry.title
      ..createdAtMs = entry.createdAt.millisecondsSinceEpoch
      ..sourceKindKey = entry.sourceKind.name
      ..localAlbumBucketId = entry.localAlbumBucketId
      ..localAlbumName = entry.localAlbumName
      ..localAlbumVideoCount = entry.localAlbumVideoCount
      ..localAlbumLatestDateAddedSeconds =
          entry.localAlbumLatestDateAddedSeconds
      ..localAlbumLatestVideoId = entry.localAlbumLatestVideoId
      ..localAlbumLatestVideoPath = entry.localAlbumLatestVideoPath
      ..localAlbumLatestVideoDateModified =
          entry.localAlbumLatestVideoDateModified
      ..webDavAccountId = entry.webDavAccountId
      ..webDavAccountAlias = entry.webDavAccountAlias
      ..webDavDirectoryPath = entry.webDavDirectoryPath;
  }
}

PlaylistSourceKind _parseSourceKind(String value) {
  return PlaylistSourceKind.values.firstWhere(
    (PlaylistSourceKind item) => item.name == value,
    orElse: () => throw StateError('未知播放列表来源类型: $value'),
  );
}
