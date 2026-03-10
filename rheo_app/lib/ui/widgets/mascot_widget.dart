import 'dart:math';
import 'package:flutter/material.dart';
import '../theme.dart';
import '../animations.dart';
import '../../data/app_strings.dart';

/// Mascot ruh halleri
enum MascotMood {
  greeting,      // Kar┼ş─▒lama
  happy,         // Mutlu
  celebrating,   // Kutlama
  thinking,      // D├╝┼ş├╝n├╝yor
  encouraging,   // Cesaretlendirici
  sad,           // ├£zg├╝n
  sleeping,      // Uyuyor
  excited,       // Heyecanl─▒
}

/// Her ruh haline g├Âre do─şru mascot g├Ârseli
String getMascotAsset(MascotMood mood) {
  switch (mood) {
    case MascotMood.greeting:
      return 'assets/mascot_greeting.png';
    case MascotMood.happy:
      return 'assets/mascot_happy.png';
    case MascotMood.celebrating:
    case MascotMood.excited:
      return 'assets/mascot_celebrating.png';
    case MascotMood.thinking:
      return 'assets/mascot_thinking.png';
    case MascotMood.encouraging:
      return 'assets/mascot_encouraging.png';
    case MascotMood.sad:
      return 'assets/mascot_sad.png';
    case MascotMood.sleeping:
      return 'assets/mascot.png'; // default/neutral
  }
}

/// Mascot mesaj yard─▒mc─▒s─▒ - duruma g├Âre rastgele mesajlar d├Ând├╝r├╝r
class MascotHelper {
  static final _random = Random();

  /// Zamana g├Âre kar┼ş─▒lama mesaj─▒
  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 6) {
      return _pick(S.isEn 
        ? ['Night owl! ­şĞë', 'Coding this late? Respect! ­şîÖ', 'Midnight coder? ­şİ┤']
        : ['Gece ku┼şu! ­şĞë', 'Bu saatte mi? Helal! ­şîÖ', 'Gece gece kod mu okuyoruz? ­şİ┤']);
    } else if (hour < 12) {
      return _pick(S.isEn
        ? ['Good morning! ÔİÇ´©Å', 'Start the day with code! ­şîà', 'Morning energy! ­şÆ¬']
        : ['G├╝nayd─▒n! ÔİÇ´©Å', 'G├╝ne kodla ba┼şla! ­şîà', 'Sabah enerjisiyle devam! ­şÆ¬']);
    } else if (hour < 18) {
      return _pick(S.isEn
        ? ['Hello! ­şæï', 'Good afternoon! ÔİÇ´©Å', 'Afternoon challenge? ­şöÑ']
        : ['Merhaba! ­şæï', '─░yi g├╝nler! ÔİÇ´©Å', '├û─şleden sonra challenge? ­şöÑ']);
    } else {
      return _pick(S.isEn
        ? ['Good evening! ­şîå', 'Evening workout! ­şÆ¬', 'Night quiz? Let\'s go! ­şîÖ']
        : ['─░yi ak┼şamlar! ­şîå', 'Ak┼şam antrenman─▒! ­şÆ¬', 'Gece s─▒nav─▒ m─▒? Haydi! ­şîÖ']);
    }
  }

  /// Zamana g├Âre kar┼ş─▒lama mood'u
  static MascotMood getGreetingMood() {
    final hour = DateTime.now().hour;
    if (hour < 6) return MascotMood.sleeping;
    return MascotMood.greeting;
  }

  /// Do─şru cevap mesajlar─▒
  static String getCorrectMessage() {
    return _pick(S.correctMessages);
  }

  /// Yanl─▒┼ş cevap mesajlar─▒
  static String getWrongMessage() {
    return _pick(S.wrongMessages);
  }

  /// Seri uyar─▒ mesajlar─▒ (bug├╝n oynamad─▒ysa)
  static String getStreakWarning() {
    return _pick(S.streakWarnings);
  }

  /// Sonu├ğ yorumlar─▒ (ba┼şar─▒ oran─▒na g├Âre)
  static String getResultComment(int accuracy) {
    return _pick(S.getResultComment(accuracy));
  }

  /// Bug Hunt ├Âzel mesajlar
  static String getBugHuntCorrect() {
    return _pick(S.bugHuntCorrect);
  }

  static String getBugHuntWrong() {
    return _pick(S.bugHuntWrong);
  }

  /// Time Attack ├Âzel mesajlar
  static String getTimeUpMessage() {
    return _pick(S.timeUpMessages);
  }

  /// AI soru y├╝kleme bekleme mesajlar─▒
  static String getWaitingMessage() {
    return _pick(S.waitingMessages);
  }

  /// G├╝nl├╝k hedef tamamland─▒ mesajlar─▒
  static String getDailyGoalComplete() {
    return _pick(S.dailyGoalComplete);
  }

  /// ELO rank yorumu
  static String getRankComment(int elo) {
    return S.getRankComment(elo);
  }

  static String _pick(List<String> options) {
    return options[_random.nextInt(options.length)];
  }
}

