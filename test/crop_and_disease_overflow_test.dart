import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:digital_krishi_officer/core/storage/local_storage_service.dart';
import 'package:digital_krishi_officer/providers/auth_provider.dart';
import 'package:digital_krishi_officer/providers/language_provider.dart';
import 'package:digital_krishi_officer/providers/weather_provider.dart';
import 'package:digital_krishi_officer/l10n/app_localizations.dart';
import 'package:digital_krishi_officer/models/crop.dart';
import 'package:digital_krishi_officer/widgets/crop_card.dart';
import 'package:digital_krishi_officer/features/auth/register_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalStorageService().init();
  });

  group('Registration Screen Tests', () {
    testWidgets('RegisterScreen does not have primary crop dropdown and renders cleanly', (tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => LanguageProvider()),
            ChangeNotifierProvider(create: (_) => WeatherProvider()),
          ],
          child: const MaterialApp(
            locale: Locale('en'),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [Locale('en'), Locale('ta')],
            home: RegisterScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Ensure no overflow
      expect(tester.takeException(), isNull);
      // Ensure 'Main Crop' dropdown is gone
      expect(find.text('Main Crop'), findsNothing);
      // Ensure 'Paddy (Rice)' default is gone from registration form
      expect(find.text('Paddy (Rice)'), findsNothing);
      // Other farm fields remain
      expect(find.text('Agricultural Profile'), findsOneWidget);
    });
  });

  group('CropCard Tamil Responsive Tests', () {
    testWidgets('CropCard renders cleanly in Tamil on 320px screen without RenderFlex overflow', (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final dummyCrop = Crop(
        id: 'crop_1',
        name: 'நெல் (பயிர்)',
        variety: 'ADT 45',
        plantingDate: DateTime.now().subtract(const Duration(days: 40)),
        expectedHarvestDate: DateTime.now().add(const Duration(days: 80)),
        landAreaAcres: 3.5,
        soilType: 'வண்டல் மண்',
        waterSource: 'கால்வாய் பாசனம்',
        stage: 'Vegetative',
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
          supportedLocales: const [Locale('en'), Locale('ta')],
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CropCard(
                crop: dummyCrop,
                onTap: () {},
                onAskAi: () {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Absolutely zero RenderFlex overflow errors
      expect(tester.takeException(), isNull);
      expect(find.byType(CropCard), findsOneWidget);
    });
  });
}
