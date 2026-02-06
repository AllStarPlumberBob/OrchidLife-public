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

// ============================================================
// DATABASE CLASS
// ============================================================

@DriftDatabase(tables: [Orchids, CareTasks, CareLogs, LightReadings, Settings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

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
// DATABASE CONNECTION
// ============================================================

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'orchidlife.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
