import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'camera_helper_stub.dart'
    if (dart.library.html) 'camera_helper_web.dart'
    if (dart.library.io) 'camera_helper_mobile.dart';

class CapturedMedia {
  final Uint8List bytes;
  final String path;
  final String name;
  final int size;

  CapturedMedia({
    required this.bytes,
    required this.path,
    required this.name,
    required this.size,
  });
}

class CameraHelper {
  static Future<CapturedMedia?> captureLivePhoto(BuildContext context) async {
    return captureLivePhotoPlatform(context);
  }
}
