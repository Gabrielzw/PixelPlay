import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/utils/media_formatters.dart';
import '../../domain/player_controller.dart';
import 'player_slide_panel.dart';
import 'player_ui_constants.dart';

const double _kEpisodeListVerticalPadding = 8;
const double _kEpisodeItemHeight = 56;
const double _kEpisodeItemHorizontalMargin = 8;
const double _kEpisodeSelectedBackgroundOpacity = 0.18;
const double _kEpisodeSelectedBorderRadius = 12;
const Duration _kEpisodeScrollDuration = Duration(milliseconds: 220);

class PlayerEpisodePanel extends StatefulWidget {
  final PlayerController controller;
  final bool visible;
  final VoidCallback onClose;

  const PlayerEpisodePanel({
    super.key,
    required this.controller,
    required this.visible,
    required this.onClose,
  });

  @override
  State<PlayerEpisodePanel> createState() => _PlayerEpisodePanelState();
}

class _PlayerEpisodePanelState extends State<PlayerEpisodePanel> {
  final ScrollController _scrollController = ScrollController();
  late Worker _currentIndexWorker;

  @override
  void initState() {
    super.initState();
    _bindCurrentIndexWorker();
    if (widget.visible) {
      _scheduleScrollToCurrentItem(animated: false);
    }
  }

  @override
  void didUpdateWidget(covariant PlayerEpisodePanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _currentIndexWorker.dispose();
      _bindCurrentIndexWorker();
    }
    final needsRelocate =
        (!oldWidget.visible && widget.visible) ||
        oldWidget.controller != widget.controller;
    if (needsRelocate) {
      _scheduleScrollToCurrentItem(animated: false);
    }
  }

  @override
  void dispose() {
    _currentIndexWorker.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlayerSlidePanel(
      visible: widget.visible,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: applyOpacity(Colors.black, 0.92),
          borderRadius: _resolveRadius(context),
          boxShadow: const <BoxShadow>[
            BoxShadow(color: Colors.black45, blurRadius: 18),
          ],
        ),
        child: Column(
          children: <Widget>[
            _buildHeader(context),
            const Divider(height: 1, color: Colors.white12),
            Expanded(child: _buildEpisodeList(context)),
          ],
        ),
      ),
    );
  }

  void _bindCurrentIndexWorker() {
    _currentIndexWorker = ever<int>(widget.controller.currentIndex, (int _) {
      if (!widget.visible) {
        return;
      }
      _scheduleScrollToCurrentItem(animated: true);
    });
  }

  void _scheduleScrollToCurrentItem({required bool animated}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _scrollToCurrentItem(animated: animated);
    });
  }

  void _scrollToCurrentItem({required bool animated}) {
    if (!_scrollController.hasClients) {
      return;
    }
    final position = _scrollController.position;
    final desiredOffset =
        _kEpisodeListVerticalPadding +
        widget.controller.currentIndex.value * _kEpisodeItemHeight -
        (position.viewportDimension - _kEpisodeItemHeight) / 2;
    final targetOffset = desiredOffset
        .clamp(position.minScrollExtent, position.maxScrollExtent)
        .toDouble();
    if ((position.pixels - targetOffset).abs() < 1) {
      return;
    }
    if (animated) {
      _scrollController.animateTo(
        targetOffset,
        duration: _kEpisodeScrollDuration,
        curve: Curves.easeOutCubic,
      );
      return;
    }
    _scrollController.jumpTo(targetOffset);
  }

  Widget _buildHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 12),
      child: Row(
        children: <Widget>[
          Text(
            '播放列表',
            style: textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '(${widget.controller.queue.length})',
            style: textTheme.bodySmall?.copyWith(color: Colors.white60),
          ),
          const Spacer(),
          IconButton(
            onPressed: widget.onClose,
            icon: const Icon(Icons.close_rounded, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildEpisodeList(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(
        vertical: _kEpisodeListVerticalPadding,
      ),
      itemCount: widget.controller.queue.length,
      itemExtent: _kEpisodeItemHeight,
      itemBuilder: (BuildContext context, int index) {
        return _buildEpisodeItem(context, index);
      },
    );
  }

  Widget _buildEpisodeItem(BuildContext context, int index) {
    final item = widget.controller.queue[index];
    final colorScheme = Theme.of(context).colorScheme;
    return Obx(() {
      final isSelected = widget.controller.currentIndex.value == index;
      final selectedColor = colorScheme.primary;
      return InkWell(
        onTap: () async {
          widget.onClose();
          if (isSelected) {
            return;
          }
          await widget.controller.switchToIndex(index);
        },
        borderRadius: const BorderRadius.all(
          Radius.circular(_kEpisodeSelectedBorderRadius),
        ),
        child: AnimatedContainer(
          duration: _kEpisodeScrollDuration,
          margin: const EdgeInsets.symmetric(
            horizontal: _kEpisodeItemHorizontalMargin,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? applyOpacity(
                    selectedColor,
                    _kEpisodeSelectedBackgroundOpacity,
                  )
                : Colors.transparent,
            borderRadius: const BorderRadius.all(
              Radius.circular(_kEpisodeSelectedBorderRadius),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: <Widget>[
              _buildLeading(
                index: index,
                isSelected: isSelected,
                selectedColor: selectedColor,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isSelected ? selectedColor : Colors.white70,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                formatVideoDuration(item.duration),
                style: TextStyle(
                  color: isSelected ? selectedColor : Colors.white54,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildLeading({
    required int index,
    required bool isSelected,
    required Color selectedColor,
  }) {
    return SizedBox(
      width: 28,
      child: isSelected
          ? Icon(Icons.play_arrow_rounded, color: selectedColor, size: 18)
          : Text(
              '${index + 1}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white54),
            ),
    );
  }

  BorderRadius _resolveRadius(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return isLandscape
        ? const BorderRadius.horizontal(left: Radius.circular(18))
        : const BorderRadius.vertical(top: Radius.circular(18));
  }
}
