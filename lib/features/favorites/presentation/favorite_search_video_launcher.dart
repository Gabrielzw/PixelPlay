import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../webdav_client/domain/contracts/webdav_account_repository.dart';
import 'favorite_folder_player_launcher.dart';
import 'favorite_models.dart';

void Function(FavoriteFolderEntry folder, FavoriteVideoEntry video)
buildFavoriteSearchVideoTapHandler(BuildContext context) {
  return (FavoriteFolderEntry folder, FavoriteVideoEntry video) {
    unawaited(
      openFavoriteFolderVideo(
        context: context,
        folder: folder,
        video: video,
        webDavAccountRepository: Get.find<WebDavAccountRepository>(),
      ),
    );
  };
}
