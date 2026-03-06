import 'package:flutter/foundation.dart';

@immutable
class WebDavServerConfig {
  final String id;
  final String alias;
  final Uri url;
  final String username;
  final String rootPath;

  const WebDavServerConfig({
    required this.id,
    required this.alias,
    required this.url,
    required this.username,
    required this.rootPath,
  });

  WebDavServerConfig copyWith({
    String? id,
    String? alias,
    Uri? url,
    String? username,
    String? rootPath,
  }) {
    return WebDavServerConfig(
      id: id ?? this.id,
      alias: alias ?? this.alias,
      url: url ?? this.url,
      username: username ?? this.username,
      rootPath: rootPath ?? this.rootPath,
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'id': id,
      'alias': alias,
      'url': url.toString(),
      'username': username,
      'rootPath': rootPath,
    };
  }

  factory WebDavServerConfig.fromJson(Map<String, Object?> json) {
    return WebDavServerConfig(
      id: json['id']! as String,
      alias: json['alias']! as String,
      url: Uri.parse(json['url']! as String),
      username: json['username']! as String,
      rootPath: json['rootPath']! as String,
    );
  }
}
