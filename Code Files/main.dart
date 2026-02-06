// lib/main.dart
// OrchidLife - Smart orchid care app

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'services/database_service.dart';
import 'data/demo_data.dart';
import 'theme/app_theme.dart';
import 'screens/main_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database
  try {
    await DatabaseService.getInstance();
    debugPrint('✅ Database initialized');
  } catch (e) {
    debugPrint('❌ Failed to initialize database: $e');
  }

  runApp(const OrchidLifeApp());
}

class OrchidLifeApp extends StatefulWidget {
  const OrchidLifeApp({super.key});

  @override
  State<OrchidLifeApp> createState() => _OrchidLifeAppState();
}

class _OrchidLifeAppState extends State<OrchidLifeApp> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Check if first launch
      final prefs = await SharedPreferences.getInstance();
      final isFirstLaunch = prefs.getBool('first_launch') ?? true;

      if (isFirstLaunch) {
        // Create demo data for new users
        await DemoData.createDemoData();
        await prefs.setBool('first_launch', false);
        debugPrint('✅ Demo data created for first launch');
      }
    } catch (e) {
      debugPrint('Error during initialization: $e');
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OrchidLife',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: _isLoading ? const _LoadingScreen() : const MainNavigation(),
    );
  }
}

/// Loading screen shown during initialization
class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App icon placeholder
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.local_florist,
                size: 64,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(
              color: AppTheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'OrchidLife',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Growing happiness...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
