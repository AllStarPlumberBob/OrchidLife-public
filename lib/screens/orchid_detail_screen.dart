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
import '../widgets/bloom_stage_widget.dart';
import '../widgets/photo_journal_section.dart';
import '../services/seasonal_context_service.dart';
import 'add_edit_orchid_screen.dart';
import 'species_profile_screen.dart';
import '../services/diagnostic_service.dart';

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
                    // 1. Info Card with bloom badge, last potted, rescue chip
                    _buildInfoCard(orchid),
                    const SizedBox(height: 16),
                    // 2. Bloom Status (interactive stepper)
                    _buildBloomSection(context, db, orchid),
                    const SizedBox(height: 16),
                    // 3. Light Exposure (if species linked)
                    _LightExposureCard(orchidId: orchidId, db: db),
                    // 4. Species Temperature Guidance
                    _TemperatureCard(orchidId: orchidId, db: db),
                    // 4b. Seasonal Tips
                    _SeasonalTipsCard(orchidId: orchidId, db: db),
                    // 4c. Species deep dive link
                    _SpeciesLink(orchidId: orchidId, db: db),
                    // 4d. Care Insights
                    _CareInsightsCard(orchidId: orchidId, db: db),
                    // 5. Photo Journal
                    PhotoJournalSection(orchidId: orchidId, db: db),
                    const SizedBox(height: 16),
                    // 6. Bloom History
                    _buildBloomHistory(context, db),
                    const SizedBox(height: 16),
                    // 7. Care Schedule (existing)
                    _buildCareTasksSection(context, db),
                    const SizedBox(height: 16),
                    // 8. Care History (existing)
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
                    // Badges row
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        if (orchid.currentBloomStage != null)
                          BloomStageBadge(stage: orchid.currentBloomStage!),
                        if (orchid.isRescue)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.statusOverdue.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.healing, size: 12, color: AppTheme.statusOverdue),
                                SizedBox(width: 4),
                                Text(
                                  'Rescue',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.statusOverdue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    if (orchid.variety != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        orchid.variety!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
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
                    if (orchid.lastPotted != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.yard, size: 16, color: AppTheme.repotBrown),
                          const SizedBox(width: 4),
                          Text(
                            'Last potted ${DateFormat.yMMMd().format(orchid.lastPotted!)}',
                            style: const TextStyle(fontSize: 13),
                          ),
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

  Widget _buildBloomSection(BuildContext context, AppDatabase db, Orchid orchid) {
    return OrchidCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_florist, color: AppTheme.bloom, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Bloom Status',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => _updateBloomStage(context, db, orchid),
                child: const Text('Update'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          BloomStageWidget(
            currentStage: orchid.currentBloomStage,
            onStageChanged: (stage) => _setBloomStage(context, db, orchid, stage),
          ),
        ],
      ),
    );
  }

  Widget _buildBloomHistory(BuildContext context, AppDatabase db) {
    return OrchidCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.timeline, color: AppTheme.bloom, size: 20),
              SizedBox(width: 8),
              Text(
                'Bloom History',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          StreamBuilder<List<BloomLog>>(
            stream: db.watchBloomLogsForOrchid(orchidId),
            builder: (context, snapshot) {
              final logs = snapshot.data ?? [];

              if (logs.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'No bloom history yet',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                );
              }

              return Column(
                children: logs.take(5).map((log) {
                  final color = BloomStageWidget.stageColor(log.stage);
                  return ListTile(
                    dense: true,
                    leading: Icon(
                      BloomStageWidget.stageIcon(log.stage),
                      color: color,
                      size: 20,
                    ),
                    title: Text(
                      BloomStageWidget.stageName(log.stage),
                      style: TextStyle(color: color, fontWeight: FontWeight.w500),
                    ),
                    subtitle: log.notes != null ? Text(log.notes!) : null,
                    trailing: Text(
                      DateFormat.MMMd().format(log.dateLogged),
                      style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                    ),
                  );
                }).toList(),
              );
            },
          ),
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

  Future<void> _updateBloomStage(BuildContext context, AppDatabase db, Orchid orchid) async {
    final result = await showDialog<({BloomStage stage, String? notes})>(
      context: context,
      builder: (context) => _BloomUpdateDialog(currentStage: orchid.currentBloomStage),
    );

    if (result != null) {
      await db.insertBloomLog(BloomLogsCompanion.insert(
        orchidId: orchidId,
        stage: result.stage,
        dateLogged: DateTime.now(),
        notes: Value(result.notes),
      ));
    }
  }

  Future<void> _setBloomStage(BuildContext context, AppDatabase db, Orchid orchid, BloomStage stage) async {
    await db.insertBloomLog(BloomLogsCompanion.insert(
      orchidId: orchidId,
      stage: stage,
      dateLogged: DateTime.now(),
    ));
  }
}

