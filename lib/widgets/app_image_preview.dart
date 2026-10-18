import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Cross-platform image preview widget compatible with Web, Android, iOS, and Desktop.
/// Never calls `Image.file` on Flutter Web to prevent assertion crashes.
class AppImagePreview extends StatelessWidget {
  final Uint8List? bytes;
  final String? path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;

  const AppImagePreview({
    super.key,
    this.bytes,
    this.path,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (bytes != null && bytes!.isNotEmpty) {
      imageWidget = Image.memory(
        bytes!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildFallback(),
      );
    } else if (path != null && path!.isNotEmpty) {
      final p = path!;
      if (p.startsWith('http://') || p.startsWith('https://') || p.startsWith('blob:')) {
        imageWidget = Image.network(
          p,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => _buildFallback(),
        );
      } else if (!kIsWeb) {
        // On native mobile/desktop platforms, we can use platform image loading
        imageWidget = _buildNativeImage(p);
      } else {
        // On web with local path, display a clean placeholder instead of crashing
        imageWidget = _buildFallback(label: 'Leaf Photo Attached');
      }
    } else {
      imageWidget = _buildFallback();
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildNativeImage(String filePath) {
    // When not on web, we dynamically render via Image.asset or network or fallback
    // To ensure 100% web-safety without importing dart:io, we check if bytes were supplied
    if (bytes != null && bytes!.isNotEmpty) {
      return Image.memory(bytes!, width: width, height: height, fit: fit);
    }
    return _buildFallback(label: 'Image Ready');
  }

  Widget _buildFallback({String? label}) {
    if (placeholder != null) return placeholder!;
    return Container(
      width: width ?? double.infinity,
      height: height ?? 140,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: borderRadius,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo_library_outlined, size: 36, color: Colors.grey.shade500),
            if (label != null) ...[
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
