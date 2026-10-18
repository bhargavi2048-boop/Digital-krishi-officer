import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:digital_krishi_officer/core/storage/local_storage_service.dart';
import 'package:digital_krishi_officer/core/services/share_service.dart';
import 'package:digital_krishi_officer/models/disease_analysis.dart';
import 'package:digital_krishi_officer/models/mandi_price.dart';
import 'package:digital_krishi_officer/providers/auth_provider.dart';
import 'package:digital_krishi_officer/providers/disease_provider.dart';
import 'package:digital_krishi_officer/providers/language_provider.dart';
import 'package:digital_krishi_officer/providers/mandi_provider.dart';
import 'package:digital_krishi_officer/features/disease_detection/disease_result_screen.dart';
import 'package:digital_krishi_officer/features/mandi/mandi_prices_screen.dart';
import 'package:digital_krishi_officer/l10n/app_localizations.dart';
import 'package:flutter/services.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('flutter_tts'), (call) async {
      return 1;
    });
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalStorageService().init();
  });

  group('ShareService Formatting Tests', () {
    final sampleAnalysis = DiseaseAnalysis(
      id: 'test_disease_1',
      cropName: 'Tomato',
      possibleIssue: 'Early Blight (Alternaria solani)',
      confidenceScore: 88,
      observedSymptoms: 'Concentric brown rings on lower leaves',
      possibleCauses: 'Fungal spores in humid conditions',
      recommendedAction: 'Mancozeb 75% WP @ 2g/L or Chlorothalonil',
      prevention: 'Neem oil spray, crop rotation, and avoid overhead watering',
      whenToSeekExpert: 'If yellowing spreads to upper fruit clusters',
    );

    const sampleMandi = MandiPrice(
      id: 'mandi_test_1',
      commodity: 'Tomato (தக்காளி)',
      variety: 'Hybrid Red',
      marketName: 'Koyambedu Wholesale Market',
      district: 'Chennai',
      state: 'Tamil Nadu',
      minPrice: 2200,
      maxPrice: 2800,
      modalPrice: 2500,
      priceDate: '18 Oct 2026',
      trend: PriceTrend.up,
      changeAmount: 150,
      category: 'vegetables',
      iconEmoji: '🍅',
    );

    test('formatDiseasePrescription produces accurate English slip', () {
      final shareService = ShareService();
      final text = shareService.formatDiseasePrescription(sampleAnalysis, 'en');

      expect(text, contains('Digital Krishi Officer - Crop Prescription Slip'));
      expect(text, contains('Tomato'));
      expect(text, contains('Early Blight'));
      expect(text, contains('Mancozeb 75% WP'));
      expect(text, contains('88% Confidence'));
    });

    test('formatDiseasePrescription produces authentic Tamil prescription slip', () {
      final shareService = ShareService();
      final text = shareService.formatDiseasePrescription(sampleAnalysis, 'ta');

      expect(text, contains('டிஜிட்டல் கிருஷி அதிகாரி - பயிர் மருந்து பரிந்துரைச் சீட்டு'));
      expect(text, contains('*பயிர்:* Tomato'));
      expect(text, contains('Mancozeb 75% WP'));
      expect(text, contains('உரக்கடையில் வாங்க வேண்டிய பரிந்துரை மருந்து'));
    });

    test('formatDiseasePrescription produces authentic Hindi prescription slip', () {
      final shareService = ShareService();
      final text = shareService.formatDiseasePrescription(sampleAnalysis, 'hi');

      expect(text, contains('डिजिटल कृषि अधिकारी - फसल उपचार पर्ची'));
      expect(text, contains('*फसल:* Tomato'));
      expect(text, contains('Mancozeb 75% WP'));
      expect(text, contains('दुकानदार के लिए अनुशंसित कीटनाशक/दवा'));
    });

    test('formatMandiPriceShare produces accurate rates in Tamil and English', () {
      final shareService = ShareService();
      final taText = shareService.formatMandiPriceShare(sampleMandi, 'ta');
      expect(taText, contains('டிஜிட்டல் கிருஷி அதிகாரி - இன்றைய மண்டி விலை'));
      expect(taText, contains('Koyambedu Wholesale Market'));
      expect(taText, contains('2500'));
      expect(taText, contains('+₹150'));

      final enText = shareService.formatMandiPriceShare(sampleMandi, 'en');
      expect(enText, contains('Digital Krishi Officer - Live Mandi Market Price'));
      expect(enText, contains('*Modal Price:* ₹2500'));
    });
  });

  group('Disease Result Screen WhatsApp Prescription Card Tests', () {
    final sampleAnalysis = DiseaseAnalysis(
      id: 'test_disease_2',
      cropName: 'Paddy',
      possibleIssue: 'Blast Disease',
      confidenceScore: 82,
      observedSymptoms: 'Spindle-shaped lesions with grey centers',
      possibleCauses: 'Magnaporthe oryzae fungus',
      recommendedAction: 'Tricyclazole 75% WP @ 0.6g/L',
      prevention: 'Balanced nitrogen fertilizer, seed treatment with Pseudomonas',
      whenToSeekExpert: 'If blast lesions appear on neck of the panicle',
    );

    Widget createTestWidget({String langCode = 'en', double screenWidth = 360}) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => LanguageProvider()),
          ChangeNotifierProvider(create: (_) => DiseaseProvider()),
        ],
        child: MaterialApp(
          locale: Locale(langCode),
          supportedLocales: const [Locale('en'), Locale('ta'), Locale('hi')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: MediaQuery(
            data: MediaQueryData(size: Size(screenWidth, 800)),
            child: DiseaseResultScreen(analysis: sampleAnalysis),
          ),
        ),
      );
    }

    testWidgets('DiseaseResultScreen displays WhatsApp & prescription buttons cleanly', (tester) async {
      await tester.pumpWidget(createTestWidget(langCode: 'en', screenWidth: 360));
      await tester.pumpAndSettle();

      expect(find.text('Prescription Slip for Dealer'), findsOneWidget);
      expect(find.text('Share on WhatsApp'), findsOneWidget);
      expect(find.text('Copy Prescription'), findsOneWidget);
    });

    testWidgets('DiseaseResultScreen renders without overflow on narrow 320px viewport in Tamil', (tester) async {
      await tester.pumpWidget(createTestWidget(langCode: 'ta', screenWidth: 320));
      await tester.pumpAndSettle();

      expect(find.text('உரக்கடைக்கான மருந்துச் சீட்டு'), findsOneWidget);
      expect(find.text('வாட்ஸ்அப்பில் பகிரவும்'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('Mandi Prices Screen Share Button Tests', () {
    Widget createMandiTestWidget({String langCode = 'en', double screenWidth = 360}) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => LanguageProvider()),
          ChangeNotifierProvider(create: (_) => MandiProvider()),
        ],
        child: MaterialApp(
          locale: Locale(langCode),
          supportedLocales: const [Locale('en'), Locale('ta'), Locale('hi')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: MediaQuery(
            data: MediaQueryData(size: Size(screenWidth, 800)),
            child: const MandiPricesScreen(),
          ),
        ),
      );
    }

    testWidgets('MandiPricesScreen renders share rate button on cards with zero overflow at 320px in Tamil', (tester) async {
      await tester.pumpWidget(createMandiTestWidget(langCode: 'ta', screenWidth: 320));
      await tester.pumpAndSettle();

      expect(find.text('மண்டி விலையை பகிரவும்'), findsWidgets);
      expect(tester.takeException(), isNull);
    });
  });
}
