import 'package:isar_community/isar.dart';

import '../../../shared/data/isar/schemas/local_video_isar_model.dart';
import '../domain/contracts/media_library_repository.dart';
import '../domain/entities/local_album.dart';
import '../domain/entities/local_video.dart';
import 'pigeon/media_store_albums_api.g.dart' as pigeon;

class AndroidMediaLibraryRepository implements MediaLibraryRepository {
  final Isar isar;
  final pigeon.MediaStoreAlbumsApi api;

  AndroidMediaLibraryRepository({
    required this.isar,
    pigeon.MediaStoreAlbumsApi? api,
  }) : api = api ?? pigeon.MediaStoreAlbumsApi();

  @override
  Future<bool> hasVideoPermission() => api.hasVideoPermission();

  @override
  Future<bool> requestVideoPermission() => api.requestVideoPermission();

  @override
  Future<List<LocalAlbum>> loadLocalAlbums() async {
    await _syncLibrary();
    final videos = await isar.localVideoIsarModels.where().findAll();
    return _buildAlbums(videos);
  }

  @override
  Future<List<LocalVideo>> loadAlbumVideos(String bucketId) async {
    final videos = await isar.localVideoIsarModels
        .filter()
        .bucketIdEqualTo(bucketId)
        .findAll();
    videos.sort(_compareVideos);
    return List<LocalVideo>.unmodifiable(
      videos.map((LocalVideoIsarModel video) => video.toDomain()),
    );
  }

  Future<void> _syncLibrary() async {
    final albumRecords = await api.scanLocalVideoAlbums();
    final existingVideos = await isar.localVideoIsarModels.where().findAll();
    final existingById = <int, LocalVideoIsarModel>{
      for (final video in existingVideos) video.id: video,
    };
    final scannedVideos = <LocalVideoIsarModel>[];
    final scannedIds = <int>{};

    for (final album in albumRecords) {
      final bucketVideos = await api.scanAlbumVideos(album.bucketId);
      for (final record in bucketVideos) {
        final videoId = int.parse(record.id);
        final currentVideo = existingById[videoId];
        scannedVideos.add(_mapVideoRecord(record, currentVideo: currentVideo));
        scannedIds.add(videoId);
      }
    }

    final removedIds = existingById.keys
        .where((int id) => !scannedIds.contains(id))
        .toList(growable: false);

    await isar.writeTxn(() async {
      await isar.localVideoIsarModels.putAll(scannedVideos);
      if (removedIds.isNotEmpty) {
        await isar.localVideoIsarModels.deleteAll(removedIds);
      }
    });
  }

  List<LocalAlbum> _buildAlbums(List<LocalVideoIsarModel> videos) {
    videos.sort(_compareVideos);
    final summaries = <String, _AlbumSummary>{};

    for (final video in videos) {
      final currentSummary = summaries[video.bucketId];
      if (currentSummary == null) {
        summaries[video.bucketId] = _AlbumSummary.fromVideo(video);
        continue;
      }

      summaries[video.bucketId] = currentSummary.copyWith(
        videoCount: currentSummary.videoCount + 1,
      );
    }

    return List<LocalAlbum>.unmodifiable(
      summaries.values.map((summary) => summary.toDomain()),
    );
  }

  int _compareVideos(LocalVideoIsarModel left, LocalVideoIsarModel right) {
    final dateAddedComparison = right.dateAdded.compareTo(left.dateAdded);
    if (dateAddedComparison != 0) {
      return dateAddedComparison;
    }
    return right.dateModified.compareTo(left.dateModified);
  }

  LocalVideoIsarModel _mapVideoRecord(
    pigeon.NativeVideoRecord record, {
    required LocalVideoIsarModel? currentVideo,
  }) {
    return LocalVideoIsarModel()
      ..id = int.parse(record.id)
      ..path = record.path
      ..title = record.name
      ..bucketId = record.bucketId
      ..bucketName = record.bucketName
      ..durationMs = record.durationMs
      ..size = record.size
      ..dateAdded = record.dateAdded
      ..width = record.width
      ..height = record.height
      ..dateModified = record.dateModified
      ..isFavorite = currentVideo?.isFavorite ?? false
      ..lastPlayPositionMs = currentVideo?.lastPlayPositionMs;
  }
}

class _AlbumSummary {
  final String bucketId;
  final String bucketName;
  final int videoCount;
  final int latestDateAddedSeconds;
  final int latestVideoId;
  final String latestVideoPath;
  final int latestVideoDateModified;

  const _AlbumSummary({
    required this.bucketId,
    required this.bucketName,
    required this.videoCount,
    required this.latestDateAddedSeconds,
    required this.latestVideoId,
    required this.latestVideoPath,
    required this.latestVideoDateModified,
  });

  factory _AlbumSummary.fromVideo(LocalVideoIsarModel video) {
    return _AlbumSummary(
      bucketId: video.bucketId,
      bucketName: video.bucketName,
      videoCount: 1,
      latestDateAddedSeconds: video.dateAdded,
      latestVideoId: video.id,
      latestVideoPath: video.path,
      latestVideoDateModified: video.dateModified,
    );
  }

  _AlbumSummary copyWith({required int videoCount}) {
    return _AlbumSummary(
      bucketId: bucketId,
      bucketName: bucketName,
      videoCount: videoCount,
      latestDateAddedSeconds: latestDateAddedSeconds,
      latestVideoId: latestVideoId,
      latestVideoPath: latestVideoPath,
      latestVideoDateModified: latestVideoDateModified,
    );
  }

  LocalAlbum toDomain() {
    return LocalAlbum(
      bucketId: bucketId,
      bucketName: bucketName,
      videoCount: videoCount,
      latestDateAddedSeconds: latestDateAddedSeconds,
      latestVideoId: latestVideoId,
      latestVideoPath: latestVideoPath,
      latestVideoDateModified: latestVideoDateModified,
    );
  }
}
