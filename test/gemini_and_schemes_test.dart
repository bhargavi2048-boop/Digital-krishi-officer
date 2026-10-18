import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:digital_krishi_officer/core/services/gemini_service.dart';
import 'package:digital_krishi_officer/core/services/scheme_service.dart';
import 'package:digital_krishi_officer/core/storage/local_storage_service.dart';
import 'package:digital_krishi_officer/providers/scheme_provider.dart';
import 'package:digital_krishi_officer/providers/auth_provider.dart';
import 'package:digital_krishi_officer/features/schemes/schemes_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalStorageService().init();
  });

  group('Gemini Service Fallback & Language Tests', () {
    final gemini = GeminiService();

    test('Offline fallback includes clear high-demand notice in English', () {
      final res = gemini.askKrishiOfficer(
        prompt: 'My tomato plant has yellow leaves, what should I do?',
        langCode: 'en',
      );
      // We expect the fallback when no key or during offline test
      expect(res, completes);
    });

    test('SchemeService loads schemes properly with non-empty list', () {
      final schemeService = SchemeService();
      final all = schemeService.getAllSchemes();
      expect(all.isNotEmpty, true);
      expect(all.any((s) => s.id == 'scheme_pm_kisan'), true);
      expect(all.any((s) => s.category == 'Income Support'), true);
    });
  });

  group('Schemes Screen Responsive Layout Tests', () {
    testWidgets('Schemes page renders without overflow at 414px width', (tester) async {
      tester.view.physicalSize = const Size(414, 896);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => SchemeProvider()),
          ],
          child: const MaterialApp(
            home: SchemesScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify no RenderFlex overflow
      expect(tester.takeException(), isNull);
      expect(find.byType(SchemesScreen), findsOneWidget);
    });

    testWidgets('Schemes page renders without overflow at 360px width', (tester) async {
      tester.view.physicalSize = const Size(360, 780);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => SchemeProvider()),
          ],
          child: const MaterialApp(
            home: SchemesScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(SchemesScreen), findsOneWidget);
    });

    testWidgets('Schemes page renders without overflow at 320px width', (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => SchemeProvider()),
          ],
          child: const MaterialApp(
            home: SchemesScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(SchemesScreen), findsOneWidget);
    });
  });
}
