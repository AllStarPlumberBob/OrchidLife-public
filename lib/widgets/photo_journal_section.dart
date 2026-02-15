import 'dart:io' show Directory, File;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:drift/drift.dart' show Value;
import '../database/database.dart';
import '../theme/app_theme.dart';
import '../screens/photo_journal_screen.dart';
import 'orchid_card.dart';
import 'page_transitions.dart';

class PhotoJournalSection extends StatelessWidget {
  final int orchidId;
  final AppDatabase db;

  const PhotoJournalSection({
    super.key,
    required this.orchidId,
    required this.db,
  });

  @override
  Widget build(BuildContext context) {
    return OrchidCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.photo_library, color: AppTheme.primary, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Photo Journal',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton.icon(
                    onPressed: () => _addPhoto(context),
                    icon: const Icon(Icons.add_a_photo, size: 16),
                    label: const Text('Add'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          StreamBuilder<List<PhotoJournalData>>(
            stream: db.watchPhotoJournalForOrchid(orchidId),
            builder: (context, snapshot) {
              final photos = snapshot.data ?? [];

              if (photos.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'No photos yet — capture your orchid\'s journey!',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                );
              }

              return Column(
                children: [
                  SizedBox(
                    height: 120,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: photos.length > 6 ? 7 : photos.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        if (index == 6 && photos.length > 6) {
                          return GestureDetector(
                            onTap: () => _viewAll(context),
                            child: Container(
                              width: 100,
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceVariant,
                                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.photo_library, color: AppTheme.primary),
                                  const SizedBox(height: 4),
                                  Text(
                                    'View all ${photos.length}',
                                    style: const TextStyle(
                                      color: AppTheme.primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        final photo = photos[index];
                        return _PhotoThumbnail(photo: photo, onTap: () => _viewAll(context));
                      },
                    ),
                  ),
                  if (photos.length > 1)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextButton(
                        onPressed: () => _viewAll(context),
                        child: Text('View all ${photos.length} photos'),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  void _viewAll(BuildContext context) {
    Navigator.push(
      context,
      OrchidPageRoute(
        builder: (_) => PhotoJournalScreen(orchidId: orchidId),
      ),
    );
  }

  Future<void> _addPhoto(BuildContext context) async {
    final picker = ImagePicker();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final picked = await picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (picked == null || !context.mounted) return;

    // Copy to app storage
    final String savedPath;
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final photosDir = Directory(p.join(appDir.path, 'orchid_photos'));
      if (!await photosDir.exists()) {
        await photosDir.create(recursive: true);
      }
      final fileName = 'journal_${DateTime.now().millisecondsSinceEpoch}${p.extension(picked.path)}';
      final savedFile = await File(picked.path).copy(p.join(photosDir.path, fileName));
      savedPath = savedFile.path;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not save photo')),
        );
      }
      return;
    }

    if (!context.mounted) return;

    // Show tag selection dialog
    final result = await showDialog<({PhotoTag tag, String? note})>(
      context: context,
      builder: (context) => _PhotoTagDialog(),
    );

    if (result != null && context.mounted) {
      await db.insertPhotoJournalEntry(PhotoJournalCompanion.insert(
        orchidId: orchidId,
        photoPath: savedPath,
        dateTaken: DateTime.now(),
        note: Value(result.note),
        tag: result.tag,
      ));
    }
  }
}

class _PhotoThumbnail extends StatelessWidget {
  final PhotoJournalData photo;
  final VoidCallback onTap;

  const _PhotoThumbnail({required this.photo, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final tagColor = _getTagColor(photo.tag);

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            child: Image.file(
              File(photo.photoPath),
              width: 100,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 100,
                height: 120,
                color: AppTheme.surfaceVariant,
                child: const Icon(Icons.broken_image, color: AppTheme.textSecondary),
              ),
            ),
          ),
          Positioned(
            bottom: 4,
            left: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: tagColor.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Text(
                _getTagName(photo.tag),
                style: const TextStyle(
                  fontSize: 9,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Color _getTagColor(PhotoTag tag) {
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

  static String _getTagName(PhotoTag tag) {
    switch (tag) {
      case PhotoTag.bloom:
        return 'Bloom';
      case PhotoTag.repot:
        return 'Repot';
      case PhotoTag.newGrowth:
        return 'Growth';
      case PhotoTag.rootCheck:
        return 'Roots';
      case PhotoTag.general:
        return 'General';
    }
  }
}

class _PhotoTagDialog extends StatefulWidget {
  @override
  State<_PhotoTagDialog> createState() => _PhotoTagDialogState();
}

class _PhotoTagDialogState extends State<_PhotoTagDialog> {
  PhotoTag _selectedTag = PhotoTag.general;
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add to Journal'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tag this photo:', style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: PhotoTag.values.map((tag) {
              final isSelected = _selectedTag == tag;
              return ChoiceChip(
                label: Text(
                  _PhotoThumbnail._getTagName(tag),
                  style: TextStyle(color: isSelected ? Colors.white : null),
                ),
                selected: isSelected,
                selectedColor: _PhotoThumbnail._getTagColor(tag),
                onSelected: (_) => setState(() => _selectedTag = tag),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _noteController,
            decoration: const InputDecoration(
              labelText: 'Note (optional)',
              hintText: 'What\'s happening?',
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
            tag: _selectedTag,
            note: _noteController.text.isEmpty ? null : _noteController.text,
          )),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
