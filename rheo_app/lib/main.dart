import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'ui/onboarding_screen.dart';
import 'ui/home_screen.dart';
import 'ui/widgets/error_screen.dart';
import 'logic/language_service.dart';
import 'logic/analytics_service.dart';
import 'logic/ai_service.dart';
import 'logic/sound_service.dart';
import 'logic/notification_service.dart';

void main() async {
  // Zone ile t├╝m hatalar─▒ yakala
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Firebase ba┼şlat
    try {
      await Firebase.initializeApp();
      debugPrint('Ô£à Firebase initialized');
      
      // Crashlytics'e Flutter hatalar─▒n─▒ g├Ânder
      if (!kIsWeb) {
        FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
      }
      
      // Analytics ba┼şlat
      await analyticsService.init();
      debugPrint('Ô£à Analytics initialized');
    } catch (e) {
      debugPrint('ÔÜá´©Å Firebase init error (google-services.json eksik olabilir): $e');
    }
    
    // Global error handler (fallback)
    FlutterError.onError ??= (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      debugPrint('Flutter Error: ${details.exception}');
    };
    
    await Hive.initFlutter();
    
    // Load environment variables (.env)
    try {
      await dotenv.load(fileName: '.env');
      debugPrint('Ô£à dotenv loaded');
    } catch (e) {
      debugPrint('ÔÜá´©Å .env file not found: $e');
    }
    
    // Initialize AI service
    await aiService.init();
    
    // Initialize services
    await languageService.init();
    await soundService.init();
    await notificationService.init();
    
    // Onboarding her zaman g├Âster (demo/MVP link payla┼ş─▒m─▒ i├ğin)
    const showOnboarding = true;
    
    runApp(RheoApp(showOnboarding: showOnboarding));
  }, (error, stack) {
    // Zone d─▒┼ş─▒ hatalar
    if (!kIsWeb) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    }
    debugPrint('Zone Error: $error');
  });
}

class RheoApp extends StatelessWidget {
  final bool showOnboarding;
  
  const RheoApp({super.key, required this.showOnboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rheo v2.0',
      debugShowCheckedModeBanner: false,
      navigatorObservers: [
        if (analyticsService.observer != null) analyticsService.observer!,
      ],
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00D9FF),
          secondary: Color(0xFF00D9FF),
          surface: Color(0xFF1E1E1E),
        ),
      ),
      home: showOnboarding ? const OnboardingScreen() : const HomeScreen(),
    );
  }
}