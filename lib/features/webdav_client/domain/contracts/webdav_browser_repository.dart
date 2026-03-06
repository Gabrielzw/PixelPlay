import '../entities/webdav_entry.dart';
import '../webdav_server_config.dart';

abstract interface class WebDavBrowserRepository {
  Future<void> verifyConnection(
    WebDavServerConfig config, {
    required String password,
  });

  Future<List<WebDavEntry>> readDirectory(
    WebDavServerConfig config, {
    required String password,
    required String path,
  });
}
