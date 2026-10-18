import 'package:flutter/material.dart';
import '../core/storage/local_storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  final LocalStorageService _storage = LocalStorageService();
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  ThemeProvider() {
    _loadTheme();
  }

  void _loadTheme() {
    _isDarkMode = _storage.getSettings().isDarkMode;
    notifyListeners();
  }

  Future<void> toggleTheme(bool isDark) async {
    _isDarkMode = isDark;
    final currentSettings = _storage.getSettings();
    await _storage.saveSettings(currentSettings.copyWith(isDarkMode: isDark));
    notifyListeners();
  }
}
