import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' show Value;
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'dart:async';
import 'dart:io' show File, Platform;
import '../database/database.dart';
import '../theme/app_theme.dart';
import '../services/light_sensor_service.dart';
import '../widgets/orchid_sliver_app_bar.dart';
import '../widgets/orchid_card.dart';
import '../widgets/page_transitions.dart';

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const OrchidSliverAppBar(title: 'Tools'),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildToolCard(
                  context,
                  icon: Icons.light_mode,
                  title: 'Light Meter',
                  subtitle: 'Measure light levels for optimal placement',
                  color: AppTheme.statusNeedsCare,
                  onTap: () => Navigator.push(
                    context,
                    OrchidPageRoute(builder: (_) => const LuxMeterScreen()),
                  ),
                ),
                const SizedBox(height: 4),
                _buildToolCard(
                  context,
                  icon: Icons.camera_alt,
                  title: 'AI Plant Doctor',
                  subtitle: 'Take a photo and get expert diagnosis',
                  color: AppTheme.primary,
                  onTap: () => Navigator.push(
                    context,
                    OrchidPageRoute(builder: (_) => const AIHandoffScreen()),
                  ),
                ),
                const SizedBox(height: 4),
                _buildToolCard(
                  context,
                  icon: Icons.book,
                  title: 'Care Guide',
                  subtitle: 'Learn about orchid care basics',
                  color: AppTheme.inspectPurple,
                  onTap: () => Navigator.push(
                    context,
                    OrchidPageRoute(builder: (_) => const CareGuideScreen()),
                  ),
                ),
                const SizedBox(height: 16),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return OrchidCard(
      onTap: onTap,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
        ],
      ),
    );
  }
}

// ============================================================
// LUX METER SCREEN
// ============================================================

class LuxMeterScreen extends StatefulWidget {
  const LuxMeterScreen({super.key});

  @override
  State<LuxMeterScreen> createState() => _LuxMeterScreenState();
}

class _LuxMeterScreenState extends State<LuxMeterScreen> {
  double _currentLux = 0;
  StreamSubscription? _luxSubscription;
  bool _isReading = false;
  bool? _hasSensor;      // null = checking, true/false = result
  String? _sensorError;  // non-null if sensor unavailable or stream errored

  @override
  void initState() {
    super.initState();
    _checkSensor();
  }

