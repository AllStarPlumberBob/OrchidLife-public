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

    // ── Past day sections — each wrapped in a card ──
    for (final day in sortedPastDays) {
      final logs = pastDays[day]!;
      slivers.add(
        SliverToBoxAdapter(
          child: _buildDateSectionCard(
            context,
            day: day,
            today: today,
            type: _DateSectionType.past,
            count: logs.length,
            child: Column(
              children: [
                for (int i = 0; i < logs.length; i++) ...[
                  if (i > 0)
                    Divider(
                      height: 1,
                      indent: 56,
                      color: AppTheme.divider.withValues(alpha: 0.4),
                    ),
                  _PastLogTile(
                    log: logs[i],
                    orchidName: orchidMap[logs[i].orchidId]?.name ?? 'Unknown',
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }

    // ── Today section — date label row + orchid-grouped cards directly ──
    slivers.add(
      SliverToBoxAdapter(
        key: _todayKey,
        child: _buildTodayDateLabel(today, todayTasks.length),
      ),
    );

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
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  Icon(Icons.check_circle_outline,
                      color: AppTheme.statusCompleted.withValues(alpha: 0.4), size: 36),
                  const SizedBox(height: 8),
                  Text(
                    'No tasks due today',
                    style: TextStyle(
                      color: AppTheme.textSecondary.withValues(alpha: 0.7),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your orchids are all set!',
                    style: TextStyle(
                      color: AppTheme.textSecondary.withValues(alpha: 0.5),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Today's completed logs
    final todayLogs = recentLogs.where((log) {
      final day = DateTime(log.completedAt.year, log.completedAt.month, log.completedAt.day);
      return day == today;
    }).toList();

    if (todayLogs.isNotEmpty) {
      // Centered divider label
      slivers.add(
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                Expanded(child: Divider(color: AppTheme.statusCompleted.withValues(alpha: 0.2))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check, size: 14, color: AppTheme.statusCompleted.withValues(alpha: 0.5)),
                      const SizedBox(width: 4),
                      Text(
                        'Completed today',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary.withValues(alpha: 0.6),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: Divider(color: AppTheme.statusCompleted.withValues(alpha: 0.2))),
              ],
            ),
          ),
        ),
      );
      slivers.add(
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          sliver: SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.cardBackground,
                borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                border: Border.all(color: AppTheme.cardBorder, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  for (int i = 0; i < todayLogs.length; i++) ...[
                    if (i > 0)
                      Divider(
                        height: 1,
                        indent: 56,
                        color: AppTheme.divider.withValues(alpha: 0.4),
                      ),
                    _PastLogTile(
                      log: todayLogs[i],
                      orchidName: orchidMap[todayLogs[i].orchidId]?.name ?? 'Unknown',
                    ),
                  ],
                ],
              ),
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

    // ── Future day sections — each wrapped in a card ──
    for (final day in sortedFutureDays) {
      final tasks = futureDays[day]!;
      slivers.add(
        SliverToBoxAdapter(
          child: _buildDateSectionCard(
            context,
            day: day,
            today: today,
            type: _DateSectionType.future,
            count: tasks.length,
            child: Column(
              children: [
                for (int i = 0; i < tasks.length; i++) ...[
                  if (i > 0)
                    Divider(
                      height: 1,
                      indent: 56,
                      color: AppTheme.divider.withValues(alpha: 0.4),
                    ),
                  _UpcomingTaskTile(
                    task: tasks[i],
                    orchidName: orchidMap[tasks[i].orchidId]?.name ?? 'Unknown',
                    today: today,
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }

    // Bottom spacing for floating nav
    slivers.add(const SliverPadding(padding: EdgeInsets.only(bottom: 32)));

    // Trigger scroll to today
    _scrollToToday();

    return CustomScrollView(slivers: slivers);
  }

  // ── Today date label row (not wrapped in card — orchid cards provide grouping) ──
  Widget _buildTodayDateLabel(DateTime today, int taskCount) {
    final dayLabel = DateFormat('MMM d').format(today);
    final weekdayLabel = DateFormat('EEEE').format(today);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Row(
        children: [
          // Bold day number in primary circle
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primary,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withValues(alpha: 0.25),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Text(
                '${today.day}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textOnPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      weekdayLabel,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primary,
                      ),
                    ),
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
                ),
                Text(
                  dayLabel,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.primary.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          if (taskCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppTheme.radiusFull),
              ),
              child: Text(
                '$taskCount task${taskCount == 1 ? '' : 's'}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Date section card with gradient header strip (past / future) ──
  Widget _buildDateSectionCard(
    BuildContext context, {
    required DateTime day,
    required DateTime today,
    required _DateSectionType type,
    required int count,
    required Widget child,
  }) {
    final dayLabel = DateFormat('MMM d').format(day);
    final weekdayLabel = DateFormat('EEEE').format(day);

    final Color gradientStart;
    final Color gradientEnd;
    final String countLabel;

    switch (type) {
      case _DateSectionType.past:
        gradientStart = AppTheme.secondary;
        gradientEnd = AppTheme.secondary.withValues(alpha: 0.7);
        countLabel = '$count done';
      case _DateSectionType.future:
        gradientStart = AppTheme.statusUpcoming;
        gradientEnd = AppTheme.statusUpcoming.withValues(alpha: 0.7);
        countLabel = '$count task${count == 1 ? '' : 's'}';
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(AppTheme.radiusCard),
          border: Border.all(color: AppTheme.cardBorder, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gradient header strip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [gradientStart, gradientEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  // Day number
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.25),
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          weekdayLabel,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          dayLabel,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (count > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                      ),
                      child: Text(
                        countLabel,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Child content (log tiles / task tiles)
            child,
          ],
        ),
      ),
    );
  }

  // ── Today tasks grouped by orchid — hero cards with gradient headers ──
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
    var orchidIndex = 0;

    for (final entry in grouped.entries) {
      final orchidName = orchidMap[entry.key]?.name ?? 'Unknown Orchid';
      final delayMs = orchidIndex * 100;

      slivers.add(
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          sliver: SliverToBoxAdapter(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 400 + delayMs),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 12 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.cardBackground,
                  borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                  border: Border.all(color: AppTheme.cardBorder, width: 0.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gradient header strip
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppTheme.sliverGradientStart, AppTheme.sliverGradientEnd],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.local_florist, color: AppTheme.textOnPrimary, size: 22),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              orchidName,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textOnPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Task rows
                    ...entry.value.asMap().entries.map((taskEntry) {
                      final taskIndex = taskEntry.key;
                      final task = taskEntry.value;
                      return Column(
                        children: [
                          if (taskIndex > 0)
                            Divider(
                              height: 1,
                              indent: 68,
                              color: AppTheme.divider.withValues(alpha: 0.5),
                            ),
                          _buildTodayTaskRow(context, db, task, orchidName, activeTaskIds),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      orchidIndex++;
    }

    return slivers;
  }

  Widget _buildTodayTaskRow(
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

    // Button color: water=blue, overdue=red tint, default=green
    final Color buttonColor;
    final String buttonLabel;
    final IconData buttonIcon;
    if (isWater && !isSoaking) {
      buttonColor = isOverdue ? AppTheme.statusOverdue : AppTheme.waterBlue;
      buttonLabel = 'Soak';
      buttonIcon = Icons.water_drop;
    } else {
      buttonColor = isOverdue ? AppTheme.statusOverdue : AppTheme.primary;
      buttonLabel = 'Done';
      buttonIcon = Icons.check;
    }

    final rowContent = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          // 44x44 rounded square icon with gradient fill
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.08)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          // Task info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isOverdue && !isSoaking ? AppTheme.statusOverdue : AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                if (isSoaking)
                  Text(
                    'Soaking...',
                    style: TextStyle(fontSize: 13, color: AppTheme.waterBlue.withValues(alpha: 0.8)),
                  )
                else
                  Text(
                    isOverdue
                        ? 'Overdue \u00b7 ${DateFormat.MMMd().format(task.nextDue)}'
                        : 'Due today',
                    style: TextStyle(
                      fontSize: 13,
                      color: isOverdue
                          ? AppTheme.statusOverdue.withValues(alpha: 0.7)
                          : AppTheme.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          // Action button
          if (isSoaking)
            Chip(
              label: const Text('Soaking'),
              backgroundColor: AppTheme.waterBlue.withValues(alpha: 0.15),
              labelStyle: const TextStyle(color: AppTheme.waterBlue, fontSize: 12),
              visualDensity: VisualDensity.compact,
            )
          else
            FilledButton.tonal(
              onPressed: () {
                if (isWater) {
                  startSoakWorkflow(context, db, task, orchidName, _refresh);
                } else {
                  completeTaskWorkflow(context, db, task, orchidName);
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: buttonColor.withValues(alpha: 0.15),
                foregroundColor: buttonColor,
                minimumSize: const Size(0, 36),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                ),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(buttonIcon, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    buttonLabel,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );

    // Wrap in Dismissible for swipe-to-snooze (only when not soaking)
    if (isSoaking) {
      return rowContent;
    }

    return Dismissible(
      key: ValueKey('snooze-${task.id}'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        await snoozeTaskWorkflow(context, db, task);
        return false; // Don't actually dismiss — the stream will update
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppTheme.accent.withValues(alpha: 0.15),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Snooze',
              style: TextStyle(
                color: AppTheme.accent.withValues(alpha: 0.9),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 6),
            Icon(Icons.snooze, color: AppTheme.accent.withValues(alpha: 0.9), size: 20),
          ],
        ),
      ),
      child: rowContent,
    );
  }
}

// ── Date section type for gradient selection ──
enum _DateSectionType { past, future }

// ============================================================
// Past care log tile — compact, no explicit border
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          // Circular icon with check overlay badge
          Stack(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: 0.1),
                ),
                child: Icon(
                  log.skipped ? Icons.skip_next : icon,
                  color: color.withValues(alpha: 0.7),
                  size: 18,
                ),
              ),
              if (!log.skipped)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.statusCompleted,
                      border: Border.all(color: AppTheme.cardBackground, width: 1.5),
                    ),
                    child: const Icon(Icons.check, size: 8, color: Colors.white),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: (log.skipped ? AppTheme.statusSkipped : AppTheme.textPrimary)
                        .withValues(alpha: 0.75),
                    fontStyle: log.skipped ? FontStyle.italic : null,
                  ),
                ),
                Text(
                  orchidName,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                timeStr,
                style: TextStyle(
                  fontSize: 11,
                  color: AppTheme.textSecondary.withValues(alpha: 0.7),
                ),
              ),
              if (log.skipped)
                Text(
                  'Skipped',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppTheme.statusSkipped.withValues(alpha: 0.7),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              if (log.notes != null && log.notes!.isNotEmpty)
                Icon(
                  Icons.notes,
                  size: 14,
                  color: AppTheme.textSecondary.withValues(alpha: 0.4),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
// Milestone banner — celebratory with gradient and glow
// ============================================================

class _MilestoneBanner extends StatelessWidget {
  final Milestone milestone;
  final AppDatabase db;

  const _MilestoneBanner({required this.milestone, required this.db});

  @override
  Widget build(BuildContext context) {
    final isBloom = milestone.type.startsWith('bloom');
    final isAnniversary = milestone.type.startsWith('anniversary');
    final color = isBloom
        ? AppTheme.bloom
        : isAnniversary
            ? AppTheme.statusNeedsCare
            : AppTheme.statusCompleted;
    final icon = isBloom
        ? Icons.local_florist
        : isAnniversary
            ? Icons.celebration
            : Icons.emoji_events;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.12), color.withValues(alpha: 0.04)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 6, 12),
        child: Row(
          children: [
            // Glowing circle icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.15),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.2),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                milestone.message,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.close, size: 18, color: color.withValues(alpha: 0.5)),
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
// Health check-in — warm pink container, no nested Cards
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
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.bloom.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(color: AppTheme.bloom.withValues(alpha: 0.12)),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.favorite_border, size: 18, color: AppTheme.bloom.withValues(alpha: 0.8)),
                const SizedBox(width: 8),
                const Text(
                  'Check in',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.bloom,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...neglectedOrchids.asMap().entries.map((entry) {
              final orchid = entry.value;
              final isLast = entry.key == neglectedOrchids.length - 1;
              return Column(
                children: [
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      OrchidPageRoute(builder: (_) => OrchidDetailScreen(orchidId: orchid.id)),
                    ),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.bloom.withValues(alpha: 0.1),
                            ),
                            child: const Icon(Icons.local_florist, color: AppTheme.bloom, size: 16),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'How is ${orchid.name} doing?',
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                ),
                                const Text(
                                  'No recent care logged',
                                  style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, size: 18, color: AppTheme.textSecondary),
                        ],
                      ),
                    ),
                  ),
                  if (!isLast)
                    Divider(height: 1, color: AppTheme.bloom.withValues(alpha: 0.1)),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// Upcoming task tile — compact, inside card container
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          // Circular icon with dashed-feel border
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.08),
              border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
            ),
            child: Icon(icon, color: color.withValues(alpha: 0.7), size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
                Text(
                  orchidName,
                  style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppTheme.statusUpcoming.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusFull),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.schedule, size: 12, color: AppTheme.statusUpcoming.withValues(alpha: 0.7)),
                const SizedBox(width: 4),
                Text(
                  dueLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.statusUpcoming,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
