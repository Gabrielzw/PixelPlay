import '../webdav_sort_option.dart';

abstract interface class WebDavSortPreferenceStore {
  Future<WebDavSortOption?> readSortOption();

  Future<void> saveSortOption(WebDavSortOption sortOption);
}
