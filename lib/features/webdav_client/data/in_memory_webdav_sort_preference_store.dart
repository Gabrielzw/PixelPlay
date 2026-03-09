import '../domain/contracts/webdav_sort_preference_store.dart';
import '../domain/webdav_sort_option.dart';

class InMemoryWebDavSortPreferenceStore implements WebDavSortPreferenceStore {
  WebDavSortOption? _sortOption;

  InMemoryWebDavSortPreferenceStore({WebDavSortOption? initialSortOption})
    : _sortOption = initialSortOption;

  @override
  Future<WebDavSortOption?> readSortOption() async {
    return _sortOption;
  }

  @override
  Future<void> saveSortOption(WebDavSortOption sortOption) async {
    _sortOption = sortOption;
  }
}
