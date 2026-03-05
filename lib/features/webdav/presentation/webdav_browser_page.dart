import 'package:flutter/material.dart';

import '../../../shared/utils/not_implemented.dart';
import '../../../shared/widgets/skeleton/ui_skeleton_notice.dart';
import '../../player/presentation/player_page.dart';
import '../domain/webdav_account.dart';

enum WebDavEntryType { directory, video, other }

@immutable
class WebDavEntry {
  final String name;
  final WebDavEntryType type;

  const WebDavEntry({required this.name, required this.type});
}

const List<WebDavEntry> kDemoRootEntries = <WebDavEntry>[
  WebDavEntry(name: 'Movies', type: WebDavEntryType.directory),
  WebDavEntry(name: 'Anime', type: WebDavEntryType.directory),
  WebDavEntry(name: 'A.mp4', type: WebDavEntryType.video),
  WebDavEntry(name: 'B.mp4', type: WebDavEntryType.video),
  WebDavEntry(name: 'C.txt', type: WebDavEntryType.other),
];

class WebDavBrowserPage extends StatelessWidget {
  final WebDavAccount account;
  final List<String> pathSegments;

  const WebDavBrowserPage({
    super.key,
    required this.account,
    this.pathSegments = const <String>[],
  });

  String get _pathLabel {
    if (pathSegments.isEmpty) return '/';
    return '/${pathSegments.join('/')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(account.name),
        actions: <Widget>[
          IconButton(
            tooltip: '搜索',
            onPressed: () => showNotImplementedSnackBar(context, '搜索（未接入）'),
            icon: const Icon(Icons.search),
          ),
          IconButton(
            tooltip: '排序',
            onPressed: () => showNotImplementedSnackBar(context, '排序（未接入）'),
            icon: const Icon(Icons.sort),
          ),
        ],
      ),
      body: _WebDavBrowserBody(
        account: account,
        pathLabel: _pathLabel,
        entries: kDemoRootEntries,
        onOpenDirectory: (name) {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => WebDavBrowserPage(
                account: account,
                pathSegments: <String>[...pathSegments, name],
              ),
            ),
          );
        },
        onOpenVideo: (name) {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute<void>(builder: (_) => PlayerPage(title: name)),
          );
        },
      ),
    );
  }
}

class _WebDavBrowserBody extends StatelessWidget {
  final WebDavAccount account;
  final String pathLabel;
  final List<WebDavEntry> entries;
  final ValueChanged<String> onOpenDirectory;
  final ValueChanged<String> onOpenVideo;

  const _WebDavBrowserBody({
    required this.account,
    required this.pathLabel,
    required this.entries,
    required this.onOpenDirectory,
    required this.onOpenVideo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const UiSkeletonNotice(
          message: 'UI 骨架阶段：真实 WebDAV 请求、面包屑联动与媒体过滤/播放列表尚未接入。',
        ),
        const SizedBox(height: 12),
        _PathBar(server: account.server.toString(), pathLabel: pathLabel),
        const Divider(height: 1),
        Expanded(
          child: ListView.builder(
            key: PageStorageKey<String>('webdav_list_$pathLabel'),
            padding: const EdgeInsets.all(8),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return _EntryTile(
                entry: entry,
                onOpenDirectory: onOpenDirectory,
                onOpenVideo: onOpenVideo,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PathBar extends StatelessWidget {
  final String server;
  final String pathLabel;

  const _PathBar({required this.server, required this.pathLabel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            server,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
          Row(
            children: <Widget>[
              const Icon(Icons.folder_open, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  pathLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EntryTile extends StatelessWidget {
  final WebDavEntry entry;
  final ValueChanged<String> onOpenDirectory;
  final ValueChanged<String> onOpenVideo;

  const _EntryTile({
    required this.entry,
    required this.onOpenDirectory,
    required this.onOpenVideo,
  });

  @override
  Widget build(BuildContext context) {
    final icon = switch (entry.type) {
      WebDavEntryType.directory => Icons.folder_outlined,
      WebDavEntryType.video => Icons.movie_outlined,
      WebDavEntryType.other => Icons.insert_drive_file_outlined,
    };

    return ListTile(
      leading: Icon(icon),
      title: Text(entry.name),
      subtitle: Text(switch (entry.type) {
        WebDavEntryType.directory => '目录',
        WebDavEntryType.video => '视频文件',
        WebDavEntryType.other => '非视频文件',
      }),
      onTap: () {
        switch (entry.type) {
          case WebDavEntryType.directory:
            onOpenDirectory(entry.name);
            break;
          case WebDavEntryType.video:
            onOpenVideo(entry.name);
            break;
          case WebDavEntryType.other:
            showNotImplementedSnackBar(context, '已过滤非视频文件（未接入）');
            break;
        }
      },
    );
  }
}
