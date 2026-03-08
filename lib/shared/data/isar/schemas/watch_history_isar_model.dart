import 'package:isar_community/isar.dart';

import '../../../../features/watch_history/domain/watch_history_repository.dart';
import '../../../domain/media_source_kind.dart';

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
  String? sourceKindKey;
  String? mediaPath;
  String? sourceUri;
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
      sourceKind: mediaSourceKindFromKey(
        sourceKindKey,
        isRemote: isRemote,
        webDavAccountId: webDavAccountId,
      ),
      mediaPath: mediaPath,
      sourceUri: sourceUri,
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
      ..sourceKindKey = record.sourceKind.key
      ..mediaPath = record.mediaPath
      ..sourceUri = record.sourceUri
      ..localVideoId = record.localVideoId
      ..localVideoDateModified = record.localVideoDateModified
      ..webDavAccountId = record.webDavAccountId;
  }
}
