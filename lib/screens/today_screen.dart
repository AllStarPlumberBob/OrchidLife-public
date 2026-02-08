import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../database/database.dart';
import '../services/notification_service.dart';
import '../theme/app_theme.dart';
import '../widgets/orchid_sliver_app_bar.dart';
import '../widgets/empty_state.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  Key _refreshKey = UniqueKey();

  void _refresh() {
    setState(() => _refreshKey = UniqueKey());
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);

    return Scaffold(
      body: StreamBuilder<List<CareTask>>(
        key: _refreshKey,
        stream: db.watchTasksDueToday(),
        builder: (context, snapshot) {
          return CustomScrollView(
            slivers: [
              OrchidSliverAppBar(
                title: 'Today',
                actions: [
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _refresh,
                  ),
                ],
              ),
              if (snapshot.connectionState == ConnectionState.waiting)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (snapshot.hasError)
                SliverFillRemaining(
                  child: Center(child: Text('Error: ${snapshot.error}')),
                )
              else if ((snapshot.data ?? []).isEmpty)
                const SliverFillRemaining(
                  child: EmptyState(
                    icon: Icons.check_circle_outline,
                    title: 'All caught up!',
                    subtitle: 'No care tasks due today',
                  ),
                )
              else
                ..._buildTaskSlivers(context, db, snapshot.data!),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildTaskSlivers(BuildContext context, AppDatabase db, List<CareTask> tasks) {
    // Group tasks by orchid
    final Map<int, List<CareTask>> grouped = {};
    for (final task in tasks) {
      grouped.putIfAbsent(task.orchidId, () => []).add(task);
    }

    final slivers = <Widget>[];
    for (final entry in grouped.entries) {
      slivers.add(
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          sliver: SliverToBoxAdapter(
            child: FutureBuilder<Orchid?>(
              future: db.getOrchidById(entry.key),
              builder: (context, orchidSnapshot) {
                final orchid = orchidSnapshot.data;
                final orchidName = orchid?.name ?? 'Unknown Orchid';

                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Orchid header
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withValues(alpha: 0.08),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(AppTheme.radiusCard),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.local_florist,
                              color: AppTheme.primary,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                orchidName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Tasks
                      ...entry.value.map((task) => _buildTaskTile(context, db, task, orchidName)),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );
    }

    // Bottom spacing for floating nav
    slivers.add(const SliverPadding(padding: EdgeInsets.only(bottom: 16)));

    return slivers;
  }

  Widget _buildTaskTile(BuildContext context, AppDatabase db, CareTask task, String orchidName) {
    final isOverdue = task.nextDue.isBefore(DateTime.now());
    final careTypeName = task.careType.name;
    final color = AppTheme.getCareTypeColor(careTypeName);
    final icon = AppTheme.getCareTypeIcon(careTypeName);
    final displayName = task.customLabel ?? AppTheme.getCareTypeDisplayName(careTypeName);

    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(
        displayName,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isOverdue ? AppTheme.statusOverdue : null,
        ),
      ),
      subtitle: Text(
        isOverdue
            ? 'Overdue - was due ${DateFormat.MMMd().format(task.nextDue)}'
            : 'Due ${_formatDueDate(task.nextDue)}',
        style: TextStyle(
          color: isOverdue ? AppTheme.statusOverdue.withValues(alpha: 0.7) : AppTheme.textSecondary,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Snooze button
          IconButton(
            icon: const Icon(Icons.snooze),
            tooltip: 'Snooze 1 day',
            onPressed: () => _snoozeTask(context, db, task),
          ),
          // Complete button
          IconButton(
            icon: const Icon(Icons.check_circle),
            color: AppTheme.primary,
            tooltip: 'Mark complete',
            onPressed: () => _completeTask(context, db, task, orchidName),
          ),
        ],
      ),
    );
  }

  String _formatDueDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDate = DateTime(date.year, date.month, date.day);

    if (dueDate == today) {
      return 'today';
    } else if (dueDate == today.add(const Duration(days: 1))) {
      return 'tomorrow';
    } else {
      return DateFormat.MMMd().format(date);
    }
  }

  Future<void> _completeTask(BuildContext context, AppDatabase db, CareTask task, String orchidName) async {
    final careTypeName = AppTheme.getCareTypeDisplayName(task.careType.name);
    final notif = Provider.of<NotificationService>(context, listen: false);

    // Show quick completion dialog
    final notes = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Complete $careTypeName'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('For: $orchidName'),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                hintText: 'Add any observations...',
              ),
              maxLines: 2,
              onSubmitted: (value) => Navigator.pop(context, value),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, ''),
            child: const Text('Complete'),
          ),
        ],
      ),
    );

    if (notes != null) {
      await db.completeTask(task, notes: notes.isEmpty ? null : notes);

      await notif.cancelTaskNotification(task.id);
      final updated = await db.getCareTaskById(task.id);
      if (updated != null) await notif.scheduleTaskNotification(updated);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$careTypeName completed for $orchidName'),
            backgroundColor: AppTheme.primary,
          ),
        );
      }
    }
  }

  Future<void> _snoozeTask(BuildContext context, AppDatabase db, CareTask task) async {
    final notif = Provider.of<NotificationService>(context, listen: false);

    await db.snoozeTask(task, 1);

    await notif.cancelTaskNotification(task.id);
    final updated = await db.getCareTaskById(task.id);
    if (updated != null) await notif.scheduleTaskNotification(updated);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task snoozed until tomorrow'),
        ),
      );
    }
  }
}
