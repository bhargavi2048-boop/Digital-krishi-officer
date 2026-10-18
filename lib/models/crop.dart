import 'dart:convert';

class Crop {
  final String id;
  final String name;
  final String variety;
  final DateTime plantingDate;
  final DateTime expectedHarvestDate;
  final double landAreaAcres;
  final String soilType;
  final String waterSource;
  final String notes;
  final String stage; // 'Sown', 'Vegetative', 'Flowering', 'Harvesting', 'Completed'

  Crop({
    required this.id,
    required this.name,
    required this.variety,
    required this.plantingDate,
    required this.expectedHarvestDate,
    this.landAreaAcres = 1.0,
    this.soilType = 'Alluvial Soil',
    this.waterSource = 'Borewell',
    this.notes = '',
    this.stage = 'Vegetative',
  });

  int get daysRemaining {
    final now = DateTime.now();
    if (expectedHarvestDate.isBefore(now)) return 0;
    return expectedHarvestDate.difference(now).inDays;
  }

  int get daysSincePlanting {
    final now = DateTime.now();
    return now.difference(plantingDate).inDays;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'variety': variety,
      'plantingDate': plantingDate.toIso8601String(),
      'expectedHarvestDate': expectedHarvestDate.toIso8601String(),
      'landAreaAcres': landAreaAcres,
      'soilType': soilType,
      'waterSource': waterSource,
      'notes': notes,
      'stage': stage,
    };
  }

  factory Crop.fromMap(Map<String, dynamic> map) {
    return Crop(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      variety: map['variety'] ?? '',
      plantingDate: map['plantingDate'] != null ? DateTime.tryParse(map['plantingDate']) ?? DateTime.now() : DateTime.now(),
      expectedHarvestDate: map['expectedHarvestDate'] != null ? DateTime.tryParse(map['expectedHarvestDate']) ?? DateTime.now().add(const Duration(days: 90)) : DateTime.now().add(const Duration(days: 90)),
      landAreaAcres: (map['landAreaAcres'] is num) ? (map['landAreaAcres'] as num).toDouble() : 1.0,
      soilType: map['soilType'] ?? 'Alluvial Soil',
      waterSource: map['waterSource'] ?? 'Borewell',
      notes: map['notes'] ?? '',
      stage: map['stage'] ?? 'Vegetative',
    );
  }

  String toJson() => json.encode(toMap());

  factory Crop.fromJson(String source) => Crop.fromMap(json.decode(source));

  Crop copyWith({
    String? id,
    String? name,
    String? variety,
    DateTime? plantingDate,
    DateTime? expectedHarvestDate,
    double? landAreaAcres,
    String? soilType,
    String? waterSource,
    String? notes,
    String? stage,
  }) {
    return Crop(
      id: id ?? this.id,
      name: name ?? this.name,
      variety: variety ?? this.variety,
      plantingDate: plantingDate ?? this.plantingDate,
      expectedHarvestDate: expectedHarvestDate ?? this.expectedHarvestDate,
      landAreaAcres: landAreaAcres ?? this.landAreaAcres,
      soilType: soilType ?? this.soilType,
      waterSource: waterSource ?? this.waterSource,
      notes: notes ?? this.notes,
      stage: stage ?? this.stage,
    );
  }
}
