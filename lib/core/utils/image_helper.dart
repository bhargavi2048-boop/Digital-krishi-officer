import 'dart:typed_data';

class ImageHelper {
  // Verifies if image bytes or size are within valid threshold (e.g. 15MB)
  static bool isValidImageBytes(Uint8List? bytes, {int maxBytes = 15 * 1024 * 1024}) {
    if (bytes == null || bytes.isEmpty) return false;
    return bytes.length <= maxBytes;
  }

  // Returns human-readable formatted file size
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  static String formatBytes(int bytes) => formatFileSize(bytes);

  // Automatically detects MIME type based on header bytes and file extensions
  static String detectMimeType(String? name, [List<int>? bytes]) {
    // 1. Check magic bytes
    if (bytes != null && bytes.length >= 4) {
      if (bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF) return 'image/jpeg';
      if (bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4E && bytes[3] == 0x47) return 'image/png';
      if (bytes[0] == 0x47 && bytes[1] == 0x49 && bytes[2] == 0x46) return 'image/gif';
      if (bytes.length >= 12 &&
          bytes[0] == 0x52 &&
          bytes[1] == 0x49 &&
          bytes[2] == 0x46 &&
          bytes[3] == 0x46) {
        return 'image/webp';
      }
      // MP4 typically has ftyp box at offset 4
      if (bytes.length >= 12) {
        final ftyp = String.fromCharCodes(bytes.sublist(4, 8));
        if (ftyp == 'ftyp') return 'video/mp4';
      }
      // WebM
      if (bytes[0] == 0x1A && bytes[1] == 0x45 && bytes[2] == 0xDF && bytes[3] == 0xA3) return 'video/webm';
    }

    // 2. Check filename extension
    if (name != null && name.isNotEmpty) {
      final ext = name.toLowerCase();
      if (ext.endsWith('.jpg') || ext.endsWith('.jpeg')) return 'image/jpeg';
      if (ext.endsWith('.png')) return 'image/png';
      if (ext.endsWith('.webp')) return 'image/webp';
      if (ext.endsWith('.gif')) return 'image/gif';
      if (ext.endsWith('.heic') || ext.endsWith('.heif')) return 'image/heic';
      if (ext.endsWith('.mp4')) return 'video/mp4';
      if (ext.endsWith('.mov')) return 'video/quicktime';
      if (ext.endsWith('.webm')) return 'video/webm';
      if (ext.endsWith('.avi')) return 'video/x-msvideo';
      if (ext.endsWith('.3gp')) return 'video/3gpp';
      if (ext.endsWith('.m4v')) return 'video/mp4';
    }

    return 'image/jpeg';
  }

  static bool isVideoMime(String mime) => mime.startsWith('video/');
  static bool isImageMime(String mime) => mime.startsWith('image/');

  static bool isVideoFileName(String? name) {
    if (name == null) return false;
    final lower = name.toLowerCase();
    return lower.endsWith('.mp4') ||
        lower.endsWith('.mov') ||
        lower.endsWith('.webm') ||
        lower.endsWith('.avi') ||
        lower.endsWith('.m4v') ||
        lower.endsWith('.3gp') ||
        lower.endsWith('.mkv');
  }
}
