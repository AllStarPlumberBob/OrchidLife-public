import 'dart:async';
import 'package:drift/drift.dart' show Value;
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
      body: StreamBuilder<List<SoakSession>>(
        stream: db.watchActiveSoakSessions(),
        builder: (context, soakSnapshot) {
          final activeSessions = soakSnapshot.data ?? [];

          return StreamBuilder<List<CareTask>>(
            key: _refreshKey,
            stream: db.watchTasksDueToday(),
            builder: (context, taskSnapshot) {
              return FutureBuilder<Set<int>>(
                future: db.getActiveSessionTaskIds(),
                builder: (context, activeIdsSnapshot) {
                  final activeTaskIds = activeIdsSnapshot.data ?? {};

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
                      // Active soak session cards at the top
                      if (activeSessions.isNotEmpty)
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => _SoakSessionCard(
                                session: activeSessions[index],
                                db: db,
                                onCompleted: _refresh,
                              ),
                              childCount: activeSessions.length,
                            ),
                          ),
                        ),
                      if (taskSnapshot.connectionState == ConnectionState.waiting)
                        const SliverFillRemaining(
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else if (taskSnapshot.hasError)
                        SliverFillRemaining(
                          child: Center(child: Text('Error: ${taskSnapshot.error}')),
                        )
                      else if ((taskSnapshot.data ?? []).isEmpty && activeSessions.isEmpty)
                        const SliverFillRemaining(
                          child: EmptyState(
                            icon: Icons.check_circle_outline,
                            title: 'All caught up!',
                            subtitle: 'No care tasks due today',
                          ),
                        )
                      else if ((taskSnapshot.data ?? []).isNotEmpty)
                        ..._buildTaskSlivers(context, db, taskSnapshot.data!, activeTaskIds),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  List<Widget> _buildTaskSlivers(
    BuildContext context,
    AppDatabase db,
    List<CareTask> tasks,
    Set<int> activeTaskIds,
  ) {
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
                      ...entry.value.map((task) =>
                          _buildTaskTile(context, db, task, orchidName, activeTaskIds)),
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

  Widget _buildTaskTile(
    BuildContext context,
    AppDatabase db,
    CareTask task,
    String orchidName,
    Set<int> activeTaskIds,
  ) {
    final isOverdue = task.nextDue.isBefore(DateTime.now());
    final careTypeName = task.careType.name;
    final color = AppTheme.getCareTypeColor(careTypeName);
    final icon = AppTheme.getCareTypeIcon(careTypeName);
    final displayName = task.customLabel ?? AppTheme.getCareTypeDisplayName(careTypeName);
    final isWater = task.careType == CareType.water;
    final isSoaking = activeTaskIds.contains(task.id);

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
          color: isOverdue && !isSoaking ? AppTheme.statusOverdue : null,
        ),
      ),
      subtitle: isSoaking
          ? Text(
              'Soaking...',
              style: TextStyle(color: AppTheme.waterBlue.withValues(alpha: 0.8)),
            )
          : Text(
              isOverdue
                  ? 'Overdue - was due ${DateFormat.MMMd().format(task.nextDue)}'
                  : 'Due ${_formatDueDate(task.nextDue)}',
              style: TextStyle(
                color: isOverdue
                    ? AppTheme.statusOverdue.withValues(alpha: 0.7)
                    : AppTheme.textSecondary,
              ),
            ),
      trailing: isSoaking
          ? Chip(
              label: const Text('Soaking'),
              backgroundColor: AppTheme.waterBlue.withValues(alpha: 0.15),
              labelStyle: const TextStyle(color: AppTheme.waterBlue, fontSize: 12),
              visualDensity: VisualDensity.compact,
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Snooze button
                IconButton(
                  icon: const Icon(Icons.snooze),
                  tooltip: 'Snooze 1 day',
                  onPressed: () => _snoozeTask(context, db, task),
                ),
                // Water tasks get "Start Soak", others get checkmark
                if (isWater)
                  IconButton(
                    icon: const Icon(Icons.water_drop),
                    color: AppTheme.waterBlue,
                    tooltip: 'Start soak',
                    onPressed: () => _startSoak(context, db, task, orchidName),
                  )
                else
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

  Future<void> _startSoak(
    BuildContext context,
    AppDatabase db,
    CareTask tappedTask,
    String tappedOrchidName,
  ) async {
    // Get all water tasks due today
    final allTasks = await db.getTasksDueToday();
    final waterTasks = allTasks.where((t) => t.careType == CareType.water).toList();

    // Get active task IDs to exclude already-soaking tasks
    final activeIds = await db.getActiveSessionTaskIds();
    final availableTasks = waterTasks.where((t) => !activeIds.contains(t.id)).toList();

    if (availableTasks.isEmpty) return;

    // Build orchid info for each task
    final taskOrchids = <int, Orchid>{};
    for (final task in availableTasks) {
      if (!taskOrchids.containsKey(task.orchidId)) {
        final orchid = await db.getOrchidById(task.orchidId);
        if (orchid != null) taskOrchids[task.orchidId] = orchid;
      }
    }

    // Group by soak duration
    final grouped = <int, List<_SoakCandidate>>{};
    for (final task in availableTasks) {
      final orchid = taskOrchids[task.orchidId];
      if (orchid == null) continue;
      final duration = orchid.soakDurationMinutes;
      grouped.putIfAbsent(duration, () => []).add(_SoakCandidate(
        task: task,
        orchid: orchid,
        selected: true,
      ));
    }

    // Pre-check the tapped orchid's group, uncheck others
    final tappedOrchid = taskOrchids[tappedTask.orchidId];
    final tappedDuration = tappedOrchid?.soakDurationMinutes ?? 15;
    for (final entry in grouped.entries) {
      if (entry.key != tappedDuration) {
        for (final candidate in entry.value) {
          candidate.selected = false;
        }
      }
    }

    if (!context.mounted) return;

    // Show bottom sheet
    final result = await showModalBottomSheet<Map<int, List<_SoakCandidate>>>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _SoakSelectionSheet(grouped: grouped),
    );

    if (result == null || !context.mounted) return;

    final notif = Provider.of<NotificationService>(context, listen: false);

    // Create one session per duration group (only for groups with selected orchids)
    for (final entry in result.entries) {
      final duration = entry.key;
      final selected = entry.value.where((c) => c.selected).toList();
      if (selected.isEmpty) continue;

      final taskIds = selected.map((c) => c.task.id).toList();
      final orchidIds = selected.map((c) => c.orchid.id).toList();

      final sessionId = await db.createSoakSession(
        taskIds: taskIds,
        orchidIds: orchidIds,
        durationMinutes: duration,
        notificationId: 0, // Will be set via notification
      );

      final drainAt = DateTime.now().add(Duration(minutes: duration));
      await notif.scheduleDrainNotification(
        sessionId: sessionId,
        orchidIds: orchidIds,
        drainAt: drainAt,
      );
    }

    _refresh();
  }

  Future<void> _completeTask(
    BuildContext context,
    AppDatabase db,
    CareTask task,
    String orchidName,
  ) async {
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

// ============================================================
// Soak candidate data class for selection sheet
// ============================================================

class _SoakCandidate {
  final CareTask task;
  final Orchid orchid;
  bool selected;

  _SoakCandidate({
    required this.task,
    required this.orchid,
    required this.selected,
  });
}

// ============================================================
// Bottom sheet for selecting orchids to soak
// ============================================================

class _SoakSelectionSheet extends StatefulWidget {
  final Map<int, List<_SoakCandidate>> grouped;

  const _SoakSelectionSheet({required this.grouped});

  @override
  State<_SoakSelectionSheet> createState() => _SoakSelectionSheetState();
}

class _SoakSelectionSheetState extends State<_SoakSelectionSheet> {
  @override
  Widget build(BuildContext context) {
    final sortedDurations = widget.grouped.keys.toList()..sort();
    final hasSelection = widget.grouped.values
        .any((list) => list.any((c) => c.selected));

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppTheme.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              'Start Soaking',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            const Text(
              'Select orchids to soak together',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 16),
            for (final duration in sortedDurations) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.waterBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Text(
                  '$duration minutes',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.waterBlue,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              ...widget.grouped[duration]!.map((candidate) => CheckboxListTile(
                    title: Text(candidate.orchid.name),
                    subtitle: candidate.orchid.variety != null
                        ? Text(candidate.orchid.variety!)
                        : null,
                    value: candidate.selected,
                    activeColor: AppTheme.waterBlue,
                    onChanged: (value) {
                      setState(() => candidate.selected = value ?? false);
                    },
                    dense: true,
                    controlAffinity: ListTileControlAffinity.leading,
                  )),
              const SizedBox(height: 8),
            ],
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: hasSelection
                  ? () => Navigator.pop(context, widget.grouped)
                  : null,
              icon: const Icon(Icons.water_drop),
              label: const Text('Start Soaking'),
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.waterBlue,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// Active soak session card with countdown timer
// ============================================================

class _SoakSessionCard extends StatefulWidget {
  final SoakSession session;
  final AppDatabase db;
  final VoidCallback onCompleted;

  const _SoakSessionCard({
    required this.session,
    required this.db,
    required this.onCompleted,
  });

  @override
  State<_SoakSessionCard> createState() => _SoakSessionCardState();
}

class _SoakSessionCardState extends State<_SoakSessionCard> {
  Timer? _timer;
  Duration _remaining = Duration.zero;
  List<SoakSessionTaskWithOrchid> _sessionTasks = [];
  bool _isReadyToDrain = false;

  @override
  void initState() {
    super.initState();
    _loadSessionTasks();
    _updateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateRemaining());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _loadSessionTasks() async {
    final tasks = await widget.db.getTasksForSoakSession(widget.session.id);
    if (mounted) setState(() => _sessionTasks = tasks);
  }

  void _updateRemaining() {
    final endTime = widget.session.startedAt
        .add(Duration(minutes: widget.session.durationMinutes));
    final now = DateTime.now();
    final diff = endTime.difference(now);

    if (mounted) {
      setState(() {
        _remaining = diff.isNegative ? Duration.zero : diff;
        if (diff.isNegative && widget.session.status == SoakStatus.soaking && !_isReadyToDrain) {
          _isReadyToDrain = true;
          _markReadyToDrain();
        } else if (widget.session.status == SoakStatus.readyToDrain) {
          _isReadyToDrain = true;
        }
      });
    }
  }

  Future<void> _markReadyToDrain() async {
    await (widget.db.update(widget.db.soakSessions)
          ..where((s) => s.id.equals(widget.session.id)))
        .write(const SoakSessionsCompanion(
      status: Value(SoakStatus.readyToDrain),
    ));
  }

  Future<void> _completeSoak() async {
    if (_sessionTasks.isEmpty) return;

    final notif = Provider.of<NotificationService>(context, listen: false);

    // If only one orchid, complete directly
    if (_sessionTasks.length == 1) {
      await widget.db.completeSoakSession(widget.session.id);
      await notif.cancelDrainNotification(widget.session.id);

      // Reschedule notifications for completed tasks
      for (final st in _sessionTasks) {
        await notif.cancelTaskNotification(st.careTask.id);
        final updated = await widget.db.getCareTaskById(st.careTask.id);
        if (updated != null) await notif.scheduleTaskNotification(updated);
      }

      widget.onCompleted();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Watering completed for ${_sessionTasks.first.orchid.name}'),
            backgroundColor: AppTheme.primary,
          ),
        );
      }
      return;
    }

    // Multiple orchids — show confirmation with checkboxes
    final selected = Map<int, bool>.fromEntries(
        _sessionTasks.map((st) => MapEntry(st.careTask.id, true)));

    if (!mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: const Text('Drain & Complete'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Select which orchids are done draining:'),
              const SizedBox(height: 8),
              ..._sessionTasks.map((st) => CheckboxListTile(
                    title: Text(st.orchid.name),
                    value: selected[st.careTask.id],
                    activeColor: AppTheme.primary,
                    onChanged: (value) {
                      setDialogState(() => selected[st.careTask.id] = value ?? false);
                    },
                    dense: true,
                    controlAffinity: ListTileControlAffinity.leading,
                  )),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Complete'),
            ),
          ],
        ),
      ),
    );

    if (confirmed != true || !mounted) return;

    final excludeIds = selected.entries
        .where((e) => !e.value)
        .map((e) => e.key)
        .toSet();

    await widget.db.completeSoakSession(widget.session.id, excludeTaskIds: excludeIds);
    await notif.cancelDrainNotification(widget.session.id);

    // Reschedule notifications for completed tasks
    for (final st in _sessionTasks) {
      if (!excludeIds.contains(st.careTask.id)) {
        await notif.cancelTaskNotification(st.careTask.id);
        final updated = await widget.db.getCareTaskById(st.careTask.id);
        if (updated != null) await notif.scheduleTaskNotification(updated);
      }
    }

    widget.onCompleted();
    if (mounted) {
      final completedCount = selected.values.where((v) => v).length;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Watering completed for $completedCount orchid${completedCount == 1 ? '' : 's'}'),
          backgroundColor: AppTheme.primary,
        ),
      );
    }
  }

  Future<void> _cancelSoak() async {
    final notif = Provider.of<NotificationService>(context, listen: false);
    await widget.db.cancelSoakSession(widget.session.id);
    await notif.cancelDrainNotification(widget.session.id);
    widget.onCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final totalSeconds = widget.session.durationMinutes * 60;
    final elapsedSeconds = totalSeconds - _remaining.inSeconds;
    final progress = totalSeconds > 0 ? (elapsedSeconds / totalSeconds).clamp(0.0, 1.0) : 1.0;
    final minutes = _remaining.inMinutes;
    final seconds = _remaining.inSeconds % 60;
    final orchidNames = _sessionTasks.map((st) => st.orchid.name).join(', ');

    final isReady = _isReadyToDrain || _remaining == Duration.zero;
    final accentColor = isReady ? AppTheme.statusNeedsCare : AppTheme.waterBlue;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: accentColor, width: 4),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Countdown circle
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accentColor.withValues(alpha: 0.15),
                      border: Border.all(color: accentColor, width: 2),
                    ),
                    child: Center(
                      child: isReady
                          ? Icon(Icons.done, color: accentColor, size: 28)
                          : Text(
                              '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: accentColor,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isReady ? 'Ready to drain!' : 'Soaking...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isReady ? AppTheme.statusNeedsCare : null,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          orchidNames.isNotEmpty ? orchidNames : 'Loading...',
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 13,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    tooltip: 'Cancel soak',
                    onPressed: _cancelSoak,
                    color: AppTheme.textSecondary,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: accentColor.withValues(alpha: 0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 12),
              // Drain button
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _completeSoak,
                  icon: const Icon(Icons.water_drop_outlined),
                  label: Text(isReady ? 'Drain & Complete' : 'Drain Early'),
                  style: FilledButton.styleFrom(
                    backgroundColor: accentColor,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
