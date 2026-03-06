package media.gabriel.pixelplay.mediastore

import android.Manifest
import android.app.Activity
import android.content.pm.PackageManager
import android.os.Build
import android.os.Handler
import android.os.Looper
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors
import media.gabriel.pixelplay.pigeon.FlutterError
import media.gabriel.pixelplay.pigeon.MediaStoreAlbumsApi
import media.gabriel.pixelplay.pigeon.NativeAlbumRecord
import media.gabriel.pixelplay.pigeon.NativeThumbnailRequest
import media.gabriel.pixelplay.pigeon.NativeVideoRecord

private const val kPermissionRequestCode = 4127
private const val kMaxThumbnailThreads = 4

class MediaStoreAlbumsApiImpl(private val activity: Activity) : MediaStoreAlbumsApi {
  private val scanExecutor: ExecutorService = Executors.newSingleThreadExecutor()
  private val thumbnailExecutor: ExecutorService =
    Executors.newFixedThreadPool(resolveThumbnailThreadCount())
  private val mainHandler = Handler(Looper.getMainLooper())
  private val scanner = MediaStoreVideoScanner(activity.contentResolver)
  private val thumbnailStore =
    MediaStoreThumbnailStore(activity.contentResolver, activity.cacheDir)
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
    executeProtectedQuery(scanExecutor, callback) { scanner.scanAlbums() }
  }

  override fun scanAlbumVideos(
    bucketId: String,
    callback: (Result<List<NativeVideoRecord>>) -> Unit,
  ) {
    executeProtectedQuery(scanExecutor, callback) { scanner.scanAlbumVideos(bucketId) }
  }

  override fun resolveVideoThumbnail(
    request: NativeThumbnailRequest,
    callback: (Result<String>) -> Unit,
  ) {
    executeProtectedQuery(thumbnailExecutor, callback) {
      thumbnailStore.resolveThumbnail(request)
    }
  }

  override fun clearThumbnailCache(callback: (Result<Unit>) -> Unit) {
    executeQuery(thumbnailExecutor, callback) {
      thumbnailStore.clearCache()
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

  private fun <T> executeProtectedQuery(
    executor: ExecutorService,
    callback: (Result<T>) -> Unit,
    query: () -> T,
  ) {
    if (!isVideoPermissionGranted()) {
      callback(Result.failure(permissionDeniedError()))
      return
    }

    executeQuery(executor, callback, query)
  }

  private fun <T> executeQuery(
    executor: ExecutorService,
    callback: (Result<T>) -> Unit,
    query: () -> T,
  ) {
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

  private fun resolveThumbnailThreadCount(): Int {
    val candidate = Runtime.getRuntime().availableProcessors() - 1
    return candidate.coerceIn(1, kMaxThumbnailThreads)
  }
}
