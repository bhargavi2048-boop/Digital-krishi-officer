import 'dart:convert';

class AppSettings {
  final String languageCode;
  final bool isDarkMode;
  final double voiceSpeed;
  final bool notificationsEnabled;
  final bool offlineCacheEnabled;

  AppSettings({
    this.languageCode = 'en',
    this.isDarkMode = false,
    this.voiceSpeed = 1.0,
    this.notificationsEnabled = true,
    this.offlineCacheEnabled = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'languageCode': languageCode,
      'isDarkMode': isDarkMode,
      'voiceSpeed': voiceSpeed,
      'notificationsEnabled': notificationsEnabled,
      'offlineCacheEnabled': offlineCacheEnabled,
    };
  }

  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      languageCode: map['languageCode'] ?? 'en',
      isDarkMode: map['isDarkMode'] ?? false,
      voiceSpeed: (map['voiceSpeed'] is num) ? (map['voiceSpeed'] as num).toDouble() : 1.0,
      notificationsEnabled: map['notificationsEnabled'] ?? true,
      offlineCacheEnabled: map['offlineCacheEnabled'] ?? true,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppSettings.fromJson(String source) => AppSettings.fromMap(json.decode(source));

  AppSettings copyWith({
    String? languageCode,
    bool? isDarkMode,
    double? voiceSpeed,
    bool? notificationsEnabled,
    bool? offlineCacheEnabled,
  }) {
    return AppSettings(
      languageCode: languageCode ?? this.languageCode,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      voiceSpeed: voiceSpeed ?? this.voiceSpeed,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      offlineCacheEnabled: offlineCacheEnabled ?? this.offlineCacheEnabled,
    );
  }
}
