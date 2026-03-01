import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' show Value;
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'dart:io' show File, Platform;
import '../services/ai_handoff_service.dart';
import '../database/database.dart';
import '../theme/app_theme.dart';
import '../services/light_sensor_service.dart';
import '../widgets/orchid_sliver_app_bar.dart';
import '../widgets/orchid_card.dart';
import '../widgets/page_transitions.dart';
import 'locations_screen.dart';

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
                // Primary tools — larger icons, gradient accent strip
                _buildPrimaryToolCard(
                  context,
                  icon: Icons.light_mode,
                  title: 'Light Meter',
                  subtitle: 'Measure light levels for optimal orchid placement',
                  color: AppTheme.statusNeedsCare,
                  onTap: () => Navigator.push(
                    context,
                    OrchidPageRoute(builder: (_) => const LuxMeterScreen()),
                  ),
                ),
                const SizedBox(height: 4),
                _buildPrimaryToolCard(
                  context,
                  icon: Icons.camera_alt,
                  title: 'AI Plant Doctor',
                  subtitle: 'Take a photo and get expert diagnosis from AI',
                  color: AppTheme.primary,
                  onTap: () => Navigator.push(
                    context,
                    OrchidPageRoute(builder: (_) => const AIHandoffScreen()),
                  ),
                ),
                const SizedBox(height: 4),
                _buildPrimaryToolCard(
                  context,
                  icon: Icons.timer,
                  title: 'Water Timer',
                  subtitle: 'Set a soak timer for your orchids',
                  color: AppTheme.waterBlue,
                  onTap: () => Navigator.push(
                    context,
                    OrchidPageRoute(builder: (_) => const WaterTimerScreen()),
                  ),
                ),
                const SizedBox(height: 20),
                // Secondary tools — compact, quieter
                _buildToolCard(
                  context,
                  icon: Icons.location_on,
                  title: 'Growing Locations',
                  subtitle: 'Manage where your orchids live',
                  color: AppTheme.primaryDark,
                  onTap: () => Navigator.push(
                    context,
                    OrchidPageRoute(builder: (_) => const LocationsScreen()),
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

  Widget _buildPrimaryToolCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return OrchidCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Accent strip
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppTheme.radiusCard),
                  bottomLeft: Radius.circular(AppTheme.radiusCard),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 20, 20),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [color.withValues(alpha: 0.18), color.withValues(alpha: 0.06)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                      ),
                      child: Icon(icon, color: color, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
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
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              fontSize: 13,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: color.withValues(alpha: 0.5)),
                  ],
                ),
              ),
            ),
          ],
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, size: 20, color: Theme.of(context).colorScheme.onSurfaceVariant),
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
  final bool _isCameraMode = !Platform.isAndroid;

  @override
  void initState() {
    super.initState();
    _checkSensor();
  }

  Future<void> _checkSensor() async {
    final service = Provider.of<LightSensorService>(context, listen: false);

    if (_isCameraMode) {
      // iOS — initialize camera for lux estimation
      final error = await service.initCamera();
      if (mounted) {
        if (error != null) {
          setState(() {
            _hasSensor = false;
            _sensorError = error.contains('permission')
                ? 'Camera permission denied. Please enable camera access in Settings to use the Light Meter.'
                : error;
          });
        } else {
          setState(() => _hasSensor = true);
        }
      }
      return;
    }

    // Android — check hardware sensor
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
    if (_isCameraMode) {
      final service = Provider.of<LightSensorService>(context, listen: false);
      service.disposeCamera();
    }
    super.dispose();
  }

  void _startReading() {
    final service = Provider.of<LightSensorService>(context, listen: false);
    setState(() {
      _isReading = true;
      _sensorError = null;
    });

    if (_isCameraMode) {
      service.startCameraStream();
    }

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
    if (_isCameraMode) {
      final service = Provider.of<LightSensorService>(context, listen: false);
      service.stopCameraStream();
    }
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
    if (lux < 500) return AppTheme.statusSkipped;
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
                                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
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
                                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        // Camera preview (iOS only, when reading)
                        if (_isCameraMode && _isReading) ...[
                          _buildCameraPreview(context),
                          const SizedBox(height: 16),
                        ],
                        // Estimated info banner (iOS only)
                        if (_isCameraMode && _hasSensor == true)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Card(
                              color: AppTheme.primary.withValues(alpha: 0.08),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    const Icon(Icons.info_outline, color: AppTheme.primary),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Camera-based estimate. For best results, point the back camera at the light source.',
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.onSurface,
                                          fontSize: 13,
                                        ),
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
                              Text(
                                'lux',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                              if (_isCameraMode)
                                Text(
                                  '(estimated)',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                        _buildLightGuideRow('< 500 lux', 'Low', AppTheme.statusSkipped),
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

  Widget _buildCameraPreview(BuildContext context) {
    final service = Provider.of<LightSensorService>(context, listen: false);
    final controller = service.cameraController;
    if (controller != null && controller.value.isInitialized) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: SizedBox(
          width: 160,
          height: 120,
          child: CameraPreview(controller),
        ),
      );
    }
    return const SizedBox.shrink();
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
      if (!context.mounted) return;
      final service = Provider.of<LightSensorService>(context, listen: false);
      await db.insertLightReading(LightReadingsCompanion.insert(
        luxValue: _currentLux,
        readingAt: DateTime.now(),
        orchidId: Value(result.orchidId),
        locationName: Value(result.location),
        notes: Value(service.isEstimated ? 'Camera estimate' : null),
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
  final _textDescriptionController = TextEditingController();
  final _textDescriptionFocusNode = FocusNode();

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

  static const Map<String, String> _problemPrompts = {
    'Yellow leaves': 'My orchid has yellow leaves. What could be causing this and how should I treat it?',
    'Brown spots': 'My orchid has brown spots on its leaves. What is causing this and what should I do?',
    'Root rot': 'I think my orchid has root rot. How do I confirm this and save the plant?',
    'Wilting': 'My orchid is wilting even though I water it. What could be wrong and how do I fix it?',
    'Pest damage': 'My orchid appears to have pest damage. How do I identify the pest and treat it?',
    'Bud drop': 'My orchid keeps dropping its buds before they bloom. What causes this and how do I prevent it?',
    'Not blooming': 'My orchid hasn\'t bloomed in a long time. How can I encourage it to bloom again?',
    'Leaf drop': 'My orchid is losing its leaves. What could be causing this and how should I respond?',
    'Mushy stems': 'My orchid has mushy or soft stems. Is this a sign of disease and what should I do?',
  };

  bool get _hasSelection =>
      _selectedImage != null ||
      _selectedProblem != null ||
      _textDescriptionController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _textDescriptionController.addListener(_onTextDescriptionChanged);
  }

  void _onTextDescriptionChanged() {
    setState(() {});
  }

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
              padding: EdgeInsets.fromLTRB(
                16, 16, 16,
                16 + MediaQuery.of(context).padding.bottom,
              ),
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
                                  ? 'Describe your orchid problem or pick a category, then get AI help.'
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
                          _textDescriptionController.clear();
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
                        'Claude',
                        Icons.psychology,
                        AppTheme.fertilizerOrange,
                        () => _openClaude(),
                      ),
                      _buildAIButton(
                        'Perplexity',
                        Icons.travel_explore,
                        AppTheme.brandPerplexity,
                        () => _openPerplexity(),
                      ),
                      if (!_isTextMode)
                        _buildAIButton(
                          'Share...',
                          Icons.share,
                          AppTheme.statusSkipped,
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
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(color: Theme.of(context).dividerColor),
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
                  Icon(Icons.add_a_photo, size: 64, color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  Text(
                    'Tap to take or select a photo',
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
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
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _problemCategories.map((problem) {
            final isSelected = _selectedProblem == problem;
            return ChoiceChip(
              label: Text(
                problem,
                style: TextStyle(
                  color: isSelected ? Colors.white : null,
                ),
              ),
              selected: isSelected,
              selectedColor: AppTheme.primary,
              onSelected: (selected) {
                setState(() {
                  if (problem == 'Other') {
                    _selectedProblem = selected ? problem : null;
                    _textDescriptionController.clear();
                    if (selected) {
                      _textDescriptionFocusNode.requestFocus();
                    }
                  } else if (selected) {
                    _selectedProblem = problem;
                    _textDescriptionController.text =
                        _problemPrompts[problem] ?? 'My orchid has $problem.';
                  } else {
                    _selectedProblem = null;
                    _textDescriptionController.clear();
                  }
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: TextField(
            controller: _textDescriptionController,
            focusNode: _textDescriptionFocusNode,
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            decoration: const InputDecoration(
              hintText: 'Select a category above or type your own description...',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAIButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return OutlinedButton.icon(
      onPressed: _hasSelection ? onTap : null,
      icon: Icon(icon, color: _hasSelection ? color : Theme.of(context).colorScheme.onSurfaceVariant),
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
    final textDescription = _textDescriptionController.text.trim();
    final searchTerm = textDescription.isNotEmpty
        ? textDescription
        : 'orchid ${_selectedProblem ?? 'problem'} treatment how to fix';
    await AIHandoffService.searchGoogle(searchTerm);
  }

  Future<void> _openGoogleLens() async {
    final opened = await AIHandoffService.openGoogleLens(
      context,
      imagePath: _selectedImage?.path,
    );
    if (!mounted || !opened) return;
    _showFollowUpInstructions('Google Lens');
  }

  Future<void> _openClaude() async {
    final opened = await AIHandoffService.openClaude(
      context,
      imagePath: _selectedImage?.path,
      prompt: _promptController.text,
    );
    if (!mounted || !opened) return;
    _showFollowUpInstructions('Claude');
  }

  Future<void> _openPerplexity() async {
    final opened = await AIHandoffService.openPerplexity(
      context,
      imagePath: _selectedImage?.path,
      prompt: _promptController.text,
    );
    if (!mounted || !opened) return;
    _showFollowUpInstructions('Perplexity');
  }

  Future<void> _shareToAny() async {
    if (_selectedImage != null) {
      await AIHandoffService.shareToAny(_selectedImage!, _promptController.text);
    }
  }

  void _showFollowUpInstructions(String service) {
    final textDescription = _textDescriptionController.text.trim();
    final String message;
    if (_isTextMode && textDescription.isNotEmpty) {
      final preview = textDescription.length > 60
          ? '${textDescription.substring(0, 60)}...'
          : textDescription;
      message = 'Opening $service... Ask: "$preview"';
    } else if (_isTextMode && _selectedProblem != null) {
      message = 'Opening $service... Ask about "$_selectedProblem" on orchids.';
    } else {
      message = 'Opening $service... Upload your photo and ask your question there.';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _textDescriptionController.removeListener(_onTextDescriptionChanged);
    _textDescriptionController.dispose();
    _textDescriptionFocusNode.dispose();
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
                SizedBox(height: 32 + MediaQuery.of(context).padding.bottom),
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

// ============================================================
// WATER TIMER SCREEN
// ============================================================

class WaterTimerScreen extends StatefulWidget {
  const WaterTimerScreen({super.key});

  @override
  State<WaterTimerScreen> createState() => _WaterTimerScreenState();
}

class _WaterTimerScreenState extends State<WaterTimerScreen> {
  // Setup state
  int _selectedMinutes = 15;
  bool _isCustom = false;
  final _customController = TextEditingController();

  // Running state
  Timer? _timer;
  int? _totalSeconds;      // null = setup mode
  int _remainingSeconds = 0;
  bool _isComplete = false;
  bool _alarmPlaying = false;

  static const List<int> _presets = [10, 15, 20, 30, 45, 60];

  double get _progress {
    if (_totalSeconds == null || _totalSeconds == 0) return 0.0;
    final elapsed = _totalSeconds! - _remainingSeconds;
    return (elapsed / _totalSeconds!).clamp(0.0, 1.0);
  }

  void _startTimer() {
    final minutes = _isCustom
        ? (int.tryParse(_customController.text) ?? _selectedMinutes)
        : _selectedMinutes;
    if (minutes < 1 || minutes > 120) return;

    setState(() {
      _totalSeconds = minutes * 60;
      _remainingSeconds = _totalSeconds!;
      _isComplete = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      bool shouldAlarm = false;
      setState(() {
        _remainingSeconds--;
        if (_remainingSeconds <= 0) {
          _remainingSeconds = 0;
          _isComplete = true;
          _timer?.cancel();
          _timer = null;
          shouldAlarm = true;
        }
      });
      if (shouldAlarm) _triggerAlarm();
    });
  }

  void _triggerAlarm() {
    _alarmPlaying = true;
    FlutterRingtonePlayer().playAlarm(looping: true, volume: 1.0, asAlarm: true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _showAlarmDialog();
    });
  }

  void _stopAlarm() {
    if (_alarmPlaying) {
      FlutterRingtonePlayer().stop();
      _alarmPlaying = false;
    }
  }

  void _showAlarmDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.alarm, size: 48, color: AppTheme.statusNeedsCare),
        title: const Text('Timer Complete!'),
        content: const Text('Time to drain your orchids.'),
        actions: [
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                _stopAlarm();
                Navigator.pop(dialogContext);
              },
              icon: const Icon(Icons.alarm_off),
              label: const Text('Got it'),
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.statusNeedsCare,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _reset() {
    _stopAlarm();
    _timer?.cancel();
    _timer = null;
    setState(() {
      _totalSeconds = null;
      _remainingSeconds = 0;
      _isComplete = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    if (_alarmPlaying) {
      FlutterRingtonePlayer().stop();
      _alarmPlaying = false;
    }
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRunning = _totalSeconds != null;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const OrchidSliverAppBar(
            title: 'Water Timer',
            showBackButton: true,
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                24, 24, 24,
                24 + MediaQuery.of(context).padding.bottom,
              ),
              child: isRunning ? _buildRunningState(context) : _buildSetupState(context),
            ),
          ),
        ],
      ),
    );
  }

  // ── Setup State ──────────────────────────────────────────────

  Widget _buildSetupState(BuildContext context) {
    return Column(
      children: [
        // Info card
        Card(
          color: AppTheme.waterBlue.withValues(alpha: 0.08),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppTheme.waterBlue),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Pick a soak duration, then start the timer.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Duration presets
        Text(
          'Soak Duration',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            ..._presets.map((min) => ChoiceChip(
                  label: Text(
                    '$min min',
                    style: TextStyle(
                      color: (!_isCustom && _selectedMinutes == min)
                          ? Colors.white
                          : null,
                    ),
                  ),
                  selected: !_isCustom && _selectedMinutes == min,
                  selectedColor: AppTheme.waterBlue,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedMinutes = min;
                        _isCustom = false;
                      });
                    }
                  },
                )),
            ChoiceChip(
              label: Text(
                'Custom',
                style: TextStyle(
                  color: _isCustom ? Colors.white : null,
                ),
              ),
              selected: _isCustom,
              selectedColor: AppTheme.waterBlue,
              onSelected: (selected) {
                setState(() => _isCustom = selected);
              },
            ),
          ],
        ),

        // Custom input
        if (_isCustom) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: 140,
            child: TextField(
              controller: _customController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: '1–120',
                suffixText: 'min',
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
        ],

        const Spacer(),

        // Start button
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _canStart ? _startTimer : null,
            icon: const Icon(Icons.play_arrow),
            label: Text('Start $_displayMinutes min Timer'),
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.waterBlue,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  bool get _canStart {
    if (_isCustom) {
      final val = int.tryParse(_customController.text);
      return val != null && val >= 1 && val <= 120;
    }
    return true;
  }

  int get _displayMinutes {
    if (_isCustom) {
      return int.tryParse(_customController.text) ?? 0;
    }
    return _selectedMinutes;
  }

  // ── Running State ────────────────────────────────────────────

  Widget _buildRunningState(BuildContext context) {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    final totalMinutes = (_totalSeconds! / 60).round();
    final accentColor = _isComplete ? AppTheme.statusNeedsCare : AppTheme.waterBlue;

    return Column(
      children: [
        const Spacer(),

        // Countdown circle (180px, scaled up from SoakSessionCard's 56px)
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: accentColor.withValues(alpha: 0.12),
            border: Border.all(color: accentColor, width: 4),
          ),
          child: Center(
            child: _isComplete
                ? Icon(Icons.done, color: accentColor, size: 64)
                : Text(
                    '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 24),

        // Status text
        Text(
          _isComplete ? 'Ready to drain!' : 'Soaking...',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: _isComplete ? AppTheme.statusNeedsCare : Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$totalMinutes minute soak',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 24),

        // Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: _progress,
            backgroundColor: accentColor.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation<Color>(accentColor),
            minHeight: 6,
          ),
        ),

        const Spacer(),

        // Buttons
        if (_isComplete)
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                _reset();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Soak complete! Time to drain.'),
                    backgroundColor: AppTheme.statusNeedsCare,
                  ),
                );
              },
              icon: const Icon(Icons.water_drop_outlined),
              label: const Text('Drain & Done'),
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.statusNeedsCare,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          )
        else
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _reset,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    _reset();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Drained early — all done!'),
                        backgroundColor: AppTheme.waterBlue,
                      ),
                    );
                  },
                  icon: const Icon(Icons.water_drop_outlined),
                  label: const Text('Drain Early'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.waterBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
