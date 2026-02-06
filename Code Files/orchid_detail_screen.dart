// lib/screens/orchid_detail_screen.dart
// OrchidLife - Orchid detail view with care tasks

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/orchid.dart';
import '../models/care_task.dart';
import '../services/database_service.dart';
import 'add_edit_orchid_screen.dart';

class OrchidDetailScreen extends StatefulWidget {
  final Orchid orchid;

  const OrchidDetailScreen({super.key, required this.orchid});

  @override
  State<OrchidDetailScreen> createState() => _OrchidDetailScreenState();
}

class _OrchidDetailScreenState extends State<OrchidDetailScreen> {
  late Orchid _orchid;
  List<CareTask> _careTasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _orchid = widget.orchid;
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      final isar = DatabaseService.isar;

      // Reload orchid in case it was updated
      final orchid = await isar.orchids.get(_orchid.id);
      if (orchid == null) {
        // Orchid was deleted
        if (mounted) Navigator.pop(context, true);
        return;
      }

      // Load care tasks
      final tasks = await isar.careTasks
          .filter()
          .orchidIdEqualTo(_orchid.id)
          .isActiveEqualTo(true)
          .findAll();

      // Sort by next due
      tasks.sort((a, b) => (a.nextDue ?? DateTime.now())
          .compareTo(b.nextDue ?? DateTime.now()));

      setState(() {
        _orchid = orchid;
        _careTasks = tasks;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading orchid data: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _navigateToEdit() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditOrchidScreen(orchid: _orchid),
      ),
    );

    if (result == true) {
      _loadData();
    }
  }

  Future<void> _deleteOrchid() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Orchid?'),
        content: Text(
          'Are you sure you want to delete "${_orchid.displayName}"? '
          'This will also delete all care tasks and history.',
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
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final isar = DatabaseService.isar;

        await isar.writeTxn(() async {
          // Delete care tasks
          await isar.careTasks
              .filter()
              .orchidIdEqualTo(_orchid.id)
              .deleteAll();

          // Delete care logs
          await isar.careLogs
              .filter()
              .orchidIdEqualTo(_orchid.id)
              .deleteAll();

          // Delete light readings
          await isar.lightReadings
              .filter()
              .orchidIdEqualTo(_orchid.id)
              .deleteAll();

          // Delete orchid
          await isar.orchids.delete(_orchid.id);
        });

        if (mounted) {
          Navigator.pop(context, true);
        }
      } catch (e) {
        debugPrint('Error deleting orchid: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting: $e'),
              backgroundColor: AppTheme.statusOverdue,
            ),
          );
        }
      }
    }
  }

  void _showMoreMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Orchid'),
              onTap: () {
                Navigator.pop(context);
                _navigateToEdit();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: AppTheme.statusOverdue),
              title: const Text(
                'Delete Orchid',
                style: TextStyle(color: AppTheme.statusOverdue),
              ),
              onTap: () {
                Navigator.pop(context);
                _deleteOrchid();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                // Header
                SliverAppBar(
                  expandedHeight: 200,
                  pinned: true,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: _showMoreMenu,
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(_orchid.displayName),
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppTheme.fromHex(_orchid.colorTag),
                            AppTheme.fromHex(_orchid.colorTag).withOpacity(0.7),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 48),
                          child: Icon(
                            Icons.local_florist,
                            size: 80,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Content
                SliverPadding(
                  padding: const EdgeInsets.all(AppTheme.screenPadding),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Info card
                      _buildInfoCard(),
                      const SizedBox(height: AppTheme.spacing6),

                      // Care schedule
                      _buildSectionHeader('Care Schedule'),
                      const SizedBox(height: AppTheme.spacing3),
                      if (_careTasks.isEmpty)
                        _buildNoTasksCard()
                      else
                        ..._careTasks.map((task) => _buildTaskCard(task)),

                      const SizedBox(height: AppTheme.spacing6),

                      // Quick actions
                      _buildSectionHeader('Quick Actions'),
                      const SizedBox(height: AppTheme.spacing3),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // TODO: Light meter
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Light meter coming soon!')),
                                );
                              },
                              icon: const Icon(Icons.wb_sunny_outlined),
                              label: const Text('Check Light'),
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacing3),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // TODO: AI help
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('AI Help coming soon!')),
                                );
                              },
                              icon: const Icon(Icons.help_outline),
                              label: const Text('Get Help'),
                            ),
                          ),
                        ],
                      ),

                      // Notes
                      if (_orchid.notes != null && _orchid.notes!.isNotEmpty) ...[
                        const SizedBox(height: AppTheme.spacing6),
                        _buildSectionHeader('Notes'),
                        const SizedBox(height: AppTheme.spacing3),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(AppTheme.spacing4),
                            child: Text(_orchid.notes!),
                          ),
                        ),
                      ],

                      const SizedBox(height: AppTheme.spacing8),
                    ]),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing4),
        child: Column(
          children: [
            _buildInfoRow(Icons.category, 'Variety', _orchid.variety.displayName),
            const Divider(),
            _buildInfoRow(Icons.filter_vintage, 'Status', _orchid.bloomStatus.displayName),
            if (_orchid.location != null) ...[
              const Divider(),
              _buildInfoRow(Icons.place_outlined, 'Location', _orchid.location!),
            ],
            const Divider(),
            _buildInfoRow(Icons.wb_sunny_outlined, 'Light Needs', _orchid.variety.lightNeeds),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing2),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.textSecondary),
          const SizedBox(width: AppTheme.spacing3),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildTaskCard(CareTask task) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing2),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: task.isDueToday
                ? AppTheme.statusNeedsCare.withOpacity(0.2)
                : AppTheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
          child: Center(
            child: Text(
              task.careType.emoji,
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
        title: Text(task.careType.displayName),
        subtitle: Text(
          task.isDueToday
              ? (task.isOverdue ? 'Overdue!' : 'Due today')
              : 'Every ${task.intervalDays} days • Next: ${_formatDate(task.nextDue)}',
          style: TextStyle(
            color: task.isOverdue ? AppTheme.statusOverdue : null,
          ),
        ),
        trailing: task.isDueToday
            ? IconButton(
                icon: const Icon(Icons.check_circle_outline),
                color: AppTheme.statusCompleted,
                onPressed: () async {
                  task.markCompleted();
                  final isar = DatabaseService.isar;
                  await isar.writeTxn(() async {
                    await isar.careTasks.put(task);
                  });
                  _loadData();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${task.careType.emoji} Done!'),
                        backgroundColor: AppTheme.statusCompleted,
                      ),
                    );
                  }
                },
              )
            : null,
      ),
    );
  }

  Widget _buildNoTasksCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing6),
        child: Column(
          children: [
            const Icon(
              Icons.schedule,
              size: 48,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(height: AppTheme.spacing3),
            Text(
              'No care tasks yet',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppTheme.spacing2),
            Text(
              'Add care tasks to get reminders',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not set';
    final now = DateTime.now();
    final diff = date.difference(DateTime(now.year, now.month, now.day)).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    if (diff < 7) return 'In $diff days';

    return '${date.day}/${date.month}';
  }
}