/// Maskot widget - ruh haline g├Âre farkl─▒ g├Ârsel + konu┼şma balonu
class MascotWidget extends StatelessWidget {
  final MascotMood mood;
  final String? message;
  final double size;
  final bool showBubble;
  final bool animate;
  final Color? bubbleColor;

  const MascotWidget({
    super.key,
    this.mood = MascotMood.happy,
    this.message,
    this.size = 80,
    this.showBubble = true,
    this.animate = true,
    this.bubbleColor,
  });

  @override
  Widget build(BuildContext context) {
    final assetPath = getMascotAsset(mood);
    
    final mascotImage = animate
        ? PulseAnimation(
            duration: const Duration(milliseconds: 2000),
            child: Image.asset(assetPath, height: size),
          )
        : Image.asset(assetPath, height: size);

    if (!showBubble || message == null) {
      return mascotImage;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        mascotImage,
        const SizedBox(width: 12),
        Flexible(
          child: _SpeechBubble(
            message: message!,
            color: bubbleColor,
            mood: mood,
          ),
        ),
      ],
    );
  }
}

/// Konu┼şma balonu widget
class _SpeechBubble extends StatelessWidget {
  final String message;
  final Color? color;
  final MascotMood mood;

  const _SpeechBubble({
    required this.message,
    this.color,
    required this.mood,
  });

  Color get _moodColor {
    switch (mood) {
      case MascotMood.celebrating:
      case MascotMood.happy:
        return RheoColors.success;
      case MascotMood.greeting:
      case MascotMood.excited:
        return RheoColors.primary;
      case MascotMood.thinking:
        return RheoColors.accent;
      case MascotMood.encouraging:
        return RheoColors.warning;
      case MascotMood.sad:
        return RheoColors.error;
      case MascotMood.sleeping:
        return RheoColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bubbleColor = color ?? _moodColor;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: bubbleColor.withAlpha(25),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(16),
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        border: Border.all(color: bubbleColor.withAlpha(60)),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.3,
        ),
      ),
    );
  }
}

/// Home Screen'de kullan─▒lacak b├╝y├╝k mascot kar┼ş─▒lama kart─▒
class MascotGreetingCard extends StatelessWidget {
  final String greeting;
  final String? subtitle;
  final Color? accentColor;

  const MascotGreetingCard({
    super.key,
    required this.greeting,
    this.subtitle,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final greetingMood = MascotHelper.getGreetingMood();
    
    return GlassCard(
      borderColor: (accentColor ?? RheoColors.primary).withAlpha(60),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          PulseAnimation(
            duration: const Duration(milliseconds: 2500),
            child: Image.asset(getMascotAsset(greetingMood), height: 60),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 12,
                      color: RheoColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Sonu├ğ diyaloglar─▒nda mascot performans yorumu
class MascotResultCard extends StatelessWidget {
  final int accuracy;
  final String? customMessage;

  const MascotResultCard({
    super.key,
    required this.accuracy,
    this.customMessage,
  });

  MascotMood get _mood {
    if (accuracy >= 80) return MascotMood.celebrating;
    if (accuracy >= 50) return MascotMood.happy;
    return MascotMood.encouraging;
  }

  @override
  Widget build(BuildContext context) {
    final message = customMessage ?? MascotHelper.getResultComment(accuracy);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: MascotWidget(
        mood: _mood,
        message: message,
        size: 55,
        animate: accuracy >= 70,
      ),
    );
  }
}