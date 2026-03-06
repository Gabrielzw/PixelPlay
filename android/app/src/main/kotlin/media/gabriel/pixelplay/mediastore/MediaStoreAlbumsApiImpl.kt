package media.gabriel.pixelplay.mediastore

import android.Manifest
import android.app.Activity
import android.content.ContentResolver
import android.content.pm.PackageManager
import android.database.Cursor
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

private const val kPermissionRequestCode = 4127

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
      callback(
        Result.failure(
          FlutterError(
            code = "permission_request_in_flight",
            message = "Video permission request already running.",
          ),
        ),
      )
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
    if (!isVideoPermissionGranted()) {
      callback(
        Result.failure(
          FlutterError(
            code = "permission_denied",
            message = "Missing video permission.",
          ),
        ),
      )
      return
    }

    executor.execute {
      val result = runCatching { queryVideoAlbums(activity.contentResolver) }
      mainHandler.post { callback(result) }
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

  private data class AlbumAccumulator(
    var bucketName: String,
    var videoCount: Int,
    var latestDateAddedSeconds: Long,
  )

  private fun queryVideoAlbums(contentResolver: ContentResolver): List<NativeAlbumRecord> {
    val cursor = queryVideoCursor(contentResolver) ?: return emptyList()
    val albumsByBucketId = cursor.use { buildAlbumMap(it) }
    return mapToNativeAlbumRecords(albumsByBucketId)
  }

  private fun queryVideoCursor(contentResolver: ContentResolver): Cursor? {
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
      addVideoToAlbumMap(
        albumsByBucketId = albumsByBucketId,
        bucketId = bucketId,
        bucketName = bucketName,
        dateAddedSeconds = dateAdded,
      )
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
