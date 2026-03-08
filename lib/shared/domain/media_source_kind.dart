enum MediaSourceKind { local, webDav, other }

extension MediaSourceKindCodec on MediaSourceKind {
  String get key => switch (this) {
    MediaSourceKind.local => 'local',
    MediaSourceKind.webDav => 'webdav',
    MediaSourceKind.other => 'other',
  };
}

MediaSourceKind mediaSourceKindFromKey(
  String? key, {
  bool? isRemote,
  String? webDavAccountId,
}) {
  return switch (key) {
    'local' => MediaSourceKind.local,
    'webdav' => MediaSourceKind.webDav,
    'other' => MediaSourceKind.other,
    _ =>
      webDavAccountId != null
          ? MediaSourceKind.webDav
          : isRemote == true
          ? MediaSourceKind.other
          : MediaSourceKind.local,
  };
}
