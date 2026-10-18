import 'package:flutter/material.dart';
import '../core/storage/local_storage_service.dart';
import '../core/services/gemini_service.dart';
import '../models/crop.dart';
import '../models/crop_recommendation.dart';
import '../models/saved_item.dart';
import '../core/services/backend_api_service.dart';

class CropProvider extends ChangeNotifier {
  final LocalStorageService _storage = LocalStorageService();
  final GeminiService _gemini = GeminiService();

  List<Crop> _crops = [];
  final bool _isLoading = false;
  String? _errorMessage;

  // Recommendations state
  List<CropRecommendation> _recommendations = [];
  bool _isGeneratingRecommendations = false;

  List<Crop> get crops => _crops;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<CropRecommendation> get recommendations => _recommendations;
  bool get isGeneratingRecommendations => _isGeneratingRecommendations;

  CropProvider() {
    loadCrops();
  }

  void loadCrops() {
    _crops = _storage.getCrops();
    notifyListeners();
  }

  // --- CRUD OPERATIONS ---
  Future<void> addCrop({
    required String name,
    required String variety,
    required DateTime plantingDate,
    required DateTime expectedHarvestDate,
    required double landAreaAcres,
    required String soilType,
    required String waterSource,
    required String stage,
    String notes = '',
  }) async {
    final newCrop = Crop(
      id: 'crop_${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      variety: variety.trim(),
      plantingDate: plantingDate,
      expectedHarvestDate: expectedHarvestDate,
      landAreaAcres: landAreaAcres,
      soilType: soilType,
      waterSource: waterSource,
      stage: stage,
      notes: notes.trim(),
    );

    await _storage.addCrop(newCrop);
    _crops = _storage.getCrops();
    notifyListeners();

    // Asynchronously synchronize with Java Spring Boot backend
    BackendApiService().syncCrop(newCrop).catchError((_) {});
  }

  Future<void> updateCrop(Crop crop) async {
    await _storage.updateCrop(crop);
    _crops = _storage.getCrops();
    notifyListeners();

    // Asynchronously synchronize with Java Spring Boot backend
    BackendApiService().syncCrop(crop).catchError((_) {});
  }

  Future<void> deleteCrop(String id) async {
    await _storage.deleteCrop(id);
    _crops = _storage.getCrops();
    notifyListeners();
  }

  Crop? getCropById(String id) {
    try {
      return _crops.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  // --- GENERATE CROP RECOMMENDATIONS ---
  Future<bool> generateCropRecommendations({
    required String state,
    required String district,
    required String season,
    required String soilType,
    required double landSizeAcres,
    required String waterAvailability,
    String? previousCrop,
    String? currentTemperature,
    String? rainfallForecast,
    String langCode = 'en',
  }) async {
    _isGeneratingRecommendations = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final recs = await _gemini.getCropRecommendations(
        state: state,
        district: district,
        season: season,
        soilType: soilType,
        landSizeAcres: landSizeAcres,
        waterAvailability: waterAvailability,
        previousCrop: previousCrop,
        currentTemperature: currentTemperature,
        rainfallForecast: rainfallForecast,
        langCode: langCode,
      );

      _recommendations = recs;
      _isGeneratingRecommendations = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to generate recommendations: $e';
      _isGeneratingRecommendations = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> saveRecommendation(CropRecommendation rec) async {
    final item = SavedItem(
      id: 'saved_rec_${rec.id}',
      title: 'Recommendation: ${rec.cropName} (${rec.variety})',
      subtitle: '${rec.suitableSeason} - ${rec.expectedDuration}',
      category: 'crop_recommendation',
      content: '''
**Why Recommended:** ${rec.whyRecommended}
**Season:** ${rec.suitableSeason}
**Water Requirement:** ${rec.waterRequirement}
**Duration:** ${rec.expectedDuration}
**Cultivation Tips:** ${rec.basicCultivationTips}
**Economic Prospects:** ${rec.economicProspects}
''',
    );
    await _storage.saveItem(item);
  }
}
