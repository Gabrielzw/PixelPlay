import 'package:flutter/foundation.dart';

enum WebDavEntryType { directory, video, other }

@immutable
class WebDavEntry {
  final String name;
  final String path;
  final WebDavEntryType type;
  final int size;
  final DateTime? modifiedAt;

  const WebDavEntry({
    required this.name,
    required this.path,
    required this.type,
    required this.size,
    required this.modifiedAt,
  });
}
