// lib/screens/settings_screen.dart
// OrchidLife - Settings screen

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/database_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Map<String, int> _stats = {};
  bool _isLoadingStats = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final stats = await DatabaseService.isar.orchids.count();
      final taskStats = await DatabaseService.isar.careTasks.count();
      final logStats = await DatabaseService.isar.careLogs.count();

      setState(() {
        _stats = {
          'orchids': stats,
          'tasks': taskStats,
          'logs': logStats,
        };
        _isLoadingStats = false;
      });
    } catch (e) {
      setState(() => _isLoadingStats = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // App Info Header
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing6),
            color: AppTheme.primary.withOpacity(0.1),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.local_florist,
                    size: 48,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing3),
                Text(
                  'OrchidLife',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Version 1.0.0 (Phase 1)',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                ),
              ],
            ),
          ),

          // Stats
          if (!_isLoadingStats && _stats.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacing4),
              child: Row(
                children: [
                  _buildStatCard('🌿', '${_stats['orchids']}', 'Orchids'),
                  const SizedBox(width: AppTheme.spacing2),
                  _buildStatCard('📋', '${_stats['tasks']}', 'Tasks'),
                  const SizedBox(width: AppTheme.spacing2),
                  _buildStatCard('✅', '${_stats['logs']}', 'Logs'),
                ],
              ),
            ),
          ],

          const Divider(),

          // Notifications Section
          _buildSectionHeader('Notifications'),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('Notification Settings'),
            subtitle: const Text('Configure reminders'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Coming in Phase 2!')),
              );
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.schedule),
            title: const Text('Daily Summary'),
            subtitle: const Text('Get a morning overview'),
            value: false,
            onChanged: (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Coming in Phase 2!')),
              );
            },
          ),

          const Divider(),

          // Data Section
          _buildSectionHeader('Data'),
          ListTile(
            leading: const Icon(Icons.backup_outlined),
            title: const Text('Backup & Restore'),
            subtitle: const Text('Save your data'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Coming in Phase 4!')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: AppTheme.statusOverdue),
            title: const Text('Clear All Data'),
            subtitle: const Text('Delete all orchids and history'),
            onTap: () => _showClearDataDialog(),
          ),

          const Divider(),

          // About Section
          _buildSectionHeader('About'),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About OrchidLife'),
            onTap: () => _showAboutDialog(),
          ),
          ListTile(
            leading: const Icon(Icons.star_outline),
            title: const Text('Rate the App'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Coming when we launch!')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.feedback_outlined),
            title: const Text('Send Feedback'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Coming soon!')),
              );
            },
          ),

          const SizedBox(height: AppTheme.spacing8),

          // Footer
          Center(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacing4),
              child: Text(
                'Made with 💚 for orchid lovers',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
              ),
            ),
          ),

          const SizedBox(height: AppTheme.spacing8),
        ],
      ),
    );
  }

  Widget _buildStatCard(String emoji, String value, String label) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacing4),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
              ),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacing4,
        AppTheme.spacing4,
        AppTheme.spacing4,
        AppTheme.spacing1,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppTheme.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Future<void> _showClearDataDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text(
          'This will permanently delete all your orchids, care tasks, and history. '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.statusOverdue,
            ),
            child: const Text('Delete Everything'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final isar = DatabaseService.isar;
        await isar.writeTxn(() async {
          await isar.clear();
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('All data cleared'),
              backgroundColor: AppTheme.statusCompleted,
            ),
          );
          _loadStats();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: AppTheme.statusOverdue,
            ),
          );
        }
      }
    }
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.local_florist, color: AppTheme.primary),
            ),
            const SizedBox(width: 12),
            const Text('OrchidLife'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Version 1.0.0 (Phase 1)'),
            const SizedBox(height: 12),
            Text(
              'Smart orchid care reminders with light meter and AI-powered help.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'Current Features:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            const Text('• Orchid profiles with photos'),
            const Text('• Care task scheduling'),
            const Text('• Today view with due tasks'),
            const Text('• Quick reference guides'),
            const SizedBox(height: 16),
            Text(
              'Coming Soon:',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              '• Lux meter\n• AI plant doctor\n• Notifications\n• Care history',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
