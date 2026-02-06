import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../database/database.dart';
import '../theme/app_theme.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Today'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Force rebuild
              (context as Element).markNeedsBuild();
            },
          ),
        ],
      ),
      body: StreamBuilder<List<CareTask>>(
        stream: db.watchTasksDueToday(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final tasks = snapshot.data ?? [];

          if (tasks.isEmpty) {
            return _buildEmptyState();
          }

          return _buildTaskList(context, db, tasks);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'All caught up!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No care tasks due today',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(BuildContext context, AppDatabase db, List<CareTask> tasks) {
    // Group tasks by orchid
    final Map<int, List<CareTask>> grouped = {};
    for (final task in tasks) {
      grouped.putIfAbsent(task.orchidId, () => []).add(task);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: grouped.length,
      itemBuilder: (context, index) {
        final orchidId = grouped.keys.elementAt(index);
        final orchidTasks = grouped[orchidId]!;

        return FutureBuilder<Orchid?>(
          future: db.getOrchidById(orchidId),
          builder: (context, orchidSnapshot) {
            final orchid = orchidSnapshot.data;
            final orchidName = orchid?.name ?? 'Unknown Orchid';

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Orchid header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen.withOpacity(0.1),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.local_florist,
                          color: AppTheme.primaryGreen,
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
                  ...orchidTasks.map((task) => _buildTaskTile(context, db, task, orchidName)),
                ],
              ),
            );
          },
        );
      },
    );
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
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(
        displayName,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isOverdue ? Colors.red : null,
        ),
      ),
      subtitle: Text(
        isOverdue
            ? 'Overdue - was due ${DateFormat.MMMd().format(task.nextDue)}'
            : 'Due ${_formatDueDate(task.nextDue)}',
        style: TextStyle(
          color: isOverdue ? Colors.red[300] : null,
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
            color: AppTheme.primaryGreen,
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
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$careTypeName completed for $orchidName'),
            backgroundColor: AppTheme.primaryGreen,
          ),
        );
      }
    }
  }

  Future<void> _snoozeTask(BuildContext context, AppDatabase db, CareTask task) async {
    await db.snoozeTask(task, 1);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task snoozed until tomorrow'),
        ),
      );
    }
  }
}
