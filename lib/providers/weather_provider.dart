import 'package:flutter/material.dart';
import '../core/services/weather_service.dart';
import '../core/storage/local_storage_service.dart';
import '../models/weather_data.dart';
import '../models/farmer_profile.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final LocalStorageService _storage = LocalStorageService();

  WeatherData? _weatherData;
  bool _isLoading = false;
  String? _errorMessage;
  String _currentLocationName = 'Thanjavur, Tamil Nadu';

  WeatherData? get weatherData => _weatherData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get currentLocationName => _currentLocationName;

  WeatherProvider() {
    final storedUser = _storage.getUser();
    loadWeather(profile: storedUser);
  }

  Future<void> loadWeather({FarmerProfile? profile, double? latitude, double? longitude}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final activeProfile = profile ?? _storage.getUser();
    if (activeProfile != null) {
      final city = activeProfile.city.trim();
      final district = activeProfile.district.trim();
      final state = activeProfile.state.trim();

      if (city.isNotEmpty && district.isNotEmpty && city.toLowerCase() != district.toLowerCase()) {
        _currentLocationName = '$city, $district';
      } else if (district.isNotEmpty) {
        _currentLocationName = '$district, $state';
      } else if (city.isNotEmpty) {
        _currentLocationName = '$city, $state';
      }
    }

    try {
      final data = await _weatherService.fetchWeather(
        locationName: _currentLocationName,
        cropName: activeProfile?.mainCrop ?? 'Paddy',
        latitude: latitude,
        longitude: longitude,
      );
      _weatherData = data;

      // Automatically generate weather-driven alerts if severe conditions exist
      final alerts = _weatherService.generateWeatherAlerts(data, profile?.mainCrop ?? 'Paddy');
      for (final alert in alerts) {
        await _storage.saveAlert(alert);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Could not load weather: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> changeLocation(String newLocation, {String cropName = 'Paddy'}) async {
    _currentLocationName = newLocation;
    await loadWeather();
  }

  Future<void> updateCurrentCoordinates(double lat, double lon, String detectedPlace) async {
    _currentLocationName = detectedPlace;
    await loadWeather(latitude: lat, longitude: lon);
  }
}
