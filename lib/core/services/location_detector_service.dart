import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../constants/location_data.dart';

class DetectedLocation {
  final String city;
  final String district;
  final String state;
  final double? latitude;
  final double? longitude;

  DetectedLocation({
    required this.city,
    required this.district,
    required this.state,
    this.latitude,
    this.longitude,
  });
}

class LocationDetectorService {
  static final LocationDetectorService _instance = LocationDetectorService._internal();
  factory LocationDetectorService() => _instance;
  LocationDetectorService._internal();

  /// Attempts to detect user's current city, district and state via IP/Network geocoding
  Future<DetectedLocation?> detectCurrentLocation() async {
    try {
      // 1. Try BigDataCloud free client reverse geocoding
      final uri = Uri.parse('https://api.bigdatacloud.net/data/reverse-geocode-client');
      final res = await http.get(uri).timeout(const Duration(seconds: 4));
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        final city = (data['city'] ?? data['locality'] ?? '').toString().trim();
        final district = (data['localityInfo']?['administrative'] != null
                ? _findDistrict(data['localityInfo']['administrative'])
                : null) ??
            city;
        final state = (data['principalSubdivision'] ?? 'Tamil Nadu').toString().trim();
        final lat = (data['latitude'] is num) ? (data['latitude'] as num).toDouble() : null;
        final lon = (data['longitude'] is num) ? (data['longitude'] as num).toDouble() : null;

        if (city.isNotEmpty || district.isNotEmpty) {
          return _normalizeDetectedLocation(
            city: city.isNotEmpty ? city : district,
            district: district.isNotEmpty ? district : city,
            state: state,
            lat: lat,
            lon: lon,
          );
        }
      }
    } catch (e) {
      debugPrint('Primary location detection fallback: $e');
    }

    try {
      // 2. Fallback to ip-api.com
      final uri = Uri.parse('http://ip-api.com/json');
      final res = await http.get(uri).timeout(const Duration(seconds: 4));
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        if (data['status'] == 'success') {
          final city = (data['city'] ?? '').toString().trim();
          final regionName = (data['regionName'] ?? 'Tamil Nadu').toString().trim();
          final lat = (data['lat'] is num) ? (data['lat'] as num).toDouble() : null;
          final lon = (data['lon'] is num) ? (data['lon'] as num).toDouble() : null;

          return _normalizeDetectedLocation(
            city: city,
            district: city,
            state: regionName,
            lat: lat,
            lon: lon,
          );
        }
      }
    } catch (e) {
      debugPrint('Secondary location detection error: $e');
    }

    // Default return Chennai if in India / default demo location
    return DetectedLocation(
      city: 'Chennai',
      district: 'Chennai',
      state: 'Tamil Nadu',
      latitude: 13.0827,
      longitude: 80.2707,
    );
  }

  static String? _findDistrict(dynamic adminList) {
    if (adminList is List) {
      for (final item in adminList) {
        final desc = item['description']?.toString().toLowerCase() ?? '';
        final name = item['name']?.toString() ?? '';
        if (desc.contains('district') || desc.contains('county')) {
          return name.replaceAll(RegExp(r'\s+district', caseSensitive: false), '').trim();
        }
      }
    }
    return null;
  }

  static DetectedLocation _normalizeDetectedLocation({
    required String city,
    required String district,
    required String state,
    double? lat,
    double? lon,
  }) {
    // Match against known states
    String matchedState = 'Tamil Nadu';
    for (final s in LocationData.stateDistricts.keys) {
      if (state.toLowerCase().contains(s.toLowerCase())) {
        matchedState = s;
        break;
      }
    }

    // Match against known districts
    final availableDistricts = LocationData.getDistrictsForState(matchedState);
    String matchedDistrict = availableDistricts.first;
    for (final d in availableDistricts) {
      if (district.toLowerCase().contains(d.toLowerCase()) || city.toLowerCase().contains(d.toLowerCase())) {
        matchedDistrict = d;
        break;
      }
    }

    final matchedCity = city.isNotEmpty ? city : matchedDistrict;

    return DetectedLocation(
      city: matchedCity,
      district: matchedDistrict,
      state: matchedState,
      latitude: lat,
      longitude: lon,
    );
  }
}
