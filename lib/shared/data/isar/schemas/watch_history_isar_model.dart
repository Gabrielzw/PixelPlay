import 'package:isar_community/isar.dart';

import '../../../../features/watch_history/domain/watch_history_repository.dart';

part 'watch_history_isar_model.g.dart';

@collection
class WatchHistoryIsarModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String mediaId;

  late String title;
  late String sourceLabel;
  late int watchedAtMs;
  late int positionMs;
  late int durationMs;
  late bool isRemote;
  String? mediaPath;
  int? localVideoId;
  int? localVideoDateModified;
  String? webDavAccountId;

  WatchHistoryRecord toDomain() {
    return WatchHistoryRecord(
      mediaId: mediaId,
      title: title,
      sourceLabel: sourceLabel,
      watchedAtMs: watchedAtMs,
      positionMs: positionMs,
      durationMs: durationMs,
      isRemote: isRemote,
      mediaPath: mediaPath,
      localVideoId: localVideoId,
      localVideoDateModified: localVideoDateModified,
      webDavAccountId: webDavAccountId,
    );
  }

  static WatchHistoryIsarModel fromDomain(WatchHistoryRecord record, {Id? id}) {
    return WatchHistoryIsarModel()
      ..id = id ?? Isar.autoIncrement
      ..mediaId = record.mediaId
      ..title = record.title
      ..sourceLabel = record.sourceLabel
      ..watchedAtMs = record.watchedAtMs
      ..positionMs = record.positionMs
      ..durationMs = record.durationMs
      ..isRemote = record.isRemote
      ..mediaPath = record.mediaPath
      ..localVideoId = record.localVideoId
      ..localVideoDateModified = record.localVideoDateModified
      ..webDavAccountId = record.webDavAccountId;
  }
}
