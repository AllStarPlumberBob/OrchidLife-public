import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_10y.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../database/database.dart';
import '../theme/app_theme.dart';

class NotificationService {
  final AppDatabase _db;
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  NotificationService(this._db);

  Future<void> init() async {
    tz.initializeTimeZones();
    _setLocalTimezone();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );
    await _plugin.initialize(initSettings);
  }

  /// Determine the device's local timezone and set it for the tz library.
  /// tz.initializeTimeZones() loads the database but does NOT set tz.local,
  /// so we must find a matching timezone by UTC offset.
  void _setLocalTimezone() {
    final offsetMs = DateTime.now().timeZoneOffset.inMilliseconds;
    for (final location in tz.timeZoneDatabase.locations.values) {
      if (location.currentTimeZone.offset == offsetMs) {
        tz.setLocalLocation(location);
        return;
      }
    }
    // Fallback to UTC if no match found
    tz.setLocalLocation(tz.getLocation('UTC'));
  }

  Future<bool> requestPermissions() async {
    if (Platform.isIOS) {
      final iosPlugin = _plugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      final granted = await iosPlugin?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    // Android 13+ (API 33) requires POST_NOTIFICATIONS permission
    final notifStatus = await Permission.notification.request();
    if (!notifStatus.isGranted) return false;

    // Android 12+ (API 31) requires exact alarm permission
    final alarmStatus = await Permission.scheduleExactAlarm.request();
    return alarmStatus.isGranted;
  }

  Future<void> scheduleTaskNotification(CareTask task) async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool('notifications_enabled') ?? true;
    if (!enabled) return;

    final scheduledDate = tz.TZDateTime(
      tz.local,
      task.nextDue.year,
      task.nextDue.month,
      task.nextDue.day,
      task.notifyHour,
      task.notifyMinute,
    );

    // Skip if the scheduled time is in the past
    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) return;

    // Look up orchid name for the notification body
    final orchid = await _db.getOrchidById(task.orchidId);
    final orchidName = orchid?.name ?? 'Your orchid';
    final careTypeName = task.careType.name;
    final displayName = AppTheme.getCareTypeDisplayName(careTypeName);
    final gerund = _careTypeGerund(careTypeName);

    const androidDetails = AndroidNotificationDetails(
      'orchidlife_care',
      'Care Reminders',
      channelDescription: 'Reminders for orchid care tasks',
      importance: Importance.high,
      priority: Priority.high,
    );
    const darwinDetails = DarwinNotificationDetails();

    try {
      await _plugin.zonedSchedule(
        task.id,
        'Time to ${displayName.toLowerCase()}',
        '$orchidName needs $gerund',
        scheduledDate,
        const NotificationDetails(android: androidDetails, iOS: darwinDetails),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      debugPrint('Failed to schedule task notification ${task.id}: $e');
    }
  }

  Future<void> cancelTaskNotification(int taskId) async {
    await _plugin.cancel(taskId);
  }

  Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
  }

  Future<void> scheduleDrainNotification({
    required int sessionId,
    required List<int> orchidIds,
    required DateTime drainAt,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool('notifications_enabled') ?? true;
    if (!enabled) return;

    // Resolve orchid names
    final names = <String>[];
    for (final id in orchidIds) {
      final orchid = await _db.getOrchidById(id);
      if (orchid != null) names.add(orchid.name);
    }
    final body = names.isEmpty
        ? 'Your orchids are ready to be drained'
        : '${names.join(' and ')} ${names.length == 1 ? 'is' : 'are'} ready to be drained';

    final scheduledDate = tz.TZDateTime.from(drainAt, tz.local);
    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) return;

    final androidDetails = AndroidNotificationDetails(
      'orchidlife_soak_alarm',
      'Soak Timer Alarm',
      channelDescription: 'Alarm when orchid soaking is complete',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 500, 250, 500, 250, 500, 250, 500]),
      ongoing: true,
      autoCancel: false,
      category: AndroidNotificationCategory.alarm,
      fullScreenIntent: true,
      audioAttributesUsage: AudioAttributesUsage.alarm,
    );
    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
    );

    // Use negative sessionId to avoid collision with positive task IDs
    try {
      await _plugin.zonedSchedule(
        -sessionId,
        'Time to drain!',
        body,
        scheduledDate,
        NotificationDetails(android: androidDetails, iOS: darwinDetails),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      debugPrint('Failed to schedule drain notification for session $sessionId: $e');
    }
  }

  Future<void> cancelDrainNotification(int sessionId) async {
    await _plugin.cancel(-sessionId);
  }

  Future<void> rescheduleAllTasks() async {
    try {
      await _plugin.cancelAll();
    } catch (e) {
      debugPrint('Failed to cancel existing notifications: $e');
    }
    final tasks = await _db.getAllEnabledTasks();
    for (final task in tasks) {
      await scheduleTaskNotification(task);
    }
  }

  static String _careTypeGerund(String careType) {
    switch (careType.toLowerCase()) {
      case 'water':
        return 'watering';
      case 'fertilize':
        return 'fertilizing';
      case 'mist':
        return 'misting';
      case 'inspect':
        return 'inspection';
      case 'repot':
        return 'repotting';
      case 'prune':
        return 'pruning';
      default:
        return 'care';
    }
  }
}
