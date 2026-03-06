package media.gabriel.pixelplay

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import media.gabriel.pixelplay.mediastore.MediaStoreAlbumsApiImpl
import media.gabriel.pixelplay.pigeon.MediaStoreAlbumsApi

class MainActivity : FlutterActivity() {
  private var mediaStoreAlbumsApiImpl: MediaStoreAlbumsApiImpl? = null

  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    val apiImpl = MediaStoreAlbumsApiImpl(activity = this)
    mediaStoreAlbumsApiImpl = apiImpl
    MediaStoreAlbumsApi.setUp(flutterEngine.dartExecutor.binaryMessenger, apiImpl)
  }

  override fun onRequestPermissionsResult(
    requestCode: Int,
    permissions: Array<out String>,
    grantResults: IntArray,
  ) {
    mediaStoreAlbumsApiImpl?.onRequestPermissionsResult(requestCode, grantResults)
    super.onRequestPermissionsResult(requestCode, permissions, grantResults)
  }
}
