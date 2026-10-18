import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../../models/farmer_profile.dart';
import '../../models/disease_analysis.dart';
import '../../models/crop.dart';

/// BackendApiService - Connects Flutter mobile client to the Java Spring Boot Backend.
/// Features automatic health detection and graceful fallback.
class BackendApiService {
  static final BackendApiService _instance = BackendApiService._internal();
  factory BackendApiService() => _instance;
  BackendApiService._internal();

  bool? _isBackendAvailable;
  DateTime? _lastHealthCheck;

  String get _baseUrl {
    if (kIsWeb) {
      return ApiConstants.springBootBaseUrl;
    }
    // If running on Android emulator, use 10.0.2.2; on desktop/web use localhost
    if (defaultTargetPlatform == TargetPlatform.android) {
      return ApiConstants.springBootAndroidUrl;
    }
    return ApiConstants.springBootBaseUrl;
  }

  /// Checks if the Java Spring Boot server is running on port 8080
  Future<bool> isBackendAvailable() async {
    final now = DateTime.now();
    if (_isBackendAvailable != null &&
        _lastHealthCheck != null &&
        now.difference(_lastHealthCheck!) < const Duration(seconds: 15)) {
      return _isBackendAvailable!;
    }

    try {
      final res = await http
          .get(Uri.parse('$_baseUrl/health'))
          .timeout(const Duration(milliseconds: 1500));
      _isBackendAvailable = res.statusCode == 200;
    } catch (_) {
      _isBackendAvailable = false;
    }
    _lastHealthCheck = now;
    return _isBackendAvailable!;
  }

  /// Calls Java Spring Boot /api/ai/chat endpoint
  Future<String?> askBackend({
    required String prompt,
    String langCode = 'en',
    List<int>? mediaBytes,
    String? mediaMime,
    bool isVideo = false,
    FarmerProfile? profile,
  }) async {
    try {
      final available = await isBackendAvailable();
      if (!available) return null;

      final body = {
        'prompt': prompt,
        'langCode': langCode,
        'mediaBase64': mediaBytes != null && mediaBytes.isNotEmpty ? base64Encode(mediaBytes) : null,
        'mediaMimeType': mediaMime,
        'isVideo': isVideo,
      };

      final response = await http
          .post(
            Uri.parse('$_baseUrl/ai/chat'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(body),
          )
          .timeout(const Duration(seconds: 35));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final reply = data['response'] as String?;
        if (reply != null && reply.trim().isNotEmpty) {
          return reply.trim();
        }
      }
    } catch (e) {
      debugPrint('Java Spring Boot chat call error: $e');
    }
    return null;
  }

  /// Calls Java Spring Boot /api/ai/diagnose endpoint
  Future<DiseaseAnalysis?> diagnoseBackend({
    required String cropName,
    required String description,
    List<int>? mediaBytes,
    String? mediaMime,
    bool isVideo = false,
    String langCode = 'en',
    FarmerProfile? profile,
  }) async {
    try {
      final available = await isBackendAvailable();
      if (!available) return null;

      final body = {
        'cropName': cropName,
        'description': description,
        'mediaBase64': mediaBytes != null && mediaBytes.isNotEmpty ? base64Encode(mediaBytes) : null,
        'mediaMimeType': mediaMime,
        'isVideo': isVideo,
        'langCode': langCode,
      };

      final response = await http
          .post(
            Uri.parse('$_baseUrl/ai/diagnose'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(body),
          )
          .timeout(const Duration(seconds: 35));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return DiseaseAnalysis(
          id: 'backend_${data['id'] ?? DateTime.now().millisecondsSinceEpoch}',
          cropName: data['cropName'] ?? cropName,
          possibleIssue: data['possibleIssue'] ?? 'Foliar Health Issue',
          confidenceScore: (data['confidenceScore'] is num) ? (data['confidenceScore'] as num).toInt() : 84,
          observedSymptoms: data['observedSymptoms'] ?? description,
          possibleCauses: data['possibleCauses'] ?? 'Pathogenic or environmental stress',
          recommendedAction: data['recommendedAction'] ?? 'Consult local agricultural extension officer.',
          prevention: data['prevention'] ?? 'Maintain proper sanitation and crop hygiene.',
          whenToSeekExpert: data['whenToSeekExpert'] ?? 'If lesions spread within 3 days.',
          isVideoAnalysis: isVideo,
        );
      }
    } catch (e) {
      debugPrint('Java Spring Boot diagnose call error: $e');
    }
    return null;
  }

  /// Synchronizes a crop record to Java Spring Boot H2 database
  Future<void> syncCrop(Crop crop) async {
    try {
      final available = await isBackendAvailable();
      if (!available) return;

      final body = {
        'name': crop.name,
        'variety': crop.variety,
        'plantingDate': crop.plantingDate.toIso8601String().substring(0, 10),
        'expectedHarvestDate': crop.expectedHarvestDate.toIso8601String().substring(0, 10),
        'landAreaAcres': crop.landAreaAcres,
        'soilType': crop.soilType,
        'waterSource': crop.waterSource,
        'stage': crop.stage,
        'notes': crop.notes,
      };

      await http
          .post(
            Uri.parse('$_baseUrl/crops'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(body),
          )
          .timeout(const Duration(seconds: 5));
    } catch (_) {}
  }

  /// Synchronizes farmer profile to Java Spring Boot H2 database
  Future<void> syncFarmer(FarmerProfile profile) async {
    try {
      final available = await isBackendAvailable();
      if (!available) return;

      final body = {
        'fullName': profile.fullName,
        'phoneNumber': profile.mobileNumber,
        'email': profile.email,
        'state': profile.state,
        'district': profile.district,
        'city': profile.city,
        'mainCrop': profile.mainCrop,
        'landSizeAcres': profile.landSizeAcres,
        'soilType': profile.soilType,
        'waterAvailability': profile.waterAvailability,
        'preferredLanguage': profile.preferredLanguage,
      };

      await http
          .post(
            Uri.parse('$_baseUrl/farmers'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(body),
          )
          .timeout(const Duration(seconds: 5));
    } catch (_) {}
  }
}
