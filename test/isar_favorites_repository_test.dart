import 'dart:ffi';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';

import 'package:pixelplay/features/favorites/data/isar_favorites_repository.dart';
import 'package:pixelplay/features/favorites/presentation/favorite_models.dart';
import 'package:pixelplay/features/thumbnail_engine/domain/video_thumbnail_request.dart';
import 'package:pixelplay/shared/data/isar/schemas/favorite_folder_isar_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDirectory;

  setUpAll(() async {
    await _initializeIsarCore();
  });

  setUp(() async {
    tempDirectory = await Directory.systemTemp.createTemp('pixelplay_fav_');
  });

  tearDown(() async {
    final isar = Isar.getInstance('favorites_test');
    if (isar != null) {
      await isar.close(deleteFromDisk: true);
    }
    if (tempDirectory.existsSync()) {
      await tempDirectory.delete(recursive: true);
    }
  });

  test('persists favorite folders and videos across Isar reopen', () async {
    final isar = await Isar.open(
      <CollectionSchema>[FavoriteFolderIsarModelSchema],
      directory: tempDirectory.path,
      name: 'favorites_test',
    );
    final repository = IsarFavoritesRepository(isar: isar);
    final folder = repository.createFolder(
      title: 'Movies',
      now: DateTime(2026, 3, 9, 10),
    );

    repository.addVideoToFolders(
      video: FavoriteVideoEntry(
        id: 'video-1',
        title: 'Test Clip.mp4',
        durationText: '03:25',
        updatedAt: DateTime(2026, 3, 9, 11),
        previewSeed: 1,
        thumbnailRequest: VideoThumbnailRequest.tile(
          videoId: 1,
          videoPath: '/storage/emulated/0/DCIM/Test Clip.mp4',
          dateModified: 123,
        ),
      ),
      folderIds: <String>{folder.id},
    );

    await isar.close();

    final reopenedIsar = await Isar.open(
      <CollectionSchema>[FavoriteFolderIsarModelSchema],
      directory: tempDirectory.path,
      name: 'favorites_test',
    );
    final reopenedRepository = IsarFavoritesRepository(isar: reopenedIsar);
    final storedFolders = reopenedRepository.loadFolders();
    final storedFolder = storedFolders.firstWhere(
      (FavoriteFolderEntry item) => item.id == folder.id,
    );

    expect(
      storedFolders.map((FavoriteFolderEntry item) => item.id),
      contains(folder.id),
    );
    expect(storedFolder.title, 'Movies');
    expect(storedFolder.videos, hasLength(1));
    expect(storedFolder.videos.single.title, 'Test Clip.mp4');
    expect(
      storedFolder.videos.single.thumbnailRequest?.videoPath,
      '/storage/emulated/0/DCIM/Test Clip.mp4',
    );
  });
}

Future<void> _initializeIsarCore() async {
  final packageRoot = _resolvePackageRoot('isar_community_flutter_libs');
  final libraryPath =
      '$packageRoot${Platform.pathSeparator}windows${Platform.pathSeparator}libisar.dll';
  await Isar.initializeIsarCore(
    libraries: <Abi, String>{Abi.current(): libraryPath},
  );
}

String _resolvePackageRoot(String packageName) {
  final packageConfigFile = File('.dart_tool/package_config.json');
  if (!packageConfigFile.existsSync()) {
    throw StateError('Failed to find .dart_tool/package_config.json.');
  }

  final packageConfig = jsonDecode(packageConfigFile.readAsStringSync());
  final packages = packageConfig['packages'];
  if (packages is! List<dynamic>) {
    throw StateError('Invalid package_config.json: missing packages list.');
  }

  for (final package in packages) {
    if (package is! Map<String, dynamic>) {
      continue;
    }
    if (package['name'] != packageName) {
      continue;
    }

    final rootUri = package['rootUri'];
    if (rootUri is! String) {
      break;
    }

    return Uri.parse(rootUri).toFilePath(windows: Platform.isWindows);
  }

  throw StateError('Failed to resolve package root for $packageName.');
}
