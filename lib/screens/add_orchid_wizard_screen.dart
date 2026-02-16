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
import '../widgets/section_header.dart';

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
          icon: const Icon(Icons.arrow_back),
          onPressed: _back,
        ),
        title: const Text('Add Orchid'),
        backgroundColor: AppTheme.sliverGradientStart,
        foregroundColor: AppTheme.textOnPrimary,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.sliverGradientStart, AppTheme.sliverGradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Step indicator
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: theme.dividerColor.withValues(alpha: 0.5))),
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            OutlinedButton(
              onPressed: _back,
              child: const Text('Back'),
            ),
          const Spacer(),
          if (_currentStep == 3) ...[
            TextButton(
              onPressed: _next,
              child: Text(
                'Skip',
                style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.5)),
              ),
            ),
            const SizedBox(width: 8),
          ],
          if (_currentStep < _totalSteps - 1)
            FilledButton(
              onPressed: _canProceed() ? _next : null,
              child: const Text('Next'),
            )
          else
            FilledButton.icon(
              onPressed: _canProceed() ? _saveOrchid : null,
              icon: const Icon(Icons.check, size: 18),
              label: const Text('Add to Collection'),
            ),
        ],
      ),
    );
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0: return true;
      case 1: return true;
      case 2: return _nameController.text.trim().isNotEmpty;
      case 3: return true;
      case 4: return true;
      case 5: return _nameController.text.trim().isNotEmpty;
      default: return true;
    }
  }

  // ── Step 1: Photo ──

  Widget _buildPhotoStep() {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SectionHeader(
            icon: Icons.camera_alt,
            color: AppTheme.primary,
            title: 'Start with a photo',
          ),
          const SizedBox(height: 4),
          Text(
            'Take a photo or choose from your gallery.',
            style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7), fontSize: 14),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GestureDetector(
              onTap: _pickPhoto,
              child: OrchidCard(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                child: _photoPath != null
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(AppTheme.radiusCard - 1),
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
                              icon: const Icon(Icons.close, size: 18),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.black45,
                                foregroundColor: Colors.white,
                              ),
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
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppTheme.primary.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.add_a_photo, size: 32, color: AppTheme.primary.withValues(alpha: 0.4)),
        ),
        const SizedBox(height: 16),
        Text('Tap to add a photo', style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 14)),
        const SizedBox(height: 4),
        Text('Optional', style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.4), fontSize: 12)),
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
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            icon: Icons.search,
            color: AppTheme.primary,
            title: 'Identify your orchid',
          ),
          const SizedBox(height: 4),
          Text(
            'Use AI to identify or select from the database.',
            style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7), fontSize: 14),
          ),
          const SizedBox(height: 20),
          // AI identification buttons
          if (_photoPath != null) ...[
            Text('Identify with AI', style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              letterSpacing: 0.3,
            )),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _aiChipButton('Google', Icons.search, AppTheme.statusUpcoming, () async {
                  final opened = await AIHandoffService.openGoogleLens(context);
                  if (!mounted || !opened) return;
                  AIHandoffService.showFollowUp(context, 'Google Lens', message: 'Opening Google Lens... Upload your orchid photo to identify the species.');
                }),
                _aiChipButton('Claude', Icons.psychology, AppTheme.fertilizerOrange, () async {
                  final opened = await AIHandoffService.openClaude(context);
                  if (!mounted || !opened) return;
                  AIHandoffService.showFollowUp(context, 'Claude', message: 'Opening Claude... Upload your orchid photo and ask "What orchid species is this?"');
                }),
                _aiChipButton('Perplexity', Icons.travel_explore, AppTheme.brandPerplexity, () async {
                  final opened = await AIHandoffService.openPerplexity(context);
                  if (!mounted || !opened) return;
                  AIHandoffService.showFollowUp(context, 'Perplexity', message: 'Opening Perplexity... Upload your orchid photo and ask "What orchid species is this?"');
                }),
              ],
            ),
            const SizedBox(height: 20),
          ],
          // Species database picker
          Text('Select from database', style: TextStyle(
            fontSize: 13, fontWeight: FontWeight.w600,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
            letterSpacing: 0.3,
          )),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: _speciesProfiles.length,
              itemBuilder: (context, index) {
                final sp = _speciesProfiles[index];
                final isSelected = _speciesProfileId == sp.id;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: OrchidCard(
                    margin: EdgeInsets.zero,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    onTap: () {
                      setState(() {
                        _speciesProfileId = isSelected ? null : sp.id;
                        if (!isSelected) {
                          _varietyController.text = sp.genus;
                          _prefillCareFromSpecies(sp);
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primary.withValues(alpha: 0.1)
                                : colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Image.asset(
                            'assets/orchid_types/${sp.genus.toLowerCase().trim()}.webp',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.local_florist,
                              color: isSelected ? AppTheme.primary : colorScheme.onSurface.withValues(alpha: 0.5),
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sp.commonName,
                                style: TextStyle(
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  fontSize: 15,
                                  color: isSelected ? AppTheme.primary : colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${sp.genus}${sp.difficultyLevel != null ? ' \u00b7 ${sp.difficultyLevel}' : ''}',
                                style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withValues(alpha: 0.55)),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.primary,
                            ),
                            child: const Icon(Icons.check, size: 14, color: Colors.white),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _aiChipButton(String label, IconData icon, Color color, VoidCallback onTap) {
    final theme = Theme.of(context);

    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: color, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: theme.colorScheme.onSurface,
        side: BorderSide(color: theme.dividerColor),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  void _prefillCareFromSpecies(SpeciesProfile sp) {
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
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            icon: Icons.edit,
            color: AppTheme.primary,
            title: 'Name & details',
          ),
          const SizedBox(height: 20),
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
          const SizedBox(height: 12),
          TextFormField(
            controller: _varietyController,
            decoration: const InputDecoration(
              labelText: 'Variety',
              hintText: 'e.g., Phalaenopsis',
              prefixIcon: Icon(Icons.category),
            ),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 12),
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
          OrchidCard(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.calendar_today, color: colorScheme.onSurface.withValues(alpha: 0.5)),
                  title: const Text('Date Acquired'),
                  subtitle: Text(_dateAcquired != null
                      ? '${_dateAcquired!.month}/${_dateAcquired!.day}/${_dateAcquired!.year}'
                      : 'Not set'),
                  trailing: _dateAcquired != null
                      ? IconButton(icon: const Icon(Icons.clear, size: 18), onPressed: () => setState(() => _dateAcquired = null))
                      : Icon(Icons.chevron_right, color: colorScheme.onSurface.withValues(alpha: 0.4)),
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
                Divider(height: 1, color: Theme.of(context).dividerColor.withValues(alpha: 0.4)),
                SwitchListTile(
                  secondary: Icon(Icons.healing, color: _isRescue ? AppTheme.statusOverdue : colorScheme.onSurface.withValues(alpha: 0.4)),
                  title: const Text('Rescue Orchid'),
                  subtitle: const Text('This orchid needs extra TLC'),
                  value: _isRescue,
                  onChanged: (value) => setState(() => _isRescue = value),
                  activeTrackColor: AppTheme.statusOverdue,
                ),
              ],
            ),
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
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SectionHeader(
            icon: Icons.health_and_safety,
            color: AppTheme.primary,
            title: 'Health check-up',
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Want an AI health assessment? This step is optional.',
              style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7), fontSize: 14),
            ),
          ),
          const SizedBox(height: 24),
          if (_photoPath != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              child: Image.file(
                File(_photoPath!),
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
            const SizedBox(height: 20),
          ],
          OrchidCard(
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.health_and_safety, size: 28, color: AppTheme.primary.withValues(alpha: 0.6)),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Get an AI health assessment',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  'Upload your orchid photo to an AI service.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 13),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _aiChipButton('Google', Icons.search, AppTheme.statusUpcoming, () async {
                      final opened = await AIHandoffService.openGoogleLens(context);
                      if (!mounted || !opened) return;
                      AIHandoffService.showFollowUp(context, 'Google Lens',
                          message: 'Opening Google Lens... Upload your orchid photo for a health check.');
                      setState(() => _healthCheckDone = true);
                    }),
                    _aiChipButton('Claude', Icons.psychology, AppTheme.fertilizerOrange, () async {
                      final opened = await AIHandoffService.openClaude(context);
                      if (!mounted || !opened) return;
                      AIHandoffService.showFollowUp(context, 'Claude',
                          message: 'Opening Claude... Upload your photo and ask "Is my orchid healthy?"');
                      setState(() => _healthCheckDone = true);
                    }),
                    _aiChipButton('Perplexity', Icons.travel_explore, AppTheme.brandPerplexity, () async {
                      final opened = await AIHandoffService.openPerplexity(context);
                      if (!mounted || !opened) return;
                      AIHandoffService.showFollowUp(context, 'Perplexity',
                          message: 'Opening Perplexity... Upload your photo for a health assessment.');
                      setState(() => _healthCheckDone = true);
                    }),
                  ],
                ),
                if (_healthCheckDone)
                  const Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, color: AppTheme.statusCompleted, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'Health check opened',
                          style: TextStyle(
                            color: AppTheme.statusCompleted,
                            fontSize: 13,
                          ),
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
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            icon: Icons.calendar_month,
            color: AppTheme.primary,
            title: 'Care schedule',
          ),
          const SizedBox(height: 4),
          Text(
            _speciesProfileId != null
                ? 'Pre-filled based on species. Adjust as needed.'
                : 'Set up care tasks for your orchid.',
            style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7), fontSize: 14),
          ),
          const SizedBox(height: 20),
          // Soak duration inside a card
          OrchidCard(
            margin: const EdgeInsets.only(bottom: 16),
            padding: EdgeInsets.zero,
            child: ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.waterBlue.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: const Icon(Icons.timer, color: AppTheme.waterBlue, size: 20),
              ),
              title: const Text('Soak Duration'),
              subtitle: Text('$_soakDuration minutes'),
              trailing: Icon(Icons.chevron_right, color: colorScheme.onSurface.withValues(alpha: 0.4)),
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
          ),
          // Care tasks header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Care Tasks', style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                letterSpacing: 0.3,
              )),
              TextButton.icon(
                onPressed: _addCareTask,
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add'),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.primary,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          if (_pendingCareTasks.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text('No care tasks yet', style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.45), fontSize: 13,
                )),
              ),
            )
          else
            OrchidCard(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              child: Column(
                children: _pendingCareTasks.asMap().entries.map((entry) {
                  final index = entry.key;
                  final task = entry.value;
                  final careType = task['careType'] as CareType;
                  final intervalDays = task['intervalDays'] as int;
                  final customLabel = task['customLabel'] as String?;
                  final displayName = customLabel ?? AppTheme.getCareTypeDisplayName(careType.name);
                  final color = AppTheme.getCareTypeColor(careType.name);
                  final icon = AppTheme.getCareTypeIcon(careType.name);

                  return Column(
                    children: [
                      if (index > 0)
                        Divider(height: 1, indent: 56, color: Theme.of(context).dividerColor.withValues(alpha: 0.4)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                              ),
                              child: Icon(icon, color: color, size: 18),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(displayName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                  Text('Every $intervalDays days', style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withValues(alpha: 0.55))),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.close, size: 18, color: colorScheme.onSurface.withValues(alpha: 0.35)),
                              onPressed: () => setState(() => _pendingCareTasks.removeAt(index)),
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _addCareTask() async {
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
    final colorScheme = Theme.of(context).colorScheme;
    final speciesName = _speciesProfileId != null
        ? _speciesProfiles.where((s) => s.id == _speciesProfileId).firstOrNull?.commonName
        : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            icon: Icons.check_circle_outline,
            color: AppTheme.primary,
            title: 'Review & save',
          ),
          const SizedBox(height: 20),
          // Hero card: photo + name
          OrchidCard(
            margin: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  child: _photoPath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                          child: Image.file(File(_photoPath!), fit: BoxFit.cover,
                            width: 72, height: 72,
                            errorBuilder: (_, __, ___) => const Icon(Icons.local_florist, color: AppTheme.primary, size: 32)),
                        )
                      : const Icon(Icons.local_florist, color: AppTheme.primary, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _nameController.text.isEmpty ? 'Unnamed' : _nameController.text,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      if (_varietyController.text.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(_varietyController.text, style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 14)),
                      ],
                      if (speciesName != null) ...[
                        const SizedBox(height: 2),
                        Text(speciesName, style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withValues(alpha: 0.55))),
                      ],
                      if (_isRescue) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.statusOverdue.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.healing, size: 12, color: AppTheme.statusOverdue),
                              SizedBox(width: 4),
                              Text('Rescue', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.statusOverdue)),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Details card
          if (_locationController.text.isNotEmpty || _dateAcquired != null)
            OrchidCard(
              margin: const EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  if (_locationController.text.isNotEmpty)
                    _reviewRow(Icons.location_on, 'Location', _locationController.text),
                  if (_locationController.text.isNotEmpty && _dateAcquired != null)
                    Divider(height: 1, color: Theme.of(context).dividerColor.withValues(alpha: 0.4)),
                  if (_dateAcquired != null)
                    _reviewRow(Icons.calendar_today, 'Acquired', '${_dateAcquired!.month}/${_dateAcquired!.day}/${_dateAcquired!.year}'),
                ],
              ),
            ),
          // Care schedule card
          OrchidCard(
            margin: const EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                // Soak duration row
                _reviewRow(Icons.timer, 'Soak', '$_soakDuration min'),
                if (_pendingCareTasks.isNotEmpty)
                  Divider(height: 1, color: Theme.of(context).dividerColor.withValues(alpha: 0.4)),
                ..._pendingCareTasks.asMap().entries.map((entry) {
                  final index = entry.key;
                  final task = entry.value;
                  final careType = task['careType'] as CareType;
                  final color = AppTheme.getCareTypeColor(careType.name);
                  final icon = AppTheme.getCareTypeIcon(careType.name);
                  final displayName = AppTheme.getCareTypeDisplayName(careType.name);

                  return Column(
                    children: [
                      if (index > 0)
                        Divider(height: 1, indent: 56, color: Theme.of(context).dividerColor.withValues(alpha: 0.4)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Row(
                          children: [
                            Icon(icon, color: color, size: 20),
                            const SizedBox(width: 12),
                            Expanded(child: Text(displayName, style: const TextStyle(fontSize: 14))),
                            Text(
                              'Every ${task['intervalDays']} days',
                              style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withValues(alpha: 0.55)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _reviewRow(IconData icon, String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: colorScheme.onSurface.withValues(alpha: 0.5)),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.55), fontSize: 13)),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
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
          content: Text('${_nameController.text.trim()} added to your collection'),
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
