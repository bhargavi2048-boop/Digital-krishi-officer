class ApiConstants {
  // Google Gemini API Base
  static const String geminiBaseUrl = 'https://generativelanguage.googleapis.com/v1beta/models';
  static const String defaultGeminiModel = 'gemini-flash-lite-latest';

  // Java Spring Boot Backend Base URL
  static const String springBootBaseUrl = 'http://localhost:8080/api';
  static const String springBootAndroidUrl = 'http://10.0.2.2:8080/api';

  // Open-Meteo Weather Base (Free, no API key required, reliable for Indian coordinates)
  static const String openMeteoForecastUrl = 'https://api.open-meteo.com/v1/forecast';
  static const String openMeteoGeocodingUrl = 'https://geocoding-api.open-meteo.com/v1/search';

  // OpenWeatherMap API Base (Alternative if user configures WEATHER_API_KEY in .env)
  static const String openWeatherMapBaseUrl = 'https://api.openweathermap.org/data/2.5';

  // Timeout settings
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
