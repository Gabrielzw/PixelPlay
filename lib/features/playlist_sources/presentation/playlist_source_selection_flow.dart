import 'package:flutter/material.dart';

import '../../../app/router/page_navigation.dart';
import '../../../shared/widgets/pp_toast.dart';
import '../../media_library/domain/contracts/media_library_repository.dart';
import '../../media_library/domain/entities/local_album.dart';
import '../../webdav_client/domain/contracts/webdav_account_repository.dart';
import '../../webdav_client/domain/webdav_server_config.dart';
import 'local_album_picker_page.dart';
import 'webdav_directory_picker_page.dart';

enum PlaylistSourceCreationAction { localAlbum, webDavDirectory }

class WebDavDirectorySelection {
  final WebDavServerConfig account;
  final String path;

  const WebDavDirectorySelection({required this.account, required this.path});
}

Future<PlaylistSourceCreationAction?> showPlaylistCreationSheet(
  BuildContext context,
) {
  return showModalBottomSheet<PlaylistSourceCreationAction>(
    context: context,
    showDragHandle: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return _PlaylistSourceSheetContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('本地相册'),
              subtitle: const Text('将某个本地相册加入播放列表'),
              onTap: () => Navigator.of(
                context,
              ).pop(PlaylistSourceCreationAction.localAlbum),
            ),
            ListTile(
              leading: const Icon(Icons.folder_copy_outlined),
              title: const Text('WebDAV 目录'),
              subtitle: const Text('将某个 WebDAV 目录加入播放列表'),
              onTap: () => Navigator.of(
                context,
              ).pop(PlaylistSourceCreationAction.webDavDirectory),
            ),
          ],
        ),
      );
    },
  );
}

Future<LocalAlbum?> pickLocalAlbumPlaylist({
  required BuildContext context,
  required MediaLibraryRepository repository,
}) async {
  final granted = await ensureLocalLibraryPermission(repository);
  if (!context.mounted || !granted) {
    return null;
  }

  return pushRootPage<LocalAlbum>(
    context,
    (_) => LocalAlbumPickerPage(repository: repository),
  );
}

Future<WebDavDirectorySelection?> pickWebDavDirectoryPlaylist({
  required BuildContext context,
  required WebDavAccountRepository repository,
}) async {
  final accounts = await repository.loadAccounts();
  if (!context.mounted) {
    return null;
  }
  if (accounts.isEmpty) {
    PPToast.error('请先添加 WebDAV 账户。');
    return null;
  }

  final selectedAccount = await _showAccountSheet(context, accounts);
  if (!context.mounted || selectedAccount == null) {
    return null;
  }

  final directoryPath = await pushRootPage<String>(
    context,
    (_) => WebDavDirectoryPickerPage(account: selectedAccount),
  );
  if (!context.mounted || directoryPath == null) {
    return null;
  }

  return WebDavDirectorySelection(
    account: selectedAccount,
    path: directoryPath,
  );
}

Future<bool> ensureLocalLibraryPermission(
  MediaLibraryRepository repository,
) async {
  final hasPermission = await repository.hasVideoPermission();
  if (hasPermission) {
    return true;
  }

  final granted = await repository.requestVideoPermission();
  if (granted) {
    return true;
  }

  PPToast.error('未授予本地视频访问权限。');
  return false;
}

Future<WebDavServerConfig?> _showAccountSheet(
  BuildContext context,
  List<WebDavServerConfig> accounts,
) {
  return showModalBottomSheet<WebDavServerConfig>(
    context: context,
    showDragHandle: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return _PlaylistSourceSheetContainer(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: accounts.length,
          itemBuilder: (BuildContext context, int index) {
            final account = accounts[index];
            return ListTile(
              leading: const Icon(Icons.cloud_outlined),
              title: Text(account.alias),
              subtitle: Text(account.url.toString()),
              onTap: () => Navigator.of(context).pop(account),
            );
          },
        ),
      );
    },
  );
}

class _PlaylistSourceSheetContainer extends StatelessWidget {
  final Widget child;

  const _PlaylistSourceSheetContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Material(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
        clipBehavior: Clip.antiAlias,
        child: SafeArea(top: false, child: child),
      ),
    );
  }
}
