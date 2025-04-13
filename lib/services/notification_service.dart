import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    print('Initializing notification service...');
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        print('Notification clicked: ${details.payload}');
      },
    );

    // Request permissions for Android 13 and above
    final androidImplementation = _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (await androidImplementation?.areNotificationsEnabled() ?? false) {
      print('Notification permissions already granted');
    } else {
      print('Requesting notification permissions...');
      final granted = await androidImplementation?.requestNotificationsPermission() ?? false;
      print('Permission request result: $granted');
    }
  }

  Future<void> scheduleBookingNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    print('Attempting to schedule notification for booking $id');
    print('Original booking time: $scheduledDate');
    
    // Schedule notification 5 minutes before the booking
    final notificationTime = scheduledDate.subtract(const Duration(minutes: 5));
    print('Notification will be sent at: $notificationTime');
    
    // Don't schedule if the notification time is in the past
    if (notificationTime.isBefore(DateTime.now())) {
      print('Warning: Notification time is in the past, skipping notification');
      return;
    }

    try {
      // First try an immediate test notification
      final scheduledTz = tz.TZDateTime.from(notificationTime, tz.local);
      await _notifications.show(
        0, // Test notification ID
        'Booking Notification',
        'Successfully scheduled notification for: $scheduledTz',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'test_channel',
            'Test Channel',
            channelDescription: 'Channel for testing notifications',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
      print('Test notification sent');

      // Now schedule the actual notification
      await _notifications.zonedSchedule(
        id,
        title,
        body,
        scheduledTz,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'booking_channel',
            'Booking Notifications',
            channelDescription: 'Notifications for upcoming bookings',
            importance: Importance.max,
            priority: Priority.high,
            enableLights: true,
            enableVibration: true,
            playSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: 'booking_$id',
      );
      print('Successfully scheduled notification for: $scheduledTz');
    } catch (e) {
      print('Error with notification: $e');
      print('Stack trace: ${StackTrace.current}');
    }
  }

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}
