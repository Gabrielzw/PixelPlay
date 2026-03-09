import 'package:get/get.dart';

import '../../../player_core/domain/player_queue_item.dart';
import '../../../../shared/domain/media_source_kind.dart';
import '../../../thumbnail_engine/domain/video_thumbnail_request.dart';
import '../../domain/favorites_repository.dart';
import '../favorite_models.dart';

class FavoritesController extends GetxController {
  final FavoritesRepository repository;
  final RxList<FavoriteFolderEntry> folders = <FavoriteFolderEntry>[].obs;

  FavoritesController({required this.repository});

  @override
  void onInit() {
    super.onInit();
    refreshFolders();
  }

  void refreshFolders() {
    folders.assignAll(repository.loadFolders());
  }

  FavoriteFolderEntry createFolder({required String title, DateTime? now}) {
    final folder = repository.createFolder(title: title, now: now);
    refreshFolders();
    return folder;
  }

  void deleteFolders(Set<String> folderIds) {
    if (folderIds.isEmpty) {
      return;
    }
    repository.deleteFolders(folderIds);
    refreshFolders();
  }

  void addQueueItemToFolders({
    required PlayerQueueItem item,
    required Set<String> folderIds,
    DateTime? now,
  }) {
    if (folderIds.isEmpty) {
      return;
    }

    repository.addVideoToFolders(
      video: buildFavoriteVideoEntry(item: item, now: now),
      folderIds: folderIds,
    );
    refreshFolders();
  }

  Set<String> existingTitles() {
    return folders
        .map(
          (FavoriteFolderEntry folder) =>
              normalizeFavoriteFolderTitle(folder.title),
        )
        .toSet();
  }
}

FavoriteVideoEntry buildFavoriteVideoEntry({
  required PlayerQueueItem item,
  DateTime? now,
}) {
  return FavoriteVideoEntry(
    id: item.id,
    title: item.title,
    durationText: _resolveDurationText(item),
    updatedAt: now ?? DateTime.now(),
    previewSeed: item.localVideoId ?? item.id.hashCode,
    sourceLabel: item.sourceLabel,
    path: item.path,
    sourceUri: item.sourceUri,
    durationMs: item.duration.inMilliseconds,
    sourceKind: _resolveSourceKind(item),
    resolutionText: item.resolutionText,
    previewAspectRatio: item.previewAspectRatio,
    lastKnownPositionMs: item.lastKnownPositionMs,
    localVideoId: item.localVideoId,
    localVideoDateModified: item.localVideoDateModified,
    webDavAccountId: item.webDavAccountId,
    thumbnailRequest: _buildThumbnailRequest(item),
  );
}

MediaSourceKind _resolveSourceKind(PlayerQueueItem item) {
  return item.sourceKind;
}

String normalizeFavoriteFolderTitle(String value) {
  return value.trim().toLowerCase();
}

String _resolveDurationText(PlayerQueueItem item) {
  if (!item.hasKnownDuration) {
    return '--:--';
  }
  final duration = item.duration;
  final totalSeconds = duration.inSeconds;
  final hours = totalSeconds ~/ Duration.secondsPerHour;
  final minutes =
      (totalSeconds % Duration.secondsPerHour) ~/ Duration.secondsPerMinute;
  final seconds = totalSeconds % Duration.secondsPerMinute;
  if (hours > 0) {
    return '$hours:${_twoDigits(minutes)}:${_twoDigits(seconds)}';
  }
  return '${_twoDigits(minutes)}:${_twoDigits(seconds)}';
}

VideoThumbnailRequest? _buildThumbnailRequest(PlayerQueueItem item) {
  final localVideoId = item.localVideoId;
  final dateModified = item.localVideoDateModified;
  final videoPath = item.path;
  if (localVideoId == null || dateModified == null || videoPath == null) {
    return null;
  }

  return VideoThumbnailRequest.tile(
    videoId: localVideoId,
    videoPath: videoPath,
    dateModified: dateModified,
  );
}

String _twoDigits(int value) => value.toString().padLeft(2, '0');
