import 'package:flutter/material.dart';
import '../core/services/scheme_service.dart';
import '../core/storage/local_storage_service.dart';
import '../models/government_scheme.dart';
import '../models/farmer_profile.dart';
import '../models/saved_item.dart';

class SchemeProvider extends ChangeNotifier {
  final SchemeService _schemeService = SchemeService();
  final LocalStorageService _storage = LocalStorageService();

  List<GovernmentScheme> _schemes = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';

  List<GovernmentScheme> get schemes {
    if (_searchQuery.isNotEmpty) {
      return _schemeService.searchSchemes(_searchQuery);
    }
    return _schemeService.getSchemesByCategory(_selectedCategory);
  }

  List<SchemeRecommendation> getRecommendations(FarmerProfile? profile) {
    return _schemeService.getPersonalizedRecommendations(profile);
  }

  List<GovernmentScheme> get allSchemes => _schemes;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  SchemeProvider() {
    loadSchemes();
  }

  void loadSchemes() {
    _schemes = _schemeService.getAllSchemes();
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> saveScheme(GovernmentScheme scheme) async {
    final item = SavedItem(
      id: 'saved_scheme_${scheme.id}',
      title: scheme.name,
      subtitle: '${scheme.category} - ${scheme.shortDescription}',
      category: 'scheme',
      content: '''
**Description:** ${scheme.detailedDescription}
**Official Source:** ${scheme.officialSource}
**Website:** ${scheme.officialUrl}
**Benefits:** ${scheme.benefits.join(', ')}
''',
    );
    await _storage.saveItem(item);
  }
}
