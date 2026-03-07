import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/utils/media_formatters.dart';
import '../../domain/player_controller.dart';
import 'player_slide_panel.dart';
import 'player_ui_constants.dart';

class PlayerEpisodePanel extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return PlayerSlidePanel(
      visible: visible,
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
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 12, 12),
              child: Row(
                children: <Widget>[
                  Text(
                    '播放列表',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(${controller.queue.length})',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.white60),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: onClose,
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Colors.white12),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: controller.queue.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = controller.queue[index];

                  return Obx(() {
                    final isSelected = controller.currentIndex.value == index;

                    return InkWell(
                      onTap: () async {
                        onClose();
                        if (isSelected) {
                          return;
                        }
                        await controller.switchToIndex(index);
                      },
                      child: Container(
                        color: isSelected
                            ? applyOpacity(Colors.white, 0.08)
                            : Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 28,
                              child: isSelected
                                  ? const Icon(
                                      Icons.play_arrow_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    )
                                  : Text(
                                      '${index + 1}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white54,
                                      ),
                                    ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                item.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.white70,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              formatVideoDuration(item.duration),
                              style: const TextStyle(color: Colors.white54),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
          ],
        ),
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
