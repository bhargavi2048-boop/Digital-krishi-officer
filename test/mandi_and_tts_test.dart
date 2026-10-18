import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:digital_krishi_officer/core/storage/local_storage_service.dart';
import 'package:digital_krishi_officer/core/services/mandi_service.dart';
import 'package:digital_krishi_officer/core/services/tts_service.dart';
import 'package:digital_krishi_officer/providers/mandi_provider.dart';
import 'package:digital_krishi_officer/providers/auth_provider.dart';
import 'package:digital_krishi_officer/providers/language_provider.dart';
import 'package:digital_krishi_officer/features/mandi/mandi_prices_screen.dart';
import 'package:digital_krishi_officer/widgets/advisory_card.dart';
import 'package:flutter/services.dart';
import 'package:digital_krishi_officer/l10n/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalStorageService().init();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('flutter_tts'), (MethodCall methodCall) async {
      return 1;
    });
  });

  group('Mandi Service & Provider Tests', () {
    test('MandiService returns verified APMC prices with valid ranges', () async {
      final service = MandiService();
      final prices = await service.fetchMandiPrices();

      expect(prices.isNotEmpty, true);
      final tomato = prices.firstWhere((p) => p.commodity.contains('Tomato'));
      expect(tomato.modalPrice > 0, true);
      expect(tomato.minPrice <= tomato.modalPrice, true);
      expect(tomato.modalPrice <= tomato.maxPrice, true);
      expect(tomato.pricePerKg, tomato.modalPrice / 100.0);
    });

    test('MandiService filters by category correctly', () async {
      final service = MandiService();
      final vegetables = await service.fetchMandiPrices(category: 'vegetables');

      expect(vegetables.isNotEmpty, true);
      for (final item in vegetables) {
        expect(item.category, 'vegetables');
      }
    });

    test('MandiService search by query works accurately', () async {
      final service = MandiService();
      final results = await service.fetchMandiPrices(query: 'paddy');

      expect(results.isNotEmpty, true);
      expect(results.every((p) => p.commodity.toLowerCase().contains('paddy')), true);
    });

    test('MandiProvider handles state, search, and category filtering', () async {
      final provider = MandiProvider();
      await provider.loadPrices();

      expect(provider.isLoading, false);
      expect(provider.prices.isNotEmpty, true);

      // Filter by cereals
      provider.setCategory('cereals');
      expect(provider.selectedCategory, 'cereals');
      expect(provider.prices.every((p) => p.category == 'cereals'), true);

      // Search query
      provider.setCategory('all');
      provider.setSearchQuery('Tomato');
      expect(provider.prices.length, 1);
      expect(provider.prices.first.commodity.contains('Tomato'), true);
    });
  });

  group('Mandi Prices Screen Widget & Responsive Layout Tests', () {
    Widget createMandiTestApp({required Size screenSize}) {
      final authProv = AuthProvider();
      final mandiProv = MandiProvider();
      final langProv = LanguageProvider();

      return MaterialApp(
        locale: const Locale('en', ''),
        supportedLocales: const [Locale('en', ''), Locale('ta', '')],
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
              ChangeNotifierProvider.value(value: mandiProv),
              ChangeNotifierProvider.value(value: langProv),
            ],
            child: const MandiPricesScreen(),
          ),
        ),
      );
    }

    testWidgets('MandiPricesScreen renders cleanly without overflow at 360px width', (tester) async {
      await tester.binding.setSurfaceSize(const Size(360, 720));
      await tester.pumpWidget(createMandiTestApp(screenSize: const Size(360, 720)));
      await tester.pumpAndSettle();

      expect(find.byType(MandiPricesScreen), findsOneWidget);
      expect(find.text('Live APMC Mandi Rates • Tamil Nadu & Regional Markets'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);

      expect(tester.takeException(), isNull);
    });

    testWidgets('MandiPricesScreen renders cleanly without overflow on narrow 320px viewport', (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 600));
      await tester.pumpWidget(createMandiTestApp(screenSize: const Size(320, 600)));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });

  group('Voice-First Text-To-Speech (TTS) Tests', () {
    testWidgets('AdvisoryCard renders Listen button and toggles voice state', (tester) async {
      final langProv = LanguageProvider();

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en', ''),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Scaffold(
            body: MultiProvider(
              providers: [
                ChangeNotifierProvider.value(value: langProv),
              ],
              child: const AdvisoryCard(
                advisoryText: 'Soil moisture is optimal. Inspect crops for early stem borer signs.',
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Listen button should be visible
      expect(find.text('Listen'), findsOneWidget);
      expect(find.byIcon(Icons.volume_up_rounded), findsOneWidget);

      // Tap Listen button
      await tester.tap(find.text('Listen'));
      await tester.pump();

      // Verify TtsService received text
      expect(TtsService().currentSpeakingText.contains('Soil moisture is optimal'), true);
      expect(TtsService().isPlayingNotifier.value, true);

      // Stop voice
      await TtsService().stop();
      await tester.pump();
      expect(TtsService().isPlayingNotifier.value, false);
    });
  });
}
