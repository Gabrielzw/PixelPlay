import 'package:isar_community/isar.dart';

import '../../../../features/webdav_client/domain/webdav_server_config.dart';

part 'webdav_account_isar_model.g.dart';

@collection
class WebDavAccountIsarModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String accountId;

  late String alias;
  late String url;
  late String username;
  late String rootPath;

  WebDavServerConfig toDomain() {
    return WebDavServerConfig(
      id: accountId,
      alias: alias,
      url: Uri.parse(url),
      username: username,
      rootPath: rootPath,
    );
  }

  static WebDavAccountIsarModel fromDomain(
    WebDavServerConfig config, {
    Id? id,
  }) {
    return WebDavAccountIsarModel()
      ..id = id ?? Isar.autoIncrement
      ..accountId = config.id
      ..alias = config.alias
      ..url = config.url.toString()
      ..username = config.username
      ..rootPath = config.rootPath;
  }
}
