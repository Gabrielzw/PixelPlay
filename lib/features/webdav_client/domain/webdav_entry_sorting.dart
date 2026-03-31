import 'entities/webdav_entry.dart';
import 'webdav_sort_option.dart';

List<WebDavEntry> filterAndSortWebDavEntries({
  required List<WebDavEntry> entries,
  required String searchQuery,
  required WebDavSortOption sortOption,
}) {
  final filteredEntries = _filterEntries(entries, searchQuery);
  final directories = filteredEntries
      .where((WebDavEntry entry) => entry.type == WebDavEntryType.directory)
      .toList(growable: true);
  final files = filteredEntries
      .where((WebDavEntry entry) => entry.type != WebDavEntryType.directory)
      .toList(growable: true);
  directories.sort(
    (WebDavEntry left, WebDavEntry right) =>
        _compareEntries(left, right, sortOption),
  );
  files.sort(
    (WebDavEntry left, WebDavEntry right) =>
        _compareEntries(left, right, sortOption),
  );
  return List<WebDavEntry>.unmodifiable(<WebDavEntry>[
    ...directories,
    ...files,
  ]);
}

List<WebDavEntry> _filterEntries(
  List<WebDavEntry> entries,
  String searchQuery,
) {
  final query = searchQuery.toLowerCase();
  if (query.isEmpty) {
    return entries;
  }

  return entries
      .where((WebDavEntry entry) => entry.name.toLowerCase().contains(query))
      .toList(growable: false);
}

int _compareEntries(
  WebDavEntry left,
  WebDavEntry right,
  WebDavSortOption sortOption,
) {
  final result = switch (sortOption) {
    WebDavSortOption.newest => _compareModifiedAt(right, left),
    WebDavSortOption.oldest => _compareModifiedAt(left, right),
    WebDavSortOption.largest => right.size.compareTo(left.size),
    WebDavSortOption.smallest => left.size.compareTo(right.size),
    WebDavSortOption.nameAsc => _compareName(left, right),
    WebDavSortOption.nameDesc => _compareName(right, left),
  };
  return result == 0 ? _compareName(left, right) : result;
}

int _compareModifiedAt(WebDavEntry left, WebDavEntry right) {
  final leftTime = left.modifiedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
  final rightTime = right.modifiedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
  return leftTime.compareTo(rightTime);
}

int _compareName(WebDavEntry left, WebDavEntry right) {
  return left.name.toLowerCase().compareTo(right.name.toLowerCase());
}
