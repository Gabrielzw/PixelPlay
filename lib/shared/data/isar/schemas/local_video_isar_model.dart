import 'package:isar_community/isar.dart';

import '../../../../features/media_library/domain/entities/local_video.dart';

part 'local_video_isar_model.g.dart';

@collection
class LocalVideoIsarModel {
  late Id id;

  @Index(unique: true, replace: true)
  late String path;

  @Index()
  late String bucketId;

  late String title;
  late String bucketName;
  late int durationMs;
  late int size;
  late int dateAdded;
  late int width;
  late int height;
  late int dateModified;
  bool isFavorite = false;
  int? lastPlayPositionMs;

  LocalVideo toDomain() {
    return LocalVideo(
      id: id,
      path: path,
      title: title,
      bucketId: bucketId,
      bucketName: bucketName,
      durationMs: durationMs,
      size: size,
      dateAdded: dateAdded,
      width: width,
      height: height,
      dateModified: dateModified,
      isFavorite: isFavorite,
      lastPlayPositionMs: lastPlayPositionMs,
    );
  }
}
