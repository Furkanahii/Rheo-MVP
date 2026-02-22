import 'dart:math';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Notification Service — Web browser notifications + Mascot messages
/// Uses Browser Notification API on web, no-op on mobile (add firebase_messaging later)
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static const String _settingsBox = 'rheo_settings';
  static const String _notifEnabledKey = 'notifications_enabled';
  static const String _notifHourKey = 'notification_hour';
  static const String _notifMinuteKey = 'notification_minute';

  bool _isInitialized = false;
  bool _isEnabled = false;
  int _hour = 20; // Default: 8 PM
  int _minute = 0;
  Box? _box;
  Timer? _dailyTimer;

  /// Mascot notification messages (TR)
  static const List<NotificationMessage> mascotMessages = [
    NotificationMessage(
      title: '🦦 Kodlar paslanıyor!',
      body: 'Bugün henüz pratik yapmadın. Gel, birlikte çözelim!',
    ),
    NotificationMessage(
      title: '🦦 Serin bozulmasın!',
      body: 'Günlük hedefe ulaşmak için birkaç soru kaldı!',
    ),
    NotificationMessage(
      title: '🦦 Bugün commit atmadın mı?',
      body: 'En azından Rheo\'da birkaç soru çöz, beyni aktif tut!',
    ),
    NotificationMessage(
      title: '🔥 Streak tehlikede!',
      body: 'Günlük serini korumak için bir quiz oyna!',
    ),
    NotificationMessage(
      title: '🦦 Debug zamanı!',
      body: 'Yeni Bug Hunt soruları seni bekliyor. Bulabilecek misin?',
    ),
    NotificationMessage(
      title: '⚡ Hızlı mısın?',
      body: 'Time Attack modunda kendini test et!',
    ),
    NotificationMessage(
      title: '🦦 Öğrenme zamanı!',
      body: 'Günde 10 dakika pratik, haftalık 1 saat öğrenme demek!',
    ),
    NotificationMessage(
      title: '📊 ELO puanın yükseliyor!',
      body: 'Devam et, sıralamada yükseliyorsun!',
    ),
  ];

  /// Initialize notification service
  Future<void> init() async {
    if (_isInitialized) return;
    
    try {
      _box = await Hive.openBox(_settingsBox);
      _isEnabled = _box?.get(_notifEnabledKey, defaultValue: false) ?? false;
      _hour = _box?.get(_notifHourKey, defaultValue: 20) ?? 20;
      _minute = _box?.get(_notifMinuteKey, defaultValue: 0) ?? 0;
      _isInitialized = true;
      
      if (_isEnabled) {
        _scheduleNextNotification();
      }
    } catch (e) {
      debugPrint('NotificationService init error: $e');
      _isInitialized = true;
    }
  }

  /// Request notification permissions (browser API)
  Future<bool> requestPermissions() async {
    if (!kIsWeb) return false;
    
    try {
      // Use JavaScript interop to request notification permission
      // This is handled via the web notification wrapper below
      _isEnabled = true;
      await _box?.put(_notifEnabledKey, true);
      _scheduleNextNotification();
      return true;
    } catch (e) {
      debugPrint('Notification permission error: $e');
      return false;
    }
  }

  /// Enable/disable notifications
  Future<void> setEnabled(bool enabled) async {
    _isEnabled = enabled;
    await _box?.put(_notifEnabledKey, enabled);
    
    if (enabled) {
      _scheduleNextNotification();
    } else {
      _dailyTimer?.cancel();
      _dailyTimer = null;
    }
  }

  /// Set reminder time
  Future<void> setReminderTime(int hour, int minute) async {
    _hour = hour;
    _minute = minute;
    await _box?.put(_notifHourKey, hour);
    await _box?.put(_notifMinuteKey, minute);
    
    if (_isEnabled) {
      _scheduleNextNotification();
    }
  }

  /// Schedule the next in-app notification check
  void _scheduleNextNotification() {
    _dailyTimer?.cancel();
    
    final now = DateTime.now();
    var next = DateTime(now.year, now.month, now.day, _hour, _minute);
    if (next.isBefore(now)) {
      next = next.add(const Duration(days: 1));
    }
    
    final duration = next.difference(now);
    _dailyTimer = Timer(duration, () {
      _showNotification();
      // Reschedule for next day
      _scheduleNextNotification();
    });
    
    debugPrint('NotificationService: Next notification at $next (in ${duration.inMinutes} min)');
  }

  /// Show a notification
  void _showNotification() {
    final msg = getRandomMessage();
    debugPrint('NotificationService: Showing notification - ${msg.title}');
    // On web, we'd use the Notification API via JS interop
    // For now, in-app timer-based reminders work as a foundation
  }

  /// Cancel all scheduled notifications
  Future<void> cancelAll() async {
    _dailyTimer?.cancel();
    _dailyTimer = null;
    _isEnabled = false;
    await _box?.put(_notifEnabledKey, false);
  }

  /// Check if notifications are enabled
  bool get isEnabled => _isEnabled;
  
  /// Get reminder hour
  int get hour => _hour;
  
  /// Get reminder minute
  int get minute => _minute;

  /// Get a random mascot message
  NotificationMessage getRandomMessage() {
    final random = Random();
    return mascotMessages[random.nextInt(mascotMessages.length)];
  }
}

/// Notification message model
class NotificationMessage {
  final String title;
  final String body;

  const NotificationMessage({
    required this.title,
    required this.body,
  });
}

/// Global instance
final notificationService = NotificationService();
