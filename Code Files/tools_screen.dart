// lib/screens/tools_screen.dart
// OrchidLife - Tools screen (Lux meter, AI help)

import 'package:flutter/material.dart';
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
        padding: const EdgeInsets.all(AppTheme.screenPadding),
        children: [
          // Header
          Text(
            '🛠️ Helpful Tools',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppTheme.spacing2),
          Text(
            'Measure light levels and get AI-powered help',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
          const SizedBox(height: AppTheme.spacing6),

          // Lux Meter Card
          _buildToolCard(
            context,
            icon: Icons.wb_sunny,
            iconColor: AppTheme.luxHigh,
            title: 'Light Meter',
            subtitle: 'Measure light levels in lux',
            description:
                'Use your phone\'s sensor to check if your orchid is getting the right amount of light.',
            buttonLabel: 'Measure Light',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('🔆 Light Meter coming in Phase 3!'),
                ),
              );
            },
          ),
          const SizedBox(height: AppTheme.spacing4),

          // AI Help Card
          _buildToolCard(
            context,
            icon: Icons.psychology,
            iconColor: AppTheme.statusUpcoming,
            title: 'AI Plant Doctor',
            subtitle: 'Get help with orchid problems',
            description:
                'Take a photo of yellow leaves, pests, or other issues and get AI-powered diagnosis.',
            buttonLabel: 'Get Help',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('🤖 AI Help coming in Phase 3!'),
                ),
              );
            },
          ),
          const SizedBox(height: AppTheme.spacing6),

          // Quick Reference Section
          Text(
            'Quick Reference',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppTheme.spacing3),

          // Light levels guide
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacing4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.lightbulb_outline, color: AppTheme.primary),
                      const SizedBox(width: AppTheme.spacing2),
                      Text(
                        'Light Level Guide',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacing4),
                  _buildLightGuideRow('🌑', 'Very Low', '0-200 lux', 'Too dark'),
                  _buildLightGuideRow('🌘', 'Low', '200-500 lux', 'Paphiopedilum'),
                  _buildLightGuideRow('🌤️', 'Medium', '500-1,500 lux', 'Phalaenopsis'),
                  _buildLightGuideRow('☀️', 'Bright', '1,500-3,000 lux', 'Most orchids'),
                  _buildLightGuideRow('🌞', 'Very Bright', '3,000-5,000 lux', 'Cattleya, Vanda'),
                  _buildLightGuideRow('🔥', 'Direct Sun', '5,000+ lux', 'Caution!'),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacing4),

          // Watering guide
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacing4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.water_drop, color: AppTheme.statusUpcoming),
                      const SizedBox(width: AppTheme.spacing2),
                      Text(
                        'Watering Guide',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacing4),
                  _buildWateringGuideRow('Phalaenopsis', '7-10 days'),
                  _buildWateringGuideRow('Dendrobium', '5-7 days'),
                  _buildWateringGuideRow('Cattleya', '7 days'),
                  _buildWateringGuideRow('Oncidium', '5-7 days'),
                  _buildWateringGuideRow('Vanda', 'Daily (roots)'),
                  _buildWateringGuideRow('Paphiopedilum', '5-7 days'),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppTheme.spacing8),
        ],
      ),
    );
  }

  Widget _buildToolCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String description,
    required String buttonLabel,
    required VoidCallback onTap,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacing3),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  child: Icon(icon, size: 32, color: iconColor),
                ),
                const SizedBox(width: AppTheme.spacing4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacing4),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppTheme.spacing4),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onTap,
                child: Text(buttonLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLightGuideRow(String emoji, String level, String lux, String orchids) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          SizedBox(
            width: 80,
            child: Text(level, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          SizedBox(
            width: 100,
            child: Text(lux, style: const TextStyle(color: AppTheme.textSecondary)),
          ),
          Expanded(
            child: Text(orchids, style: const TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Widget _buildWateringGuideRow(String variety, String frequency) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(variety),
          Text(
            frequency,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppTheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
