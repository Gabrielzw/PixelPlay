const String kWebDavRootPath = '/';
const String kWebDavAccountIdPrefix = 'webdav_';

String normalizeWebDavPath(String rawPath) {
  final replaced = rawPath.trim().replaceAll('\\', '/');
  if (replaced.isEmpty || replaced == kWebDavRootPath) {
    return kWebDavRootPath;
  }

  final segments = replaced
      .split('/')
      .where((String segment) => segment.isNotEmpty)
      .toList(growable: false);
  if (segments.isEmpty) {
    return kWebDavRootPath;
  }

  return '/${segments.join('/')}';
}

Uri normalizeWebDavUrl(String rawUrl) {
  final parsedUrl = Uri.parse(rawUrl.trim());
  final normalizedPath = normalizeWebDavPath(parsedUrl.path);
  return parsedUrl.replace(path: normalizedPath, query: null, fragment: null);
}

Uri buildWebDavResourceUrl({required Uri baseUrl, required String path}) {
  final normalizedBaseUrl = normalizeWebDavUrl(baseUrl.toString());
  final relativePath = resolveRelativeWebDavPath(
    baseUrl: normalizedBaseUrl,
    path: path,
  );
  final resourceSegments = <String>[
    ...normalizedBaseUrl.pathSegments.where((String value) => value.isNotEmpty),
    ...normalizeWebDavPath(relativePath)
        .split('/')
        .where((String value) => value.isNotEmpty),
  ];

  return normalizedBaseUrl.replace(pathSegments: resourceSegments);
}

String resolveRelativeWebDavPath({required Uri baseUrl, required String path}) {
  final normalizedBasePath = normalizeWebDavPath(baseUrl.path);
  final normalizedPath = normalizeWebDavPath(path);
  if (normalizedBasePath == kWebDavRootPath) {
    return normalizedPath;
  }
  if (normalizedPath == normalizedBasePath) {
    return kWebDavRootPath;
  }
  final prefix = '$normalizedBasePath/';
  if (!normalizedPath.startsWith(prefix)) {
    return normalizedPath;
  }
  final relativePath = normalizedPath.substring(normalizedBasePath.length);
  return normalizeWebDavPath(relativePath);
}

String createWebDavAccountId() {
  final timestamp = DateTime.now().microsecondsSinceEpoch;
  return '$kWebDavAccountIdPrefix$timestamp';
}
