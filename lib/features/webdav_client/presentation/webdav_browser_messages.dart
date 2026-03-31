String buildWebDavBrowserEmptyMessage(String searchQuery) {
  return searchQuery.isEmpty
      ? '当前目录下没有可显示的视频或子目录。'
      : '没有匹配“$searchQuery”的文件或文件夹。';
}

String formatWebDavBrowserError(Object error) {
  final text = error.toString();
  return text
      .replaceFirst('Exception: ', '')
      .replaceFirst('Bad state: ', '')
      .trim();
}
