import 'package:webdav_client/webdav_client.dart' as webdav;

import '../domain/contracts/webdav_browser_repository.dart';
import '../domain/entities/webdav_entry.dart';
import '../domain/webdav_paths.dart';
import '../domain/webdav_server_config.dart';

const int _webDavTimeoutMs = 8000;
const Set<String> _videoExtensions = <String>{
  '.3gp',
  '.avi',
  '.flv',
  '.m2ts',
  '.m4v',
  '.mkv',
  '.mov',
  '.mp4',
  '.mpeg',
  '.mpg',
  '.ts',
  '.webm',
  '.wmv',
};

class WebDavClientBrowserRepository implements WebDavBrowserRepository {
  const WebDavClientBrowserRepository();

  @override
  Future<void> verifyConnection(
    WebDavServerConfig config, {
    required String password,
  }) async {
    final client = _buildClient(config: config, password: password);
    final requestPath = _resolveRequestPath(config, config.rootPath);
    await client.ping();
    await client.readDir(requestPath);
  }

  @override
  Future<List<WebDavEntry>> readDirectory(
    WebDavServerConfig config, {
    required String password,
    required String path,
  }) async {
    final client = _buildClient(config: config, password: password);
    final requestPath = _resolveRequestPath(config, path);
    final files = await client.readDir(requestPath);
    final entries = files
        .map(_mapEntry)
        .where((WebDavEntry entry) => entry.type != WebDavEntryType.other)
        .toList(growable: true);
    entries.sort(_compareEntries);
    return List<WebDavEntry>.unmodifiable(entries);
  }

  webdav.Client _buildClient({
    required WebDavServerConfig config,
    required String password,
  }) {
    final client = webdav.newClient(
      normalizeWebDavUrl(config.url.toString()).toString(),
      user: config.username,
      password: password,
    );
    client.setHeaders(<String, dynamic>{'accept-charset': 'utf-8'});
    client.setConnectTimeout(_webDavTimeoutMs);
    client.setSendTimeout(_webDavTimeoutMs);
    client.setReceiveTimeout(_webDavTimeoutMs);
    return client;
  }

  String _resolveRequestPath(WebDavServerConfig config, String path) {
    return resolveRelativeWebDavPath(
      baseUrl: normalizeWebDavUrl(config.url.toString()),
      path: path,
    );
  }

  WebDavEntry _mapEntry(webdav.File file) {
    final path = normalizeWebDavPath(file.path ?? kWebDavRootPath);
    final name = _resolveName(file, path);
    return WebDavEntry(
      name: name,
      path: path,
      type: _resolveEntryType(file, name),
      size: file.size ?? 0,
      modifiedAt: file.mTime,
    );
  }

  String _resolveName(webdav.File file, String normalizedPath) {
    final explicitName = file.name?.trim();
    if (explicitName != null && explicitName.isNotEmpty) {
      return explicitName;
    }

    final segments = normalizedPath
        .split('/')
        .where((String segment) => segment.isNotEmpty)
        .toList(growable: false);
    if (segments.isEmpty) {
      return normalizedPath;
    }
    return segments.last;
  }

  WebDavEntryType _resolveEntryType(webdav.File file, String name) {
    if (file.isDir ?? false) {
      return WebDavEntryType.directory;
    }

    final extensionIndex = name.lastIndexOf('.');
    if (extensionIndex < 0) {
      return WebDavEntryType.other;
    }

    final extension = name.substring(extensionIndex).toLowerCase();
    return _videoExtensions.contains(extension)
        ? WebDavEntryType.video
        : WebDavEntryType.other;
  }

  int _compareEntries(WebDavEntry left, WebDavEntry right) {
    final leftPriority = left.type == WebDavEntryType.directory ? 0 : 1;
    final rightPriority = right.type == WebDavEntryType.directory ? 0 : 1;
    if (leftPriority != rightPriority) {
      return leftPriority.compareTo(rightPriority);
    }
    return left.name.toLowerCase().compareTo(right.name.toLowerCase());
  }
}
