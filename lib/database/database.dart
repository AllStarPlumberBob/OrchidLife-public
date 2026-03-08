import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

// ============================================================
// TABLE DEFINITIONS
// ============================================================

/// Orchid plants table
class Orchids extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get variety => text().withLength(max: 50).nullable()();
  TextColumn get location => text().withLength(max: 100).nullable()();
  TextColumn get photoPath => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get dateAcquired => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isDemo => boolean().withDefault(const Constant(false))();
  IntColumn get soakDurationMinutes => integer().withDefault(const Constant(15))();
  TextColumn get currentBloomStage => textEnum<BloomStage>().nullable()();
  DateTimeColumn get lastPotted => dateTime().nullable()();
  BoolColumn get isRescue => boolean().withDefault(const Constant(false))();
  IntColumn get speciesProfileId => integer().nullable()();
  IntColumn get growingLocationId => integer().nullable()();
}

/// Care task types enum stored as text
enum CareType { water, fertilize, repot, mist, inspect, prune, other }

/// Bloom stage enum
enum BloomStage { dormant, spikeEmerging, budding, inBloom, fading }

/// Photo journal tag enum
enum PhotoTag { bloom, repot, newGrowth, rootCheck, general }

/// Care tasks (schedules) for each orchid
class CareTasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get orchidId => integer().references(Orchids, #id)();
  TextColumn get careType => textEnum<CareType>()();
  IntColumn get intervalDays => integer()();
  DateTimeColumn get lastCompleted => dateTime().nullable()();
  DateTimeColumn get nextDue => dateTime()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  TextColumn get customLabel => text().nullable()(); // For "other" type
  IntColumn get notifyHour => integer().withDefault(const Constant(9))();
  IntColumn get notifyMinute => integer().withDefault(const Constant(0))();
}

/// Log of completed care actions
class CareLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get orchidId => integer().references(Orchids, #id)();
  IntColumn get careTaskId => integer().references(CareTasks, #id).nullable()();
  TextColumn get careType => textEnum<CareType>()();
  DateTimeColumn get completedAt => dateTime()();
  TextColumn get notes => text().nullable()();
  BoolColumn get skipped => boolean().withDefault(const Constant(false))();
}

/// Light readings from lux meter
class LightReadings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get orchidId => integer().references(Orchids, #id).nullable()();
  TextColumn get locationName => text().nullable()();
  RealColumn get luxValue => real()();
  DateTimeColumn get readingAt => dateTime()();
  TextColumn get notes => text().nullable()();
}

/// User settings
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

/// Soak session status
enum SoakStatus { soaking, readyToDrain, completed, cancelled }

/// Active soak sessions (one per duration group)
class SoakSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get startedAt => dateTime()();
  IntColumn get durationMinutes => integer().withDefault(const Constant(15))();
  TextColumn get status => textEnum<SoakStatus>()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  IntColumn get notificationId => integer()();
}

/// Join table: which care tasks belong to which soak session
class SoakSessionTasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get soakSessionId => integer().references(SoakSessions, #id)();
  IntColumn get careTaskId => integer().references(CareTasks, #id)();
  IntColumn get orchidId => integer().references(Orchids, #id)();
}

/// Bloom cycle logs
class BloomLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get orchidId => integer().references(Orchids, #id)();
  TextColumn get stage => textEnum<BloomStage>()();
  DateTimeColumn get dateLogged => dateTime()();
  TextColumn get notes => text().nullable()();
  TextColumn get photoPath => text().nullable()();
}

/// Photo journal entries
class PhotoJournal extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get orchidId => integer().references(Orchids, #id)();
  TextColumn get photoPath => text()();
  DateTimeColumn get dateTaken => dateTime()();
  TextColumn get note => text().nullable()();
  TextColumn get tag => textEnum<PhotoTag>()();
}

/// Species profiles for care defaults and intelligence
class SpeciesProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get commonName => text()();
  TextColumn get genus => text()();
  TextColumn get species => text().nullable()();
  IntColumn get idealLuxMin => integer().nullable()();
  IntColumn get idealLuxMax => integer().nullable()();
  IntColumn get tempMinF => integer().nullable()();
  IntColumn get tempMaxF => integer().nullable()();
  IntColumn get tempNightDropF => integer().nullable()();
  TextColumn get humidity => text().nullable()();
  TextColumn get bloomSeason => text().nullable()();
  TextColumn get wateringNotes => text().nullable()();
  TextColumn get fertilizingNotes => text().nullable()();
  TextColumn get difficultyLevel => text().nullable()();
  TextColumn get description => text().nullable()();
}

/// Growing locations for orchid placement
class GrowingLocations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  RealColumn get latestLuxReading => real().nullable()();
  DateTimeColumn get lastReadingAt => dateTime().nullable()();
}

/// Milestone moments for orchid achievements
class Milestones extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get orchidId => integer().references(Orchids, #id)();
  TextColumn get type => text()();
  TextColumn get message => text()();
  DateTimeColumn get triggeredAt => dateTime()();
  BoolColumn get dismissed => boolean().withDefault(const Constant(false))();
}

// ============================================================
// DATABASE CLASS
// ============================================================

