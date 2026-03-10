import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'home_screen.dart';
import 'theme.dart';
import 'animations.dart';
import 'widgets/mascot_widget.dart';

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
    return GradientBackground(
      child: IntroductionScreen(
        globalBackgroundColor: Colors.transparent,
        pages: [
          // Welcome page with mascot
          PageViewModel(
            title: '',
            bodyWidget: Column(
              children: [
                const SizedBox(height: 60),
                Image.asset(getMascotAsset(MascotMood.greeting), height: 180),
                const SizedBox(height: 24),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [RheoColors.primary, RheoColors.accent],
                  ).createShader(bounds),
                  child: const Text(
                    'RHEO',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 8,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Learning for coding',
                  style: TextStyle(
                    fontSize: 14,
                    color: RheoColors.textMuted,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Ho┼ş Geldin! ­şæï',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            decoration: const PageDecoration(
              contentMargin: EdgeInsets.symmetric(horizontal: 32),
              bodyPadding: EdgeInsets.zero,
            ),
          ),
          _buildPage(
            title: 'Kodu Oku',
            body: 'Kod par├ğac─▒klar─▒n─▒ incele ve ├ğ─▒kt─▒y─▒ tahmin et.\nIDE a├ğmadan, sadece parmak ucunuzla.',
            icon: Icons.code_rounded,
            color: RheoColors.primary,
            emoji: '­şôû',
          ),
          _buildPage(
            title: 'Bug Avla',
            body: 'Hatal─▒ sat─▒r─▒ bul ve t─▒kla!\nGer├ğek debugging kaslar─▒n─▒ geli┼ştir.',
            icon: Icons.bug_report_rounded,
            color: RheoColors.secondary,
            emoji: '­şÉŞ',
          ),
          _buildPage(
            title: 'Y├╝ksel',
            body: 'Her g├╝n oyna, serini koru.\nELO puan─▒n─▒ y├╝kselt, r├╝tbeni kazan!',
            icon: Icons.trending_up_rounded,
            color: RheoColors.success,
            emoji: '­şÜÇ',
          ),
        ],
        showSkipButton: true,
        skip: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: RheoColors.glassLight,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: RheoColors.glassBorder),
          ),
          child: Text('Atla', style: TextStyle(color: RheoColors.textSecondary)),
        ),
        next: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            gradient: RheoGradients.primaryButton,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: RheoColors.primary.withAlpha(60),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text('─░leri', style: TextStyle(color: RheoTheme.textColor, fontWeight: FontWeight.w600)),
        ),
        done: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            gradient: RheoGradients.primaryButton,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: RheoColors.primary.withAlpha(80),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Text('Ba┼şla!', style: TextStyle(color: RheoTheme.textColor, fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        onDone: () => _finishOnboarding(context),
        onSkip: () => _finishOnboarding(context),
        dotsDecorator: DotsDecorator(
          size: const Size(10, 10),
          color: RheoColors.glassLight,
          activeSize: const Size(24, 10),
          activeColor: RheoColors.primary,
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }

  PageViewModel _buildPage({
    required String title,
    required String body,
    required IconData icon,
    required Color color,
    required String emoji,
  }) {
    return PageViewModel(
      title: '',
      bodyWidget: Column(
        children: [
          const SizedBox(height: 40),
          // Icon with glow effect
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  color.withAlpha(40),
                  color.withAlpha(10),
                  Colors.transparent,
                ],
              ),
            ),
            child: Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withAlpha(30),
                  border: Border.all(color: color.withAlpha(60), width: 2),
                ),
                child: Icon(icon, size: 50, color: color),
              ),
            ),
          ),
          const SizedBox(height: 40),
          // Title with emoji
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 12),
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [color, color.withAlpha(200)],
                ).createShader(bounds),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Body text
          Text(
            body,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: RheoColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
      decoration: const PageDecoration(
        contentMargin: EdgeInsets.symmetric(horizontal: 32),
        bodyPadding: EdgeInsets.zero,
      ),
    );
  }

  void _finishOnboarding(BuildContext context) async {
    HapticService.success();
    await markAsSeen();
    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        PageTransitions.fadeSlideUp(const HomeScreen()),
      );
    }
  }
}