import 'package:flutter/material.dart';
import '../database/database.dart';
import '../theme/app_theme.dart';

class BloomStageWidget extends StatelessWidget {
  final BloomStage? currentStage;
  final ValueChanged<BloomStage>? onStageChanged;

  const BloomStageWidget({
    super.key,
    this.currentStage,
    this.onStageChanged,
  });

  static const _stages = BloomStage.values;

  static String stageName(BloomStage stage) {
    switch (stage) {
      case BloomStage.dormant:
        return 'Dormant';
      case BloomStage.spikeEmerging:
        return 'Spike';
      case BloomStage.budding:
        return 'Budding';
      case BloomStage.inBloom:
        return 'Blooming';
      case BloomStage.fading:
        return 'Fading';
    }
  }

  static IconData stageIcon(BloomStage stage) {
    switch (stage) {
      case BloomStage.dormant:
        return Icons.nightlight_round;
      case BloomStage.spikeEmerging:
        return Icons.trending_up;
      case BloomStage.budding:
        return Icons.filter_vintage;
      case BloomStage.inBloom:
        return Icons.local_florist;
      case BloomStage.fading:
        return Icons.nights_stay;
    }
  }

  static Color stageColor(BloomStage stage) {
    switch (stage) {
      case BloomStage.dormant:
        return AppTheme.statusSkipped;
      case BloomStage.spikeEmerging:
        return AppTheme.statusCompleted;
      case BloomStage.budding:
        return AppTheme.statusNeedsCare;
      case BloomStage.inBloom:
        return AppTheme.bloom;
      case BloomStage.fading:
        return AppTheme.repotBrown;
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeIndex = currentStage != null ? _stages.indexOf(currentStage!) : -1;

    return Row(
      children: List.generate(_stages.length * 2 - 1, (i) {
        if (i.isOdd) {
          // Connector line between stages
          final stageIndex = i ~/ 2;
          final isActive = stageIndex < activeIndex;
          return Expanded(
            child: Container(
              height: 2,
              color: isActive
                  ? stageColor(_stages[stageIndex])
                  : Theme.of(context).dividerColor,
            ),
          );
        }

        final stageIndex = i ~/ 2;
        final stage = _stages[stageIndex];
        final isActive = stageIndex == activeIndex;
        final isPast = stageIndex < activeIndex;
        final color = (isActive || isPast)
            ? stageColor(stage)
            : Theme.of(context).dividerColor;

        return GestureDetector(
          onTap: onStageChanged != null ? () => onStageChanged!(stage) : null,
          child: Tooltip(
            message: stageName(stage),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: isActive ? 40 : 32,
                  height: isActive ? 40 : 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive
                        ? color.withValues(alpha: 0.2)
                        : Colors.transparent,
                    border: Border.all(
                      color: color,
                      width: isActive ? 2.5 : 1.5,
                    ),
                  ),
                  child: Icon(
                    stageIcon(stage),
                    size: isActive ? 20 : 16,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stageName(stage),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    color: isActive ? color : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

/// Compact bloom stage badge for list views
class BloomStageBadge extends StatelessWidget {
  final BloomStage stage;

  const BloomStageBadge({super.key, required this.stage});

  @override
  Widget build(BuildContext context) {
    final color = BloomStageWidget.stageColor(stage);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppTheme.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(BloomStageWidget.stageIcon(stage), size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            BloomStageWidget.stageName(stage),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
