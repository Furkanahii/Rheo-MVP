import 'dart:math';

/// ELO Rating Calculator
/// Based on chess ELO system adapted for quiz questions
class EloCalculator {
  /// Starting ELO for new users
  static const int startingElo = 1000;
  
  /// K-factor based on question difficulty
  static int getKFactor(int difficulty) {
    switch (difficulty) {
      case 1: return 16;  // Easy - smaller changes
      case 2: return 24;  // Medium
      case 3: return 32;  // Hard - bigger changes
      default: return 24;
    }
  }

  /// Get question ELO based on difficulty
  static int getQuestionElo(int difficulty) {
    switch (difficulty) {
      case 1: return 800;   // Easy
      case 2: return 1000;  // Medium
      case 3: return 1200;  // Hard
      default: return 1000;
    }
  }

  /// Calculate expected score (probability of correct answer)
  static double expectedScore(int userElo, int questionElo) {
    return 1.0 / (1.0 + pow(10, (questionElo - userElo) / 400.0));
  }

  /// Calculate new ELO after answering a question
  static int calculateNewElo({
    required int currentElo,
    required int questionDifficulty,
    required bool isCorrect,
  }) {
    final questionElo = getQuestionElo(questionDifficulty);
    final k = getKFactor(questionDifficulty);
    final expected = expectedScore(currentElo, questionElo);
    
    final actual = isCorrect ? 1.0 : 0.0;
    final change = (k * (actual - expected)).round();
    
    // Prevent ELO from going below 100
    return max(100, currentElo + change);
  }

  /// Get difficulty level based on user ELO
  /// Returns recommended difficulty (1, 2, or 3)
  static int getRecommendedDifficulty(int userElo) {
    if (userElo < 900) return 1;       // Easy
    if (userElo < 1100) return 2;      // Medium
    return 3;                          // Hard
  }

  /// Get ELO rank title
  static String getRankTitle(int elo) {
    if (elo < 200) return 'Çaylak';
    if (elo < 400) return 'Yükselen';
    if (elo < 600) return 'Deneyimli';
    if (elo < 800) return 'Uzman';
    if (elo < 1000) return 'Usta';
    return 'Üstat';
  }

  /// Get ELO rank color (as hex value for UI)
  static int getRankColor(int elo) {
    if (elo < 200) return 0xFFE6E212;   // Yellow — Çaylak
    if (elo < 400) return 0xFFD99800;   // Orange — Yükselen
    if (elo < 600) return 0xFFFF00EA;   // Magenta — Deneyimli
    if (elo < 800) return 0xFF416FF0;   // Blue — Uzman
    if (elo < 1000) return 0xFFAA09DB;  // Purple — Usta
    return 0xFFE61600;                   // Red — Üstat
  }

  /// Get rank emoji/icon for a given ELO
  static String getRankEmoji(int elo) {
    if (elo < 200) return '🌱';   // Çaylak
    if (elo < 400) return '📈';   // Yükselen
    if (elo < 600) return '💡';   // Deneyimli
    if (elo < 800) return '🎯';   // Uzman
    if (elo < 1000) return '⚡';  // Usta
    return '👑';                   // Üstat
  }
}
