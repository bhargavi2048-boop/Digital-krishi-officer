class AppConstants {
  static const String appName = 'Digital Krishi Officer';
  static const String appTagline = 'Your AI-Powered Agricultural Assistant';
  static const String appVersion = '1.0.0';

  // Supported Languages
  static const List<Map<String, String>> supportedLanguages = [
    {'code': 'en', 'name': 'English', 'native': 'English', 'flag': '🇮🇳'},
    {'code': 'ta', 'name': 'Tamil', 'native': 'தமிழ்', 'flag': '🌾'},
    {'code': 'hi', 'name': 'Hindi', 'native': 'हिन्दी', 'flag': '🇮🇳'},
    {'code': 'te', 'name': 'Telugu', 'native': 'తెలుగు', 'flag': '🇮🇳'},
    {'code': 'kn', 'name': 'Kannada', 'native': 'ಕನ್ನಡ', 'flag': '🇮🇳'},
    {'code': 'ml', 'name': 'Malayalam', 'native': 'മലയാളം', 'flag': '🌴'},
  ];

  // Common Indian Agricultural States
  static const List<String> indianStates = [
    'Tamil Nadu',
    'Andhra Pradesh',
    'Telangana',
    'Karnataka',
    'Kerala',
    'Maharashtra',
    'Punjab',
    'Haryana',
    'Uttar Pradesh',
    'Madhya Pradesh',
    'Gujarat',
    'Rajasthan',
    'West Bengal',
    'Odisha',
    'Bihar',
    'Assam',
  ];

  // Soil Types
  static const List<String> soilTypes = [
    'Alluvial Soil',
    'Black (Regur) Soil',
    'Red Soil',
    'Laterite Soil',
    'Clay Soil',
    'Sandy Loam Soil',
    'Loamy Soil',
    'Peaty / Marshy Soil',
  ];

  // Water Availability Sources
  static const List<String> waterSources = [
    'Canal Irrigation',
    'Borewell / Tube Well',
    'Open Well',
    'Drip Irrigation',
    'Sprinkler Irrigation',
    'Rainfed / Natural Rainfall',
    'River / Lake Lift Irrigation',
  ];

  // Sowing Seasons
  static const List<String> seasons = [
    'Kharif (Monsoon: Jun - Oct)',
    'Rabi (Winter: Oct - Mar)',
    'Zaid (Summer: Mar - Jun)',
    'Year-Round (Perennial)',
  ];

  // Common Crops
  static const List<String> commonCrops = [
    'Paddy (Rice)',
    'Wheat',
    'Tomato',
    'Cotton',
    'Sugarcane',
    'Maize (Corn)',
    'Chilli',
    'Onion',
    'Groundnut',
    'Banana',
    'Turmeric',
    'Soybean',
    'Potato',
    'Mustard',
    'Pulses (Gram/Toor)',
  ];

  // National Kisan Call Center helpline
  static const String kisanCallCenterNumber = '1800-180-1551';
  static const String kisanPortalUrl = 'https://mkisan.gov.in';
  static const String icarPortalUrl = 'https://icar.org.in';
}
