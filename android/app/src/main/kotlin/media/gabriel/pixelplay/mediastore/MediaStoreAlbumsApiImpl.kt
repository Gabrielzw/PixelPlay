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
import media.gabriel.pixelplay.pigeon.NativeVideoRecord

private const val kPermissionRequestCode = 4127

class MediaStoreAlbumsApiImpl(private val activity: Activity) : MediaStoreAlbumsApi {
  private val executor: ExecutorService = Executors.newSingleThreadExecutor()
  private val mainHandler = Handler(Looper.getMainLooper())
  private val scanner = MediaStoreVideoScanner(activity.contentResolver)
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
    executeQuery(callback) { scanner.scanAlbums() }
  }

  override fun scanAlbumVideos(
    bucketId: String,
    callback: (Result<List<NativeVideoRecord>>) -> Unit,
  ) {
    executeQuery(callback) { scanner.scanAlbumVideos(bucketId) }
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
}
