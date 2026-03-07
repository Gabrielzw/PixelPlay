import 'package:isar_community/isar.dart';

import '../../../../features/player_core/domain/playback_position_repository.dart';

part 'playback_position_isar_model.g.dart';

@collection
class PlaybackPositionIsarModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String mediaId;

  late int positionMs;
  late int durationMs;

  PlaybackPositionRecord toDomain() {
    return PlaybackPositionRecord(
      mediaId: mediaId,
      positionMs: positionMs,
      durationMs: durationMs,
    );
  }

  static PlaybackPositionIsarModel fromDomain(
    PlaybackPositionRecord record, {
    Id? id,
  }) {
    return PlaybackPositionIsarModel()
      ..id = id ?? Isar.autoIncrement
      ..mediaId = record.mediaId
      ..positionMs = record.positionMs
      ..durationMs = record.durationMs;
  }
}
