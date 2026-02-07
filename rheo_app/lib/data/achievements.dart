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
    Achievement(
      id: 'first_step',
      title: 'İlk Adım',
      description: 'İlk soruyu çöz',
      icon: Icons.rocket_launch_rounded,
      colorValue: 0xFF4CAF50,
      unlockCondition: (p) => p.totalQuestions >= 1,
    ),
    Achievement(
      id: 'warming_up',
      title: 'Isınma Turu',
      description: '10 soru çöz',
      icon: Icons.whatshot_rounded,
      colorValue: 0xFFFF9800,
      unlockCondition: (p) => p.totalQuestions >= 10,
    ),
    Achievement(
      id: 'dedicated',
      title: 'Azimli',
      description: '50 soru çöz',
      icon: Icons.sports_score_rounded,
      colorValue: 0xFF2196F3,
      unlockCondition: (p) => p.totalQuestions >= 50,
    ),
    Achievement(
      id: 'century',
      title: 'Yüzlük',
      description: '100 soru çöz',
      icon: Icons.military_tech_rounded,
      colorValue: 0xFF9C27B0,
      unlockCondition: (p) => p.totalQuestions >= 100,
    ),
    Achievement(
      id: 'perfect_ten',
      title: 'Mükemmel 10',
      description: '10 doğru cevap ver',
      icon: Icons.check_circle_rounded,
      colorValue: 0xFF00BCD4,
      unlockCondition: (p) => p.totalCorrect >= 10,
    ),
    Achievement(
      id: 'streak_3',
      title: 'Üçlü Seri',
      description: '3 gün üst üste oyna',
      icon: Icons.local_fire_department_rounded,
      colorValue: 0xFFE91E63,
      unlockCondition: (p) => p.bestStreak >= 3,
    ),
    Achievement(
      id: 'streak_7',
      title: 'Haftalık Seri',
      description: '7 gün üst üste oyna',
      icon: Icons.bolt_rounded,
      colorValue: 0xFFFFEB3B,
      unlockCondition: (p) => p.bestStreak >= 7,
    ),
    Achievement(
      id: 'silver_rank',
      title: 'Gümüş Rütbe',
      description: '1000 ELO\'ya ulaş',
      icon: Icons.emoji_events_rounded,
      colorValue: 0xFFC0C0C0,
      unlockCondition: (p) => p.elo >= 1000,
    ),
    Achievement(
      id: 'gold_rank',
      title: 'Altın Rütbe',
      description: '1500 ELO\'ya ulaş',
      icon: Icons.emoji_events_rounded,
      colorValue: 0xFFFFD700,
      unlockCondition: (p) => p.elo >= 1500,
    ),
    Achievement(
      id: 'bug_hunter',
      title: 'Bug Hunter',
      description: '25 doğru cevap ver',
      icon: Icons.bug_report_rounded,
      colorValue: 0xFF8BC34A,
      unlockCondition: (p) => p.totalCorrect >= 25,
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
