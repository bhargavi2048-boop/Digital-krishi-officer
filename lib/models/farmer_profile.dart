import 'dart:convert';

class FarmerProfile {
  final String id;
  final String fullName;
  final String mobileNumber;
  final String email;
  final String passwordHash;
  final String city;
  final String district;
  final String state;
  final String preferredLanguage; // 'en', 'ta', 'hi', 'te', 'kn', 'ml'
  final String mainCrop;
  final String otherCrops;
  final double landSizeAcres;
  final String soilType;
  final String waterAvailability;
  final DateTime createdAt;

  FarmerProfile({
    required this.id,
    required this.fullName,
    required this.mobileNumber,
    required this.email,
    required this.passwordHash,
    required this.city,
    required this.district,
    required this.state,
    this.preferredLanguage = 'en',
    this.mainCrop = 'Paddy (Rice)',
    this.otherCrops = '',
    this.landSizeAcres = 2.5,
    this.soilType = 'Alluvial Soil',
    this.waterAvailability = 'Canal Irrigation',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory FarmerProfile.empty() => FarmerProfile(
    id: '',
    fullName: '',
    mobileNumber: '',
    email: '',
    passwordHash: '',
    city: '',
    district: '',
    state: '',
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'mobileNumber': mobileNumber,
      'email': email,
      'passwordHash': passwordHash,
      'city': city,
      'district': district,
      'state': state,
      'preferredLanguage': preferredLanguage,
      'mainCrop': mainCrop,
      'otherCrops': otherCrops,
      'landSizeAcres': landSizeAcres,
      'soilType': soilType,
      'waterAvailability': waterAvailability,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory FarmerProfile.fromMap(Map<String, dynamic> map) {
    return FarmerProfile(
      id: map['id'] ?? '',
      fullName: map['fullName'] ?? '',
      mobileNumber: map['mobileNumber'] ?? '',
      email: map['email'] ?? '',
      passwordHash: map['passwordHash'] ?? '',
      city: map['city'] ?? '',
      district: map['district'] ?? '',
      state: map['state'] ?? '',
      preferredLanguage: map['preferredLanguage'] ?? 'en',
      mainCrop: map['mainCrop'] ?? 'Paddy (Rice)',
      otherCrops: map['otherCrops'] ?? '',
      landSizeAcres: (map['landSizeAcres'] is num) ? (map['landSizeAcres'] as num).toDouble() : 2.5,
      soilType: map['soilType'] ?? 'Alluvial Soil',
      waterAvailability: map['waterAvailability'] ?? 'Canal Irrigation',
      createdAt: map['createdAt'] != null ? DateTime.tryParse(map['createdAt']) ?? DateTime.now() : DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory FarmerProfile.fromJson(String source) => FarmerProfile.fromMap(json.decode(source));

  FarmerProfile copyWith({
    String? id,
    String? fullName,
    String? mobileNumber,
    String? email,
    String? passwordHash,
    String? city,
    String? district,
    String? state,
    String? preferredLanguage,
    String? mainCrop,
    String? otherCrops,
    double? landSizeAcres,
    String? soilType,
    String? waterAvailability,
    DateTime? createdAt,
  }) {
    return FarmerProfile(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      city: city ?? this.city,
      district: district ?? this.district,
      state: state ?? this.state,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      mainCrop: mainCrop ?? this.mainCrop,
      otherCrops: otherCrops ?? this.otherCrops,
      landSizeAcres: landSizeAcres ?? this.landSizeAcres,
      soilType: soilType ?? this.soilType,
      waterAvailability: waterAvailability ?? this.waterAvailability,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
