// lib/screens/orchid_list_screen.dart
// OrchidLife - Grid view of all orchids

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/orchid.dart';
import '../services/database_service.dart';
import 'add_edit_orchid_screen.dart';
import 'orchid_detail_screen.dart';

class OrchidListScreen extends StatefulWidget {
  const OrchidListScreen({super.key});

  @override
  State<OrchidListScreen> createState() => _OrchidListScreenState();
}

class _OrchidListScreenState extends State<OrchidListScreen> {
  List<Orchid> _orchids = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrchids();
  }

  Future<void> _loadOrchids() async {
    setState(() => _isLoading = true);

    try {
      final isar = DatabaseService.isar;
      final orchids = await isar.orchids
          .filter()
          .isActiveEqualTo(true)
          .sortByName()
          .findAll();

      setState(() {
        _orchids = orchids;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading orchids: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _navigateToAdd() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEditOrchidScreen(),
      ),
    );

    if (result == true) {
      _loadOrchids();
    }
  }

  Future<void> _navigateToDetail(Orchid orchid) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => OrchidDetailScreen(orchid: orchid),
      ),
    );

    if (result == true) {
      _loadOrchids();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orchids'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _navigateToAdd,
            tooltip: 'Add Orchid',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _orchids.isEmpty
              ? _buildEmptyState()
              : _buildGrid(),
      floatingActionButton: _orchids.isNotEmpty
          ? FloatingActionButton(
              onPressed: _navigateToAdd,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildGrid() {
    return RefreshIndicator(
      onRefresh: _loadOrchids,
      child: GridView.builder(
        padding: const EdgeInsets.all(AppTheme.screenPadding),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          crossAxisSpacing: AppTheme.spacing3,
          mainAxisSpacing: AppTheme.spacing3,
        ),
        itemCount: _orchids.length,
        itemBuilder: (context, index) {
          return _buildOrchidCard(_orchids[index]);
        },
      ),
    );
  }

  Widget _buildOrchidCard(Orchid orchid) {
    return GestureDetector(
      onTap: () => _navigateToDetail(orchid),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Photo area
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.fromHex(orchid.colorTag).withOpacity(0.2),
                ),
                child: orchid.photoPath != null
                    ? Image.asset(
                        orchid.photoPath!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildPlaceholderIcon(orchid),
                      )
                    : _buildPlaceholderIcon(orchid),
              ),
            ),
            // Info area
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacing3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      orchid.displayName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      orchid.variety.commonName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    // Status row
                    Row(
                      children: [
                        Text(
                          orchid.bloomStatus.emoji,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            orchid.bloomStatus.displayName,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
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

  Widget _buildPlaceholderIcon(Orchid orchid) {
    return Center(
      child: Icon(
        Icons.local_florist,
        size: 48,
        color: AppTheme.fromHex(orchid.colorTag),
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
                color: AppTheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.local_florist_outlined,
                size: 64,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: AppTheme.spacing6),
            Text(
              'No Orchids Yet',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppTheme.spacing2),
            Text(
              'Add your first orchid to start\ntracking its care schedule',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
            const SizedBox(height: AppTheme.spacing6),
            ElevatedButton.icon(
              onPressed: _navigateToAdd,
              icon: const Icon(Icons.add),
              label: const Text('Add Orchid'),
            ),
          ],
        ),
      ),
    );
  }
}
