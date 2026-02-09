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
        soakDurationMinutes
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
    );
  }

  @override
  $OrchidsTable createAlias(String alias) {
    return $OrchidsTable(attachedDatabase, alias);
  }
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
      required this.soakDurationMinutes});
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
          int? soakDurationMinutes}) =>
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
          ..write('soakDurationMinutes: $soakDurationMinutes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, variety, location, photoPath, notes,
      dateAcquired, createdAt, isDemo, soakDurationMinutes);
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
          other.soakDurationMinutes == this.soakDurationMinutes);
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
      Value<int>? soakDurationMinutes}) {
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
          ..write('soakDurationMinutes: $soakDurationMinutes')
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
        soakSessionTasks
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
}
