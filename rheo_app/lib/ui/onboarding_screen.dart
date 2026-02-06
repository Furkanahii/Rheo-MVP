import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  static const String _boxName = 'rheo_settings';
  static const String _seenKey = 'seen_onboarding';

  static Future<bool> hasSeenOnboarding() async {
    final box = await Hive.openBox(_boxName);
    return box.get(_seenKey, defaultValue: false);
  }

  static Future<void> markAsSeen() async {
    final box = await Hive.openBox(_boxName);
    await box.put(_seenKey, true);
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: const Color(0xFF1E1E1E),
      pages: [
        _buildPage(
          title: 'Kodu Oku 📖',
          body: 'Kod parçacıklarını oku ve çıktıyı tahmin et. IDE açmadan, sadece parmak ucunuzla.',
          icon: Icons.code,
          color: const Color(0xFF00D9FF),
        ),
        _buildPage(
          title: 'Bug Avla 🐞',
          body: 'Hatalı satırı bul! Gerçek debugging kaslarını geliştir.',
          icon: Icons.bug_report,
          color: Colors.orange,
        ),
        _buildPage(
          title: 'Yüksel 🚀',
          body: 'Her gün oyna, serini koru, ELO puanını yükselt ve rütbeni kazan!',
          icon: Icons.trending_up,
          color: Colors.green,
        ),
      ],
      showSkipButton: true,
      skip: const Text('Atla', style: TextStyle(color: Colors.grey)),
      next: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF00D9FF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text('İleri', style: TextStyle(color: Colors.black)),
      ),
      done: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF00D9FF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text('Başla!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      onDone: () => _finishOnboarding(context),
      onSkip: () => _finishOnboarding(context),
      dotsDecorator: DotsDecorator(
        size: const Size(10, 10),
        color: Colors.grey[700]!,
        activeSize: const Size(22, 10),
        activeColor: const Color(0xFF00D9FF),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }

  PageViewModel _buildPage({
    required String title,
    required String body,
    required IconData icon,
    required Color color,
  }) {
    return PageViewModel(
      title: title,
      body: body,
      image: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: color.withAlpha(30),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 80, color: color),
      ),
      decoration: PageDecoration(
        titleTextStyle: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        bodyTextStyle: TextStyle(
          fontSize: 16,
          color: Colors.grey[400],
        ),
        imagePadding: const EdgeInsets.only(top: 60),
        contentMargin: const EdgeInsets.symmetric(horizontal: 24),
      ),
    );
  }

  void _finishOnboarding(BuildContext context) async {
    await markAsSeen();
    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }
}
