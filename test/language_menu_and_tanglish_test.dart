import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:digital_krishi_officer/core/storage/local_storage_service.dart';
import 'package:digital_krishi_officer/core/services/gemini_service.dart';
import 'package:digital_krishi_officer/providers/auth_provider.dart';
import 'package:digital_krishi_officer/providers/weather_provider.dart';
import 'package:digital_krishi_officer/providers/crop_provider.dart';
import 'package:digital_krishi_officer/providers/alert_provider.dart';
import 'package:digital_krishi_officer/providers/language_provider.dart';
import 'package:digital_krishi_officer/features/home/home_dashboard_screen.dart';
import 'package:digital_krishi_officer/l10n/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalStorageService().init();
  });

  group('Gemini Tanglish & Dynamic Language Mirroring Tests', () {
    test('Tanglish query returns Tanglish advisory in fallback mode', () async {
      final gemini = GeminiService();
      final response = await gemini.askKrishiOfficer(
        prompt: 'thakkali sedila ilai manjal aagiradhu enna marundhu adikkalam?',
        langCode: 'en',
      );

      // Verify that response contains natural Tanglish terms
      expect(response.toLowerCase().contains('tanglish') || response.toLowerCase().contains('manjal') || response.toLowerCase().contains('thakkali') || response.toLowerCase().contains('sedila'), true);
      expect(response.contains('Enna Pannanum') || response.contains('spray pannunga') || response.contains('koodadhu') || response.contains('manjal aagiradhu'), true);
    });

    test('Tamil script query returns Tamil script advice in fallback mode', () async {
      final gemini = GeminiService();
      final response = await gemini.askKrishiOfficer(
        prompt: 'தக்காளி செடியில் இலை மஞ்சள் ஆகிறது என்ன செய்வது?',
        langCode: 'ta',
      );

      expect(response.contains('சாத்தியமான காரணம்') || response.contains('நீங்கள் செய்ய வேண்டியவை'), true);
    });

    test('English query returns English advice in fallback mode', () async {
      final gemini = GeminiService();
      final response = await gemini.askKrishiOfficer(
        prompt: 'Why are tomato leaves turning yellow?',
        langCode: 'en',
      );

      expect(response.contains('Possible Cause') || response.contains('What You Can Do'), true);
    });
  });

  group('Home Dashboard Language Menu Tests', () {
    Widget createDashboardTestApp({
      required Size screenSize,
      required LanguageProvider langProv,
    }) {
      final authProv = AuthProvider();
      final weatherProv = WeatherProvider();
      final cropProv = CropProvider();
      final alertProv = AlertProvider();

      return MaterialApp(
        locale: langProv.currentLocale,
        supportedLocales: const [
          Locale('en', ''),
          Locale('ta', ''),
          Locale('hi', ''),
          Locale('te', ''),
          Locale('kn', ''),
          Locale('ml', ''),
        ],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: MediaQuery(
          data: MediaQueryData(size: screenSize),
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: authProv),
              ChangeNotifierProvider.value(value: weatherProv),
              ChangeNotifierProvider.value(value: cropProv),
              ChangeNotifierProvider.value(value: alertProv),
              ChangeNotifierProvider.value(value: langProv),
            ],
            child: HomeDashboardScreen(onNavigateToTab: (_) {}),
          ),
        ),
      );
    }

    testWidgets('Language menu button renders cleanly and shows Tamil, English, Hindi, and All', (tester) async {
      final langProv = LanguageProvider();
      await tester.binding.setSurfaceSize(const Size(360, 800));

      await tester.pumpWidget(createDashboardTestApp(
        screenSize: const Size(360, 800),
        langProv: langProv,
      ));
      await tester.pumpAndSettle();

      // Find the language switch button PopupMenuButton
      final popupFinder = find.byType(PopupMenuButton<String>);
      expect(popupFinder, findsOneWidget);

      // Tap the PopupMenuButton to open menu
      await tester.tap(popupFinder);
      await tester.pumpAndSettle();

      // Verify the 4 options: Tamil, English, Hindi, All
      expect(find.text('தமிழ்'), findsWidgets);
      expect(find.text('English'), findsWidgets);
      expect(find.text('हिन्दी'), findsOneWidget);
      expect(find.text('All Languages...'), findsOneWidget);

      // Tap Tamil
      await tester.tap(find.text('தமிழ்').last);
      await tester.pumpAndSettle();

      // Verify language changed
      expect(langProv.currentLanguageCode, 'ta');
    });

    testWidgets('Home page layout does not overflow at narrow widths (320px) in Tamil', (tester) async {
      final langProv = LanguageProvider();
      await langProv.setLanguage('ta');

      await tester.binding.setSurfaceSize(const Size(320, 640));

      await tester.pumpWidget(createDashboardTestApp(
        screenSize: const Size(320, 640),
        langProv: langProv,
      ));
      await tester.pumpAndSettle();

      // Ensure no red error boxes or RenderFlex errors exist
      expect(tester.takeException(), isNull);
    });

    testWidgets('Home page layout does not overflow at standard width (414px) in Hindi', (tester) async {
      final langProv = LanguageProvider();
      await langProv.setLanguage('hi');

      await tester.binding.setSurfaceSize(const Size(414, 896));

      await tester.pumpWidget(createDashboardTestApp(
        screenSize: const Size(414, 896),
        langProv: langProv,
      ));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
