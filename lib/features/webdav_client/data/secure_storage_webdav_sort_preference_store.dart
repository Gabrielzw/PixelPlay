import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../domain/contracts/webdav_sort_preference_store.dart';
import '../domain/webdav_sort_option.dart';

const String _sortOptionKey = 'webdav.browser.sort_option';

class SecureStorageWebDavSortPreferenceStore
    implements WebDavSortPreferenceStore {
  final FlutterSecureStorage storage;

  const SecureStorageWebDavSortPreferenceStore({required this.storage});

  @override
  Future<WebDavSortOption?> readSortOption() async {
    final storedValue = await storage.read(key: _sortOptionKey);
    if (storedValue == null || storedValue.isEmpty) {
      return null;
    }

    for (final sortOption in WebDavSortOption.values) {
      if (sortOption.name == storedValue) {
        return sortOption;
      }
    }

    throw StateError('无法识别已保存的 WebDAV 排序选项：$storedValue');
  }

  @override
  Future<void> saveSortOption(WebDavSortOption sortOption) {
    return storage.write(key: _sortOptionKey, value: sortOption.name);
  }
}
