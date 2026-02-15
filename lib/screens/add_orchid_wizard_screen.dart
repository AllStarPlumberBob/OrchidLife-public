import 'dart:io' show File, Directory;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drift/drift.dart' show Value;
import '../database/database.dart';
import '../services/notification_service.dart';
import '../services/ai_handoff_service.dart';
import '../theme/app_theme.dart';
import '../widgets/step_indicator.dart';
import '../widgets/orchid_card.dart';

class AddOrchidWizardScreen extends StatefulWidget {
  const AddOrchidWizardScreen({super.key});

  @override
  State<AddOrchidWizardScreen> createState() => _AddOrchidWizardScreenState();
}

class _AddOrchidWizardScreenState extends State<AddOrchidWizardScreen> {
  final _pageController = PageController();
  int _currentStep = 0;
  static const _totalSteps = 6;

  // Step 1: Photo
  String? _photoPath;
  final _imagePicker = ImagePicker();

  // Step 2: Identify
  int? _speciesProfileId;
  List<SpeciesProfile> _speciesProfiles = [];

  // Step 3: Name & Details
  final _nameController = TextEditingController();
  final _varietyController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime? _dateAcquired;
  bool _isRescue = false;

  // Step 4: Health Check (skippable)
  bool _healthCheckDone = false;

  // Step 5: Care Setup
  int _soakDuration = 15;
  List<Map<String, dynamic>> _pendingCareTasks = [
    {'careType': CareType.water, 'intervalDays': 7, 'customLabel': null},
    {'careType': CareType.fertilize, 'intervalDays': 30, 'customLabel': null},
  ];

