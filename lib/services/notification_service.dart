import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../database/database.dart';

class NotificationService {
  final AppDatabase _db;
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  NotificationService(this._db);

  Future<void> init() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.local);

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(initSettings);
  }

  Future<bool> requestPermissions() async {
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
    final displayName = _careTypeDisplayName(careTypeName);

    const androidDetails = AndroidNotificationDetails(
      'orchidlife_care',
      'Care Reminders',
      channelDescription: 'Reminders for orchid care tasks',
      importance: Importance.high,
      priority: Priority.high,
    );

    await _plugin.zonedSchedule(
      task.id,
      'Time to ${displayName.toLowerCase()}',
      '$orchidName needs ${displayName.toLowerCase()}ing',
      scheduledDate,
      const NotificationDetails(android: androidDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelTaskNotification(int taskId) async {
    await _plugin.cancel(taskId);
  }

  Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
  }

  Future<void> rescheduleAllTasks() async {
    await _plugin.cancelAll();
    final tasks = await _db.getAllEnabledTasks();
    for (final task in tasks) {
      await scheduleTaskNotification(task);
    }
  }

  static String _careTypeDisplayName(String careType) {
    switch (careType.toLowerCase()) {
      case 'water':
        return 'Water';
      case 'fertilize':
        return 'Fertilize';
      case 'mist':
        return 'Mist';
      case 'inspect':
        return 'Inspect';
      case 'repot':
        return 'Repot';
      case 'prune':
        return 'Prune';
      default:
        return careType;
    }
  }
}
