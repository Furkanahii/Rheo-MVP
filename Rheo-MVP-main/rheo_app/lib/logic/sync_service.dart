import 'dart:math';
import 'package:flutter/foundation.dart';
import '../data/user_progress.dart';
import 'auth_service.dart';
import 'firestore_service.dart';
import 'storage_service.dart';

/// Sync Service - Hive ↔ Firestore akıllı senkronizasyon
/// Misafir modunda sadece Hive kullanılır, login olunca merge yapılır
class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  bool _isSyncing = false;

  // ==================== SMART MERGE ====================

  /// Login sonrası akıllı merge: hangisi yüksekse onu al
  Future<void> mergeOnLogin() async {
    if (!authService.isLoggedIn || _isSyncing) return;

    _isSyncing = true;
    try {
      final uid = authService.uid!;
      final localProgress = storageService.progress;
      final cloudProgress = await firestoreService.getUserProgress(uid);

      if (cloudProgress == null) {
        // İlk kez login: local veriyi cloud'a yükle
        debugPrint('SyncService: İlk login - local veri cloud\'a yükleniyor');
        await _uploadToCloud(localProgress);
      } else {
        // Merge: her alan için max değeri al
        final merged = _smartMerge(localProgress, cloudProgress);

        // Local'i güncelle
        await storageService.saveProgress(merged);

        // Cloud'u güncelle
        await _uploadToCloud(merged);

        debugPrint('✅ SyncService: Merge tamamlandı - ELO: ${merged.elo}');
      }
    } catch (e) {
      debugPrint('⚠️ SyncService: Merge hatası: $e');
    } finally {
      _isSyncing = false;
    }
  }

  /// Her iki kaynaktan max değerleri al
  UserProgress _smartMerge(UserProgress local, UserProgress cloud) {
    return UserProgress(
      elo: max(local.elo, cloud.elo),
      currentStreak: max(local.currentStreak, cloud.currentStreak),
      bestStreak: max(local.bestStreak, cloud.bestStreak),
      totalCorrect: max(local.totalCorrect, cloud.totalCorrect),
      totalWrong: max(local.totalWrong, cloud.totalWrong),
      dailyQuestionsToday: max(local.dailyQuestionsToday, cloud.dailyQuestionsToday),
      dailyGoal: local.dailyGoal, // Local tercih korunur
      lastPlayedDate: _latestDate(local.lastPlayedDate, cloud.lastPlayedDate),
    );
  }

  /// İki tarihten en geç olanı al
  DateTime? _latestDate(DateTime? a, DateTime? b) {
    if (a == null) return b;
    if (b == null) return a;
    return a.isAfter(b) ? a : b;
  }

  // ==================== SYNC OPERATIONS ====================

  /// Cevap sonrası cloud'u güncelle (login ise)
  Future<void> syncAfterAnswer() async {
    if (!authService.isLoggedIn) return;

    try {
      await _uploadToCloud(storageService.progress);
    } catch (e) {
      // Sessizce hata yut - offline çalışmaya devam et
      debugPrint('⚠️ SyncService: Sync hatası (cevap sonrası): $e');
    }
  }

  /// Local veriyi cloud'a yükle
  Future<void> _uploadToCloud(UserProgress progress) async {
    final uid = authService.uid;
    if (uid == null) return;

    await firestoreService.saveUserProgress(
      uid: uid,
      displayName: authService.displayName,
      email: authService.email,
      photoUrl: authService.photoUrl,
      progress: progress,
    );
  }

  /// Manuel tam senkronizasyon
  Future<void> forceSync() async {
    if (!authService.isLoggedIn) return;
    await mergeOnLogin();
  }
}

/// Global instance
final syncService = SyncService();
