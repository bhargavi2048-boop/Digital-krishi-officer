import 'dart:convert';

class FarmerAlert {
  final String id;
  final String title;
  final String description;
  final String type; // 'weather', 'crop', 'disease', 'pest', 'irrigation', 'scheme'
  final String severity; // 'info', 'warning', 'critical'
  final DateTime timestamp;
  final bool isRead;
  final String? actionRoute;

  FarmerAlert({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.severity = 'info',
    DateTime? timestamp,
    this.isRead = false,
    this.actionRoute,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'severity': severity,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'actionRoute': actionRoute,
    };
  }

  factory FarmerAlert.fromMap(Map<String, dynamic> map) {
    return FarmerAlert(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      type: map['type'] ?? 'crop',
      severity: map['severity'] ?? 'info',
      timestamp: map['timestamp'] != null ? DateTime.tryParse(map['timestamp']) ?? DateTime.now() : DateTime.now(),
      isRead: map['isRead'] ?? false,
      actionRoute: map['actionRoute'],
    );
  }

  FarmerAlert copyWith({
    String? id,
    String? title,
    String? description,
    String? type,
    String? severity,
    DateTime? timestamp,
    bool? isRead,
    String? actionRoute,
  }) {
    return FarmerAlert(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      severity: severity ?? this.severity,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      actionRoute: actionRoute ?? this.actionRoute,
    );
  }

  String toJson() => json.encode(toMap());

  factory FarmerAlert.fromJson(String source) => FarmerAlert.fromMap(json.decode(source));
}
