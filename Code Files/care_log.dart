// lib/models/care_log.dart
// OrchidLife - Care log/history data model

import 'package:isar/isar.dart';

part 'care_log.g.dart';

@collection
class CareLog {
  Id id = Isar.autoIncrement;

  @Index()
  late int orchidId;

  @Index()
  late int careTaskId;

  late DateTime scheduledDate; // When it was supposed to be done

  DateTime? completedAt; // When it was actually done (null if missed/skipped)

  @Enumerated(EnumType.name)
  late CareLogStatus status;

  String? notes; // "Roots looked dry", "Used rainwater"

  String? photoPath; // Optional before/after photo

  late DateTime createdAt;

  // Constructor
  CareLog({
    this.id = Isar.autoIncrement,
    required this.orchidId,
    required this.careTaskId,
    required this.scheduledDate,
    this.completedAt,
    required this.status,
    this.notes,
    this.photoPath,
  }) {
    createdAt = DateTime.now();
    // If completed, set completedAt to now if not provided
    if (status == CareLogStatus.completed && completedAt == null) {
      completedAt = DateTime.now();
    }
  }

  // Validation
  String? validate() {
    if (orchidId <= 0) {
      return 'Invalid orchid';
    }
    if (careTaskId <= 0) {
      return 'Invalid care task';
    }
    return null;
  }

  /// How late/early was completion (in hours)
  @ignore
  int? get hoursFromScheduled {
    if (completedAt == null) return null;
    return completedAt!.difference(scheduledDate).inHours;
  }

  /// Was this completed on time (within 24 hours)?
  @ignore
  bool get wasOnTime {
    if (status != CareLogStatus.completed || completedAt == null) return false;
    final diff = completedAt!.difference(scheduledDate).abs();
    return diff.inHours <= 24;
  }

  // Copy with
  CareLog copyWith({
    Id? id,
    int? orchidId,
    int? careTaskId,
    DateTime? scheduledDate,
    DateTime? completedAt,
    CareLogStatus? status,
    String? notes,
    String? photoPath,
    DateTime? createdAt,
  }) {
    final copy = CareLog(
      id: id ?? this.id,
      orchidId: orchidId ?? this.orchidId,
      careTaskId: careTaskId ?? this.careTaskId,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      completedAt: completedAt ?? this.completedAt,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      photoPath: photoPath ?? this.photoPath,
    );
    copy.createdAt = createdAt ?? this.createdAt;
    return copy;
  }
}

/// Status of a care log entry
enum CareLogStatus {
  completed, // ✅ Done
  skipped, // ⏭️ Intentionally skipped
  missed, // ❌ Forgot / didn't do it
  snoozed, // ⏰ Delayed to later
}

/// Extension for CareLogStatus
extension CareLogStatusExtension on CareLogStatus {
  String get displayName {
    switch (this) {
      case CareLogStatus.completed:
        return 'Completed';
      case CareLogStatus.skipped:
        return 'Skipped';
      case CareLogStatus.missed:
        return 'Missed';
      case CareLogStatus.snoozed:
        return 'Snoozed';
    }
  }

  String get emoji {
    switch (this) {
      case CareLogStatus.completed:
        return '✅';
      case CareLogStatus.skipped:
        return '⏭️';
      case CareLogStatus.missed:
        return '❌';
      case CareLogStatus.snoozed:
        return '⏰';
    }
  }

  /// Color hex for this status
  String get colorHex {
    switch (this) {
      case CareLogStatus.completed:
        return '#43A047'; // Green
      case CareLogStatus.skipped:
        return '#9E9E9E'; // Gray
      case CareLogStatus.missed:
        return '#E53935'; // Red
      case CareLogStatus.snoozed:
        return '#FF9800'; // Orange
    }
  }
}
