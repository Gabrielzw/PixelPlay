import 'package:flutter/foundation.dart';

@immutable
class WebDavAccount {
  final String name;
  final Uri server;
  final String username;
  final String rootPath;

  const WebDavAccount({
    required this.name,
    required this.server,
    required this.username,
    required this.rootPath,
  });
}
