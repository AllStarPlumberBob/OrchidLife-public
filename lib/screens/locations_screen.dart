import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' show Value;
import 'package:intl/intl.dart';
import '../database/database.dart';
import '../theme/app_theme.dart';
import '../widgets/orchid_sliver_app_bar.dart';
import '../widgets/orchid_card.dart';

class LocationsScreen extends StatelessWidget {
  const LocationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);

    return Scaffold(
      body: StreamBuilder<List<GrowingLocation>>(
        stream: db.watchAllGrowingLocations(),
        builder: (context, snapshot) {
          final locations = snapshot.data ?? [];

          return CustomScrollView(
            slivers: [
              const OrchidSliverAppBar(
                title: 'Growing Locations',
                showBackButton: true,
              ),
              if (locations.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on_outlined, size: 64, color: AppTheme.textSecondary),
                        SizedBox(height: 16),
                        Text('No locations yet', style: TextStyle(color: AppTheme.textSecondary)),
                        SizedBox(height: 8),
                        Text('Add a growing location to track\nlight conditions by spot.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _LocationCard(
                        location: locations[index],
                        db: db,
                      ),
                      childCount: locations.length,
                    ),
                  ),
                ),
              SliverPadding(
                padding: EdgeInsets.only(bottom: 88 + MediaQuery.of(context).padding.bottom),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: FloatingActionButton.extended(
          onPressed: () => _addLocation(context, Provider.of<AppDatabase>(context, listen: false)),
          icon: const Icon(Icons.add),
          label: const Text('Add Location'),
        ),
      ),
    );
  }

  Future<void> _addLocation(BuildContext context, AppDatabase db) async {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Location'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name *',
                hintText: 'e.g., East Window',
                prefixIcon: Icon(Icons.location_on),
              ),
              textCapitalization: TextCapitalization.words,
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'e.g., Morning sun, afternoon shade',
              ),
              maxLines: 2,
              textCapitalization: TextCapitalization.sentences,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                Navigator.pop(context, true);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (result == true) {
      await db.insertGrowingLocation(GrowingLocationsCompanion.insert(
        name: nameController.text.trim(),
        description: Value(descController.text.trim().isEmpty ? null : descController.text.trim()),
      ));
    }
  }
}

class _LocationCard extends StatelessWidget {
  final GrowingLocation location;
  final AppDatabase db;

  const _LocationCard({required this.location, required this.db});

  @override
  Widget build(BuildContext context) {
    return OrchidCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: const Icon(Icons.location_on, color: AppTheme.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location.name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    if (location.description != null)
                      Text(
                        location.description!,
                        style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                      ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'delete') {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Delete Location'),
                        content: Text('Remove "${location.name}"?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                          FilledButton(
                            style: FilledButton.styleFrom(backgroundColor: AppTheme.statusOverdue),
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      await db.deleteGrowingLocation(location.id);
                    }
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ],
          ),
          if (location.latestLuxReading != null) ...[
            const Divider(height: 20),
            Row(
              children: [
                const Icon(Icons.light_mode, size: 16, color: AppTheme.statusNeedsCare),
                const SizedBox(width: 4),
                Text(
                  '${location.latestLuxReading!.toStringAsFixed(0)} lux',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                if (location.lastReadingAt != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    DateFormat.MMMd().format(location.lastReadingAt!),
                    style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
