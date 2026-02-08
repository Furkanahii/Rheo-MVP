import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'ui/onboarding_screen.dart';
import 'ui/home_screen.dart';
import 'ui/widgets/error_screen.dart';
import 'logic/language_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Global error handler
  FlutterError.onError = (FlutterErrorDetails details) {
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
}

class RheoApp extends StatelessWidget {
  final bool showOnboarding;
  
  const RheoApp({super.key, required this.showOnboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rheo',
      debugShowCheckedModeBanner: false,
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