  Future<void> _checkSensor() async {
    final service = Provider.of<LightSensorService>(context, listen: false);
    try {
      final available = await service.hasSensor();
      if (mounted) setState(() => _hasSensor = available);
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasSensor = false;
          _sensorError = 'Could not access light sensor: $e';
        });
      }
    }
  }

  @override
  void dispose() {
    _luxSubscription?.cancel();
    super.dispose();
  }

  void _startReading() {
    final service = Provider.of<LightSensorService>(context, listen: false);
    setState(() {
      _isReading = true;
      _sensorError = null;
    });

    _luxSubscription = service.luxStream().listen(
      (double lux) {
        // Validate lux value: must be non-negative and finite
        final sanitizedLux = (lux.isFinite && lux >= 0) ? lux : 0.0;
        if (mounted) setState(() => _currentLux = sanitizedLux);
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _isReading = false;
            _sensorError = 'Sensor error: $error';
          });
        }
      },
    );
  }

  void _stopReading() {
    _luxSubscription?.cancel();
    setState(() => _isReading = false);
  }

  String _getLightLevel(double lux) {
    if (lux < 500) return 'Low Light';
    if (lux < 1000) return 'Medium Light';
    if (lux < 5000) return 'Bright Indirect';
    if (lux < 10000) return 'Bright Light';
    return 'Direct Sunlight';
  }

  Color _getLightColor(double lux) {
    if (lux < 500) return AppTheme.textSecondary;
    if (lux < 1000) return AppTheme.statusUpcoming;
    if (lux < 5000) return AppTheme.statusCompleted;
    if (lux < 10000) return AppTheme.statusNeedsCare;
    return AppTheme.statusOverdue;
  }

  String _getOrchidRecommendation(double lux) {
    if (lux < 500) {
      return 'Too dark for most orchids. Consider Paphiopedilum which tolerates lower light.';
    } else if (lux < 1000) {
      return 'Good for Phalaenopsis and Paphiopedilum. May be too dark for Cattleya or Vanda.';
    } else if (lux < 5000) {
      return 'Ideal for most orchids! Perfect for Phalaenopsis, Oncidium, and Dendrobium.';
    } else if (lux < 10000) {
      return 'Great for Cattleya and Dendrobium. May be too bright for Phalaenopsis.';
    } else {
      return 'Too bright for most orchids. Only Vanda can handle this much light. Add shade.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const OrchidSliverAppBar(
            title: 'Light Meter',
            showBackButton: true,
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Lux display
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Sensor status banners
                        if (_hasSensor == null)
                          const Padding(
                            padding: EdgeInsets.only(bottom: 16),
                            child: LinearProgressIndicator(),
                          ),
                        if (_hasSensor == false)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Card(
                              color: AppTheme.statusNeedsCare.withValues(alpha: 0.1),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    const Icon(Icons.warning_amber_rounded, color: AppTheme.statusNeedsCare),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        _sensorError ?? 'This device does not have an ambient light sensor.',
                                        style: const TextStyle(color: AppTheme.textPrimary),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        if (_sensorError != null && _hasSensor == true)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Card(
                              color: AppTheme.statusOverdue.withValues(alpha: 0.1),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    const Icon(Icons.error_outline, color: AppTheme.statusOverdue),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        _sensorError!,
                                        style: const TextStyle(color: AppTheme.textPrimary),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _getLightColor(_currentLux).withValues(alpha: 0.1),
                            border: Border.all(
                              color: _getLightColor(_currentLux),
                              width: 4,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _currentLux.toStringAsFixed(0),
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: _getLightColor(_currentLux),
                                ),
                              ),
                              const Text(
                                'lux',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          _getLightLevel(_currentLux),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: _getLightColor(_currentLux),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            _getOrchidRecommendation(_currentLux),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Controls
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _hasSensor == true
                              ? (_isReading ? _stopReading : _startReading)
                              : null,
                          icon: Icon(_isReading ? Icons.stop : Icons.play_arrow),
                          label: Text(_isReading ? 'Stop' : 'Start'),
                          style: FilledButton.styleFrom(
                            backgroundColor: _isReading ? AppTheme.statusOverdue : AppTheme.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _currentLux > 0
                              ? () => _saveReading(context, db)
                              : null,
                          icon: const Icon(Icons.save),
                          label: const Text('Save'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Light guide
                  OrchidCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Light Level Guide',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        _buildLightGuideRow('< 500 lux', 'Low', AppTheme.textSecondary),
                        _buildLightGuideRow('500-1000', 'Medium', AppTheme.statusUpcoming),
                        _buildLightGuideRow('1000-5000', 'Bright Indirect', AppTheme.statusCompleted),
                        _buildLightGuideRow('5000-10000', 'Bright', AppTheme.statusNeedsCare),
                        _buildLightGuideRow('> 10000', 'Direct Sun', AppTheme.statusOverdue),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLightGuideRow(String range, String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Text(range),
          const Spacer(),
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Future<void> _saveReading(BuildContext context, AppDatabase db) async {
    if (!context.mounted) return;
    final orchids = await db.getAllOrchids();

    if (!context.mounted) return;
    // Show dialog and get result (returns null if cancelled)
    final result = await showDialog<({int? orchidId, String? location})>(
      context: context,
      builder: (context) => _SaveReadingDialog(orchids: orchids),
    );

    if (result != null) {
      await db.insertLightReading(LightReadingsCompanion.insert(
        luxValue: _currentLux,
        readingAt: DateTime.now(),
        orchidId: Value(result.orchidId),
        locationName: Value(result.location),
      ));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reading saved!')),
        );
      }
    }
  }
}

/// Dialog widget for saving light readings with proper state management
class _SaveReadingDialog extends StatefulWidget {
  final List<Orchid> orchids;

  const _SaveReadingDialog({required this.orchids});

  @override
  State<_SaveReadingDialog> createState() => _SaveReadingDialogState();
}

class _SaveReadingDialogState extends State<_SaveReadingDialog> {
  final _locationController = TextEditingController();
  int? _selectedOrchidId;

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Save Reading'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Orchid selector dropdown
          DropdownButtonFormField<int?>(
            initialValue: _selectedOrchidId,
            decoration: const InputDecoration(
              labelText: 'Link to orchid (optional)',
              prefixIcon: Icon(Icons.local_florist),
            ),
            items: [
              const DropdownMenuItem<int?>(
                value: null,
                child: Text('No specific orchid'),
              ),
              ...widget.orchids.map((orchid) => DropdownMenuItem<int?>(
                value: orchid.id,
                child: Text(orchid.name),
              )),
            ],
            onChanged: (value) {
              setState(() => _selectedOrchidId = value);
            },
          ),
          const SizedBox(height: 16),
          // Location text field
          TextField(
            controller: _locationController,
            decoration: const InputDecoration(
              labelText: 'Location name',
              hintText: 'e.g., Living room window',
              prefixIcon: Icon(Icons.location_on),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(
            context,
            (
              orchidId: _selectedOrchidId,
              location: _locationController.text.isEmpty ? null : _locationController.text,
            ),
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}

// ============================================================
// AI HANDOFF SCREEN
// ============================================================

class AIHandoffScreen extends StatefulWidget {
  const AIHandoffScreen({super.key});

  @override
  State<AIHandoffScreen> createState() => _AIHandoffScreenState();
}

class _AIHandoffScreenState extends State<AIHandoffScreen> {
  XFile? _selectedImage;
  bool _isTextMode = false;
  String? _selectedProblem;
  final _promptController = TextEditingController(
    text: 'I have an orchid with a problem. Can you identify any health issues and suggest treatment?',
  );

  static const List<String> _problemCategories = [
    'Yellow leaves',
    'Brown spots',
    'Root rot',
    'Wilting',
    'Pest damage',
    'Bud drop',
    'Not blooming',
    'Leaf drop',
    'Mushy stems',
    'Other',
  ];

  bool get _hasSelection => _selectedImage != null || _selectedProblem != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const OrchidSliverAppBar(
            title: 'AI Plant Doctor',
            showBackButton: true,
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Instructions
                  Card(
                    color: AppTheme.primary.withValues(alpha: 0.08),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: AppTheme.primary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _isTextMode
                                  ? 'Select a problem category and search for solutions.'
                                  : 'Take a photo of your orchid and send it to an AI assistant for diagnosis.',
                              style: const TextStyle(color: AppTheme.primaryDark),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Mode toggle
                  SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment(
                        value: false,
                        icon: Icon(Icons.camera_alt),
                        label: Text('Photo'),
                      ),
                      ButtonSegment(
                        value: true,
                        icon: Icon(Icons.edit_note),
                        label: Text('Text'),
                      ),
                    ],
                    selected: {_isTextMode},
                    onSelectionChanged: (selection) {
                      setState(() {
                        _isTextMode = selection.first;
                        // Clear the other mode's selection
                        if (_isTextMode) {
                          _selectedImage = null;
                        } else {
                          _selectedProblem = null;
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Content area - Photo or Text mode
                  Expanded(
                    child: _isTextMode ? _buildTextModeContent() : _buildPhotoModeContent(),
                  ),
                  const SizedBox(height: 16),

                  // Prompt customization (for photo mode only)
                  if (!_isTextMode) ...[
                    TextField(
                      controller: _promptController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Your question',
                        hintText: 'Describe the issue...',
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // AI service buttons
                  const Text(
                    'Get help from:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildAIButton(
                        'Google',
                        Icons.search,
                        AppTheme.statusUpcoming,
                        _isTextMode ? () => _searchGoogle() : () => _openGoogleLens(),
                      ),
                      _buildAIButton(
                        'ChatGPT',
                        Icons.chat_bubble,
                        const Color(0xFF10A37F),
                        () => _openChatGPT(),
                      ),
                      _buildAIButton(
                        'Gemini',
                        Icons.auto_awesome,
                        AppTheme.statusUpcoming,
                        () => _openGemini(),
                      ),
                      _buildAIButton(
                        'Claude',
                        Icons.psychology,
                        AppTheme.fertilizerOrange,
                        () => _openClaude(),
                      ),
                      _buildAIButton(
                        'Assistant',
                        Icons.mic,
                        AppTheme.statusOverdue,
                        () => _launchVoiceAssistant(),
                      ),
                      if (!_isTextMode)
                        _buildAIButton(
                          'Share...',
                          Icons.share,
                          AppTheme.textSecondary,
                          () => _shareToAny(),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoModeContent() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(color: AppTheme.cardBorder),
        ),
        child: _selectedImage != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    child: Image.file(
                      File(_selectedImage!.path),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(Icons.broken_image, size: 64),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton.filled(
                      onPressed: () => setState(() => _selectedImage = null),
                      icon: const Icon(Icons.close),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black54,
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo, size: 64, color: AppTheme.textSecondary.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  const Text(
                    'Tap to take or select a photo',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildTextModeContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What issue are you seeing?',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: _problemCategories.length,
            itemBuilder: (context, index) {
              final problem = _problemCategories[index];
              final isSelected = _selectedProblem == problem;
              return ChoiceChip(
                label: SizedBox(
                  width: double.infinity,
                  child: Text(
                    problem,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected ? Colors.white : null,
                    ),
                  ),
                ),
                selected: isSelected,
                selectedColor: AppTheme.primary,
                onSelected: (selected) {
                  setState(() {
                    _selectedProblem = selected ? problem : null;
                  });
                },
              );
            },
          ),
        ),
        if (_selectedProblem != null) ...[
          const SizedBox(height: 12),
          Card(
            color: AppTheme.primary.withValues(alpha: 0.08),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: AppTheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Selected: $_selectedProblem',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAIButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return OutlinedButton.icon(
      onPressed: _hasSelection ? onTap : null,
      icon: Icon(icon, color: _hasSelection ? color : AppTheme.textSecondary),
      label: Text(label),
    );
  }

  Future<void> _pickImage() async {
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

    if (source != null) {
      try {
        final image = await picker.pickImage(source: source);
        if (image != null && mounted) {
          setState(() => _selectedImage = image);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                source == ImageSource.camera
                    ? 'Could not access camera. Please check permissions.'
                    : 'Could not access photos. Please check permissions.',
              ),
              backgroundColor: AppTheme.statusOverdue,
            ),
          );
        }
      }
    }
  }

  Future<void> _searchGoogle() async {
    final query = Uri.encodeComponent(
      'orchid ${_selectedProblem ?? 'problem'} treatment how to fix',
    );
    final url = Uri.parse('https://www.google.com/search?q=$query');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchVoiceAssistant() async {
    final query = _selectedProblem != null
        ? 'How to fix $_selectedProblem on my orchid'
        : 'Help me with my orchid';

    // Only use Android intent on Android
    if (Platform.isAndroid) {
      final intent = AndroidIntent(
        action: 'android.intent.action.WEB_SEARCH',
        arguments: {'query': query},
        flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
      );

      try {
        await intent.launch();
        return;
      } catch (e) {
        // Fall through to Google search fallback
      }
    }

    // Fallback to Google search for iOS or if intent fails
    final encodedQuery = Uri.encodeComponent(query);
    final url = Uri.parse('https://www.google.com/search?q=$encodedQuery');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openGoogleLens() async {
    final url = Uri.parse('https://lens.google.com');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
    _showFollowUpInstructions('Google Lens');
  }

  Future<void> _openChatGPT() async {
    final url = Uri.parse('https://chat.openai.com');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
    _showFollowUpInstructions('ChatGPT');
  }

  Future<void> _openGemini() async {
    final url = Uri.parse('https://gemini.google.com');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
    _showFollowUpInstructions('Gemini');
  }

  Future<void> _openClaude() async {
    final url = Uri.parse('https://claude.ai');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
    _showFollowUpInstructions('Claude');
  }

  Future<void> _shareToAny() async {
    if (_selectedImage != null) {
      await Share.shareXFiles(
        [_selectedImage!],
        text: _promptController.text,
      );
    }
  }

  void _showFollowUpInstructions(String service) {
    final message = _isTextMode && _selectedProblem != null
        ? 'Opening $service... Ask about "$_selectedProblem" on orchids.'
        : 'Opening $service... Upload your photo and ask your question there.';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }
}

// ============================================================
// CARE GUIDE SCREEN
// ============================================================

class CareGuideScreen extends StatelessWidget {
  const CareGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const OrchidSliverAppBar(
            title: 'Orchid Care Guide',
            showBackButton: true,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSection(
                  'Watering',
                  Icons.water_drop,
                  AppTheme.waterBlue,
                  'Water when the potting medium is nearly dry. For most orchids, this means every 7-10 days. '
                  'Water thoroughly and let excess drain completely. Never let orchids sit in water.',
                ),
                _buildSection(
                  'Light',
                  Icons.light_mode,
                  AppTheme.statusNeedsCare,
                  'Most orchids prefer bright, indirect light. East-facing windows are ideal. '
                  'Direct sunlight can burn leaves. Use the Light Meter tool to check your spots!',
                ),
                _buildSection(
                  'Humidity',
                  Icons.grain,
                  AppTheme.mistCyan,
                  'Orchids thrive in 50-70% humidity. Mist leaves in the morning, use a humidity tray, '
                  'or group plants together. Avoid misting at night to prevent fungal issues.',
                ),
                _buildSection(
                  'Fertilizing',
                  Icons.eco,
                  AppTheme.fertilizerOrange,
                  'Feed weekly with a diluted orchid fertilizer (1/4 strength) or monthly at full strength. '
                  'Reduce or stop fertilizing when not actively growing.',
                ),
                _buildSection(
                  'Temperature',
                  Icons.thermostat,
                  AppTheme.statusOverdue,
                  'Most orchids prefer 65-80\u00b0F (18-27\u00b0C) during the day and a 10-15\u00b0F drop at night. '
                  'This temperature variation can trigger blooming in many species.',
                ),
                _buildSection(
                  'Repotting',
                  Icons.yard,
                  AppTheme.repotBrown,
                  'Repot every 1-2 years or when the medium breaks down. Use fresh orchid bark mix. '
                  'Best done after flowering when new roots are growing.',
                ),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, Color color, String content) {
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
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(height: 1.5),
          ),
        ],
      ),
    );
  }
}
