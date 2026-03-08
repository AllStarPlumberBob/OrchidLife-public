import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database.dart';
import '../theme/app_theme.dart';

/// Shared dialog for adding a care task — used by both orchid detail and add/edit screens.
class AddCareTaskDialog extends StatefulWidget {
  const AddCareTaskDialog({super.key});

  @override
  State<AddCareTaskDialog> createState() => _AddCareTaskDialogState();
}

class _AddCareTaskDialogState extends State<AddCareTaskDialog> {
  CareType _selectedType = CareType.water;
  int _intervalDays = 7;
  DateTime? _firstDueDate;
  final _customLabelController = TextEditingController();
  late final TextEditingController _intervalController;

  @override
  void initState() {
    super.initState();
    _intervalController = TextEditingController(text: '$_intervalDays');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Care Task'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<CareType>(
              initialValue: _selectedType,
              decoration: const InputDecoration(labelText: 'Care Type'),
              items: CareType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Row(
                    children: [
                      Icon(
                        AppTheme.getCareTypeIcon(type.name),
                        color: AppTheme.getCareTypeColor(type.name),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(AppTheme.getCareTypeDisplayName(type.name)),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) setState(() => _selectedType = value);
              },
            ),
            const SizedBox(height: 16),
            if (_selectedType == CareType.other)
              TextField(
                controller: _customLabelController,
                decoration: const InputDecoration(
                  labelText: 'Custom Label',
                  hintText: 'e.g., Check roots',
                ),
              ),
            if (_selectedType == CareType.other) const SizedBox(height: 16),
            Row(
              children: [
                const Text('Every '),
                SizedBox(
                  width: 60,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    ),
                    controller: _intervalController,
                    onChanged: (value) {
                      final parsed = int.tryParse(value);
                      if (parsed != null && parsed > 0) {
                        setState(() => _intervalDays = parsed);
                      }
                    },
                  ),
                ),
                const Text(' days'),
              ],
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today, size: 20),
              title: const Text('First due date'),
              subtitle: Text(
                _firstDueDate != null
                    ? DateFormat.yMMMd().format(_firstDueDate!)
                    : 'Auto ($_intervalDays days from now)',
                style: TextStyle(
                  color: _firstDueDate != null
                      ? AppTheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              trailing: _firstDueDate != null
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () => setState(() => _firstDueDate = null),
                    )
                  : null,
              onTap: _pickFirstDueDate,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(context, {
              'careType': _selectedType,
              'intervalDays': _intervalDays,
              'customLabel': _selectedType == CareType.other
                  ? _customLabelController.text.isEmpty
                      ? null
                      : _customLabelController.text
                  : null,
              'firstDueDate': _firstDueDate,
            });
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  Future<void> _pickFirstDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _firstDueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _firstDueDate = picked);
    }
  }

  @override
  void dispose() {
    _customLabelController.dispose();
    _intervalController.dispose();
    super.dispose();
  }
}
