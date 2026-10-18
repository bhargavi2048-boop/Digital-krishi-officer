import 'dart:convert';

class CropRecommendation {
  final String id;
  final String cropName;
  final String variety;
  final String whyRecommended;
  final String suitableSeason;
  final String waterRequirement;
  final String expectedDuration;
  final String basicCultivationTips;
  final String economicProspects;

  CropRecommendation({
    required this.id,
    required this.cropName,
    required this.variety,
    required this.whyRecommended,
    required this.suitableSeason,
    required this.waterRequirement,
    required this.expectedDuration,
    required this.basicCultivationTips,
    this.economicProspects = 'Moderate to high market demand',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cropName': cropName,
      'variety': variety,
      'whyRecommended': whyRecommended,
      'suitableSeason': suitableSeason,
      'waterRequirement': waterRequirement,
      'expectedDuration': expectedDuration,
      'basicCultivationTips': basicCultivationTips,
      'economicProspects': economicProspects,
    };
  }

  factory CropRecommendation.fromMap(Map<String, dynamic> map) {
    return CropRecommendation(
      id: map['id'] ?? '',
      cropName: map['cropName'] ?? '',
      variety: map['variety'] ?? 'Standard High-Yielding Variety',
      whyRecommended: map['whyRecommended'] ?? '',
      suitableSeason: map['suitableSeason'] ?? '',
      waterRequirement: map['waterRequirement'] ?? '',
      expectedDuration: map['expectedDuration'] ?? '',
      basicCultivationTips: map['basicCultivationTips'] ?? '',
      economicProspects: map['economicProspects'] ?? 'Good return on investment',
    );
  }

  String toJson() => json.encode(toMap());

  factory CropRecommendation.fromJson(String source) => CropRecommendation.fromMap(json.decode(source));
}
