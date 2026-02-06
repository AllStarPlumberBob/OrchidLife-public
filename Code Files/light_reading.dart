// lib/models/light_reading.dart
// OrchidLife - Light reading data model for lux meter

import 'package:isar/isar.dart';

part 'light_reading.g.dart';

@collection
class LightReading {
  Id id = Isar.autoIncrement;

  @Index()
  int? orchidId; // Optional - can take general readings

  String? locationName; // "Kitchen window", "Bathroom shelf"

  late int luxValue; // Raw lux reading

  @Enumerated(EnumType.name)
  late LightLevel level; // Calculated category

  late DateTime readingTime;

  String? notes;

  // Constructor
  LightReading({
    this.id = Isar.autoIncrement,
    this.orchidId,
    this.locationName,
    required this.luxValue,
    this.notes,
  }) {
    readingTime = DateTime.now();
    level = LightLevel.fromLux(luxValue);
  }

  /// Get recommendation based on reading
  @ignore
  String get recommendation {
    return level.recommendation;
  }

  /// Is this reading good for a specific variety?
  bool isGoodFor(String variety) {
    // Simplified logic - can be expanded
    switch (variety.toLowerCase()) {
      case 'phalaenopsis':
        return luxValue >= 1000 && luxValue <= 2500;
      case 'dendrobium':
      case 'cattleya':
      case 'oncidium':
        return luxValue >= 2000 && luxValue <= 4000;
      case 'vanda':
        return luxValue >= 3000 && luxValue <= 5000;
      case 'paphiopedilum':
        return luxValue >= 500 && luxValue <= 1500;
      default:
        return luxValue >= 1500 && luxValue <= 3000;
    }
  }
}

/// Light level categories
enum LightLevel {
  veryLow,
  low,
  medium,
  bright,
  veryBright,
  direct,
}

/// Extension for LightLevel
extension LightLevelExtension on LightLevel {
  String get displayName {
    switch (this) {
      case LightLevel.veryLow:
        return 'Very Low';
      case LightLevel.low:
        return 'Low';
      case LightLevel.medium:
        return 'Medium';
      case LightLevel.bright:
        return 'Bright Indirect';
      case LightLevel.veryBright:
        return 'Very Bright';
      case LightLevel.direct:
        return 'Direct Sun';
    }
  }

  String get emoji {
    switch (this) {
      case LightLevel.veryLow:
        return '🌑';
      case LightLevel.low:
        return '🌘';
      case LightLevel.medium:
        return '🌤️';
      case LightLevel.bright:
        return '☀️';
      case LightLevel.veryBright:
        return '🌞';
      case LightLevel.direct:
        return '🔥';
    }
  }

  /// Lux range description
  String get luxRange {
    switch (this) {
      case LightLevel.veryLow:
        return '0-200 lux';
      case LightLevel.low:
        return '200-500 lux';
      case LightLevel.medium:
        return '500-1,500 lux';
      case LightLevel.bright:
        return '1,500-3,000 lux';
      case LightLevel.veryBright:
        return '3,000-5,000 lux';
      case LightLevel.direct:
        return '5,000+ lux';
    }
  }

  /// Recommendation text
  String get recommendation {
    switch (this) {
      case LightLevel.veryLow:
        return 'Too dark for most orchids. Move closer to a window.';
      case LightLevel.low:
        return 'Only suitable for low-light orchids like Paphiopedilum.';
      case LightLevel.medium:
        return 'Good for Phalaenopsis and Miltonia.';
      case LightLevel.bright:
        return 'Perfect for most orchids! Great spot.';
      case LightLevel.veryBright:
        return 'Great for Dendrobium, Cattleya, Oncidium, and Vanda.';
      case LightLevel.direct:
        return 'Caution! May burn leaves. Use sheer curtain or move back.';
    }
  }

  /// Good varieties for this light level
  List<String> get goodForVarieties {
    switch (this) {
      case LightLevel.veryLow:
        return ['Jewel Orchids (not ideal for most)'];
      case LightLevel.low:
        return ['Paphiopedilum', 'Phalaenopsis (minimum)'];
      case LightLevel.medium:
        return ['Phalaenopsis', 'Miltonia', 'Zygopetalum'];
      case LightLevel.bright:
        return ['Phalaenopsis', 'Dendrobium', 'Oncidium', 'Cattleya'];
      case LightLevel.veryBright:
        return ['Dendrobium', 'Cattleya', 'Oncidium', 'Vanda', 'Cymbidium'];
      case LightLevel.direct:
        return ['Vanda (with care)', 'Some Cymbidiums'];
    }
  }

  /// Color for UI
  String get colorHex {
    switch (this) {
      case LightLevel.veryLow:
        return '#37474F'; // Dark blue-gray
      case LightLevel.low:
        return '#607D8B'; // Blue-gray
      case LightLevel.medium:
        return '#81C784'; // Light green
      case LightLevel.bright:
        return '#4CAF50'; // Green
      case LightLevel.veryBright:
        return '#FFC107'; // Amber
      case LightLevel.direct:
        return '#FF5722'; // Deep orange (warning)
    }
  }

  /// Create LightLevel from lux value
  static LightLevel fromLux(int lux) {
    if (lux < 200) return LightLevel.veryLow;
    if (lux < 500) return LightLevel.low;
    if (lux < 1500) return LightLevel.medium;
    if (lux < 3000) return LightLevel.bright;
    if (lux < 5000) return LightLevel.veryBright;
    return LightLevel.direct;
  }
}
