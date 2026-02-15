import 'package:drift/drift.dart';
import '../database/database.dart';

/// Checks for milestone conditions and creates milestone records.
class MilestoneService {
  final AppDatabase db;

  MilestoneService(this.db);

  /// Run on app startup to check for new milestones
  Future<void> checkMilestones() async {
    final orchids = await db.getAllOrchids();
    final now = DateTime.now();

    for (final orchid in orchids) {
      await _checkAnniversary(orchid, now);
      await _checkBloomCount(orchid);
      await _checkCareStreak(orchid, now);
    }
  }

  Future<void> _checkAnniversary(Orchid orchid, DateTime now) async {
    if (orchid.dateAcquired == null) return;

    final years = now.difference(orchid.dateAcquired!).inDays ~/ 365;
    if (years < 1) return;

    // Check if we already have this anniversary milestone
    final existing = await _hasMilestone(orchid.id, 'anniversary_$years');
    if (existing) return;

    final yearWord = years == 1 ? 'year' : 'years';
    await db.insertMilestone(MilestonesCompanion.insert(
      orchidId: orchid.id,
      type: 'anniversary_$years',
      message: '${orchid.name} has been with you for $years $yearWord! Happy anniversary!',
      triggeredAt: now,
    ));
  }

  Future<void> _checkBloomCount(Orchid orchid) async {
    final bloomLogs = await (db.select(db.bloomLogs)
          ..where((b) => b.orchidId.equals(orchid.id))
          ..where((b) => b.stage.equalsValue(BloomStage.inBloom)))
        .get();

    final bloomCount = bloomLogs.length;
    if (bloomCount == 0) return;

    // Milestones at 1, 5, 10 blooms
    for (final threshold in [1, 5, 10]) {
      if (bloomCount >= threshold) {
        final existing = await _hasMilestone(orchid.id, 'bloom_$threshold');
        if (!existing) {
          final message = threshold == 1
              ? '${orchid.name} bloomed for the first time!'
              : '${orchid.name} has bloomed $threshold times!';
          await db.insertMilestone(MilestonesCompanion.insert(
            orchidId: orchid.id,
            type: 'bloom_$threshold',
            message: message,
            triggeredAt: DateTime.now(),
          ));
        }
      }
    }
  }

  Future<void> _checkCareStreak(Orchid orchid, DateTime now) async {
    // Check for 30-day care streak (at least one log in the past 30 days)
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    final recentLogs = await (db.select(db.careLogs)
          ..where((l) => l.orchidId.equals(orchid.id))
          ..where((l) => l.completedAt.isBiggerOrEqualValue(thirtyDaysAgo))
          ..where((l) => l.skipped.equals(false)))
        .get();

    if (recentLogs.length >= 10) {
      final monthKey = '${now.year}_${now.month}';
      final existing = await _hasMilestone(orchid.id, 'care_streak_$monthKey');
      if (!existing) {
        await db.insertMilestone(MilestonesCompanion.insert(
          orchidId: orchid.id,
          type: 'care_streak_$monthKey',
          message: 'Great care streak for ${orchid.name}! ${recentLogs.length} care actions this month.',
          triggeredAt: now,
        ));
      }
    }
  }

  Future<bool> _hasMilestone(int orchidId, String type) async {
    final result = await (db.select(db.milestones)
          ..where((m) => m.orchidId.equals(orchidId))
          ..where((m) => m.type.equals(type)))
        .get();
    return result.isNotEmpty;
  }
}
