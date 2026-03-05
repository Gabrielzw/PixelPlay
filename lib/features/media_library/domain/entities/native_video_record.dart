import 'package:flutter/foundation.dart';

@immutable
class NativeVideoRecord {
  final String id;
  final String path;
  final String name;
  final String bucketId;
  final String bucketName;
  final int durationMs;
  final int size;
  final int dateAdded;

  const NativeVideoRecord({
    required this.id,
    required this.path,
    required this.name,
    required this.bucketId,
    required this.bucketName,
    required this.durationMs,
    required this.size,
    required this.dateAdded,
  });
}

