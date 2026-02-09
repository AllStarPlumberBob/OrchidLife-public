import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database/database.dart';
import 'services/notification_service.dart';
import 'services/light_sensor_service.dart';
import 'theme/app_theme.dart';
import 'screens/main_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Enable edge-to-edge rendering (transparent system nav bar)
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  // Initialize database
  final database = AppDatabase();

  try {
    // Insert demo data on first run only
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool('demo_data_inserted') ?? false)) {
      await database.insertDemoData();
      await prefs.setBool('demo_data_inserted', true);
    }
  } catch (e) {
    debugPrint('Demo data initialization error: $e');
  }

  // Initialize notification service (timezone + plugin only, no scheduling yet)
  final notificationService = NotificationService(database);
  try {
    await notificationService.init();
  } catch (e) {
    debugPrint('Notification initialization error: $e');
  }

  // Mark any expired soak sessions as ready to drain (e.g., app was closed mid-soak)
  try {
    await database.markExpiredSessionsReadyToDrain();
  } catch (e) {
    debugPrint('Soak session cleanup error: $e');
  }

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
