import 'package:isar_community/isar.dart';

import '../../../shared/data/isar/schemas/local_video_isar_model.dart';
import '../../../shared/data/isar/schemas/playback_position_isar_model.dart';
import '../domain/playback_position_repository.dart';

class IsarPlaybackPositionRepository implements PlaybackPositionRepository {
  final Isar isar;

  const IsarPlaybackPositionRepository({required this.isar});

  @override
  Future<PlaybackPositionRecord?> load(String mediaId) async {
    final storedRecord = await _findRecord(mediaId);
    return storedRecord?.toDomain();
  }

  @override
  Future<void> save(PlaybackPositionRecord record) async {
    final storedRecord = await _findRecord(record.mediaId);
    final nextRecord = PlaybackPositionIsarModel.fromDomain(
      record,
      id: storedRecord?.id,
    );
    await isar.writeTxn(() async {
      await isar.playbackPositionIsarModels.put(nextRecord);
      await _syncLocalVideoProgress(record.mediaId, record.positionMs);
    });
  }

  @override
  Future<void> clear(String mediaId) async {
    final storedRecord = await _findRecord(mediaId);
    await isar.writeTxn(() async {
      if (storedRecord != null) {
        await isar.playbackPositionIsarModels.delete(storedRecord.id);
      }
      await _syncLocalVideoProgress(mediaId, null);
    });
  }

  @override
  Future<void> clearAll() async {
    await isar.writeTxn(() async {
      await isar.playbackPositionIsarModels.clear();
      await _clearLocalVideoProgress();
    });
  }

  Future<PlaybackPositionIsarModel?> _findRecord(String mediaId) {
    return isar.playbackPositionIsarModels
        .filter()
        .mediaIdEqualTo(mediaId)
        .findFirst();
  }

  Future<void> _syncLocalVideoProgress(String mediaId, int? positionMs) async {
    final localVideoId = int.tryParse(mediaId);
    if (localVideoId == null) {
      return;
    }

    final localVideo = await isar.localVideoIsarModels.get(localVideoId);
    if (localVideo == null) {
      return;
    }

    localVideo.lastPlayPositionMs = positionMs;
    await isar.localVideoIsarModels.put(localVideo);
  }

  Future<void> _clearLocalVideoProgress() async {
    final localVideos = await isar.localVideoIsarModels
        .filter()
        .lastPlayPositionMsIsNotNull()
        .findAll();
    if (localVideos.isEmpty) {
      return;
    }

    for (final localVideo in localVideos) {
      localVideo.lastPlayPositionMs = null;
    }
    await isar.localVideoIsarModels.putAll(localVideos);
  }
}
