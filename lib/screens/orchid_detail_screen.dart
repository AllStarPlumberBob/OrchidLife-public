import 'dart:io' show File;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' show Value;
import '../database/database.dart';
import '../services/notification_service.dart';
import '../theme/app_theme.dart';
import '../widgets/orchid_sliver_app_bar.dart';
import '../widgets/orchid_card.dart';
import '../widgets/page_transitions.dart';
import '../widgets/add_care_task_dialog.dart';
import 'add_edit_orchid_screen.dart';

class OrchidDetailScreen extends StatelessWidget {
  final int orchidId;

  const OrchidDetailScreen({super.key, required this.orchidId});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);

    return FutureBuilder<Orchid?>(
      future: db.getOrchidById(orchidId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final orchid = snapshot.data;
        if (orchid == null) {
          return const Scaffold(
            body: CustomScrollView(
              slivers: [
                OrchidSliverAppBar(
                  title: 'Not Found',
                  showBackButton: true,
                ),
                SliverFillRemaining(
                  child: Center(child: Text('Orchid not found')),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              OrchidSliverAppBar(
                title: orchid.name,
                showBackButton: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _editOrchid(context, orchid),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteOrchid(context, db, orchid),
                  ),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildInfoCard(orchid),
                    const SizedBox(height: 16),
                    _buildCareTasksSection(context, db),
                    const SizedBox(height: 16),
                    _buildCareHistorySection(context, db),
                    SizedBox(height: 32 + MediaQuery.of(context).padding.bottom),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoCard(Orchid orchid) {
    return OrchidCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                ),
                child: orchid.photoPath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                        child: Image.file(
                          File(orchid.photoPath!),
                          fit: BoxFit.cover,
                          width: 80,
                          height: 80,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.local_florist,
                            color: AppTheme.primary,
                            size: 40,
                          ),
                        ),
                      )
                    : const Icon(
                        Icons.local_florist,
                        color: AppTheme.primary,
                        size: 40,
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (orchid.variety != null)
                      Text(
                        orchid.variety!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    if (orchid.location != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16, color: AppTheme.textSecondary),
                          const SizedBox(width: 4),
                          Text(orchid.location!),
                        ],
                      ),
                    ],
                    if (orchid.dateAcquired != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16, color: AppTheme.textSecondary),
                          const SizedBox(width: 4),
                          Text('Since ${DateFormat.yMMMd().format(orchid.dateAcquired!)}'),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (orchid.notes != null && orchid.notes!.isNotEmpty) ...[
            const Divider(height: 24),
            Text(
              orchid.notes!,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCareTasksSection(BuildContext context, AppDatabase db) {
    return OrchidCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Care Schedule',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                onPressed: () => _addCareTask(context, db),
                icon: const Icon(Icons.add),
                label: const Text('Add'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          StreamBuilder<List<CareTask>>(
            stream: db.watchTasksForOrchid(orchidId),
            builder: (context, snapshot) {
              final tasks = snapshot.data ?? [];

              if (tasks.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'No care tasks set up yet',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                );
              }

              return Column(
                children: tasks.map((task) => _buildTaskTile(context, db, task)).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTaskTile(BuildContext context, AppDatabase db, CareTask task) {
    final careTypeName = task.careType.name;
    final color = AppTheme.getCareTypeColor(careTypeName);
    final icon = AppTheme.getCareTypeIcon(careTypeName);
    final displayName = task.customLabel ?? AppTheme.getCareTypeDisplayName(careTypeName);
    final isOverdue = task.enabled && task.nextDue.isBefore(DateTime.now());

    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withValues(alpha: task.enabled ? 0.15 : 0.08),
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        ),
        child: Icon(
          icon,
          color: task.enabled ? color : AppTheme.textSecondary,
        ),
      ),
      title: Text(
        displayName,
        style: TextStyle(
          color: task.enabled ? null : AppTheme.textSecondary,
          decoration: task.enabled ? null : TextDecoration.lineThrough,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Every ${task.intervalDays} days'),
          if (task.enabled)
            Text(
              isOverdue
                  ? 'Overdue! Due ${DateFormat.MMMd().format(task.nextDue)}'
                  : 'Next: ${DateFormat.MMMd().format(task.nextDue)}',
              style: TextStyle(
                color: isOverdue ? AppTheme.statusOverdue : AppTheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
      trailing: Switch(
        value: task.enabled,
        onChanged: (enabled) async {
          final notif = Provider.of<NotificationService>(context, listen: false);
          await db.updateCareTask(task.copyWith(enabled: enabled));
          if (enabled) {
            await notif.scheduleTaskNotification(task.copyWith(enabled: true));
          } else {
            await notif.cancelTaskNotification(task.id);
          }
        },
        activeTrackColor: AppTheme.primary,
      ),
    );
  }

  Widget _buildCareHistorySection(BuildContext context, AppDatabase db) {
    return OrchidCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Care History',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          StreamBuilder<List<CareLog>>(
            stream: db.watchLogsForOrchid(orchidId, limit: 10),
            builder: (context, snapshot) {
              final logs = snapshot.data ?? [];

              if (logs.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'No care history yet',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                );
              }

              return Column(
                children: logs.map((log) => _buildLogTile(log)).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLogTile(CareLog log) {
    final careTypeName = log.careType.name;
    final color = AppTheme.getCareTypeColor(careTypeName);
    final icon = AppTheme.getCareTypeIcon(careTypeName);
    final displayName = AppTheme.getCareTypeDisplayName(careTypeName);

    return ListTile(
      dense: true,
      leading: Icon(icon, color: color, size: 20),
      title: Text(
        log.skipped ? '$displayName (skipped)' : displayName,
        style: TextStyle(
          color: log.skipped ? AppTheme.textSecondary : null,
          fontStyle: log.skipped ? FontStyle.italic : null,
        ),
      ),
      subtitle: log.notes != null ? Text(log.notes!) : null,
      trailing: Text(
        DateFormat.MMMd().add_jm().format(log.completedAt),
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  void _editOrchid(BuildContext context, Orchid orchid) {
    Navigator.push(
      context,
      OrchidPageRoute(
        builder: (context) => AddEditOrchidScreen(orchid: orchid),
      ),
    );
  }

  Future<void> _deleteOrchid(BuildContext context, AppDatabase db, Orchid orchid) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Orchid'),
        content: Text('Are you sure you want to delete "${orchid.name}"? This will also delete all care history.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppTheme.statusOverdue),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      final notif = Provider.of<NotificationService>(context, listen: false);
      final tasks = await db.getTasksForOrchid(orchid.id);
      for (final task in tasks) {
        await notif.cancelTaskNotification(task.id);
      }
      await db.deleteOrchidAndRelated(orchid.id);
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${orchid.name} deleted')),
        );
      }
    }
  }

  Future<void> _addCareTask(BuildContext context, AppDatabase db) async {
    final notif = Provider.of<NotificationService>(context, listen: false);

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const AddCareTaskDialog(),
    );

    if (result != null) {
      final now = DateTime.now();
      final intervalDays = result['intervalDays'] as int;
      final firstDueDate = result['firstDueDate'] as DateTime?;
      final taskId = await db.insertCareTask(CareTasksCompanion.insert(
        orchidId: orchidId,
        careType: result['careType'] as CareType,
        intervalDays: intervalDays,
        nextDue: firstDueDate ?? now.add(Duration(days: intervalDays)),
        customLabel: Value(result['customLabel'] as String?),
      ));

      final newTask = await db.getCareTaskById(taskId);
      if (newTask != null) await notif.scheduleTaskNotification(newTask);
    }
  }
}

