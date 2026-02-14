import 'dart:math';
import 'package:flutter/material.dart';
import '../theme.dart';
import '../animations.dart';

/// Mascot ruh halleri
enum MascotMood {
  greeting,      // Karşılama
  happy,         // Mutlu
  celebrating,   // Kutlama
  thinking,      // Düşünüyor
  encouraging,   // Cesaretlendirici
  sad,           // Üzgün
  sleeping,      // Uyuyor
  excited,       // Heyecanlı
}

/// Her ruh haline göre doğru mascot görseli
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

/// Mascot mesaj yardımcısı - duruma göre rastgele mesajlar döndürür
class MascotHelper {
  static final _random = Random();

  /// Zamana göre karşılama mesajı
  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 6) {
      return _pick(['Gece kuşu! 🦉', 'Bu saatte mi? Helal! 🌙', 'Gece gece kod mu okuyoruz? 😴']);
    } else if (hour < 12) {
      return _pick(['Günaydın! ☀️', 'Güne kodla başla! 🌅', 'Sabah enerjisiyle devam! 💪']);
    } else if (hour < 18) {
      return _pick(['Merhaba! 👋', 'İyi günler! ☀️', 'Öğleden sonra challenge? 🔥']);
    } else {
      return _pick(['İyi akşamlar! 🌆', 'Akşam antrenmanı! 💪', 'Gece sınavı mı? Haydi! 🌙']);
    }
  }

  /// Zamana göre karşılama mood'u
  static MascotMood getGreetingMood() {
    final hour = DateTime.now().hour;
    if (hour < 6) return MascotMood.sleeping;
    return MascotMood.greeting;
  }

  /// Doğru cevap mesajları
  static String getCorrectMessage() {
    return _pick([
      'Harikasın! 🎉',
      'Tam isabet! 🎯',
      'Süpersin! 🔥',
      'Bravo! 👏',
      'Mükemmel! ⭐',
      'Kod sende! 💪',
      'Doğru bildin! 🥳',
      'Aferin ustam! 🏆',
      'Vay be, bildin! 🤩',
      'Seni tutamıyoruz! 🚀',
    ]);
  }

  /// Yanlış cevap mesajları
  static String getWrongMessage() {
    return _pick([
      'Olsun, bir dahakine! 💪',
      'Her hata bir öğrenme fırsatı! 📚',
      'Vazgeçme! 🔥',
      'Yaklaştın, devam et! 🎯',
      'Hata yapılır, öğrenilir! 💡',
      'Bir dahakine kesin bilirsin! 🌟',
      'Yılma, devam! 💪',
      'Öğrenmek böyle olur! 🧠',
      'Bu sefer olmadı ama yakın! 🤏',
      'Tekrar dene, başarabilirsin! ✨',
    ]);
  }

  /// Seri uyarı mesajları (bugün oynamadıysa)
  static String getStreakWarning() {
    return _pick([
      'Bugün henüz oynamadın! 🔥',
      'Serini koru, haydi! 🏃',
      'Bir quiz oyna, serini kayba! 💨',
      'Seni bekliyorum! 🐾',
      'Günlük antrenman vakti! ⏰',
      'Bugün pratik yaptın mı? 🤔',
    ]);
  }

  /// Sonuç yorumları (başarı oranına göre)
  static String getResultComment(int accuracy) {
    if (accuracy >= 90) {
      return _pick([
        'Efsane performans! 🏆',
        'Sen bir dahisin! 🧠',
        'Mükemmelsin, çılgın! 🤯',
        'Ustasın! Eline sağlık! 👑',
      ]);
    } else if (accuracy >= 70) {
      return _pick([
        'Çok iyi gidiyorsun! 🌟',
        'Harika performans! 💪',
        'Süper çalışma! 🔥',
        'Böyle devam! 🚀',
      ]);
    } else if (accuracy >= 50) {
      return _pick([
        'İyi gidiyorsun! 👍',
        'Fena değil, gelişiyorsun! 📈',
        'Biraz daha pratikle zirve! ⬆️',
        'Yarısını bildin, devam! 💪',
      ]);
    } else {
      return _pick([
        'Herkes baştan başlar! 🌱',
        'Pratik yapmaya devam et! 📚',
        'Düşme kalk, devam et! 💪',
        'Öğrenmek zaman alır, sabret! ⏳',
        'Her usta bir çıraktı! 🎓',
      ]);
    }
  }

  /// Bug Hunt özel mesajlar
  static String getBugHuntCorrect() {
    return _pick([
      'Bug avladın! 🐛',
      'Harika debugging! 🔍',
      'Bug senden kaçamaz! 🐞',
      'Debugger gibisin! 💻',
      'Bug bulma ustası! 🏆',
    ]);
  }

  static String getBugHuntWrong() {
    return _pick([
      'Bu bug kaçtı! 🐛',
      'Kodu dikkatli oku! 🔎',
      'Bir dahakine yakala! 🎯',
      'Bug gizlenmiş, tekrar bak! 👀',
    ]);
  }

  /// Time Attack özel mesajlar
  static String getTimeUpMessage() {
    return _pick([
      'Süre bitti! ⏱️',
      'Zamana yenildin! ⏰',
      'Biraz daha hızlı ol! 🏃',
      'Tick tock, bir dahakine! ⏳',
    ]);
  }

  /// AI soru yükleme bekleme mesajları
  static String getWaitingMessage() {
    return _pick([
      'Soru hazırlıyorum... 🤖',
      'Beyin çalışıyor... 🧠',
      'Senin için özel bir soru! ✨',
      'Biraz sabret, geliyor... ⏳',
    ]);
  }

  /// Günlük hedef tamamlandı mesajları
  static String getDailyGoalComplete() {
    return _pick([
      'Günlük hedef tamam! 🎉',
      'Bugünkü görev tamamlandı! ✅',
      'Bravo, hedefine ulaştın! 🏆',
      'Müthişsin, bugünlük tamam! 🌟',
    ]);
  }

  /// ELO rank yorumu
  static String getRankComment(int elo) {
    if (elo < 1100) {
      return _pick(['Bronze\'dan çıkman yakın! 🥉', 'Devam et, yükseliyorsun! 📈']);
    } else if (elo < 1300) {
      return _pick(['Silver seviyen harika! 🥈', 'Gold\'a az kaldı! ⭐']);
    } else if (elo < 1500) {
      return _pick(['Gold seviyedesin! 🥇', 'Platinum hedefle! 💎']);
    } else if (elo < 1800) {
      return _pick(['Platinum! Efsanesin! 💎', 'Diamond yakın! 💠']);
    } else {
      return _pick(['Diamond! Sen bir efsanesin! 💎', 'Zirvede kalma vakti! 👑']);
    }
  }

  static String _pick(List<String> options) {
    return options[_random.nextInt(options.length)];
  }
}

/// Maskot widget - ruh haline göre farklı görsel + konuşma balonu
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

/// Konuşma balonu widget
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

/// Home Screen'de kullanılacak büyük mascot karşılama kartı
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

/// Sonuç diyaloglarında mascot performans yorumu
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
