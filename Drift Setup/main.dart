import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database/database.dart';
import 'theme/app_theme.dart';
import 'screens/main_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize database
  final database = AppDatabase();
  
  // Insert demo data on first run
  await database.insertDemoData();
  
  runApp(
    Provider<AppDatabase>.value(
      value: database,
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
