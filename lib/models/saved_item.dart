import 'dart:convert';

class SavedItem {
  final String id;
  final String title;
  final String subtitle;
  final String category; // 'ai_advice', 'crop_recommendation', 'disease_report', 'scheme', 'weather_advisory'
  final String content;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  SavedItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.content,
    DateTime? timestamp,
    this.metadata,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'category': category,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory SavedItem.fromMap(Map<String, dynamic> map) {
    return SavedItem(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      category: map['category'] ?? 'ai_advice',
      content: map['content'] ?? '',
      timestamp: map['timestamp'] != null ? DateTime.tryParse(map['timestamp']) ?? DateTime.now() : DateTime.now(),
      metadata: map['metadata'] != null ? Map<String, dynamic>.from(map['metadata']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SavedItem.fromJson(String source) => SavedItem.fromMap(json.decode(source));
}
