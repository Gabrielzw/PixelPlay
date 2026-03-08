import 'package:flutter/material.dart';

import '../../thumbnail_engine/domain/video_thumbnail_request.dart';
import '../domain/entities/local_album.dart';
import 'local_library_sort_type.dart';
import 'widgets/library_album_card.dart';

const int kFnvOffsetBasis = 2166136261;
const int kFnvPrime = 16777619;
const int kFnvHashMask = 0xFFFFFFFF;

@immutable
class _AlbumPalette {
  final Color start;
  final Color end;

  const _AlbumPalette({required this.start, required this.end});
}

const List<_AlbumPalette> _kAlbumPalettes = <_AlbumPalette>[
  _AlbumPalette(start: Color(0xFFD6C8D0), end: Color(0xFFA3939B)),
  _AlbumPalette(start: Color(0xFFD9DAD5), end: Color(0xFFA5B0A8)),
  _AlbumPalette(start: Color(0xFFCDBDAF), end: Color(0xFF9C8A7A)),
  _AlbumPalette(start: Color(0xFFD8C6C4), end: Color(0xFFA78682)),
  _AlbumPalette(start: Color(0xFFB8BBC2), end: Color(0xFF747986)),
  _AlbumPalette(start: Color(0xFF8E84D8), end: Color(0xFF4C4086)),
  _AlbumPalette(start: Color(0xFFD8C1B0), end: Color(0xFF9E7767)),
  _AlbumPalette(start: Color(0xFFE0C3CB), end: Color(0xFFB98997)),
];

LibraryAlbumPreview buildLibraryAlbumPreview(LocalAlbum album) {
  final palette = _resolveAlbumPalette(album.bucketId);
  return LibraryAlbumPreview(
    title: resolveLocalLibraryAlbumTitle(album.bucketName),
    subtitle: '${album.videoCount} 个视频',
    startColor: palette.start,
    endColor: palette.end,
    thumbnailRequest: VideoThumbnailRequest.album(
      videoId: album.latestVideoId,
      videoPath: album.latestVideoPath,
      dateModified: album.latestVideoDateModified,
    ),
  );
}

_AlbumPalette _resolveAlbumPalette(String bucketId) {
  final hash = _fnv1aHash(bucketId);
  final index = hash % _kAlbumPalettes.length;
  return _kAlbumPalettes[index];
}

int _fnv1aHash(String value) {
  var hash = kFnvOffsetBasis;
  for (final unit in value.codeUnits) {
    hash ^= unit;
    hash = (hash * kFnvPrime) & kFnvHashMask;
  }
  return hash;
}
