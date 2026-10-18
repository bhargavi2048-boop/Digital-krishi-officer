import 'dart:convert';
import 'dart:typed_data';

class ChatMessage {
  final String id;
  final String conversationId;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? imagePath;
  final Uint8List? imageBytes;
  final String? videoPath;
  final String? mediaName;
  final int? mediaSizeBytes;
  final bool isVideoFrameAnalysis;
  final bool isVoiceMessage;

  ChatMessage({
    required this.id,
    required this.conversationId,
    required this.text,
    required this.isUser,
    DateTime? timestamp,
    this.imagePath,
    this.imageBytes,
    this.videoPath,
    this.mediaName,
    this.mediaSizeBytes,
    this.isVideoFrameAnalysis = false,
    this.isVoiceMessage = false,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'conversationId': conversationId,
      'text': text,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'imagePath': imagePath,
      'imageBase64': imageBytes != null ? base64Encode(imageBytes!) : null,
      'videoPath': videoPath,
      'mediaName': mediaName,
      'mediaSizeBytes': mediaSizeBytes,
      'isVideoFrameAnalysis': isVideoFrameAnalysis,
      'isVoiceMessage': isVoiceMessage,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    Uint8List? bytes;
    if (map['imageBase64'] != null && (map['imageBase64'] as String).isNotEmpty) {
      try {
        bytes = base64Decode(map['imageBase64']);
      } catch (_) {}
    }

    return ChatMessage(
      id: map['id'] ?? '',
      conversationId: map['conversationId'] ?? '',
      text: map['text'] ?? '',
      isUser: map['isUser'] ?? false,
      timestamp: map['timestamp'] != null ? DateTime.tryParse(map['timestamp']) ?? DateTime.now() : DateTime.now(),
      imagePath: map['imagePath'],
      imageBytes: bytes,
      videoPath: map['videoPath'],
      mediaName: map['mediaName'],
      mediaSizeBytes: map['mediaSizeBytes'],
      isVideoFrameAnalysis: map['isVideoFrameAnalysis'] ?? false,
      isVoiceMessage: map['isVoiceMessage'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatMessage.fromJson(String source) => ChatMessage.fromMap(json.decode(source));
}
