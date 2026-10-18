import 'package:flutter/material.dart';
import '../features/splash/splash_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/language/language_selection_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/home/main_navigation_screen.dart';
import '../features/disease_detection/disease_detection_screen.dart';
import '../features/crop_recommendation/crop_recommendation_screen.dart';
import '../features/weather/weather_detail_screen.dart';
import '../features/crops/add_edit_crop_screen.dart';
import '../features/crops/crop_detail_screen.dart';
import '../features/alerts/alerts_screen.dart';
import '../features/saved/saved_items_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/mandi/mandi_prices_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String languageSelect = '/language_select';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String aiChat = '/ai_chat';
  static const String diseaseDetection = '/disease_detection';
  static const String cropRecommendation = '/crop_recommendation';
  static const String weatherDetail = '/weather_detail';
  static const String schemes = '/schemes';
  static const String myCrops = '/my_crops';
  static const String addCrop = '/add_crop';
  static const String cropDetail = '/crop_detail';
  static const String alerts = '/alerts';
  static const String savedItems = '/saved_items';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String mandiPrices = '/mandi_prices';

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case languageSelect:
        return MaterialPageRoute(builder: (_) => const LanguageSelectionScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const MainNavigationScreen());
      case aiChat:
        return MaterialPageRoute(builder: (_) => const MainNavigationScreen(initialIndex: 1));
      case diseaseDetection:
        return MaterialPageRoute(builder: (_) => const DiseaseDetectionScreen());
      case cropRecommendation:
        return MaterialPageRoute(builder: (_) => const CropRecommendationScreen());
      case weatherDetail:
        return MaterialPageRoute(builder: (_) => const WeatherDetailScreen());
      case schemes:
        return MaterialPageRoute(builder: (_) => const MainNavigationScreen(initialIndex: 3));
      case myCrops:
        return MaterialPageRoute(builder: (_) => const MainNavigationScreen(initialIndex: 2));
      case addCrop:
        return MaterialPageRoute(builder: (_) => const AddEditCropScreen());
      case cropDetail:
        final cropId = routeSettings.arguments as String? ?? '';
        return MaterialPageRoute(builder: (_) => CropDetailScreen(cropId: cropId));
      case alerts:
        return MaterialPageRoute(builder: (_) => const AlertsScreen());
      case savedItems:
        return MaterialPageRoute(builder: (_) => const SavedItemsScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const MainNavigationScreen(initialIndex: 4));
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case mandiPrices:
        return MaterialPageRoute(builder: (_) => const MandiPricesScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route not found: ${routeSettings.name}')),
          ),
        );
    }
  }
}
