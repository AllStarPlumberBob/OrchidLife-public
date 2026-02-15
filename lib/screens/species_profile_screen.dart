import 'package:flutter/material.dart';
import '../database/database.dart';
import '../theme/app_theme.dart';
import '../widgets/orchid_sliver_app_bar.dart';
import '../widgets/orchid_card.dart';
import '../services/seasonal_context_service.dart';

class SpeciesProfileScreen extends StatelessWidget {
  final SpeciesProfile species;

  const SpeciesProfileScreen({super.key, required this.species});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          OrchidSliverAppBar(
            title: species.commonName,
            showBackButton: true,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Header
                _buildHeader(),
                const SizedBox(height: 16),
                // Description
                if (species.description != null) ...[
                  _buildDescriptionCard(),
                  const SizedBox(height: 16),
                ],
                // Light requirements
                if (species.idealLuxMin != null || species.idealLuxMax != null) ...[
                  _buildLightCard(),
                  const SizedBox(height: 16),
                ],
                // Temperature
                if (species.tempMinF != null) ...[
                  _buildTemperatureCard(),
                  const SizedBox(height: 16),
                ],
                // Watering
                if (species.wateringNotes != null) ...[
                  _buildCareNotesCard(
                    icon: Icons.water_drop,
                    title: 'Watering',
                    content: species.wateringNotes!,
                    color: AppTheme.waterBlue,
                  ),
                  const SizedBox(height: 16),
                ],
                // Fertilizing
                if (species.fertilizingNotes != null) ...[
                  _buildCareNotesCard(
                    icon: Icons.science,
                    title: 'Fertilizing',
                    content: species.fertilizingNotes!,
                    color: AppTheme.fertilizerOrange,
                  ),
                  const SizedBox(height: 16),
                ],
                // Seasonal tips
                _buildSeasonalTipsCard(),
                SizedBox(height: 32 + MediaQuery.of(context).padding.bottom),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return OrchidCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                ),
                child: const Icon(Icons.local_florist, color: AppTheme.primary, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      species.commonName,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      species.species != null
                          ? '${species.genus} ${species.species}'
                          : '${species.genus} spp.',
                      style: const TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              if (species.difficultyLevel != null)
                _InfoChip(
                  icon: Icons.trending_up,
                  label: species.difficultyLevel!,
                  color: _difficultyColor(species.difficultyLevel!),
                ),
              if (species.bloomSeason != null)
                _InfoChip(
                  icon: Icons.local_florist,
                  label: species.bloomSeason!,
                  color: AppTheme.bloom,
                ),
              if (species.humidity != null)
                _InfoChip(
                  icon: Icons.water,
                  label: species.humidity!,
                  color: AppTheme.mistCyan,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return OrchidCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, color: AppTheme.primary, size: 20),
              SizedBox(width: 8),
              Text('About', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Text(species.description!, style: const TextStyle(fontSize: 14, height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildLightCard() {
    return OrchidCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.light_mode, color: AppTheme.statusNeedsCare, size: 20),
              SizedBox(width: 8),
              Text('Light Requirements', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _RangeIndicator(
                  label: 'Ideal Range',
                  min: species.idealLuxMin ?? 0,
                  max: species.idealLuxMax ?? 0,
                  unit: 'lux',
                  color: AppTheme.statusNeedsCare,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _lightDescription(),
            style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildTemperatureCard() {
    return OrchidCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.thermostat, color: AppTheme.statusOverdue, size: 20),
              SizedBox(width: 8),
              Text('Temperature', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _TempDisplay(label: 'Min', value: '${species.tempMinF}\u00b0F', color: AppTheme.statusUpcoming),
              if (species.tempMaxF != null)
                _TempDisplay(label: 'Max', value: '${species.tempMaxF}\u00b0F', color: AppTheme.statusOverdue),
              if (species.tempNightDropF != null)
                _TempDisplay(label: 'Night drop', value: '${species.tempNightDropF}\u00b0F', color: AppTheme.inspectPurple),
            ],
          ),
          if (species.humidity != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.water, size: 16, color: AppTheme.mistCyan),
                const SizedBox(width: 4),
                Text('Humidity: ${species.humidity}', style: const TextStyle(fontSize: 13)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCareNotesCard({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return OrchidCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(fontSize: 14, height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildSeasonalTipsCard() {
    final tips = SeasonalContextService.getTips(species.genus);
    if (tips.isEmpty) return const SizedBox.shrink();

    return OrchidCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.wb_sunny, color: AppTheme.statusNeedsCare, size: 20),
              const SizedBox(width: 8),
              Text(
                '${SeasonalContextService.getSeasonName()} Tips',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...tips.take(4).map((tip) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Icon(Icons.eco, size: 14, color: AppTheme.primary),
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(tip, style: const TextStyle(fontSize: 13))),
              ],
            ),
          )),
        ],
      ),
    );
  }

  String _lightDescription() {
    final min = species.idealLuxMin ?? 0;
    if (min < 1000) return 'Low light — suitable for shaded areas away from direct sun.';
    if (min < 3000) return 'Medium light — bright indirect light, near an east-facing window.';
    if (min < 10000) return 'Bright indirect — near a south or west window with a sheer curtain.';
    return 'High light — needs bright, direct or near-direct sunlight.';
  }

  Color _difficultyColor(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return AppTheme.statusCompleted;
      case 'intermediate':
        return AppTheme.statusNeedsCare;
      case 'advanced':
        return AppTheme.statusOverdue;
      default:
        return AppTheme.textSecondary;
    }
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: color)),
        ],
      ),
    );
  }
}

class _RangeIndicator extends StatelessWidget {
  final String label;
  final int min;
  final int max;
  final String unit;
  final Color color;

  const _RangeIndicator({
    required this.label,
    required this.min,
    required this.max,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(
            '$min – $max $unit',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}

class _TempDisplay extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _TempDisplay({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 10, color: color)),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
