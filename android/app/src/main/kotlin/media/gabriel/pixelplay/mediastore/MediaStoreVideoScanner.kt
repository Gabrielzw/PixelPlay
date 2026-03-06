package media.gabriel.pixelplay.mediastore

import android.content.ContentResolver
import android.content.ContentUris
import android.database.Cursor
import android.net.Uri
import android.provider.MediaStore
import media.gabriel.pixelplay.pigeon.NativeAlbumRecord
import media.gabriel.pixelplay.pigeon.NativeVideoRecord

private const val kUnknownVideoName = "未命名视频"

internal class MediaStoreVideoScanner(
  private val contentResolver: ContentResolver,
) {
  fun scanAlbums(): List<NativeAlbumRecord> {
    val cursor = queryAlbumAggregationCursor() ?: return emptyList()
    val albumsByBucketId = cursor.use(::buildAlbumMap)
    return mapToNativeAlbumRecords(albumsByBucketId)
  }

  fun scanAlbumVideos(bucketId: String): List<NativeVideoRecord> {
    val cursor = queryAlbumVideoCursor(bucketId) ?: return emptyList()
    return cursor.use(::buildVideoRecords)
  }

  private fun queryAlbumAggregationCursor(): Cursor? {
    val projection =
      arrayOf(
        MediaStore.Video.Media._ID,
        MediaStore.Video.Media.BUCKET_ID,
        MediaStore.Video.Media.BUCKET_DISPLAY_NAME,
        MediaStore.Video.Media.DATE_ADDED,
        MediaStore.Video.Media.DATE_MODIFIED,
      )
    return contentResolver.query(
      MediaStore.Video.Media.EXTERNAL_CONTENT_URI,
      projection,
      null,
      null,
      "${MediaStore.Video.Media.DATE_ADDED} DESC, ${MediaStore.Video.Media._ID} DESC",
    )
  }

  private fun queryAlbumVideoCursor(bucketId: String): Cursor? {
    val projection =
      arrayOf(
        MediaStore.Video.Media._ID,
        MediaStore.Video.Media.DISPLAY_NAME,
        MediaStore.Video.Media.BUCKET_ID,
        MediaStore.Video.Media.BUCKET_DISPLAY_NAME,
        MediaStore.Video.Media.DURATION,
        MediaStore.Video.Media.SIZE,
        MediaStore.Video.Media.DATE_ADDED,
        MediaStore.Video.Media.DATE_MODIFIED,
        MediaStore.Video.Media.WIDTH,
        MediaStore.Video.Media.HEIGHT,
      )
    return contentResolver.query(
      MediaStore.Video.Media.EXTERNAL_CONTENT_URI,
      projection,
      "${MediaStore.Video.Media.BUCKET_ID} = ?",
      arrayOf(bucketId),
      "${MediaStore.Video.Media.DATE_ADDED} DESC, ${MediaStore.Video.Media._ID} DESC",
    )
  }

  private fun buildAlbumMap(cursor: Cursor): LinkedHashMap<String, AlbumAccumulator> {
    val albumsByBucketId = LinkedHashMap<String, AlbumAccumulator>()
    val videoIdIndex = cursor.getColumnIndexOrThrow(MediaStore.Video.Media._ID)
    val bucketIdIndex = cursor.getColumnIndexOrThrow(MediaStore.Video.Media.BUCKET_ID)
    val bucketNameIndex =
      cursor.getColumnIndexOrThrow(MediaStore.Video.Media.BUCKET_DISPLAY_NAME)
    val dateAddedIndex = cursor.getColumnIndexOrThrow(MediaStore.Video.Media.DATE_ADDED)
    val dateModifiedIndex =
      cursor.getColumnIndexOrThrow(MediaStore.Video.Media.DATE_MODIFIED)

    while (cursor.moveToNext()) {
      val bucketId = cursor.getString(bucketIdIndex) ?: continue
      mergeAlbum(
        albumsByBucketId = albumsByBucketId,
        videoId = cursor.getLong(videoIdIndex),
        bucketId = bucketId,
        bucketName = cursor.getString(bucketNameIndex) ?: "",
        dateAddedSeconds = cursor.getLong(dateAddedIndex),
        dateModifiedSeconds = cursor.getLong(dateModifiedIndex),
      )
    }

    return albumsByBucketId
  }

  private fun mergeAlbum(
    albumsByBucketId: LinkedHashMap<String, AlbumAccumulator>,
    videoId: Long,
    bucketId: String,
    bucketName: String,
    dateAddedSeconds: Long,
    dateModifiedSeconds: Long,
  ) {
    val current = albumsByBucketId[bucketId]
    if (current == null) {
      albumsByBucketId[bucketId] =
        AlbumAccumulator(
          bucketName = bucketName,
          videoCount = 1,
          latestDateAddedSeconds = dateAddedSeconds,
          latestVideoId = videoId,
          latestVideoDateModified = dateModifiedSeconds,
        )
      return
    }

    current.videoCount += 1
    if (shouldUpdateLatestVideo(current, dateAddedSeconds, videoId)) {
      current.latestDateAddedSeconds = dateAddedSeconds
      current.latestVideoId = videoId
      current.latestVideoDateModified = dateModifiedSeconds
    }
    if (current.bucketName.isEmpty() && bucketName.isNotEmpty()) {
      current.bucketName = bucketName
    }
  }

  private fun shouldUpdateLatestVideo(
    current: AlbumAccumulator,
    dateAddedSeconds: Long,
    videoId: Long,
  ): Boolean {
    if (dateAddedSeconds != current.latestDateAddedSeconds) {
      return dateAddedSeconds > current.latestDateAddedSeconds
    }
    return videoId > current.latestVideoId
  }

  private fun buildVideoRecords(cursor: Cursor): List<NativeVideoRecord> {
    val columns = resolveVideoCursorColumns(cursor)
    val videos = ArrayList<NativeVideoRecord>(cursor.count.coerceAtLeast(0))

    while (cursor.moveToNext()) {
      val video = readVideoRecord(cursor, columns) ?: continue
      videos.add(video)
    }

    return videos
  }

  private fun resolveVideoCursorColumns(cursor: Cursor): VideoCursorColumns {
    return VideoCursorColumns(
      idIndex = cursor.getColumnIndexOrThrow(MediaStore.Video.Media._ID),
      nameIndex = cursor.getColumnIndexOrThrow(MediaStore.Video.Media.DISPLAY_NAME),
      bucketIdIndex = cursor.getColumnIndexOrThrow(MediaStore.Video.Media.BUCKET_ID),
      bucketNameIndex =
        cursor.getColumnIndexOrThrow(MediaStore.Video.Media.BUCKET_DISPLAY_NAME),
      durationIndex = cursor.getColumnIndexOrThrow(MediaStore.Video.Media.DURATION),
      sizeIndex = cursor.getColumnIndexOrThrow(MediaStore.Video.Media.SIZE),
      dateAddedIndex = cursor.getColumnIndexOrThrow(MediaStore.Video.Media.DATE_ADDED),
      dateModifiedIndex =
        cursor.getColumnIndexOrThrow(MediaStore.Video.Media.DATE_MODIFIED),
      widthIndex = cursor.getColumnIndexOrThrow(MediaStore.Video.Media.WIDTH),
      heightIndex = cursor.getColumnIndexOrThrow(MediaStore.Video.Media.HEIGHT),
    )
  }

  private fun readVideoRecord(
    cursor: Cursor,
    columns: VideoCursorColumns,
  ): NativeVideoRecord? {
    val mediaId = cursor.getLong(columns.idIndex)
    val bucketId = cursor.getString(columns.bucketIdIndex) ?: return null

    return NativeVideoRecord(
      id = mediaId.toString(),
      path = buildVideoUri(mediaId).toString(),
      name = resolveVideoName(cursor.getString(columns.nameIndex), mediaId),
      bucketId = bucketId,
      bucketName = cursor.getString(columns.bucketNameIndex) ?: "",
      durationMs = cursor.getLong(columns.durationIndex),
      size = cursor.getLong(columns.sizeIndex),
      dateAdded = cursor.getLong(columns.dateAddedIndex),
      width = cursor.getLong(columns.widthIndex),
      height = cursor.getLong(columns.heightIndex),
      dateModified = cursor.getLong(columns.dateModifiedIndex),
    )
  }

  private fun resolveVideoName(name: String?, mediaId: Long): String {
    if (!name.isNullOrBlank()) {
      return name
    }
    return "$kUnknownVideoName-$mediaId"
  }

  private fun buildVideoUri(mediaId: Long): Uri {
    return ContentUris.withAppendedId(MediaStore.Video.Media.EXTERNAL_CONTENT_URI, mediaId)
  }

  private fun mapToNativeAlbumRecords(
    albumsByBucketId: LinkedHashMap<String, AlbumAccumulator>,
  ): List<NativeAlbumRecord> {
    return albumsByBucketId
      .map { entry ->
        NativeAlbumRecord(
          bucketId = entry.key,
          bucketName = entry.value.bucketName,
          videoCount = entry.value.videoCount.toLong(),
          latestDateAddedSeconds = entry.value.latestDateAddedSeconds,
          latestVideoId = entry.value.latestVideoId,
          latestVideoPath = buildVideoUri(entry.value.latestVideoId).toString(),
          latestVideoDateModified = entry.value.latestVideoDateModified,
        )
      }
      .sortedByDescending { it.latestDateAddedSeconds }
  }
}

private data class AlbumAccumulator(
  var bucketName: String,
  var videoCount: Int,
  var latestDateAddedSeconds: Long,
  var latestVideoId: Long,
  var latestVideoDateModified: Long,
)

private data class VideoCursorColumns(
  val idIndex: Int,
  val nameIndex: Int,
  val bucketIdIndex: Int,
  val bucketNameIndex: Int,
  val durationIndex: Int,
  val sizeIndex: Int,
  val dateAddedIndex: Int,
  val dateModifiedIndex: Int,
  val widthIndex: Int,
  val heightIndex: Int,
)
