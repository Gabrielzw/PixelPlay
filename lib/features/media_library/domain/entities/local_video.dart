import 'package:flutter/foundation.dart';

@immutable
class LocalVideo {
  final int id;
  final String path;
  final String title;
  final String bucketId;
  final String bucketName;
  final int durationMs;
  final int size;
  final int dateAdded;
  final int width;
  final int height;
  final int dateModified;
  final bool isFavorite;
  final int? lastPlayPositionMs;

  const LocalVideo({
    required this.id,
    required this.path,
    required this.title,
    required this.bucketId,
    required this.bucketName,
    required this.durationMs,
    required this.size,
    required this.dateAdded,
    required this.width,
    required this.height,
    required this.dateModified,
    this.isFavorite = false,
    this.lastPlayPositionMs,
  });

  LocalVideo copyWith({bool? isFavorite, int? lastPlayPositionMs}) {
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
      isFavorite: isFavorite ?? this.isFavorite,
      lastPlayPositionMs: lastPlayPositionMs ?? this.lastPlayPositionMs,
    );
  }
}
