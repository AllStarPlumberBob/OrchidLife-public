import 'dart:async';
import 'dart:io' show File, Directory;
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../database/database.dart';
import '../services/notification_service.dart';
import '../theme/app_theme.dart';

// ============================================================
// Soak candidate data class for selection sheet
// ============================================================

class SoakCandidate {
  final CareTask task;
  final Orchid orchid;
  bool selected;

  SoakCandidate({
    required this.task,
    required this.orchid,
    required this.selected,
  });
}

// ============================================================
// Bottom sheet for selecting orchids to soak
// ============================================================

class SoakSelectionSheet extends StatefulWidget {
  final Map<int, List<SoakCandidate>> grouped;

  const SoakSelectionSheet({super.key, required this.grouped});

  @override
  State<SoakSelectionSheet> createState() => _SoakSelectionSheetState();
}

class _SoakSelectionSheetState extends State<SoakSelectionSheet> {
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
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              'Start Soaking',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(
              'Select orchids to soak together',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
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

class SoakSessionCard extends StatefulWidget {
  final SoakSession session;
  final AppDatabase db;
  final VoidCallback onCompleted;

  const SoakSessionCard({
    super.key,
    required this.session,
    required this.db,
    required this.onCompleted,
  });

  @override
  State<SoakSessionCard> createState() => _SoakSessionCardState();
}

class _SoakSessionCardState extends State<SoakSessionCard> {
  static bool _alarmDialogShowing = false;

  Timer? _timer;
  Duration _remaining = Duration.zero;
  List<SoakSessionTaskWithOrchid> _sessionTasks = [];
  bool _isReadyToDrain = false;
  bool _alarmPlaying = false;

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
    if (_alarmPlaying) {
      FlutterRingtonePlayer().stop();
      _alarmPlaying = false;
    }
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

    if (!mounted) return;

    bool shouldAlarm = false;
    setState(() {
      _remaining = diff.isNegative ? Duration.zero : diff;
      if (diff.isNegative && widget.session.status == SoakStatus.soaking && !_isReadyToDrain) {
        _isReadyToDrain = true;
        shouldAlarm = true;
      } else if (widget.session.status == SoakStatus.readyToDrain) {
        _isReadyToDrain = true;
      }
    });

    if (shouldAlarm) {
      _markReadyToDrain();
      _triggerAlarm();
    }
  }

  Future<void> _markReadyToDrain() async {
    await (widget.db.update(widget.db.soakSessions)
          ..where((s) => s.id.equals(widget.session.id)))
        .write(const SoakSessionsCompanion(
      status: Value(SoakStatus.readyToDrain),
    ));
  }

  void _triggerAlarm() {
    _alarmPlaying = true;
    FlutterRingtonePlayer().playAlarm(looping: true, volume: 1.0, asAlarm: true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _showAlarmDialog();
    });
  }

  void _stopAlarm() {
    if (_alarmPlaying) {
      FlutterRingtonePlayer().stop();
      _alarmPlaying = false;
    }
  }

  void _showAlarmDialog() {
    // Prevent stacked dialogs from multiple sessions completing simultaneously
    if (_alarmDialogShowing) return;
    _alarmDialogShowing = true;

    final orchidNames = _sessionTasks.map((st) => st.orchid.name).join(', ');
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.alarm, size: 48, color: AppTheme.statusNeedsCare),
        title: const Text('Soak Complete!'),
        content: Text(
          orchidNames.isNotEmpty
              ? '$orchidNames ${_sessionTasks.length == 1 ? 'is' : 'are'} ready to drain'
              : 'Your orchids are ready to drain',
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                _stopAlarm();
                // Cancel the ongoing system notification so it doesn't persist
                Provider.of<NotificationService>(context, listen: false)
                    .cancelDrainNotification(widget.session.id);
                Navigator.pop(dialogContext);
              },
              icon: const Icon(Icons.alarm_off),
              label: const Text('Got it'),
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.statusNeedsCare,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    ).then((_) => _alarmDialogShowing = false);
  }

  Future<void> _completeSoak() async {
    if (_sessionTasks.isEmpty) return;
    _stopAlarm();

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
    _stopAlarm();
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
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
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

// ============================================================
// Task action workflow functions
// ============================================================

/// Start a soak workflow for a water task
Future<void> startSoakWorkflow(
  BuildContext context,
  AppDatabase db,
  CareTask tappedTask,
  String tappedOrchidName, [
  VoidCallback? onCompleted,
]) async {
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
  final grouped = <int, List<SoakCandidate>>{};
  for (final task in availableTasks) {
    final orchid = taskOrchids[task.orchidId];
    if (orchid == null) continue;
    final duration = orchid.soakDurationMinutes;
    grouped.putIfAbsent(duration, () => []).add(SoakCandidate(
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
  final result = await showModalBottomSheet<Map<int, List<SoakCandidate>>>(
    context: context,
    isScrollControlled: true,
    builder: (context) => SoakSelectionSheet(grouped: grouped),
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
      notificationId: 0,
    );

    final drainAt = DateTime.now().add(Duration(minutes: duration));
    await notif.scheduleDrainNotification(
      sessionId: sessionId,
      orchidIds: orchidIds,
      drainAt: drainAt,
    );
  }

  onCompleted?.call();
}

/// Complete a care task with optional notes
Future<void> completeTaskWorkflow(
  BuildContext context,
  AppDatabase db,
  CareTask task,
  String orchidName, {
  VoidCallback? onCompleted,
}) async {
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

    onCompleted?.call();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$careTypeName completed for $orchidName'),
          backgroundColor: AppTheme.primary,
        ),
      );

      // Prompt for root check photo after repotting
      if (task.careType == CareType.repot && context.mounted) {
        _promptRootCheckPhoto(context, db, task.orchidId);
      }
    }
  }
}

/// Prompt user to take a root check photo after repotting
Future<void> _promptRootCheckPhoto(BuildContext context, AppDatabase db, int orchidId) async {
  final takePhoto = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Root Check Photo?'),
      content: const Text('Would you like to take a root check photo for your journal? This helps track root health over time.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Skip')),
        FilledButton.icon(
          onPressed: () => Navigator.pop(context, true),
          icon: const Icon(Icons.camera_alt),
          label: const Text('Take Photo'),
        ),
      ],
    ),
  );

  if (takePhoto != true || !context.mounted) return;

  final picker = ImagePicker();
  final picked = await picker.pickImage(
    source: ImageSource.camera,
    maxWidth: 1024,
    maxHeight: 1024,
    imageQuality: 85,
  );
  if (picked == null) return;

  final appDir = await getApplicationDocumentsDirectory();
  final photosDir = Directory(p.join(appDir.path, 'orchid_photos'));
  if (!await photosDir.exists()) await photosDir.create(recursive: true);
  final fileName = 'roots_${DateTime.now().millisecondsSinceEpoch}${p.extension(picked.path)}';
  final savedFile = await File(picked.path).copy(p.join(photosDir.path, fileName));

  await db.insertPhotoJournalEntry(PhotoJournalCompanion.insert(
    orchidId: orchidId,
    photoPath: savedFile.path,
    dateTaken: DateTime.now(),
    note: const Value('Root check during repotting'),
    tag: PhotoTag.rootCheck,
  ));

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Root check photo saved to journal!'),
        backgroundColor: AppTheme.statusCompleted,
      ),
    );
  }
}

/// Snooze a care task by 1 day
Future<void> snoozeTaskWorkflow(
  BuildContext context,
  AppDatabase db,
  CareTask task,
) async {
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
