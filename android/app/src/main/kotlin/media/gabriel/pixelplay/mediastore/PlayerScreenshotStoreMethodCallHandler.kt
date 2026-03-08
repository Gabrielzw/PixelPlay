package media.gabriel.pixelplay.mediastore

import android.Manifest
import android.app.Activity
import android.content.ContentValues
import android.content.pm.PackageManager
import android.media.MediaScannerConnection
import android.os.Build
import android.os.Environment
import android.os.Handler
import android.os.Looper
import android.provider.MediaStore
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.IOException
import java.time.Instant
import java.time.ZoneId
import java.time.format.DateTimeFormatter
import java.util.Locale
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

private const val kScreenshotStoreChannelName = "pixelplay/player_screenshot_store"
private const val kSaveScreenshotMethodName = "saveScreenshot"
private const val kWritePermissionRequestCode = 4128
private const val kScreenshotDirectoryName = "PixelPlay"
private const val kScreenshotMimeType = "image/png"
private const val kScreenshotFilePrefix = "PixelPlay_"
private const val kScreenshotFileExtension = ".png"
private const val kScreenshotFileTimestampPattern = "yyyyMMddHHmmss"
private val kScreenshotFileTimestampFormatter: DateTimeFormatter =
  DateTimeFormatter.ofPattern(kScreenshotFileTimestampPattern, Locale.US)

class PlayerScreenshotStoreMethodCallHandler(private val activity: Activity) :
  MethodChannel.MethodCallHandler {
  private val executor: ExecutorService = Executors.newSingleThreadExecutor()
  private val mainHandler = Handler(Looper.getMainLooper())
  private var pendingSaveResult: MethodChannel.Result? = null
  private var pendingScreenshotBytes: ByteArray? = null

  fun bind(messenger: BinaryMessenger) {
    MethodChannel(messenger, kScreenshotStoreChannelName).setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    if (call.method != kSaveScreenshotMethodName) {
      result.notImplemented()
      return
    }

    val bytes = call.argument<ByteArray>("bytes")
    if (bytes == null || bytes.isEmpty()) {
      result.error("invalid_args", "Missing screenshot bytes.", null)
      return
    }

    if (requiresLegacyWritePermission() && !hasLegacyWritePermission()) {
      requestLegacyWritePermission(bytes, result)
      return
    }

    executeSave(bytes, result)
  }

  fun onRequestPermissionsResult(requestCode: Int, grantResults: IntArray): Boolean {
    if (requestCode != kWritePermissionRequestCode) {
      return false
    }

    val result = pendingSaveResult
    val bytes = pendingScreenshotBytes
    pendingSaveResult = null
    pendingScreenshotBytes = null
    if (result == null || bytes == null) {
      return true
    }

    val granted =
      grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED
    if (!granted) {
      result.error("permission_denied", "Missing storage write permission.", null)
      return true
    }

    executeSave(bytes, result)
    return true
  }

  private fun requestLegacyWritePermission(
    bytes: ByteArray,
    result: MethodChannel.Result,
  ) {
    if (pendingSaveResult != null) {
      result.error(
        "permission_request_in_flight",
        "Storage permission request already running.",
        null,
      )
      return
    }

    pendingSaveResult = result
    pendingScreenshotBytes = bytes
    ActivityCompat.requestPermissions(
      activity,
      arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE),
      kWritePermissionRequestCode,
    )
  }

  private fun executeSave(bytes: ByteArray, result: MethodChannel.Result) {
    executor.execute {
      val saveResult = runCatching { saveScreenshot(bytes) }
      mainHandler.post {
        saveResult.onSuccess(result::success).onFailure { error ->
          result.error("save_failed", error.message, null)
        }
      }
    }
  }

  private fun saveScreenshot(bytes: ByteArray): String {
    val capturedAtMillis = System.currentTimeMillis()
    return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
      saveToMediaStore(bytes, capturedAtMillis)
    } else {
      saveToLegacyPicturesDirectory(bytes, capturedAtMillis)
    }
  }

  private fun saveToMediaStore(bytes: ByteArray, capturedAtMillis: Long): String {
    val resolver = activity.contentResolver
    val values = ContentValues().apply {
      put(MediaStore.Images.Media.DISPLAY_NAME, buildFileName(capturedAtMillis))
      put(MediaStore.Images.Media.MIME_TYPE, kScreenshotMimeType)
      put(
        MediaStore.Images.Media.RELATIVE_PATH,
        "${Environment.DIRECTORY_PICTURES}/$kScreenshotDirectoryName",
      )
      put(MediaStore.Images.Media.DATE_TAKEN, capturedAtMillis)
      put(MediaStore.Images.Media.IS_PENDING, 1)
    }
    val uri =
      resolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values)
        ?: throw IOException("Unable to create screenshot entry in MediaStore.")

    try {
      val outputStream =
        resolver.openOutputStream(uri)
          ?: throw IOException("Unable to open MediaStore output stream.")
      outputStream.use { it.write(bytes) }
      resolver.update(
        uri,
        ContentValues().apply { put(MediaStore.Images.Media.IS_PENDING, 0) },
        null,
        null,
      )
      return uri.toString()
    } catch (error: Throwable) {
      resolver.delete(uri, null, null)
      throw error
    }
  }

  @Suppress("DEPRECATION")
  private fun saveToLegacyPicturesDirectory(
    bytes: ByteArray,
    capturedAtMillis: Long,
  ): String {
    val picturesDirectory =
      Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES)
    val screenshotDirectory = File(picturesDirectory, kScreenshotDirectoryName)
    if (!screenshotDirectory.exists() && !screenshotDirectory.mkdirs()) {
      throw IOException("Unable to create screenshot directory.")
    }

    val screenshotFile = File(screenshotDirectory, buildFileName(capturedAtMillis))
    screenshotFile.outputStream().use { it.write(bytes) }
    MediaScannerConnection.scanFile(
      activity,
      arrayOf(screenshotFile.absolutePath),
      arrayOf(kScreenshotMimeType),
      null,
    )
    return screenshotFile.absolutePath
  }

  private fun requiresLegacyWritePermission(): Boolean {
    return Build.VERSION.SDK_INT < Build.VERSION_CODES.Q
  }

  private fun hasLegacyWritePermission(): Boolean {
    val grantResult = ContextCompat.checkSelfPermission(
      activity,
      Manifest.permission.WRITE_EXTERNAL_STORAGE,
    )
    return grantResult == PackageManager.PERMISSION_GRANTED
  }

  private fun buildFileName(timestampMillis: Long): String {
    val localTimestamp =
      Instant.ofEpochMilli(timestampMillis)
        .atZone(ZoneId.systemDefault())
        .format(kScreenshotFileTimestampFormatter)
    return "$kScreenshotFilePrefix$localTimestamp$kScreenshotFileExtension"
  }
}
