import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import '../database/database.dart';
import '../theme/app_theme.dart';

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tools'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildToolCard(
            context,
            icon: Icons.light_mode,
            title: 'Light Meter',
            subtitle: 'Measure light levels for optimal placement',
            color: Colors.amber,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LuxMeterScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _buildToolCard(
            context,
            icon: Icons.camera_alt,
            title: 'AI Plant Doctor',
            subtitle: 'Take a photo and get expert diagnosis',
            color: AppTheme.primaryGreen,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AIHandoffScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _buildToolCard(
            context,
            icon: Icons.book,
            title: 'Care Guide',
            subtitle: 'Learn about orchid care basics',
            color: AppTheme.inspectPurple,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CareGuideScreen()),
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
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
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
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
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

  @override
  void dispose() {
    _luxSubscription?.cancel();
    super.dispose();
  }

  void _startReading() {
    setState(() => _isReading = true);
    
    // Note: sensors_plus doesn't have a direct lux sensor on all devices
    // This is a placeholder - in production you'd use platform channels
    // or a package like light_sensor for actual lux readings
    
    // For demo, we'll simulate readings
    _luxSubscription = Stream.periodic(const Duration(milliseconds: 500)).listen((_) {
      // Simulate varying light readings
      setState(() {
        _currentLux = 500 + (DateTime.now().millisecond % 1000);
      });
    });
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
    if (lux < 500) return Colors.grey;
    if (lux < 1000) return Colors.blue;
    if (lux < 5000) return Colors.green;
    if (lux < 10000) return Colors.orange;
    return Colors.red;
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
      appBar: AppBar(
        title: const Text('Light Meter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Lux display
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _getLightColor(_currentLux).withOpacity(0.1),
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
                            color: Colors.grey,
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
                    onPressed: _isReading ? _stopReading : _startReading,
                    icon: Icon(_isReading ? Icons.stop : Icons.play_arrow),
                    label: Text(_isReading ? 'Stop' : 'Start'),
                    style: FilledButton.styleFrom(
                      backgroundColor: _isReading ? Colors.red : AppTheme.primaryGreen,
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
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Light Level Guide',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    _buildLightGuideRow('< 500 lux', 'Low', Colors.grey),
                    _buildLightGuideRow('500-1000', 'Medium', Colors.blue),
                    _buildLightGuideRow('1000-5000', 'Bright Indirect', Colors.green),
                    _buildLightGuideRow('5000-10000', 'Bright', Colors.orange),
                    _buildLightGuideRow('> 10000', 'Direct Sun', Colors.red),
                  ],
                ),
              ),
            ),
          ],
        ),
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
    final locationController = TextEditingController();
    
    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Reading'),
        content: TextField(
          controller: locationController,
          decoration: const InputDecoration(
            labelText: 'Location name',
            hintText: 'e.g., Living room window',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (shouldSave == true) {
      await db.insertLightReading(LightReadingsCompanion.insert(
        luxValue: _currentLux,
        readingAt: DateTime.now(),
        locationName: Value(locationController.text.isEmpty ? null : locationController.text),
      ));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reading saved!')),
        );
      }
    }
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
  final _promptController = TextEditingController(
    text: 'I have an orchid with a problem. Can you identify any health issues and suggest treatment?',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Plant Doctor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Instructions
            Card(
              color: AppTheme.primaryGreen.withOpacity(0.1),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: AppTheme.primaryGreen),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Take a photo of your orchid and send it to an AI assistant for diagnosis.',
                        style: TextStyle(color: AppTheme.primaryGreenDark),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Photo selection
            Expanded(
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: _selectedImage != null
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                _selectedImage!.path,
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
                            Icon(Icons.add_a_photo, size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'Tap to take or select a photo',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Prompt customization
            TextField(
              controller: _promptController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Your question',
                hintText: 'Describe the issue...',
              ),
            ),
            const SizedBox(height: 16),

            // AI service buttons
            const Text(
              'Send to:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildAIButton(
                  'Google Lens',
                  Icons.search,
                  Colors.blue,
                  () => _openGoogleLens(),
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
                  Colors.blueAccent,
                  () => _openGemini(),
                ),
                _buildAIButton(
                  'Claude',
                  Icons.psychology,
                  const Color(0xFFD97706),
                  () => _openClaude(),
                ),
                _buildAIButton(
                  'Share...',
                  Icons.share,
                  Colors.grey,
                  () => _shareToAny(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return OutlinedButton.icon(
      onPressed: _selectedImage != null ? onTap : null,
      icon: Icon(icon, color: color),
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
      final image = await picker.pickImage(source: source);
      if (image != null) {
        setState(() => _selectedImage = image);
      }
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening $service... Upload your photo and ask your question there.'),
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
      appBar: AppBar(
        title: const Text('Orchid Care Guide'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
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
            Colors.amber,
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
            Colors.red,
            'Most orchids prefer 65-80°F (18-27°C) during the day and a 10-15°F drop at night. '
            'This temperature variation can trigger blooming in many species.',
          ),
          _buildSection(
            'Repotting',
            Icons.yard,
            AppTheme.repotBrown,
            'Repot every 1-2 years or when the medium breaks down. Use fresh orchid bark mix. '
            'Best done after flowering when new roots are growing.',
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, Color color, String content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
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
      ),
    );
  }
}
