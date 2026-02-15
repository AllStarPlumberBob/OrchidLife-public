import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String>? stepLabels;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.stepLabels,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps * 2 - 1, (i) {
        if (i.isOdd) {
          // Connector
          final stepIndex = i ~/ 2;
          return Expanded(
            child: Container(
              height: 2,
              color: stepIndex < currentStep
                  ? AppTheme.primary
                  : AppTheme.divider,
            ),
          );
        }

        final stepIndex = i ~/ 2;
        final isActive = stepIndex == currentStep;
        final isCompleted = stepIndex < currentStep;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: isActive ? 32 : 24,
              height: isActive ? 32 : 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? AppTheme.primary
                    : isCompleted
                        ? AppTheme.primary.withValues(alpha: 0.3)
                        : AppTheme.divider,
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(Icons.check, size: 14, color: AppTheme.primary)
                    : Text(
                        '${stepIndex + 1}',
                        style: TextStyle(
                          fontSize: isActive ? 14 : 11,
                          fontWeight: FontWeight.bold,
                          color: isActive ? Colors.white : AppTheme.textSecondary,
                        ),
                      ),
              ),
            ),
            if (stepLabels != null && stepIndex < stepLabels!.length) ...[
              const SizedBox(height: 4),
              Text(
                stepLabels![stepIndex],
                style: TextStyle(
                  fontSize: 9,
                  color: isActive ? AppTheme.primary : AppTheme.textSecondary,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ],
        );
      }),
    );
  }
}
