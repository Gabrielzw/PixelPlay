import 'package:flutter/material.dart';

import '../../../shared/utils/not_implemented.dart';
import '../../../shared/utils/media_formatters.dart';
import '../../../shared/widgets/skeleton/skeleton_box.dart';
import '../../../shared/widgets/skeleton/ui_skeleton_notice.dart';
import '../../player_core/presentation/player_page.dart';

const int kVideoSkeletonCount = 24;
const double kAlbumBodySpacing = 12;
const double kVideoThumbAspectRatio = 16 / 9;
const double kVideoThumbWidth = 140;
const double kVideoListSpacing = 8;
const double kVideoCardPadding = 12;
const double kVideoThumbTextPadding = 6;
const double kVideoInfoSpacing = 4;
const double kDurationBadgeOpacity = 0.72;
const double kDurationBadgeVerticalPadding = 2;
const EdgeInsets kVideoListPadding = EdgeInsets.all(16);
const int kVideoTitleMaxLines = 2;

const int kDemoVideoWidth = 1920;
const int kDemoVideoHeight = 1080;
const int kDemoBaseSizeBytes = 120 * 1024 * 1024;
const int kDemoSizeStepBytes = 5 * 1024 * 1024;
const int kDemoBaseDurationSeconds = 90;
const int kDemoDurationStepSeconds = 7;
const int kDemoModifiedMinutesStep = 37;

class AlbumPage extends StatelessWidget {
  final String albumTitle;

  const AlbumPage({super.key, required this.albumTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(albumTitle),
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
      body: const _AlbumBody(),
    );
  }
}

class _AlbumBody extends StatelessWidget {
  const _AlbumBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const UiSkeletonNotice(message: 'UI 骨架阶段：缩略图、筛选/排序、播放记录与收藏尚未接入。'),
        const SizedBox(height: kAlbumBodySpacing),
        const Expanded(child: _VideoList()),
      ],
    );
  }
}

class _VideoList extends StatelessWidget {
  const _VideoList();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Padding(
      padding: kVideoListPadding,
      child: ListView.separated(
        key: const PageStorageKey<String>('album_video_list'),
        itemCount: kVideoSkeletonCount,
        separatorBuilder: (context, index) =>
            const SizedBox(height: kVideoListSpacing),
        itemBuilder: (context, index) {
          final title = 'Video_${index + 1}.mp4';
          final duration = Duration(
            seconds:
                kDemoBaseDurationSeconds + (index * kDemoDurationStepSeconds),
          );
          final sizeBytes = kDemoBaseSizeBytes + (index * kDemoSizeStepBytes);
          final modifiedAt = now.subtract(
            Duration(minutes: index * kDemoModifiedMinutesStep),
          );

          return _VideoRowTile(
            key: ValueKey<String>(title),
            title: title,
            durationText: formatVideoDuration(duration),
            resolutionText: formatResolution(
              width: kDemoVideoWidth,
              height: kDemoVideoHeight,
            ),
            sizeText: formatFileSize(sizeBytes),
            modifiedTimeText: formatChineseDateTime(modifiedAt),
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute<void>(
                  builder: (_) => PlayerPage(title: title),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _VideoRowTile extends StatelessWidget {
  final String title;
  final String durationText;
  final String resolutionText;
  final String sizeText;
  final String modifiedTimeText;
  final VoidCallback onTap;

  const _VideoRowTile({
    super.key,
    required this.title,
    required this.durationText,
    required this.resolutionText,
    required this.sizeText,
    required this.modifiedTimeText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(kVideoCardPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _VideoThumbnail(durationText: durationText),
              const SizedBox(width: kVideoCardPadding),
              Expanded(
                child: _VideoInfo(
                  title: title,
                  resolutionText: resolutionText,
                  sizeText: sizeText,
                  modifiedTimeText: modifiedTimeText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VideoThumbnail extends StatelessWidget {
  final String durationText;

  const _VideoThumbnail({required this.durationText});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: kVideoThumbWidth,
      child: AspectRatio(
        aspectRatio: kVideoThumbAspectRatio,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(kSkeletonRadius)),
          child: Stack(
            children: <Widget>[
              const Positioned.fill(
                child: SkeletonBox(borderRadius: BorderRadius.zero),
              ),
              Positioned(
                right: kVideoThumbTextPadding,
                bottom: kVideoThumbTextPadding,
                child: _DurationBadge(text: durationText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DurationBadge extends StatelessWidget {
  final String text;

  const _DurationBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.labelSmall;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(kDurationBadgeOpacity),
        borderRadius: const BorderRadius.all(
          Radius.circular(kVideoThumbTextPadding),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kVideoThumbTextPadding,
          vertical: kDurationBadgeVerticalPadding,
        ),
        child: Text(text, style: labelStyle?.copyWith(color: Colors.white)),
      ),
    );
  }
}

class _VideoInfo extends StatelessWidget {
  final String title;
  final String resolutionText;
  final String sizeText;
  final String modifiedTimeText;

  const _VideoInfo({
    required this.title,
    required this.resolutionText,
    required this.sizeText,
    required this.modifiedTimeText,
  });

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).colorScheme.onSurfaceVariant;
    final secondaryStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: secondary,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, maxLines: kVideoTitleMaxLines, overflow: TextOverflow.ellipsis),
        const SizedBox(height: kVideoInfoSpacing),
        Text('$resolutionText · $sizeText', style: secondaryStyle),
        const SizedBox(height: kVideoInfoSpacing),
        Text(modifiedTimeText, style: secondaryStyle),
      ],
    );
  }
}
