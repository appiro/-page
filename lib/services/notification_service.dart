import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  // Initialize notification service
  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    try {
      final initialized = await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      _initialized = initialized ?? false;
      
      if (_initialized) {
        await _requestPermissions();
      }
    } catch (e) {
      debugPrint('Failed to initialize notifications: $e');
    }
  }

  // Request notification permissions (iOS)
  Future<void> _requestPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      await _notifications
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      final androidImplementation = _notifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      await androidImplementation?.requestNotificationsPermission();
    }
  }

  // Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
    // Handle navigation based on payload if needed
  }

  // Show timer completion notification
  Future<void> showTimerNotification(int seconds) async {
    if (!_initialized) {
      await initialize();
    }

    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    final timeText = minutes > 0 
        ? '$minutes分${secs > 0 ? '$secs秒' : ''}'
        : '$secs秒';

    const androidDetails = AndroidNotificationDetails(
      'timer_channel',
      'Interval Timer',
      channelDescription: 'Notifications for interval timer completion',
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: true,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _notifications.show(
        0, // Notification ID
        'タイマー終了',
        '$timeTextのインターバルが終了しました',
        notificationDetails,
        payload: 'timer_complete',
      );
    } catch (e) {
      debugPrint('Failed to show notification: $e');
    }
  }

  // Cancel all notifications
  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  // Cancel specific notification
  Future<void> cancel(int id) async {
    await _notifications.cancel(id);
  }
}
