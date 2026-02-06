/// User progress model for Hive storage
/// Stores ELO rating, streaks, and game statistics
class UserProgress {
  int elo;
  int currentStreak;
  int bestStreak;
  int totalCorrect;
  int totalWrong;
  DateTime? lastPlayedDate;

  UserProgress({
    this.elo = 1000,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.totalCorrect = 0,
    this.totalWrong = 0,
    this.lastPlayedDate,
  });

  /// Total questions answered
  int get totalQuestions => totalCorrect + totalWrong;

  /// Accuracy percentage
  double get accuracy => 
      totalQuestions > 0 ? (totalCorrect / totalQuestions) * 100 : 0;

  /// Check if played today
  bool get playedToday {
    if (lastPlayedDate == null) return false;
    final now = DateTime.now();
    return lastPlayedDate!.year == now.year &&
           lastPlayedDate!.month == now.month &&
           lastPlayedDate!.day == now.day;
  }

  /// Check if streak should be reset (missed a day)
  bool get shouldResetStreak {
    if (lastPlayedDate == null) return false;
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    
    // If last played was before yesterday, streak is broken
    return lastPlayedDate!.isBefore(
      DateTime(yesterday.year, yesterday.month, yesterday.day)
    );
  }

  /// Convert to Map for Hive storage
  Map<String, dynamic> toMap() {
    return {
      'elo': elo,
      'currentStreak': currentStreak,
      'bestStreak': bestStreak,
      'totalCorrect': totalCorrect,
      'totalWrong': totalWrong,
      'lastPlayedDate': lastPlayedDate?.toIso8601String(),
    };
  }

  /// Create from Map (Hive storage)
  factory UserProgress.fromMap(Map<dynamic, dynamic> map) {
    return UserProgress(
      elo: map['elo'] ?? 1000,
      currentStreak: map['currentStreak'] ?? 0,
      bestStreak: map['bestStreak'] ?? 0,
      totalCorrect: map['totalCorrect'] ?? 0,
      totalWrong: map['totalWrong'] ?? 0,
      lastPlayedDate: map['lastPlayedDate'] != null 
          ? DateTime.parse(map['lastPlayedDate']) 
          : null,
    );
  }
}
