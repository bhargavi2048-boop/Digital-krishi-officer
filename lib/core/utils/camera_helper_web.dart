// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:convert';
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'camera_helper.dart';

Future<CapturedMedia?> captureLivePhotoPlatform(BuildContext context) async {
  return showDialog<CapturedMedia>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => const WebCameraCaptureDialog(),
  );
}

class WebCameraCaptureDialog extends StatefulWidget {
  const WebCameraCaptureDialog({super.key});

  @override
  State<WebCameraCaptureDialog> createState() => _WebCameraCaptureDialogState();
}

class _WebCameraCaptureDialogState extends State<WebCameraCaptureDialog> {
  final String _viewType = 'web-camera-view-${DateTime.now().millisecondsSinceEpoch}';
  html.VideoElement? _videoElement;
  html.MediaStream? _mediaStream;
  bool _isStreaming = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initWebcam();
  }

  Future<void> _initWebcam() async {
    try {
      _videoElement = html.VideoElement()
        ..autoplay = true
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.objectFit = 'cover'
        ..setAttribute('playsinline', 'true');

      ui_web.platformViewRegistry.registerViewFactory(
        _viewType,
        (int viewId) => _videoElement!,
      );

      final mediaDevices = html.window.navigator.mediaDevices;
      if (mediaDevices == null) {
        setState(() => _errorMessage = 'Camera hardware not supported on this browser.');
        return;
      }

      final stream = await mediaDevices.getUserMedia({
        'video': {
          'facingMode': {'ideal': 'environment'},
          'width': {'ideal': 1280},
          'height': {'ideal': 720},
        },
        'audio': false,
      });

      _mediaStream = stream;
      if (_videoElement != null) {
        _videoElement!.srcObject = stream;
        _videoElement!.play();
      }

      if (mounted) {
        setState(() {
          _isStreaming = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Could not access camera: $e\nPlease grant camera permission in your browser.';
        });
      }
    }
  }

  void _capturePhoto() {
    if (_videoElement == null || !_isStreaming) return;

    try {
      final videoWidth = _videoElement!.videoWidth > 0 ? _videoElement!.videoWidth : 640;
      final videoHeight = _videoElement!.videoHeight > 0 ? _videoElement!.videoHeight : 480;

      final canvas = html.CanvasElement(width: videoWidth, height: videoHeight);
      canvas.context2D.drawImage(_videoElement!, 0, 0);

      final dataUrl = canvas.toDataUrl('image/jpeg', 0.90);
      final base64String = dataUrl.split(',').last;
      final bytes = base64Decode(base64String);

      _stopStream();

      final captured = CapturedMedia(
        bytes: bytes,
        path: 'live_camera_${DateTime.now().millisecondsSinceEpoch}.jpg',
        name: 'live_camera_${DateTime.now().millisecondsSinceEpoch}.jpg',
        size: bytes.length,
      );

      Navigator.of(context).pop(captured);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to snap photo: $e')),
      );
    }
  }

  void _stopStream() {
    try {
      if (_mediaStream != null) {
        for (final track in _mediaStream!.getTracks()) {
          track.stop();
        }
        _mediaStream = null;
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _stopStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: 480,
        color: const Color(0xFF1B381F),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.camera_alt, color: Colors.greenAccent, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Live Crop Camera',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () {
                      _stopStream();
                      Navigator.of(context).pop(null);
                    },
                  ),
                ],
              ),
            ),

            // Camera Viewfinder
            Container(
              height: 320,
              width: double.infinity,
              color: Colors.black,
              child: _errorMessage != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                        ),
                      ),
                    )
                  : _isStreaming
                      ? HtmlElementView(viewType: _viewType)
                      : const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(color: Colors.greenAccent),
                              SizedBox(height: 12),
                              Text(
                                'Starting camera feed...',
                                style: TextStyle(color: Colors.white70, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
            ),

            // Controls Footer
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      _stopStream();
                      Navigator.of(context).pop(null);
                    },
                    icon: const Icon(Icons.close, color: Colors.white70),
                    label: const Text('Cancel', style: TextStyle(color: Colors.white70)),
                  ),
                  ElevatedButton.icon(
                    onPressed: _isStreaming ? _capturePhoto : null,
                    icon: const Icon(Icons.camera, color: Colors.white, size: 22),
                    label: const Text(
                      'Click Photo',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
