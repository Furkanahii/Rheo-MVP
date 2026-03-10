import 'package:flutter/material.dart';
import 'app_strings.dart';

/// Achievement definition
class Achievement {
  final String id;
  final String Function() titleGetter;
  final String Function() descriptionGetter;
  final IconData icon;
  final int colorValue;
  final bool Function(AchievementProgress) unlockCondition;

  const Achievement({
    required this.id,
    required this.titleGetter,
    required this.descriptionGetter,
    required this.icon,
    required this.colorValue,
    required this.unlockCondition,
  });

  String get title => titleGetter();
  String get description => descriptionGetter();
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
    // ÔöÇÔöÇ Streak achievements ÔöÇÔöÇ
    Achievement(
      id: 'streak_7',
      titleGetter: () => S.yediGunSerisi,
      descriptionGetter: () => S.yediGunAciklama,
      icon: Icons.local_fire_department_rounded,
      colorValue: 0xFFE91E63,
      unlockCondition: (p) => p.bestStreak >= 7,
    ),
    Achievement(
      id: 'streak_30',
      titleGetter: () => S.otuzGunSerisi,
      descriptionGetter: () => S.otuzGunAciklama,
      icon: Icons.whatshot_rounded,
      colorValue: 0xFFFF5722,
      unlockCondition: (p) => p.bestStreak >= 30,
    ),
    Achievement(
      id: 'streak_90',
      titleGetter: () => S.doksanGunSerisi,
      descriptionGetter: () => S.doksanGunAciklama,
      icon: Icons.bolt_rounded,
      colorValue: 0xFFFF9800,
      unlockCondition: (p) => p.bestStreak >= 90,
    ),
    Achievement(
      id: 'streak_365',
      titleGetter: () => S.yilSerisi,
      descriptionGetter: () => S.yilAciklama,
      icon: Icons.star_rounded,
      colorValue: 0xFFFFEB3B,
      unlockCondition: (p) => p.bestStreak >= 365,
    ),

    // ÔöÇÔöÇ Question count achievements ÔöÇÔöÇ
    Achievement(
      id: 'questions_10',
      titleGetter: () => S.onSoru,
      descriptionGetter: () => S.onSoruAciklama,
      icon: Icons.quiz_rounded,
      colorValue: 0xFF4CAF50,
      unlockCondition: (p) => p.totalQuestions >= 10,
    ),
    Achievement(
      id: 'questions_100',
      titleGetter: () => S.yuzSoru,
      descriptionGetter: () => S.yuzSoruAciklama,
      icon: Icons.school_rounded,
      colorValue: 0xFF2196F3,
      unlockCondition: (p) => p.totalQuestions >= 100,
    ),
    Achievement(
      id: 'questions_1000',
      titleGetter: () => S.binSoru,
      descriptionGetter: () => S.binSoruAciklama,
      icon: Icons.military_tech_rounded,
      colorValue: 0xFF9C27B0,
      unlockCondition: (p) => p.totalQuestions >= 1000,
    ),

    // ÔöÇÔöÇ Correct answer achievements ÔöÇÔöÇ
    Achievement(
      id: 'correct_10',
      titleGetter: () => S.onDogru,
      descriptionGetter: () => S.onDogruAciklama,
      icon: Icons.check_circle_rounded,
      colorValue: 0xFF00BCD4,
      unlockCondition: (p) => p.totalCorrect >= 10,
    ),
    Achievement(
      id: 'correct_100',
      titleGetter: () => S.yuzDogru,
      descriptionGetter: () => S.yuzDogruAciklama,
      icon: Icons.verified_rounded,
      colorValue: 0xFF8BC34A,
      unlockCondition: (p) => p.totalCorrect >= 100,
    ),
    Achievement(
      id: 'correct_1000',
      titleGetter: () => S.binDogru,
      descriptionGetter: () => S.binDogruAciklama,
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