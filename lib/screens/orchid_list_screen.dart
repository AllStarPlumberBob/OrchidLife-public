import 'dart:io' show File;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/database.dart';
import '../theme/app_theme.dart';
import '../widgets/orchid_sliver_app_bar.dart';
import '../widgets/orchid_card.dart';
import '../widgets/bloom_stage_widget.dart';
import '../widgets/empty_state.dart';
import '../widgets/page_transitions.dart';
import 'orchid_detail_screen.dart';
import 'add_orchid_wizard_screen.dart';

class OrchidListScreen extends StatefulWidget {
  const OrchidListScreen({super.key});

  @override
  State<OrchidListScreen> createState() => _OrchidListScreenState();
}

class _OrchidListScreenState extends State<OrchidListScreen> {
  bool _isGalleryView = false;

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
                  OrchidSliverAppBar(
                    title: 'My Orchids',
                    actions: [
                      IconButton(
                        icon: Icon(_isGalleryView ? Icons.view_list : Icons.grid_view),
                        tooltip: _isGalleryView ? 'List view' : 'Gallery view',
                        onPressed: () => setState(() => _isGalleryView = !_isGalleryView),
                      ),
                    ],
                  ),
                  if (_isGalleryView)
                    SliverPadding(
                      padding: const EdgeInsets.all(12),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.78,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _GalleryCard(orchid: orchids[index]),
                          childCount: orchids.length,
                        ),
                      ),
                    )
                  else
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
                  // Bottom spacing so last card scrolls above the FAB
                  const SliverPadding(padding: EdgeInsets.only(bottom: 88)),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 24),
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
        builder: (context) => const AddOrchidWizardScreen(),
      ),
    );
  }
}

// ============================================================
// Gallery card for grid view
// ============================================================

class _GalleryCard extends StatelessWidget {
  final Orchid orchid;

  const _GalleryCard({required this.orchid});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          OrchidPageRoute(builder: (_) => OrchidDetailScreen(orchidId: orchid.id)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: orchid.photoPath != null
                  ? Image.file(
                      File(orchid.photoPath!),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder(),
                    )
                  : _placeholder(),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      orchid.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (orchid.variety != null)
                      Text(
                        orchid.variety!,
                        style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const Spacer(),
                    Row(
                      children: [
                        if (orchid.currentBloomStage != null)
                          BloomStageBadge(stage: orchid.currentBloomStage!),
                        if (orchid.isRescue) ...[
                          if (orchid.currentBloomStage != null) const SizedBox(width: 4),
                          const Icon(Icons.healing, size: 14, color: AppTheme.statusOverdue),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: AppTheme.primary.withValues(alpha: 0.1),
      child: const Center(
        child: Icon(Icons.local_florist, color: AppTheme.primary, size: 40),
      ),
    );
  }
}
