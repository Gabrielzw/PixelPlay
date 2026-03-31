enum WebDavSortOption { newest, oldest, largest, smallest, nameAsc, nameDesc }

extension WebDavSortOptionX on WebDavSortOption {
  String get label {
    return switch (this) {
      WebDavSortOption.newest => '最新',
      WebDavSortOption.oldest => '最旧',
      WebDavSortOption.largest => '最大',
      WebDavSortOption.smallest => '最小',
      WebDavSortOption.nameAsc => '名称 A-Z',
      WebDavSortOption.nameDesc => '名称 Z-A',
    };
  }
}
