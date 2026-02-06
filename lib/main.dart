import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database/database.dart';
import 'services/notification_service.dart';
import 'services/light_sensor_service.dart';
import 'theme/app_theme.dart';
import 'screens/main_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database
  final database = AppDatabase();

  // Insert demo data on first run
  await database.insertDemoData();

  // Initialize notification service
  final notificationService = NotificationService(database);
  await notificationService.init();
  await notificationService.rescheduleAllTasks();

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: database),
        Provider<NotificationService>.value(value: notificationService),
        Provider<LightSensorService>.value(value: LightSensorService()),
      ],
      child: const OrchidLifeApp(),
    ),
  );
}

class OrchidLifeApp extends StatelessWidget {
  const OrchidLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OrchidLife',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const MainNavigation(),
      debugShowCheckedModeBanner: false,
    );
  }
}
