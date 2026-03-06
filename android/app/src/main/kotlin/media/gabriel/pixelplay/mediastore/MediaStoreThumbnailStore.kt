package media.gabriel.pixelplay.mediastore

import android.content.ContentResolver
import android.graphics.Bitmap
import android.graphics.Matrix
import android.media.MediaMetadataRetriever
import android.net.Uri
import java.io.File
import java.io.FileOutputStream
import java.security.MessageDigest
import media.gabriel.pixelplay.pigeon.NativeThumbnailRequest

private const val kThumbnailCacheDirectoryName = "video_thumbnails"
private const val kThumbnailCompressionQuality = 82
private const val kRepresentativeFrameTimeUs = -1L
private const val kNoRotationDegrees = 0

internal class MediaStoreThumbnailStore(
  private val contentResolver: ContentResolver,
  cacheRoot: File,
) {
  private val cacheDirectory =
    File(cacheRoot, kThumbnailCacheDirectoryName).apply { mkdirs() }

  fun resolveThumbnail(request: NativeThumbnailRequest): String {
    val spec = request.toSpec()
    val cachedFile = resolveCacheFile(spec)
    if (cachedFile.exists()) {
      return cachedFile.absolutePath
    }

    val bitmap = loadBitmap(spec)
      ?: error("Failed to resolve thumbnail for ${spec.videoPath}.")
    writeBitmap(cachedFile, bitmap)
    return cachedFile.absolutePath
  }

  fun clearCache() {
    cacheDirectory.listFiles()?.forEach(File::delete)
  }

  private fun resolveCacheFile(spec: ThumbnailSpec): File {
    val key = "${spec.videoId}_${spec.dateModified}_origin"
    return File(cacheDirectory, "${key.md5()}.jpg")
  }

  private fun loadBitmap(spec: ThumbnailSpec): Bitmap? {
    val uri = Uri.parse(spec.videoPath)
    val descriptor = contentResolver.openFileDescriptor(uri, "r") ?: return null
    val retriever = MediaMetadataRetriever()

    try {
      descriptor.use { fileDescriptor ->
        retriever.setDataSource(fileDescriptor.fileDescriptor)
        val frame =
          retriever.getFrameAtTime(
            kRepresentativeFrameTimeUs,
            MediaMetadataRetriever.OPTION_CLOSEST_SYNC,
          ) ?: return null
        return normalizeBitmap(frame, extractRotationDegrees(retriever))
      }
    } finally {
      retriever.release()
    }
  }

  private fun extractRotationDegrees(retriever: MediaMetadataRetriever): Int {
    val value = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_ROTATION)
    return value?.toIntOrNull() ?: kNoRotationDegrees
  }

  private fun normalizeBitmap(bitmap: Bitmap, rotationDegrees: Int): Bitmap {
    if (rotationDegrees == kNoRotationDegrees) {
      return bitmap
    }

    val matrix = Matrix().apply { postRotate(rotationDegrees.toFloat()) }
    val rotatedBitmap = Bitmap.createBitmap(
      bitmap,
      0,
      0,
      bitmap.width,
      bitmap.height,
      matrix,
      true,
    )
    if (rotatedBitmap != bitmap) {
      bitmap.recycle()
    }
    return rotatedBitmap
  }

  private fun writeBitmap(file: File, bitmap: Bitmap) {
    val tempFile = File(file.parentFile, "${file.name}.tmp")
    FileOutputStream(tempFile).use { output ->
      val compressed =
        bitmap.compress(Bitmap.CompressFormat.JPEG, kThumbnailCompressionQuality, output)
      check(compressed) { "Failed to compress thumbnail ${file.name}." }
      output.fd.sync()
    }

    if (file.exists()) {
      tempFile.delete()
      return
    }
    val moved = tempFile.renameTo(file)
    check(moved) { "Failed to persist thumbnail ${file.absolutePath}." }
  }
}

private fun NativeThumbnailRequest.toSpec(): ThumbnailSpec {
  return ThumbnailSpec(
    videoId = videoId,
    videoPath = videoPath,
    dateModified = dateModified,
  )
}

private fun String.md5(): String {
  val bytes = MessageDigest.getInstance("MD5").digest(toByteArray())
  return bytes.joinToString(separator = "") { byte -> "%02x".format(byte) }
}

private data class ThumbnailSpec(
  val videoId: Long,
  val videoPath: String,
  val dateModified: Long,
)
