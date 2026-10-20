import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'camera_helper.dart';

Future<CapturedMedia?> captureLivePhotoPlatform(BuildContext context) async {
  try {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
      maxWidth: 1280,
      maxHeight: 1280,
      imageQuality: 85,
    );
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      final size = await picked.length();
      return CapturedMedia(
        bytes: bytes,
        path: picked.path,
        name: picked.name,
        size: size,
      );
    }
  } catch (e) {
    debugPrint('Camera capture stub error: $e');
  }
  return null;
}
