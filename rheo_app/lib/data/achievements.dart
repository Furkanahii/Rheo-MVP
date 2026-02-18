import 'package:flutter/material.dart';

/// Achievement definition
class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final int colorValue;
  final bool Function(AchievementProgress) unlockCondition;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.colorValue,
    required this.unlockCondition,
  });
}

/// Progress data for checking achievements
class AchievementProgress {
  final int totalQuestions;
  final int totalCorrect;
  final int elo;
  final int bestStreak;
  final int currentStreak;

  const AchievementProgress({
    required this.totalQuestions,
    required this.totalCorrect,
    required this.elo,
    required this.bestStreak,
    required this.currentStreak,
  });
}

/// All available achievements
class Achievements {
  static final List<Achievement> all = [
    // --- Giriş serileri ---
    Achievement(
      id: 'streak_7',
      title: 'Haftalık Seri',
      description: '1 hafta aralıksız giriş yap',
      icon: Icons.local_fire_department_rounded,
      colorValue: 0xFFFF9800,
      unlockCondition: (p) => p.bestStreak >= 7,
    ),
    Achievement(
      id: 'streak_30',
      title: 'Aylık Seri',
      description: '1 ay aralıksız giriş yap',
      icon: Icons.whatshot_rounded,
      colorValue: 0xFFE91E63,
      unlockCondition: (p) => p.bestStreak >= 30,
    ),
    Achievement(
      id: 'streak_90',
      title: '3 Aylık Seri',
      description: '3 ay aralıksız giriş yap',
      icon: Icons.bolt_rounded,
      colorValue: 0xFF9C27B0,
      unlockCondition: (p) => p.bestStreak >= 90,
    ),
    Achievement(
      id: 'streak_365',
      title: 'Yıllık Seri',
      description: '1 yıl aralıksız giriş yap',
      icon: Icons.auto_awesome_rounded,
      colorValue: 0xFFFFD700,
      unlockCondition: (p) => p.bestStreak >= 365,
    ),

    // --- Soru serileri ---
    Achievement(
      id: 'questions_10',
      title: '10 Seri',
      description: '10 seriye ulaş',
      icon: Icons.speed_rounded,
      colorValue: 0xFF2196F3,
      unlockCondition: (p) => p.bestStreak >= 10,
    ),
    Achievement(
      id: 'questions_100',
      title: '100 Seri',
      description: '100 seriye ulaş',
      icon: Icons.rocket_launch_rounded,
      colorValue: 0xFF00BCD4,
      unlockCondition: (p) => p.bestStreak >= 100,
    ),
    Achievement(
      id: 'questions_1000',
      title: '1000 Seri',
      description: '1000 seriye ulaş',
      icon: Icons.military_tech_rounded,
      colorValue: 0xFF4CAF50,
      unlockCondition: (p) => p.bestStreak >= 1000,
    ),

    // --- Doğru cevaplar ---
    Achievement(
      id: 'correct_10',
      title: '10 Doğru',
      description: '10 soruyu doğru cevapla',
      icon: Icons.check_circle_rounded,
      colorValue: 0xFF4CAF50,
      unlockCondition: (p) => p.totalCorrect >= 10,
    ),
    Achievement(
      id: 'correct_100',
      title: '100 Doğru',
      description: '100 soruyu doğru cevapla',
      icon: Icons.verified_rounded,
      colorValue: 0xFF2196F3,
      unlockCondition: (p) => p.totalCorrect >= 100,
    ),
    Achievement(
      id: 'correct_1000',
      title: '1000 Doğru',
      description: '1000 soruyu doğru cevapla',
      icon: Icons.workspace_premium_rounded,
      colorValue: 0xFFFFD700,
      unlockCondition: (p) => p.totalCorrect >= 1000,
    ),
  ];

  /// Get unlocked achievements
  static List<Achievement> getUnlocked(AchievementProgress progress) {
    return all.where((a) => a.unlockCondition(progress)).toList();
  }

  /// Get locked achievements
  static List<Achievement> getLocked(AchievementProgress progress) {
    return all.where((a) => !a.unlockCondition(progress)).toList();
  }

  /// Get unlock count
  static int getUnlockedCount(AchievementProgress progress) {
    return all.where((a) => a.unlockCondition(progress)).length;
  }
}
