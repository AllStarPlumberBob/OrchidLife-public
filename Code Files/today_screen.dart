// lib/screens/today_screen.dart
// OrchidLife - Today screen showing care tasks due

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/orchid.dart';
import '../models/care_task.dart';
import '../services/database_service.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  List<_TaskWithOrchid> _dueTasks = [];
  List<_TaskWithOrchid> _upcomingTasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() => _isLoading = true);

    try {
      final isar = DatabaseService.isar;
      
      // Get all active care tasks
      final tasks = await isar.careTasks
          .filter()
          .isActiveEqualTo(true)
          .findAll();

      // Get orchids for these tasks
      final orchidIds = tasks.map((t) => t.orchidId).toSet();
      final orchids = await isar.orchids
          .filter()
          .anyOf(orchidIds.toList(), (q, id) => q.idEqualTo(id))
          .findAll();
      
      final orchidMap = {for (var o in orchids) o.id: o};

      // Separate into due today and upcoming
      final due = <_TaskWithOrchid>[];
      final upcoming = <_TaskWithOrchid>[];

      for (final task in tasks) {
        final orchid = orchidMap[task.orchidId];
        if (orchid == null || !orchid.isActive) continue;

        final taskWithOrchid = _TaskWithOrchid(task: task, orchid: orchid);

        if (task.isDueToday) {
          due.add(taskWithOrchid);
        } else if (task.daysUntilDue <= 7 && task.daysUntilDue > 0) {
          upcoming.add(taskWithOrchid);
        }
      }

      // Sort by urgency
      due.sort((a, b) => (a.task.nextDue ?? DateTime.now())
          .compareTo(b.task.nextDue ?? DateTime.now()));
      upcoming.sort((a, b) => (a.task.nextDue ?? DateTime.now())
          .compareTo(b.task.nextDue ?? DateTime.now()));

      setState(() {
        _dueTasks = due;
        _upcomingTasks = upcoming;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading tasks: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _markTaskDone(_TaskWithOrchid item) async {
    try {
      final isar = DatabaseService.isar;
      
      // Update task
      item.task.markCompleted();
      
      await isar.writeTxn(() async {
        await isar.careTasks.put(item.task);
      });

      // Reload
      _loadTasks();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.task.careType.emoji} ${item.orchid.displayName} - Done!'),
            backgroundColor: AppTheme.statusCompleted,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error marking task done: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Today'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTasks,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadTasks,
              child: _buildContent(),
            ),
    );
  }

  Widget _buildContent() {
    if (_dueTasks.isEmpty && _upcomingTasks.isEmpty) {
      return _buildEmptyState();
    }

    return ListView(
      padding: const EdgeInsets.all(AppTheme.screenPadding),
      children: [
        // Header
        _buildGreeting(),
        const SizedBox(height: AppTheme.spacing6),

        // Due Today
        if (_dueTasks.isNotEmpty) ...[
          _buildSectionHeader(
            'Needs Care Today',
            '${_dueTasks.length} ${_dueTasks.length == 1 ? 'task' : 'tasks'}',
            AppTheme.statusNeedsCare,
          ),
          const SizedBox(height: AppTheme.spacing3),
          ..._dueTasks.map((item) => _buildTaskCard(item, isUrgent: true)),
          const SizedBox(height: AppTheme.spacing6),
        ],

        // Upcoming
        if (_upcomingTasks.isNotEmpty) ...[
          _buildSectionHeader(
            'Coming Up',
            'Next 7 days',
            AppTheme.statusUpcoming,
          ),
          const SizedBox(height: AppTheme.spacing3),
          ..._upcomingTasks.map((item) => _buildTaskCard(item, isUrgent: false)),
        ],

        const SizedBox(height: AppTheme.spacing8),
      ],
    );
  }

  Widget _buildGreeting() {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good morning!';
    } else if (hour < 17) {
      greeting = 'Good afternoon!';
    } else {
      greeting = 'Good evening!';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '🌿 $greeting',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        if (_dueTasks.isNotEmpty)
          Text(
            '${_dueTasks.length} ${_dueTasks.length == 1 ? 'orchid needs' : 'orchids need'} your attention',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          )
        else
          Text(
            'All caught up! Your orchids are happy 🌸',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.statusCompleted,
                ),
          ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String subtitle, Color color) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: AppTheme.spacing3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTaskCard(_TaskWithOrchid item, {required bool isUrgent}) {
    final task = item.task;
    final orchid = item.orchid;

    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        side: isUrgent
            ? BorderSide(
                color: task.isOverdue
                    ? AppTheme.statusOverdue.withOpacity(0.5)
                    : AppTheme.statusNeedsCare.withOpacity(0.5),
                width: 1,
              )
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                // Color indicator
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.fromHex(orchid.colorTag).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: Center(
                    child: Text(
                      task.careType.emoji,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spacing3),
                // Task info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        orchid.displayName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '${task.careType.displayName}${task.isOverdue ? ' • Overdue!' : ''}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: task.isOverdue
                                  ? AppTheme.statusOverdue
                                  : AppTheme.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
                // Days indicator
                if (!isUrgent)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacing3,
                      vertical: AppTheme.spacing1,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.statusUpcoming.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                    ),
                    child: Text(
                      task.daysUntilDue == 1
                          ? 'Tomorrow'
                          : 'In ${task.daysUntilDue} days',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.statusUpcoming,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
              ],
            ),

            // Action buttons (only for urgent tasks)
            if (isUrgent) ...[
              const SizedBox(height: AppTheme.spacing4),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _markTaskDone(item),
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('Done'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.statusCompleted,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacing2),
                  OutlinedButton(
                    onPressed: () {
                      // TODO: Skip functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Skip coming soon!')),
                      );
                    },
                    child: const Text('Skip'),
                  ),
                  const SizedBox(width: AppTheme.spacing2),
                  OutlinedButton(
                    onPressed: () {
                      // TODO: Snooze functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Snooze coming soon!')),
                      );
                    },
                    child: const Text('Later'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.statusCompleted.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline,
                size: 64,
                color: AppTheme.statusCompleted,
              ),
            ),
            const SizedBox(height: AppTheme.spacing6),
            Text(
              'All caught up! 🎉',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppTheme.spacing2),
            Text(
              'No care tasks due today.\nYour orchids are happy!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper class to pair task with its orchid
class _TaskWithOrchid {
  final CareTask task;
  final Orchid orchid;

  _TaskWithOrchid({required this.task, required this.orchid});
}
