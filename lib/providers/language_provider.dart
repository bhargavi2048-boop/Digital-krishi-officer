import 'package:flutter/material.dart';
import '../core/storage/local_storage_service.dart';

class LanguageProvider extends ChangeNotifier {
  final LocalStorageService _storage = LocalStorageService();
  String _currentLanguageCode = 'en';

  String get currentLanguageCode => _currentLanguageCode;
  Locale get currentLocale => Locale(_currentLanguageCode);

  LanguageProvider() {
    _loadLanguage();
  }

  void _loadLanguage() {
    _currentLanguageCode = _storage.getLanguage();
    notifyListeners();
  }

  Future<void> setLanguage(String langCode) async {
    if (_currentLanguageCode != langCode) {
      _currentLanguageCode = langCode;
      await _storage.setLanguage(langCode);
      notifyListeners();
    }
  }
}