// ============================================================
// Light Exposure Card
// ============================================================

class _LightExposureCard extends StatelessWidget {
  final int orchidId;
  final AppDatabase db;

  const _LightExposureCard({required this.orchidId, required this.db});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SpeciesProfile?>(
      future: db.getSpeciesProfileForOrchid(orchidId),
      builder: (context, speciesSnap) {
        return FutureBuilder<LightReading?>(
          future: db.getLatestLightReadingForOrchid(orchidId),
          builder: (context, readingSnap) {
            final species = speciesSnap.data;
            final reading = readingSnap.data;

            // Only show if there's a reading or species data
            if (reading == null && species == null) return const SizedBox.shrink();

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: OrchidCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.light_mode, color: AppTheme.statusNeedsCare, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Light Exposure',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (reading != null) ...[
                      Row(
                        children: [
                          Text(
                            '${reading.luxValue.toStringAsFixed(0)} lux',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: _getLuxColor(reading.luxValue, species),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getLuxColor(reading.luxValue, species).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                            ),
                            child: Text(
                              _getLuxLabel(reading.luxValue, species),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _getLuxColor(reading.luxValue, species),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Last reading: ${DateFormat.yMMMd().format(reading.readingAt)}',
                        style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                      ),
                    ],
                    if (species != null && species.idealLuxMin != null && species.idealLuxMax != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Ideal range: ${species.idealLuxMin}-${species.idealLuxMax} lux',
                        style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Color _getLuxColor(double lux, SpeciesProfile? species) {
    if (species != null && species.idealLuxMin != null && species.idealLuxMax != null) {
      if (lux < species.idealLuxMin!) return AppTheme.statusUpcoming;
      if (lux > species.idealLuxMax!) return AppTheme.statusOverdue;
      return AppTheme.statusCompleted;
    }
    if (lux < 1000) return AppTheme.statusUpcoming;
    if (lux < 5000) return AppTheme.statusCompleted;
    return AppTheme.statusNeedsCare;
  }

  String _getLuxLabel(double lux, SpeciesProfile? species) {
    if (species != null && species.idealLuxMin != null && species.idealLuxMax != null) {
      if (lux < species.idealLuxMin!) return 'Below ideal';
      if (lux > species.idealLuxMax!) return 'Above ideal';
      return 'Ideal';
    }
    if (lux < 500) return 'Low';
    if (lux < 1000) return 'Medium';
    if (lux < 5000) return 'Bright Indirect';
    return 'Bright';
  }
}

// ============================================================
// Temperature Guidance Card
// ============================================================

class _TemperatureCard extends StatelessWidget {
  final int orchidId;
  final AppDatabase db;

  const _TemperatureCard({required this.orchidId, required this.db});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SpeciesProfile?>(
      future: db.getSpeciesProfileForOrchid(orchidId),
      builder: (context, snapshot) {
        final species = snapshot.data;
        if (species == null || species.tempMinF == null) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: OrchidCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.thermostat, color: AppTheme.statusOverdue, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Temperature',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _TempChip(label: 'Min', value: '${species.tempMinF}\u00b0F', color: AppTheme.statusUpcoming),
                    const SizedBox(width: 8),
                    _TempChip(label: 'Max', value: '${species.tempMaxF}\u00b0F', color: AppTheme.statusOverdue),
                    if (species.tempNightDropF != null) ...[
                      const SizedBox(width: 8),
                      _TempChip(label: 'Night drop', value: '${species.tempNightDropF}\u00b0F', color: AppTheme.inspectPurple),
                    ],
                  ],
                ),
                if (species.humidity != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.water, size: 16, color: AppTheme.mistCyan),
                      const SizedBox(width: 4),
                      Text('Humidity: ${species.humidity}', style: const TextStyle(fontSize: 13)),
                    ],
                  ),
                ],
                if (species.bloomSeason != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.local_florist, size: 16, color: AppTheme.bloom),
                      const SizedBox(width: 4),
                      Text('Bloom season: ${species.bloomSeason}', style: const TextStyle(fontSize: 13)),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TempChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _TempChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 10, color: color)),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}

// ============================================================
// Seasonal Tips Card
// ============================================================

class _SeasonalTipsCard extends StatelessWidget {
  final int orchidId;
  final AppDatabase db;

