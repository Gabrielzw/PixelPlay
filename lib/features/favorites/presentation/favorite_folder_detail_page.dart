import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../media_library/presentation/widgets/album_video_preview.dart';
import '../../webdav_client/domain/contracts/webdav_account_repository.dart';
import 'favorite_folder_player_launcher.dart';
import 'favorite_models.dart';
import 'widgets/favorite_folder_preview.dart';
import 'widgets/favorite_folder_video_tile.dart';

const EdgeInsets _kFavoriteFolderDetailPadding = EdgeInsets.fromLTRB(
  16,
  12,
  16,
  20,
);
const double _kFavoriteFolderDetailHeaderBottom = 20;
const double _kFavoriteFolderDetailHeaderGap = 16;
const double _kFavoriteFolderDetailVideoSpacing = 12;
const double _kFavoriteFolderDetailCountLineHeight = 1.2;
const double _kFavoriteFolderDetailEmptyIconSize = 40;

class FavoriteFolderDetailPage extends StatefulWidget {
  final FavoriteFolderEntry folder;
  final WebDavAccountRepository? webDavAccountRepository;

  const FavoriteFolderDetailPage({
    super.key,
    required this.folder,
    this.webDavAccountRepository,
  });

  @override
  State<FavoriteFolderDetailPage> createState() =>
      _FavoriteFolderDetailPageState();
}

class _FavoriteFolderDetailPageState extends State<FavoriteFolderDetailPage> {
  Set<String> _selectedVideoIds = <String>{};

  bool get _isSelectionMode => _selectedVideoIds.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: _isSelectionMode ? '取消选择' : '返回',
          onPressed: _handleLeadingPressed,
          icon: Icon(
            _isSelectionMode ? Icons.close : Icons.arrow_back_ios_new_rounded,
          ),
        ),
        title: _isSelectionMode
            ? Text('已选择 ${_selectedVideoIds.length} 项')
            : null,
        actions: _isSelectionMode
            ? const <Widget>[]
            : <Widget>[
                IconButton(
                  tooltip: '搜索',
                  onPressed: () {},
                  icon: const Icon(Icons.search_rounded),
                ),
                IconButton(
                  tooltip: '排序',
                  onPressed: () {},
                  icon: const Icon(Icons.sort_rounded),
                ),
                IconButton(
                  tooltip: '更多',
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert_rounded),
                ),
              ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (widget.folder.videos.isEmpty) {
      return ListView(
        key: PageStorageKey<String>(
          'favorite_folder_detail_${widget.folder.id}',
        ),
        padding: _kFavoriteFolderDetailPadding,
        children: <Widget>[
          _FavoriteFolderDetailHeader(folder: widget.folder),
          const SizedBox(height: _kFavoriteFolderDetailHeaderBottom),
          const FavoriteFolderDetailEmptyView(),
        ],
      );
    }

    return ListView.separated(
      key: PageStorageKey<String>('favorite_folder_detail_${widget.folder.id}'),
      padding: _kFavoriteFolderDetailPadding,
      itemCount: widget.folder.videos.length + 1,
      separatorBuilder: (_, int index) {
        if (index == 0) {
          return const SizedBox(height: _kFavoriteFolderDetailHeaderBottom);
        }
        return const SizedBox(height: _kFavoriteFolderDetailVideoSpacing);
      },
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return _FavoriteFolderDetailHeader(folder: widget.folder);
        }

        final video = widget.folder.videos[index - 1];
        return FavoriteFolderVideoTile(
          key: ValueKey<String>('favorite_folder_video_${video.id}'),
          video: video,
          selected: _selectedVideoIds.contains(video.id),
          onTap: () {
            unawaited(_handleVideoTap(video));
          },
          onLongPress: () => _handleVideoLongPress(video.id),
        );
      },
    );
  }

  void _handleLeadingPressed() {
    if (_isSelectionMode) {
      setState(() {
        _selectedVideoIds = <String>{};
      });
      return;
    }

    Navigator.of(context).maybePop();
  }

  Future<void> _handleVideoTap(FavoriteVideoEntry video) async {
    if (_isSelectionMode) {
      _toggleSelection(video.id);
      return;
    }

    await openFavoriteFolderVideo(
      context: context,
      folder: widget.folder,
      video: video,
      webDavAccountRepository:
          widget.webDavAccountRepository ?? Get.find<WebDavAccountRepository>(),
    );
  }

  void _handleVideoLongPress(String videoId) {
    _toggleSelection(videoId);
  }

  void _toggleSelection(String videoId) {
    final nextSelectedVideoIds = Set<String>.of(_selectedVideoIds);
    final isAdded = nextSelectedVideoIds.add(videoId);
    if (!isAdded) {
      nextSelectedVideoIds.remove(videoId);
    }

    setState(() {
      _selectedVideoIds = nextSelectedVideoIds;
    });
  }
}

class _FavoriteFolderDetailHeader extends StatelessWidget {
  final FavoriteFolderEntry folder;

  const _FavoriteFolderDetailHeader({required this.folder});

  @override
  Widget build(BuildContext context) {
    final latestVideo = folder.latestVideo;
    final secondaryColor = Theme.of(context).colorScheme.onSurfaceVariant;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FavoriteFolderPreview(
          previewSeed: latestVideo?.previewSeed ?? 1,
          thumbnailRequest: latestVideo?.thumbnailRequest,
          heroTag: buildFavoriteFolderPreviewHeroTag(folder.id),
        ),
        const SizedBox(width: _kFavoriteFolderDetailHeaderGap),
        Expanded(
          child: SizedBox(
            height: kVideoTilePreviewWidth / kVideoTilePreviewAspectRatio,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  folder.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${folder.videoCount} 个视频',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: secondaryColor,
                    height: _kFavoriteFolderDetailCountLineHeight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class FavoriteFolderDetailEmptyView extends StatelessWidget {
  const FavoriteFolderDetailEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.video_library_outlined,
              size: _kFavoriteFolderDetailEmptyIconSize,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              '当前收藏夹还没有视频',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
