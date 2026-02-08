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
    const initSettings = InitializationSettings(android: androidSettings);
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

    await _plugin.zonedSchedule(
      task.id,
      'Time to ${displayName.toLowerCase()}',
      '$orchidName needs $gerund',
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