  static const _stepLabels = ['Photo', 'Identify', 'Details', 'Health', 'Care', 'Review'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final db = Provider.of<AppDatabase>(context, listen: false);
    final profiles = await db.getAllSpeciesProfiles();
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _speciesProfiles = profiles;
        _soakDuration = prefs.getInt('default_soak_duration') ?? 15;
      });
    }
  }

  void _goToStep(int step) {
    setState(() => _currentStep = step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _next() {
    if (_currentStep < _totalSteps - 1) {
      _goToStep(_currentStep + 1);
    }
  }

  void _back() {
    if (_currentStep > 0) {
      _goToStep(_currentStep - 1);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: _back,
        ),
        title: const Text('Add Orchid', style: TextStyle(color: AppTheme.textPrimary)),
        backgroundColor: AppTheme.background,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Step indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: StepIndicator(
              currentStep: _currentStep,
              totalSteps: _totalSteps,
              stepLabels: _stepLabels,
            ),
          ),
          // Page content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) => setState(() => _currentStep = index),
              children: [
                _buildPhotoStep(),
                _buildIdentifyStep(),
                _buildDetailsStep(),
                _buildHealthCheckStep(),
                _buildCareSetupStep(),
                _buildReviewStep(),
              ],
            ),
          ),
          // Bottom navigation
          _buildBottomNav(),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: AppTheme.divider)),
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            OutlinedButton(
              onPressed: _back,
              child: const Text('Back'),
            ),
          const Spacer(),
          if (_currentStep == 3) // Health check step - show skip
            TextButton(
              onPressed: _next,
              child: const Text('Skip'),
            ),
          const SizedBox(width: 8),
          if (_currentStep < _totalSteps - 1)
            FilledButton(
              onPressed: _canProceed() ? _next : null,
              child: const Text('Next'),
            )
          else
            FilledButton.icon(
              onPressed: _canProceed() ? _saveOrchid : null,
              icon: const Icon(Icons.check),
              label: const Text('Add to Collection'),
            ),
        ],
      ),
    );
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0: // Photo — optional
        return true;
      case 1: // Identify — optional
        return true;
      case 2: // Details — name required
        return _nameController.text.trim().isNotEmpty;
      case 3: // Health check — always can proceed
        return true;
      case 4: // Care setup — always can proceed
        return true;
      case 5: // Review — name required
        return _nameController.text.trim().isNotEmpty;
      default:
        return true;
    }
  }

  // ── Step 1: Photo ──

  Widget _buildPhotoStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Text(
            'Start with a photo',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Take a photo of your orchid or choose one from your gallery.',
            style: TextStyle(color: AppTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Expanded(
            child: GestureDetector(
              onTap: _pickPhoto,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                  border: Border.all(color: AppTheme.cardBorder, width: 2),
                ),
                child: _photoPath != null
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(AppTheme.radiusLarge - 1),
                            child: Image.file(
                              File(_photoPath!),
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _photoPlaceholder(),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: IconButton.filled(
                              onPressed: () => setState(() => _photoPath = null),
                              icon: const Icon(Icons.close),
                              style: IconButton.styleFrom(backgroundColor: Colors.black54),
                            ),
                          ),
                        ],
                      )
                    : _photoPlaceholder(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _photoPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_a_photo, size: 64, color: AppTheme.textSecondary.withValues(alpha: 0.5)),
        const SizedBox(height: 16),
        const Text('Tap to add a photo', style: TextStyle(color: AppTheme.textSecondary)),
        const SizedBox(height: 8),
        const Text('(Optional)', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
      ],
    );
  }

  Future<void> _pickPhoto() async {
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
    final picked = await _imagePicker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (picked == null) return;

    final appDir = await getApplicationDocumentsDirectory();
    final photosDir = Directory(p.join(appDir.path, 'orchid_photos'));
    if (!await photosDir.exists()) await photosDir.create(recursive: true);
    final fileName = 'orchid_${DateTime.now().millisecondsSinceEpoch}${p.extension(picked.path)}';
    final savedFile = await File(picked.path).copy(p.join(photosDir.path, fileName));

    if (!mounted) return;
    setState(() => _photoPath = savedFile.path);
  }

  // ── Step 2: Identify ──

  Widget _buildIdentifyStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Identify your orchid',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Use AI to identify your orchid species, or select from the database.',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 24),
          // AI identification buttons
          if (_photoPath != null) ...[
            const Text('Identify with AI:', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    AIHandoffService.openGoogleLens(context);
                    AIHandoffService.showFollowUp(context, 'Google Lens', message: 'Opening Google Lens... Upload your orchid photo to identify the species.');
                  },
                  icon: const Icon(Icons.search, color: AppTheme.statusUpcoming),
                  label: const Text('Google Lens'),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    AIHandoffService.openChatGPT(context);
                    AIHandoffService.showFollowUp(context, 'ChatGPT', message: 'Opening ChatGPT... Upload your orchid photo and ask "What orchid species is this?"');
                  },
                  icon: const Icon(Icons.chat_bubble, color: Color(0xFF10A37F)),
                  label: const Text('ChatGPT'),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
          // Species database picker
          const Text('Or select from database:', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: _speciesProfiles.length,
              itemBuilder: (context, index) {
                final sp = _speciesProfiles[index];
                final isSelected = _speciesProfileId == sp.id;
                return Card(
                  color: isSelected ? AppTheme.primary.withValues(alpha: 0.1) : null,
                  child: ListTile(
                    title: Text(
                      sp.commonName,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : null,
                        color: isSelected ? AppTheme.primary : null,
                      ),
                    ),
                    subtitle: Text(sp.genus),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: AppTheme.primary)
                        : Text(
                            sp.difficultyLevel ?? '',
                            style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                          ),
                    onTap: () {
                      setState(() {
                        _speciesProfileId = isSelected ? null : sp.id;
                        if (!isSelected) {
                          _varietyController.text = sp.genus;
                          // Pre-fill care based on species
                          _prefillCareFromSpecies(sp);
                        }
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _prefillCareFromSpecies(SpeciesProfile sp) {
    // Adjust watering interval based on difficulty
    final waterInterval = sp.difficultyLevel == 'Easy' ? 7 : 5;
    _pendingCareTasks = [
      {'careType': CareType.water, 'intervalDays': waterInterval, 'customLabel': null},
      {'careType': CareType.fertilize, 'intervalDays': 30, 'customLabel': null},
      {'careType': CareType.mist, 'intervalDays': 2, 'customLabel': null},
      {'careType': CareType.inspect, 'intervalDays': 14, 'customLabel': null},
    ];
  }

  // ── Step 3: Details ──

  Widget _buildDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Name & details',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Name *',
              hintText: 'Give your orchid a name',
              prefixIcon: Icon(Icons.local_florist),
            ),
            maxLength: 100,
            textCapitalization: TextCapitalization.words,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _varietyController,
            decoration: const InputDecoration(
              labelText: 'Variety',
              hintText: 'e.g., Phalaenopsis',
              prefixIcon: Icon(Icons.category),
            ),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 16),
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
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Date Acquired'),
            subtitle: Text(_dateAcquired != null
                ? '${_dateAcquired!.month}/${_dateAcquired!.day}/${_dateAcquired!.year}'
                : 'Not set'),
            trailing: _dateAcquired != null
                ? IconButton(icon: const Icon(Icons.clear), onPressed: () => setState(() => _dateAcquired = null))
                : null,
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _dateAcquired ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (picked != null) setState(() => _dateAcquired = picked);
            },
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            secondary: Icon(Icons.healing, color: _isRescue ? AppTheme.statusOverdue : AppTheme.textSecondary),
            title: const Text('Rescue Orchid'),
            subtitle: const Text('This orchid needs extra TLC'),
            value: _isRescue,
            onChanged: (value) => setState(() => _isRescue = value),
            activeTrackColor: AppTheme.statusOverdue,
          ),
          const SizedBox(height: 16),
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
        ],
      ),
    );
  }

  // ── Step 4: Health Check (optional) ──

  Widget _buildHealthCheckStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Text(
            'Health check-up',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Want an AI health assessment? This step is optional.',
            style: TextStyle(color: AppTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          if (_photoPath != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              child: Image.file(
                File(_photoPath!),
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
            const SizedBox(height: 24),
          ],
          OrchidCard(
            child: Column(
              children: [
                const Icon(Icons.health_and_safety, size: 48, color: AppTheme.primary),
                const SizedBox(height: 12),
                const Text(
                  'Get an AI health assessment',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Upload your orchid photo to an AI service for a health check.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        AIHandoffService.openChatGPT(context);
                        AIHandoffService.showFollowUp(context, 'ChatGPT',
                            message: 'Opening ChatGPT... Ask "Is my orchid healthy? What do you notice?"');
                        setState(() => _healthCheckDone = true);
                      },
                      icon: const Icon(Icons.chat_bubble, color: Color(0xFF10A37F)),
                      label: const Text('ChatGPT'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        AIHandoffService.openGemini(context);
                        AIHandoffService.showFollowUp(context, 'Gemini',
                            message: 'Opening Gemini... Upload your photo for a health assessment.');
                        setState(() => _healthCheckDone = true);
                      },
                      icon: const Icon(Icons.auto_awesome, color: AppTheme.statusUpcoming),
                      label: const Text('Gemini'),
                    ),
                  ],
                ),
                if (_healthCheckDone)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle, color: AppTheme.statusCompleted, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'Health check opened',
                          style: TextStyle(color: AppTheme.statusCompleted.withValues(alpha: 0.8)),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Step 5: Care Setup ──

  Widget _buildCareSetupStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Care schedule',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            _speciesProfileId != null
                ? 'Pre-filled based on species profile. Adjust as needed.'
                : 'Set up care tasks for your orchid.',
            style: const TextStyle(color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 24),
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
            onTap: () async {
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
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                    FilledButton(
                      onPressed: () {
                        final v = int.tryParse(controller.text);
                        if (v != null && v >= 5 && v <= 60) Navigator.pop(context, v);
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              );
              if (result != null) setState(() => _soakDuration = result);
            },
          ),
          const Divider(),
          // Care tasks
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Care Tasks', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              TextButton.icon(
                onPressed: _addCareTask,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add'),
              ),
            ],
          ),
          if (_pendingCareTasks.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('No care tasks', style: TextStyle(color: AppTheme.textSecondary)),
            )
          else
            ..._pendingCareTasks.asMap().entries.map((entry) {
              final index = entry.key;
              final task = entry.value;
              final careType = task['careType'] as CareType;
              final intervalDays = task['intervalDays'] as int;
              final customLabel = task['customLabel'] as String?;
              final displayName = customLabel ?? AppTheme.getCareTypeDisplayName(careType.name);
              final color = AppTheme.getCareTypeColor(careType.name);
              final icon = AppTheme.getCareTypeIcon(careType.name);

              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                title: Text(displayName),
                subtitle: Text('Every $intervalDays days'),
                trailing: IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => setState(() => _pendingCareTasks.removeAt(index)),
                ),
              );
            }),
        ],
      ),
    );
  }

  Future<void> _addCareTask() async {
    // Simple add care task dialog
    CareType? selectedType;
    final intervalController = TextEditingController(text: '7');

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Care Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: CareType.values.map((type) {
                  final isSelected = selectedType == type;
                  final color = AppTheme.getCareTypeColor(type.name);
                  return ChoiceChip(
                    label: Text(
                      AppTheme.getCareTypeDisplayName(type.name),
                      style: TextStyle(color: isSelected ? Colors.white : null),
                    ),
                    selected: isSelected,
                    selectedColor: color,
                    onSelected: (_) => setDialogState(() => selectedType = type),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Every '),
                  SizedBox(
                    width: 50,
                    child: TextField(
                      controller: intervalController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Text(' days'),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            FilledButton(
              onPressed: selectedType != null
                  ? () {
                      final days = int.tryParse(intervalController.text) ?? 7;
                      Navigator.pop(context, {
                        'careType': selectedType,
                        'intervalDays': days,
                        'customLabel': null,
                      });
                    }
                  : null,
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );

    if (result != null) {
      setState(() => _pendingCareTasks.add(result));
    }
  }

  // ── Step 6: Review ──

  Widget _buildReviewStep() {
    final speciesName = _speciesProfileId != null
        ? _speciesProfiles.where((s) => s.id == _speciesProfileId).firstOrNull?.commonName
        : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Review & save',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          // Photo + name card
          OrchidCard(
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  child: _photoPath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                          child: Image.file(File(_photoPath!), fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(Icons.local_florist, color: AppTheme.primary, size: 40)),
                        )
                      : const Icon(Icons.local_florist, color: AppTheme.primary, size: 40),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _nameController.text.isEmpty ? 'Unnamed' : _nameController.text,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      if (_varietyController.text.isNotEmpty)
                        Text(_varietyController.text, style: const TextStyle(color: AppTheme.textSecondary)),
                      if (speciesName != null)
                        Text('Species: $speciesName', style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                      if (_isRescue)
                        const Text('Rescue orchid', style: TextStyle(fontSize: 12, color: AppTheme.statusOverdue)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (_locationController.text.isNotEmpty)
            _reviewItem(Icons.location_on, 'Location', _locationController.text),
          if (_dateAcquired != null)
            _reviewItem(Icons.calendar_today, 'Acquired', '${_dateAcquired!.month}/${_dateAcquired!.day}/${_dateAcquired!.year}'),
          _reviewItem(Icons.timer, 'Soak Duration', '$_soakDuration minutes'),
          const SizedBox(height: 12),
          const Text('Care Schedule:', style: TextStyle(fontWeight: FontWeight.w600)),
          if (_pendingCareTasks.isEmpty)
            const Text('No care tasks', style: TextStyle(color: AppTheme.textSecondary))
          else
            ..._pendingCareTasks.map((task) {
              final careType = task['careType'] as CareType;
              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: Icon(AppTheme.getCareTypeIcon(careType.name), color: AppTheme.getCareTypeColor(careType.name)),
                title: Text(AppTheme.getCareTypeDisplayName(careType.name)),
                trailing: Text('Every ${task['intervalDays']} days'),
              );
            }),
        ],
      ),
    );
  }

  Widget _reviewItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppTheme.textSecondary),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(color: AppTheme.textSecondary)),
          Text(value),
        ],
      ),
    );
  }

  // ── Save ──

  Future<void> _saveOrchid() async {
    final db = Provider.of<AppDatabase>(context, listen: false);
    final notif = Provider.of<NotificationService>(context, listen: false);

    final orchidId = await db.insertOrchid(OrchidsCompanion.insert(
      name: _nameController.text.trim(),
      variety: Value(_varietyController.text.trim().isEmpty ? null : _varietyController.text.trim()),
      location: Value(_locationController.text.trim().isEmpty ? null : _locationController.text.trim()),
      photoPath: Value(_photoPath),
      notes: Value(_notesController.text.trim().isEmpty ? null : _notesController.text.trim()),
      dateAcquired: Value(_dateAcquired),
      soakDurationMinutes: Value(_soakDuration),
      isRescue: Value(_isRescue),
      speciesProfileId: Value(_speciesProfileId),
    ));

    // Create care tasks
    final now = DateTime.now();
    for (final task in _pendingCareTasks) {
      final intervalDays = task['intervalDays'] as int;
      final taskId = await db.insertCareTask(CareTasksCompanion.insert(
        orchidId: orchidId,
        careType: task['careType'] as CareType,
        intervalDays: intervalDays,
        nextDue: now.add(Duration(days: intervalDays)),
        customLabel: Value(task['customLabel'] as String?),
      ));
      final newTask = await db.getCareTaskById(taskId);
      if (newTask != null) await notif.scheduleTaskNotification(newTask);
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

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _varietyController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
