// lib/screens/add_edit_orchid_screen.dart
// OrchidLife - Add or edit an orchid

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../theme/app_theme.dart';
import '../models/orchid.dart';
import '../models/care_task.dart';
import '../services/database_service.dart';

class AddEditOrchidScreen extends StatefulWidget {
  final Orchid? orchid; // null = add mode, non-null = edit mode

  const AddEditOrchidScreen({super.key, this.orchid});

  @override
  State<AddEditOrchidScreen> createState() => _AddEditOrchidScreenState();
}

class _AddEditOrchidScreenState extends State<AddEditOrchidScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();

  OrchidVariety _selectedVariety = OrchidVariety.phalaenopsis;
  BloomStatus _selectedBloomStatus = BloomStatus.resting;
  String _selectedColor = AppTheme.orchidColors[0];
  bool _isSaving = false;
  bool _createDefaultTasks = true;

  bool get isEditMode => widget.orchid != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      final o = widget.orchid!;
      _nameController.text = o.name;
      _nicknameController.text = o.nickname ?? '';
      _locationController.text = o.location ?? '';
      _notesController.text = o.notes ?? '';
      _selectedVariety = o.variety;
      _selectedBloomStatus = o.bloomStatus;
      _selectedColor = o.colorTag;
      _createDefaultTasks = false; // Don't recreate tasks when editing
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nicknameController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final isar = DatabaseService.isar;

      final orchid = Orchid(
        id: isEditMode ? widget.orchid!.id : Isar.autoIncrement,
        name: _nameController.text.trim(),
        nickname: _nicknameController.text.trim().isEmpty
            ? null
            : _nicknameController.text.trim(),
        variety: _selectedVariety,
        colorTag: _selectedColor,
        location: _locationController.text.trim().isEmpty
            ? null
            : _locationController.text.trim(),
        bloomStatus: _selectedBloomStatus,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        isActive: true,
      );

      // Preserve createdAt when editing
      if (isEditMode) {
        orchid.createdAt = widget.orchid!.createdAt;
      }

      int orchidId = 0;
      await isar.writeTxn(() async {
        orchidId = await isar.orchids.put(orchid);
      });

      // Create default care tasks for new orchids
      if (!isEditMode && _createDefaultTasks) {
        await _createDefaultCareTasks(orchidId);
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      debugPrint('Error saving orchid: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppTheme.statusOverdue,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _createDefaultCareTasks(int orchidId) async {
    final isar = DatabaseService.isar;
    final now = DateTime.now();

    // Get default watering interval for this variety
    final wateringDays = _selectedVariety.defaultWateringDays;

    final tasks = [
      CareTask(
        orchidId: orchidId,
        careType: CareType.watering,
        intervalDays: wateringDays,
        preferredTime: '09:00',
        instructions: CareType.watering.defaultInstructions,
        isActive: true,
        nextDue: now.add(Duration(days: wateringDays)),
      ),
      CareTask(
        orchidId: orchidId,
        careType: CareType.fertilizing,
        intervalDays: 30,
        preferredTime: '09:00',
        instructions: CareType.fertilizing.defaultInstructions,
        isActive: true,
        nextDue: now.add(const Duration(days: 30)),
      ),
      CareTask(
        orchidId: orchidId,
        careType: CareType.inspection,
        intervalDays: 7,
        preferredTime: '10:00',
        instructions: CareType.inspection.defaultInstructions,
        isActive: true,
        nextDue: now.add(const Duration(days: 7)),
      ),
    ];

    await isar.writeTxn(() async {
      await isar.careTasks.putAll(tasks);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Orchid' : 'Add Orchid'),
        actions: [
          if (_isSaving)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _save,
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppTheme.screenPadding),
          children: [
            // Name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name *',
                hintText: 'e.g., Kitchen Window Orchid',
                prefixIcon: Icon(Icons.local_florist),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a name';
                }
                if (value.length > 50) {
                  return 'Name must be 50 characters or less';
                }
                return null;
              },
            ),
            const SizedBox(height: AppTheme.spacing4),

            // Nickname
            TextFormField(
              controller: _nicknameController,
              decoration: const InputDecoration(
                labelText: 'Nickname (optional)',
                hintText: 'e.g., Rosie',
                prefixIcon: Icon(Icons.favorite_outline),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: AppTheme.spacing4),

            // Variety
            DropdownButtonFormField<OrchidVariety>(
              value: _selectedVariety,
              decoration: const InputDecoration(
                labelText: 'Variety',
                prefixIcon: Icon(Icons.category),
              ),
              items: OrchidVariety.values.map((variety) {
                return DropdownMenuItem(
                  value: variety,
                  child: Text('${variety.displayName} (${variety.commonName})'),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedVariety = value);
                }
              },
            ),
            const SizedBox(height: AppTheme.spacing4),

            // Location
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location (optional)',
                hintText: 'e.g., Living room windowsill',
                prefixIcon: Icon(Icons.place_outlined),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: AppTheme.spacing4),

            // Bloom Status
            DropdownButtonFormField<BloomStatus>(
              value: _selectedBloomStatus,
              decoration: const InputDecoration(
                labelText: 'Bloom Status',
                prefixIcon: Icon(Icons.filter_vintage),
              ),
              items: BloomStatus.values.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status.displayName),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedBloomStatus = value);
                }
              },
            ),
            const SizedBox(height: AppTheme.spacing6),

            // Color picker
            Text(
              'Color Tag',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppTheme.spacing2),
            Wrap(
              spacing: AppTheme.spacing2,
              runSpacing: AppTheme.spacing2,
              children: AppTheme.orchidColors.map((color) {
                final isSelected = color == _selectedColor;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppTheme.fromHex(color),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? AppTheme.textPrimary : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 24)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppTheme.spacing6),

            // Notes
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                hintText: 'Any special care notes...',
                prefixIcon: Icon(Icons.notes),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              maxLength: 500,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: AppTheme.spacing4),

            // Create default tasks toggle (only for new orchids)
            if (!isEditMode)
              SwitchListTile(
                value: _createDefaultTasks,
                onChanged: (value) => setState(() => _createDefaultTasks = value),
                title: const Text('Create default care schedule'),
                subtitle: Text(
                  'Adds watering, fertilizing, and inspection tasks based on ${_selectedVariety.displayName} recommendations',
                ),
                secondary: const Icon(Icons.schedule),
              ),

            const SizedBox(height: AppTheme.spacing8),

            // Save button
            ElevatedButton(
              onPressed: _isSaving ? null : _save,
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(isEditMode ? 'Update Orchid' : 'Add Orchid'),
            ),
          ],
        ),
      ),
    );
  }
}
