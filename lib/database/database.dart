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
}

/// Care task types enum stored as text
enum CareType { water, fertilize, repot, mist, inspect, prune, other }

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

// ============================================================
// DATABASE CLASS
// ============================================================

@DriftDatabase(tables: [Orchids, CareTasks, CareLogs, LightReadings, Settings, SoakSessions, SoakSessionTasks])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(orchids, orchids.soakDurationMinutes);
            await m.createTable(soakSessions);
            await m.createTable(soakSessionTasks);
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
      await (delete(soakSessionTasks)..where((s) => s.orchidId.equals(id))).go();
      await (delete(careLogs)..where((l) => l.orchidId.equals(id))).go();
      await (delete(careTasks)..where((t) => t.orchidId.equals(id))).go();
      await (delete(lightReadings)..where((r) => r.orchidId.equals(id))).go();
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
    });
  }

  Future<void> snoozeTask(CareTask task, int days) async {
    final newDue = task.nextDue.add(Duration(days: days));
    await (update(careTasks)..where((t) => t.id.equals(task.id))).write(
      CareTasksCompanion(nextDue: Value(newDue)),
    );
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

  Future<int> insertCareLog(CareLogsCompanion log) =>
      into(careLogs).insert(log);

  // ============================================================
  // LIGHT READING OPERATIONS
  // ============================================================

  Future<List<LightReading>> getReadingsForOrchid(int orchidId) =>
      (select(lightReadings)
            ..where((r) => r.orchidId.equals(orchidId))
            ..orderBy([(r) => OrderingTerm.desc(r.readingAt)]))
          .get();

  Future<List<LightReading>> getAllReadings({int limit = 100}) =>
      (select(lightReadings)
            ..orderBy([(r) => OrderingTerm.desc(r.readingAt)])
            ..limit(limit))
          .get();

  Future<int> insertLightReading(LightReadingsCompanion reading) =>
      into(lightReadings).insert(reading);

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
