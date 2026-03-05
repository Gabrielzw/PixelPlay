import 'package:flutter/foundation.dart';

@immutable
class WebDavServerConfig {
  final String alias;
  final Uri url;
  final String username;
  final String rootPath;

  const WebDavServerConfig({
    required this.alias,
    required this.url,
    required this.username,
    required this.rootPath,
  });
}
