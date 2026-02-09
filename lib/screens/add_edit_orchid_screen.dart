import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drift/drift.dart' show Value;
import '../database/database.dart';
import '../services/notification_service.dart';
import '../theme/app_theme.dart';
import '../widgets/orchid_sliver_app_bar.dart';

class AddEditOrchidScreen extends StatefulWidget {
  final Orchid? orchid;

  const AddEditOrchidScreen({super.key, this.orchid});

  bool get isEditing => orchid != null;

  @override
  State<AddEditOrchidScreen> createState() => _AddEditOrchidScreenState();
}

class _AddEditOrchidScreenState extends State<AddEditOrchidScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _varietyController;
  late TextEditingController _locationController;
  late TextEditingController _notesController;
  DateTime? _dateAcquired;
  String? _photoPath;
  bool _addDefaultTasks = true;
  int _soakDuration = 15;
  final _imagePicker = ImagePicker();

  // Common orchid varieties for quick selection
  static const _commonVarieties = [
    'Phalaenopsis',
    'Dendrobium',
    'Cattleya',
    'Oncidium',
    'Vanda',
    'Paphiopedilum',
    'Cymbidium',
    'Miltonia',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.orchid?.name ?? '');
    _varietyController = TextEditingController(text: widget.orchid?.variety ?? '');
    _locationController = TextEditingController(text: widget.orchid?.location ?? '');
    _notesController = TextEditingController(text: widget.orchid?.notes ?? '');
    _dateAcquired = widget.orchid?.dateAcquired;
    _photoPath = widget.orchid?.photoPath;
    if (widget.isEditing) {
      _soakDuration = widget.orchid!.soakDurationMinutes;
    } else {
      _loadDefaultSoakDuration();
    }
  }

  Future<void> _loadDefaultSoakDuration() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _soakDuration = prefs.getInt('default_soak_duration') ?? 15;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: CustomScrollView(
          slivers: [
            OrchidSliverAppBar(
              title: widget.isEditing ? 'Edit Orchid' : 'Add Orchid',
              showBackButton: true,
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Photo
                  _buildPhotoSection(),
                  const SizedBox(height: 20),

                  // Name
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name *',
                      hintText: 'Give your orchid a name',
                      prefixIcon: Icon(Icons.local_florist),
                      counterText: '', // Hide character counter
                    ),
                    maxLength: 100,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 20),

                  // Variety
                  Autocomplete<String>(
                    initialValue: TextEditingValue(text: _varietyController.text),
                    optionsBuilder: (textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        return _commonVarieties;
                      }
                      return _commonVarieties.where((variety) =>
                          variety.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                    },
                    onSelected: (selection) {
                      _varietyController.text = selection;
                    },
                    fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                      return TextFormField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: const InputDecoration(
                          labelText: 'Variety',
                          hintText: 'e.g., Phalaenopsis',
                          prefixIcon: Icon(Icons.category),
                        ),
                        textCapitalization: TextCapitalization.words,
                        onChanged: (value) {
                          _varietyController.text = value;
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Location
                  TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: 'Location',
                      hintText: 'Where is this orchid placed?',
                      prefixIcon: Icon(Icons.location_on),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 20),

                  // Date acquired
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('Date Acquired'),
                    subtitle: Text(
                      _dateAcquired != null
                          ? '${_dateAcquired!.month}/${_dateAcquired!.day}/${_dateAcquired!.year}'
                          : 'Not set',
                    ),
                    trailing: _dateAcquired != null
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () => setState(() => _dateAcquired = null),
                          )
                        : null,
                    onTap: _selectDate,
                  ),
                  const SizedBox(height: 20),

                  // Notes
                  TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      labelText: 'Notes',
                      hintText: 'Any additional notes...',
                      prefixIcon: Icon(Icons.notes),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 20),

                  // Soak duration
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.waterBlue.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                      ),
                      child: const Icon(Icons.timer, color: AppTheme.waterBlue),
                    ),
                    title: const Text('Soak Duration'),
                    subtitle: Text('$_soakDuration minutes'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _selectSoakDuration,
                  ),
                  const SizedBox(height: 20),

                  // Add default tasks checkbox (only for new orchids)
                  if (!widget.isEditing) ...[
                    SwitchListTile(
                      title: const Text('Add default care tasks'),
                      subtitle: const Text('Water (7 days), Fertilize (30 days)'),
                      value: _addDefaultTasks,
                      onChanged: (value) => setState(() => _addDefaultTasks = value),
                      activeTrackColor: AppTheme.primary,
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Save button
                  FilledButton.icon(
                    onPressed: _saveOrchid,
                    icon: const Icon(Icons.save),
                    label: Text(widget.isEditing ? 'Save Changes' : 'Add Orchid'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                  // Bottom spacing for floating nav + system nav bar inset
                  SizedBox(height: 32 + MediaQuery.of(context).padding.bottom),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Center(
      child: GestureDetector(
        onTap: _showPhotoOptions,
        child: Column(
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(
                  color: AppTheme.primary.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: _photoPath != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMedium - 1),
                      child: Image.file(
                        File(_photoPath!),
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildPhotoPlaceholder(),
                      ),
                    )
                  : _buildPhotoPlaceholder(),
            ),
            const SizedBox(height: 8),
            Text(
              _photoPath != null ? 'Tap to change photo' : 'Add a photo',
              style: const TextStyle(
                color: AppTheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoPlaceholder() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_a_photo, color: AppTheme.primary, size: 40),
        SizedBox(height: 8),
        Text(
          'Tap to add',
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
        ),
      ],
    );
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            if (_photoPath != null)
              ListTile(
                leading: const Icon(Icons.delete, color: AppTheme.statusOverdue),
                title: const Text('Remove Photo',
                    style: TextStyle(color: AppTheme.statusOverdue)),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _photoPath = null);
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _imagePicker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (picked == null) return;

    // Copy to app documents directory for persistence
    final appDir = await getApplicationDocumentsDirectory();
    final photosDir = Directory(p.join(appDir.path, 'orchid_photos'));
    if (!await photosDir.exists()) {
      await photosDir.create(recursive: true);
    }
    final fileName = 'orchid_${DateTime.now().millisecondsSinceEpoch}${p.extension(picked.path)}';
    final savedFile = await File(picked.path).copy(p.join(photosDir.path, fileName));

    setState(() => _photoPath = savedFile.path);
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateAcquired ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _dateAcquired = picked);
    }
  }

  Future<void> _selectSoakDuration() async {
    final controller = TextEditingController(text: '$_soakDuration');

    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Soak Duration'),
        content: Row(
          children: [
            SizedBox(
              width: 60,
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                autofocus: true,
              ),
            ),
            const Text(' minutes'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final value = int.tryParse(controller.text);
              if (value != null && value >= 5 && value <= 60) {
                Navigator.pop(context, value);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() => _soakDuration = result);
    }
  }

  Future<void> _saveOrchid() async {
    if (!_formKey.currentState!.validate()) return;

    final db = Provider.of<AppDatabase>(context, listen: false);

    if (widget.isEditing) {
      // Update existing orchid
      await db.updateOrchid(widget.orchid!.copyWith(
        name: _nameController.text.trim(),
        variety: Value(_varietyController.text.trim().isEmpty ? null : _varietyController.text.trim()),
        location: Value(_locationController.text.trim().isEmpty ? null : _locationController.text.trim()),
        photoPath: Value(_photoPath),
        notes: Value(_notesController.text.trim().isEmpty ? null : _notesController.text.trim()),
        dateAcquired: Value(_dateAcquired),
        soakDurationMinutes: _soakDuration,
      ));

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Orchid updated')),
        );
      }
    } else {
      // Create new orchid
      final orchidId = await db.insertOrchid(OrchidsCompanion.insert(
        name: _nameController.text.trim(),
        variety: Value(_varietyController.text.trim().isEmpty ? null : _varietyController.text.trim()),
        location: Value(_locationController.text.trim().isEmpty ? null : _locationController.text.trim()),
        photoPath: Value(_photoPath),
        notes: Value(_notesController.text.trim().isEmpty ? null : _notesController.text.trim()),
        dateAcquired: Value(_dateAcquired),
        soakDurationMinutes: Value(_soakDuration),
      ));

      // Add default care tasks if requested
      if (_addDefaultTasks && mounted) {
        final now = DateTime.now();
        final notif = Provider.of<NotificationService>(context, listen: false);

        // Water every 7 days
        final waterId = await db.insertCareTask(CareTasksCompanion.insert(
          orchidId: orchidId,
          careType: CareType.water,
          intervalDays: 7,
          nextDue: now.add(const Duration(days: 7)),
        ));
        final waterTask = await db.getCareTaskById(waterId);
        if (waterTask != null && mounted) {
          await notif.scheduleTaskNotification(waterTask);
        }

        // Fertilize every 30 days
        final fertId = await db.insertCareTask(CareTasksCompanion.insert(
          orchidId: orchidId,
          careType: CareType.fertilize,
          intervalDays: 30,
          nextDue: now.add(const Duration(days: 30)),
        ));
        final fertTask = await db.getCareTaskById(fertId);
        if (fertTask != null && mounted) {
          await notif.scheduleTaskNotification(fertTask);
        }
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_nameController.text.trim()} added!'),
            backgroundColor: AppTheme.primary,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _varietyController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
