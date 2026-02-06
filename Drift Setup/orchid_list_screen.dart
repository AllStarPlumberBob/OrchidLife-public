import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../database/database.dart';
import '../theme/app_theme.dart';
import 'orchid_detail_screen.dart';
import 'add_edit_orchid_screen.dart';

class OrchidListScreen extends StatelessWidget {
  const OrchidListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orchids'),
      ),
      body: StreamBuilder<List<Orchid>>(
        stream: db.watchAllOrchids(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final orchids = snapshot.data ?? [];

          if (orchids.isEmpty) {
            return _buildEmptyState(context);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orchids.length,
            itemBuilder: (context, index) {
              return _buildOrchidCard(context, db, orchids[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddOrchid(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Orchid'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_florist_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No orchids yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the button below to add your first orchid',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => _navigateToAddOrchid(context),
            icon: const Icon(Icons.add),
            label: const Text('Add Your First Orchid'),
          ),
        ],
      ),
    );
  }

  Widget _buildOrchidCard(BuildContext context, AppDatabase db, Orchid orchid) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _navigateToDetail(context, orchid),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Orchid avatar/photo
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: orchid.photoPath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          orchid.photoPath!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.local_florist,
                            color: AppTheme.primaryGreen,
                            size: 32,
                          ),
                        ),
                      )
                    : const Icon(
                        Icons.local_florist,
                        color: AppTheme.primaryGreen,
                        size: 32,
                      ),
              ),
              const SizedBox(width: 16),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            orchid.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (orchid.isDemo)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Demo',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.orange,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (orchid.variety != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        orchid.variety!,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                    if (orchid.location != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            orchid.location!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              // Tasks summary
              FutureBuilder<List<CareTask>>(
                future: db.getTasksForOrchid(orchid.id),
                builder: (context, snapshot) {
                  final tasks = snapshot.data ?? [];
                  final dueToday = tasks.where((t) {
                    final now = DateTime.now();
                    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
                    return t.nextDue.isBefore(endOfDay) && t.enabled;
                  }).length;

                  if (dueToday > 0) {
                    return Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '$dueToday',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          const Text(
                            'due',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return const Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context, Orchid orchid) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrchidDetailScreen(orchidId: orchid.id),
      ),
    );
  }

  void _navigateToAddOrchid(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEditOrchidScreen(),
      ),
    );
  }
}
