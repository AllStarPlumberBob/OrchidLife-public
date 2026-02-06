import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/database.dart';
import '../services/notification_service.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _isTogglingNotifications = false; // Prevent race condition
  TimeOfDay _defaultNotifyTime = const TimeOfDay(hour: 9, minute: 0);
  int _defaultWaterInterval = 7;
  int _defaultFertilizeInterval = 30;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      _defaultNotifyTime = TimeOfDay(
        hour: prefs.getInt('notify_hour') ?? 9,
        minute: prefs.getInt('notify_minute') ?? 0,
      );
      _defaultWaterInterval = prefs.getInt('default_water_interval') ?? 7;
      _defaultFertilizeInterval = prefs.getInt('default_fertilize_interval') ?? 30;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', _notificationsEnabled);
    await prefs.setInt('notify_hour', _defaultNotifyTime.hour);
    await prefs.setInt('notify_minute', _defaultNotifyTime.minute);
    await prefs.setInt('default_water_interval', _defaultWaterInterval);
    await prefs.setInt('default_fertilize_interval', _defaultFertilizeInterval);
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Notifications section
          _buildSectionHeader('Notifications'),
          SwitchListTile(
            title: const Text('Enable Notifications'),
            subtitle: Text(_isTogglingNotifications
                ? 'Updating...'
                : 'Get reminders for care tasks'),
            value: _notificationsEnabled,
            onChanged: _isTogglingNotifications
                ? null  // Disable during async operation
                : (value) async {
                    setState(() => _isTogglingNotifications = true);
                    try {
                      final notif = Provider.of<NotificationService>(context, listen: false);
                      if (value) {
                        final granted = await notif.requestPermissions();
                        if (!granted) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Notification permission denied')),
                            );
                          }
                          return;
                        }
                        if (mounted) setState(() => _notificationsEnabled = true);
                        await _saveSettings();
                        await notif.rescheduleAllTasks();
                      } else {
                        if (mounted) setState(() => _notificationsEnabled = false);
                        await _saveSettings();
                        await notif.cancelAllNotifications();
                      }
                    } finally {
                      if (mounted) setState(() => _isTogglingNotifications = false);
                    }
                  },
            activeColor: AppTheme.primaryGreen,
          ),
          ListTile(
            title: const Text('Default Notification Time'),
            subtitle: Text(_defaultNotifyTime.format(context)),
            trailing: const Icon(Icons.chevron_right),
            enabled: _notificationsEnabled,
            onTap: _notificationsEnabled ? _selectNotifyTime : null,
          ),
          const Divider(),

          // Default intervals section
          _buildSectionHeader('Default Care Intervals'),
          ListTile(
            title: const Text('Watering'),
            subtitle: Text('Every $_defaultWaterInterval days'),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.waterBlue.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.water_drop, color: AppTheme.waterBlue),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _selectInterval('water'),
          ),
          ListTile(
            title: const Text('Fertilizing'),
            subtitle: Text('Every $_defaultFertilizeInterval days'),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.fertilizerOrange.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.eco, color: AppTheme.fertilizerOrange),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _selectInterval('fertilize'),
          ),
          const Divider(),

          // Data management section
          _buildSectionHeader('Data Management'),
          ListTile(
            title: const Text('Clear Demo Data'),
            subtitle: const Text('Remove the demo orchid and its data'),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.cleaning_services, color: Colors.orange),
            ),
            onTap: () => _clearDemoData(context, db),
          ),
          ListTile(
            title: const Text('Export Data'),
            subtitle: const Text('Coming soon'),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.download, color: Colors.blue),
            ),
            enabled: false,
          ),
          const Divider(),

          // About section
          _buildSectionHeader('About'),
          ListTile(
            title: const Text('OrchidLife'),
            subtitle: const Text('Version 1.0.0'),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.local_florist, color: AppTheme.primaryGreen),
            ),
          ),
          ListTile(
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.open_in_new),
            onTap: () {
              // TODO: Open privacy policy
            },
          ),
          ListTile(
            title: const Text('Send Feedback'),
            trailing: const Icon(Icons.email),
            onTap: () {
              // TODO: Open email
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryGreen,
        ),
      ),
    );
  }

  Future<void> _selectNotifyTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _defaultNotifyTime,
    );
    if (picked != null) {
      setState(() => _defaultNotifyTime = picked);
      await _saveSettings();
      final notif = Provider.of<NotificationService>(context, listen: false);
      await notif.rescheduleAllTasks();
    }
  }

  Future<void> _selectInterval(String type) async {
    final currentValue = type == 'water' ? _defaultWaterInterval : _defaultFertilizeInterval;
    final controller = TextEditingController(text: '$currentValue');

    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${type == 'water' ? 'Watering' : 'Fertilizing'} Interval'),
        content: Row(
          children: [
            const Text('Every '),
            SizedBox(
              width: 60,
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                autofocus: true,
              ),
            ),
            const Text(' days'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final value = int.tryParse(controller.text);
              if (value != null && value > 0) {
                Navigator.pop(context, value);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() {
        if (type == 'water') {
          _defaultWaterInterval = result;
        } else {
          _defaultFertilizeInterval = result;
        }
      });
      _saveSettings();
    }
  }

  Future<void> _clearDemoData(BuildContext context, AppDatabase db) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Demo Data'),
        content: const Text('This will remove the demo orchid and all its care history. This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await db.clearDemoData();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Demo data cleared')),
        );
      }
    }
  }
}
