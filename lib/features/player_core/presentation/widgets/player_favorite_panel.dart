import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../favorites/presentation/controllers/favorites_controller.dart';
import '../../../favorites/presentation/favorite_models.dart';
import '../../../../shared/widgets/pp_toast.dart';
import '../../domain/player_queue_item.dart';
import 'player_slide_panel.dart';
import 'player_ui_constants.dart';

const double _kFavoritePanelOpacity = 0.94;
const double _kFavoritePanelLandscapeWidth = 380;
const double _kFavoritePanelPortraitHeightFactor = 0.68;
const double _kFavoritePanelBlurRadius = 18;
const double _kFavoritePanelHorizontalPadding = 16;
const double _kFavoritePanelVerticalSpacing = 12;
const double _kFavoritePanelItemRadius = 16;

class PlayerFavoritePanel extends StatefulWidget {
  final FavoritesController favoritesController;
  final PlayerQueueItem item;
  final bool visible;
  final VoidCallback onClose;
  final Future<FavoriteFolderEntry?> Function() onCreateFolder;

  const PlayerFavoritePanel({
    super.key,
    required this.favoritesController,
    required this.item,
    required this.visible,
    required this.onClose,
    required this.onCreateFolder,
  });

  @override
  State<PlayerFavoritePanel> createState() => _PlayerFavoritePanelState();
}

class _PlayerFavoritePanelState extends State<PlayerFavoritePanel> {
  Set<String> _selectedFolderIds = <String>{};
  Timer? _hideContentTimer;
  late bool _showsPanelContent;

  @override
  void initState() {
    super.initState();
    _showsPanelContent = widget.visible;
  }

  @override
  void didUpdateWidget(covariant PlayerFavoritePanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.visible && widget.visible) {
      _hideContentTimer?.cancel();
      setState(() {
        _selectedFolderIds = <String>{};
        _showsPanelContent = true;
      });
    }
    if (oldWidget.visible && !widget.visible) {
      _scheduleHidePanelContent();
    }
  }

  @override
  void dispose() {
    _hideContentTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlayerSlidePanel(
      visible: widget.visible,
      landscapeWidth: _kFavoritePanelLandscapeWidth,
      portraitHeightFactor: _kFavoritePanelPortraitHeightFactor,
      child: Offstage(
        offstage: !_showsPanelContent,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: applyOpacity(Colors.black, _kFavoritePanelOpacity),
            borderRadius: _resolveRadius(context),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Colors.black45,
                blurRadius: _kFavoritePanelBlurRadius,
              ),
            ],
          ),
          child: Column(
            children: <Widget>[
              _Header(onClose: widget.onClose),
              const Divider(height: 1, color: Colors.white12),
              Expanded(
                child: Obx(
                  () => _FolderList(
                    folders: widget.favoritesController.folders.toList(
                      growable: false,
                    ),
                    selectedFolderIds: _selectedFolderIds,
                    onToggle: _toggleFolder,
                  ),
                ),
              ),
              const Divider(height: 1, color: Colors.white12),
              Padding(
                padding: const EdgeInsets.all(_kFavoritePanelHorizontalPadding),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _handleCreateFolder,
                        child: const Text('新建收藏夹'),
                      ),
                    ),
                    const SizedBox(width: _kFavoritePanelVerticalSpacing),
                    Expanded(
                      child: FilledButton(
                        onPressed: _selectedFolderIds.isEmpty
                            ? null
                            : _confirmSelection,
                        child: const Text('确认'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _scheduleHidePanelContent() {
    _hideContentTimer?.cancel();
    _hideContentTimer = Timer(kPlayerOverlayAnimationDuration, () {
      if (!mounted || widget.visible) {
        return;
      }
      setState(() {
        _showsPanelContent = false;
      });
    });
  }

  BorderRadius _resolveRadius(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return isLandscape
        ? const BorderRadius.horizontal(left: Radius.circular(18))
        : const BorderRadius.vertical(top: Radius.circular(18));
  }

  void _toggleFolder(String folderId) {
    final nextSelectedFolderIds = Set<String>.of(_selectedFolderIds);
    final isAdded = nextSelectedFolderIds.add(folderId);
    if (!isAdded) {
      nextSelectedFolderIds.remove(folderId);
    }

    setState(() {
      _selectedFolderIds = nextSelectedFolderIds;
    });
  }

  Future<void> _handleCreateFolder() async {
    final createdFolder = await widget.onCreateFolder();
    if (!mounted || createdFolder == null) {
      return;
    }

    setState(() {
      _selectedFolderIds = <String>{..._selectedFolderIds, createdFolder.id};
    });
  }

  Future<void> _confirmSelection() async {
    if (_selectedFolderIds.isEmpty) {
      await PPToast.warning('请先选择至少一个收藏夹');
      return;
    }

    widget.favoritesController.addQueueItemToFolders(
      item: widget.item,
      folderIds: _selectedFolderIds,
    );
    widget.onClose();
    unawaited(PPToast.success('已加入选中的收藏夹'));
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onClose;

  const _Header({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 12),
      child: Row(
        children: <Widget>[
          Text(
            '加入收藏',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close_rounded, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _FolderList extends StatelessWidget {
  final List<FavoriteFolderEntry> folders;
  final Set<String> selectedFolderIds;
  final ValueChanged<String> onToggle;

  const _FolderList({
    required this.folders,
    required this.selectedFolderIds,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(_kFavoritePanelHorizontalPadding),
      itemCount: folders.length,
      separatorBuilder: (_, _) =>
          const SizedBox(height: _kFavoritePanelVerticalSpacing),
      itemBuilder: (BuildContext context, int index) {
        final folder = folders[index];
        final isSelected = selectedFolderIds.contains(folder.id);
        return Material(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.18)
              : Colors.white10,
          borderRadius: const BorderRadius.all(
            Radius.circular(_kFavoritePanelItemRadius),
          ),
          child: InkWell(
            borderRadius: const BorderRadius.all(
              Radius.circular(_kFavoritePanelItemRadius),
            ),
            onTap: () => onToggle(folder.id),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          folder.title,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${folder.videoCount} 个视频',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  Checkbox(
                    value: isSelected,
                    onChanged: (_) => onToggle(folder.id),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
