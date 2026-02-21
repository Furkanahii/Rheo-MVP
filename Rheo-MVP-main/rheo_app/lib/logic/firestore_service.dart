import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../data/user_progress.dart';

/// Firestore Service - Cloud veritabanı işlemleri
/// Kullanıcı profili CRUD ve leaderboard sorguları
class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Koleksiyon referansları
  CollectionReference get _usersCollection => _db.collection('users');

  // ==================== USER PROFILE ====================

  /// Kullanıcı profilini Firestore'a kaydet/güncelle
  Future<void> saveUserProgress({
    required String uid,
    required String displayName,
    required String email,
    String? photoUrl,
    required UserProgress progress,
  }) async {
    try {
      await _usersCollection.doc(uid).set({
        'displayName': displayName,
        'email': email,
        'photoUrl': photoUrl,
        'elo': progress.elo,
        'currentStreak': progress.currentStreak,
        'bestStreak': progress.bestStreak,
        'totalCorrect': progress.totalCorrect,
        'totalWrong': progress.totalWrong,
        'dailyQuestionsToday': progress.dailyQuestionsToday,
        'dailyGoal': progress.dailyGoal,
        'lastPlayedDate': progress.lastPlayedDate?.toIso8601String(),
        'lastSyncedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      debugPrint('✅ FirestoreService: Profil kaydedildi');
    } catch (e) {
      debugPrint('⚠️ FirestoreService: Kayıt hatası: $e');
    }
  }

  /// Kullanıcı profilini Firestore'dan oku
  Future<UserProgress?> getUserProgress(String uid) async {
    try {
      final doc = await _usersCollection.doc(uid).get();
      if (!doc.exists) return null;

      final data = doc.data() as Map<String, dynamic>;
      return UserProgress(
        elo: data['elo'] ?? 1000,
        currentStreak: data['currentStreak'] ?? 0,
        bestStreak: data['bestStreak'] ?? 0,
        totalCorrect: data['totalCorrect'] ?? 0,
        totalWrong: data['totalWrong'] ?? 0,
        dailyQuestionsToday: data['dailyQuestionsToday'] ?? 0,
        dailyGoal: data['dailyGoal'] ?? 5,
        lastPlayedDate: data['lastPlayedDate'] != null
            ? DateTime.parse(data['lastPlayedDate'])
            : null,
      );
    } catch (e) {
      debugPrint('⚠️ FirestoreService: Okuma hatası: $e');
      return null;
    }
  }

  // ==================== LEADERBOARD ====================

  /// Global Top N leaderboard verisi çek
  Future<List<LeaderboardData>> getLeaderboard({int limit = 10}) async {
    try {
      final snapshot = await _usersCollection
          .orderBy('elo', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs.asMap().entries.map((entry) {
        final data = entry.value.data() as Map<String, dynamic>;
        return LeaderboardData(
          rank: entry.key + 1,
          uid: entry.value.id,
          displayName: data['displayName'] ?? 'Bilinmeyen',
          elo: data['elo'] ?? 1000,
          streak: data['currentStreak'] ?? 0,
          photoUrl: data['photoUrl'],
        );
      }).toList();
    } catch (e) {
      debugPrint('⚠️ FirestoreService: Leaderboard hatası: $e');
      return [];
    }
  }

  /// Kullanıcının sıralamasını bul
  Future<int?> getUserRank(String uid) async {
    try {
      final userDoc = await _usersCollection.doc(uid).get();
      if (!userDoc.exists) return null;

      final userData = userDoc.data() as Map<String, dynamic>;
      final userElo = userData['elo'] ?? 1000;

      // Kullanıcıdan yüksek ELO'ya sahip kişi sayısı + 1
      final higherCount = await _usersCollection
          .where('elo', isGreaterThan: userElo)
          .count()
          .get();

      return (higherCount.count ?? 0) + 1;
    } catch (e) {
      debugPrint('⚠️ FirestoreService: Rank hatası: $e');
      return null;
    }
  }

  /// Toplam kullanıcı sayısı
  Future<int> getTotalUsers() async {
    try {
      final count = await _usersCollection.count().get();
      return count.count ?? 0;
    } catch (e) {
      return 0;
    }
  }
}

/// Leaderboard veri modeli
class LeaderboardData {
  final int rank;
  final String uid;
  final String displayName;
  final int elo;
  final int streak;
  final String? photoUrl;

  LeaderboardData({
    required this.rank,
    required this.uid,
    required this.displayName,
    required this.elo,
    required this.streak,
    this.photoUrl,
  });

  /// Avatar emoji (fotoğraf yoksa)
  String get avatarEmoji {
    final emojis = ['🦊', '🐍', '🐛', '👑', '🦦', '🧮', '⚙️', '🔍', '🌱', '🎮'];
    return emojis[rank % emojis.length];
  }
}

/// Global instance
final firestoreService = FirestoreService();
