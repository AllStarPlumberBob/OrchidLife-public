import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../database/database.dart';
import '../services/notification_service.dart';
import '../theme/app_theme.dart';
import '../widgets/floating_bottom_nav.dart';
import 'agenda_screen.dart';
import 'orchid_list_screen.dart';
import 'tools_screen.dart';
import 'settings_screen.dart';

class MainNavigation extends StatefulWidget {
  static final globalKey = GlobalKey<MainNavigationState>();
  MainNavigation() : super(key: globalKey);

  @override
  State<MainNavigation> createState() => MainNavigationState();
}

class MainNavigationState extends State<MainNavigation>
    with WidgetsBindingObserver {
  int _currentIndex = 0;
  StreamSubscription<String>? _notificationTapSub;

  void switchToTab(int index) {
    setState(() => _currentIndex = index);
  }

  final List<Widget> _screens = const [
    AgendaScreen(),
    OrchidListScreen(),
    ToolsScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Listen for notification taps (drain payloads → switch to agenda)
    _notificationTapSub = NotificationService.onNotificationTap.listen((payload) {
      if (payload.startsWith('drain:') && mounted) {
        setState(() => _currentIndex = 0);
      }
    });

    // Check for cold-start launch payload (buffered because broadcast stream
    // has no subscribers during main() when init() runs)
    final launchPayload = NotificationService.consumeLaunchPayload();
    if (launchPayload != null && launchPayload.startsWith('drain:')) {
      _currentIndex = 0;
    }

    // Request permissions and schedule notifications after first frame.
    // Also check for expired soak sessions (cold-start case — the app was
    // killed by Android while a timer was running).  didChangeAppLifecycleState
    // does NOT fire on cold start, so we must check here.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestPermissionsAndSchedule();
      _checkForReadyToDrainSessions();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _notificationTapSub?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkForReadyToDrainSessions();
    }
  }

  /// Mark any expired soak sessions in the DB, then switch to the agenda
  /// tab if any are ready to drain.  Runs on both cold-start (post-frame
  /// callback in initState) and warm resume (didChangeAppLifecycleState).
  Future<void> _checkForReadyToDrainSessions() async {
    try {
      final db = Provider.of<AppDatabase>(context, listen: false);
      // Ensure sessions that expired while backgrounded/killed are marked.
      await db.markExpiredSessionsReadyToDrain();
      final sessions = await db.getActiveSoakSessions();
      final hasReady = sessions.any((s) => s.status == SoakStatus.readyToDrain);
      if (hasReady && mounted) {
        setState(() => _currentIndex = 0);
      }
    } catch (e) {
      debugPrint('Soak session check error: $e');
    }
  }

  Future<void> _requestPermissionsAndSchedule() async {
    final notif = Provider.of<NotificationService>(context, listen: false);
    try {
      final granted = await notif.requestPermissions();
      if (granted) {
        await notif.rescheduleAllTasks();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Notification permissions needed for care reminders'),
            action: SnackBarAction(
              label: 'Settings',
              onPressed: () => openAppSettings(),
            ),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      debugPrint('Permission/scheduling error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final navTotalHeight = AppTheme.floatingNavHeight + AppTheme.floatingNavMarginB + bottomInset;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(bottom: navTotalHeight),
              child: IndexedStack(
                index: _currentIndex,
                children: _screens,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: FloatingBottomNav(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
            ),
          ),
        ],
      ),
    );
  }
}
