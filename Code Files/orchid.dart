// lib/models/orchid.dart
// OrchidLife - Orchid data model

import 'package:isar/isar.dart';

part 'orchid.g.dart';

@collection
class Orchid {
  Id id = Isar.autoIncrement;

  @Index()
  late String name; // "Kitchen Window Orchid"

  String? nickname; // "Rosie"

  @Enumerated(EnumType.name)
  late OrchidVariety variety;

  String? photoPath; // Local photo path

  @Index()
  late String colorTag; // Hex color for visual organization

  String? location; // "Living room windowsill"

  DateTime? purchaseDate;

  DateTime? lastBloomDate;

  @Enumerated(EnumType.name)
  late BloomStatus bloomStatus;

  String? notes;

  @Index()
  late bool isActive; // Archive without deleting

  late DateTime createdAt;

  // Constructor
  Orchid({
    this.id = Isar.autoIncrement,
    required this.name,
    this.nickname,
    this.variety = OrchidVariety.phalaenopsis,
    this.photoPath,
    this.colorTag = '#4CAF50',
    this.location,
    this.purchaseDate,
    this.lastBloomDate,
    this.bloomStatus = BloomStatus.resting,
    this.notes,
    this.isActive = true,
  }) {
    createdAt = DateTime.now();
  }

  // Validation
  String? validate() {
    if (name.trim().isEmpty) {
      return 'Orchid name is required';
    }
    if (name.length > 50) {
      return 'Name must be 50 characters or less';
    }
    return null;
  }

  // Display name (nickname or name)
  @ignore
  String get displayName => nickname?.isNotEmpty == true ? nickname! : name;

  // Copy with
  Orchid copyWith({
    Id? id,
    String? name,
    String? nickname,
    OrchidVariety? variety,
    String? photoPath,
    String? colorTag,
    String? location,
    DateTime? purchaseDate,
    DateTime? lastBloomDate,
    BloomStatus? bloomStatus,
    String? notes,
    bool? isActive,
    DateTime? createdAt,
  }) {
    final copy = Orchid(
      id: id ?? this.id,
      name: name ?? this.name,
      nickname: nickname ?? this.nickname,
      variety: variety ?? this.variety,
      photoPath: photoPath ?? this.photoPath,
      colorTag: colorTag ?? this.colorTag,
      location: location ?? this.location,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      lastBloomDate: lastBloomDate ?? this.lastBloomDate,
      bloomStatus: bloomStatus ?? this.bloomStatus,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
    );
    copy.createdAt = createdAt ?? this.createdAt;
    return copy;
  }
}

/// Orchid variety/species
enum OrchidVariety {
  phalaenopsis, // Most common, "moth orchid"
  dendrobium,
  cattleya,
  oncidium,
  vanda,
  paphiopedilum, // "Slipper orchid"
  miltonia,
  cymbidium,
  zygopetalum,
  other,
}

/// Bloom status
enum BloomStatus {
  blooming, // Currently has flowers
  budding, // Has buds forming
  spiking, // Flower spike growing
  resting, // No blooms, normal growth
  dormant, // Minimal growth period
}

/// Extension for OrchidVariety
extension OrchidVarietyExtension on OrchidVariety {
  String get displayName {
    switch (this) {
      case OrchidVariety.phalaenopsis:
        return 'Phalaenopsis';
      case OrchidVariety.dendrobium:
        return 'Dendrobium';
      case OrchidVariety.cattleya:
        return 'Cattleya';
      case OrchidVariety.oncidium:
        return 'Oncidium';
      case OrchidVariety.vanda:
        return 'Vanda';
      case OrchidVariety.paphiopedilum:
        return 'Paphiopedilum';
      case OrchidVariety.miltonia:
        return 'Miltonia';
      case OrchidVariety.cymbidium:
        return 'Cymbidium';
      case OrchidVariety.zygopetalum:
        return 'Zygopetalum';
      case OrchidVariety.other:
        return 'Other';
    }
  }

  String get commonName {
    switch (this) {
      case OrchidVariety.phalaenopsis:
        return 'Moth Orchid';
      case OrchidVariety.dendrobium:
        return 'Dendrobium';
      case OrchidVariety.cattleya:
        return 'Corsage Orchid';
      case OrchidVariety.oncidium:
        return 'Dancing Lady';
      case OrchidVariety.vanda:
        return 'Vanda';
      case OrchidVariety.paphiopedilum:
        return 'Slipper Orchid';
      case OrchidVariety.miltonia:
        return 'Pansy Orchid';
      case OrchidVariety.cymbidium:
        return 'Boat Orchid';
      case OrchidVariety.zygopetalum:
        return 'Zygo';
      case OrchidVariety.other:
        return 'Orchid';
    }
  }

  /// Default watering interval in days
  int get defaultWateringDays {
    switch (this) {
      case OrchidVariety.phalaenopsis:
        return 7;
      case OrchidVariety.dendrobium:
        return 5;
      case OrchidVariety.cattleya:
        return 7;
      case OrchidVariety.oncidium:
        return 5;
      case OrchidVariety.vanda:
        return 2; // High maintenance!
      case OrchidVariety.paphiopedilum:
        return 5;
      case OrchidVariety.miltonia:
        return 5;
      case OrchidVariety.cymbidium:
        return 7;
      case OrchidVariety.zygopetalum:
        return 5;
      case OrchidVariety.other:
        return 7;
    }
  }

  /// Ideal light level description
  String get lightNeeds {
    switch (this) {
      case OrchidVariety.phalaenopsis:
        return 'Low to medium (1000-2000 lux)';
      case OrchidVariety.dendrobium:
        return 'Bright indirect (2000-3000 lux)';
      case OrchidVariety.cattleya:
        return 'Bright (2500-3500 lux)';
      case OrchidVariety.oncidium:
        return 'Bright indirect (2000-3000 lux)';
      case OrchidVariety.vanda:
        return 'Very bright (3000-5000 lux)';
      case OrchidVariety.paphiopedilum:
        return 'Low (500-1500 lux)';
      case OrchidVariety.miltonia:
        return 'Medium (1500-2500 lux)';
      case OrchidVariety.cymbidium:
        return 'Bright (2500-4000 lux)';
      case OrchidVariety.zygopetalum:
        return 'Medium (1500-2500 lux)';
      case OrchidVariety.other:
        return 'Medium (1500-2500 lux)';
    }
  }
}

/// Extension for BloomStatus
extension BloomStatusExtension on BloomStatus {
  String get displayName {
    switch (this) {
      case BloomStatus.blooming:
        return 'Blooming 🌸';
      case BloomStatus.budding:
        return 'Budding';
      case BloomStatus.spiking:
        return 'Spiking';
      case BloomStatus.resting:
        return 'Resting';
      case BloomStatus.dormant:
        return 'Dormant';
    }
  }

  String get emoji {
    switch (this) {
      case BloomStatus.blooming:
        return '🌸';
      case BloomStatus.budding:
        return '🌱';
      case BloomStatus.spiking:
        return '📈';
      case BloomStatus.resting:
        return '😴';
      case BloomStatus.dormant:
        return '💤';
    }
  }
}
