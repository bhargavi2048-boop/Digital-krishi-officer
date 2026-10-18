import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:digital_krishi_officer/core/storage/local_storage_service.dart';
import 'package:digital_krishi_officer/providers/auth_provider.dart';
import 'package:digital_krishi_officer/providers/language_provider.dart';
import 'package:digital_krishi_officer/l10n/translations.dart';
import 'package:digital_krishi_officer/l10n/app_localizations.dart';
import 'package:digital_krishi_officer/core/constants/app_constants.dart';
import 'package:digital_krishi_officer/core/services/weather_service.dart';
import 'package:digital_krishi_officer/models/weather_data.dart';
import 'package:digital_krishi_officer/widgets/weather_card.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalStorageService().init();
  });

  group('Guest Mode Tests', () {
    test('User can successfully login as Guest mode', () async {
      final auth = AuthProvider();
      expect(auth.isLoggedIn, false);
      expect(auth.isGuest, false);

      final success = await auth.loginAsGuest();
      expect(success, true);
      expect(auth.isLoggedIn, true);
      expect(auth.isGuest, true);
      expect(auth.currentUser != null, true);
      expect(auth.currentUser!.id, 'guest_farmer');
      expect(auth.currentUser!.fullName, 'Guest Farmer');
      expect(auth.currentUser!.city, 'Chennai');
      expect(auth.currentUser!.district, 'Chennai');
      expect(auth.currentUser!.state, 'Tamil Nadu');
    });

    test('Guest user logout clears session properly', () async {
      final auth = AuthProvider();
      await auth.loginAsGuest();
      expect(auth.isLoggedIn, true);

      await auth.logout();
      expect(auth.isLoggedIn, false);
      expect(auth.isGuest, false);
      expect(auth.currentUser, isNull);
    });
  });

  group('Language Switching and Translations Tests', () {
    test('Language provider switches between English and Tamil cleanly', () async {
      final lang = LanguageProvider();
      expect(lang.currentLanguageCode, 'en');

      await lang.setLanguage('ta');
      expect(lang.currentLanguageCode, 'ta');
      expect(lang.currentLocale.languageCode, 'ta');

      await lang.setLanguage('en');
      expect(lang.currentLanguageCode, 'en');
    });

    test('Translations returns pure Tamil without corrupted characters', () {
      final appNameTa = Translations.get('appName', 'ta');
      expect(appNameTa, 'டிஜிட்டல் கிரிஷி அதிகாரி');
      expect(appNameTa.contains('à'), false);
      expect(appNameTa.contains('ð'), false);

      final guestModeTa = Translations.get('guestMode', 'ta');
      expect(guestModeTa, 'விருந்தினர் முறை');

      final continueAsGuestTa = Translations.get('continueAsGuest', 'ta');
      expect(continueAsGuestTa, 'விருந்தினராக தொடரவும்');

      final navHomeTa = Translations.get('navHome', 'ta');
      expect(navHomeTa, 'முகப்பு');

      final todayWeatherTa = Translations.get('todayWeather', 'ta');
      expect(todayWeatherTa, 'இன்றைய வானிலை');
    });

    test('English translations has guest mode keys and clean text', () {
      expect(Translations.get('appName', 'en'), 'Digital Krishi Officer');
      expect(Translations.get('guestMode', 'en'), 'Guest Mode');
      expect(Translations.get('continueAsGuest', 'en'), 'Continue as Guest');
      expect(Translations.get('guestFarmer', 'en'), 'Guest Farmer');
    });

    test('All 6 languages are supported in AppConstants and Translations', () {
      final supported = AppConstants.supportedLanguages.map((l) => l['code']).toList();
      expect(supported, containsAll(['en', 'ta', 'hi', 'te', 'kn', 'ml']));
      for (final code in supported) {
        expect(Translations.values.containsKey(code), true);
      }
    });

    test('WeatherService agricultural advisory contains clean text and no mojibake', () async {
      final weatherService = WeatherService();
      final weather = await weatherService.fetchWeather(
        locationName: 'Chennai',
        cropName: 'Paddy',
      );
      expect(weather.agriculturalAdvisory.contains('âš'), false);
      expect(weather.agriculturalAdvisory.contains('â˜'), false);
      expect(weather.agriculturalAdvisory.isNotEmpty, true);
    });

    testWidgets('WeatherCard renders without overflow in Tamil on small 320px screen', (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final dummyWeather = WeatherData(
        temperature: 32.5,
        condition: 'Heavy Rain Showers',
        humidity: 88,
        windSpeed: 24.5,
        rainProbability: 75,
        locationName: 'Thiruvaiyaru, Thanjavur',
        forecast: [],
        agriculturalAdvisory: 'Clean advisory text without symbols.',
      );

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ta'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('ta'),
          ],
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: WeatherCard(weather: dummyWeather),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(WeatherCard), findsOneWidget);
    });
  });
}
