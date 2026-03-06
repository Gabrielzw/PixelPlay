import '../domain/contracts/webdav_browser_repository.dart';
import '../domain/entities/webdav_entry.dart';
import '../domain/webdav_server_config.dart';

class InMemoryWebDavBrowserRepository implements WebDavBrowserRepository {
  final Map<String, List<WebDavEntry>> entriesByPath;

  const InMemoryWebDavBrowserRepository({
    this.entriesByPath = const <String, List<WebDavEntry>>{},
  });

  @override
  Future<void> verifyConnection(
    WebDavServerConfig config, {
    required String password,
  }) async {}

  @override
  Future<List<WebDavEntry>> readDirectory(
    WebDavServerConfig config, {
    required String password,
    required String path,
  }) async {
    return List<WebDavEntry>.unmodifiable(
      entriesByPath[path] ?? const <WebDavEntry>[],
    );
  }
}
