import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/storage/local_storage_service.dart';
import 'core/services/tts_service.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables (.env)
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint('Note: .env file not found or failed to load. Falling back to built-in configurations: $e');
  }

  // Initialize local persistent storage
  await LocalStorageService().init();

  // Initialize Text-To-Speech engine
  await TtsService().init();

  runApp(const DigitalKrishiOfficerApp());
}
