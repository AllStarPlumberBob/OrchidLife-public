import '../database/database.dart';

/// Insight card data returned by the diagnostic engine.
class CareInsight {
  final String title;
  final String message;
  final InsightType type;

  const CareInsight({required this.title, required this.message, required this.type});
}

enum InsightType { positive, warning, info }

/// Analyzes care patterns for an orchid and surfaces correlations as insights.
class DiagnosticService {
  final AppDatabase db;

  DiagnosticService(this.db);

  /// Generate insights for a specific orchid based on its care history.
  Future<List<CareInsight>> getInsightsForOrchid(int orchidId) async {
    final insights = <CareInsight>[];

    final orchid = await db.getOrchidById(orchidId);
    if (orchid == null) return insights;

    final logs = await db.getLogsForOrchid(orchidId, limit: 100);
    final tasks = await db.getTasksForOrchid(orchidId);

    // Need at least some data to analyze
    if (logs.isEmpty) return insights;

    _checkWateringConsistency(logs, insights);
    _checkOverduePattern(tasks, insights);
    _checkSkipRate(logs, insights);
    _checkBloomCorrelation(orchid, logs, insights);
    _checkCareFrequency(logs, insights);

    return insights;
  }

  void _checkWateringConsistency(List<CareLog> logs, List<CareInsight> insights) {
    final waterLogs = logs
        .where((l) => l.careType == CareType.water && !l.skipped)
        .toList();

    if (waterLogs.length < 4) return; // Need at least 3 intervals for meaningful variance

    // Calculate intervals between waterings (logs are newest-first)
    final intervals = <int>[];
    for (var i = 0; i < waterLogs.length - 1; i++) {
      intervals.add(waterLogs[i].completedAt.difference(waterLogs[i + 1].completedAt).inDays.abs());
    }
    if (intervals.isEmpty) return;

    final avg = intervals.reduce((a, b) => a + b) / intervals.length;
    final variance = intervals.map((i) => (i - avg) * (i - avg)).reduce((a, b) => a + b) / intervals.length;

    if (variance < 4) {
      insights.add(const CareInsight(
        title: 'Consistent watering',
        message: 'Your watering schedule is very consistent. Great job keeping a regular routine!',
        type: InsightType.positive,
      ));
    } else if (variance > 16) {
      insights.add(CareInsight(
        title: 'Irregular watering',
        message: 'Watering intervals vary quite a bit (avg ${avg.round()} days). Orchids generally prefer a predictable schedule.',
        type: InsightType.warning,
      ));
    }
  }

  void _checkOverduePattern(List<CareTask> tasks, List<CareInsight> insights) {
    final now = DateTime.now();
    final overdueTasks = tasks.where((t) => t.enabled && t.nextDue.isBefore(now)).toList();

    if (overdueTasks.length >= 3) {
      insights.add(CareInsight(
        title: 'Multiple tasks overdue',
        message: '${overdueTasks.length} care tasks are overdue. Consider setting shorter intervals or using reminders.',
        type: InsightType.warning,
      ));
    }
  }

  void _checkSkipRate(List<CareLog> logs, List<CareInsight> insights) {
    if (logs.length < 5) return;

    final recentLogs = logs.take(20).toList();
    final skipped = recentLogs.where((l) => l.skipped).length;
    final skipRate = skipped / recentLogs.length;

    if (skipRate == 0 && recentLogs.length >= 10) {
      insights.add(const CareInsight(
        title: 'Perfect record',
        message: 'You haven\'t skipped any recent tasks. Your orchid is getting excellent care!',
        type: InsightType.positive,
      ));
    } else if (skipRate > 0.3) {
      insights.add(const CareInsight(
        title: 'High skip rate',
        message: 'Over 30% of recent tasks were skipped. Consider adjusting intervals to better fit your schedule.',
        type: InsightType.warning,
      ));
    }
  }

  void _checkBloomCorrelation(Orchid orchid, List<CareLog> logs, List<CareInsight> insights) {
    if (orchid.currentBloomStage == null) return;

    if (orchid.currentBloomStage == BloomStage.inBloom) {
      // Check if fertilizing has been consistent
      final fertilizeLogs = logs.where((l) => l.careType == CareType.fertilize && !l.skipped).toList();
      if (fertilizeLogs.length >= 3) {
        insights.add(const CareInsight(
          title: 'Bloom success',
          message: 'Regular fertilizing may be contributing to this bloom. Keep it up!',
          type: InsightType.positive,
        ));
      }
    }

    if (orchid.currentBloomStage == BloomStage.dormant) {
      insights.add(const CareInsight(
        title: 'Dormant period',
        message: 'During dormancy, reduce watering and fertilizing. A cool night-time temperature drop can help trigger the next spike.',
        type: InsightType.info,
      ));
    }
  }

  void _checkCareFrequency(List<CareLog> logs, List<CareInsight> insights) {
    if (logs.length < 2) return;

    final oldest = logs.last.completedAt;
    final newest = logs.first.completedAt;
    final daySpan = newest.difference(oldest).inDays;

    if (daySpan >= 1) {
      final actionsPerWeek = (logs.length / daySpan) * 7;
      if (actionsPerWeek > 10) {
        insights.add(const CareInsight(
          title: 'Very attentive',
          message: 'You\'re averaging over 10 care actions per week. Make sure not to overwater — orchids like drying out between waterings.',
          type: InsightType.info,
        ));
      }
    }
  }
}
