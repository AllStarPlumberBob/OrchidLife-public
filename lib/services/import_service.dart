import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../database/database.dart';

class ImportResult {
  final bool success;
  final int orchidsImported;
  final int tasksImported;
  final int logsImported;
  final int photosImported;
  final String? error;

  ImportResult({
    required this.success,
    this.orchidsImported = 0,
    this.tasksImported = 0,
    this.logsImported = 0,
    this.photosImported = 0,
    this.error,
  });
}

class ImportService {
  final AppDatabase _db;

  ImportService(this._db);

  Future<ImportResult> importFromZip(String zipFilePath) async {
    try {
      // 1. Read and decode the ZIP
      final zipBytes = await File(zipFilePath).readAsBytes();
      final archive = ZipDecoder().decodeBytes(zipBytes);

      // 2. Find and parse the JSON export
      final jsonFile = archive.files.firstWhere(
        (f) => f.name == 'orchidlife_export.json',
        orElse: () => throw Exception('No orchidlife_export.json found in archive'),
      );
      final jsonString = utf8.decode(jsonFile.content as List<int>);
      final exportData = json.decode(jsonString) as Map<String, dynamic>;

      // 3. Extract new photos to a temporary directory first (don't touch existing yet)
      final appDir = await getApplicationDocumentsDirectory();
      final photosDir = Directory(p.join(appDir.path, 'orchid_photos'));
      final tempPhotosDir = Directory(p.join(appDir.path, 'orchid_photos_import'));

      // Clean up any leftover temp dir from a previous failed import
      if (await tempPhotosDir.exists()) {
        await tempPhotosDir.delete(recursive: true);
      }
      await tempPhotosDir.create(recursive: true);

      final photoPathMap = <String, String>{};
      int photosExtracted = 0;
      for (final file in archive.files) {
        if (file.isFile && file.name.startsWith('photos/')) {
          final fileName = p.basename(file.name);
          if (fileName.isEmpty) continue;
          // Write to temp dir; paths will point to final location for DB records
          final tempPath = p.join(tempPhotosDir.path, fileName);
          await File(tempPath).writeAsBytes(file.content as List<int>);
          // Map to the final destination path (orchid_photos/)
          photoPathMap[file.name] = p.join(photosDir.path, fileName);
          photosExtracted++;
        }
      }

      // 4. Parse JSON lists
      final orchidsList = (exportData['orchids'] as List?) ?? [];
      final tasksList = (exportData['careTasks'] as List?) ?? [];
      final logsList = (exportData['careLogs'] as List?) ?? [];
      final lightList = (exportData['lightReadings'] as List?) ?? [];
      final bloomList = (exportData['bloomLogs'] as List?) ?? [];
      final photoList = (exportData['photoJournal'] as List?) ?? [];

      int orchidsImported = 0;
      int tasksImported = 0;
      int logsImported = 0;

      // 5. Clear + import all DB data in a single transaction (atomic)
      await _db.transaction(() async {
        await _db.clearAllUserData();

        // Get valid species profile IDs for validation
        final validSpeciesIds = (await _db.getAllSpeciesProfiles()).map((s) => s.id).toSet();

        // Import orchids with ID remapping
        final orchidIdMap = <int, int>{};
        for (final o in orchidsList) {
          final data = o as Map<String, dynamic>;
          final oldId = data['id'] as int;
          String? newPhotoPath;
          if (data['photoPath'] != null) {
            newPhotoPath = photoPathMap[data['photoPath'] as String];
          }

          final speciesId = data['speciesProfileId'] as int?;
          final validSpeciesId = (speciesId != null && validSpeciesIds.contains(speciesId))
              ? speciesId
              : null;

          final newId = await _db.insertOrchid(OrchidsCompanion.insert(
            name: data['name'] as String,
            variety: Value(data['variety'] as String?),
            location: Value(data['location'] as String?),
            photoPath: Value(newPhotoPath),
            notes: Value(data['notes'] as String?),
            dateAcquired: Value(_parseDateTime(data['dateAcquired'] as String?)),
            createdAt: Value(_parseDateTime(data['createdAt'] as String?) ?? DateTime.now()),
            isDemo: Value(data['isDemo'] as bool? ?? false),
            soakDurationMinutes: Value(data['soakDurationMinutes'] as int? ?? 15),
            currentBloomStage: Value(_parseBloomStage(data['currentBloomStage'] as String?)),
            lastPotted: Value(_parseDateTime(data['lastPotted'] as String?)),
            isRescue: Value(data['isRescue'] as bool? ?? false),
            speciesProfileId: Value(validSpeciesId),
          ));
          orchidIdMap[oldId] = newId;
          orchidsImported++;
        }

        // Import care tasks with ID remapping
        final careTaskIdMap = <int, int>{};
        for (final t in tasksList) {
          final data = t as Map<String, dynamic>;
          final oldId = data['id'] as int;
          final oldOrchidId = data['orchidId'] as int;
          final newOrchidId = orchidIdMap[oldOrchidId];
          if (newOrchidId == null) continue;

          final newId = await _db.insertCareTask(CareTasksCompanion.insert(
            orchidId: newOrchidId,
            careType: _parseCareType(data['careType'] as String),
            intervalDays: data['intervalDays'] as int,
            lastCompleted: Value(_parseDateTime(data['lastCompleted'] as String?)),
            nextDue: DateTime.parse(data['nextDue'] as String),
            enabled: Value(data['enabled'] as bool? ?? true),
            customLabel: Value(data['customLabel'] as String?),
            notifyHour: Value(data['notifyHour'] as int? ?? 9),
            notifyMinute: Value(data['notifyMinute'] as int? ?? 0),
          ));
          careTaskIdMap[oldId] = newId;
          tasksImported++;
        }

        // Import care logs
        for (final l in logsList) {
          final data = l as Map<String, dynamic>;
          final oldOrchidId = data['orchidId'] as int;
          final newOrchidId = orchidIdMap[oldOrchidId];
          if (newOrchidId == null) continue;

          final oldTaskId = data['careTaskId'] as int?;
          final newTaskId = oldTaskId != null ? careTaskIdMap[oldTaskId] : null;

          await _db.insertCareLog(CareLogsCompanion.insert(
            orchidId: newOrchidId,
            careTaskId: Value(newTaskId),
            careType: _parseCareType(data['careType'] as String),
            completedAt: DateTime.parse(data['completedAt'] as String),
            notes: Value(data['notes'] as String?),
            skipped: Value(data['skipped'] as bool? ?? false),
          ));
          logsImported++;
        }

        // Import light readings
        for (final r in lightList) {
          final data = r as Map<String, dynamic>;
          final oldOrchidId = data['orchidId'] as int?;
          final newOrchidId = oldOrchidId != null ? orchidIdMap[oldOrchidId] : null;

          await _db.insertLightReading(LightReadingsCompanion.insert(
            orchidId: Value(newOrchidId),
            locationName: Value(data['locationName'] as String?),
            luxValue: (data['luxValue'] as num).toDouble(),
            readingAt: DateTime.parse(data['readingAt'] as String),
            notes: Value(data['notes'] as String?),
          ));
        }

        // Import bloom logs
        for (final b in bloomList) {
          final data = b as Map<String, dynamic>;
          final oldOrchidId = data['orchidId'] as int;
          final newOrchidId = orchidIdMap[oldOrchidId];
          if (newOrchidId == null) continue;

          String? newPhotoPath;
          if (data['photoPath'] != null) {
            newPhotoPath = photoPathMap[data['photoPath'] as String];
          }

          await _db.insertBloomLogRaw(BloomLogsCompanion.insert(
            orchidId: newOrchidId,
            stage: _parseBloomStage(data['stage'] as String?) ?? BloomStage.dormant,
            dateLogged: DateTime.parse(data['dateLogged'] as String),
            notes: Value(data['notes'] as String?),
            photoPath: Value(newPhotoPath),
          ));
        }

        // Import photo journal entries
        for (final pj in photoList) {
          final data = pj as Map<String, dynamic>;
          final oldOrchidId = data['orchidId'] as int;
          final newOrchidId = orchidIdMap[oldOrchidId];
          if (newOrchidId == null) continue;

          final newPhotoPath = photoPathMap[data['photoPath'] as String];
          if (newPhotoPath == null) continue; // Skip if photo wasn't in archive

          await _db.insertPhotoJournalEntry(PhotoJournalCompanion.insert(
            orchidId: newOrchidId,
            photoPath: newPhotoPath,
            dateTaken: DateTime.parse(data['dateTaken'] as String),
            note: Value(data['note'] as String?),
            tag: _parsePhotoTag(data['tag'] as String?) ?? PhotoTag.general,
          ));
        }
      });

      // 6. DB transaction succeeded — now swap photo directories
      if (await photosDir.exists()) {
        await photosDir.delete(recursive: true);
      }
      await tempPhotosDir.rename(photosDir.path);

      return ImportResult(
        success: true,
        orchidsImported: orchidsImported,
        tasksImported: tasksImported,
        logsImported: logsImported,
        photosImported: photosExtracted,
      );
    } catch (e) {
      // Clean up temp photos dir if it exists
      try {
        final appDir = await getApplicationDocumentsDirectory();
        final tempPhotosDir = Directory(p.join(appDir.path, 'orchid_photos_import'));
        if (await tempPhotosDir.exists()) {
          await tempPhotosDir.delete(recursive: true);
        }
      } catch (_) {}
      return ImportResult(success: false, error: e.toString());
    }
  }

  static DateTime? _parseDateTime(String? iso) {
    if (iso == null) return null;
    return DateTime.tryParse(iso);
  }

  static CareType _parseCareType(String name) {
    return CareType.values.firstWhere(
      (c) => c.name == name,
      orElse: () => CareType.other,
    );
  }

  static BloomStage? _parseBloomStage(String? name) {
    if (name == null) return null;
    return BloomStage.values.where((s) => s.name == name).firstOrNull;
  }

  static PhotoTag? _parsePhotoTag(String? name) {
    if (name == null) return null;
    return PhotoTag.values.where((t) => t.name == name).firstOrNull;
  }
}
