package media.gabriel.pixelplay.mediastore

import android.Manifest
import android.app.Activity
import android.content.ContentResolver
import android.content.ContentUris
import android.content.pm.PackageManager
import android.database.Cursor
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.provider.MediaStore
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors
import media.gabriel.pixelplay.pigeon.FlutterError
import media.gabriel.pixelplay.pigeon.MediaStoreAlbumsApi
import media.gabriel.pixelplay.pigeon.NativeAlbumRecord
import media.gabriel.pixelplay.pigeon.NativeVideoRecord

private const val kPermissionRequestCode = 4127
private const val kUnknownVideoName = "未命名视频"

class MediaStoreAlbumsApiImpl(private val activity: Activity) : MediaStoreAlbumsApi {
  private val executor: ExecutorService = Executors.newSingleThreadExecutor()
  private val mainHandler = Handler(Looper.getMainLooper())
  private var pendingPermissionCallback: ((Result<Boolean>) -> Unit)? = null

  override fun hasVideoPermission(callback: (Result<Boolean>) -> Unit) {
    callback(Result.success(isVideoPermissionGranted()))
  }

  override fun requestVideoPermission(callback: (Result<Boolean>) -> Unit) {
    if (isVideoPermissionGranted()) {
      callback(Result.success(true))
      return
    }
    if (pendingPermissionCallback != null) {
      callback(Result.failure(permissionRequestInFlightError()))
      return
    }

    pendingPermissionCallback = callback
    ActivityCompat.requestPermissions(
      activity,
      arrayOf(requiredVideoPermission()),
      kPermissionRequestCode,
    )
  }

  override fun scanLocalVideoAlbums(callback: (Result<List<NativeAlbumRecord>>) -> Unit) {
    executeQuery(callback) {
      queryVideoAlbums(activity.contentResolver)
    }
  }

  override fun scanAlbumVideos(
    bucketId: String,
    callback: (Result<List<NativeVideoRecord>>) -> Unit,
  ) {
    executeQuery(callback) {
      queryAlbumVideos(
        contentResolver = activity.contentResolver,
        bucketId = bucketId,
      )
    }
  }

  fun onRequestPermissionsResult(requestCode: Int, grantResults: IntArray): Boolean {
    if (requestCode != kPermissionRequestCode) return false

    val granted =
      grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED
    val callback = pendingPermissionCallback
    pendingPermissionCallback = null
    callback?.invoke(Result.success(granted))
    return true
  }

  private fun <T> executeQuery(
    callback: (Result<T>) -> Unit,
    query: () -> T,
  ) {
    if (!isVideoPermissionGranted()) {
      callback(Result.failure(permissionDeniedError()))
      return
    }

    executor.execute {
      val result = runCatching(query)
      mainHandler.post { callback(result) }
    }
  }

  private fun isVideoPermissionGranted(): Boolean {
    val permission = requiredVideoPermission()
    val result = ContextCompat.checkSelfPermission(activity, permission)
    return result == PackageManager.PERMISSION_GRANTED
  }

