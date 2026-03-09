import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/router/page_navigation.dart';
import '../../../shared/widgets/pp_toast.dart';
import '../../media_library/domain/contracts/media_library_repository.dart';
import '../../media_library/domain/entities/local_album.dart';
import '../../media_library/presentation/album_page.dart';
import '../../webdav_client/domain/contracts/webdav_account_repository.dart';
import '../../webdav_client/domain/webdav_server_config.dart';
import '../../webdav_client/presentation/webdav_browser_page.dart';
import 'controllers/playlist_sources_controller.dart';
import 'playlist_source_models.dart';
import 'playlist_source_selection_flow.dart';
import 'widgets/playlist_source_card.dart';
import 'widgets/playlist_sources_header.dart';

class PlaylistSourcesTabView extends StatefulWidget {
  final List<PlaylistSourceEntry>? initialEntries;
  final PlaylistSourcesController? playlistSourcesController;

  const PlaylistSourcesTabView({
    super.key,
    this.initialEntries,
    this.playlistSourcesController,
  });

  @override
  State<PlaylistSourcesTabView> createState() => _PlaylistSourcesTabViewState();
}

class _PlaylistSourcesTabViewState extends State<PlaylistSourcesTabView>
    with AutomaticKeepAliveClientMixin {
  List<PlaylistSourceEntry> _localEntries = const <PlaylistSourceEntry>[];
  PlaylistSourcesController? _playlistSourcesController;
  Set<String> _selectedEntryIds = <String>{};

  bool get _usesSharedEntries => widget.initialEntries == null;
  bool get _isSelectionMode => _selectedEntryIds.isNotEmpty;

  List<PlaylistSourceEntry> get _entries {
    if (_usesSharedEntries) {
      return _playlistSourcesController!.entries.toList(growable: false);
    }
    return _localEntries;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (_usesSharedEntries) {
      _playlistSourcesController =
          widget.playlistSourcesController ??
          Get.find<PlaylistSourcesController>();
      return;
    }
    _localEntries = sortPlaylistSources(widget.initialEntries!);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_usesSharedEntries) {
      return Obx(_buildContent);
    }
    return _buildContent();
  }

  Widget _buildContent() {
    return Column(
      children: <Widget>[
        PlaylistSourcesHeader(
          isSelectionMode: _isSelectionMode,
          selectedCount: _selectedEntryIds.length,
          onAddPressed: _openAddPlaylistSheet,
          onDeletePressed: _deleteSelectedEntries,
          onExitSelectionMode: _clearSelection,
        ),
        Expanded(child: _buildList()),
      ],
    );
  }

  Widget _buildList() {
    if (_entries.isEmpty) {
      return const PlaylistEmptyView();
    }

    return ListView.separated(
      key: const PageStorageKey<String>('playlist_sources_list'),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: _entries.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (BuildContext context, int index) {
        final entry = _entries[index];
        return PlaylistSourceCard(
          entry: entry,
          isSelected: _selectedEntryIds.contains(entry.id),
          isSelectionMode: _isSelectionMode,
          onTap: () => _handleEntryTap(entry),
          onLongPress: () => _toggleSelection(entry.id),
        );
      },
    );
  }

  Future<void> _openAddPlaylistSheet() async {
    final action = await showPlaylistCreationSheet(context);
    if (!mounted || action == null) {
      return;
    }

    switch (action) {
      case PlaylistSourceCreationAction.localAlbum:
        await _addLocalAlbumPlaylist();
        return;
      case PlaylistSourceCreationAction.webDavDirectory:
        await _addWebDavDirectoryPlaylist();
        return;
    }
  }

  Future<void> _addLocalAlbumPlaylist() async {
    final repository = Get.find<MediaLibraryRepository>();
    final album = await pickLocalAlbumPlaylist(
      context: context,
      repository: repository,
    );
    if (!mounted || album == null) {
      return;
    }

    try {
      _saveLocalAlbumEntry(album);
      PPToast.success('已添加到播放列表');
    } catch (error) {
      PPToast.error(error.toString());
    }
  }

  Future<void> _addWebDavDirectoryPlaylist() async {
    final accountRepository = Get.find<WebDavAccountRepository>();
    final selection = await pickWebDavDirectoryPlaylist(
      context: context,
      repository: accountRepository,
    );
    if (!mounted || selection == null) {
      return;
    }

    try {
      _saveWebDavDirectoryEntry(selection.account, selection.path);
      PPToast.success('已添加到播放列表');
    } catch (error) {
      PPToast.error(error.toString());
    }
  }

  void _saveLocalAlbumEntry(LocalAlbum album) {
    if (_usesSharedEntries) {
      _playlistSourcesController!.createLocalAlbumEntry(album: album);
      return;
    }

    final entry = PlaylistSourceEntry.localAlbum(
      album: album,
      createdAt: DateTime.now(),
    );
    _assertEntryIsUnique(entry);
    setState(() {
      _localEntries = sortPlaylistSources(<PlaylistSourceEntry>[
        ..._entries,
        entry,
      ]);
    });
  }

  void _saveWebDavDirectoryEntry(WebDavServerConfig account, String path) {
    if (_usesSharedEntries) {
      _playlistSourcesController!.createWebDavDirectoryEntry(
        account: account,
        path: path,
      );
      return;
    }

    final entry = PlaylistSourceEntry.webDavDirectory(
      account: account,
      path: path,
      createdAt: DateTime.now(),
    );
    _assertEntryIsUnique(entry);
    setState(() {
      _localEntries = sortPlaylistSources(<PlaylistSourceEntry>[
        ..._entries,
        entry,
      ]);
    });
  }

  void _assertEntryIsUnique(PlaylistSourceEntry nextEntry) {
    final duplicatedEntry = _entries.firstWhereOrNull(
      (PlaylistSourceEntry entry) =>
          playlistSourcesReferToSameTarget(entry, nextEntry),
    );
    if (duplicatedEntry != null) {
      throw StateError('该播放列表已存在，无需重复添加。');
    }
  }

  Future<void> _handleEntryTap(PlaylistSourceEntry entry) async {
    if (_isSelectionMode) {
      _toggleSelection(entry.id);
      return;
    }

    try {
      switch (entry.sourceKind) {
        case PlaylistSourceKind.localAlbum:
          await _openLocalAlbum(entry);
          return;
        case PlaylistSourceKind.webDavDirectory:
          await _openWebDavDirectory(entry);
          return;
      }
    } catch (error) {
      PPToast.error(error.toString());
    }
  }

  Future<void> _openLocalAlbum(PlaylistSourceEntry entry) async {
    final repository = Get.find<MediaLibraryRepository>();
    final granted = await ensureLocalLibraryPermission(repository);
    if (!mounted || !granted) {
      return;
    }

    await pushRootPage<void>(
      context,
      (_) => AlbumPage(album: entry.toLocalAlbum(), repository: repository),
    );
  }

  Future<void> _openWebDavDirectory(PlaylistSourceEntry entry) async {
    final accountId = entry.webDavAccountId;
    if (accountId == null) {
      throw StateError('播放列表中的 WebDAV 目录信息不完整。');
    }

    final repository = Get.find<WebDavAccountRepository>();
    final accounts = await repository.loadAccounts();
    if (!mounted) {
      return;
    }
    final account = accounts.firstWhereOrNull(
      (WebDavServerConfig item) => item.id == accountId,
    );
    if (account == null) {
      throw StateError('未找到对应的 WebDAV 账户，请重新添加该播放列表。');
    }

    await pushRootPage<void>(
      context,
      (_) =>
          WebDavBrowserPage(account: account, path: entry.webDavDirectoryPath),
    );
  }

  void _toggleSelection(String entryId) {
    final nextSelectedEntryIds = Set<String>.of(_selectedEntryIds);
    final isAdded = nextSelectedEntryIds.add(entryId);
    if (!isAdded) {
      nextSelectedEntryIds.remove(entryId);
    }
    setState(() {
      _selectedEntryIds = nextSelectedEntryIds;
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedEntryIds = <String>{};
    });
  }

  void _deleteSelectedEntries() {
    if (_selectedEntryIds.isEmpty) {
      return;
    }

    final selectedEntryIds = Set<String>.of(_selectedEntryIds);
    if (_usesSharedEntries) {
      _playlistSourcesController!.deleteEntries(selectedEntryIds);
      _clearSelection();
      return;
    }

    setState(() {
      _localEntries = _entries
          .where(
            (PlaylistSourceEntry entry) => !selectedEntryIds.contains(entry.id),
          )
          .toList(growable: false);
      _selectedEntryIds = <String>{};
    });
  }
}
