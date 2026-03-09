import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'schemas/favorite_folder_isar_model.dart';
import 'schemas/app_settings_isar_model.dart';
import 'schemas/local_video_isar_model.dart';
import 'schemas/playback_position_isar_model.dart';
import 'schemas/watch_history_isar_model.dart';
import 'schemas/webdav_account_isar_model.dart';

const String kPixelPlayIsarName = 'pixelplay';

Future<Isar> openPixelPlayIsar() async {
  final documentsDirectory = await getApplicationDocumentsDirectory();
  return Isar.open(
    <CollectionSchema>[
      AppSettingsIsarModelSchema,
      FavoriteFolderIsarModelSchema,
      LocalVideoIsarModelSchema,
      PlaybackPositionIsarModelSchema,
      WatchHistoryIsarModelSchema,
      WebDavAccountIsarModelSchema,
    ],
    directory: documentsDirectory.path,
    name: kPixelPlayIsarName,
  );
}
