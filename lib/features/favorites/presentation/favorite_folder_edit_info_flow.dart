import 'package:flutter/material.dart';

import '../../../app/router/page_navigation.dart';
import 'controllers/favorites_controller.dart';
import 'favorite_folder_detail_utils.dart';
import 'favorite_folder_form_page.dart';
import 'favorite_models.dart';

Future<FavoriteFolderEntry?> editFavoriteFolderInfo({
  required BuildContext context,
  required FavoriteFolderEntry folder,
  FavoritesController? favoritesController,
}) async {
  final nextTitle = await pushRootPage<String>(
    context,
    (_) => FavoriteFolderFormPage(
      existingTitles: _buildEditableTitles(
        folder: folder,
        favoritesController: favoritesController,
      ),
      initialTitle: folder.title,
      pageTitle: '\u7f16\u8f91\u6536\u85cf\u5939',
      submitLabel: '\u4fdd\u5b58',
      description:
          '\u4fee\u6539\u540e\u4f1a\u540c\u6b65\u66f4\u65b0\u8be5\u6536\u85cf\u5939\u7684\u540d\u79f0\u3002',
    ),
  );
  if (nextTitle == null) {
    return null;
  }

  final controller = favoritesController;
  if (controller == null) {
    return buildRenamedFavoriteFolder(folder: folder, title: nextTitle);
  }
  return controller.renameFolder(folderId: folder.id, title: nextTitle);
}

Set<String> _buildEditableTitles({
  required FavoriteFolderEntry folder,
  FavoritesController? favoritesController,
}) {
  final editableTitles = Set<String>.of(
    favoritesController?.existingTitles() ?? <String>{},
  );
  editableTitles.remove(normalizeFavoriteFolderTitle(folder.title));
  return editableTitles;
}
