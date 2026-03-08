import 'dart:io' show File;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../database/database.dart';
import '../theme/app_theme.dart';
import '../widgets/orchid_sliver_app_bar.dart';

class PhotoJournalScreen extends StatefulWidget {
  final int orchidId;

  const PhotoJournalScreen({super.key, required this.orchidId});

  @override
  State<PhotoJournalScreen> createState() => _PhotoJournalScreenState();
}

class _PhotoJournalScreenState extends State<PhotoJournalScreen> {
  PhotoTag? _filterTag;

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);

    return Scaffold(
      body: StreamBuilder<List<PhotoJournalData>>(
        stream: db.watchPhotoJournalForOrchid(widget.orchidId),
        builder: (context, snapshot) {
          final allPhotos = snapshot.data ?? [];
          final photos = _filterTag == null
              ? allPhotos
              : allPhotos.where((p) => p.tag == _filterTag).toList();

          return CustomScrollView(
            slivers: [
              const OrchidSliverAppBar(
                title: 'Photo Journal',
                showBackButton: true,
              ),
              // Tag filter chips
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip(null, 'All', allPhotos.length),
                        const SizedBox(width: 8),
                        ...PhotoTag.values.map((tag) {
                          final count = allPhotos.where((p) => p.tag == tag).length;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _buildFilterChip(tag, _tagName(tag), count),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
              // Photo grid
              if (photos.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'No photos yet',
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.75,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _PhotoGridItem(
                        photo: photos[index],
                        onTap: () => _showPhotoDetail(context, photos[index], db),
                      ),
                      childCount: photos.length,
                    ),
                  ),
                ),
              SliverPadding(
                padding: EdgeInsets.only(bottom: 32 + MediaQuery.of(context).padding.bottom),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(PhotoTag? tag, String label, int count) {
    final isSelected = _filterTag == tag;
    return FilterChip(
      label: Text('$label ($count)'),
      selected: isSelected,
      onSelected: (_) => setState(() => _filterTag = isSelected ? null : tag),
      selectedColor: tag != null
          ? _tagColor(tag).withValues(alpha: 0.2)
          : AppTheme.primary.withValues(alpha: 0.2),
    );
  }

  void _showPhotoDetail(BuildContext context, PhotoJournalData photo, AppDatabase db) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Image.file(
                File(photo.photoPath),
                fit: BoxFit.cover,
                errorBuilder: (context, _, __) => Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: const Icon(Icons.broken_image, size: 64),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _tagColor(photo.tag).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                        ),
                        child: Text(
                          _tagName(photo.tag),
                          style: TextStyle(
                            fontSize: 12,
                            color: _tagColor(photo.tag),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        DateFormat.yMMMd().format(photo.dateTaken),
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  if (photo.note != null) ...[
                    const SizedBox(height: 8),
                    Text(photo.note!),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Delete Photo'),
                          content: const Text('Remove this photo from the journal?'),
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
                        await db.deletePhotoJournalEntry(photo.id);
                        if (context.mounted) Navigator.pop(context);
                      }
                    },
                    child: const Text('Delete', style: TextStyle(color: AppTheme.statusOverdue)),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _tagName(PhotoTag tag) {
    switch (tag) {
      case PhotoTag.bloom:
        return 'Bloom';
      case PhotoTag.repot:
        return 'Repot';
      case PhotoTag.newGrowth:
        return 'New Growth';
      case PhotoTag.rootCheck:
        return 'Root Check';
      case PhotoTag.general:
        return 'General';
    }
  }

  static Color _tagColor(PhotoTag tag) {
    switch (tag) {
      case PhotoTag.bloom:
        return AppTheme.bloom;
      case PhotoTag.repot:
        return AppTheme.repotBrown;
      case PhotoTag.newGrowth:
        return AppTheme.statusCompleted;
      case PhotoTag.rootCheck:
        return AppTheme.fertilizerOrange;
      case PhotoTag.general:
        return AppTheme.primary;
    }
  }
}

class _PhotoGridItem extends StatelessWidget {
  final PhotoJournalData photo;
  final VoidCallback onTap;

  const _PhotoGridItem({required this.photo, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.file(
                File(photo.photoPath),
                fit: BoxFit.cover,
                errorBuilder: (context, _, __) => Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: const Icon(Icons.broken_image),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: _PhotoJournalScreenState._tagColor(photo.tag).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                        ),
                        child: Text(
                          _PhotoJournalScreenState._tagName(photo.tag),
                          style: TextStyle(
                            fontSize: 10,
                            color: _PhotoJournalScreenState._tagColor(photo.tag),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat.MMMd().format(photo.dateTaken),
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (photo.note != null)
                    Text(
                      photo.note!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
