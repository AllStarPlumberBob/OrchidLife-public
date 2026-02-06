// lib/services/database_service.dart
// OrchidLife - Isar database service

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

import '../models/orchid.dart';
import '../models/care_task.dart';
import '../models/care_log.dart';
import '../models/light_reading.dart';

class DatabaseService {
  static DatabaseService? _instance;
  static Isar? _isar;

  DatabaseService._internal();

  /// Get singleton instance
  static Future<DatabaseService> getInstance() async {
    if (_instance == null) {
      _instance = DatabaseService._internal();
      await _instance!._init();
    }
    return _instance!;
  }

  /// Get Isar instance directly
  static Isar get isar {
    if (_isar == null) {
      throw Exception('Database not initialized. Call getInstance() first.');
    }
    return _isar!;
  }

  /// Initialize the database
  Future<void> _init() async {
    if (_isar != null) return;

    try {
      final dir = await getApplicationDocumentsDirectory();
      
      _isar = await Isar.open(
        [
          OrchidSchema,
          CareTaskSchema,
          CareLogSchema,
          LightReadingSchema,
        ],
        directory: dir.path,
        name: 'orchidlife',
      );
      
      debugPrint('DatabaseService: Isar initialized at ${dir.path}');
    } catch (e) {
      debugPrint('DatabaseService: Failed to initialize Isar: $e');
      rethrow;
    }
  }

  /// Close database (call on app dispose if needed)
  Future<void> close() async {
    await _isar?.close();
    _isar = null;
    _instance = null;
    debugPrint('DatabaseService: Isar closed');
  }

  /// Clear all data (for testing/reset)
  Future<void> clearAll() async {
    await _isar?.writeTxn(() async {
      await _isar!.clear();
    });
    debugPrint('DatabaseService: All data cleared');
  }

  /// Get database stats
  Future<Map<String, int>> getStats() async {
    final orchidCount = await _isar?.orchids.count() ?? 0;
    final careTaskCount = await _isar?.careTasks.count() ?? 0;
    final careLogCount = await _isar?.careLogs.count() ?? 0;
    final lightReadingCount = await _isar?.lightReadings.count() ?? 0;

    return {
      'orchids': orchidCount,
      'careTasks': careTaskCount,
      'careLogs': careLogCount,
      'lightReadings': lightReadingCount,
    };
  }
}
