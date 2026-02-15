import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../database/database.dart';
import '../theme/app_theme.dart';
import '../widgets/orchid_sliver_app_bar.dart';
import '../widgets/empty_state.dart';
import '../widgets/page_transitions.dart';
import '../widgets/soak_session_widgets.dart';
import 'orchid_detail_screen.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  Key _refreshKey = UniqueKey();
  final GlobalKey _todayKey = GlobalKey();
  bool _hasScrolledToToday = false;

  void _refresh() {
    setState(() {
      _refreshKey = UniqueKey();
      _hasScrolledToToday = false;
    });
  }

  void _scrollToToday() {
    if (_hasScrolledToToday) return;
    _hasScrolledToToday = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _todayKey.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);

    return Scaffold(
      body: StreamBuilder<List<SoakSession>>(
        key: _refreshKey,
        stream: db.watchActiveSoakSessions(),
        builder: (context, soakSnapshot) {
          final activeSessions = soakSnapshot.data ?? [];

          return StreamBuilder<Map<int, Orchid>>(
            stream: db.watchAllOrchidsMap(),
            builder: (context, orchidSnapshot) {
              final orchidMap = orchidSnapshot.data ?? {};

              return StreamBuilder<List<CareTask>>(
                stream: db.watchTasksDueToday(),
                builder: (context, todaySnapshot) {
                  return FutureBuilder<Set<int>>(
                    key: ValueKey(activeSessions.length),
                    future: db.getActiveSessionTaskIds(),
                    builder: (context, activeIdsSnapshot) {
                      final activeTaskIds = activeIdsSnapshot.data ?? {};

                      return StreamBuilder<List<CareLog>>(
                        stream: db.watchRecentCareLogs(days: 14),
                        builder: (context, logsSnapshot) {
                          return StreamBuilder<List<CareTask>>(
                            stream: db.watchUpcomingTasks(days: 14),
                            builder: (context, upcomingSnapshot) {
                              // Loading state
                              if (todaySnapshot.connectionState == ConnectionState.waiting &&
                                  logsSnapshot.connectionState == ConnectionState.waiting) {
                                return CustomScrollView(
                                  slivers: [
                                    OrchidSliverAppBar(
                                      title: 'Agenda',
                                      actions: [
                                        IconButton(
                                          icon: const Icon(Icons.refresh),
                                          onPressed: _refresh,
                                        ),
                                      ],
                                    ),
                                    const SliverFillRemaining(
                                      child: Center(child: CircularProgressIndicator()),
                                    ),
                                  ],
                                );
                              }

                              final todayTasks = todaySnapshot.data ?? [];
                              final recentLogs = logsSnapshot.data ?? [];
                              final upcomingTasks = upcomingSnapshot.data ?? [];

                              return _buildAgendaContent(
                                context,
                                db,
                                orchidMap,
                                activeSessions,
                                activeTaskIds,
                                todayTasks,
                                recentLogs,
                                upcomingTasks,
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildAgendaContent(
    BuildContext context,
    AppDatabase db,
    Map<int, Orchid> orchidMap,
    List<SoakSession> activeSessions,
    Set<int> activeTaskIds,
    List<CareTask> todayTasks,
    List<CareLog> recentLogs,
    List<CareTask> upcomingTasks,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // ── Past days: group logs by date ──
    final pastDays = <DateTime, List<CareLog>>{};
    for (final log in recentLogs) {
      final day = DateTime(log.completedAt.year, log.completedAt.month, log.completedAt.day);
      if (day.isBefore(today)) {
        pastDays.putIfAbsent(day, () => []).add(log);
      }
    }
    final sortedPastDays = pastDays.keys.toList()..sort();

    // ── Future days: group tasks by nextDue date ──
    final futureDays = <DateTime, List<CareTask>>{};
    for (final task in upcomingTasks) {
      final day = DateTime(task.nextDue.year, task.nextDue.month, task.nextDue.day);
      futureDays.putIfAbsent(day, () => []).add(task);
    }
    final sortedFutureDays = futureDays.keys.toList()..sort();

    // ── Check if totally empty ──
    final hasContent = pastDays.isNotEmpty ||
        todayTasks.isNotEmpty ||
        activeSessions.isNotEmpty ||
        futureDays.isNotEmpty;

    final slivers = <Widget>[];

    // App bar
    slivers.add(
      OrchidSliverAppBar(
        title: 'Agenda',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
          ),
        ],
      ),
    );

    if (!hasContent) {
      slivers.add(
        const SliverFillRemaining(
          child: EmptyState(
            icon: Icons.check_circle_outline,
            title: 'All caught up!',
            subtitle: 'No care tasks due today',
          ),
        ),
      );
      // Still need to trigger scroll for consistency
      _scrollToToday();
      return CustomScrollView(slivers: slivers);
    }

    // ── Milestone banners ──
    slivers.add(
      SliverToBoxAdapter(
        child: StreamBuilder<List<Milestone>>(
          stream: db.watchUndismissedMilestones(),
          builder: (context, milestoneSnap) {
            final milestones = milestoneSnap.data ?? [];
            if (milestones.isEmpty) return const SizedBox.shrink();

            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Column(
                children: milestones.take(3).map((m) => _MilestoneBanner(
                  milestone: m,
                  db: db,
                )).toList(),
              ),
            );
          },
        ),
      ),
    );

    // ── Past day sections ──
    for (final day in sortedPastDays) {
      final logs = pastDays[day]!;
      slivers.add(_buildDateHeader(context, day, today, logCount: logs.length));
      slivers.add(
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _PastLogTile(
                log: logs[index],
                orchidName: orchidMap[logs[index].orchidId]?.name ?? 'Unknown',
              ),
              childCount: logs.length,
            ),
          ),
        ),
      );
    }

    // ── Today section ──
    slivers.add(_buildDateHeader(
      context,
      today,
      today,
      taskCount: todayTasks.length,
      isToday: true,
      key: _todayKey,
    ));

    // Active soak sessions
    if (activeSessions.isNotEmpty) {
      slivers.add(
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => SoakSessionCard(
                session: activeSessions[index],
                db: db,
                onCompleted: _refresh,
              ),
              childCount: activeSessions.length,
            ),
          ),
        ),
      );
    }

    // Today tasks grouped by orchid
    if (todayTasks.isNotEmpty) {
      slivers.addAll(_buildTodayTaskSlivers(context, db, todayTasks, orchidMap, activeTaskIds));
    } else if (activeSessions.isEmpty) {
      slivers.add(
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          sliver: SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline,
                      color: AppTheme.statusCompleted.withValues(alpha: 0.6), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'No tasks due today',
                    style: TextStyle(
                      color: AppTheme.textSecondary.withValues(alpha: 0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Today's completed logs (things done today)
    final todayLogs = recentLogs.where((log) {
      final day = DateTime(log.completedAt.year, log.completedAt.month, log.completedAt.day);
      return day == today;
    }).toList();

    if (todayLogs.isNotEmpty) {
      slivers.add(
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          sliver: SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 4),
              child: Text(
                'Completed today',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary.withValues(alpha: 0.7),
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ),
      );
      slivers.add(
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _PastLogTile(
                log: todayLogs[index],
                orchidName: orchidMap[todayLogs[index].orchidId]?.name ?? 'Unknown',
              ),
              childCount: todayLogs.length,
            ),
          ),
        ),
      );
    }

    // ── Health check-in prompts ──
    slivers.add(
      SliverToBoxAdapter(
        child: _HealthCheckInSection(orchidMap: orchidMap, recentLogs: recentLogs),
      ),
    );

    // ── Future day sections ──
    for (final day in sortedFutureDays) {
      final tasks = futureDays[day]!;
      slivers.add(_buildDateHeader(context, day, today, taskCount: tasks.length));
      slivers.add(
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _UpcomingTaskTile(
                task: tasks[index],
                orchidName: orchidMap[tasks[index].orchidId]?.name ?? 'Unknown',
                today: today,
              ),
              childCount: tasks.length,
            ),
          ),
        ),
      );
    }

    // Bottom spacing for floating nav
    slivers.add(const SliverPadding(padding: EdgeInsets.only(bottom: 16)));

    // Trigger scroll to today
    _scrollToToday();

    return CustomScrollView(slivers: slivers);
  }

  // ── Date header widget ──
  Widget _buildDateHeader(
    BuildContext context,
    DateTime day,
    DateTime today, {
    int taskCount = 0,
    int logCount = 0,
    bool isToday = false,
    Key? key,
  }) {
    final isPast = day.isBefore(today);
    final dayLabel = DateFormat('MMM d').format(day);
    final weekdayLabel = DateFormat('EEEE').format(day);
    final count = isToday ? taskCount : (isPast ? logCount : taskCount);

    return SliverToBoxAdapter(
      key: key,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        margin: const EdgeInsets.only(top: 4),
        decoration: BoxDecoration(
          color: isToday
              ? AppTheme.primary.withValues(alpha: 0.08)
              : AppTheme.surfaceVariant.withValues(alpha: 0.5),
        ),
        child: Row(
          children: [
            Text(
              dayLabel,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isToday ? AppTheme.primary : AppTheme.textPrimary,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              weekdayLabel,
              style: TextStyle(
                fontSize: 13,
                color: isToday
                    ? AppTheme.primary.withValues(alpha: 0.7)
                    : AppTheme.textSecondary,
              ),
            ),
            if (isToday) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                ),
                child: const Text(
                  'Today',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textOnPrimary,
                  ),
                ),
              ),
            ],
            const Spacer(),
            if (count > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isToday
                      ? AppTheme.primary.withValues(alpha: 0.15)
                      : isPast
                          ? AppTheme.statusCompleted.withValues(alpha: 0.15)
                          : AppTheme.statusUpcoming.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                ),
                child: Text(
                  isPast ? '$count done' : '$count task${count == 1 ? '' : 's'}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isToday
                        ? AppTheme.primary
                        : isPast
                            ? AppTheme.statusCompleted
                            : AppTheme.statusUpcoming,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ── Today tasks grouped by orchid (mirrors old Today screen) ──
  List<Widget> _buildTodayTaskSlivers(
    BuildContext context,
    AppDatabase db,
    List<CareTask> tasks,
    Map<int, Orchid> orchidMap,
    Set<int> activeTaskIds,
  ) {
    final Map<int, List<CareTask>> grouped = {};
    for (final task in tasks) {
      grouped.putIfAbsent(task.orchidId, () => []).add(task);
    }

    final slivers = <Widget>[];
    for (final entry in grouped.entries) {
      final orchidName = orchidMap[entry.key]?.name ?? 'Unknown Orchid';

      slivers.add(
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          sliver: SliverToBoxAdapter(
            child: Card(
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
                      _buildTodayTaskTile(context, db, task, orchidName, activeTaskIds)),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return slivers;
  }

  Widget _buildTodayTaskTile(
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
                  : 'Due today',
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
                IconButton(
                  icon: const Icon(Icons.snooze),
                  tooltip: 'Snooze 1 day',
                  onPressed: () => snoozeTaskWorkflow(context, db, task),
                ),
                if (isWater)
                  IconButton(
                    icon: const Icon(Icons.water_drop),
                    color: AppTheme.waterBlue,
                    tooltip: 'Start soak',
                    onPressed: () => startSoakWorkflow(
                        context, db, task, orchidName, _refresh),
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.check_circle),
                    color: AppTheme.primary,
                    tooltip: 'Mark complete',
                    onPressed: () =>
                        completeTaskWorkflow(context, db, task, orchidName),
                  ),
              ],
            ),
    );
  }
}

// ============================================================
// Past care log tile (read-only)
// ============================================================

class _PastLogTile extends StatelessWidget {
  final CareLog log;
  final String orchidName;

  const _PastLogTile({required this.log, required this.orchidName});

  @override
  Widget build(BuildContext context) {
    final careTypeName = log.careType.name;
    final color = log.skipped ? AppTheme.statusSkipped : AppTheme.statusCompleted;
    final icon = AppTheme.getCareTypeIcon(careTypeName);
    final displayName = AppTheme.getCareTypeDisplayName(careTypeName);
    final timeStr = DateFormat.jm().format(log.completedAt);

    return Card(
      margin: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        dense: true,
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
          child: Icon(
            log.skipped ? Icons.skip_next : icon,
            color: color,
            size: 20,
          ),
        ),
        title: Text(
          displayName,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: log.skipped ? AppTheme.statusSkipped : null,
            fontStyle: log.skipped ? FontStyle.italic : null,
          ),
        ),
        subtitle: Text(
          orchidName,
          style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              timeStr,
              style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
            ),
            if (log.skipped)
              const Text(
                'Skipped',
                style: TextStyle(
                  fontSize: 10,
                  color: AppTheme.statusSkipped,
                  fontStyle: FontStyle.italic,
                ),
              ),
            if (log.notes != null && log.notes!.isNotEmpty)
              Icon(
                Icons.notes,
                size: 14,
                color: AppTheme.textSecondary.withValues(alpha: 0.6),
              ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// Milestone banner (dismissable)
// ============================================================

class _MilestoneBanner extends StatelessWidget {
  final Milestone milestone;
  final AppDatabase db;

  const _MilestoneBanner({required this.milestone, required this.db});

  @override
  Widget build(BuildContext context) {
    final isBlooom = milestone.type.startsWith('bloom');
    final isAnniversary = milestone.type.startsWith('anniversary');
    final color = isBlooom
        ? AppTheme.bloom
        : isAnniversary
            ? AppTheme.statusNeedsCare
            : AppTheme.statusCompleted;
    final icon = isBlooom
        ? Icons.local_florist
        : isAnniversary
            ? Icons.celebration
            : Icons.emoji_events;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: color.withValues(alpha: 0.08),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                milestone.message,
                style: TextStyle(color: color, fontWeight: FontWeight.w500, fontSize: 13),
              ),
            ),
            IconButton(
              icon: Icon(Icons.close, size: 18, color: color.withValues(alpha: 0.6)),
              onPressed: () => db.dismissMilestone(milestone.id),
              tooltip: 'Dismiss',
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// Health check-in prompts
// ============================================================

class _HealthCheckInSection extends StatelessWidget {
  final Map<int, Orchid> orchidMap;
  final List<CareLog> recentLogs;

  const _HealthCheckInSection({
    required this.orchidMap,
    required this.recentLogs,
  });

  @override
  Widget build(BuildContext context) {
    // Find orchids with no care activity in the past 7 days
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    final recentOrchidIds = recentLogs
        .where((l) => l.completedAt.isAfter(sevenDaysAgo))
        .map((l) => l.orchidId)
        .toSet();

    final neglectedOrchids = orchidMap.values
        .where((o) => !o.isDemo && !recentOrchidIds.contains(o.id))
        .take(3)
        .toList();

    if (neglectedOrchids.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 8),
            child: Row(
              children: [
                Icon(Icons.favorite_border, size: 16, color: AppTheme.bloom),
                SizedBox(width: 6),
                Text(
                  'Check in',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.bloom,
                  ),
                ),
              ],
            ),
          ),
          ...neglectedOrchids.map((orchid) => Card(
            margin: const EdgeInsets.only(bottom: 6),
            color: AppTheme.bloom.withValues(alpha: 0.06),
            child: ListTile(
              dense: true,
              onTap: () => Navigator.push(
                context,
                OrchidPageRoute(builder: (_) => OrchidDetailScreen(orchidId: orchid.id)),
              ),
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.bloom.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: const Icon(Icons.local_florist, color: AppTheme.bloom, size: 20),
              ),
              title: Text(
                'How is ${orchid.name} doing?',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
              subtitle: const Text(
                'No recent care logged',
                style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
              ),
              trailing: const Icon(Icons.chevron_right, size: 18, color: AppTheme.textSecondary),
            ),
          )),
        ],
      ),
    );
  }
}

// ============================================================
// Upcoming task tile (read-only, future)
// ============================================================

class _UpcomingTaskTile extends StatelessWidget {
  final CareTask task;
  final String orchidName;
  final DateTime today;

  const _UpcomingTaskTile({
    required this.task,
    required this.orchidName,
    required this.today,
  });

  @override
  Widget build(BuildContext context) {
    final careTypeName = task.careType.name;
    const color = AppTheme.statusUpcoming;
    final icon = AppTheme.getCareTypeIcon(careTypeName);
    final displayName = task.customLabel ?? AppTheme.getCareTypeDisplayName(careTypeName);
    final dueDay = DateTime(task.nextDue.year, task.nextDue.month, task.nextDue.day);
    final daysAway = dueDay.difference(today).inDays;
    final dueLabel = daysAway == 1 ? 'tomorrow' : 'in $daysAway days';

    return Card(
      margin: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        dense: true,
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          displayName,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        subtitle: Text(
          orchidName,
          style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
        ),
        trailing: Text(
          dueLabel,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.statusUpcoming,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