  const _SeasonalTipsCard({required this.orchidId, required this.db});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SpeciesProfile?>(
      future: db.getSpeciesProfileForOrchid(orchidId),
      builder: (context, snapshot) {
        final species = snapshot.data;
        if (species == null) return const SizedBox.shrink();

        final tips = SeasonalContextService.getTips(species.genus);
        if (tips.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: OrchidCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.wb_sunny, color: AppTheme.statusNeedsCare, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '${SeasonalContextService.getSeasonName()} Tips',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...tips.take(3).map((tip) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Icon(Icons.eco, size: 14, color: AppTheme.primary),
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(tip, style: const TextStyle(fontSize: 13))),
                    ],
                  ),
                )),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ============================================================
// Species Profile Link
// ============================================================

class _SpeciesLink extends StatelessWidget {
  final int orchidId;
  final AppDatabase db;

  const _SpeciesLink({required this.orchidId, required this.db});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SpeciesProfile?>(
      future: db.getSpeciesProfileForOrchid(orchidId),
      builder: (context, snapshot) {
        final species = snapshot.data;
        if (species == null) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: OutlinedButton.icon(
            onPressed: () => Navigator.push(
              context,
              OrchidPageRoute(builder: (_) => SpeciesProfileScreen(species: species)),
            ),
            icon: const Icon(Icons.menu_book, size: 18),
            label: Text('${species.commonName} Care Guide'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 44),
              foregroundColor: AppTheme.primary,
            ),
          ),
        );
      },
    );
  }
}

// ============================================================
// Care Insights Card (Diagnostic Engine)
// ============================================================

class _CareInsightsCard extends StatelessWidget {
  final int orchidId;
  final AppDatabase db;

  const _CareInsightsCard({required this.orchidId, required this.db});

  @override
  Widget build(BuildContext context) {
    final diagnostics = DiagnosticService(db);

    return FutureBuilder<List<CareInsight>>(
      future: diagnostics.getInsightsForOrchid(orchidId),
      builder: (context, snapshot) {
        final insights = snapshot.data ?? [];
        if (insights.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: OrchidCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.insights, color: AppTheme.inspectPurple, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Care Insights',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...insights.take(3).map((insight) {
                  final color = switch (insight.type) {
                    InsightType.positive => AppTheme.statusCompleted,
                    InsightType.warning => AppTheme.statusNeedsCare,
                    InsightType.info => AppTheme.statusUpcoming,
                  };
                  final icon = switch (insight.type) {
                    InsightType.positive => Icons.thumb_up,
                    InsightType.warning => Icons.warning_amber,
                    InsightType.info => Icons.info_outline,
                  };

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(icon, size: 18, color: color),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                insight.title,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: color,
                                ),
                              ),
                              Text(
                                insight.message,
                                style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ============================================================
// Bloom Update Dialog
// ============================================================

class _BloomUpdateDialog extends StatefulWidget {
  final BloomStage? currentStage;

  const _BloomUpdateDialog({this.currentStage});

  @override
  State<_BloomUpdateDialog> createState() => _BloomUpdateDialogState();
}

class _BloomUpdateDialogState extends State<_BloomUpdateDialog> {
  late BloomStage _selected;
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selected = widget.currentStage ?? BloomStage.dormant;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update Bloom Stage'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: BloomStage.values.map((stage) {
              final isSelected = _selected == stage;
              final color = BloomStageWidget.stageColor(stage);
              return ChoiceChip(
                label: Text(
                  BloomStageWidget.stageName(stage),
                  style: TextStyle(color: isSelected ? Colors.white : null),
                ),
                selected: isSelected,
                selectedColor: color,
                avatar: Icon(
                  BloomStageWidget.stageIcon(stage),
                  size: 18,
                  color: isSelected ? Colors.white : color,
                ),
                onSelected: (_) => setState(() => _selected = stage),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(
              labelText: 'Notes (optional)',
              hintText: 'Any observations...',
            ),
            maxLines: 2,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, (
            stage: _selected,
            notes: _notesController.text.isEmpty ? null : _notesController.text,
          )),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
