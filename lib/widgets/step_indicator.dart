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
          // Connector line
          final stepIndex = i ~/ 2;
          return Expanded(
            child: Container(
              height: 2,
              margin: EdgeInsets.only(bottom: stepLabels != null ? 18 : 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1),
                color: stepIndex < currentStep
                    ? AppTheme.primary.withValues(alpha: 0.4)
                    : AppTheme.divider.withValues(alpha: 0.5),
              ),
            ),
          );
        }

        final stepIndex = i ~/ 2;
        final isActive = stepIndex == currentStep;
        final isCompleted = stepIndex < currentStep;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? AppTheme.primary
                    : isCompleted
                        ? AppTheme.primary.withValues(alpha: 0.15)
                        : AppTheme.surfaceVariant,
                border: isActive
                    ? null
                    : Border.all(
                        color: isCompleted
                            ? AppTheme.primary.withValues(alpha: 0.3)
                            : AppTheme.divider,
                        width: 1,
                      ),
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(Icons.check, size: 14, color: AppTheme.primary)
                    : Text(
                        '${stepIndex + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                          color: isActive ? Colors.white : AppTheme.textPrimary.withValues(alpha: 0.5),
                        ),
                      ),
              ),
            ),
            if (stepLabels != null && stepIndex < stepLabels!.length) ...[
              const SizedBox(height: 4),
              Text(
                stepLabels![stepIndex],
                style: TextStyle(
                  fontSize: 10,
                  color: isActive
                      ? AppTheme.primary
                      : isCompleted
                          ? AppTheme.textPrimary
                          : AppTheme.textPrimary.withValues(alpha: 0.5),
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
