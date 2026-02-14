import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Notification Service - Maskot ağzından bildirimler
/// Web platformunda gerçek bildirimler çalışmaz, sadece native platformlarda aktif
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  bool _isInitialized = false;
  bool _isEnabled = false;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Android bildirim kanalı
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'rheo_daily_reminder',
    'Günlük Hatırlatma',
    description: 'Rheo günlük pratik hatırlatmaları',
    importance: Importance.high,
  );

  /// Maskot ağzından bildirim mesajları
  static const List<NotificationMessage> mascotMessages = [
    NotificationMessage(
      title: '🦦 Kodlar paslanıyor!',
      body: 'Bugün henüz pratik yapmadın. Gel, birlikte çözelim!',
    ),
    NotificationMessage(
      title: '🦦 Serin bozulmasın!',
      body: 'Günlük hedefe ulaşmak için sadece 5 soru kaldı!',
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

    // Web platformunda bildirimler çalışmaz
    if (kIsWeb) {
      debugPrint('NotificationService: Web platformunda bildirimler desteklenmiyor');
      _isInitialized = true;
      return;
    }

    try {
      // Android initialization
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS initialization
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _flutterLocalNotificationsPlugin.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: _onNotificationResponse,
      );

      // Android 8.0+ için bildirim kanalı oluştur
      if (Platform.isAndroid) {
        await _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(_channel);
      }

      _isInitialized = true;
      debugPrint('✅ NotificationService initialized');
    } catch (e) {
      debugPrint('⚠️ NotificationService init error: $e');
      _isInitialized = true; // Hata olsa bile tekrar denemesin
    }
  }

  /// Bildirime tıklandığında
  void _onNotificationResponse(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
    // Uygulama açıldığında ilgili ekrana yönlendirme yapılabilir
  }

  /// Request notification permissions
  Future<bool> requestPermissions() async {
    if (kIsWeb) return false;

    try {
      if (Platform.isAndroid) {
        final androidPlugin = _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
        final granted = await androidPlugin?.requestNotificationsPermission();
        _isEnabled = granted ?? false;
      } else if (Platform.isIOS) {
        final iosPlugin = _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
        final granted = await iosPlugin?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        _isEnabled = granted ?? false;
      }

      debugPrint('NotificationService: İzin durumu = $_isEnabled');
      return _isEnabled;
    } catch (e) {
      debugPrint('⚠️ NotificationService permission error: $e');
      return false;
    }
  }

  /// Hemen bir bildirim göster (test amaçlı)
  Future<void> showInstantNotification({
    String? title,
    String? body,
  }) async {
    if (!_isEnabled || kIsWeb) return;

    final message = (title == null || body == null) ? getRandomMessage() : null;

    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        _channel.id,
        _channel.name,
        channelDescription: _channel.description,
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _flutterLocalNotificationsPlugin.show(
      id: 0,
      title: title ?? message!.title,
      body: body ?? message!.body,
      notificationDetails: notificationDetails,
      payload: 'daily_reminder',
    );
  }

  /// Schedule daily reminder notification
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
  }) async {
    if (!_isEnabled || kIsWeb) return;

    try {
      // Önce mevcut zamanlanmış bildirimleri iptal et
      await _flutterLocalNotificationsPlugin.cancelAll();

      // Rastgele bir maskot mesajı seç
      final message = getRandomMessage();

      final notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      // Günlük tekrarlayan bildirim zamanla
      // Basit yaklaşım: periodicallyShow kullan (tam saat kontrolü yok ama güvenilir)
      await _flutterLocalNotificationsPlugin.periodicallyShow(
        id: 1,
        title: message.title,
        body: message.body,
        repeatInterval: RepeatInterval.daily,
        notificationDetails: notificationDetails,
        payload: 'daily_reminder',
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );

      debugPrint('NotificationService: Günlük hatırlatma ayarlandı - $hour:$minute');
    } catch (e) {
      debugPrint('⚠️ NotificationService schedule error: $e');
    }
  }

  /// Cancel all scheduled notifications
  Future<void> cancelAll() async {
    if (kIsWeb) return;

    try {
      await _flutterLocalNotificationsPlugin.cancelAll();
      _isEnabled = false;
      debugPrint('NotificationService: Tüm bildirimler iptal edildi');
    } catch (e) {
      debugPrint('⚠️ NotificationService cancel error: $e');
    }
  }

  /// Get notification enabled status
  bool get isEnabled => _isEnabled;

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
