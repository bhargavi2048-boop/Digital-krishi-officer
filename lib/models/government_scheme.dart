import 'dart:convert';

class GovernmentScheme {
  final String id;
  final String name;
  final String category; // 'Income Support', 'Insurance', 'Credit', 'Irrigation', 'Machinery', 'Organic'
  final String shortDescription;
  final String detailedDescription;
  final List<String> eligibility;
  final List<String> benefits;
  final List<String> requiredDocuments;
  final List<String> applicationProcess;
  final String officialSource;
  final String officialUrl;
  final String lastUpdated;

  GovernmentScheme({
    required this.id,
    required this.name,
    required this.category,
    required this.shortDescription,
    required this.detailedDescription,
    required this.eligibility,
    required this.benefits,
    required this.requiredDocuments,
    required this.applicationProcess,
    required this.officialSource,
    required this.officialUrl,
    required this.lastUpdated,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'shortDescription': shortDescription,
      'detailedDescription': detailedDescription,
      'eligibility': eligibility,
      'benefits': benefits,
      'requiredDocuments': requiredDocuments,
      'applicationProcess': applicationProcess,
      'officialSource': officialSource,
      'officialUrl': officialUrl,
      'lastUpdated': lastUpdated,
    };
  }

  factory GovernmentScheme.fromMap(Map<String, dynamic> map) {
    return GovernmentScheme(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? 'General',
      shortDescription: map['shortDescription'] ?? '',
      detailedDescription: map['detailedDescription'] ?? '',
      eligibility: List<String>.from(map['eligibility'] ?? []),
      benefits: List<String>.from(map['benefits'] ?? []),
      requiredDocuments: List<String>.from(map['requiredDocuments'] ?? []),
      applicationProcess: List<String>.from(map['applicationProcess'] ?? []),
      officialSource: map['officialSource'] ?? 'Ministry of Agriculture & Farmers Welfare',
      officialUrl: map['officialUrl'] ?? 'https://agricoop.nic.in',
      lastUpdated: map['lastUpdated'] ?? '2025-2026',
    );
  }

  String toJson() => json.encode(toMap());

  factory GovernmentScheme.fromJson(String source) => GovernmentScheme.fromMap(json.decode(source));
}