@DriftDatabase(tables: [
  Orchids, CareTasks, CareLogs, LightReadings, Settings,
  SoakSessions, SoakSessionTasks, BloomLogs, PhotoJournal,
  SpeciesProfiles, GrowingLocations, Milestones,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(orchids, orchids.soakDurationMinutes);
            await m.createTable(soakSessions);
            await m.createTable(soakSessionTasks);
          }
          if (from < 3) {
            await m.addColumn(orchids, orchids.currentBloomStage);
            await m.addColumn(orchids, orchids.lastPotted);
            await m.addColumn(orchids, orchids.isRescue);
            await m.createTable(bloomLogs);
            await m.createTable(photoJournal);
          }
          if (from < 4) {
            await m.createTable(speciesProfiles);
            await m.addColumn(orchids, orchids.speciesProfileId);
            // Seed species data
            await _seedSpeciesProfiles();
          }
          if (from < 5) {
            await m.createTable(growingLocations);
            await m.createTable(milestones);
            await m.addColumn(orchids, orchids.growingLocationId);
          }
        },
        beforeOpen: (details) async {
          // Seed species profiles on fresh install
          if (details.wasCreated) {
            await _seedSpeciesProfiles();
          }
        },
      );

  // ============================================================
  // ORCHID OPERATIONS
  // ============================================================

  Future<List<Orchid>> getAllOrchids() => select(orchids).get();

  Stream<List<Orchid>> watchAllOrchids() => select(orchids).watch();

  Future<Orchid?> getOrchidById(int id) =>
      (select(orchids)..where((o) => o.id.equals(id))).getSingleOrNull();

  Future<int> insertOrchid(OrchidsCompanion orchid) =>
      into(orchids).insert(orchid);

  Future<bool> updateOrchid(Orchid orchid) =>
      update(orchids).replace(orchid);

  Future<int> deleteOrchid(int id) =>
      (delete(orchids)..where((o) => o.id.equals(id))).go();

  Future<void> deleteOrchidAndRelated(int id) async {
    await transaction(() async {
      // Find session IDs this orchid participates in before deleting join rows
      final sessionTaskRows = await (select(soakSessionTasks)
            ..where((s) => s.orchidId.equals(id)))
          .get();
      final affectedSessionIds = sessionTaskRows.map((r) => r.soakSessionId).toSet();

      await (delete(soakSessionTasks)..where((s) => s.orchidId.equals(id))).go();

      // Delete any soak sessions that now have zero remaining tasks
      for (final sessionId in affectedSessionIds) {
        final remaining = await (select(soakSessionTasks)
              ..where((s) => s.soakSessionId.equals(sessionId)))
            .get();
        if (remaining.isEmpty) {
          await (delete(soakSessions)..where((s) => s.id.equals(sessionId))).go();
        }
      }

      await (delete(careLogs)..where((l) => l.orchidId.equals(id))).go();
      await (delete(careTasks)..where((t) => t.orchidId.equals(id))).go();
      await (delete(lightReadings)..where((r) => r.orchidId.equals(id))).go();
      await (delete(bloomLogs)..where((b) => b.orchidId.equals(id))).go();
      await (delete(photoJournal)..where((p) => p.orchidId.equals(id))).go();
      await (delete(milestones)..where((m) => m.orchidId.equals(id))).go();
      await (delete(orchids)..where((o) => o.id.equals(id))).go();
    });
  }

  // ============================================================
  // CARE TASK OPERATIONS
  // ============================================================

  Future<List<CareTask>> getTasksForOrchid(int orchidId) =>
      (select(careTasks)..where((t) => t.orchidId.equals(orchidId))).get();

  Stream<List<CareTask>> watchTasksForOrchid(int orchidId) =>
      (select(careTasks)..where((t) => t.orchidId.equals(orchidId))).watch();

  Future<List<CareTask>> getAllEnabledTasks() =>
      (select(careTasks)..where((t) => t.enabled.equals(true))).get();

  Future<CareTask?> getCareTaskById(int id) =>
      (select(careTasks)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<CareTask>> getTasksDueToday() {
    final now = DateTime.now();
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    return (select(careTasks)
          ..where((t) => t.nextDue.isSmallerOrEqualValue(endOfDay))
          ..where((t) => t.enabled.equals(true)))
        .get();
  }

  /// Returns a map of orchidId → count of tasks due today (or overdue).
  Stream<Map<int, int>> watchDueTaskCountsByOrchid() {
    final now = DateTime.now();
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    return (select(careTasks)
          ..where((t) => t.nextDue.isSmallerOrEqualValue(endOfDay))
          ..where((t) => t.enabled.equals(true)))
        .watch()
        .map((tasks) {
      final counts = <int, int>{};
      for (final task in tasks) {
        counts[task.orchidId] = (counts[task.orchidId] ?? 0) + 1;
      }
      return counts;
    });
  }

  Stream<List<CareTask>> watchTasksDueToday() {
    final now = DateTime.now();
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    return (select(careTasks)
          ..where((t) => t.nextDue.isSmallerOrEqualValue(endOfDay))
          ..where((t) => t.enabled.equals(true)))
        .watch();
  }

  Future<int> insertCareTask(CareTasksCompanion task) =>
      into(careTasks).insert(task);

  Future<bool> updateCareTask(CareTask task) =>
      update(careTasks).replace(task);

  Future<int> deleteCareTask(int id) =>
      (delete(careTasks)..where((t) => t.id.equals(id))).go();

  Future<void> completeTask(CareTask task, {String? notes, bool skipped = false}) async {
    final now = DateTime.now();
    final nextDue = now.add(Duration(days: task.intervalDays));

    await transaction(() async {
      // Log the completion
      await into(careLogs).insert(CareLogsCompanion.insert(
        orchidId: task.orchidId,
        careTaskId: Value(task.id),
        careType: task.careType,
        completedAt: now,
        notes: Value(notes),
        skipped: Value(skipped),
      ));

      // Update the task
      await (update(careTasks)..where((t) => t.id.equals(task.id))).write(
        CareTasksCompanion(
          lastCompleted: Value(now),
          nextDue: Value(nextDue),
        ),
      );

      // Update lastPotted when repotting
      if (task.careType == CareType.repot && !skipped) {
        await (update(orchids)..where((o) => o.id.equals(task.orchidId))).write(
          OrchidsCompanion(lastPotted: Value(now)),
        );
      }
    });
  }

  Future<void> snoozeTask(CareTask task, int days) async {
    final newDue = task.nextDue.add(Duration(days: days));
    await (update(careTasks)..where((t) => t.id.equals(task.id))).write(
      CareTasksCompanion(nextDue: Value(newDue)),
    );
  }

  /// Undo a task completion — only allowed for today's logs
  Future<bool> undoTaskCompletion(int careLogId) async {
    final log = await (select(careLogs)..where((l) => l.id.equals(careLogId))).getSingleOrNull();
    if (log == null) return false;

    // Safety check: only undo logs from today
    final now = DateTime.now();
    final logDay = DateTime(log.completedAt.year, log.completedAt.month, log.completedAt.day);
    final today = DateTime(now.year, now.month, now.day);
    if (logDay != today) return false;

    await transaction(() async {
      // Delete the care log entry
      await (delete(careLogs)..where((l) => l.id.equals(careLogId))).go();

      // Revert the care task's nextDue and lastCompleted
      if (log.careTaskId != null) {
        await (update(careTasks)..where((t) => t.id.equals(log.careTaskId!))).write(
          CareTasksCompanion(
            nextDue: Value(today),
            lastCompleted: const Value(null),
          ),
        );
      }
    });

    return true;
  }

  // ============================================================
  // CARE LOG OPERATIONS
  // ============================================================

  Future<List<CareLog>> getLogsForOrchid(int orchidId, {int limit = 50}) =>
      (select(careLogs)
            ..where((l) => l.orchidId.equals(orchidId))
            ..orderBy([(l) => OrderingTerm.desc(l.completedAt)])
            ..limit(limit))
          .get();

  Stream<List<CareLog>> watchLogsForOrchid(int orchidId, {int limit = 50}) =>
      (select(careLogs)
            ..where((l) => l.orchidId.equals(orchidId))
            ..orderBy([(l) => OrderingTerm.desc(l.completedAt)])
            ..limit(limit))
          .watch();

  Future<List<CareLog>> getAllCareLogs() =>
      (select(careLogs)..orderBy([(l) => OrderingTerm.desc(l.completedAt)])).get();

  Future<List<CareTask>> getAllCareTasks() => select(careTasks).get();

  Future<int> insertCareLog(CareLogsCompanion log) =>
      into(careLogs).insert(log);

  /// Watch all care logs from the past N days (across all orchids)
  Stream<List<CareLog>> watchRecentCareLogs({int days = 14}) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return (select(careLogs)
          ..where((l) => l.completedAt.isBiggerOrEqualValue(cutoff))
          ..orderBy([(l) => OrderingTerm.desc(l.completedAt)]))
        .watch();
  }

  /// Watch enabled tasks due within the next N days (excludes today/overdue)
  Stream<List<CareTask>> watchUpcomingTasks({int days = 14}) {
    final now = DateTime.now();
    final endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final futureLimit = endOfToday.add(Duration(days: days));
    return (select(careTasks)
          ..where((t) => t.nextDue.isBiggerThanValue(endOfToday))
          ..where((t) => t.nextDue.isSmallerOrEqualValue(futureLimit))
          ..where((t) => t.enabled.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.nextDue)]))
        .watch();
  }

  /// Watch all orchids as a Map<int, Orchid> for O(1) lookups
  Stream<Map<int, Orchid>> watchAllOrchidsMap() {
    return watchAllOrchids().map((list) {
      return {for (final orchid in list) orchid.id: orchid};
    });
  }

  // ============================================================
  // LIGHT READING OPERATIONS
  // ============================================================

  Future<List<LightReading>> getReadingsForOrchid(int orchidId) =>
      (select(lightReadings)
            ..where((r) => r.orchidId.equals(orchidId))
            ..orderBy([(r) => OrderingTerm.desc(r.readingAt)]))
          .get();

  Future<List<LightReading>> getAllLightReadings() =>
      (select(lightReadings)..orderBy([(r) => OrderingTerm.desc(r.readingAt)])).get();

  Future<List<LightReading>> getAllReadings({int limit = 100}) =>
      (select(lightReadings)
            ..orderBy([(r) => OrderingTerm.desc(r.readingAt)])
            ..limit(limit))
          .get();

  Future<int> insertLightReading(LightReadingsCompanion reading) =>
      into(lightReadings).insert(reading);

  // ============================================================
  // BLOOM LOG OPERATIONS
  // ============================================================

  Future<List<BloomLog>> getAllBloomLogs() =>
      (select(bloomLogs)..orderBy([(b) => OrderingTerm.desc(b.dateLogged)])).get();

  Stream<List<BloomLog>> watchBloomLogsForOrchid(int orchidId) =>
      (select(bloomLogs)
            ..where((b) => b.orchidId.equals(orchidId))
            ..orderBy([(b) => OrderingTerm.desc(b.dateLogged)]))
          .watch();

  Future<int> insertBloomLog(BloomLogsCompanion log) async {
    final id = await into(bloomLogs).insert(log);
    // Update orchid's current bloom stage
    await (update(orchids)..where((o) => o.id.equals(log.orchidId.value))).write(
      OrchidsCompanion(currentBloomStage: log.stage),
    );
    return id;
  }

  // ============================================================
  // PHOTO JOURNAL OPERATIONS
  // ============================================================

  Future<List<PhotoJournalData>> getAllPhotoJournalEntries() =>
      (select(photoJournal)..orderBy([(p) => OrderingTerm.desc(p.dateTaken)])).get();

  Stream<List<PhotoJournalData>> watchPhotoJournalForOrchid(int orchidId) =>
      (select(photoJournal)
            ..where((p) => p.orchidId.equals(orchidId))
            ..orderBy([(p) => OrderingTerm.desc(p.dateTaken)]))
          .watch();

  Future<List<PhotoJournalData>> getPhotoJournalForOrchid(int orchidId) =>
      (select(photoJournal)
            ..where((p) => p.orchidId.equals(orchidId))
            ..orderBy([(p) => OrderingTerm.desc(p.dateTaken)]))
          .get();

  Future<int> insertPhotoJournalEntry(PhotoJournalCompanion entry) =>
      into(photoJournal).insert(entry);

  Future<int> deletePhotoJournalEntry(int id) =>
      (delete(photoJournal)..where((p) => p.id.equals(id))).go();

  // ============================================================
  // SPECIES PROFILE OPERATIONS
  // ============================================================

  Future<List<SpeciesProfile>> getAllSpeciesProfiles() =>
      (select(speciesProfiles)..orderBy([(s) => OrderingTerm.asc(s.commonName)])).get();

  Future<SpeciesProfile?> getSpeciesProfileById(int id) =>
      (select(speciesProfiles)..where((s) => s.id.equals(id))).getSingleOrNull();

  Future<SpeciesProfile?> getSpeciesProfileForOrchid(int orchidId) async {
    final orchid = await getOrchidById(orchidId);
    if (orchid?.speciesProfileId == null) return null;
    return getSpeciesProfileById(orchid!.speciesProfileId!);
  }

  Future<LightReading?> getLatestLightReadingForOrchid(int orchidId) =>
      (select(lightReadings)
            ..where((r) => r.orchidId.equals(orchidId))
            ..orderBy([(r) => OrderingTerm.desc(r.readingAt)])
            ..limit(1))
          .getSingleOrNull();

  // ============================================================
  // GROWING LOCATION OPERATIONS
  // ============================================================

  Future<List<GrowingLocation>> getAllGrowingLocations() =>
      (select(growingLocations)..orderBy([(l) => OrderingTerm.asc(l.name)])).get();

  Stream<List<GrowingLocation>> watchAllGrowingLocations() =>
      (select(growingLocations)..orderBy([(l) => OrderingTerm.asc(l.name)])).watch();

  Future<int> insertGrowingLocation(GrowingLocationsCompanion location) =>
      into(growingLocations).insert(location);

  Future<bool> updateGrowingLocation(GrowingLocation location) =>
      update(growingLocations).replace(location);

  Future<int> deleteGrowingLocation(int id) =>
      (delete(growingLocations)..where((l) => l.id.equals(id))).go();

  // ============================================================
  // MILESTONE OPERATIONS
  // ============================================================

  Stream<List<Milestone>> watchUndismissedMilestones() =>
      (select(milestones)
            ..where((m) => m.dismissed.equals(false))
            ..orderBy([(m) => OrderingTerm.desc(m.triggeredAt)]))
          .watch();

  Future<int> insertMilestone(MilestonesCompanion milestone) =>
      into(milestones).insert(milestone);

  Future<void> dismissMilestone(int id) async {
    await (update(milestones)..where((m) => m.id.equals(id))).write(
      const MilestonesCompanion(dismissed: Value(true)),
    );
  }

  // ============================================================
  // SOAK SESSION OPERATIONS
  // ============================================================

  /// Watch active soak sessions (soaking or readyToDrain)
  Stream<List<SoakSession>> watchActiveSoakSessions() {
    return (select(soakSessions)
          ..where((s) => s.status.isIn(['soaking', 'readyToDrain']))
          ..orderBy([(s) => OrderingTerm.asc(s.startedAt)]))
        .watch();
  }

  /// Get active soak sessions (soaking or readyToDrain) - one-shot query
  Future<List<SoakSession>> getActiveSoakSessions() {
    return (select(soakSessions)
          ..where((s) => s.status.isIn(['soaking', 'readyToDrain']))
          ..orderBy([(s) => OrderingTerm.asc(s.startedAt)]))
        .get();
  }

  /// Get tasks + orchid info for a soak session
  Future<List<SoakSessionTaskWithOrchid>> getTasksForSoakSession(int sessionId) async {
    final query = select(soakSessionTasks).join([
      innerJoin(orchids, orchids.id.equalsExp(soakSessionTasks.orchidId)),
      innerJoin(careTasks, careTasks.id.equalsExp(soakSessionTasks.careTaskId)),
    ])..where(soakSessionTasks.soakSessionId.equals(sessionId));

    final rows = await query.get();
    return rows.map((row) => SoakSessionTaskWithOrchid(
      sessionTask: row.readTable(soakSessionTasks),
      orchid: row.readTable(orchids),
      careTask: row.readTable(careTasks),
    )).toList();
  }

  /// Get orchid IDs for a soak session (lightweight — no joins to orchids table)
  Future<List<int>> getOrchidIdsForSoakSession(int sessionId) async {
    final rows = await (select(soakSessionTasks)
          ..where((t) => t.soakSessionId.equals(sessionId)))
        .get();
    return rows.map((r) => r.orchidId).toList();
  }

  /// Create a soak session with its associated tasks
  Future<int> createSoakSession({
    required List<int> taskIds,
    required List<int> orchidIds,
    required int durationMinutes,
    required int notificationId,
  }) async {
    return transaction(() async {
      final sessionId = await into(soakSessions).insert(SoakSessionsCompanion.insert(
        startedAt: DateTime.now(),
        durationMinutes: Value(durationMinutes),
        status: SoakStatus.soaking,
        notificationId: notificationId,
      ));

      for (var i = 0; i < taskIds.length; i++) {
        await into(soakSessionTasks).insert(SoakSessionTasksCompanion.insert(
          soakSessionId: sessionId,
          careTaskId: taskIds[i],
          orchidId: orchidIds[i],
        ));
      }

      return sessionId;
    });
  }

  /// Complete a soak session, completing all included tasks
  Future<void> completeSoakSession(int sessionId, {Set<int>? excludeTaskIds}) async {
    await transaction(() async {
      final sessionTasks = await getTasksForSoakSession(sessionId);

      for (final st in sessionTasks) {
        if (excludeTaskIds != null && excludeTaskIds.contains(st.careTask.id)) continue;
        await completeTask(st.careTask);
      }

      await (update(soakSessions)..where((s) => s.id.equals(sessionId))).write(
        SoakSessionsCompanion(
          status: const Value(SoakStatus.completed),
          completedAt: Value(DateTime.now()),
        ),
      );
    });
  }

  /// Cancel a soak session
  Future<void> cancelSoakSession(int sessionId) async {
    await (update(soakSessions)..where((s) => s.id.equals(sessionId))).write(
      SoakSessionsCompanion(
        status: const Value(SoakStatus.cancelled),
        completedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Get set of careTaskIds currently in active soak sessions
  Future<Set<int>> getActiveSessionTaskIds() async {
    final activeSessions = await (select(soakSessions)
          ..where((s) => s.status.isIn(['soaking', 'readyToDrain'])))
        .get();

    if (activeSessions.isEmpty) return {};

    final sessionIds = activeSessions.map((s) => s.id).toList();
    final tasks = await (select(soakSessionTasks)
          ..where((t) => t.soakSessionId.isIn(sessionIds)))
        .get();

    return tasks.map((t) => t.careTaskId).toSet();
  }

  /// Mark expired soaking sessions as readyToDrain (startup cleanup)
  Future<void> markExpiredSessionsReadyToDrain() async {
    final activeSessions = await (select(soakSessions)
          ..where((s) => s.status.equals('soaking')))
        .get();

    final now = DateTime.now();
    for (final session in activeSessions) {
      final endTime = session.startedAt.add(Duration(minutes: session.durationMinutes));
      if (now.isAfter(endTime)) {
        await (update(soakSessions)..where((s) => s.id.equals(session.id))).write(
          const SoakSessionsCompanion(status: Value(SoakStatus.readyToDrain)),
        );
      }
    }
  }

  // ============================================================
  // SETTINGS OPERATIONS
  // ============================================================

  Future<String?> getSetting(String key) async {
    final result = await (select(settings)..where((s) => s.key.equals(key)))
        .getSingleOrNull();
    return result?.value;
  }

  Future<void> setSetting(String key, String value) async {
    await into(settings).insertOnConflictUpdate(
      SettingsCompanion.insert(key: key, value: value),
    );
  }

  Future<int> deleteSetting(String key) =>
      (delete(settings)..where((s) => s.key.equals(key))).go();

  // ============================================================
  // DEMO DATA
  // ============================================================

  Future<void> insertDemoData() async {
    // Check if demo data already exists
    final existing = await (select(orchids)..where((o) => o.isDemo.equals(true))).get();
    if (existing.isNotEmpty) return;

    final now = DateTime.now();

    // Insert demo orchid
    final orchidId = await into(orchids).insert(OrchidsCompanion.insert(
      name: 'Demo Phalaenopsis',
      variety: const Value('Phalaenopsis'),
      location: const Value('Living Room - East Window'),
      notes: const Value('This is a demo orchid to show you how OrchidLife works! Feel free to delete it once you add your own plants.'),
      dateAcquired: Value(now.subtract(const Duration(days: 30))),
      isDemo: const Value(true),
    ));

    // Insert care tasks for the demo orchid
    await into(careTasks).insert(CareTasksCompanion.insert(
      orchidId: orchidId,
      careType: CareType.water,
      intervalDays: 7,
      lastCompleted: Value(now.subtract(const Duration(days: 5))),
      nextDue: now.add(const Duration(days: 2)),
    ));

    await into(careTasks).insert(CareTasksCompanion.insert(
      orchidId: orchidId,
      careType: CareType.fertilize,
      intervalDays: 30,
      lastCompleted: Value(now.subtract(const Duration(days: 25))),
      nextDue: now.add(const Duration(days: 5)),
    ));

    await into(careTasks).insert(CareTasksCompanion.insert(
      orchidId: orchidId,
      careType: CareType.mist,
      intervalDays: 2,
      lastCompleted: Value(now.subtract(const Duration(days: 1))),
      nextDue: now.add(const Duration(days: 1)),
    ));

    await into(careTasks).insert(CareTasksCompanion.insert(
      orchidId: orchidId,
      careType: CareType.inspect,
      intervalDays: 14,
      lastCompleted: Value(now.subtract(const Duration(days: 10))),
      nextDue: now.add(const Duration(days: 4)),
    ));

    // Insert some demo care logs
    await into(careLogs).insert(CareLogsCompanion.insert(
      orchidId: orchidId,
      careType: CareType.water,
      completedAt: now.subtract(const Duration(days: 5)),
      notes: const Value('Watered thoroughly, let drain'),
    ));

    await into(careLogs).insert(CareLogsCompanion.insert(
      orchidId: orchidId,
      careType: CareType.mist,
      completedAt: now.subtract(const Duration(days: 1)),
    ));
  }

  Future<void> clearDemoData() async {
    final demoOrchids = await (select(orchids)..where((o) => o.isDemo.equals(true))).get();
    for (final orchid in demoOrchids) {
      await deleteOrchidAndRelated(orchid.id);
    }
  }

  // ============================================================
  // SPECIES PROFILES SEED DATA
  // ============================================================

  Future<void> _seedSpeciesProfiles() async {
    final existing = await select(speciesProfiles).get();
    if (existing.isNotEmpty) return;

    final profiles = [
      SpeciesProfilesCompanion.insert(commonName: 'Moth Orchid', genus: 'Phalaenopsis', species: const Value('spp.'), idealLuxMin: const Value(1000), idealLuxMax: const Value(3000), tempMinF: const Value(65), tempMaxF: const Value(80), tempNightDropF: const Value(10), humidity: const Value('50-70%'), bloomSeason: const Value('Winter-Spring'), wateringNotes: const Value('Water when roots turn silvery. Soak for 15 min, drain completely.'), fertilizingNotes: const Value('Weekly at 1/4 strength during active growth.'), difficultyLevel: const Value('Easy'), description: const Value('The most popular orchid. Long-lasting blooms in many colors. Great for beginners.')),
      SpeciesProfilesCompanion.insert(commonName: 'Dendrobium', genus: 'Dendrobium', species: const Value('spp.'), idealLuxMin: const Value(2000), idealLuxMax: const Value(5000), tempMinF: const Value(60), tempMaxF: const Value(85), tempNightDropF: const Value(15), humidity: const Value('50-70%'), bloomSeason: const Value('Spring'), wateringNotes: const Value('Let dry between waterings. Reduce water in winter rest period.'), fertilizingNotes: const Value('Monthly during growth, stop in winter.'), difficultyLevel: const Value('Moderate'), description: const Value('Large diverse genus. Many need a cool dry rest to trigger blooming.')),
      SpeciesProfilesCompanion.insert(commonName: 'Cattleya', genus: 'Cattleya', species: const Value('spp.'), idealLuxMin: const Value(3000), idealLuxMax: const Value(5000), tempMinF: const Value(58), tempMaxF: const Value(85), tempNightDropF: const Value(15), humidity: const Value('50-80%'), bloomSeason: const Value('Fall-Spring'), wateringNotes: const Value('Water when medium is nearly dry. Good air circulation essential.'), fertilizingNotes: const Value('Weekly at 1/4 strength during growth.'), difficultyLevel: const Value('Moderate'), description: const Value('Classic corsage orchid with large fragrant blooms. Needs bright light.')),
      SpeciesProfilesCompanion.insert(commonName: 'Oncidium', genus: 'Oncidium', species: const Value('spp.'), idealLuxMin: const Value(2000), idealLuxMax: const Value(4000), tempMinF: const Value(58), tempMaxF: const Value(80), tempNightDropF: const Value(10), humidity: const Value('40-60%'), bloomSeason: const Value('Fall'), wateringNotes: const Value('Water when medium approaches dryness. Avoid soggy roots.'), fertilizingNotes: const Value('Biweekly at 1/4 strength.'), difficultyLevel: const Value('Easy'), description: const Value('Dancing lady orchids. Produces sprays of many small cheerful blooms.')),
      SpeciesProfilesCompanion.insert(commonName: 'Vanda', genus: 'Vanda', species: const Value('spp.'), idealLuxMin: const Value(4000), idealLuxMax: const Value(8000), tempMinF: const Value(65), tempMaxF: const Value(95), tempNightDropF: const Value(10), humidity: const Value('60-80%'), bloomSeason: const Value('Spring-Summer'), wateringNotes: const Value('Daily misting or soaking of aerial roots. High humidity essential.'), fertilizingNotes: const Value('Weekly with balanced fertilizer.'), difficultyLevel: const Value('Advanced'), description: const Value('Stunning large flat flowers. Often grown in baskets with bare roots. Needs high light.')),
      SpeciesProfilesCompanion.insert(commonName: 'Lady Slipper', genus: 'Paphiopedilum', species: const Value('spp.'), idealLuxMin: const Value(800), idealLuxMax: const Value(2000), tempMinF: const Value(60), tempMaxF: const Value(80), tempNightDropF: const Value(10), humidity: const Value('50-70%'), bloomSeason: const Value('Winter-Spring'), wateringNotes: const Value('Keep evenly moist. Never let dry completely or sit in water.'), fertilizingNotes: const Value('Monthly at 1/4 strength.'), difficultyLevel: const Value('Easy'), description: const Value('Distinctive pouch-shaped lip. Tolerates lower light. No pseudobulbs.')),
      SpeciesProfilesCompanion.insert(commonName: 'Cymbidium', genus: 'Cymbidium', species: const Value('spp.'), idealLuxMin: const Value(3000), idealLuxMax: const Value(6000), tempMinF: const Value(45), tempMaxF: const Value(75), tempNightDropF: const Value(20), humidity: const Value('40-60%'), bloomSeason: const Value('Winter-Spring'), wateringNotes: const Value('Keep moist during growth. Reduce in winter.'), fertilizingNotes: const Value('Biweekly at half strength during growth.'), difficultyLevel: const Value('Moderate'), description: const Value('Cool-growing orchids with tall sprays of long-lasting blooms. Great for outdoor growing.')),
      SpeciesProfilesCompanion.insert(commonName: 'Miltonia', genus: 'Miltonia', species: const Value('spp.'), idealLuxMin: const Value(1500), idealLuxMax: const Value(3000), tempMinF: const Value(60), tempMaxF: const Value(80), tempNightDropF: const Value(10), humidity: const Value('60-80%'), bloomSeason: const Value('Spring-Summer'), wateringNotes: const Value('Keep evenly moist. Sensitive to salt buildup.'), fertilizingNotes: const Value('Biweekly at 1/4 strength.'), difficultyLevel: const Value('Moderate'), description: const Value('Pansy orchids with flat, colorful, fragrant flowers.')),
      SpeciesProfilesCompanion.insert(commonName: 'Miltoniopsis', genus: 'Miltoniopsis', species: const Value('spp.'), idealLuxMin: const Value(1000), idealLuxMax: const Value(2500), tempMinF: const Value(55), tempMaxF: const Value(75), tempNightDropF: const Value(10), humidity: const Value('60-80%'), bloomSeason: const Value('Spring'), wateringNotes: const Value('Keep evenly moist. Sensitive to overwatering.'), fertilizingNotes: const Value('Weekly at 1/4 strength.'), difficultyLevel: const Value('Advanced'), description: const Value('Cool-growing pansy orchids. Beautiful waterfall-like flowers.')),
      SpeciesProfilesCompanion.insert(commonName: 'Brassia', genus: 'Brassia', species: const Value('spp.'), idealLuxMin: const Value(2000), idealLuxMax: const Value(4000), tempMinF: const Value(58), tempMaxF: const Value(80), tempNightDropF: const Value(10), humidity: const Value('50-70%'), bloomSeason: const Value('Spring-Summer'), wateringNotes: const Value('Water when approaching dryness.'), fertilizingNotes: const Value('Biweekly during growth.'), difficultyLevel: const Value('Easy'), description: const Value('Spider orchids with dramatic long-petaled flowers.')),
      SpeciesProfilesCompanion.insert(commonName: 'Zygopetalum', genus: 'Zygopetalum', species: const Value('spp.'), idealLuxMin: const Value(2000), idealLuxMax: const Value(4000), tempMinF: const Value(55), tempMaxF: const Value(75), tempNightDropF: const Value(15), humidity: const Value('50-70%'), bloomSeason: const Value('Fall-Winter'), wateringNotes: const Value('Keep moist. Let medium nearly dry between waterings.'), fertilizingNotes: const Value('Biweekly during growth.'), difficultyLevel: const Value('Moderate'), description: const Value('Fragrant orchids with striking patterned flowers in greens and purples.')),
      SpeciesProfilesCompanion.insert(commonName: 'Ludisia', genus: 'Ludisia', species: const Value('discolor'), idealLuxMin: const Value(500), idealLuxMax: const Value(1500), tempMinF: const Value(65), tempMaxF: const Value(80), tempNightDropF: const Value(10), humidity: const Value('50-70%'), bloomSeason: const Value('Winter'), wateringNotes: const Value('Keep moist but not waterlogged.'), fertilizingNotes: const Value('Monthly at 1/4 strength.'), difficultyLevel: const Value('Easy'), description: const Value('Jewel orchid grown for its stunning dark velvety leaves with silver veining.')),
      SpeciesProfilesCompanion.insert(commonName: 'Epidendrum', genus: 'Epidendrum', species: const Value('spp.'), idealLuxMin: const Value(3000), idealLuxMax: const Value(6000), tempMinF: const Value(55), tempMaxF: const Value(85), tempNightDropF: const Value(10), humidity: const Value('40-60%'), bloomSeason: const Value('Year-round'), wateringNotes: const Value('Water when medium is dry. Very drought tolerant.'), fertilizingNotes: const Value('Monthly at 1/4 strength.'), difficultyLevel: const Value('Easy'), description: const Value('Reed-stem orchids with clusters of small colorful flowers. Very hardy.')),
      SpeciesProfilesCompanion.insert(commonName: 'Masdevallia', genus: 'Masdevallia', species: const Value('spp.'), idealLuxMin: const Value(800), idealLuxMax: const Value(2000), tempMinF: const Value(50), tempMaxF: const Value(70), tempNightDropF: const Value(10), humidity: const Value('70-90%'), bloomSeason: const Value('Spring-Summer'), wateringNotes: const Value('Keep constantly moist. Sphagnum works well.'), fertilizingNotes: const Value('Weekly at 1/4 strength.'), difficultyLevel: const Value('Advanced'), description: const Value('Cool-growing miniatures with unique triangular flowers. Need high humidity.')),
      SpeciesProfilesCompanion.insert(commonName: 'Bulbophyllum', genus: 'Bulbophyllum', species: const Value('spp.'), idealLuxMin: const Value(1000), idealLuxMax: const Value(3000), tempMinF: const Value(60), tempMaxF: const Value(85), tempNightDropF: const Value(10), humidity: const Value('60-80%'), bloomSeason: const Value('Varies'), wateringNotes: const Value('Keep moist year-round. Do not let dry out.'), fertilizingNotes: const Value('Biweekly at 1/4 strength.'), difficultyLevel: const Value('Moderate'), description: const Value('Largest orchid genus with bizarre, fascinating flowers. Many are fragrant.')),
      SpeciesProfilesCompanion.insert(commonName: 'Phragmipedium', genus: 'Phragmipedium', species: const Value('spp.'), idealLuxMin: const Value(1500), idealLuxMax: const Value(3000), tempMinF: const Value(60), tempMaxF: const Value(80), tempNightDropF: const Value(10), humidity: const Value('60-80%'), bloomSeason: const Value('Fall-Spring'), wateringNotes: const Value('Keep very moist — one of few orchids that can sit in shallow water.'), fertilizingNotes: const Value('Weekly at 1/4 strength.'), difficultyLevel: const Value('Moderate'), description: const Value('New World slipper orchids. Sequential bloomers with elegant pouched flowers.')),
      SpeciesProfilesCompanion.insert(commonName: 'Cambria', genus: 'Oncidium', species: const Value('(intergeneric hybrid)'), idealLuxMin: const Value(1500), idealLuxMax: const Value(3000), tempMinF: const Value(58), tempMaxF: const Value(78), tempNightDropF: const Value(10), humidity: const Value('50-60%'), bloomSeason: const Value('Fall-Winter'), wateringNotes: const Value('Water when medium is nearly dry.'), fertilizingNotes: const Value('Biweekly at 1/4 strength.'), difficultyLevel: const Value('Easy'), description: const Value('Popular intergeneric hybrids with star-shaped flowers. Widely available and forgiving.')),
      SpeciesProfilesCompanion.insert(commonName: 'Dracula', genus: 'Dracula', species: const Value('spp.'), idealLuxMin: const Value(500), idealLuxMax: const Value(1500), tempMinF: const Value(50), tempMaxF: const Value(68), tempNightDropF: const Value(10), humidity: const Value('80-100%'), bloomSeason: const Value('Varies'), wateringNotes: const Value('Keep constantly moist in live sphagnum.'), fertilizingNotes: const Value('Light feeding monthly.'), difficultyLevel: const Value('Advanced'), description: const Value('Cool-growing orchids with dramatic monkey-face flowers. Need very high humidity.')),
      SpeciesProfilesCompanion.insert(commonName: 'Brassavola', genus: 'Brassavola', species: const Value('spp.'), idealLuxMin: const Value(3000), idealLuxMax: const Value(6000), tempMinF: const Value(55), tempMaxF: const Value(85), tempNightDropF: const Value(15), humidity: const Value('40-70%'), bloomSeason: const Value('Summer-Fall'), wateringNotes: const Value('Let dry between waterings. Tolerates drought.'), fertilizingNotes: const Value('Biweekly at 1/4 strength during growth.'), difficultyLevel: const Value('Easy'), description: const Value('Lady of the night orchid. Fragrant white flowers that bloom at night.')),
      SpeciesProfilesCompanion.insert(commonName: 'Laelia', genus: 'Laelia', species: const Value('spp.'), idealLuxMin: const Value(3000), idealLuxMax: const Value(5000), tempMinF: const Value(55), tempMaxF: const Value(85), tempNightDropF: const Value(15), humidity: const Value('40-60%'), bloomSeason: const Value('Fall-Winter'), wateringNotes: const Value('Water well, then let dry. Good drainage essential.'), fertilizingNotes: const Value('Biweekly during growth.'), difficultyLevel: const Value('Moderate'), description: const Value('Related to Cattleya with bright colorful blooms. Many are now reclassified.')),
      SpeciesProfilesCompanion.insert(commonName: 'Maxillaria', genus: 'Maxillaria', species: const Value('spp.'), idealLuxMin: const Value(1500), idealLuxMax: const Value(3000), tempMinF: const Value(55), tempMaxF: const Value(80), tempNightDropF: const Value(10), humidity: const Value('50-70%'), bloomSeason: const Value('Spring'), wateringNotes: const Value('Keep evenly moist.'), fertilizingNotes: const Value('Biweekly at 1/4 strength.'), difficultyLevel: const Value('Moderate'), description: const Value('Coconut orchid — many species have a distinct coconut fragrance.')),
      SpeciesProfilesCompanion.insert(commonName: 'Tolumnia', genus: 'Tolumnia', species: const Value('spp.'), idealLuxMin: const Value(2000), idealLuxMax: const Value(4000), tempMinF: const Value(60), tempMaxF: const Value(85), tempNightDropF: const Value(10), humidity: const Value('50-70%'), bloomSeason: const Value('Year-round'), wateringNotes: const Value('Dry quickly between waterings. Mount on cork for best results.'), fertilizingNotes: const Value('Weekly misting with dilute fertilizer.'), difficultyLevel: const Value('Moderate'), description: const Value('Equitant oncidiums — compact miniatures with disproportionately large, colorful flower sprays.')),
      SpeciesProfilesCompanion.insert(commonName: 'Catasetum', genus: 'Catasetum', species: const Value('spp.'), idealLuxMin: const Value(3000), idealLuxMax: const Value(6000), tempMinF: const Value(65), tempMaxF: const Value(90), tempNightDropF: const Value(10), humidity: const Value('50-70%'), bloomSeason: const Value('Summer-Fall'), wateringNotes: const Value('Water heavily during growth. Completely stop water when leaves drop in winter.'), fertilizingNotes: const Value('Heavy feeding during growth season.'), difficultyLevel: const Value('Moderate'), description: const Value('Deciduous orchids that catapult pollen. Dramatic blooms and strict seasonal dormancy.')),
      SpeciesProfilesCompanion.insert(commonName: 'Stanhopea', genus: 'Stanhopea', species: const Value('spp.'), idealLuxMin: const Value(2000), idealLuxMax: const Value(4000), tempMinF: const Value(55), tempMaxF: const Value(80), tempNightDropF: const Value(10), humidity: const Value('60-80%'), bloomSeason: const Value('Summer'), wateringNotes: const Value('Keep moist year-round.'), fertilizingNotes: const Value('Biweekly at 1/4 strength.'), difficultyLevel: const Value('Moderate'), description: const Value('Spectacular pendant flowers that emerge through the basket. Short-lived but dramatic and fragrant.')),
    ];

    for (final profile in profiles) {
      try {
        await into(speciesProfiles).insert(profile);
      } catch (e) {
        // Continue seeding remaining species if one fails
      }
    }
  }
}

// ============================================================
// DATA CLASSES
// ============================================================

class SoakSessionTaskWithOrchid {
  final SoakSessionTask sessionTask;
  final Orchid orchid;
  final CareTask careTask;

  SoakSessionTaskWithOrchid({
    required this.sessionTask,
    required this.orchid,
    required this.careTask,
  });
}

// ============================================================
// DATABASE CONNECTION
// ============================================================

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'orchidlife.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
