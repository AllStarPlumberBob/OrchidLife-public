import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' show Value;
import '../database/database.dart';
import '../services/notification_service.dart';
import '../theme/app_theme.dart';

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
  bool _addDefaultTasks = true;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Orchid' : 'Add Orchid'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name *',
                hintText: 'Give your orchid a name',
                prefixIcon: Icon(Icons.local_florist),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),

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
                // Sync with our controller
                controller.text = _varietyController.text;
                controller.addListener(() {
                  _varietyController.text = controller.text;
                });
                return TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                    labelText: 'Variety',
                    hintText: 'e.g., Phalaenopsis',
                    prefixIcon: Icon(Icons.category),
                  ),
                  textCapitalization: TextCapitalization.words,
                );
              },
            ),
            const SizedBox(height: 16),

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
            const SizedBox(height: 16),

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
            const SizedBox(height: 16),

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
            const SizedBox(height: 16),

            // Add default tasks checkbox (only for new orchids)
            if (!widget.isEditing) ...[
              SwitchListTile(
                title: const Text('Add default care tasks'),
                subtitle: const Text('Water (7 days), Fertilize (30 days)'),
                value: _addDefaultTasks,
                onChanged: (value) => setState(() => _addDefaultTasks = value),
                activeColor: AppTheme.primaryGreen,
              ),
              const SizedBox(height: 16),
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
          ],
        ),
      ),
    );
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

  Future<void> _saveOrchid() async {
    if (!_formKey.currentState!.validate()) return;

    final db = Provider.of<AppDatabase>(context, listen: false);

    if (widget.isEditing) {
      // Update existing orchid
      await db.updateOrchid(widget.orchid!.copyWith(
        name: _nameController.text.trim(),
        variety: Value(_varietyController.text.trim().isEmpty ? null : _varietyController.text.trim()),
        location: Value(_locationController.text.trim().isEmpty ? null : _locationController.text.trim()),
        notes: Value(_notesController.text.trim().isEmpty ? null : _notesController.text.trim()),
        dateAcquired: Value(_dateAcquired),
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
        notes: Value(_notesController.text.trim().isEmpty ? null : _notesController.text.trim()),
        dateAcquired: Value(_dateAcquired),
      ));

      // Add default care tasks if requested
      if (_addDefaultTasks) {
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
        if (waterTask != null) await notif.scheduleTaskNotification(waterTask);

        // Fertilize every 30 days
        final fertId = await db.insertCareTask(CareTasksCompanion.insert(
          orchidId: orchidId,
          careType: CareType.fertilize,
          intervalDays: 30,
          nextDue: now.add(const Duration(days: 30)),
        ));
        final fertTask = await db.getCareTaskById(fertId);
        if (fertTask != null) await notif.scheduleTaskNotification(fertTask);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_nameController.text.trim()} added!'),
            backgroundColor: AppTheme.primaryGreen,
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
