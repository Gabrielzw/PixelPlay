import 'package:flutter/foundation.dart';

enum WebDavEntryType { directory, video, other }

@immutable
class WebDavEntry {
  final String name;
  final WebDavEntryType type;

  const WebDavEntry({required this.name, required this.type});
}

