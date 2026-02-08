import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'ui/onboarding_screen.dart';
import 'ui/home_screen.dart';
import 'ui/widgets/error_screen.dart';
import 'logic/language_service.dart';
import 'logic/analytics_service.dart';

void main() async {
  // Zone ile tüm hataları yakala
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Firebase başlat
    try {
      await Firebase.initializeApp();
      debugPrint('✅ Firebase initialized');
      
      // Crashlytics'e Flutter hatalarını gönder
      if (!kIsWeb) {
        FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
      }
      
      // Analytics başlat
      await analyticsService.init();
      debugPrint('✅ Analytics initialized');
    } catch (e) {
      debugPrint('⚠️ Firebase init error (google-services.json eksik olabilir): $e');
    }
    
    // Global error handler (fallback)
    FlutterError.onError ??= (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      debugPrint('Flutter Error: ${details.exception}');
    };
    
    await Hive.initFlutter();
    
    // Initialize services
    await languageService.init();
    
    // Kullanıcı tercihine göre onboarding göster
    final hasSeenOnboarding = await OnboardingScreen.hasSeenOnboarding();
    
    // Set error widget
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return ErrorScreen(
        errorDetails: details,
        onRetry: () {
          // Error durumunda yapılacak işlem
        },
      );
    };
    
    runApp(RheoApp(showOnboarding: !hasSeenOnboarding));
  }, (error, stack) {
    // Zone dışı hatalar
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
      title: 'Rheo',
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
