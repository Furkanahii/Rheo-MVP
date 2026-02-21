import 'package:flutter/foundation.dart';
import 'auth_service.dart';
import 'firestore_service.dart';
import 'storage_service.dart';

/// Leaderboard Provider - Hibrit online/offline leaderboard
/// İnternet varsa Firestore'dan, yoksa local fallback
class LeaderboardProvider {
  static final LeaderboardProvider _instance = LeaderboardProvider._internal();
  factory LeaderboardProvider() => _instance;
  LeaderboardProvider._internal();

  List<LeaderboardData> _leaderboard = [];
  bool _isOnline = false;
  bool _isLoading = false;
  int? _userRank;
  int _totalUsers = 0;
  String? _errorMessage;

  // ==================== GETTERS ====================

  List<LeaderboardData> get leaderboard => _leaderboard;
  bool get isOnline => _isOnline;
  bool get isLoading => _isLoading;
  int? get userRank => _userRank;
  int get totalUsers => _totalUsers;
  String? get errorMessage => _errorMessage;

  // ==================== FETCH ====================

  /// Leaderboard verisini çek (online veya offline)
  Future<void> fetchLeaderboard() async {
    _isLoading = true;
    _errorMessage = null;

    try {
      // Firestore'dan çekmeyi dene
      final data = await firestoreService.getLeaderboard(limit: 10);

      if (data.isNotEmpty) {
        _leaderboard = data;
        _isOnline = true;
        _totalUsers = await firestoreService.getTotalUsers();

        // Kullanıcının sırasını bul
        if (authService.isLoggedIn && authService.uid != null) {
          _userRank = await firestoreService.getUserRank(authService.uid!);
        }

        debugPrint('✅ LeaderboardProvider: Online veri çekildi (${data.length} kayıt)');
      } else {
        _setOfflineMode();
      }
    } catch (e) {
      debugPrint('⚠️ LeaderboardProvider: Online fetch hatası: $e');
      _setOfflineMode();
    } finally {
      _isLoading = false;
    }
  }

  /// Offline moduna geç
  void _setOfflineMode() {
    _isOnline = false;
    _leaderboard = _getLocalLeaderboard();
    _userRank = null;
    _totalUsers = 0;
    _errorMessage = 'İnternet bağlantısı yok. Yerel veriler gösteriliyor.';
    debugPrint('LeaderboardProvider: Offline mod aktif');
  }

  /// Local fallback leaderboard (kullanıcının kendi skoru)
  List<LeaderboardData> _getLocalLeaderboard() {
    final progress = storageService.progress;
    return [
      LeaderboardData(
        rank: 1,
        uid: 'local',
        displayName: authService.isLoggedIn ? authService.displayName : 'Sen',
        elo: progress.elo,
        streak: progress.currentStreak,
      ),
    ];
  }
}

/// Global instance
final leaderboardProvider = LeaderboardProvider();
