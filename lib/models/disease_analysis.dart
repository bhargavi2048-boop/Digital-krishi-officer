import 'dart:convert';
import 'dart:typed_data';

class DiseaseAnalysis {
  final String id;
  final String cropName;
  final String possibleIssue;
  final int confidenceScore; // 0 - 100 (Never 100%)
  final String observedSymptoms;
  final String possibleCauses;
  final String recommendedAction;
  final String prevention;
  final String whenToSeekExpert;
  final String? imagePath;
  final Uint8List? imageBytes;
  final bool isVideoAnalysis;
  final DateTime date;

  DiseaseAnalysis({
    required this.id,
    required this.cropName,
    required this.possibleIssue,
    required this.confidenceScore,
    required this.observedSymptoms,
    required this.possibleCauses,
    required this.recommendedAction,
    required this.prevention,
    required this.whenToSeekExpert,
    this.imagePath,
    this.imageBytes,
    this.isVideoAnalysis = false,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  bool get isHighConfidence => confidenceScore >= 75;
  bool get requiresExpertEscalation => confidenceScore < 70;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cropName': cropName,
      'possibleIssue': possibleIssue,
      'confidenceScore': confidenceScore,
      'observedSymptoms': observedSymptoms,
      'possibleCauses': possibleCauses,
      'recommendedAction': recommendedAction,
      'prevention': prevention,
      'whenToSeekExpert': whenToSeekExpert,
      'imagePath': imagePath,
      'imageBase64': imageBytes != null ? base64Encode(imageBytes!) : null,
      'isVideoAnalysis': isVideoAnalysis,
      'date': date.toIso8601String(),
    };
  }

  factory DiseaseAnalysis.fromMap(Map<String, dynamic> map) {
    Uint8List? bytes;
    if (map['imageBase64'] != null && (map['imageBase64'] as String).isNotEmpty) {
      try {
        bytes = base64Decode(map['imageBase64']);
      } catch (_) {}
    }

    return DiseaseAnalysis(
      id: map['id'] ?? '',
      cropName: map['cropName'] ?? 'Crop',
      possibleIssue: map['possibleIssue'] ?? 'Unidentified Condition',
      confidenceScore: (map['confidenceScore'] is int) ? map['confidenceScore'] : 70,
      observedSymptoms: map['observedSymptoms'] ?? '',
      possibleCauses: map['possibleCauses'] ?? '',
      recommendedAction: map['recommendedAction'] ?? '',
      prevention: map['prevention'] ?? '',
      whenToSeekExpert: map['whenToSeekExpert'] ?? '',
      imagePath: map['imagePath'],
      imageBytes: bytes,
      isVideoAnalysis: map['isVideoAnalysis'] ?? false,
      date: map['date'] != null ? DateTime.tryParse(map['date']) ?? DateTime.now() : DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory DiseaseAnalysis.fromJson(String source) => DiseaseAnalysis.fromMap(json.decode(source));
}
