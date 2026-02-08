import 'dart:io' show File;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/database.dart';
import '../theme/app_theme.dart';
import '../widgets/orchid_sliver_app_bar.dart';
import '../widgets/orchid_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/page_transitions.dart';
import 'orchid_detail_screen.dart';
import 'add_edit_orchid_screen.dart';

class OrchidListScreen extends StatelessWidget {
  const OrchidListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);

    return Scaffold(
      body: StreamBuilder<List<Orchid>>(
        stream: db.watchAllOrchids(),
        builder: (context, orchidSnapshot) {
          if (orchidSnapshot.connectionState == ConnectionState.waiting) {
            return const CustomScrollView(
              slivers: [
                OrchidSliverAppBar(title: 'My Orchids'),
                SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                ),
              ],
            );
          }

          if (orchidSnapshot.hasError) {
            return CustomScrollView(
              slivers: [
                const OrchidSliverAppBar(title: 'My Orchids'),
                SliverFillRemaining(
                  child: Center(child: Text('Error: ${orchidSnapshot.error}')),
                ),
              ],
            );
          }

          final orchids = orchidSnapshot.data ?? [];

          if (orchids.isEmpty) {
            return CustomScrollView(
              slivers: [
                const OrchidSliverAppBar(title: 'My Orchids'),
                SliverFillRemaining(
                  child: EmptyState(
                    icon: Icons.local_florist_outlined,
                    title: 'No orchids yet',
                    subtitle: 'Tap the button below to add your first orchid',
                    action: FilledButton.icon(
                      onPressed: () => _navigateToAddOrchid(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Your First Orchid'),
                    ),
                  ),
                ),
              ],
            );
          }

          return StreamBuilder<Map<int, int>>(
            stream: db.watchDueTaskCountsByOrchid(),
            builder: (context, countsSnapshot) {
              final dueCounts = countsSnapshot.data ?? {};

              return CustomScrollView(
                slivers: [
                  const OrchidSliverAppBar(title: 'My Orchids'),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final orchid = orchids[index];
                          final dueCount = dueCounts[orchid.id] ?? 0;
                          return _buildOrchidCard(context, orchid, dueCount);
                        },
                        childCount: orchids.length,
                      ),
                    ),
                  ),
                  // Bottom spacing for floating nav
                  const SliverPadding(padding: EdgeInsets.only(bottom: 16)),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: FloatingActionButton.extended(
          onPressed: () => _navigateToAddOrchid(context),
          icon: const Icon(Icons.add),
          label: const Text('Add Orchid'),
        ),
      ),
    );
  }

  Widget _buildOrchidCard(BuildContext context, Orchid orchid, int dueCount) {
    return OrchidCard(
      onTap: () => _navigateToDetail(context, orchid),
      child: Row(
        children: [
          // Orchid avatar/photo
          Container(
            width: 64,
            height: 64,
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
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.local_florist,
                        color: AppTheme.primary,
                        size: 32,
                      ),
                    ),
                  )
                : const Icon(
                    Icons.local_florist,
                    color: AppTheme.primary,
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
                          color: AppTheme.accent.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                        ),
                        child: const Text(
                          'Demo',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.accent,
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
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
                if (orchid.location != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        orchid.location!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          // Tasks due indicator
          if (dueCount > 0)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.statusOverdue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Column(
                children: [
                  Text(
                    '$dueCount',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.statusOverdue,
                    ),
                  ),
                  const Text(
                    'due',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppTheme.statusOverdue,
                    ),
                  ),
                ],
              ),
            )
          else
            const Icon(
              Icons.chevron_right,
              color: AppTheme.textSecondary,
            ),
        ],
      ),
    );
  }

  void _navigateToDetail(BuildContext context, Orchid orchid) {
    Navigator.push(
      context,
      OrchidPageRoute(
        builder: (context) => OrchidDetailScreen(orchidId: orchid.id),
      ),
    );
  }

  void _navigateToAddOrchid(BuildContext context) {
    Navigator.push(
      context,
      OrchidPageRoute(
        builder: (context) => const AddEditOrchidScreen(),
      ),
    );
  }
}