  private fun requiredVideoPermission(): String {
    return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
      Manifest.permission.READ_MEDIA_VIDEO
    } else {
      Manifest.permission.READ_EXTERNAL_STORAGE
    }
  }

  private fun permissionDeniedError(): FlutterError {
    return FlutterError(
      code = "permission_denied",
      message = "Missing video permission.",
    )
  }

  private fun permissionRequestInFlightError(): FlutterError {
    return FlutterError(
      code = "permission_request_in_flight",
      message = "Video permission request already running.",
    )
  }

  private data class AlbumAccumulator(
    var bucketName: String,
    var videoCount: Int,
    var latestDateAddedSeconds: Long,
  )

  private data class VideoCursorColumns(
    val idIndex: Int,
    val nameIndex: Int,
    val bucketIdIndex: Int,
    val bucketNameIndex: Int,
    val durationIndex: Int,
    val sizeIndex: Int,
    val dateAddedIndex: Int,
  )

  private fun queryVideoAlbums(contentResolver: ContentResolver): List<NativeAlbumRecord> {
    val cursor = queryAlbumAggregationCursor(contentResolver) ?: return emptyList()
    val albumsByBucketId = cursor.use(::buildAlbumMap)
    return mapToNativeAlbumRecords(albumsByBucketId)
  }

  private fun queryAlbumVideos(
    contentResolver: ContentResolver,
    bucketId: String,
  ): List<NativeVideoRecord> {
    val cursor = queryAlbumVideoCursor(contentResolver, bucketId) ?: return emptyList()
    return cursor.use(::buildVideoRecords)
  }

  private fun queryAlbumAggregationCursor(contentResolver: ContentResolver): Cursor? {
    val projection =
      arrayOf(
        MediaStore.Video.Media.BUCKET_ID,
        MediaStore.Video.Media.BUCKET_DISPLAY_NAME,
        MediaStore.Video.Media.DATE_ADDED,
      )
    return contentResolver.query(
      MediaStore.Video.Media.EXTERNAL_CONTENT_URI,
      projection,
      null,
      null,
      "${MediaStore.Video.Media.DATE_ADDED} DESC",
    )
  }

  private fun queryAlbumVideoCursor(
    contentResolver: ContentResolver,
    bucketId: String,
  ): Cursor? {
    val projection =
      arrayOf(
        MediaStore.Video.Media._ID,
        MediaStore.Video.Media.DISPLAY_NAME,
        MediaStore.Video.Media.BUCKET_ID,
        MediaStore.Video.Media.BUCKET_DISPLAY_NAME,
        MediaStore.Video.Media.DURATION,
        MediaStore.Video.Media.SIZE,
        MediaStore.Video.Media.DATE_ADDED,
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
    val bucketIdIndex = cursor.getColumnIndexOrThrow(MediaStore.Video.Media.BUCKET_ID)
    val bucketNameIndex =
      cursor.getColumnIndexOrThrow(MediaStore.Video.Media.BUCKET_DISPLAY_NAME)
    val dateAddedIndex = cursor.getColumnIndexOrThrow(MediaStore.Video.Media.DATE_ADDED)

    while (cursor.moveToNext()) {
      val bucketId = cursor.getString(bucketIdIndex) ?: continue
      val bucketName = cursor.getString(bucketNameIndex) ?: ""
      val dateAdded = cursor.getLong(dateAddedIndex)
      addVideoToAlbumMap(albumsByBucketId, bucketId, bucketName, dateAdded)
    }

    return albumsByBucketId
  }

  private fun addVideoToAlbumMap(
    albumsByBucketId: LinkedHashMap<String, AlbumAccumulator>,
    bucketId: String,
    bucketName: String,
    dateAddedSeconds: Long,
  ) {
    val current = albumsByBucketId[bucketId]
    if (current == null) {
      albumsByBucketId[bucketId] =
        AlbumAccumulator(
          bucketName = bucketName,
          videoCount = 1,
          latestDateAddedSeconds = dateAddedSeconds,
        )
      return
    }

    current.videoCount += 1
    if (dateAddedSeconds > current.latestDateAddedSeconds) {
      current.latestDateAddedSeconds = dateAddedSeconds
    }
    if (current.bucketName.isEmpty() && bucketName.isNotEmpty()) {
      current.bucketName = bucketName
    }
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
    )
  }

  private fun readVideoRecord(
    cursor: Cursor,
    columns: VideoCursorColumns,
  ): NativeVideoRecord? {
    val mediaId = cursor.getLong(columns.idIndex)
    val bucketId = cursor.getString(columns.bucketIdIndex) ?: return null
    val sourceUri = buildVideoUri(mediaId)

    return NativeVideoRecord(
      id = mediaId.toString(),
      path = sourceUri.toString(),
      name = resolveVideoName(cursor, columns.nameIndex, mediaId),
      bucketId = bucketId,
      bucketName = cursor.getString(columns.bucketNameIndex) ?: "",
      durationMs = cursor.getLong(columns.durationIndex),
      size = cursor.getLong(columns.sizeIndex),
      dateAdded = cursor.getLong(columns.dateAddedIndex),
    )
  }

  private fun resolveVideoName(cursor: Cursor, nameIndex: Int, mediaId: Long): String {
    val name = cursor.getString(nameIndex)
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
        )
      }
      .sortedByDescending { it.latestDateAddedSeconds }
  }
}
