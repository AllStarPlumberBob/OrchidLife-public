// lib/models/care_task.dart
// OrchidLife - Care task/schedule data model

import 'package:isar/isar.dart';
import 'package:flutter/material.dart';

part 'care_task.g.dart';

@collection
class CareTask {
  Id id = Isar.autoIncrement;

  @Index()
  late int orchidId; // Links to Orchid

  @Enumerated(EnumType.name)
  late CareType careType;

  late int intervalDays; // Every X days

  String? preferredTime; // "09:00" - when to remind

  String? instructions; // "Use rain water, room temp"

  @Index()
  late bool isActive;

  DateTime? lastCompleted; // When was this last done

  DateTime? nextDue; // Calculated next due date

  late DateTime createdAt;

  // Constructor
  CareTask({
    this.id = Isar.autoIncrement,
    required this.orchidId,
    required this.careType,
    this.intervalDays = 7,
    this.preferredTime = '09:00',
    this.instructions,
    this.isActive = true,
    this.lastCompleted,
    this.nextDue,
  }) {
    createdAt = DateTime.now();
    // If no nextDue set, calculate from now
    nextDue ??= DateTime.now().add(Duration(days: intervalDays));
  }

  // Validation
  String? validate() {
    if (orchidId <= 0) {
      return 'Invalid orchid';
    }
    if (intervalDays < 1 || intervalDays > 365) {
      return 'Interval must be between 1 and 365 days';
    }
    if (preferredTime != null && !_isValidTimeFormat(preferredTime!)) {
      return 'Invalid time format';
    }
    return null;
  }

  bool _isValidTimeFormat(String time) {
    final regex = RegExp(r'^([01]\d|2[0-3]):([0-5]\d)$');
    return regex.hasMatch(time);
  }

  /// Mark task as completed and calculate next due date
  void markCompleted() {
    lastCompleted = DateTime.now();
    nextDue = DateTime.now().add(Duration(days: intervalDays));
  }

  /// Check if task is due today or overdue
  @ignore
  bool get isDueToday {
    if (nextDue == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDate = DateTime(nextDue!.year, nextDue!.month, nextDue!.day);
    return dueDate.isBefore(today) || dueDate.isAtSameMomentAs(today);
  }

  /// Check if overdue
  @ignore
  bool get isOverdue {
    if (nextDue == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDate = DateTime(nextDue!.year, nextDue!.month, nextDue!.day);
    return dueDate.isBefore(today);
  }

  /// Days until due (negative if overdue)
  @ignore
  int get daysUntilDue {
    if (nextDue == null) return 0;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDate = DateTime(nextDue!.year, nextDue!.month, nextDue!.day);
    return dueDate.difference(today).inDays;
  }

  // Copy with
  CareTask copyWith({
    Id? id,
    int? orchidId,
    CareType? careType,
    int? intervalDays,
    String? preferredTime,
    String? instructions,
    bool? isActive,
    DateTime? lastCompleted,
    DateTime? nextDue,
    DateTime? createdAt,
  }) {
    final copy = CareTask(
      id: id ?? this.id,
      orchidId: orchidId ?? this.orchidId,
      careType: careType ?? this.careType,
      intervalDays: intervalDays ?? this.intervalDays,
      preferredTime: preferredTime ?? this.preferredTime,
      instructions: instructions ?? this.instructions,
      isActive: isActive ?? this.isActive,
      lastCompleted: lastCompleted ?? this.lastCompleted,
      nextDue: nextDue ?? this.nextDue,
    );
    copy.createdAt = createdAt ?? this.createdAt;
    return copy;
  }
}

/// Types of care tasks
enum CareType {
  watering,
  fertilizing,
  misting,
  repotting,
  inspection,
  rotation,
  cleaning,
  custom,
}

/// Extension for CareType
extension CareTypeExtension on CareType {
  String get displayName {
    switch (this) {
      case CareType.watering:
        return 'Watering';
      case CareType.fertilizing:
        return 'Fertilizing';
      case CareType.misting:
        return 'Misting';
      case CareType.repotting:
        return 'Repotting';
      case CareType.inspection:
        return 'Inspection';
      case CareType.rotation:
        return 'Rotation';
      case CareType.cleaning:
        return 'Cleaning';
      case CareType.custom:
        return 'Custom';
    }
  }

  String get emoji {
    switch (this) {
      case CareType.watering:
        return '💧';
      case CareType.fertilizing:
        return '🌱';
      case CareType.misting:
        return '💨';
      case CareType.repotting:
        return '🪴';
      case CareType.inspection:
        return '🔍';
      case CareType.rotation:
        return '🔄';
      case CareType.cleaning:
        return '🧹';
      case CareType.custom:
        return '📝';
    }
  }

  IconData get icon {
    switch (this) {
      case CareType.watering:
        return Icons.water_drop;
      case CareType.fertilizing:
        return Icons.eco;
      case CareType.misting:
        return Icons.shower;
      case CareType.repotting:
        return Icons.yard;
      case CareType.inspection:
        return Icons.search;
      case CareType.rotation:
        return Icons.rotate_right;
      case CareType.cleaning:
        return Icons.cleaning_services;
      case CareType.custom:
        return Icons.edit_note;
    }
  }

  /// Default interval in days for this care type
  int get defaultIntervalDays {
    switch (this) {
      case CareType.watering:
        return 7;
      case CareType.fertilizing:
        return 30;
      case CareType.misting:
        return 3;
      case CareType.repotting:
        return 365; // Once a year
      case CareType.inspection:
        return 7;
      case CareType.rotation:
        return 7;
      case CareType.cleaning:
        return 14;
      case CareType.custom:
        return 7;
    }
  }

  /// Default instructions hint
  String get defaultInstructions {
    switch (this) {
      case CareType.watering:
        return 'Water when top inch of bark is dry. Use room temperature water.';
      case CareType.fertilizing:
        return 'Use orchid fertilizer at half strength. "Weekly, weakly"';
      case CareType.misting:
        return 'Mist leaves and aerial roots in the morning.';
      case CareType.repotting:
        return 'Repot when roots overflow pot or medium breaks down.';
      case CareType.inspection:
        return 'Check leaves, roots, and medium for problems.';
      case CareType.rotation:
        return 'Rotate 90° for even light exposure.';
      case CareType.cleaning:
        return 'Wipe leaves gently with damp cloth.';
      case CareType.custom:
        return '';
    }
  }
}
