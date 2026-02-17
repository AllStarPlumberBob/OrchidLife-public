import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../database/database.dart';

class ExportService {
  final AppDatabase _db;

  ExportService(this._db);

  /// Export all orchid data + photos as a ZIP file, then share it.
  Future<void> exportAndShare() async {
    final archive = Archive();

    // Gather all data
    final orchids = await _db.getAllOrchids();
    final careTasks = await _db.getAllCareTasks();
    final careLogs = await _db.getAllCareLogs();
    final lightReadings = await _db.getAllLightReadings();
    final bloomLogs = await _db.getAllBloomLogs();
    final photoJournal = await _db.getAllPhotoJournalEntries();

    // Build JSON export
    final exportData = {
      'exportedAt': DateTime.now().toIso8601String(),
      'version': '1.0',
      'orchids': orchids.map((o) => {
        'id': o.id,
        'name': o.name,
        'variety': o.variety,
        'location': o.location,
        'photoPath': o.photoPath != null ? 'photos/${p.basename(o.photoPath!)}' : null,
        'notes': o.notes,
        'dateAcquired': o.dateAcquired?.toIso8601String(),
        'createdAt': o.createdAt.toIso8601String(),
        'isDemo': o.isDemo,
        'soakDurationMinutes': o.soakDurationMinutes,
        'currentBloomStage': o.currentBloomStage?.name,
        'lastPotted': o.lastPotted?.toIso8601String(),
        'isRescue': o.isRescue,
        'speciesProfileId': o.speciesProfileId,
      }).toList(),
      'careTasks': careTasks.map((t) => {
        'id': t.id,
        'orchidId': t.orchidId,
        'careType': t.careType.name,
        'intervalDays': t.intervalDays,
        'lastCompleted': t.lastCompleted?.toIso8601String(),
        'nextDue': t.nextDue.toIso8601String(),
        'enabled': t.enabled,
        'customLabel': t.customLabel,
        'notifyHour': t.notifyHour,
        'notifyMinute': t.notifyMinute,
      }).toList(),
      'careLogs': careLogs.map((l) => {
        'id': l.id,
        'orchidId': l.orchidId,
        'careTaskId': l.careTaskId,
        'careType': l.careType.name,
        'completedAt': l.completedAt.toIso8601String(),
        'notes': l.notes,
        'skipped': l.skipped,
      }).toList(),
      'lightReadings': lightReadings.map((r) => {
        'id': r.id,
        'orchidId': r.orchidId,
        'locationName': r.locationName,
        'luxValue': r.luxValue,
        'readingAt': r.readingAt.toIso8601String(),
        'notes': r.notes,
      }).toList(),
      'bloomLogs': bloomLogs.map((b) => {
        'id': b.id,
        'orchidId': b.orchidId,
        'stage': b.stage.name,
        'dateLogged': b.dateLogged.toIso8601String(),
        'notes': b.notes,
        'photoPath': b.photoPath != null ? 'photos/${p.basename(b.photoPath!)}' : null,
      }).toList(),
      'photoJournal': photoJournal.map((pj) => {
        'id': pj.id,
        'orchidId': pj.orchidId,
        'photoPath': 'photos/${p.basename(pj.photoPath)}',
        'dateTaken': pj.dateTaken.toIso8601String(),
        'note': pj.note,
        'tag': pj.tag.name,
      }).toList(),
    };

    // Add JSON to archive
    final jsonBytes = utf8.encode(const JsonEncoder.withIndent('  ').convert(exportData));
    archive.addFile(ArchiveFile('orchidlife_export.json', jsonBytes.length, jsonBytes));

    // Collect all photo paths to include
    final photoPaths = <String>{};
    for (final o in orchids) {
      if (o.photoPath != null) photoPaths.add(o.photoPath!);
    }
    for (final b in bloomLogs) {
      if (b.photoPath != null) photoPaths.add(b.photoPath!);
    }
    for (final pj in photoJournal) {
      photoPaths.add(pj.photoPath);
    }

    // Add photos to archive
    for (final photoPath in photoPaths) {
      final file = File(photoPath);
      if (await file.exists()) {
        final bytes = await file.readAsBytes();
        archive.addFile(ArchiveFile('photos/${p.basename(photoPath)}', bytes.length, bytes));
      }
    }

    // Encode ZIP and write to temp file
    final zipData = ZipEncoder().encode(archive);
    if (zipData == null) throw Exception('Failed to create ZIP archive');

    final tempDir = await getTemporaryDirectory();
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-').split('.').first;
    final zipFile = File(p.join(tempDir.path, 'OrchidLife_Export_$timestamp.zip'));
    await zipFile.writeAsBytes(zipData);

    // Share
    await Share.shareXFiles(
      [XFile(zipFile.path)],
      text: 'OrchidLife Data Export',
      subject: 'OrchidLife Data Export',
    );
  }
}
