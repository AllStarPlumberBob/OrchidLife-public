// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $OrchidsTable extends Orchids with TableInfo<$OrchidsTable, Orchid> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrchidsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _varietyMeta =
      const VerificationMeta('variety');
  @override
  late final GeneratedColumn<String> variety = GeneratedColumn<String>(
      'variety', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _locationMeta =
      const VerificationMeta('location');
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
      'location', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _photoPathMeta =
      const VerificationMeta('photoPath');
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
      'photo_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dateAcquiredMeta =
      const VerificationMeta('dateAcquired');
  @override
  late final GeneratedColumn<DateTime> dateAcquired = GeneratedColumn<DateTime>(
      'date_acquired', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _isDemoMeta = const VerificationMeta('isDemo');
  @override
  late final GeneratedColumn<bool> isDemo = GeneratedColumn<bool>(
      'is_demo', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_demo" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _soakDurationMinutesMeta =
      const VerificationMeta('soakDurationMinutes');
  @override
  late final GeneratedColumn<int> soakDurationMinutes = GeneratedColumn<int>(
      'soak_duration_minutes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(15));
  static const VerificationMeta _currentBloomStageMeta =
      const VerificationMeta('currentBloomStage');
  @override
  late final GeneratedColumnWithTypeConverter<BloomStage?, String>
      currentBloomStage = GeneratedColumn<String>(
              'current_bloom_stage', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<BloomStage?>(
              $OrchidsTable.$convertercurrentBloomStagen);
  static const VerificationMeta _lastPottedMeta =
      const VerificationMeta('lastPotted');
  @override
  late final GeneratedColumn<DateTime> lastPotted = GeneratedColumn<DateTime>(
      'last_potted', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isRescueMeta =
      const VerificationMeta('isRescue');
  @override
  late final GeneratedColumn<bool> isRescue = GeneratedColumn<bool>(
      'is_rescue', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_rescue" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _speciesProfileIdMeta =
      const VerificationMeta('speciesProfileId');
  @override
  late final GeneratedColumn<int> speciesProfileId = GeneratedColumn<int>(
      'species_profile_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _growingLocationIdMeta =
      const VerificationMeta('growingLocationId');
  @override
  late final GeneratedColumn<int> growingLocationId = GeneratedColumn<int>(
      'growing_location_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        variety,
        location,
        photoPath,
        notes,
        dateAcquired,
        createdAt,
        isDemo,
        soakDurationMinutes,
        currentBloomStage,
        lastPotted,
        isRescue,
        speciesProfileId,
        growingLocationId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'orchids';
  @override
  VerificationContext validateIntegrity(Insertable<Orchid> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('variety')) {
      context.handle(_varietyMeta,
          variety.isAcceptableOrUnknown(data['variety']!, _varietyMeta));
    }
    if (data.containsKey('location')) {
      context.handle(_locationMeta,
          location.isAcceptableOrUnknown(data['location']!, _locationMeta));
    }
    if (data.containsKey('photo_path')) {
      context.handle(_photoPathMeta,
          photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('date_acquired')) {
      context.handle(
          _dateAcquiredMeta,
          dateAcquired.isAcceptableOrUnknown(
              data['date_acquired']!, _dateAcquiredMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('is_demo')) {
      context.handle(_isDemoMeta,
          isDemo.isAcceptableOrUnknown(data['is_demo']!, _isDemoMeta));
    }
    if (data.containsKey('soak_duration_minutes')) {
      context.handle(
          _soakDurationMinutesMeta,
          soakDurationMinutes.isAcceptableOrUnknown(
              data['soak_duration_minutes']!, _soakDurationMinutesMeta));
    }
    context.handle(_currentBloomStageMeta, const VerificationResult.success());
    if (data.containsKey('last_potted')) {
      context.handle(
          _lastPottedMeta,
          lastPotted.isAcceptableOrUnknown(
              data['last_potted']!, _lastPottedMeta));
    }
    if (data.containsKey('is_rescue')) {
      context.handle(_isRescueMeta,
          isRescue.isAcceptableOrUnknown(data['is_rescue']!, _isRescueMeta));
    }
    if (data.containsKey('species_profile_id')) {
      context.handle(
          _speciesProfileIdMeta,
          speciesProfileId.isAcceptableOrUnknown(
              data['species_profile_id']!, _speciesProfileIdMeta));
    }
    if (data.containsKey('growing_location_id')) {
      context.handle(
          _growingLocationIdMeta,
          growingLocationId.isAcceptableOrUnknown(
              data['growing_location_id']!, _growingLocationIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Orchid map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Orchid(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      variety: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}variety']),
      location: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location']),
      photoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo_path']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      dateAcquired: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_acquired']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      isDemo: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_demo'])!,
      soakDurationMinutes: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}soak_duration_minutes'])!,
      currentBloomStage: $OrchidsTable.$convertercurrentBloomStagen.fromSql(
          attachedDatabase.typeMapping.read(DriftSqlType.string,
              data['${effectivePrefix}current_bloom_stage'])),
      lastPotted: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_potted']),
      isRescue: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_rescue'])!,
      speciesProfileId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}species_profile_id']),
      growingLocationId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}growing_location_id']),
    );
  }

  @override
  $OrchidsTable createAlias(String alias) {
    return $OrchidsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<BloomStage, String, String>
      $convertercurrentBloomStage =
      const EnumNameConverter<BloomStage>(BloomStage.values);
  static JsonTypeConverter2<BloomStage?, String?, String?>
      $convertercurrentBloomStagen =
      JsonTypeConverter2.asNullable($convertercurrentBloomStage);
}

class Orchid extends DataClass implements Insertable<Orchid> {
  final int id;
  final String name;
  final String? variety;
  final String? location;
  final String? photoPath;
  final String? notes;
  final DateTime? dateAcquired;
  final DateTime createdAt;
  final bool isDemo;
  final int soakDurationMinutes;
  final BloomStage? currentBloomStage;
  final DateTime? lastPotted;
  final bool isRescue;
  final int? speciesProfileId;
  final int? growingLocationId;
  const Orchid(
      {required this.id,
      required this.name,
      this.variety,
      this.location,
      this.photoPath,
      this.notes,
      this.dateAcquired,
      required this.createdAt,
      required this.isDemo,
      required this.soakDurationMinutes,
      this.currentBloomStage,
      this.lastPotted,
      required this.isRescue,
      this.speciesProfileId,
      this.growingLocationId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || variety != null) {
      map['variety'] = Variable<String>(variety);
    }
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || dateAcquired != null) {
      map['date_acquired'] = Variable<DateTime>(dateAcquired);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_demo'] = Variable<bool>(isDemo);
    map['soak_duration_minutes'] = Variable<int>(soakDurationMinutes);
    if (!nullToAbsent || currentBloomStage != null) {
      map['current_bloom_stage'] = Variable<String>(
          $OrchidsTable.$convertercurrentBloomStagen.toSql(currentBloomStage));
    }
    if (!nullToAbsent || lastPotted != null) {
      map['last_potted'] = Variable<DateTime>(lastPotted);
    }
    map['is_rescue'] = Variable<bool>(isRescue);
    if (!nullToAbsent || speciesProfileId != null) {
      map['species_profile_id'] = Variable<int>(speciesProfileId);
    }
    if (!nullToAbsent || growingLocationId != null) {
      map['growing_location_id'] = Variable<int>(growingLocationId);
    }
    return map;
  }

  OrchidsCompanion toCompanion(bool nullToAbsent) {
    return OrchidsCompanion(
      id: Value(id),
      name: Value(name),
      variety: variety == null && nullToAbsent
          ? const Value.absent()
          : Value(variety),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      dateAcquired: dateAcquired == null && nullToAbsent
          ? const Value.absent()
          : Value(dateAcquired),
      createdAt: Value(createdAt),
      isDemo: Value(isDemo),
      soakDurationMinutes: Value(soakDurationMinutes),
      currentBloomStage: currentBloomStage == null && nullToAbsent
          ? const Value.absent()
          : Value(currentBloomStage),
      lastPotted: lastPotted == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPotted),
      isRescue: Value(isRescue),
      speciesProfileId: speciesProfileId == null && nullToAbsent
          ? const Value.absent()
          : Value(speciesProfileId),
      growingLocationId: growingLocationId == null && nullToAbsent
          ? const Value.absent()
          : Value(growingLocationId),
    );
  }

  factory Orchid.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Orchid(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      variety: serializer.fromJson<String?>(json['variety']),
      location: serializer.fromJson<String?>(json['location']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      notes: serializer.fromJson<String?>(json['notes']),
      dateAcquired: serializer.fromJson<DateTime?>(json['dateAcquired']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isDemo: serializer.fromJson<bool>(json['isDemo']),
      soakDurationMinutes:
          serializer.fromJson<int>(json['soakDurationMinutes']),
      currentBloomStage: $OrchidsTable.$convertercurrentBloomStagen
          .fromJson(serializer.fromJson<String?>(json['currentBloomStage'])),
      lastPotted: serializer.fromJson<DateTime?>(json['lastPotted']),
      isRescue: serializer.fromJson<bool>(json['isRescue']),
      speciesProfileId: serializer.fromJson<int?>(json['speciesProfileId']),
      growingLocationId: serializer.fromJson<int?>(json['growingLocationId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'variety': serializer.toJson<String?>(variety),
      'location': serializer.toJson<String?>(location),
      'photoPath': serializer.toJson<String?>(photoPath),
      'notes': serializer.toJson<String?>(notes),
      'dateAcquired': serializer.toJson<DateTime?>(dateAcquired),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isDemo': serializer.toJson<bool>(isDemo),
      'soakDurationMinutes': serializer.toJson<int>(soakDurationMinutes),
      'currentBloomStage': serializer.toJson<String?>(
          $OrchidsTable.$convertercurrentBloomStagen.toJson(currentBloomStage)),
      'lastPotted': serializer.toJson<DateTime?>(lastPotted),
      'isRescue': serializer.toJson<bool>(isRescue),
      'speciesProfileId': serializer.toJson<int?>(speciesProfileId),
      'growingLocationId': serializer.toJson<int?>(growingLocationId),
    };
  }

  Orchid copyWith(
          {int? id,
          String? name,
          Value<String?> variety = const Value.absent(),
          Value<String?> location = const Value.absent(),
          Value<String?> photoPath = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          Value<DateTime?> dateAcquired = const Value.absent(),
          DateTime? createdAt,
          bool? isDemo,
          int? soakDurationMinutes,
          Value<BloomStage?> currentBloomStage = const Value.absent(),
          Value<DateTime?> lastPotted = const Value.absent(),
          bool? isRescue,
          Value<int?> speciesProfileId = const Value.absent(),
          Value<int?> growingLocationId = const Value.absent()}) =>
      Orchid(
        id: id ?? this.id,
        name: name ?? this.name,
        variety: variety.present ? variety.value : this.variety,
        location: location.present ? location.value : this.location,
        photoPath: photoPath.present ? photoPath.value : this.photoPath,
        notes: notes.present ? notes.value : this.notes,
        dateAcquired:
            dateAcquired.present ? dateAcquired.value : this.dateAcquired,
        createdAt: createdAt ?? this.createdAt,
        isDemo: isDemo ?? this.isDemo,
        soakDurationMinutes: soakDurationMinutes ?? this.soakDurationMinutes,
        currentBloomStage: currentBloomStage.present
            ? currentBloomStage.value
            : this.currentBloomStage,
        lastPotted: lastPotted.present ? lastPotted.value : this.lastPotted,
        isRescue: isRescue ?? this.isRescue,
        speciesProfileId: speciesProfileId.present
            ? speciesProfileId.value
            : this.speciesProfileId,
        growingLocationId: growingLocationId.present
            ? growingLocationId.value
            : this.growingLocationId,
      );
  @override
  String toString() {
    return (StringBuffer('Orchid(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('variety: $variety, ')
          ..write('location: $location, ')
          ..write('photoPath: $photoPath, ')
          ..write('notes: $notes, ')
          ..write('dateAcquired: $dateAcquired, ')
          ..write('createdAt: $createdAt, ')
          ..write('isDemo: $isDemo, ')
          ..write('soakDurationMinutes: $soakDurationMinutes, ')
          ..write('currentBloomStage: $currentBloomStage, ')
          ..write('lastPotted: $lastPotted, ')
          ..write('isRescue: $isRescue, ')
          ..write('speciesProfileId: $speciesProfileId, ')
          ..write('growingLocationId: $growingLocationId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      variety,
      location,
      photoPath,
      notes,
      dateAcquired,
      createdAt,
      isDemo,
      soakDurationMinutes,
      currentBloomStage,
      lastPotted,
      isRescue,
      speciesProfileId,
      growingLocationId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Orchid &&
          other.id == this.id &&
          other.name == this.name &&
          other.variety == this.variety &&
          other.location == this.location &&
          other.photoPath == this.photoPath &&
          other.notes == this.notes &&
          other.dateAcquired == this.dateAcquired &&
          other.createdAt == this.createdAt &&
          other.isDemo == this.isDemo &&
          other.soakDurationMinutes == this.soakDurationMinutes &&
          other.currentBloomStage == this.currentBloomStage &&
          other.lastPotted == this.lastPotted &&
          other.isRescue == this.isRescue &&
          other.speciesProfileId == this.speciesProfileId &&
          other.growingLocationId == this.growingLocationId);
}

class OrchidsCompanion extends UpdateCompanion<Orchid> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> variety;
  final Value<String?> location;
  final Value<String?> photoPath;
  final Value<String?> notes;
  final Value<DateTime?> dateAcquired;
  final Value<DateTime> createdAt;
  final Value<bool> isDemo;
  final Value<int> soakDurationMinutes;
  final Value<BloomStage?> currentBloomStage;
  final Value<DateTime?> lastPotted;
  final Value<bool> isRescue;
  final Value<int?> speciesProfileId;
  final Value<int?> growingLocationId;
  const OrchidsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.variety = const Value.absent(),
    this.location = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.notes = const Value.absent(),
    this.dateAcquired = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isDemo = const Value.absent(),
    this.soakDurationMinutes = const Value.absent(),
    this.currentBloomStage = const Value.absent(),
    this.lastPotted = const Value.absent(),
    this.isRescue = const Value.absent(),
    this.speciesProfileId = const Value.absent(),
    this.growingLocationId = const Value.absent(),
  });
  OrchidsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.variety = const Value.absent(),
    this.location = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.notes = const Value.absent(),
    this.dateAcquired = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isDemo = const Value.absent(),
    this.soakDurationMinutes = const Value.absent(),
    this.currentBloomStage = const Value.absent(),
    this.lastPotted = const Value.absent(),
    this.isRescue = const Value.absent(),
    this.speciesProfileId = const Value.absent(),
    this.growingLocationId = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Orchid> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? variety,
    Expression<String>? location,
    Expression<String>? photoPath,
    Expression<String>? notes,
    Expression<DateTime>? dateAcquired,
    Expression<DateTime>? createdAt,
    Expression<bool>? isDemo,
    Expression<int>? soakDurationMinutes,
    Expression<String>? currentBloomStage,
    Expression<DateTime>? lastPotted,
    Expression<bool>? isRescue,
    Expression<int>? speciesProfileId,
    Expression<int>? growingLocationId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (variety != null) 'variety': variety,
      if (location != null) 'location': location,
      if (photoPath != null) 'photo_path': photoPath,
      if (notes != null) 'notes': notes,
      if (dateAcquired != null) 'date_acquired': dateAcquired,
      if (createdAt != null) 'created_at': createdAt,
      if (isDemo != null) 'is_demo': isDemo,
      if (soakDurationMinutes != null)
        'soak_duration_minutes': soakDurationMinutes,
      if (currentBloomStage != null) 'current_bloom_stage': currentBloomStage,
      if (lastPotted != null) 'last_potted': lastPotted,
      if (isRescue != null) 'is_rescue': isRescue,
      if (speciesProfileId != null) 'species_profile_id': speciesProfileId,
      if (growingLocationId != null) 'growing_location_id': growingLocationId,
    });
  }

  OrchidsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? variety,
      Value<String?>? location,
      Value<String?>? photoPath,
      Value<String?>? notes,
      Value<DateTime?>? dateAcquired,
      Value<DateTime>? createdAt,
      Value<bool>? isDemo,
      Value<int>? soakDurationMinutes,
      Value<BloomStage?>? currentBloomStage,
      Value<DateTime?>? lastPotted,
      Value<bool>? isRescue,
      Value<int?>? speciesProfileId,
      Value<int?>? growingLocationId}) {
    return OrchidsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      variety: variety ?? this.variety,
      location: location ?? this.location,
      photoPath: photoPath ?? this.photoPath,
      notes: notes ?? this.notes,
      dateAcquired: dateAcquired ?? this.dateAcquired,
      createdAt: createdAt ?? this.createdAt,
      isDemo: isDemo ?? this.isDemo,
      soakDurationMinutes: soakDurationMinutes ?? this.soakDurationMinutes,
      currentBloomStage: currentBloomStage ?? this.currentBloomStage,
      lastPotted: lastPotted ?? this.lastPotted,
      isRescue: isRescue ?? this.isRescue,
      speciesProfileId: speciesProfileId ?? this.speciesProfileId,
      growingLocationId: growingLocationId ?? this.growingLocationId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (variety.present) {
      map['variety'] = Variable<String>(variety.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (dateAcquired.present) {
      map['date_acquired'] = Variable<DateTime>(dateAcquired.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isDemo.present) {
      map['is_demo'] = Variable<bool>(isDemo.value);
    }
    if (soakDurationMinutes.present) {
      map['soak_duration_minutes'] = Variable<int>(soakDurationMinutes.value);
    }
    if (currentBloomStage.present) {
      map['current_bloom_stage'] = Variable<String>($OrchidsTable
          .$convertercurrentBloomStagen
          .toSql(currentBloomStage.value));
    }
    if (lastPotted.present) {
      map['last_potted'] = Variable<DateTime>(lastPotted.value);
    }
    if (isRescue.present) {
      map['is_rescue'] = Variable<bool>(isRescue.value);
    }
    if (speciesProfileId.present) {
      map['species_profile_id'] = Variable<int>(speciesProfileId.value);
    }
    if (growingLocationId.present) {
      map['growing_location_id'] = Variable<int>(growingLocationId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrchidsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('variety: $variety, ')
          ..write('location: $location, ')
          ..write('photoPath: $photoPath, ')
          ..write('notes: $notes, ')
          ..write('dateAcquired: $dateAcquired, ')
          ..write('createdAt: $createdAt, ')
          ..write('isDemo: $isDemo, ')
          ..write('soakDurationMinutes: $soakDurationMinutes, ')
          ..write('currentBloomStage: $currentBloomStage, ')
          ..write('lastPotted: $lastPotted, ')
          ..write('isRescue: $isRescue, ')
          ..write('speciesProfileId: $speciesProfileId, ')
          ..write('growingLocationId: $growingLocationId')
          ..write(')'))
        .toString();
  }
}

class $CareTasksTable extends CareTasks
    with TableInfo<$CareTasksTable, CareTask> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CareTasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _orchidIdMeta =
      const VerificationMeta('orchidId');
  @override
  late final GeneratedColumn<int> orchidId = GeneratedColumn<int>(
      'orchid_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES orchids (id)'));
  static const VerificationMeta _careTypeMeta =
      const VerificationMeta('careType');
  @override
  late final GeneratedColumnWithTypeConverter<CareType, String> careType =
      GeneratedColumn<String>('care_type', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<CareType>($CareTasksTable.$convertercareType);
  static const VerificationMeta _intervalDaysMeta =
      const VerificationMeta('intervalDays');
  @override
  late final GeneratedColumn<int> intervalDays = GeneratedColumn<int>(
      'interval_days', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _lastCompletedMeta =
      const VerificationMeta('lastCompleted');
  @override
  late final GeneratedColumn<DateTime> lastCompleted =
      GeneratedColumn<DateTime>('last_completed', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _nextDueMeta =
      const VerificationMeta('nextDue');
  @override
  late final GeneratedColumn<DateTime> nextDue = GeneratedColumn<DateTime>(
      'next_due', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _enabledMeta =
      const VerificationMeta('enabled');
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
      'enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _customLabelMeta =
      const VerificationMeta('customLabel');
  @override
  late final GeneratedColumn<String> customLabel = GeneratedColumn<String>(
      'custom_label', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notifyHourMeta =
      const VerificationMeta('notifyHour');
  @override
  late final GeneratedColumn<int> notifyHour = GeneratedColumn<int>(
      'notify_hour', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(9));
  static const VerificationMeta _notifyMinuteMeta =
      const VerificationMeta('notifyMinute');
  @override
  late final GeneratedColumn<int> notifyMinute = GeneratedColumn<int>(
      'notify_minute', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        orchidId,
        careType,
        intervalDays,
        lastCompleted,
        nextDue,
        enabled,
        customLabel,
        notifyHour,
        notifyMinute
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'care_tasks';
  @override
  VerificationContext validateIntegrity(Insertable<CareTask> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('orchid_id')) {
      context.handle(_orchidIdMeta,
          orchidId.isAcceptableOrUnknown(data['orchid_id']!, _orchidIdMeta));
    } else if (isInserting) {
      context.missing(_orchidIdMeta);
    }
    context.handle(_careTypeMeta, const VerificationResult.success());
    if (data.containsKey('interval_days')) {
      context.handle(
          _intervalDaysMeta,
          intervalDays.isAcceptableOrUnknown(
              data['interval_days']!, _intervalDaysMeta));
    } else if (isInserting) {
      context.missing(_intervalDaysMeta);
    }
    if (data.containsKey('last_completed')) {
      context.handle(
          _lastCompletedMeta,
          lastCompleted.isAcceptableOrUnknown(
              data['last_completed']!, _lastCompletedMeta));
    }
    if (data.containsKey('next_due')) {
      context.handle(_nextDueMeta,
          nextDue.isAcceptableOrUnknown(data['next_due']!, _nextDueMeta));
    } else if (isInserting) {
      context.missing(_nextDueMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(_enabledMeta,
          enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta));
    }
    if (data.containsKey('custom_label')) {
      context.handle(
          _customLabelMeta,
          customLabel.isAcceptableOrUnknown(
              data['custom_label']!, _customLabelMeta));
    }
    if (data.containsKey('notify_hour')) {
      context.handle(
          _notifyHourMeta,
          notifyHour.isAcceptableOrUnknown(
              data['notify_hour']!, _notifyHourMeta));
    }
    if (data.containsKey('notify_minute')) {
      context.handle(
          _notifyMinuteMeta,
          notifyMinute.isAcceptableOrUnknown(
              data['notify_minute']!, _notifyMinuteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CareTask map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CareTask(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      orchidId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}orchid_id'])!,
      careType: $CareTasksTable.$convertercareType.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}care_type'])!),
      intervalDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}interval_days'])!,
      lastCompleted: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_completed']),
      nextDue: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}next_due'])!,
      enabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}enabled'])!,
      customLabel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}custom_label']),
      notifyHour: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}notify_hour'])!,
      notifyMinute: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}notify_minute'])!,
    );
  }

  @override
  $CareTasksTable createAlias(String alias) {
    return $CareTasksTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CareType, String, String> $convertercareType =
      const EnumNameConverter<CareType>(CareType.values);
}

class CareTask extends DataClass implements Insertable<CareTask> {
  final int id;
  final int orchidId;
  final CareType careType;
  final int intervalDays;
  final DateTime? lastCompleted;
  final DateTime nextDue;
  final bool enabled;
  final String? customLabel;
  final int notifyHour;
  final int notifyMinute;
  const CareTask(
      {required this.id,
      required this.orchidId,
      required this.careType,
      required this.intervalDays,
      this.lastCompleted,
      required this.nextDue,
      required this.enabled,
      this.customLabel,
      required this.notifyHour,
      required this.notifyMinute});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['orchid_id'] = Variable<int>(orchidId);
    {
      map['care_type'] =
          Variable<String>($CareTasksTable.$convertercareType.toSql(careType));
    }
    map['interval_days'] = Variable<int>(intervalDays);
    if (!nullToAbsent || lastCompleted != null) {
      map['last_completed'] = Variable<DateTime>(lastCompleted);
    }
    map['next_due'] = Variable<DateTime>(nextDue);
    map['enabled'] = Variable<bool>(enabled);
    if (!nullToAbsent || customLabel != null) {
      map['custom_label'] = Variable<String>(customLabel);
    }
    map['notify_hour'] = Variable<int>(notifyHour);
    map['notify_minute'] = Variable<int>(notifyMinute);
    return map;
  }

  CareTasksCompanion toCompanion(bool nullToAbsent) {
    return CareTasksCompanion(
      id: Value(id),
      orchidId: Value(orchidId),
      careType: Value(careType),
      intervalDays: Value(intervalDays),
      lastCompleted: lastCompleted == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCompleted),
      nextDue: Value(nextDue),
      enabled: Value(enabled),
      customLabel: customLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(customLabel),
      notifyHour: Value(notifyHour),
      notifyMinute: Value(notifyMinute),
    );
  }

  factory CareTask.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CareTask(
      id: serializer.fromJson<int>(json['id']),
      orchidId: serializer.fromJson<int>(json['orchidId']),
      careType: $CareTasksTable.$convertercareType
          .fromJson(serializer.fromJson<String>(json['careType'])),
      intervalDays: serializer.fromJson<int>(json['intervalDays']),
      lastCompleted: serializer.fromJson<DateTime?>(json['lastCompleted']),
      nextDue: serializer.fromJson<DateTime>(json['nextDue']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      customLabel: serializer.fromJson<String?>(json['customLabel']),
      notifyHour: serializer.fromJson<int>(json['notifyHour']),
      notifyMinute: serializer.fromJson<int>(json['notifyMinute']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orchidId': serializer.toJson<int>(orchidId),
      'careType': serializer
          .toJson<String>($CareTasksTable.$convertercareType.toJson(careType)),
      'intervalDays': serializer.toJson<int>(intervalDays),
      'lastCompleted': serializer.toJson<DateTime?>(lastCompleted),
      'nextDue': serializer.toJson<DateTime>(nextDue),
      'enabled': serializer.toJson<bool>(enabled),
      'customLabel': serializer.toJson<String?>(customLabel),
      'notifyHour': serializer.toJson<int>(notifyHour),
      'notifyMinute': serializer.toJson<int>(notifyMinute),
    };
  }

  CareTask copyWith(
          {int? id,
          int? orchidId,
          CareType? careType,
          int? intervalDays,
          Value<DateTime?> lastCompleted = const Value.absent(),
          DateTime? nextDue,
          bool? enabled,
          Value<String?> customLabel = const Value.absent(),
          int? notifyHour,
          int? notifyMinute}) =>
      CareTask(
        id: id ?? this.id,
        orchidId: orchidId ?? this.orchidId,
        careType: careType ?? this.careType,
        intervalDays: intervalDays ?? this.intervalDays,
        lastCompleted:
            lastCompleted.present ? lastCompleted.value : this.lastCompleted,
        nextDue: nextDue ?? this.nextDue,
        enabled: enabled ?? this.enabled,
        customLabel: customLabel.present ? customLabel.value : this.customLabel,
        notifyHour: notifyHour ?? this.notifyHour,
        notifyMinute: notifyMinute ?? this.notifyMinute,
      );
  @override
  String toString() {
    return (StringBuffer('CareTask(')
          ..write('id: $id, ')
          ..write('orchidId: $orchidId, ')
          ..write('careType: $careType, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('lastCompleted: $lastCompleted, ')
          ..write('nextDue: $nextDue, ')
          ..write('enabled: $enabled, ')
          ..write('customLabel: $customLabel, ')
          ..write('notifyHour: $notifyHour, ')
          ..write('notifyMinute: $notifyMinute')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, orchidId, careType, intervalDays,
      lastCompleted, nextDue, enabled, customLabel, notifyHour, notifyMinute);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CareTask &&
          other.id == this.id &&
          other.orchidId == this.orchidId &&
          other.careType == this.careType &&
          other.intervalDays == this.intervalDays &&
          other.lastCompleted == this.lastCompleted &&
          other.nextDue == this.nextDue &&
          other.enabled == this.enabled &&
          other.customLabel == this.customLabel &&
          other.notifyHour == this.notifyHour &&
          other.notifyMinute == this.notifyMinute);
}

class CareTasksCompanion extends UpdateCompanion<CareTask> {
  final Value<int> id;
  final Value<int> orchidId;
  final Value<CareType> careType;
  final Value<int> intervalDays;
  final Value<DateTime?> lastCompleted;
  final Value<DateTime> nextDue;
  final Value<bool> enabled;
  final Value<String?> customLabel;
  final Value<int> notifyHour;
  final Value<int> notifyMinute;
  const CareTasksCompanion({
    this.id = const Value.absent(),
    this.orchidId = const Value.absent(),
    this.careType = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.lastCompleted = const Value.absent(),
    this.nextDue = const Value.absent(),
    this.enabled = const Value.absent(),
    this.customLabel = const Value.absent(),
    this.notifyHour = const Value.absent(),
    this.notifyMinute = const Value.absent(),
  });
  CareTasksCompanion.insert({
    this.id = const Value.absent(),
    required int orchidId,
    required CareType careType,
    required int intervalDays,
    this.lastCompleted = const Value.absent(),
    required DateTime nextDue,
    this.enabled = const Value.absent(),
    this.customLabel = const Value.absent(),
    this.notifyHour = const Value.absent(),
    this.notifyMinute = const Value.absent(),
  })  : orchidId = Value(orchidId),
        careType = Value(careType),
        intervalDays = Value(intervalDays),
        nextDue = Value(nextDue);
  static Insertable<CareTask> custom({
    Expression<int>? id,
    Expression<int>? orchidId,
    Expression<String>? careType,
    Expression<int>? intervalDays,
    Expression<DateTime>? lastCompleted,
    Expression<DateTime>? nextDue,
    Expression<bool>? enabled,
    Expression<String>? customLabel,
    Expression<int>? notifyHour,
    Expression<int>? notifyMinute,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orchidId != null) 'orchid_id': orchidId,
      if (careType != null) 'care_type': careType,
      if (intervalDays != null) 'interval_days': intervalDays,
      if (lastCompleted != null) 'last_completed': lastCompleted,
      if (nextDue != null) 'next_due': nextDue,
      if (enabled != null) 'enabled': enabled,
      if (customLabel != null) 'custom_label': customLabel,
      if (notifyHour != null) 'notify_hour': notifyHour,
      if (notifyMinute != null) 'notify_minute': notifyMinute,
    });
  }

  CareTasksCompanion copyWith(
      {Value<int>? id,
      Value<int>? orchidId,
      Value<CareType>? careType,
      Value<int>? intervalDays,
      Value<DateTime?>? lastCompleted,
      Value<DateTime>? nextDue,
      Value<bool>? enabled,
      Value<String?>? customLabel,
      Value<int>? notifyHour,
      Value<int>? notifyMinute}) {
    return CareTasksCompanion(
      id: id ?? this.id,
      orchidId: orchidId ?? this.orchidId,
      careType: careType ?? this.careType,
      intervalDays: intervalDays ?? this.intervalDays,
      lastCompleted: lastCompleted ?? this.lastCompleted,
      nextDue: nextDue ?? this.nextDue,
      enabled: enabled ?? this.enabled,
      customLabel: customLabel ?? this.customLabel,
      notifyHour: notifyHour ?? this.notifyHour,
      notifyMinute: notifyMinute ?? this.notifyMinute,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orchidId.present) {
      map['orchid_id'] = Variable<int>(orchidId.value);
    }
    if (careType.present) {
      map['care_type'] = Variable<String>(
          $CareTasksTable.$convertercareType.toSql(careType.value));
    }
    if (intervalDays.present) {
      map['interval_days'] = Variable<int>(intervalDays.value);
    }
    if (lastCompleted.present) {
      map['last_completed'] = Variable<DateTime>(lastCompleted.value);
    }
    if (nextDue.present) {
      map['next_due'] = Variable<DateTime>(nextDue.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (customLabel.present) {
      map['custom_label'] = Variable<String>(customLabel.value);
    }
    if (notifyHour.present) {
      map['notify_hour'] = Variable<int>(notifyHour.value);
    }
    if (notifyMinute.present) {
      map['notify_minute'] = Variable<int>(notifyMinute.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CareTasksCompanion(')
          ..write('id: $id, ')
          ..write('orchidId: $orchidId, ')
          ..write('careType: $careType, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('lastCompleted: $lastCompleted, ')
          ..write('nextDue: $nextDue, ')
          ..write('enabled: $enabled, ')
          ..write('customLabel: $customLabel, ')
          ..write('notifyHour: $notifyHour, ')
          ..write('notifyMinute: $notifyMinute')
          ..write(')'))
        .toString();
  }
}

class $CareLogsTable extends CareLogs with TableInfo<$CareLogsTable, CareLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CareLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _orchidIdMeta =
      const VerificationMeta('orchidId');
  @override
  late final GeneratedColumn<int> orchidId = GeneratedColumn<int>(
      'orchid_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES orchids (id)'));
  static const VerificationMeta _careTaskIdMeta =
      const VerificationMeta('careTaskId');
  @override
  late final GeneratedColumn<int> careTaskId = GeneratedColumn<int>(
      'care_task_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES care_tasks (id)'));
  static const VerificationMeta _careTypeMeta =
      const VerificationMeta('careType');
  @override
  late final GeneratedColumnWithTypeConverter<CareType, String> careType =
      GeneratedColumn<String>('care_type', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<CareType>($CareLogsTable.$convertercareType);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _skippedMeta =
      const VerificationMeta('skipped');
  @override
  late final GeneratedColumn<bool> skipped = GeneratedColumn<bool>(
      'skipped', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("skipped" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, orchidId, careTaskId, careType, completedAt, notes, skipped];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'care_logs';
  @override
  VerificationContext validateIntegrity(Insertable<CareLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('orchid_id')) {
      context.handle(_orchidIdMeta,
          orchidId.isAcceptableOrUnknown(data['orchid_id']!, _orchidIdMeta));
    } else if (isInserting) {
      context.missing(_orchidIdMeta);
    }
    if (data.containsKey('care_task_id')) {
      context.handle(
          _careTaskIdMeta,
          careTaskId.isAcceptableOrUnknown(
              data['care_task_id']!, _careTaskIdMeta));
    }
    context.handle(_careTypeMeta, const VerificationResult.success());
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('skipped')) {
      context.handle(_skippedMeta,
          skipped.isAcceptableOrUnknown(data['skipped']!, _skippedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CareLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CareLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      orchidId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}orchid_id'])!,
      careTaskId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}care_task_id']),
      careType: $CareLogsTable.$convertercareType.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}care_type'])!),
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      skipped: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}skipped'])!,
    );
  }

  @override
  $CareLogsTable createAlias(String alias) {
    return $CareLogsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CareType, String, String> $convertercareType =
      const EnumNameConverter<CareType>(CareType.values);
}

class CareLog extends DataClass implements Insertable<CareLog> {
  final int id;
  final int orchidId;
  final int? careTaskId;
  final CareType careType;
  final DateTime completedAt;
  final String? notes;
  final bool skipped;
  const CareLog(
      {required this.id,
      required this.orchidId,
      this.careTaskId,
      required this.careType,
      required this.completedAt,
      this.notes,
      required this.skipped});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['orchid_id'] = Variable<int>(orchidId);
    if (!nullToAbsent || careTaskId != null) {
      map['care_task_id'] = Variable<int>(careTaskId);
    }
    {
      map['care_type'] =
          Variable<String>($CareLogsTable.$convertercareType.toSql(careType));
    }
    map['completed_at'] = Variable<DateTime>(completedAt);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['skipped'] = Variable<bool>(skipped);
    return map;
  }

  CareLogsCompanion toCompanion(bool nullToAbsent) {
    return CareLogsCompanion(
      id: Value(id),
      orchidId: Value(orchidId),
      careTaskId: careTaskId == null && nullToAbsent
          ? const Value.absent()
          : Value(careTaskId),
      careType: Value(careType),
      completedAt: Value(completedAt),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      skipped: Value(skipped),
    );
  }

  factory CareLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CareLog(
      id: serializer.fromJson<int>(json['id']),
      orchidId: serializer.fromJson<int>(json['orchidId']),
      careTaskId: serializer.fromJson<int?>(json['careTaskId']),
      careType: $CareLogsTable.$convertercareType
          .fromJson(serializer.fromJson<String>(json['careType'])),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
      skipped: serializer.fromJson<bool>(json['skipped']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orchidId': serializer.toJson<int>(orchidId),
      'careTaskId': serializer.toJson<int?>(careTaskId),
      'careType': serializer
          .toJson<String>($CareLogsTable.$convertercareType.toJson(careType)),
      'completedAt': serializer.toJson<DateTime>(completedAt),
      'notes': serializer.toJson<String?>(notes),
      'skipped': serializer.toJson<bool>(skipped),
    };
  }

  CareLog copyWith(
          {int? id,
          int? orchidId,
          Value<int?> careTaskId = const Value.absent(),
          CareType? careType,
          DateTime? completedAt,
          Value<String?> notes = const Value.absent(),
          bool? skipped}) =>
      CareLog(
        id: id ?? this.id,
        orchidId: orchidId ?? this.orchidId,
        careTaskId: careTaskId.present ? careTaskId.value : this.careTaskId,
        careType: careType ?? this.careType,
        completedAt: completedAt ?? this.completedAt,
        notes: notes.present ? notes.value : this.notes,
        skipped: skipped ?? this.skipped,
      );
  @override
  String toString() {
    return (StringBuffer('CareLog(')
          ..write('id: $id, ')
          ..write('orchidId: $orchidId, ')
          ..write('careTaskId: $careTaskId, ')
          ..write('careType: $careType, ')
          ..write('completedAt: $completedAt, ')
          ..write('notes: $notes, ')
          ..write('skipped: $skipped')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, orchidId, careTaskId, careType, completedAt, notes, skipped);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CareLog &&
          other.id == this.id &&
          other.orchidId == this.orchidId &&
          other.careTaskId == this.careTaskId &&
          other.careType == this.careType &&
          other.completedAt == this.completedAt &&
          other.notes == this.notes &&
          other.skipped == this.skipped);
}

class CareLogsCompanion extends UpdateCompanion<CareLog> {
  final Value<int> id;
  final Value<int> orchidId;
  final Value<int?> careTaskId;
  final Value<CareType> careType;
  final Value<DateTime> completedAt;
  final Value<String?> notes;
  final Value<bool> skipped;
  const CareLogsCompanion({
    this.id = const Value.absent(),
    this.orchidId = const Value.absent(),
    this.careTaskId = const Value.absent(),
    this.careType = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.skipped = const Value.absent(),
  });
  CareLogsCompanion.insert({
    this.id = const Value.absent(),
    required int orchidId,
    this.careTaskId = const Value.absent(),
    required CareType careType,
    required DateTime completedAt,
    this.notes = const Value.absent(),
    this.skipped = const Value.absent(),
  })  : orchidId = Value(orchidId),
        careType = Value(careType),
        completedAt = Value(completedAt);
  static Insertable<CareLog> custom({
    Expression<int>? id,
    Expression<int>? orchidId,
    Expression<int>? careTaskId,
    Expression<String>? careType,
    Expression<DateTime>? completedAt,
    Expression<String>? notes,
    Expression<bool>? skipped,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orchidId != null) 'orchid_id': orchidId,
      if (careTaskId != null) 'care_task_id': careTaskId,
      if (careType != null) 'care_type': careType,
      if (completedAt != null) 'completed_at': completedAt,
      if (notes != null) 'notes': notes,
      if (skipped != null) 'skipped': skipped,
    });
  }

  CareLogsCompanion copyWith(
      {Value<int>? id,
      Value<int>? orchidId,
      Value<int?>? careTaskId,
      Value<CareType>? careType,
      Value<DateTime>? completedAt,
      Value<String?>? notes,
      Value<bool>? skipped}) {
    return CareLogsCompanion(
      id: id ?? this.id,
      orchidId: orchidId ?? this.orchidId,
      careTaskId: careTaskId ?? this.careTaskId,
      careType: careType ?? this.careType,
      completedAt: completedAt ?? this.completedAt,
      notes: notes ?? this.notes,
      skipped: skipped ?? this.skipped,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orchidId.present) {
      map['orchid_id'] = Variable<int>(orchidId.value);
    }
    if (careTaskId.present) {
      map['care_task_id'] = Variable<int>(careTaskId.value);
    }
    if (careType.present) {
      map['care_type'] = Variable<String>(
          $CareLogsTable.$convertercareType.toSql(careType.value));
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (skipped.present) {
      map['skipped'] = Variable<bool>(skipped.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CareLogsCompanion(')
          ..write('id: $id, ')
          ..write('orchidId: $orchidId, ')
          ..write('careTaskId: $careTaskId, ')
          ..write('careType: $careType, ')
          ..write('completedAt: $completedAt, ')
          ..write('notes: $notes, ')
          ..write('skipped: $skipped')
          ..write(')'))
        .toString();
  }
}

class $LightReadingsTable extends LightReadings
    with TableInfo<$LightReadingsTable, LightReading> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LightReadingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _orchidIdMeta =
      const VerificationMeta('orchidId');
  @override
  late final GeneratedColumn<int> orchidId = GeneratedColumn<int>(
      'orchid_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES orchids (id)'));
  static const VerificationMeta _locationNameMeta =
      const VerificationMeta('locationName');
  @override
  late final GeneratedColumn<String> locationName = GeneratedColumn<String>(
      'location_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _luxValueMeta =
      const VerificationMeta('luxValue');
  @override
  late final GeneratedColumn<double> luxValue = GeneratedColumn<double>(
      'lux_value', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _readingAtMeta =
      const VerificationMeta('readingAt');
  @override
  late final GeneratedColumn<DateTime> readingAt = GeneratedColumn<DateTime>(
      'reading_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, orchidId, locationName, luxValue, readingAt, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'light_readings';
  @override
  VerificationContext validateIntegrity(Insertable<LightReading> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('orchid_id')) {
      context.handle(_orchidIdMeta,
          orchidId.isAcceptableOrUnknown(data['orchid_id']!, _orchidIdMeta));
    }
    if (data.containsKey('location_name')) {
      context.handle(
          _locationNameMeta,
          locationName.isAcceptableOrUnknown(
              data['location_name']!, _locationNameMeta));
    }
    if (data.containsKey('lux_value')) {
      context.handle(_luxValueMeta,
          luxValue.isAcceptableOrUnknown(data['lux_value']!, _luxValueMeta));
    } else if (isInserting) {
      context.missing(_luxValueMeta);
    }
    if (data.containsKey('reading_at')) {
      context.handle(_readingAtMeta,
          readingAt.isAcceptableOrUnknown(data['reading_at']!, _readingAtMeta));
    } else if (isInserting) {
      context.missing(_readingAtMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LightReading map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LightReading(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      orchidId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}orchid_id']),
      locationName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location_name']),
      luxValue: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}lux_value'])!,
      readingAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}reading_at'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $LightReadingsTable createAlias(String alias) {
    return $LightReadingsTable(attachedDatabase, alias);
  }
}

class LightReading extends DataClass implements Insertable<LightReading> {
  final int id;
  final int? orchidId;
  final String? locationName;
  final double luxValue;
  final DateTime readingAt;
  final String? notes;
  const LightReading(
      {required this.id,
      this.orchidId,
      this.locationName,
      required this.luxValue,
      required this.readingAt,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || orchidId != null) {
      map['orchid_id'] = Variable<int>(orchidId);
    }
    if (!nullToAbsent || locationName != null) {
      map['location_name'] = Variable<String>(locationName);
    }
    map['lux_value'] = Variable<double>(luxValue);
    map['reading_at'] = Variable<DateTime>(readingAt);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  LightReadingsCompanion toCompanion(bool nullToAbsent) {
    return LightReadingsCompanion(
      id: Value(id),
      orchidId: orchidId == null && nullToAbsent
          ? const Value.absent()
          : Value(orchidId),
      locationName: locationName == null && nullToAbsent
          ? const Value.absent()
          : Value(locationName),
      luxValue: Value(luxValue),
      readingAt: Value(readingAt),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory LightReading.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LightReading(
      id: serializer.fromJson<int>(json['id']),
      orchidId: serializer.fromJson<int?>(json['orchidId']),
      locationName: serializer.fromJson<String?>(json['locationName']),
      luxValue: serializer.fromJson<double>(json['luxValue']),
      readingAt: serializer.fromJson<DateTime>(json['readingAt']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orchidId': serializer.toJson<int?>(orchidId),
      'locationName': serializer.toJson<String?>(locationName),
      'luxValue': serializer.toJson<double>(luxValue),
      'readingAt': serializer.toJson<DateTime>(readingAt),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  LightReading copyWith(
          {int? id,
          Value<int?> orchidId = const Value.absent(),
          Value<String?> locationName = const Value.absent(),
          double? luxValue,
          DateTime? readingAt,
          Value<String?> notes = const Value.absent()}) =>
      LightReading(
        id: id ?? this.id,
        orchidId: orchidId.present ? orchidId.value : this.orchidId,
        locationName:
            locationName.present ? locationName.value : this.locationName,
        luxValue: luxValue ?? this.luxValue,
        readingAt: readingAt ?? this.readingAt,
        notes: notes.present ? notes.value : this.notes,
      );
  @override
  String toString() {
    return (StringBuffer('LightReading(')
          ..write('id: $id, ')
          ..write('orchidId: $orchidId, ')
          ..write('locationName: $locationName, ')
          ..write('luxValue: $luxValue, ')
          ..write('readingAt: $readingAt, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, orchidId, locationName, luxValue, readingAt, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LightReading &&
          other.id == this.id &&
          other.orchidId == this.orchidId &&
          other.locationName == this.locationName &&
          other.luxValue == this.luxValue &&
          other.readingAt == this.readingAt &&
          other.notes == this.notes);
}

class LightReadingsCompanion extends UpdateCompanion<LightReading> {
  final Value<int> id;
  final Value<int?> orchidId;
  final Value<String?> locationName;
  final Value<double> luxValue;
  final Value<DateTime> readingAt;
  final Value<String?> notes;
  const LightReadingsCompanion({
    this.id = const Value.absent(),
    this.orchidId = const Value.absent(),
    this.locationName = const Value.absent(),
    this.luxValue = const Value.absent(),
    this.readingAt = const Value.absent(),
    this.notes = const Value.absent(),
  });
  LightReadingsCompanion.insert({
    this.id = const Value.absent(),
    this.orchidId = const Value.absent(),
    this.locationName = const Value.absent(),
    required double luxValue,
    required DateTime readingAt,
    this.notes = const Value.absent(),
  })  : luxValue = Value(luxValue),
        readingAt = Value(readingAt);
  static Insertable<LightReading> custom({
    Expression<int>? id,
    Expression<int>? orchidId,
    Expression<String>? locationName,
    Expression<double>? luxValue,
    Expression<DateTime>? readingAt,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orchidId != null) 'orchid_id': orchidId,
      if (locationName != null) 'location_name': locationName,
      if (luxValue != null) 'lux_value': luxValue,
      if (readingAt != null) 'reading_at': readingAt,
      if (notes != null) 'notes': notes,
    });
  }

  LightReadingsCompanion copyWith(
      {Value<int>? id,
      Value<int?>? orchidId,
      Value<String?>? locationName,
      Value<double>? luxValue,
      Value<DateTime>? readingAt,
      Value<String?>? notes}) {
    return LightReadingsCompanion(
      id: id ?? this.id,
      orchidId: orchidId ?? this.orchidId,
      locationName: locationName ?? this.locationName,
      luxValue: luxValue ?? this.luxValue,
      readingAt: readingAt ?? this.readingAt,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orchidId.present) {
      map['orchid_id'] = Variable<int>(orchidId.value);
    }
    if (locationName.present) {
      map['location_name'] = Variable<String>(locationName.value);
    }
    if (luxValue.present) {
      map['lux_value'] = Variable<double>(luxValue.value);
    }
    if (readingAt.present) {
      map['reading_at'] = Variable<DateTime>(readingAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LightReadingsCompanion(')
          ..write('id: $id, ')
          ..write('orchidId: $orchidId, ')
          ..write('locationName: $locationName, ')
          ..write('luxValue: $luxValue, ')
          ..write('readingAt: $readingAt, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(Insertable<Setting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String value;
  const Setting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      key: Value(key),
      value: Value(value),
    );
  }

  factory Setting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  Setting copyWith({String? key, String? value}) => Setting(
        key: key ?? this.key,
        value: value ?? this.value,
      );
  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting && other.key == this.key && other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith(
      {Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SoakSessionsTable extends SoakSessions
    with TableInfo<$SoakSessionsTable, SoakSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SoakSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _startedAtMeta =
      const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
      'started_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _durationMinutesMeta =
      const VerificationMeta('durationMinutes');
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
      'duration_minutes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(15));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumnWithTypeConverter<SoakStatus, String> status =
      GeneratedColumn<String>('status', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<SoakStatus>($SoakSessionsTable.$converterstatus);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _notificationIdMeta =
      const VerificationMeta('notificationId');
  @override
  late final GeneratedColumn<int> notificationId = GeneratedColumn<int>(
      'notification_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, startedAt, durationMinutes, status, completedAt, notificationId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'soak_sessions';
  @override
  VerificationContext validateIntegrity(Insertable<SoakSession> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta,
          startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
          _durationMinutesMeta,
          durationMinutes.isAcceptableOrUnknown(
              data['duration_minutes']!, _durationMinutesMeta));
    }
    context.handle(_statusMeta, const VerificationResult.success());
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('notification_id')) {
      context.handle(
          _notificationIdMeta,
          notificationId.isAcceptableOrUnknown(
              data['notification_id']!, _notificationIdMeta));
    } else if (isInserting) {
      context.missing(_notificationIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SoakSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SoakSession(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      startedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}started_at'])!,
      durationMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_minutes'])!,
      status: $SoakSessionsTable.$converterstatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!),
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
      notificationId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}notification_id'])!,
    );
  }

  @override
  $SoakSessionsTable createAlias(String alias) {
    return $SoakSessionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SoakStatus, String, String> $converterstatus =
      const EnumNameConverter<SoakStatus>(SoakStatus.values);
}

class SoakSession extends DataClass implements Insertable<SoakSession> {
  final int id;
  final DateTime startedAt;
  final int durationMinutes;
  final SoakStatus status;
  final DateTime? completedAt;
  final int notificationId;
  const SoakSession(
      {required this.id,
      required this.startedAt,
      required this.durationMinutes,
      required this.status,
      this.completedAt,
      required this.notificationId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['duration_minutes'] = Variable<int>(durationMinutes);
    {
      map['status'] =
          Variable<String>($SoakSessionsTable.$converterstatus.toSql(status));
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['notification_id'] = Variable<int>(notificationId);
    return map;
  }

  SoakSessionsCompanion toCompanion(bool nullToAbsent) {
    return SoakSessionsCompanion(
      id: Value(id),
      startedAt: Value(startedAt),
      durationMinutes: Value(durationMinutes),
      status: Value(status),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      notificationId: Value(notificationId),
    );
  }

  factory SoakSession.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SoakSession(
      id: serializer.fromJson<int>(json['id']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      status: $SoakSessionsTable.$converterstatus
          .fromJson(serializer.fromJson<String>(json['status'])),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      notificationId: serializer.fromJson<int>(json['notificationId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'status': serializer
          .toJson<String>($SoakSessionsTable.$converterstatus.toJson(status)),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'notificationId': serializer.toJson<int>(notificationId),
    };
  }

  SoakSession copyWith(
          {int? id,
          DateTime? startedAt,
          int? durationMinutes,
          SoakStatus? status,
          Value<DateTime?> completedAt = const Value.absent(),
          int? notificationId}) =>
      SoakSession(
        id: id ?? this.id,
        startedAt: startedAt ?? this.startedAt,
        durationMinutes: durationMinutes ?? this.durationMinutes,
        status: status ?? this.status,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
        notificationId: notificationId ?? this.notificationId,
      );
  @override
  String toString() {
    return (StringBuffer('SoakSession(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('status: $status, ')
          ..write('completedAt: $completedAt, ')
          ..write('notificationId: $notificationId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, startedAt, durationMinutes, status, completedAt, notificationId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SoakSession &&
          other.id == this.id &&
          other.startedAt == this.startedAt &&
          other.durationMinutes == this.durationMinutes &&
          other.status == this.status &&
          other.completedAt == this.completedAt &&
          other.notificationId == this.notificationId);
}

class SoakSessionsCompanion extends UpdateCompanion<SoakSession> {
  final Value<int> id;
  final Value<DateTime> startedAt;
  final Value<int> durationMinutes;
  final Value<SoakStatus> status;
  final Value<DateTime?> completedAt;
  final Value<int> notificationId;
  const SoakSessionsCompanion({
    this.id = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.status = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.notificationId = const Value.absent(),
  });
  SoakSessionsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime startedAt,
    this.durationMinutes = const Value.absent(),
    required SoakStatus status,
    this.completedAt = const Value.absent(),
    required int notificationId,
  })  : startedAt = Value(startedAt),
        status = Value(status),
        notificationId = Value(notificationId);
  static Insertable<SoakSession> custom({
    Expression<int>? id,
    Expression<DateTime>? startedAt,
    Expression<int>? durationMinutes,
    Expression<String>? status,
    Expression<DateTime>? completedAt,
    Expression<int>? notificationId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startedAt != null) 'started_at': startedAt,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (status != null) 'status': status,
      if (completedAt != null) 'completed_at': completedAt,
      if (notificationId != null) 'notification_id': notificationId,
    });
  }

  SoakSessionsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? startedAt,
      Value<int>? durationMinutes,
      Value<SoakStatus>? status,
      Value<DateTime?>? completedAt,
      Value<int>? notificationId}) {
    return SoakSessionsCompanion(
      id: id ?? this.id,
      startedAt: startedAt ?? this.startedAt,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      status: status ?? this.status,
      completedAt: completedAt ?? this.completedAt,
      notificationId: notificationId ?? this.notificationId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
          $SoakSessionsTable.$converterstatus.toSql(status.value));
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (notificationId.present) {
      map['notification_id'] = Variable<int>(notificationId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SoakSessionsCompanion(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('status: $status, ')
          ..write('completedAt: $completedAt, ')
          ..write('notificationId: $notificationId')
          ..write(')'))
        .toString();
  }
}

class $SoakSessionTasksTable extends SoakSessionTasks
    with TableInfo<$SoakSessionTasksTable, SoakSessionTask> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SoakSessionTasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _soakSessionIdMeta =
      const VerificationMeta('soakSessionId');
  @override
  late final GeneratedColumn<int> soakSessionId = GeneratedColumn<int>(
      'soak_session_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES soak_sessions (id)'));
  static const VerificationMeta _careTaskIdMeta =
      const VerificationMeta('careTaskId');
  @override
  late final GeneratedColumn<int> careTaskId = GeneratedColumn<int>(
      'care_task_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES care_tasks (id)'));
  static const VerificationMeta _orchidIdMeta =
      const VerificationMeta('orchidId');
  @override
  late final GeneratedColumn<int> orchidId = GeneratedColumn<int>(
      'orchid_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES orchids (id)'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, soakSessionId, careTaskId, orchidId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'soak_session_tasks';
  @override
  VerificationContext validateIntegrity(Insertable<SoakSessionTask> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('soak_session_id')) {
      context.handle(
          _soakSessionIdMeta,
          soakSessionId.isAcceptableOrUnknown(
              data['soak_session_id']!, _soakSessionIdMeta));
    } else if (isInserting) {
      context.missing(_soakSessionIdMeta);
    }
    if (data.containsKey('care_task_id')) {
      context.handle(
          _careTaskIdMeta,
          careTaskId.isAcceptableOrUnknown(
              data['care_task_id']!, _careTaskIdMeta));
    } else if (isInserting) {
      context.missing(_careTaskIdMeta);
    }
    if (data.containsKey('orchid_id')) {
      context.handle(_orchidIdMeta,
          orchidId.isAcceptableOrUnknown(data['orchid_id']!, _orchidIdMeta));
    } else if (isInserting) {
      context.missing(_orchidIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SoakSessionTask map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SoakSessionTask(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      soakSessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}soak_session_id'])!,
      careTaskId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}care_task_id'])!,
      orchidId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}orchid_id'])!,
    );
  }

  @override
  $SoakSessionTasksTable createAlias(String alias) {
    return $SoakSessionTasksTable(attachedDatabase, alias);
  }
}

class SoakSessionTask extends DataClass implements Insertable<SoakSessionTask> {
  final int id;
  final int soakSessionId;
  final int careTaskId;
  final int orchidId;
  const SoakSessionTask(
      {required this.id,
      required this.soakSessionId,
      required this.careTaskId,
      required this.orchidId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['soak_session_id'] = Variable<int>(soakSessionId);
    map['care_task_id'] = Variable<int>(careTaskId);
    map['orchid_id'] = Variable<int>(orchidId);
    return map;
  }

  SoakSessionTasksCompanion toCompanion(bool nullToAbsent) {
    return SoakSessionTasksCompanion(
      id: Value(id),
      soakSessionId: Value(soakSessionId),
      careTaskId: Value(careTaskId),
      orchidId: Value(orchidId),
    );
  }

  factory SoakSessionTask.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SoakSessionTask(
      id: serializer.fromJson<int>(json['id']),
      soakSessionId: serializer.fromJson<int>(json['soakSessionId']),
      careTaskId: serializer.fromJson<int>(json['careTaskId']),
      orchidId: serializer.fromJson<int>(json['orchidId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'soakSessionId': serializer.toJson<int>(soakSessionId),
      'careTaskId': serializer.toJson<int>(careTaskId),
      'orchidId': serializer.toJson<int>(orchidId),
    };
  }

  SoakSessionTask copyWith(
          {int? id, int? soakSessionId, int? careTaskId, int? orchidId}) =>
      SoakSessionTask(
        id: id ?? this.id,
        soakSessionId: soakSessionId ?? this.soakSessionId,
        careTaskId: careTaskId ?? this.careTaskId,
        orchidId: orchidId ?? this.orchidId,
      );
  @override
  String toString() {
    return (StringBuffer('SoakSessionTask(')
          ..write('id: $id, ')
          ..write('soakSessionId: $soakSessionId, ')
          ..write('careTaskId: $careTaskId, ')
          ..write('orchidId: $orchidId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, soakSessionId, careTaskId, orchidId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SoakSessionTask &&
          other.id == this.id &&
          other.soakSessionId == this.soakSessionId &&
          other.careTaskId == this.careTaskId &&
          other.orchidId == this.orchidId);
}

class SoakSessionTasksCompanion extends UpdateCompanion<SoakSessionTask> {
  final Value<int> id;
  final Value<int> soakSessionId;
  final Value<int> careTaskId;
  final Value<int> orchidId;
  const SoakSessionTasksCompanion({
    this.id = const Value.absent(),
    this.soakSessionId = const Value.absent(),
    this.careTaskId = const Value.absent(),
    this.orchidId = const Value.absent(),
  });
  SoakSessionTasksCompanion.insert({
    this.id = const Value.absent(),
    required int soakSessionId,
    required int careTaskId,
    required int orchidId,
  })  : soakSessionId = Value(soakSessionId),
        careTaskId = Value(careTaskId),
        orchidId = Value(orchidId);
  static Insertable<SoakSessionTask> custom({
    Expression<int>? id,
    Expression<int>? soakSessionId,
    Expression<int>? careTaskId,
    Expression<int>? orchidId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (soakSessionId != null) 'soak_session_id': soakSessionId,
      if (careTaskId != null) 'care_task_id': careTaskId,
      if (orchidId != null) 'orchid_id': orchidId,
    });
  }

  SoakSessionTasksCompanion copyWith(
      {Value<int>? id,
      Value<int>? soakSessionId,
      Value<int>? careTaskId,
      Value<int>? orchidId}) {
    return SoakSessionTasksCompanion(
      id: id ?? this.id,
      soakSessionId: soakSessionId ?? this.soakSessionId,
      careTaskId: careTaskId ?? this.careTaskId,
      orchidId: orchidId ?? this.orchidId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (soakSessionId.present) {
      map['soak_session_id'] = Variable<int>(soakSessionId.value);
    }
    if (careTaskId.present) {
      map['care_task_id'] = Variable<int>(careTaskId.value);
    }
    if (orchidId.present) {
      map['orchid_id'] = Variable<int>(orchidId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SoakSessionTasksCompanion(')
          ..write('id: $id, ')
          ..write('soakSessionId: $soakSessionId, ')
          ..write('careTaskId: $careTaskId, ')
          ..write('orchidId: $orchidId')
          ..write(')'))
        .toString();
  }
}

class $BloomLogsTable extends BloomLogs
    with TableInfo<$BloomLogsTable, BloomLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BloomLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _orchidIdMeta =
      const VerificationMeta('orchidId');
  @override
  late final GeneratedColumn<int> orchidId = GeneratedColumn<int>(
      'orchid_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES orchids (id)'));
  static const VerificationMeta _stageMeta = const VerificationMeta('stage');
  @override
  late final GeneratedColumnWithTypeConverter<BloomStage, String> stage =
      GeneratedColumn<String>('stage', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<BloomStage>($BloomLogsTable.$converterstage);
  static const VerificationMeta _dateLoggedMeta =
      const VerificationMeta('dateLogged');
  @override
  late final GeneratedColumn<DateTime> dateLogged = GeneratedColumn<DateTime>(
      'date_logged', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _photoPathMeta =
      const VerificationMeta('photoPath');
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
      'photo_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, orchidId, stage, dateLogged, notes, photoPath];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bloom_logs';
  @override
  VerificationContext validateIntegrity(Insertable<BloomLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('orchid_id')) {
      context.handle(_orchidIdMeta,
          orchidId.isAcceptableOrUnknown(data['orchid_id']!, _orchidIdMeta));
    } else if (isInserting) {
      context.missing(_orchidIdMeta);
    }
    context.handle(_stageMeta, const VerificationResult.success());
    if (data.containsKey('date_logged')) {
      context.handle(
          _dateLoggedMeta,
          dateLogged.isAcceptableOrUnknown(
              data['date_logged']!, _dateLoggedMeta));
    } else if (isInserting) {
      context.missing(_dateLoggedMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('photo_path')) {
      context.handle(_photoPathMeta,
          photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BloomLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BloomLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      orchidId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}orchid_id'])!,
      stage: $BloomLogsTable.$converterstage.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}stage'])!),
      dateLogged: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_logged'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      photoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo_path']),
    );
  }

  @override
  $BloomLogsTable createAlias(String alias) {
    return $BloomLogsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<BloomStage, String, String> $converterstage =
      const EnumNameConverter<BloomStage>(BloomStage.values);
}

class BloomLog extends DataClass implements Insertable<BloomLog> {
  final int id;
  final int orchidId;
  final BloomStage stage;
  final DateTime dateLogged;
  final String? notes;
  final String? photoPath;
  const BloomLog(
      {required this.id,
      required this.orchidId,
      required this.stage,
      required this.dateLogged,
      this.notes,
      this.photoPath});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['orchid_id'] = Variable<int>(orchidId);
    {
      map['stage'] =
          Variable<String>($BloomLogsTable.$converterstage.toSql(stage));
    }
    map['date_logged'] = Variable<DateTime>(dateLogged);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    return map;
  }

  BloomLogsCompanion toCompanion(bool nullToAbsent) {
    return BloomLogsCompanion(
      id: Value(id),
      orchidId: Value(orchidId),
      stage: Value(stage),
      dateLogged: Value(dateLogged),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
    );
  }

  factory BloomLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BloomLog(
      id: serializer.fromJson<int>(json['id']),
      orchidId: serializer.fromJson<int>(json['orchidId']),
      stage: $BloomLogsTable.$converterstage
          .fromJson(serializer.fromJson<String>(json['stage'])),
      dateLogged: serializer.fromJson<DateTime>(json['dateLogged']),
      notes: serializer.fromJson<String?>(json['notes']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orchidId': serializer.toJson<int>(orchidId),
      'stage': serializer
          .toJson<String>($BloomLogsTable.$converterstage.toJson(stage)),
      'dateLogged': serializer.toJson<DateTime>(dateLogged),
      'notes': serializer.toJson<String?>(notes),
      'photoPath': serializer.toJson<String?>(photoPath),
    };
  }

  BloomLog copyWith(
          {int? id,
          int? orchidId,
          BloomStage? stage,
          DateTime? dateLogged,
          Value<String?> notes = const Value.absent(),
          Value<String?> photoPath = const Value.absent()}) =>
      BloomLog(
        id: id ?? this.id,
        orchidId: orchidId ?? this.orchidId,
        stage: stage ?? this.stage,
        dateLogged: dateLogged ?? this.dateLogged,
        notes: notes.present ? notes.value : this.notes,
        photoPath: photoPath.present ? photoPath.value : this.photoPath,
      );
  @override
  String toString() {
    return (StringBuffer('BloomLog(')
          ..write('id: $id, ')
          ..write('orchidId: $orchidId, ')
          ..write('stage: $stage, ')
          ..write('dateLogged: $dateLogged, ')
          ..write('notes: $notes, ')
          ..write('photoPath: $photoPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, orchidId, stage, dateLogged, notes, photoPath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BloomLog &&
          other.id == this.id &&
          other.orchidId == this.orchidId &&
          other.stage == this.stage &&
          other.dateLogged == this.dateLogged &&
          other.notes == this.notes &&
          other.photoPath == this.photoPath);
}

class BloomLogsCompanion extends UpdateCompanion<BloomLog> {
  final Value<int> id;
  final Value<int> orchidId;
  final Value<BloomStage> stage;
  final Value<DateTime> dateLogged;
  final Value<String?> notes;
  final Value<String?> photoPath;
  const BloomLogsCompanion({
    this.id = const Value.absent(),
    this.orchidId = const Value.absent(),
    this.stage = const Value.absent(),
    this.dateLogged = const Value.absent(),
    this.notes = const Value.absent(),
    this.photoPath = const Value.absent(),
  });
  BloomLogsCompanion.insert({
    this.id = const Value.absent(),
    required int orchidId,
    required BloomStage stage,
    required DateTime dateLogged,
    this.notes = const Value.absent(),
    this.photoPath = const Value.absent(),
  })  : orchidId = Value(orchidId),
        stage = Value(stage),
        dateLogged = Value(dateLogged);
  static Insertable<BloomLog> custom({
    Expression<int>? id,
    Expression<int>? orchidId,
    Expression<String>? stage,
    Expression<DateTime>? dateLogged,
    Expression<String>? notes,
    Expression<String>? photoPath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orchidId != null) 'orchid_id': orchidId,
      if (stage != null) 'stage': stage,
      if (dateLogged != null) 'date_logged': dateLogged,
      if (notes != null) 'notes': notes,
      if (photoPath != null) 'photo_path': photoPath,
    });
  }

  BloomLogsCompanion copyWith(
      {Value<int>? id,
      Value<int>? orchidId,
      Value<BloomStage>? stage,
      Value<DateTime>? dateLogged,
      Value<String?>? notes,
      Value<String?>? photoPath}) {
    return BloomLogsCompanion(
      id: id ?? this.id,
      orchidId: orchidId ?? this.orchidId,
      stage: stage ?? this.stage,
      dateLogged: dateLogged ?? this.dateLogged,
      notes: notes ?? this.notes,
      photoPath: photoPath ?? this.photoPath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orchidId.present) {
      map['orchid_id'] = Variable<int>(orchidId.value);
    }
    if (stage.present) {
      map['stage'] =
          Variable<String>($BloomLogsTable.$converterstage.toSql(stage.value));
    }
    if (dateLogged.present) {
      map['date_logged'] = Variable<DateTime>(dateLogged.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BloomLogsCompanion(')
          ..write('id: $id, ')
          ..write('orchidId: $orchidId, ')
          ..write('stage: $stage, ')
          ..write('dateLogged: $dateLogged, ')
          ..write('notes: $notes, ')
          ..write('photoPath: $photoPath')
          ..write(')'))
        .toString();
  }
}

class $PhotoJournalTable extends PhotoJournal
    with TableInfo<$PhotoJournalTable, PhotoJournalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PhotoJournalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _orchidIdMeta =
      const VerificationMeta('orchidId');
  @override
  late final GeneratedColumn<int> orchidId = GeneratedColumn<int>(
      'orchid_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES orchids (id)'));
  static const VerificationMeta _photoPathMeta =
      const VerificationMeta('photoPath');
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
      'photo_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateTakenMeta =
      const VerificationMeta('dateTaken');
  @override
  late final GeneratedColumn<DateTime> dateTaken = GeneratedColumn<DateTime>(
      'date_taken', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _tagMeta = const VerificationMeta('tag');
  @override
  late final GeneratedColumnWithTypeConverter<PhotoTag, String> tag =
      GeneratedColumn<String>('tag', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<PhotoTag>($PhotoJournalTable.$convertertag);
  @override
  List<GeneratedColumn> get $columns =>
      [id, orchidId, photoPath, dateTaken, note, tag];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'photo_journal';
  @override
  VerificationContext validateIntegrity(Insertable<PhotoJournalData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('orchid_id')) {
      context.handle(_orchidIdMeta,
          orchidId.isAcceptableOrUnknown(data['orchid_id']!, _orchidIdMeta));
    } else if (isInserting) {
      context.missing(_orchidIdMeta);
    }
    if (data.containsKey('photo_path')) {
      context.handle(_photoPathMeta,
          photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta));
    } else if (isInserting) {
      context.missing(_photoPathMeta);
    }
    if (data.containsKey('date_taken')) {
      context.handle(_dateTakenMeta,
          dateTaken.isAcceptableOrUnknown(data['date_taken']!, _dateTakenMeta));
    } else if (isInserting) {
      context.missing(_dateTakenMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    context.handle(_tagMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PhotoJournalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PhotoJournalData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      orchidId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}orchid_id'])!,
      photoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo_path'])!,
      dateTaken: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_taken'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      tag: $PhotoJournalTable.$convertertag.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tag'])!),
    );
  }

  @override
  $PhotoJournalTable createAlias(String alias) {
    return $PhotoJournalTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PhotoTag, String, String> $convertertag =
      const EnumNameConverter<PhotoTag>(PhotoTag.values);
}

class PhotoJournalData extends DataClass
    implements Insertable<PhotoJournalData> {
  final int id;
  final int orchidId;
  final String photoPath;
  final DateTime dateTaken;
  final String? note;
  final PhotoTag tag;
  const PhotoJournalData(
      {required this.id,
      required this.orchidId,
      required this.photoPath,
      required this.dateTaken,
      this.note,
      required this.tag});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['orchid_id'] = Variable<int>(orchidId);
    map['photo_path'] = Variable<String>(photoPath);
    map['date_taken'] = Variable<DateTime>(dateTaken);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    {
      map['tag'] =
          Variable<String>($PhotoJournalTable.$convertertag.toSql(tag));
    }
    return map;
  }

  PhotoJournalCompanion toCompanion(bool nullToAbsent) {
    return PhotoJournalCompanion(
      id: Value(id),
      orchidId: Value(orchidId),
      photoPath: Value(photoPath),
      dateTaken: Value(dateTaken),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      tag: Value(tag),
    );
  }

  factory PhotoJournalData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PhotoJournalData(
      id: serializer.fromJson<int>(json['id']),
      orchidId: serializer.fromJson<int>(json['orchidId']),
      photoPath: serializer.fromJson<String>(json['photoPath']),
      dateTaken: serializer.fromJson<DateTime>(json['dateTaken']),
      note: serializer.fromJson<String?>(json['note']),
      tag: $PhotoJournalTable.$convertertag
          .fromJson(serializer.fromJson<String>(json['tag'])),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orchidId': serializer.toJson<int>(orchidId),
      'photoPath': serializer.toJson<String>(photoPath),
      'dateTaken': serializer.toJson<DateTime>(dateTaken),
      'note': serializer.toJson<String?>(note),
      'tag': serializer
          .toJson<String>($PhotoJournalTable.$convertertag.toJson(tag)),
    };
  }

  PhotoJournalData copyWith(
          {int? id,
          int? orchidId,
          String? photoPath,
          DateTime? dateTaken,
          Value<String?> note = const Value.absent(),
          PhotoTag? tag}) =>
      PhotoJournalData(
        id: id ?? this.id,
        orchidId: orchidId ?? this.orchidId,
        photoPath: photoPath ?? this.photoPath,
        dateTaken: dateTaken ?? this.dateTaken,
        note: note.present ? note.value : this.note,
        tag: tag ?? this.tag,
      );
  @override
  String toString() {
    return (StringBuffer('PhotoJournalData(')
          ..write('id: $id, ')
          ..write('orchidId: $orchidId, ')
          ..write('photoPath: $photoPath, ')
          ..write('dateTaken: $dateTaken, ')
          ..write('note: $note, ')
          ..write('tag: $tag')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, orchidId, photoPath, dateTaken, note, tag);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PhotoJournalData &&
          other.id == this.id &&
          other.orchidId == this.orchidId &&
          other.photoPath == this.photoPath &&
          other.dateTaken == this.dateTaken &&
          other.note == this.note &&
          other.tag == this.tag);
}

class PhotoJournalCompanion extends UpdateCompanion<PhotoJournalData> {
  final Value<int> id;
  final Value<int> orchidId;
  final Value<String> photoPath;
  final Value<DateTime> dateTaken;
  final Value<String?> note;
  final Value<PhotoTag> tag;
  const PhotoJournalCompanion({
    this.id = const Value.absent(),
    this.orchidId = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.dateTaken = const Value.absent(),
    this.note = const Value.absent(),
    this.tag = const Value.absent(),
  });
  PhotoJournalCompanion.insert({
    this.id = const Value.absent(),
    required int orchidId,
    required String photoPath,
    required DateTime dateTaken,
    this.note = const Value.absent(),
    required PhotoTag tag,
  })  : orchidId = Value(orchidId),
        photoPath = Value(photoPath),
        dateTaken = Value(dateTaken),
        tag = Value(tag);
  static Insertable<PhotoJournalData> custom({
    Expression<int>? id,
    Expression<int>? orchidId,
    Expression<String>? photoPath,
    Expression<DateTime>? dateTaken,
    Expression<String>? note,
    Expression<String>? tag,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orchidId != null) 'orchid_id': orchidId,
      if (photoPath != null) 'photo_path': photoPath,
      if (dateTaken != null) 'date_taken': dateTaken,
      if (note != null) 'note': note,
      if (tag != null) 'tag': tag,
    });
  }

  PhotoJournalCompanion copyWith(
      {Value<int>? id,
      Value<int>? orchidId,
      Value<String>? photoPath,
      Value<DateTime>? dateTaken,
      Value<String?>? note,
      Value<PhotoTag>? tag}) {
    return PhotoJournalCompanion(
      id: id ?? this.id,
      orchidId: orchidId ?? this.orchidId,
      photoPath: photoPath ?? this.photoPath,
      dateTaken: dateTaken ?? this.dateTaken,
      note: note ?? this.note,
      tag: tag ?? this.tag,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orchidId.present) {
      map['orchid_id'] = Variable<int>(orchidId.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (dateTaken.present) {
      map['date_taken'] = Variable<DateTime>(dateTaken.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (tag.present) {
      map['tag'] =
          Variable<String>($PhotoJournalTable.$convertertag.toSql(tag.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PhotoJournalCompanion(')
          ..write('id: $id, ')
          ..write('orchidId: $orchidId, ')
          ..write('photoPath: $photoPath, ')
          ..write('dateTaken: $dateTaken, ')
          ..write('note: $note, ')
          ..write('tag: $tag')
          ..write(')'))
        .toString();
  }
}

class $SpeciesProfilesTable extends SpeciesProfiles
    with TableInfo<$SpeciesProfilesTable, SpeciesProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SpeciesProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _commonNameMeta =
      const VerificationMeta('commonName');
  @override
  late final GeneratedColumn<String> commonName = GeneratedColumn<String>(
      'common_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _genusMeta = const VerificationMeta('genus');
  @override
  late final GeneratedColumn<String> genus = GeneratedColumn<String>(
      'genus', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _speciesMeta =
      const VerificationMeta('species');
  @override
  late final GeneratedColumn<String> species = GeneratedColumn<String>(
      'species', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _idealLuxMinMeta =
      const VerificationMeta('idealLuxMin');
  @override
  late final GeneratedColumn<int> idealLuxMin = GeneratedColumn<int>(
      'ideal_lux_min', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _idealLuxMaxMeta =
      const VerificationMeta('idealLuxMax');
  @override
  late final GeneratedColumn<int> idealLuxMax = GeneratedColumn<int>(
      'ideal_lux_max', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _tempMinFMeta =
      const VerificationMeta('tempMinF');
  @override
  late final GeneratedColumn<int> tempMinF = GeneratedColumn<int>(
      'temp_min_f', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _tempMaxFMeta =
      const VerificationMeta('tempMaxF');
  @override
  late final GeneratedColumn<int> tempMaxF = GeneratedColumn<int>(
      'temp_max_f', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _tempNightDropFMeta =
      const VerificationMeta('tempNightDropF');
  @override
  late final GeneratedColumn<int> tempNightDropF = GeneratedColumn<int>(
      'temp_night_drop_f', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _humidityMeta =
      const VerificationMeta('humidity');
  @override
  late final GeneratedColumn<String> humidity = GeneratedColumn<String>(
      'humidity', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _bloomSeasonMeta =
      const VerificationMeta('bloomSeason');
  @override
  late final GeneratedColumn<String> bloomSeason = GeneratedColumn<String>(
      'bloom_season', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _wateringNotesMeta =
      const VerificationMeta('wateringNotes');
  @override
  late final GeneratedColumn<String> wateringNotes = GeneratedColumn<String>(
      'watering_notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fertilizingNotesMeta =
      const VerificationMeta('fertilizingNotes');
  @override
  late final GeneratedColumn<String> fertilizingNotes = GeneratedColumn<String>(
      'fertilizing_notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _difficultyLevelMeta =
      const VerificationMeta('difficultyLevel');
  @override
  late final GeneratedColumn<String> difficultyLevel = GeneratedColumn<String>(
      'difficulty_level', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        commonName,
        genus,
        species,
        idealLuxMin,
        idealLuxMax,
        tempMinF,
        tempMaxF,
        tempNightDropF,
        humidity,
        bloomSeason,
        wateringNotes,
        fertilizingNotes,
        difficultyLevel,
        description
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'species_profiles';
  @override
  VerificationContext validateIntegrity(Insertable<SpeciesProfile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('common_name')) {
      context.handle(
          _commonNameMeta,
          commonName.isAcceptableOrUnknown(
              data['common_name']!, _commonNameMeta));
    } else if (isInserting) {
      context.missing(_commonNameMeta);
    }
    if (data.containsKey('genus')) {
      context.handle(
          _genusMeta, genus.isAcceptableOrUnknown(data['genus']!, _genusMeta));
    } else if (isInserting) {
      context.missing(_genusMeta);
    }
    if (data.containsKey('species')) {
      context.handle(_speciesMeta,
          species.isAcceptableOrUnknown(data['species']!, _speciesMeta));
    }
    if (data.containsKey('ideal_lux_min')) {
      context.handle(
          _idealLuxMinMeta,
          idealLuxMin.isAcceptableOrUnknown(
              data['ideal_lux_min']!, _idealLuxMinMeta));
    }
    if (data.containsKey('ideal_lux_max')) {
      context.handle(
          _idealLuxMaxMeta,
          idealLuxMax.isAcceptableOrUnknown(
              data['ideal_lux_max']!, _idealLuxMaxMeta));
    }
    if (data.containsKey('temp_min_f')) {
      context.handle(_tempMinFMeta,
          tempMinF.isAcceptableOrUnknown(data['temp_min_f']!, _tempMinFMeta));
    }
    if (data.containsKey('temp_max_f')) {
      context.handle(_tempMaxFMeta,
          tempMaxF.isAcceptableOrUnknown(data['temp_max_f']!, _tempMaxFMeta));
    }
    if (data.containsKey('temp_night_drop_f')) {
      context.handle(
          _tempNightDropFMeta,
          tempNightDropF.isAcceptableOrUnknown(
              data['temp_night_drop_f']!, _tempNightDropFMeta));
    }
    if (data.containsKey('humidity')) {
      context.handle(_humidityMeta,
          humidity.isAcceptableOrUnknown(data['humidity']!, _humidityMeta));
    }
    if (data.containsKey('bloom_season')) {
      context.handle(
          _bloomSeasonMeta,
          bloomSeason.isAcceptableOrUnknown(
              data['bloom_season']!, _bloomSeasonMeta));
    }
    if (data.containsKey('watering_notes')) {
      context.handle(
          _wateringNotesMeta,
          wateringNotes.isAcceptableOrUnknown(
              data['watering_notes']!, _wateringNotesMeta));
    }
    if (data.containsKey('fertilizing_notes')) {
      context.handle(
          _fertilizingNotesMeta,
          fertilizingNotes.isAcceptableOrUnknown(
              data['fertilizing_notes']!, _fertilizingNotesMeta));
    }
    if (data.containsKey('difficulty_level')) {
      context.handle(
          _difficultyLevelMeta,
          difficultyLevel.isAcceptableOrUnknown(
              data['difficulty_level']!, _difficultyLevelMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SpeciesProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SpeciesProfile(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      commonName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}common_name'])!,
      genus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}genus'])!,
      species: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}species']),
      idealLuxMin: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ideal_lux_min']),
      idealLuxMax: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ideal_lux_max']),
      tempMinF: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}temp_min_f']),
      tempMaxF: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}temp_max_f']),
      tempNightDropF: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}temp_night_drop_f']),
      humidity: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}humidity']),
      bloomSeason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bloom_season']),
      wateringNotes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}watering_notes']),
      fertilizingNotes: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}fertilizing_notes']),
      difficultyLevel: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}difficulty_level']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
    );
  }

  @override
  $SpeciesProfilesTable createAlias(String alias) {
    return $SpeciesProfilesTable(attachedDatabase, alias);
  }
}

class SpeciesProfile extends DataClass implements Insertable<SpeciesProfile> {
  final int id;
  final String commonName;
  final String genus;
  final String? species;
  final int? idealLuxMin;
  final int? idealLuxMax;
  final int? tempMinF;
  final int? tempMaxF;
  final int? tempNightDropF;
  final String? humidity;
  final String? bloomSeason;
  final String? wateringNotes;
  final String? fertilizingNotes;
  final String? difficultyLevel;
  final String? description;
  const SpeciesProfile(
      {required this.id,
      required this.commonName,
      required this.genus,
      this.species,
      this.idealLuxMin,
      this.idealLuxMax,
      this.tempMinF,
      this.tempMaxF,
      this.tempNightDropF,
      this.humidity,
      this.bloomSeason,
      this.wateringNotes,
      this.fertilizingNotes,
      this.difficultyLevel,
      this.description});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['common_name'] = Variable<String>(commonName);
    map['genus'] = Variable<String>(genus);
    if (!nullToAbsent || species != null) {
      map['species'] = Variable<String>(species);
    }
    if (!nullToAbsent || idealLuxMin != null) {
      map['ideal_lux_min'] = Variable<int>(idealLuxMin);
    }
    if (!nullToAbsent || idealLuxMax != null) {
      map['ideal_lux_max'] = Variable<int>(idealLuxMax);
    }
    if (!nullToAbsent || tempMinF != null) {
      map['temp_min_f'] = Variable<int>(tempMinF);
    }
    if (!nullToAbsent || tempMaxF != null) {
      map['temp_max_f'] = Variable<int>(tempMaxF);
    }
    if (!nullToAbsent || tempNightDropF != null) {
      map['temp_night_drop_f'] = Variable<int>(tempNightDropF);
    }
    if (!nullToAbsent || humidity != null) {
      map['humidity'] = Variable<String>(humidity);
    }
    if (!nullToAbsent || bloomSeason != null) {
      map['bloom_season'] = Variable<String>(bloomSeason);
    }
    if (!nullToAbsent || wateringNotes != null) {
      map['watering_notes'] = Variable<String>(wateringNotes);
    }
    if (!nullToAbsent || fertilizingNotes != null) {
      map['fertilizing_notes'] = Variable<String>(fertilizingNotes);
    }
    if (!nullToAbsent || difficultyLevel != null) {
      map['difficulty_level'] = Variable<String>(difficultyLevel);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    return map;
  }

  SpeciesProfilesCompanion toCompanion(bool nullToAbsent) {
    return SpeciesProfilesCompanion(
      id: Value(id),
      commonName: Value(commonName),
      genus: Value(genus),
      species: species == null && nullToAbsent
          ? const Value.absent()
          : Value(species),
      idealLuxMin: idealLuxMin == null && nullToAbsent
          ? const Value.absent()
          : Value(idealLuxMin),
      idealLuxMax: idealLuxMax == null && nullToAbsent
          ? const Value.absent()
          : Value(idealLuxMax),
      tempMinF: tempMinF == null && nullToAbsent
          ? const Value.absent()
          : Value(tempMinF),
      tempMaxF: tempMaxF == null && nullToAbsent
          ? const Value.absent()
          : Value(tempMaxF),
      tempNightDropF: tempNightDropF == null && nullToAbsent
          ? const Value.absent()
          : Value(tempNightDropF),
      humidity: humidity == null && nullToAbsent
          ? const Value.absent()
          : Value(humidity),
      bloomSeason: bloomSeason == null && nullToAbsent
          ? const Value.absent()
          : Value(bloomSeason),
      wateringNotes: wateringNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(wateringNotes),
      fertilizingNotes: fertilizingNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(fertilizingNotes),
      difficultyLevel: difficultyLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(difficultyLevel),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
    );
  }

  factory SpeciesProfile.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SpeciesProfile(
      id: serializer.fromJson<int>(json['id']),
      commonName: serializer.fromJson<String>(json['commonName']),
      genus: serializer.fromJson<String>(json['genus']),
      species: serializer.fromJson<String?>(json['species']),
      idealLuxMin: serializer.fromJson<int?>(json['idealLuxMin']),
      idealLuxMax: serializer.fromJson<int?>(json['idealLuxMax']),
      tempMinF: serializer.fromJson<int?>(json['tempMinF']),
      tempMaxF: serializer.fromJson<int?>(json['tempMaxF']),
      tempNightDropF: serializer.fromJson<int?>(json['tempNightDropF']),
      humidity: serializer.fromJson<String?>(json['humidity']),
      bloomSeason: serializer.fromJson<String?>(json['bloomSeason']),
      wateringNotes: serializer.fromJson<String?>(json['wateringNotes']),
      fertilizingNotes: serializer.fromJson<String?>(json['fertilizingNotes']),
      difficultyLevel: serializer.fromJson<String?>(json['difficultyLevel']),
      description: serializer.fromJson<String?>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'commonName': serializer.toJson<String>(commonName),
      'genus': serializer.toJson<String>(genus),
      'species': serializer.toJson<String?>(species),
      'idealLuxMin': serializer.toJson<int?>(idealLuxMin),
      'idealLuxMax': serializer.toJson<int?>(idealLuxMax),
      'tempMinF': serializer.toJson<int?>(tempMinF),
      'tempMaxF': serializer.toJson<int?>(tempMaxF),
      'tempNightDropF': serializer.toJson<int?>(tempNightDropF),
      'humidity': serializer.toJson<String?>(humidity),
      'bloomSeason': serializer.toJson<String?>(bloomSeason),
      'wateringNotes': serializer.toJson<String?>(wateringNotes),
      'fertilizingNotes': serializer.toJson<String?>(fertilizingNotes),
      'difficultyLevel': serializer.toJson<String?>(difficultyLevel),
      'description': serializer.toJson<String?>(description),
    };
  }

  SpeciesProfile copyWith(
          {int? id,
          String? commonName,
          String? genus,
          Value<String?> species = const Value.absent(),
          Value<int?> idealLuxMin = const Value.absent(),
          Value<int?> idealLuxMax = const Value.absent(),
          Value<int?> tempMinF = const Value.absent(),
          Value<int?> tempMaxF = const Value.absent(),
          Value<int?> tempNightDropF = const Value.absent(),
          Value<String?> humidity = const Value.absent(),
          Value<String?> bloomSeason = const Value.absent(),
          Value<String?> wateringNotes = const Value.absent(),
          Value<String?> fertilizingNotes = const Value.absent(),
          Value<String?> difficultyLevel = const Value.absent(),
          Value<String?> description = const Value.absent()}) =>
      SpeciesProfile(
        id: id ?? this.id,
        commonName: commonName ?? this.commonName,
        genus: genus ?? this.genus,
        species: species.present ? species.value : this.species,
        idealLuxMin: idealLuxMin.present ? idealLuxMin.value : this.idealLuxMin,
        idealLuxMax: idealLuxMax.present ? idealLuxMax.value : this.idealLuxMax,
        tempMinF: tempMinF.present ? tempMinF.value : this.tempMinF,
        tempMaxF: tempMaxF.present ? tempMaxF.value : this.tempMaxF,
        tempNightDropF:
            tempNightDropF.present ? tempNightDropF.value : this.tempNightDropF,
        humidity: humidity.present ? humidity.value : this.humidity,
        bloomSeason: bloomSeason.present ? bloomSeason.value : this.bloomSeason,
        wateringNotes:
            wateringNotes.present ? wateringNotes.value : this.wateringNotes,
        fertilizingNotes: fertilizingNotes.present
            ? fertilizingNotes.value
            : this.fertilizingNotes,
        difficultyLevel: difficultyLevel.present
            ? difficultyLevel.value
            : this.difficultyLevel,
        description: description.present ? description.value : this.description,
      );
  @override
  String toString() {
    return (StringBuffer('SpeciesProfile(')
          ..write('id: $id, ')
          ..write('commonName: $commonName, ')
          ..write('genus: $genus, ')
          ..write('species: $species, ')
          ..write('idealLuxMin: $idealLuxMin, ')
          ..write('idealLuxMax: $idealLuxMax, ')
          ..write('tempMinF: $tempMinF, ')
          ..write('tempMaxF: $tempMaxF, ')
          ..write('tempNightDropF: $tempNightDropF, ')
          ..write('humidity: $humidity, ')
          ..write('bloomSeason: $bloomSeason, ')
          ..write('wateringNotes: $wateringNotes, ')
          ..write('fertilizingNotes: $fertilizingNotes, ')
          ..write('difficultyLevel: $difficultyLevel, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      commonName,
      genus,
      species,
      idealLuxMin,
      idealLuxMax,
      tempMinF,
      tempMaxF,
      tempNightDropF,
      humidity,
      bloomSeason,
      wateringNotes,
      fertilizingNotes,
      difficultyLevel,
      description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SpeciesProfile &&
          other.id == this.id &&
          other.commonName == this.commonName &&
          other.genus == this.genus &&
          other.species == this.species &&
          other.idealLuxMin == this.idealLuxMin &&
          other.idealLuxMax == this.idealLuxMax &&
          other.tempMinF == this.tempMinF &&
          other.tempMaxF == this.tempMaxF &&
          other.tempNightDropF == this.tempNightDropF &&
          other.humidity == this.humidity &&
          other.bloomSeason == this.bloomSeason &&
          other.wateringNotes == this.wateringNotes &&
          other.fertilizingNotes == this.fertilizingNotes &&
          other.difficultyLevel == this.difficultyLevel &&
          other.description == this.description);
}

class SpeciesProfilesCompanion extends UpdateCompanion<SpeciesProfile> {
  final Value<int> id;
  final Value<String> commonName;
  final Value<String> genus;
  final Value<String?> species;
  final Value<int?> idealLuxMin;
  final Value<int?> idealLuxMax;
  final Value<int?> tempMinF;
  final Value<int?> tempMaxF;
  final Value<int?> tempNightDropF;
  final Value<String?> humidity;
  final Value<String?> bloomSeason;
  final Value<String?> wateringNotes;
  final Value<String?> fertilizingNotes;
  final Value<String?> difficultyLevel;
  final Value<String?> description;
  const SpeciesProfilesCompanion({
    this.id = const Value.absent(),
    this.commonName = const Value.absent(),
    this.genus = const Value.absent(),
    this.species = const Value.absent(),
    this.idealLuxMin = const Value.absent(),
    this.idealLuxMax = const Value.absent(),
    this.tempMinF = const Value.absent(),
    this.tempMaxF = const Value.absent(),
    this.tempNightDropF = const Value.absent(),
    this.humidity = const Value.absent(),
    this.bloomSeason = const Value.absent(),
    this.wateringNotes = const Value.absent(),
    this.fertilizingNotes = const Value.absent(),
    this.difficultyLevel = const Value.absent(),
    this.description = const Value.absent(),
  });
  SpeciesProfilesCompanion.insert({
    this.id = const Value.absent(),
    required String commonName,
    required String genus,
    this.species = const Value.absent(),
    this.idealLuxMin = const Value.absent(),
    this.idealLuxMax = const Value.absent(),
    this.tempMinF = const Value.absent(),
    this.tempMaxF = const Value.absent(),
    this.tempNightDropF = const Value.absent(),
    this.humidity = const Value.absent(),
    this.bloomSeason = const Value.absent(),
    this.wateringNotes = const Value.absent(),
    this.fertilizingNotes = const Value.absent(),
    this.difficultyLevel = const Value.absent(),
    this.description = const Value.absent(),
  })  : commonName = Value(commonName),
        genus = Value(genus);
  static Insertable<SpeciesProfile> custom({
    Expression<int>? id,
    Expression<String>? commonName,
    Expression<String>? genus,
    Expression<String>? species,
    Expression<int>? idealLuxMin,
    Expression<int>? idealLuxMax,
    Expression<int>? tempMinF,
    Expression<int>? tempMaxF,
    Expression<int>? tempNightDropF,
    Expression<String>? humidity,
    Expression<String>? bloomSeason,
    Expression<String>? wateringNotes,
    Expression<String>? fertilizingNotes,
    Expression<String>? difficultyLevel,
    Expression<String>? description,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (commonName != null) 'common_name': commonName,
      if (genus != null) 'genus': genus,
      if (species != null) 'species': species,
      if (idealLuxMin != null) 'ideal_lux_min': idealLuxMin,
      if (idealLuxMax != null) 'ideal_lux_max': idealLuxMax,
      if (tempMinF != null) 'temp_min_f': tempMinF,
      if (tempMaxF != null) 'temp_max_f': tempMaxF,
      if (tempNightDropF != null) 'temp_night_drop_f': tempNightDropF,
      if (humidity != null) 'humidity': humidity,
      if (bloomSeason != null) 'bloom_season': bloomSeason,
      if (wateringNotes != null) 'watering_notes': wateringNotes,
      if (fertilizingNotes != null) 'fertilizing_notes': fertilizingNotes,
      if (difficultyLevel != null) 'difficulty_level': difficultyLevel,
      if (description != null) 'description': description,
    });
  }

  SpeciesProfilesCompanion copyWith(
      {Value<int>? id,
      Value<String>? commonName,
      Value<String>? genus,
      Value<String?>? species,
      Value<int?>? idealLuxMin,
      Value<int?>? idealLuxMax,
      Value<int?>? tempMinF,
      Value<int?>? tempMaxF,
      Value<int?>? tempNightDropF,
      Value<String?>? humidity,
      Value<String?>? bloomSeason,
      Value<String?>? wateringNotes,
      Value<String?>? fertilizingNotes,
      Value<String?>? difficultyLevel,
      Value<String?>? description}) {
    return SpeciesProfilesCompanion(
      id: id ?? this.id,
      commonName: commonName ?? this.commonName,
      genus: genus ?? this.genus,
      species: species ?? this.species,
      idealLuxMin: idealLuxMin ?? this.idealLuxMin,
      idealLuxMax: idealLuxMax ?? this.idealLuxMax,
      tempMinF: tempMinF ?? this.tempMinF,
      tempMaxF: tempMaxF ?? this.tempMaxF,
      tempNightDropF: tempNightDropF ?? this.tempNightDropF,
      humidity: humidity ?? this.humidity,
      bloomSeason: bloomSeason ?? this.bloomSeason,
      wateringNotes: wateringNotes ?? this.wateringNotes,
      fertilizingNotes: fertilizingNotes ?? this.fertilizingNotes,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      description: description ?? this.description,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (commonName.present) {
      map['common_name'] = Variable<String>(commonName.value);
    }
    if (genus.present) {
      map['genus'] = Variable<String>(genus.value);
    }
    if (species.present) {
      map['species'] = Variable<String>(species.value);
    }
    if (idealLuxMin.present) {
      map['ideal_lux_min'] = Variable<int>(idealLuxMin.value);
    }
    if (idealLuxMax.present) {
      map['ideal_lux_max'] = Variable<int>(idealLuxMax.value);
    }
    if (tempMinF.present) {
      map['temp_min_f'] = Variable<int>(tempMinF.value);
    }
    if (tempMaxF.present) {
      map['temp_max_f'] = Variable<int>(tempMaxF.value);
    }
    if (tempNightDropF.present) {
      map['temp_night_drop_f'] = Variable<int>(tempNightDropF.value);
    }
    if (humidity.present) {
      map['humidity'] = Variable<String>(humidity.value);
    }
    if (bloomSeason.present) {
      map['bloom_season'] = Variable<String>(bloomSeason.value);
    }
    if (wateringNotes.present) {
      map['watering_notes'] = Variable<String>(wateringNotes.value);
    }
    if (fertilizingNotes.present) {
      map['fertilizing_notes'] = Variable<String>(fertilizingNotes.value);
    }
    if (difficultyLevel.present) {
      map['difficulty_level'] = Variable<String>(difficultyLevel.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SpeciesProfilesCompanion(')
          ..write('id: $id, ')
          ..write('commonName: $commonName, ')
          ..write('genus: $genus, ')
          ..write('species: $species, ')
          ..write('idealLuxMin: $idealLuxMin, ')
          ..write('idealLuxMax: $idealLuxMax, ')
          ..write('tempMinF: $tempMinF, ')
          ..write('tempMaxF: $tempMaxF, ')
          ..write('tempNightDropF: $tempNightDropF, ')
          ..write('humidity: $humidity, ')
          ..write('bloomSeason: $bloomSeason, ')
          ..write('wateringNotes: $wateringNotes, ')
          ..write('fertilizingNotes: $fertilizingNotes, ')
          ..write('difficultyLevel: $difficultyLevel, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }
}

class $GrowingLocationsTable extends GrowingLocations
    with TableInfo<$GrowingLocationsTable, GrowingLocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GrowingLocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _latestLuxReadingMeta =
      const VerificationMeta('latestLuxReading');
  @override
  late final GeneratedColumn<double> latestLuxReading = GeneratedColumn<double>(
      'latest_lux_reading', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _lastReadingAtMeta =
      const VerificationMeta('lastReadingAt');
  @override
  late final GeneratedColumn<DateTime> lastReadingAt =
      GeneratedColumn<DateTime>('last_reading_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, description, latestLuxReading, lastReadingAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'growing_locations';
  @override
  VerificationContext validateIntegrity(Insertable<GrowingLocation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('latest_lux_reading')) {
      context.handle(
          _latestLuxReadingMeta,
          latestLuxReading.isAcceptableOrUnknown(
              data['latest_lux_reading']!, _latestLuxReadingMeta));
    }
    if (data.containsKey('last_reading_at')) {
      context.handle(
          _lastReadingAtMeta,
          lastReadingAt.isAcceptableOrUnknown(
              data['last_reading_at']!, _lastReadingAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GrowingLocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GrowingLocation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      latestLuxReading: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}latest_lux_reading']),
      lastReadingAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_reading_at']),
    );
  }

  @override
  $GrowingLocationsTable createAlias(String alias) {
    return $GrowingLocationsTable(attachedDatabase, alias);
  }
}

class GrowingLocation extends DataClass implements Insertable<GrowingLocation> {
  final int id;
  final String name;
  final String? description;
  final double? latestLuxReading;
  final DateTime? lastReadingAt;
  const GrowingLocation(
      {required this.id,
      required this.name,
      this.description,
      this.latestLuxReading,
      this.lastReadingAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || latestLuxReading != null) {
      map['latest_lux_reading'] = Variable<double>(latestLuxReading);
    }
    if (!nullToAbsent || lastReadingAt != null) {
      map['last_reading_at'] = Variable<DateTime>(lastReadingAt);
    }
    return map;
  }

  GrowingLocationsCompanion toCompanion(bool nullToAbsent) {
    return GrowingLocationsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      latestLuxReading: latestLuxReading == null && nullToAbsent
          ? const Value.absent()
          : Value(latestLuxReading),
      lastReadingAt: lastReadingAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReadingAt),
    );
  }

  factory GrowingLocation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GrowingLocation(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      latestLuxReading: serializer.fromJson<double?>(json['latestLuxReading']),
      lastReadingAt: serializer.fromJson<DateTime?>(json['lastReadingAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'latestLuxReading': serializer.toJson<double?>(latestLuxReading),
      'lastReadingAt': serializer.toJson<DateTime?>(lastReadingAt),
    };
  }

  GrowingLocation copyWith(
          {int? id,
          String? name,
          Value<String?> description = const Value.absent(),
          Value<double?> latestLuxReading = const Value.absent(),
          Value<DateTime?> lastReadingAt = const Value.absent()}) =>
      GrowingLocation(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        latestLuxReading: latestLuxReading.present
            ? latestLuxReading.value
            : this.latestLuxReading,
        lastReadingAt:
            lastReadingAt.present ? lastReadingAt.value : this.lastReadingAt,
      );
  @override
  String toString() {
    return (StringBuffer('GrowingLocation(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('latestLuxReading: $latestLuxReading, ')
          ..write('lastReadingAt: $lastReadingAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, description, latestLuxReading, lastReadingAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GrowingLocation &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.latestLuxReading == this.latestLuxReading &&
          other.lastReadingAt == this.lastReadingAt);
}

class GrowingLocationsCompanion extends UpdateCompanion<GrowingLocation> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<double?> latestLuxReading;
  final Value<DateTime?> lastReadingAt;
  const GrowingLocationsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.latestLuxReading = const Value.absent(),
    this.lastReadingAt = const Value.absent(),
  });
  GrowingLocationsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.latestLuxReading = const Value.absent(),
    this.lastReadingAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<GrowingLocation> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<double>? latestLuxReading,
    Expression<DateTime>? lastReadingAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (latestLuxReading != null) 'latest_lux_reading': latestLuxReading,
      if (lastReadingAt != null) 'last_reading_at': lastReadingAt,
    });
  }

  GrowingLocationsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? description,
      Value<double?>? latestLuxReading,
      Value<DateTime?>? lastReadingAt}) {
    return GrowingLocationsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      latestLuxReading: latestLuxReading ?? this.latestLuxReading,
      lastReadingAt: lastReadingAt ?? this.lastReadingAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (latestLuxReading.present) {
      map['latest_lux_reading'] = Variable<double>(latestLuxReading.value);
    }
    if (lastReadingAt.present) {
      map['last_reading_at'] = Variable<DateTime>(lastReadingAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GrowingLocationsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('latestLuxReading: $latestLuxReading, ')
          ..write('lastReadingAt: $lastReadingAt')
          ..write(')'))
        .toString();
  }
}

class $MilestonesTable extends Milestones
    with TableInfo<$MilestonesTable, Milestone> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MilestonesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _orchidIdMeta =
      const VerificationMeta('orchidId');
  @override
  late final GeneratedColumn<int> orchidId = GeneratedColumn<int>(
      'orchid_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES orchids (id)'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _messageMeta =
      const VerificationMeta('message');
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
      'message', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _triggeredAtMeta =
      const VerificationMeta('triggeredAt');
  @override
  late final GeneratedColumn<DateTime> triggeredAt = GeneratedColumn<DateTime>(
      'triggered_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _dismissedMeta =
      const VerificationMeta('dismissed');
  @override
  late final GeneratedColumn<bool> dismissed = GeneratedColumn<bool>(
      'dismissed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("dismissed" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, orchidId, type, message, triggeredAt, dismissed];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'milestones';
  @override
  VerificationContext validateIntegrity(Insertable<Milestone> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('orchid_id')) {
      context.handle(_orchidIdMeta,
          orchidId.isAcceptableOrUnknown(data['orchid_id']!, _orchidIdMeta));
    } else if (isInserting) {
      context.missing(_orchidIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('message')) {
      context.handle(_messageMeta,
          message.isAcceptableOrUnknown(data['message']!, _messageMeta));
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('triggered_at')) {
      context.handle(
          _triggeredAtMeta,
          triggeredAt.isAcceptableOrUnknown(
              data['triggered_at']!, _triggeredAtMeta));
    } else if (isInserting) {
      context.missing(_triggeredAtMeta);
    }
    if (data.containsKey('dismissed')) {
      context.handle(_dismissedMeta,
          dismissed.isAcceptableOrUnknown(data['dismissed']!, _dismissedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Milestone map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Milestone(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      orchidId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}orchid_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      message: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message'])!,
      triggeredAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}triggered_at'])!,
      dismissed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}dismissed'])!,
    );
  }

  @override
  $MilestonesTable createAlias(String alias) {
    return $MilestonesTable(attachedDatabase, alias);
  }
}

class Milestone extends DataClass implements Insertable<Milestone> {
  final int id;
  final int orchidId;
  final String type;
  final String message;
  final DateTime triggeredAt;
  final bool dismissed;
  const Milestone(
      {required this.id,
      required this.orchidId,
      required this.type,
      required this.message,
      required this.triggeredAt,
      required this.dismissed});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['orchid_id'] = Variable<int>(orchidId);
    map['type'] = Variable<String>(type);
    map['message'] = Variable<String>(message);
    map['triggered_at'] = Variable<DateTime>(triggeredAt);
    map['dismissed'] = Variable<bool>(dismissed);
    return map;
  }

  MilestonesCompanion toCompanion(bool nullToAbsent) {
    return MilestonesCompanion(
      id: Value(id),
      orchidId: Value(orchidId),
      type: Value(type),
      message: Value(message),
      triggeredAt: Value(triggeredAt),
      dismissed: Value(dismissed),
    );
  }

  factory Milestone.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Milestone(
      id: serializer.fromJson<int>(json['id']),
      orchidId: serializer.fromJson<int>(json['orchidId']),
      type: serializer.fromJson<String>(json['type']),
      message: serializer.fromJson<String>(json['message']),
      triggeredAt: serializer.fromJson<DateTime>(json['triggeredAt']),
      dismissed: serializer.fromJson<bool>(json['dismissed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orchidId': serializer.toJson<int>(orchidId),
      'type': serializer.toJson<String>(type),
      'message': serializer.toJson<String>(message),
      'triggeredAt': serializer.toJson<DateTime>(triggeredAt),
      'dismissed': serializer.toJson<bool>(dismissed),
    };
  }

  Milestone copyWith(
          {int? id,
          int? orchidId,
          String? type,
          String? message,
          DateTime? triggeredAt,
          bool? dismissed}) =>
      Milestone(
        id: id ?? this.id,
        orchidId: orchidId ?? this.orchidId,
        type: type ?? this.type,
        message: message ?? this.message,
        triggeredAt: triggeredAt ?? this.triggeredAt,
        dismissed: dismissed ?? this.dismissed,
      );
  @override
  String toString() {
    return (StringBuffer('Milestone(')
          ..write('id: $id, ')
          ..write('orchidId: $orchidId, ')
          ..write('type: $type, ')
          ..write('message: $message, ')
          ..write('triggeredAt: $triggeredAt, ')
          ..write('dismissed: $dismissed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, orchidId, type, message, triggeredAt, dismissed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Milestone &&
          other.id == this.id &&
          other.orchidId == this.orchidId &&
          other.type == this.type &&
          other.message == this.message &&
          other.triggeredAt == this.triggeredAt &&
          other.dismissed == this.dismissed);
}

class MilestonesCompanion extends UpdateCompanion<Milestone> {
  final Value<int> id;
  final Value<int> orchidId;
  final Value<String> type;
  final Value<String> message;
  final Value<DateTime> triggeredAt;
  final Value<bool> dismissed;
  const MilestonesCompanion({
    this.id = const Value.absent(),
    this.orchidId = const Value.absent(),
    this.type = const Value.absent(),
    this.message = const Value.absent(),
    this.triggeredAt = const Value.absent(),
    this.dismissed = const Value.absent(),
  });
  MilestonesCompanion.insert({
    this.id = const Value.absent(),
    required int orchidId,
    required String type,
    required String message,
    required DateTime triggeredAt,
    this.dismissed = const Value.absent(),
  })  : orchidId = Value(orchidId),
        type = Value(type),
        message = Value(message),
        triggeredAt = Value(triggeredAt);
  static Insertable<Milestone> custom({
    Expression<int>? id,
    Expression<int>? orchidId,
    Expression<String>? type,
    Expression<String>? message,
    Expression<DateTime>? triggeredAt,
    Expression<bool>? dismissed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orchidId != null) 'orchid_id': orchidId,
      if (type != null) 'type': type,
      if (message != null) 'message': message,
      if (triggeredAt != null) 'triggered_at': triggeredAt,
      if (dismissed != null) 'dismissed': dismissed,
    });
  }

  MilestonesCompanion copyWith(
      {Value<int>? id,
      Value<int>? orchidId,
      Value<String>? type,
      Value<String>? message,
      Value<DateTime>? triggeredAt,
      Value<bool>? dismissed}) {
    return MilestonesCompanion(
      id: id ?? this.id,
      orchidId: orchidId ?? this.orchidId,
      type: type ?? this.type,
      message: message ?? this.message,
      triggeredAt: triggeredAt ?? this.triggeredAt,
      dismissed: dismissed ?? this.dismissed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orchidId.present) {
      map['orchid_id'] = Variable<int>(orchidId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (triggeredAt.present) {
      map['triggered_at'] = Variable<DateTime>(triggeredAt.value);
    }
    if (dismissed.present) {
      map['dismissed'] = Variable<bool>(dismissed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MilestonesCompanion(')
          ..write('id: $id, ')
          ..write('orchidId: $orchidId, ')
          ..write('type: $type, ')
          ..write('message: $message, ')
          ..write('triggeredAt: $triggeredAt, ')
          ..write('dismissed: $dismissed')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  _$AppDatabaseManager get managers => _$AppDatabaseManager(this);
  late final $OrchidsTable orchids = $OrchidsTable(this);
  late final $CareTasksTable careTasks = $CareTasksTable(this);
  late final $CareLogsTable careLogs = $CareLogsTable(this);
  late final $LightReadingsTable lightReadings = $LightReadingsTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $SoakSessionsTable soakSessions = $SoakSessionsTable(this);
  late final $SoakSessionTasksTable soakSessionTasks =
      $SoakSessionTasksTable(this);
  late final $BloomLogsTable bloomLogs = $BloomLogsTable(this);
  late final $PhotoJournalTable photoJournal = $PhotoJournalTable(this);
  late final $SpeciesProfilesTable speciesProfiles =
      $SpeciesProfilesTable(this);
  late final $GrowingLocationsTable growingLocations =
      $GrowingLocationsTable(this);
  late final $MilestonesTable milestones = $MilestonesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        orchids,
        careTasks,
        careLogs,
        lightReadings,
        settings,
        soakSessions,
        soakSessionTasks,
        bloomLogs,
        photoJournal,
        speciesProfiles,
        growingLocations,
        milestones
      ];
}

typedef $$OrchidsTableInsertCompanionBuilder = OrchidsCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> variety,
  Value<String?> location,
  Value<String?> photoPath,
  Value<String?> notes,
  Value<DateTime?> dateAcquired,
  Value<DateTime> createdAt,
  Value<bool> isDemo,
  Value<int> soakDurationMinutes,
  Value<BloomStage?> currentBloomStage,
  Value<DateTime?> lastPotted,
  Value<bool> isRescue,
  Value<int?> speciesProfileId,
  Value<int?> growingLocationId,
});
typedef $$OrchidsTableUpdateCompanionBuilder = OrchidsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> variety,
  Value<String?> location,
  Value<String?> photoPath,
  Value<String?> notes,
  Value<DateTime?> dateAcquired,
  Value<DateTime> createdAt,
  Value<bool> isDemo,
  Value<int> soakDurationMinutes,
  Value<BloomStage?> currentBloomStage,
  Value<DateTime?> lastPotted,
  Value<bool> isRescue,
  Value<int?> speciesProfileId,
  Value<int?> growingLocationId,
});

class $$OrchidsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OrchidsTable,
    Orchid,
    $$OrchidsTableFilterComposer,
    $$OrchidsTableOrderingComposer,
    $$OrchidsTableProcessedTableManager,
    $$OrchidsTableInsertCompanionBuilder,
    $$OrchidsTableUpdateCompanionBuilder> {
  $$OrchidsTableTableManager(_$AppDatabase db, $OrchidsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$OrchidsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$OrchidsTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) => $$OrchidsTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> variety = const Value.absent(),
            Value<String?> location = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime?> dateAcquired = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> isDemo = const Value.absent(),
            Value<int> soakDurationMinutes = const Value.absent(),
            Value<BloomStage?> currentBloomStage = const Value.absent(),
            Value<DateTime?> lastPotted = const Value.absent(),
            Value<bool> isRescue = const Value.absent(),
            Value<int?> speciesProfileId = const Value.absent(),
            Value<int?> growingLocationId = const Value.absent(),
          }) =>
              OrchidsCompanion(
            id: id,
            name: name,
            variety: variety,
            location: location,
            photoPath: photoPath,
            notes: notes,
            dateAcquired: dateAcquired,
            createdAt: createdAt,
            isDemo: isDemo,
            soakDurationMinutes: soakDurationMinutes,
            currentBloomStage: currentBloomStage,
            lastPotted: lastPotted,
            isRescue: isRescue,
            speciesProfileId: speciesProfileId,
            growingLocationId: growingLocationId,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> variety = const Value.absent(),
            Value<String?> location = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime?> dateAcquired = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> isDemo = const Value.absent(),
            Value<int> soakDurationMinutes = const Value.absent(),
            Value<BloomStage?> currentBloomStage = const Value.absent(),
            Value<DateTime?> lastPotted = const Value.absent(),
            Value<bool> isRescue = const Value.absent(),
            Value<int?> speciesProfileId = const Value.absent(),
            Value<int?> growingLocationId = const Value.absent(),
          }) =>
              OrchidsCompanion.insert(
            id: id,
            name: name,
            variety: variety,
            location: location,
            photoPath: photoPath,
            notes: notes,
            dateAcquired: dateAcquired,
            createdAt: createdAt,
            isDemo: isDemo,
            soakDurationMinutes: soakDurationMinutes,
            currentBloomStage: currentBloomStage,
            lastPotted: lastPotted,
            isRescue: isRescue,
            speciesProfileId: speciesProfileId,
            growingLocationId: growingLocationId,
          ),
        ));
}

class $$OrchidsTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $OrchidsTable,
    Orchid,
    $$OrchidsTableFilterComposer,
    $$OrchidsTableOrderingComposer,
    $$OrchidsTableProcessedTableManager,
    $$OrchidsTableInsertCompanionBuilder,
    $$OrchidsTableUpdateCompanionBuilder> {
  $$OrchidsTableProcessedTableManager(super.$state);
}

class $$OrchidsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $OrchidsTable> {
  $$OrchidsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get variety => $state.composableBuilder(
      column: $state.table.variety,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get location => $state.composableBuilder(
      column: $state.table.location,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get photoPath => $state.composableBuilder(
      column: $state.table.photoPath,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get dateAcquired => $state.composableBuilder(
      column: $state.table.dateAcquired,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isDemo => $state.composableBuilder(
      column: $state.table.isDemo,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get soakDurationMinutes => $state.composableBuilder(
      column: $state.table.soakDurationMinutes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<BloomStage?, BloomStage, String>
      get currentBloomStage => $state.composableBuilder(
          column: $state.table.currentBloomStage,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get lastPotted => $state.composableBuilder(
      column: $state.table.lastPotted,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isRescue => $state.composableBuilder(
      column: $state.table.isRescue,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get speciesProfileId => $state.composableBuilder(
      column: $state.table.speciesProfileId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get growingLocationId => $state.composableBuilder(
      column: $state.table.growingLocationId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter careTasksRefs(
      ComposableFilter Function($$CareTasksTableFilterComposer f) f) {
    final $$CareTasksTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.careTasks,
        getReferencedColumn: (t) => t.orchidId,
        builder: (joinBuilder, parentComposers) =>
            $$CareTasksTableFilterComposer(ComposerState(
                $state.db, $state.db.careTasks, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter careLogsRefs(
      ComposableFilter Function($$CareLogsTableFilterComposer f) f) {
    final $$CareLogsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.careLogs,
        getReferencedColumn: (t) => t.orchidId,
        builder: (joinBuilder, parentComposers) =>
            $$CareLogsTableFilterComposer(ComposerState(
                $state.db, $state.db.careLogs, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter lightReadingsRefs(
      ComposableFilter Function($$LightReadingsTableFilterComposer f) f) {
    final $$LightReadingsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.lightReadings,
        getReferencedColumn: (t) => t.orchidId,
        builder: (joinBuilder, parentComposers) =>
            $$LightReadingsTableFilterComposer(ComposerState($state.db,
                $state.db.lightReadings, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter soakSessionTasksRefs(
      ComposableFilter Function($$SoakSessionTasksTableFilterComposer f) f) {
    final $$SoakSessionTasksTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $state.db.soakSessionTasks,
            getReferencedColumn: (t) => t.orchidId,
            builder: (joinBuilder, parentComposers) =>
                $$SoakSessionTasksTableFilterComposer(ComposerState($state.db,
                    $state.db.soakSessionTasks, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter bloomLogsRefs(
      ComposableFilter Function($$BloomLogsTableFilterComposer f) f) {
    final $$BloomLogsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.bloomLogs,
        getReferencedColumn: (t) => t.orchidId,
        builder: (joinBuilder, parentComposers) =>
            $$BloomLogsTableFilterComposer(ComposerState(
                $state.db, $state.db.bloomLogs, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter photoJournalRefs(
      ComposableFilter Function($$PhotoJournalTableFilterComposer f) f) {
    final $$PhotoJournalTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.photoJournal,
        getReferencedColumn: (t) => t.orchidId,
        builder: (joinBuilder, parentComposers) =>
            $$PhotoJournalTableFilterComposer(ComposerState($state.db,
                $state.db.photoJournal, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter milestonesRefs(
      ComposableFilter Function($$MilestonesTableFilterComposer f) f) {
    final $$MilestonesTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.milestones,
        getReferencedColumn: (t) => t.orchidId,
        builder: (joinBuilder, parentComposers) =>
            $$MilestonesTableFilterComposer(ComposerState($state.db,
                $state.db.milestones, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$OrchidsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $OrchidsTable> {
  $$OrchidsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get variety => $state.composableBuilder(
      column: $state.table.variety,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get location => $state.composableBuilder(
      column: $state.table.location,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get photoPath => $state.composableBuilder(
      column: $state.table.photoPath,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get dateAcquired => $state.composableBuilder(
      column: $state.table.dateAcquired,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isDemo => $state.composableBuilder(
      column: $state.table.isDemo,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get soakDurationMinutes => $state.composableBuilder(
      column: $state.table.soakDurationMinutes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get currentBloomStage => $state.composableBuilder(
      column: $state.table.currentBloomStage,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get lastPotted => $state.composableBuilder(
      column: $state.table.lastPotted,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isRescue => $state.composableBuilder(
      column: $state.table.isRescue,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get speciesProfileId => $state.composableBuilder(
      column: $state.table.speciesProfileId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get growingLocationId => $state.composableBuilder(
      column: $state.table.growingLocationId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$CareTasksTableInsertCompanionBuilder = CareTasksCompanion Function({
  Value<int> id,
  required int orchidId,
  required CareType careType,
  required int intervalDays,
  Value<DateTime?> lastCompleted,
  required DateTime nextDue,
  Value<bool> enabled,
  Value<String?> customLabel,
  Value<int> notifyHour,
  Value<int> notifyMinute,
});
typedef $$CareTasksTableUpdateCompanionBuilder = CareTasksCompanion Function({
  Value<int> id,
  Value<int> orchidId,
  Value<CareType> careType,
  Value<int> intervalDays,
  Value<DateTime?> lastCompleted,
  Value<DateTime> nextDue,
  Value<bool> enabled,
  Value<String?> customLabel,
  Value<int> notifyHour,
  Value<int> notifyMinute,
});

class $$CareTasksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CareTasksTable,
    CareTask,
    $$CareTasksTableFilterComposer,
    $$CareTasksTableOrderingComposer,
    $$CareTasksTableProcessedTableManager,
    $$CareTasksTableInsertCompanionBuilder,
    $$CareTasksTableUpdateCompanionBuilder> {
  $$CareTasksTableTableManager(_$AppDatabase db, $CareTasksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$CareTasksTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$CareTasksTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$CareTasksTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<int> orchidId = const Value.absent(),
            Value<CareType> careType = const Value.absent(),
            Value<int> intervalDays = const Value.absent(),
            Value<DateTime?> lastCompleted = const Value.absent(),
            Value<DateTime> nextDue = const Value.absent(),
            Value<bool> enabled = const Value.absent(),
            Value<String?> customLabel = const Value.absent(),
            Value<int> notifyHour = const Value.absent(),
            Value<int> notifyMinute = const Value.absent(),
          }) =>
              CareTasksCompanion(
            id: id,
            orchidId: orchidId,
            careType: careType,
            intervalDays: intervalDays,
            lastCompleted: lastCompleted,
            nextDue: nextDue,
            enabled: enabled,
            customLabel: customLabel,
            notifyHour: notifyHour,
            notifyMinute: notifyMinute,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required int orchidId,
            required CareType careType,
            required int intervalDays,
            Value<DateTime?> lastCompleted = const Value.absent(),
            required DateTime nextDue,
            Value<bool> enabled = const Value.absent(),
            Value<String?> customLabel = const Value.absent(),
            Value<int> notifyHour = const Value.absent(),
            Value<int> notifyMinute = const Value.absent(),
          }) =>
              CareTasksCompanion.insert(
            id: id,
            orchidId: orchidId,
            careType: careType,
            intervalDays: intervalDays,
            lastCompleted: lastCompleted,
            nextDue: nextDue,
            enabled: enabled,
            customLabel: customLabel,
            notifyHour: notifyHour,
            notifyMinute: notifyMinute,
          ),
        ));
}

class $$CareTasksTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $CareTasksTable,
    CareTask,
    $$CareTasksTableFilterComposer,
    $$CareTasksTableOrderingComposer,
    $$CareTasksTableProcessedTableManager,
    $$CareTasksTableInsertCompanionBuilder,
    $$CareTasksTableUpdateCompanionBuilder> {
  $$CareTasksTableProcessedTableManager(super.$state);
}

class $$CareTasksTableFilterComposer
    extends FilterComposer<_$AppDatabase, $CareTasksTable> {
  $$CareTasksTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<CareType, CareType, String> get careType =>
      $state.composableBuilder(
          column: $state.table.careType,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<int> get intervalDays => $state.composableBuilder(
      column: $state.table.intervalDays,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get lastCompleted => $state.composableBuilder(
      column: $state.table.lastCompleted,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get nextDue => $state.composableBuilder(
      column: $state.table.nextDue,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get enabled => $state.composableBuilder(
      column: $state.table.enabled,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get customLabel => $state.composableBuilder(
      column: $state.table.customLabel,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get notifyHour => $state.composableBuilder(
      column: $state.table.notifyHour,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get notifyMinute => $state.composableBuilder(
      column: $state.table.notifyMinute,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$OrchidsTableFilterComposer get orchidId {
    final $$OrchidsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orchidId,
        referencedTable: $state.db.orchids,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$OrchidsTableFilterComposer(
            ComposerState(
                $state.db, $state.db.orchids, joinBuilder, parentComposers)));
    return composer;
  }

  ComposableFilter careLogsRefs(
      ComposableFilter Function($$CareLogsTableFilterComposer f) f) {
    final $$CareLogsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.careLogs,
        getReferencedColumn: (t) => t.careTaskId,
        builder: (joinBuilder, parentComposers) =>
            $$CareLogsTableFilterComposer(ComposerState(
                $state.db, $state.db.careLogs, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter soakSessionTasksRefs(
      ComposableFilter Function($$SoakSessionTasksTableFilterComposer f) f) {
    final $$SoakSessionTasksTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $state.db.soakSessionTasks,
            getReferencedColumn: (t) => t.careTaskId,
            builder: (joinBuilder, parentComposers) =>
                $$SoakSessionTasksTableFilterComposer(ComposerState($state.db,
                    $state.db.soakSessionTasks, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$CareTasksTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $CareTasksTable> {
  $$CareTasksTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get careType => $state.composableBuilder(
      column: $state.table.careType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get intervalDays => $state.composableBuilder(
      column: $state.table.intervalDays,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get lastCompleted => $state.composableBuilder(
      column: $state.table.lastCompleted,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get nextDue => $state.composableBuilder(
      column: $state.table.nextDue,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get enabled => $state.composableBuilder(
      column: $state.table.enabled,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get customLabel => $state.composableBuilder(
      column: $state.table.customLabel,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get notifyHour => $state.composableBuilder(
      column: $state.table.notifyHour,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get notifyMinute => $state.composableBuilder(
      column: $state.table.notifyMinute,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$OrchidsTableOrderingComposer get orchidId {
    final $$OrchidsTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orchidId,
        referencedTable: $state.db.orchids,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$OrchidsTableOrderingComposer(ComposerState(
                $state.db, $state.db.orchids, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$CareLogsTableInsertCompanionBuilder = CareLogsCompanion Function({
  Value<int> id,
  required int orchidId,
  Value<int?> careTaskId,
  required CareType careType,
  required DateTime completedAt,
  Value<String?> notes,
  Value<bool> skipped,
});
typedef $$CareLogsTableUpdateCompanionBuilder = CareLogsCompanion Function({
  Value<int> id,
  Value<int> orchidId,
  Value<int?> careTaskId,
  Value<CareType> careType,
  Value<DateTime> completedAt,
  Value<String?> notes,
  Value<bool> skipped,
});

class $$CareLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CareLogsTable,
    CareLog,
    $$CareLogsTableFilterComposer,
    $$CareLogsTableOrderingComposer,
    $$CareLogsTableProcessedTableManager,
    $$CareLogsTableInsertCompanionBuilder,
    $$CareLogsTableUpdateCompanionBuilder> {
  $$CareLogsTableTableManager(_$AppDatabase db, $CareLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$CareLogsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$CareLogsTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$CareLogsTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<int> orchidId = const Value.absent(),
            Value<int?> careTaskId = const Value.absent(),
            Value<CareType> careType = const Value.absent(),
            Value<DateTime> completedAt = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> skipped = const Value.absent(),
          }) =>
              CareLogsCompanion(
            id: id,
            orchidId: orchidId,
            careTaskId: careTaskId,
            careType: careType,
            completedAt: completedAt,
            notes: notes,
            skipped: skipped,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required int orchidId,
            Value<int?> careTaskId = const Value.absent(),
            required CareType careType,
            required DateTime completedAt,
            Value<String?> notes = const Value.absent(),
            Value<bool> skipped = const Value.absent(),
          }) =>
              CareLogsCompanion.insert(
            id: id,
            orchidId: orchidId,
            careTaskId: careTaskId,
            careType: careType,
            completedAt: completedAt,
            notes: notes,
            skipped: skipped,
          ),
        ));
}

class $$CareLogsTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $CareLogsTable,
    CareLog,
    $$CareLogsTableFilterComposer,
    $$CareLogsTableOrderingComposer,
    $$CareLogsTableProcessedTableManager,
    $$CareLogsTableInsertCompanionBuilder,
    $$CareLogsTableUpdateCompanionBuilder> {
  $$CareLogsTableProcessedTableManager(super.$state);
}

class $$CareLogsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $CareLogsTable> {
  $$CareLogsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<CareType, CareType, String> get careType =>
      $state.composableBuilder(
          column: $state.table.careType,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get completedAt => $state.composableBuilder(
      column: $state.table.completedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get skipped => $state.composableBuilder(
      column: $state.table.skipped,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$OrchidsTableFilterComposer get orchidId {
    final $$OrchidsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orchidId,
        referencedTable: $state.db.orchids,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$OrchidsTableFilterComposer(
            ComposerState(
                $state.db, $state.db.orchids, joinBuilder, parentComposers)));
    return composer;
  }

  $$CareTasksTableFilterComposer get careTaskId {
    final $$CareTasksTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.careTaskId,
        referencedTable: $state.db.careTasks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$CareTasksTableFilterComposer(ComposerState(
                $state.db, $state.db.careTasks, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$CareLogsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $CareLogsTable> {
  $$CareLogsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get careType => $state.composableBuilder(
      column: $state.table.careType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get completedAt => $state.composableBuilder(
      column: $state.table.completedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get skipped => $state.composableBuilder(
      column: $state.table.skipped,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$OrchidsTableOrderingComposer get orchidId {
    final $$OrchidsTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orchidId,
        referencedTable: $state.db.orchids,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$OrchidsTableOrderingComposer(ComposerState(
                $state.db, $state.db.orchids, joinBuilder, parentComposers)));
    return composer;
  }

  $$CareTasksTableOrderingComposer get careTaskId {
    final $$CareTasksTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.careTaskId,
        referencedTable: $state.db.careTasks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$CareTasksTableOrderingComposer(ComposerState(
                $state.db, $state.db.careTasks, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$LightReadingsTableInsertCompanionBuilder = LightReadingsCompanion
    Function({
  Value<int> id,
  Value<int?> orchidId,
  Value<String?> locationName,
  required double luxValue,
  required DateTime readingAt,
  Value<String?> notes,
});
typedef $$LightReadingsTableUpdateCompanionBuilder = LightReadingsCompanion
    Function({
  Value<int> id,
  Value<int?> orchidId,
  Value<String?> locationName,
  Value<double> luxValue,
  Value<DateTime> readingAt,
  Value<String?> notes,
});

class $$LightReadingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LightReadingsTable,
    LightReading,
    $$LightReadingsTableFilterComposer,
    $$LightReadingsTableOrderingComposer,
    $$LightReadingsTableProcessedTableManager,
    $$LightReadingsTableInsertCompanionBuilder,
    $$LightReadingsTableUpdateCompanionBuilder> {
  $$LightReadingsTableTableManager(_$AppDatabase db, $LightReadingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$LightReadingsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$LightReadingsTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$LightReadingsTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<int?> orchidId = const Value.absent(),
            Value<String?> locationName = const Value.absent(),
            Value<double> luxValue = const Value.absent(),
            Value<DateTime> readingAt = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              LightReadingsCompanion(
            id: id,
            orchidId: orchidId,
            locationName: locationName,
            luxValue: luxValue,
            readingAt: readingAt,
            notes: notes,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<int?> orchidId = const Value.absent(),
            Value<String?> locationName = const Value.absent(),
            required double luxValue,
            required DateTime readingAt,
            Value<String?> notes = const Value.absent(),
          }) =>
              LightReadingsCompanion.insert(
            id: id,
            orchidId: orchidId,
            locationName: locationName,
            luxValue: luxValue,
            readingAt: readingAt,
            notes: notes,
          ),
        ));
}

class $$LightReadingsTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $LightReadingsTable,
    LightReading,
    $$LightReadingsTableFilterComposer,
    $$LightReadingsTableOrderingComposer,
    $$LightReadingsTableProcessedTableManager,
    $$LightReadingsTableInsertCompanionBuilder,
    $$LightReadingsTableUpdateCompanionBuilder> {
  $$LightReadingsTableProcessedTableManager(super.$state);
}

class $$LightReadingsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $LightReadingsTable> {
  $$LightReadingsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get locationName => $state.composableBuilder(
      column: $state.table.locationName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get luxValue => $state.composableBuilder(
      column: $state.table.luxValue,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get readingAt => $state.composableBuilder(
      column: $state.table.readingAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$OrchidsTableFilterComposer get orchidId {
    final $$OrchidsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orchidId,
        referencedTable: $state.db.orchids,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$OrchidsTableFilterComposer(
            ComposerState(
                $state.db, $state.db.orchids, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$LightReadingsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $LightReadingsTable> {
  $$LightReadingsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get locationName => $state.composableBuilder(
      column: $state.table.locationName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get luxValue => $state.composableBuilder(
      column: $state.table.luxValue,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get readingAt => $state.composableBuilder(
      column: $state.table.readingAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$OrchidsTableOrderingComposer get orchidId {
    final $$OrchidsTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orchidId,
        referencedTable: $state.db.orchids,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$OrchidsTableOrderingComposer(ComposerState(
                $state.db, $state.db.orchids, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$SettingsTableInsertCompanionBuilder = SettingsCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$SettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SettingsTable,
    Setting,
    $$SettingsTableFilterComposer,
    $$SettingsTableOrderingComposer,
    $$SettingsTableProcessedTableManager,
    $$SettingsTableInsertCompanionBuilder,
    $$SettingsTableUpdateCompanionBuilder> {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$SettingsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$SettingsTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$SettingsTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SettingsCompanion(
            key: key,
            value: value,
            rowid: rowid,
          ),
          getInsertCompanionBuilder: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) =>
              SettingsCompanion.insert(
            key: key,
            value: value,
            rowid: rowid,
          ),
        ));
}

class $$SettingsTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $SettingsTable,
    Setting,
    $$SettingsTableFilterComposer,
    $$SettingsTableOrderingComposer,
    $$SettingsTableProcessedTableManager,
    $$SettingsTableInsertCompanionBuilder,
    $$SettingsTableUpdateCompanionBuilder> {
  $$SettingsTableProcessedTableManager(super.$state);
}

class $$SettingsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer(super.$state);
  ColumnFilters<String> get key => $state.composableBuilder(
      column: $state.table.key,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get value => $state.composableBuilder(
      column: $state.table.value,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$SettingsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get key => $state.composableBuilder(
      column: $state.table.key,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get value => $state.composableBuilder(
      column: $state.table.value,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$SoakSessionsTableInsertCompanionBuilder = SoakSessionsCompanion
    Function({
  Value<int> id,
  required DateTime startedAt,
  Value<int> durationMinutes,
  required SoakStatus status,
  Value<DateTime?> completedAt,
  required int notificationId,
});
typedef $$SoakSessionsTableUpdateCompanionBuilder = SoakSessionsCompanion
    Function({
  Value<int> id,
  Value<DateTime> startedAt,
  Value<int> durationMinutes,
  Value<SoakStatus> status,
  Value<DateTime?> completedAt,
  Value<int> notificationId,
});

class $$SoakSessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SoakSessionsTable,
    SoakSession,
    $$SoakSessionsTableFilterComposer,
    $$SoakSessionsTableOrderingComposer,
    $$SoakSessionsTableProcessedTableManager,
    $$SoakSessionsTableInsertCompanionBuilder,
    $$SoakSessionsTableUpdateCompanionBuilder> {
  $$SoakSessionsTableTableManager(_$AppDatabase db, $SoakSessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$SoakSessionsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$SoakSessionsTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$SoakSessionsTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> startedAt = const Value.absent(),
            Value<int> durationMinutes = const Value.absent(),
            Value<SoakStatus> status = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<int> notificationId = const Value.absent(),
          }) =>
              SoakSessionsCompanion(
            id: id,
            startedAt: startedAt,
            durationMinutes: durationMinutes,
            status: status,
            completedAt: completedAt,
            notificationId: notificationId,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required DateTime startedAt,
            Value<int> durationMinutes = const Value.absent(),
            required SoakStatus status,
            Value<DateTime?> completedAt = const Value.absent(),
            required int notificationId,
          }) =>
              SoakSessionsCompanion.insert(
            id: id,
            startedAt: startedAt,
            durationMinutes: durationMinutes,
            status: status,
            completedAt: completedAt,
            notificationId: notificationId,
          ),
        ));
}

class $$SoakSessionsTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $SoakSessionsTable,
    SoakSession,
    $$SoakSessionsTableFilterComposer,
    $$SoakSessionsTableOrderingComposer,
    $$SoakSessionsTableProcessedTableManager,
    $$SoakSessionsTableInsertCompanionBuilder,
    $$SoakSessionsTableUpdateCompanionBuilder> {
  $$SoakSessionsTableProcessedTableManager(super.$state);
}

class $$SoakSessionsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $SoakSessionsTable> {
  $$SoakSessionsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get startedAt => $state.composableBuilder(
      column: $state.table.startedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get durationMinutes => $state.composableBuilder(
      column: $state.table.durationMinutes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<SoakStatus, SoakStatus, String> get status =>
      $state.composableBuilder(
          column: $state.table.status,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get completedAt => $state.composableBuilder(
      column: $state.table.completedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get notificationId => $state.composableBuilder(
      column: $state.table.notificationId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter soakSessionTasksRefs(
      ComposableFilter Function($$SoakSessionTasksTableFilterComposer f) f) {
    final $$SoakSessionTasksTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $state.db.soakSessionTasks,
            getReferencedColumn: (t) => t.soakSessionId,
            builder: (joinBuilder, parentComposers) =>
                $$SoakSessionTasksTableFilterComposer(ComposerState($state.db,
                    $state.db.soakSessionTasks, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$SoakSessionsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $SoakSessionsTable> {
  $$SoakSessionsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get startedAt => $state.composableBuilder(
      column: $state.table.startedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get durationMinutes => $state.composableBuilder(
      column: $state.table.durationMinutes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get completedAt => $state.composableBuilder(
      column: $state.table.completedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get notificationId => $state.composableBuilder(
      column: $state.table.notificationId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$SoakSessionTasksTableInsertCompanionBuilder
    = SoakSessionTasksCompanion Function({
  Value<int> id,
  required int soakSessionId,
  required int careTaskId,
  required int orchidId,
});
typedef $$SoakSessionTasksTableUpdateCompanionBuilder
    = SoakSessionTasksCompanion Function({
  Value<int> id,
  Value<int> soakSessionId,
  Value<int> careTaskId,
  Value<int> orchidId,
});

class $$SoakSessionTasksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SoakSessionTasksTable,
    SoakSessionTask,
    $$SoakSessionTasksTableFilterComposer,
    $$SoakSessionTasksTableOrderingComposer,
    $$SoakSessionTasksTableProcessedTableManager,
    $$SoakSessionTasksTableInsertCompanionBuilder,
    $$SoakSessionTasksTableUpdateCompanionBuilder> {
  $$SoakSessionTasksTableTableManager(
      _$AppDatabase db, $SoakSessionTasksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$SoakSessionTasksTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$SoakSessionTasksTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$SoakSessionTasksTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<int> soakSessionId = const Value.absent(),
            Value<int> careTaskId = const Value.absent(),
            Value<int> orchidId = const Value.absent(),
          }) =>
              SoakSessionTasksCompanion(
            id: id,
            soakSessionId: soakSessionId,
            careTaskId: careTaskId,
            orchidId: orchidId,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required int soakSessionId,
            required int careTaskId,
            required int orchidId,
          }) =>
              SoakSessionTasksCompanion.insert(
            id: id,
            soakSessionId: soakSessionId,
            careTaskId: careTaskId,
            orchidId: orchidId,
          ),
        ));
}

class $$SoakSessionTasksTableProcessedTableManager
    extends ProcessedTableManager<
        _$AppDatabase,
        $SoakSessionTasksTable,
        SoakSessionTask,
        $$SoakSessionTasksTableFilterComposer,
        $$SoakSessionTasksTableOrderingComposer,
        $$SoakSessionTasksTableProcessedTableManager,
        $$SoakSessionTasksTableInsertCompanionBuilder,
        $$SoakSessionTasksTableUpdateCompanionBuilder> {
  $$SoakSessionTasksTableProcessedTableManager(super.$state);
}

class $$SoakSessionTasksTableFilterComposer
    extends FilterComposer<_$AppDatabase, $SoakSessionTasksTable> {
  $$SoakSessionTasksTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$SoakSessionsTableFilterComposer get soakSessionId {
    final $$SoakSessionsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.soakSessionId,
        referencedTable: $state.db.soakSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$SoakSessionsTableFilterComposer(ComposerState($state.db,
                $state.db.soakSessions, joinBuilder, parentComposers)));
    return composer;
  }

  $$CareTasksTableFilterComposer get careTaskId {
    final $$CareTasksTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.careTaskId,
        referencedTable: $state.db.careTasks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$CareTasksTableFilterComposer(ComposerState(
                $state.db, $state.db.careTasks, joinBuilder, parentComposers)));
    return composer;
  }

  $$OrchidsTableFilterComposer get orchidId {
    final $$OrchidsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orchidId,
        referencedTable: $state.db.orchids,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$OrchidsTableFilterComposer(
            ComposerState(
                $state.db, $state.db.orchids, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$SoakSessionTasksTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $SoakSessionTasksTable> {
  $$SoakSessionTasksTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$SoakSessionsTableOrderingComposer get soakSessionId {
    final $$SoakSessionsTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.soakSessionId,
        referencedTable: $state.db.soakSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$SoakSessionsTableOrderingComposer(ComposerState($state.db,
                $state.db.soakSessions, joinBuilder, parentComposers)));
    return composer;
  }

  $$CareTasksTableOrderingComposer get careTaskId {
    final $$CareTasksTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.careTaskId,
        referencedTable: $state.db.careTasks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$CareTasksTableOrderingComposer(ComposerState(
                $state.db, $state.db.careTasks, joinBuilder, parentComposers)));
    return composer;
  }

  $$OrchidsTableOrderingComposer get orchidId {
    final $$OrchidsTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orchidId,
        referencedTable: $state.db.orchids,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$OrchidsTableOrderingComposer(ComposerState(
                $state.db, $state.db.orchids, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$BloomLogsTableInsertCompanionBuilder = BloomLogsCompanion Function({
  Value<int> id,
  required int orchidId,
  required BloomStage stage,
  required DateTime dateLogged,
  Value<String?> notes,
  Value<String?> photoPath,
});
typedef $$BloomLogsTableUpdateCompanionBuilder = BloomLogsCompanion Function({
  Value<int> id,
  Value<int> orchidId,
  Value<BloomStage> stage,
  Value<DateTime> dateLogged,
  Value<String?> notes,
  Value<String?> photoPath,
});

class $$BloomLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BloomLogsTable,
    BloomLog,
    $$BloomLogsTableFilterComposer,
    $$BloomLogsTableOrderingComposer,
    $$BloomLogsTableProcessedTableManager,
    $$BloomLogsTableInsertCompanionBuilder,
    $$BloomLogsTableUpdateCompanionBuilder> {
  $$BloomLogsTableTableManager(_$AppDatabase db, $BloomLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$BloomLogsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$BloomLogsTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$BloomLogsTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<int> orchidId = const Value.absent(),
            Value<BloomStage> stage = const Value.absent(),
            Value<DateTime> dateLogged = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
          }) =>
              BloomLogsCompanion(
            id: id,
            orchidId: orchidId,
            stage: stage,
            dateLogged: dateLogged,
            notes: notes,
            photoPath: photoPath,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required int orchidId,
            required BloomStage stage,
            required DateTime dateLogged,
            Value<String?> notes = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
          }) =>
              BloomLogsCompanion.insert(
            id: id,
            orchidId: orchidId,
            stage: stage,
            dateLogged: dateLogged,
            notes: notes,
            photoPath: photoPath,
          ),
        ));
}

class $$BloomLogsTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $BloomLogsTable,
    BloomLog,
    $$BloomLogsTableFilterComposer,
    $$BloomLogsTableOrderingComposer,
    $$BloomLogsTableProcessedTableManager,
    $$BloomLogsTableInsertCompanionBuilder,
    $$BloomLogsTableUpdateCompanionBuilder> {
  $$BloomLogsTableProcessedTableManager(super.$state);
}

class $$BloomLogsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $BloomLogsTable> {
  $$BloomLogsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<BloomStage, BloomStage, String> get stage =>
      $state.composableBuilder(
          column: $state.table.stage,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get dateLogged => $state.composableBuilder(
      column: $state.table.dateLogged,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get photoPath => $state.composableBuilder(
      column: $state.table.photoPath,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$OrchidsTableFilterComposer get orchidId {
    final $$OrchidsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orchidId,
        referencedTable: $state.db.orchids,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$OrchidsTableFilterComposer(
            ComposerState(
                $state.db, $state.db.orchids, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$BloomLogsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $BloomLogsTable> {
  $$BloomLogsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get stage => $state.composableBuilder(
      column: $state.table.stage,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get dateLogged => $state.composableBuilder(
      column: $state.table.dateLogged,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get photoPath => $state.composableBuilder(
      column: $state.table.photoPath,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$OrchidsTableOrderingComposer get orchidId {
    final $$OrchidsTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orchidId,
        referencedTable: $state.db.orchids,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$OrchidsTableOrderingComposer(ComposerState(
                $state.db, $state.db.orchids, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$PhotoJournalTableInsertCompanionBuilder = PhotoJournalCompanion
    Function({
  Value<int> id,
  required int orchidId,
  required String photoPath,
  required DateTime dateTaken,
  Value<String?> note,
  required PhotoTag tag,
});
typedef $$PhotoJournalTableUpdateCompanionBuilder = PhotoJournalCompanion
    Function({
  Value<int> id,
  Value<int> orchidId,
  Value<String> photoPath,
  Value<DateTime> dateTaken,
  Value<String?> note,
  Value<PhotoTag> tag,
});

class $$PhotoJournalTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PhotoJournalTable,
    PhotoJournalData,
    $$PhotoJournalTableFilterComposer,
    $$PhotoJournalTableOrderingComposer,
    $$PhotoJournalTableProcessedTableManager,
    $$PhotoJournalTableInsertCompanionBuilder,
    $$PhotoJournalTableUpdateCompanionBuilder> {
  $$PhotoJournalTableTableManager(_$AppDatabase db, $PhotoJournalTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$PhotoJournalTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$PhotoJournalTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$PhotoJournalTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<int> orchidId = const Value.absent(),
            Value<String> photoPath = const Value.absent(),
            Value<DateTime> dateTaken = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<PhotoTag> tag = const Value.absent(),
          }) =>
              PhotoJournalCompanion(
            id: id,
            orchidId: orchidId,
            photoPath: photoPath,
            dateTaken: dateTaken,
            note: note,
            tag: tag,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required int orchidId,
            required String photoPath,
            required DateTime dateTaken,
            Value<String?> note = const Value.absent(),
            required PhotoTag tag,
          }) =>
              PhotoJournalCompanion.insert(
            id: id,
            orchidId: orchidId,
            photoPath: photoPath,
            dateTaken: dateTaken,
            note: note,
            tag: tag,
          ),
        ));
}

class $$PhotoJournalTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $PhotoJournalTable,
    PhotoJournalData,
    $$PhotoJournalTableFilterComposer,
    $$PhotoJournalTableOrderingComposer,
    $$PhotoJournalTableProcessedTableManager,
    $$PhotoJournalTableInsertCompanionBuilder,
    $$PhotoJournalTableUpdateCompanionBuilder> {
  $$PhotoJournalTableProcessedTableManager(super.$state);
}

class $$PhotoJournalTableFilterComposer
    extends FilterComposer<_$AppDatabase, $PhotoJournalTable> {
  $$PhotoJournalTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get photoPath => $state.composableBuilder(
      column: $state.table.photoPath,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get dateTaken => $state.composableBuilder(
      column: $state.table.dateTaken,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get note => $state.composableBuilder(
      column: $state.table.note,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<PhotoTag, PhotoTag, String> get tag =>
      $state.composableBuilder(
          column: $state.table.tag,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  $$OrchidsTableFilterComposer get orchidId {
    final $$OrchidsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orchidId,
        referencedTable: $state.db.orchids,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$OrchidsTableFilterComposer(
            ComposerState(
                $state.db, $state.db.orchids, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$PhotoJournalTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $PhotoJournalTable> {
  $$PhotoJournalTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get photoPath => $state.composableBuilder(
      column: $state.table.photoPath,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get dateTaken => $state.composableBuilder(
      column: $state.table.dateTaken,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get note => $state.composableBuilder(
      column: $state.table.note,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get tag => $state.composableBuilder(
      column: $state.table.tag,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$OrchidsTableOrderingComposer get orchidId {
    final $$OrchidsTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orchidId,
        referencedTable: $state.db.orchids,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$OrchidsTableOrderingComposer(ComposerState(
                $state.db, $state.db.orchids, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$SpeciesProfilesTableInsertCompanionBuilder = SpeciesProfilesCompanion
    Function({
  Value<int> id,
  required String commonName,
  required String genus,
  Value<String?> species,
  Value<int?> idealLuxMin,
  Value<int?> idealLuxMax,
  Value<int?> tempMinF,
  Value<int?> tempMaxF,
  Value<int?> tempNightDropF,
  Value<String?> humidity,
  Value<String?> bloomSeason,
  Value<String?> wateringNotes,
  Value<String?> fertilizingNotes,
  Value<String?> difficultyLevel,
  Value<String?> description,
});
typedef $$SpeciesProfilesTableUpdateCompanionBuilder = SpeciesProfilesCompanion
    Function({
  Value<int> id,
  Value<String> commonName,
  Value<String> genus,
  Value<String?> species,
  Value<int?> idealLuxMin,
  Value<int?> idealLuxMax,
  Value<int?> tempMinF,
  Value<int?> tempMaxF,
  Value<int?> tempNightDropF,
  Value<String?> humidity,
  Value<String?> bloomSeason,
  Value<String?> wateringNotes,
  Value<String?> fertilizingNotes,
  Value<String?> difficultyLevel,
  Value<String?> description,
});

class $$SpeciesProfilesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SpeciesProfilesTable,
    SpeciesProfile,
    $$SpeciesProfilesTableFilterComposer,
    $$SpeciesProfilesTableOrderingComposer,
    $$SpeciesProfilesTableProcessedTableManager,
    $$SpeciesProfilesTableInsertCompanionBuilder,
    $$SpeciesProfilesTableUpdateCompanionBuilder> {
  $$SpeciesProfilesTableTableManager(
      _$AppDatabase db, $SpeciesProfilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$SpeciesProfilesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$SpeciesProfilesTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$SpeciesProfilesTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<String> commonName = const Value.absent(),
            Value<String> genus = const Value.absent(),
            Value<String?> species = const Value.absent(),
            Value<int?> idealLuxMin = const Value.absent(),
            Value<int?> idealLuxMax = const Value.absent(),
            Value<int?> tempMinF = const Value.absent(),
            Value<int?> tempMaxF = const Value.absent(),
            Value<int?> tempNightDropF = const Value.absent(),
            Value<String?> humidity = const Value.absent(),
            Value<String?> bloomSeason = const Value.absent(),
            Value<String?> wateringNotes = const Value.absent(),
            Value<String?> fertilizingNotes = const Value.absent(),
            Value<String?> difficultyLevel = const Value.absent(),
            Value<String?> description = const Value.absent(),
          }) =>
              SpeciesProfilesCompanion(
            id: id,
            commonName: commonName,
            genus: genus,
            species: species,
            idealLuxMin: idealLuxMin,
            idealLuxMax: idealLuxMax,
            tempMinF: tempMinF,
            tempMaxF: tempMaxF,
            tempNightDropF: tempNightDropF,
            humidity: humidity,
            bloomSeason: bloomSeason,
            wateringNotes: wateringNotes,
            fertilizingNotes: fertilizingNotes,
            difficultyLevel: difficultyLevel,
            description: description,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required String commonName,
            required String genus,
            Value<String?> species = const Value.absent(),
            Value<int?> idealLuxMin = const Value.absent(),
            Value<int?> idealLuxMax = const Value.absent(),
            Value<int?> tempMinF = const Value.absent(),
            Value<int?> tempMaxF = const Value.absent(),
            Value<int?> tempNightDropF = const Value.absent(),
            Value<String?> humidity = const Value.absent(),
            Value<String?> bloomSeason = const Value.absent(),
            Value<String?> wateringNotes = const Value.absent(),
            Value<String?> fertilizingNotes = const Value.absent(),
            Value<String?> difficultyLevel = const Value.absent(),
            Value<String?> description = const Value.absent(),
          }) =>
              SpeciesProfilesCompanion.insert(
            id: id,
            commonName: commonName,
            genus: genus,
            species: species,
            idealLuxMin: idealLuxMin,
            idealLuxMax: idealLuxMax,
            tempMinF: tempMinF,
            tempMaxF: tempMaxF,
            tempNightDropF: tempNightDropF,
            humidity: humidity,
            bloomSeason: bloomSeason,
            wateringNotes: wateringNotes,
            fertilizingNotes: fertilizingNotes,
            difficultyLevel: difficultyLevel,
            description: description,
          ),
        ));
}

class $$SpeciesProfilesTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $SpeciesProfilesTable,
    SpeciesProfile,
    $$SpeciesProfilesTableFilterComposer,
    $$SpeciesProfilesTableOrderingComposer,
    $$SpeciesProfilesTableProcessedTableManager,
    $$SpeciesProfilesTableInsertCompanionBuilder,
    $$SpeciesProfilesTableUpdateCompanionBuilder> {
  $$SpeciesProfilesTableProcessedTableManager(super.$state);
}

class $$SpeciesProfilesTableFilterComposer
    extends FilterComposer<_$AppDatabase, $SpeciesProfilesTable> {
  $$SpeciesProfilesTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get commonName => $state.composableBuilder(
      column: $state.table.commonName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get genus => $state.composableBuilder(
      column: $state.table.genus,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get species => $state.composableBuilder(
      column: $state.table.species,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get idealLuxMin => $state.composableBuilder(
      column: $state.table.idealLuxMin,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get idealLuxMax => $state.composableBuilder(
      column: $state.table.idealLuxMax,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get tempMinF => $state.composableBuilder(
      column: $state.table.tempMinF,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get tempMaxF => $state.composableBuilder(
      column: $state.table.tempMaxF,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get tempNightDropF => $state.composableBuilder(
      column: $state.table.tempNightDropF,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get humidity => $state.composableBuilder(
      column: $state.table.humidity,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get bloomSeason => $state.composableBuilder(
      column: $state.table.bloomSeason,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get wateringNotes => $state.composableBuilder(
      column: $state.table.wateringNotes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get fertilizingNotes => $state.composableBuilder(
      column: $state.table.fertilizingNotes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get difficultyLevel => $state.composableBuilder(
      column: $state.table.difficultyLevel,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$SpeciesProfilesTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $SpeciesProfilesTable> {
  $$SpeciesProfilesTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get commonName => $state.composableBuilder(
      column: $state.table.commonName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get genus => $state.composableBuilder(
      column: $state.table.genus,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get species => $state.composableBuilder(
      column: $state.table.species,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get idealLuxMin => $state.composableBuilder(
      column: $state.table.idealLuxMin,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get idealLuxMax => $state.composableBuilder(
      column: $state.table.idealLuxMax,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get tempMinF => $state.composableBuilder(
      column: $state.table.tempMinF,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get tempMaxF => $state.composableBuilder(
      column: $state.table.tempMaxF,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get tempNightDropF => $state.composableBuilder(
      column: $state.table.tempNightDropF,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get humidity => $state.composableBuilder(
      column: $state.table.humidity,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get bloomSeason => $state.composableBuilder(
      column: $state.table.bloomSeason,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get wateringNotes => $state.composableBuilder(
      column: $state.table.wateringNotes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get fertilizingNotes => $state.composableBuilder(
      column: $state.table.fertilizingNotes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get difficultyLevel => $state.composableBuilder(
      column: $state.table.difficultyLevel,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$GrowingLocationsTableInsertCompanionBuilder
    = GrowingLocationsCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> description,
  Value<double?> latestLuxReading,
  Value<DateTime?> lastReadingAt,
});
typedef $$GrowingLocationsTableUpdateCompanionBuilder
    = GrowingLocationsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> description,
  Value<double?> latestLuxReading,
  Value<DateTime?> lastReadingAt,
});

class $$GrowingLocationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GrowingLocationsTable,
    GrowingLocation,
    $$GrowingLocationsTableFilterComposer,
    $$GrowingLocationsTableOrderingComposer,
    $$GrowingLocationsTableProcessedTableManager,
    $$GrowingLocationsTableInsertCompanionBuilder,
    $$GrowingLocationsTableUpdateCompanionBuilder> {
  $$GrowingLocationsTableTableManager(
      _$AppDatabase db, $GrowingLocationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$GrowingLocationsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$GrowingLocationsTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$GrowingLocationsTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<double?> latestLuxReading = const Value.absent(),
            Value<DateTime?> lastReadingAt = const Value.absent(),
          }) =>
              GrowingLocationsCompanion(
            id: id,
            name: name,
            description: description,
            latestLuxReading: latestLuxReading,
            lastReadingAt: lastReadingAt,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> description = const Value.absent(),
            Value<double?> latestLuxReading = const Value.absent(),
            Value<DateTime?> lastReadingAt = const Value.absent(),
          }) =>
              GrowingLocationsCompanion.insert(
            id: id,
            name: name,
            description: description,
            latestLuxReading: latestLuxReading,
            lastReadingAt: lastReadingAt,
          ),
        ));
}

class $$GrowingLocationsTableProcessedTableManager
    extends ProcessedTableManager<
        _$AppDatabase,
        $GrowingLocationsTable,
        GrowingLocation,
        $$GrowingLocationsTableFilterComposer,
        $$GrowingLocationsTableOrderingComposer,
        $$GrowingLocationsTableProcessedTableManager,
        $$GrowingLocationsTableInsertCompanionBuilder,
        $$GrowingLocationsTableUpdateCompanionBuilder> {
  $$GrowingLocationsTableProcessedTableManager(super.$state);
}

class $$GrowingLocationsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $GrowingLocationsTable> {
  $$GrowingLocationsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get latestLuxReading => $state.composableBuilder(
      column: $state.table.latestLuxReading,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get lastReadingAt => $state.composableBuilder(
      column: $state.table.lastReadingAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$GrowingLocationsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $GrowingLocationsTable> {
  $$GrowingLocationsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get latestLuxReading => $state.composableBuilder(
      column: $state.table.latestLuxReading,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get lastReadingAt => $state.composableBuilder(
      column: $state.table.lastReadingAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$MilestonesTableInsertCompanionBuilder = MilestonesCompanion Function({
  Value<int> id,
  required int orchidId,
  required String type,
  required String message,
  required DateTime triggeredAt,
  Value<bool> dismissed,
});
typedef $$MilestonesTableUpdateCompanionBuilder = MilestonesCompanion Function({
  Value<int> id,
  Value<int> orchidId,
  Value<String> type,
  Value<String> message,
  Value<DateTime> triggeredAt,
  Value<bool> dismissed,
});

class $$MilestonesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MilestonesTable,
    Milestone,
    $$MilestonesTableFilterComposer,
    $$MilestonesTableOrderingComposer,
    $$MilestonesTableProcessedTableManager,
    $$MilestonesTableInsertCompanionBuilder,
    $$MilestonesTableUpdateCompanionBuilder> {
  $$MilestonesTableTableManager(_$AppDatabase db, $MilestonesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$MilestonesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$MilestonesTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$MilestonesTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<int> orchidId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> message = const Value.absent(),
            Value<DateTime> triggeredAt = const Value.absent(),
            Value<bool> dismissed = const Value.absent(),
          }) =>
              MilestonesCompanion(
            id: id,
            orchidId: orchidId,
            type: type,
            message: message,
            triggeredAt: triggeredAt,
            dismissed: dismissed,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required int orchidId,
            required String type,
            required String message,
            required DateTime triggeredAt,
            Value<bool> dismissed = const Value.absent(),
          }) =>
              MilestonesCompanion.insert(
            id: id,
            orchidId: orchidId,
            type: type,
            message: message,
            triggeredAt: triggeredAt,
            dismissed: dismissed,
          ),
        ));
}

class $$MilestonesTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $MilestonesTable,
    Milestone,
    $$MilestonesTableFilterComposer,
    $$MilestonesTableOrderingComposer,
    $$MilestonesTableProcessedTableManager,
    $$MilestonesTableInsertCompanionBuilder,
    $$MilestonesTableUpdateCompanionBuilder> {
  $$MilestonesTableProcessedTableManager(super.$state);
}

class $$MilestonesTableFilterComposer
    extends FilterComposer<_$AppDatabase, $MilestonesTable> {
  $$MilestonesTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get message => $state.composableBuilder(
      column: $state.table.message,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get triggeredAt => $state.composableBuilder(
      column: $state.table.triggeredAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get dismissed => $state.composableBuilder(
      column: $state.table.dismissed,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$OrchidsTableFilterComposer get orchidId {
    final $$OrchidsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orchidId,
        referencedTable: $state.db.orchids,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$OrchidsTableFilterComposer(
            ComposerState(
                $state.db, $state.db.orchids, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$MilestonesTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $MilestonesTable> {
  $$MilestonesTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get message => $state.composableBuilder(
      column: $state.table.message,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get triggeredAt => $state.composableBuilder(
      column: $state.table.triggeredAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get dismissed => $state.composableBuilder(
      column: $state.table.dismissed,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$OrchidsTableOrderingComposer get orchidId {
    final $$OrchidsTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orchidId,
        referencedTable: $state.db.orchids,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$OrchidsTableOrderingComposer(ComposerState(
                $state.db, $state.db.orchids, joinBuilder, parentComposers)));
    return composer;
  }
}

class _$AppDatabaseManager {
  final _$AppDatabase _db;
  _$AppDatabaseManager(this._db);
  $$OrchidsTableTableManager get orchids =>
      $$OrchidsTableTableManager(_db, _db.orchids);
  $$CareTasksTableTableManager get careTasks =>
      $$CareTasksTableTableManager(_db, _db.careTasks);
  $$CareLogsTableTableManager get careLogs =>
      $$CareLogsTableTableManager(_db, _db.careLogs);
  $$LightReadingsTableTableManager get lightReadings =>
      $$LightReadingsTableTableManager(_db, _db.lightReadings);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$SoakSessionsTableTableManager get soakSessions =>
      $$SoakSessionsTableTableManager(_db, _db.soakSessions);
  $$SoakSessionTasksTableTableManager get soakSessionTasks =>
      $$SoakSessionTasksTableTableManager(_db, _db.soakSessionTasks);
  $$BloomLogsTableTableManager get bloomLogs =>
      $$BloomLogsTableTableManager(_db, _db.bloomLogs);
  $$PhotoJournalTableTableManager get photoJournal =>
      $$PhotoJournalTableTableManager(_db, _db.photoJournal);
  $$SpeciesProfilesTableTableManager get speciesProfiles =>
      $$SpeciesProfilesTableTableManager(_db, _db.speciesProfiles);
  $$GrowingLocationsTableTableManager get growingLocations =>
      $$GrowingLocationsTableTableManager(_db, _db.growingLocations);
  $$MilestonesTableTableManager get milestones =>
      $$MilestonesTableTableManager(_db, _db.milestones);
}
