import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../core/storage/local_storage_service.dart';
import '../core/services/gemini_service.dart';
import '../core/utils/camera_helper.dart';
import '../models/disease_analysis.dart';
import '../models/farmer_profile.dart';
import '../models/saved_item.dart';

class DiseaseProvider extends ChangeNotifier {
  final LocalStorageService _storage = LocalStorageService();
  final GeminiService _gemini = GeminiService();
  final ImagePicker _picker = ImagePicker();

  XFile? _selectedMedia;
  Uint8List? _selectedMediaBytes;
  int? _selectedMediaSize;
  String? _selectedMediaName;
  bool _isVideo = false;
  bool _isAnalyzing = false;
  String? _errorMessage;
  DiseaseAnalysis? _latestResult;
  List<DiseaseAnalysis> _history = [];

  XFile? get selectedMedia => _selectedMedia;
  Uint8List? get selectedMediaBytes => _selectedMediaBytes;
  int? get selectedMediaSize => _selectedMediaSize;
  String? get selectedMediaName => _selectedMediaName;
  bool get isVideo => _isVideo;
  bool get isAnalyzing => _isAnalyzing;
  String? get errorMessage => _errorMessage;
  DiseaseAnalysis? get latestResult => _latestResult;
  List<DiseaseAnalysis> get history => _history;

  DiseaseProvider() {
    loadHistory();
  }

  void loadHistory() {
    _history = _storage.getDiseaseHistory();
    notifyListeners();
  }

  // --- PICK MEDIA (IMAGE / VIDEO) ---
  Future<void> pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 1280,
        maxHeight: 1280,
        imageQuality: 85,
      );
      if (picked != null) {
        _selectedMedia = picked;
        _selectedMediaBytes = await picked.readAsBytes();
        _selectedMediaSize = await picked.length();
        _selectedMediaName = picked.name;
        _isVideo = false;
        _errorMessage = null;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Could not select image: $e';
      notifyListeners();
    }
  }

  void setSelectedCapturedMedia(CapturedMedia captured) {
    _selectedMedia = XFile.fromData(
      captured.bytes,
      name: captured.name,
      path: captured.path,
      length: captured.size,
    );
    _selectedMediaBytes = captured.bytes;
    _selectedMediaSize = captured.size;
    _selectedMediaName = captured.name;
    _isVideo = false;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> pickVideo(ImageSource source) async {
    try {
      final picked = await _picker.pickVideo(
        source: source,
        maxDuration: const Duration(seconds: 30),
      );
      if (picked != null) {
        // Cross-platform size check without dart:io File
        final sizeBytes = await picked.length();
        if (sizeBytes > 15 * 1024 * 1024) {
          _errorMessage = 'Video file exceeds 15MB limit. Please select a shorter clip (under 15s) for AI analysis.';
          notifyListeners();
          return;
        }

        _selectedMedia = picked;
        _selectedMediaBytes = await picked.readAsBytes();
        _selectedMediaSize = sizeBytes;
        _selectedMediaName = picked.name;
        _isVideo = true;
        _errorMessage = null;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Could not select video: $e';
      notifyListeners();
    }
  }

  void clearSelectedMedia() {
    _selectedMedia = null;
    _selectedMediaBytes = null;
    _selectedMediaSize = null;
    _selectedMediaName = null;
    _isVideo = false;
    _errorMessage = null;
    notifyListeners();
  }

  // --- RUN ANALYSIS ---
  Future<bool> analyzeCropDisease({
    required String cropName,
    required String description,
    FarmerProfile? profile,
    String langCode = 'en',
  }) async {
    // Validate image or description
    if (_selectedMedia == null && description.trim().isEmpty) {
      _errorMessage = 'Please provide either a photo/video or describe the crop symptoms.';
      notifyListeners();
      return false;
    }

    _isAnalyzing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _gemini.analyzeDisease(
        cropName: cropName.trim().isNotEmpty
            ? cropName.trim()
            : ((profile?.mainCrop.isNotEmpty == true) ? profile!.mainCrop : 'Crop / Plant'),
        userDescription: description.trim().isEmpty
            ? (_isVideo ? 'Video showing leaf wilting and discoloration' : 'Crop leaf symptoms inspection')
            : description.trim(),
        imagePath: _selectedMedia?.path,
        mediaBytes: _selectedMediaBytes,
        isVideo: _isVideo,
        profile: profile,
        langCode: langCode,
      );

      // Attach bytes to analysis model for cross-platform rendering
      final completeResult = DiseaseAnalysis(
        id: result.id,
        cropName: result.cropName,
        possibleIssue: result.possibleIssue,
        confidenceScore: result.confidenceScore,
        observedSymptoms: result.observedSymptoms,
        possibleCauses: result.possibleCauses,
        recommendedAction: result.recommendedAction,
        prevention: result.prevention,
        whenToSeekExpert: result.whenToSeekExpert,
        imagePath: result.imagePath,
        imageBytes: _isVideo ? null : _selectedMediaBytes,
        isVideoAnalysis: _isVideo,
        date: result.date,
      );

      _latestResult = completeResult;
      await _storage.saveDiseaseAnalysis(completeResult);
      _history = _storage.getDiseaseHistory();
      _isAnalyzing = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Analysis failed: $e';
      _isAnalyzing = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> saveResultToSavedItems(DiseaseAnalysis analysis) async {
    final item = SavedItem(
      id: 'saved_disease_${analysis.id}',
      title: '${analysis.cropName}: ${analysis.possibleIssue}',
      subtitle: 'Confidence: ${analysis.confidenceScore}% - ${analysis.observedSymptoms}',
      category: 'disease_report',
      content: '''
**Crop:** ${analysis.cropName}
**Possible Issue:** ${analysis.possibleIssue} (AI Confidence: ${analysis.confidenceScore}%)
**Observed Symptoms:** ${analysis.observedSymptoms}
**Possible Causes:** ${analysis.possibleCauses}
**Recommended Action:** ${analysis.recommendedAction}
**Prevention:** ${analysis.prevention}
**When to Seek Expert Help:** ${analysis.whenToSeekExpert}
''',
      metadata: {'imagePath': analysis.imagePath},
    );
    await _storage.saveItem(item);
  }

  Future<void> deleteHistoryItem(String id) async {
    await _storage.deleteDiseaseAnalysis(id);
    _history = _storage.getDiseaseHistory();
    notifyListeners();
  }
}
