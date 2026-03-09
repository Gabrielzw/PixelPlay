import 'package:flutter/material.dart';

import '../controllers/webdav_browser_controller.dart';

class WebDavSortButton extends StatelessWidget {
  final WebDavSortOption selectedSortOption;
  final ValueChanged<WebDavSortOption> onSelected;

  const WebDavSortButton({
    super.key,
    required this.selectedSortOption,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<WebDavSortOption>(
      tooltip: '排序',
      initialValue: selectedSortOption,
      onSelected: onSelected,
      icon: const Icon(Icons.sort_rounded),
      itemBuilder: (BuildContext context) {
        return WebDavSortOption.values
            .map(
              (WebDavSortOption sortOption) =>
                  CheckedPopupMenuItem<WebDavSortOption>(
                    value: sortOption,
                    checked: sortOption == selectedSortOption,
                    child: Text(sortOption.label),
                  ),
            )
            .toList(growable: false);
      },
    );
  }
}
