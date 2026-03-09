import 'dart:convert';

import 'webdav_server_config.dart';

Map<String, String> buildWebDavAuthHeaders({
  required WebDavServerConfig account,
  required String password,
}) {
  if (account.username.trim().isEmpty) {
    return const <String, String>{};
  }

  final authorization = base64Encode(
    utf8.encode('${account.username}:$password'),
  );
  return <String, String>{'Authorization': 'Basic $authorization'};
}
