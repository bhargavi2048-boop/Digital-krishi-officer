import 'package:flutter_test/flutter_test.dart';
import 'package:digital_krishi_officer/app/app.dart';
import 'package:digital_krishi_officer/core/storage/local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalStorageService().init();
  });

  testWidgets('App initializes with Digital Krishi Officer splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const DigitalKrishiOfficerApp());
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Digital Krishi Officer'), findsWidgets);
    await tester.pump(const Duration(seconds: 7));
    await tester.pumpAndSettle();
  });
}
