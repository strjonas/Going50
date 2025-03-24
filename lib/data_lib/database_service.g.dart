// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_service.dart';

// ignore_for_file: type=lint
class $TripsTableTable extends TripsTable
    with TableInfo<$TripsTableTable, TripsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TripsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 36,
      maxTextLength: 36,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
    'end_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _distanceKmMeta = const VerificationMeta(
    'distanceKm',
  );
  @override
  late final GeneratedColumn<double> distanceKm = GeneratedColumn<double>(
    'distance_km',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _averageSpeedKmhMeta = const VerificationMeta(
    'averageSpeedKmh',
  );
  @override
  late final GeneratedColumn<double> averageSpeedKmh = GeneratedColumn<double>(
    'average_speed_kmh',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maxSpeedKmhMeta = const VerificationMeta(
    'maxSpeedKmh',
  );
  @override
  late final GeneratedColumn<double> maxSpeedKmh = GeneratedColumn<double>(
    'max_speed_kmh',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fuelUsedLMeta = const VerificationMeta(
    'fuelUsedL',
  );
  @override
  late final GeneratedColumn<double> fuelUsedL = GeneratedColumn<double>(
    'fuel_used_l',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idlingEventsMeta = const VerificationMeta(
    'idlingEvents',
  );
  @override
  late final GeneratedColumn<int> idlingEvents = GeneratedColumn<int>(
    'idling_events',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _aggressiveAccelerationEventsMeta =
      const VerificationMeta('aggressiveAccelerationEvents');
  @override
  late final GeneratedColumn<int> aggressiveAccelerationEvents =
      GeneratedColumn<int>(
        'aggressive_acceleration_events',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _hardBrakingEventsMeta = const VerificationMeta(
    'hardBrakingEvents',
  );
  @override
  late final GeneratedColumn<int> hardBrakingEvents = GeneratedColumn<int>(
    'hard_braking_events',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _excessiveSpeedEventsMeta =
      const VerificationMeta('excessiveSpeedEvents');
  @override
  late final GeneratedColumn<int> excessiveSpeedEvents = GeneratedColumn<int>(
    'excessive_speed_events',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stopEventsMeta = const VerificationMeta(
    'stopEvents',
  );
  @override
  late final GeneratedColumn<int> stopEvents = GeneratedColumn<int>(
    'stop_events',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _averageRPMMeta = const VerificationMeta(
    'averageRPM',
  );
  @override
  late final GeneratedColumn<double> averageRPM = GeneratedColumn<double>(
    'average_r_p_m',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _ecoScoreMeta = const VerificationMeta(
    'ecoScore',
  );
  @override
  late final GeneratedColumn<int> ecoScore = GeneratedColumn<int>(
    'eco_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _routeDataJsonMeta = const VerificationMeta(
    'routeDataJson',
  );
  @override
  late final GeneratedColumn<String> routeDataJson = GeneratedColumn<String>(
    'route_data_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    startTime,
    endTime,
    distanceKm,
    averageSpeedKmh,
    maxSpeedKmh,
    fuelUsedL,
    idlingEvents,
    aggressiveAccelerationEvents,
    hardBrakingEvents,
    excessiveSpeedEvents,
    stopEvents,
    averageRPM,
    isCompleted,
    ecoScore,
    routeDataJson,
    userId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trips_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TripsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    }
    if (data.containsKey('distance_km')) {
      context.handle(
        _distanceKmMeta,
        distanceKm.isAcceptableOrUnknown(data['distance_km']!, _distanceKmMeta),
      );
    }
    if (data.containsKey('average_speed_kmh')) {
      context.handle(
        _averageSpeedKmhMeta,
        averageSpeedKmh.isAcceptableOrUnknown(
          data['average_speed_kmh']!,
          _averageSpeedKmhMeta,
        ),
      );
    }
    if (data.containsKey('max_speed_kmh')) {
      context.handle(
        _maxSpeedKmhMeta,
        maxSpeedKmh.isAcceptableOrUnknown(
          data['max_speed_kmh']!,
          _maxSpeedKmhMeta,
        ),
      );
    }
    if (data.containsKey('fuel_used_l')) {
      context.handle(
        _fuelUsedLMeta,
        fuelUsedL.isAcceptableOrUnknown(data['fuel_used_l']!, _fuelUsedLMeta),
      );
    }
    if (data.containsKey('idling_events')) {
      context.handle(
        _idlingEventsMeta,
        idlingEvents.isAcceptableOrUnknown(
          data['idling_events']!,
          _idlingEventsMeta,
        ),
      );
    }
    if (data.containsKey('aggressive_acceleration_events')) {
      context.handle(
        _aggressiveAccelerationEventsMeta,
        aggressiveAccelerationEvents.isAcceptableOrUnknown(
          data['aggressive_acceleration_events']!,
          _aggressiveAccelerationEventsMeta,
        ),
      );
    }
    if (data.containsKey('hard_braking_events')) {
      context.handle(
        _hardBrakingEventsMeta,
        hardBrakingEvents.isAcceptableOrUnknown(
          data['hard_braking_events']!,
          _hardBrakingEventsMeta,
        ),
      );
    }
    if (data.containsKey('excessive_speed_events')) {
      context.handle(
        _excessiveSpeedEventsMeta,
        excessiveSpeedEvents.isAcceptableOrUnknown(
          data['excessive_speed_events']!,
          _excessiveSpeedEventsMeta,
        ),
      );
    }
    if (data.containsKey('stop_events')) {
      context.handle(
        _stopEventsMeta,
        stopEvents.isAcceptableOrUnknown(data['stop_events']!, _stopEventsMeta),
      );
    }
    if (data.containsKey('average_r_p_m')) {
      context.handle(
        _averageRPMMeta,
        averageRPM.isAcceptableOrUnknown(
          data['average_r_p_m']!,
          _averageRPMMeta,
        ),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('eco_score')) {
      context.handle(
        _ecoScoreMeta,
        ecoScore.isAcceptableOrUnknown(data['eco_score']!, _ecoScoreMeta),
      );
    }
    if (data.containsKey('route_data_json')) {
      context.handle(
        _routeDataJsonMeta,
        routeDataJson.isAcceptableOrUnknown(
          data['route_data_json']!,
          _routeDataJsonMeta,
        ),
      );
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TripsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TripsTableData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      startTime:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}start_time'],
          )!,
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_time'],
      ),
      distanceKm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}distance_km'],
      ),
      averageSpeedKmh: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}average_speed_kmh'],
      ),
      maxSpeedKmh: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}max_speed_kmh'],
      ),
      fuelUsedL: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fuel_used_l'],
      ),
      idlingEvents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}idling_events'],
      ),
      aggressiveAccelerationEvents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}aggressive_acceleration_events'],
      ),
      hardBrakingEvents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hard_braking_events'],
      ),
      excessiveSpeedEvents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}excessive_speed_events'],
      ),
      stopEvents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stop_events'],
      ),
      averageRPM: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}average_r_p_m'],
      ),
      isCompleted:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_completed'],
          )!,
      ecoScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}eco_score'],
      ),
      routeDataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}route_data_json'],
      ),
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
    );
  }

  @override
  $TripsTableTable createAlias(String alias) {
    return $TripsTableTable(attachedDatabase, alias);
  }
}

class TripsTableData extends DataClass implements Insertable<TripsTableData> {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final double? distanceKm;
  final double? averageSpeedKmh;
  final double? maxSpeedKmh;
  final double? fuelUsedL;
  final int? idlingEvents;
  final int? aggressiveAccelerationEvents;
  final int? hardBrakingEvents;
  final int? excessiveSpeedEvents;
  final int? stopEvents;
  final double? averageRPM;
  final bool isCompleted;
  final int? ecoScore;
  final String? routeDataJson;
  final String? userId;
  const TripsTableData({
    required this.id,
    required this.startTime,
    this.endTime,
    this.distanceKm,
    this.averageSpeedKmh,
    this.maxSpeedKmh,
    this.fuelUsedL,
    this.idlingEvents,
    this.aggressiveAccelerationEvents,
    this.hardBrakingEvents,
    this.excessiveSpeedEvents,
    this.stopEvents,
    this.averageRPM,
    required this.isCompleted,
    this.ecoScore,
    this.routeDataJson,
    this.userId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['start_time'] = Variable<DateTime>(startTime);
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<DateTime>(endTime);
    }
    if (!nullToAbsent || distanceKm != null) {
      map['distance_km'] = Variable<double>(distanceKm);
    }
    if (!nullToAbsent || averageSpeedKmh != null) {
      map['average_speed_kmh'] = Variable<double>(averageSpeedKmh);
    }
    if (!nullToAbsent || maxSpeedKmh != null) {
      map['max_speed_kmh'] = Variable<double>(maxSpeedKmh);
    }
    if (!nullToAbsent || fuelUsedL != null) {
      map['fuel_used_l'] = Variable<double>(fuelUsedL);
    }
    if (!nullToAbsent || idlingEvents != null) {
      map['idling_events'] = Variable<int>(idlingEvents);
    }
    if (!nullToAbsent || aggressiveAccelerationEvents != null) {
      map['aggressive_acceleration_events'] = Variable<int>(
        aggressiveAccelerationEvents,
      );
    }
    if (!nullToAbsent || hardBrakingEvents != null) {
      map['hard_braking_events'] = Variable<int>(hardBrakingEvents);
    }
    if (!nullToAbsent || excessiveSpeedEvents != null) {
      map['excessive_speed_events'] = Variable<int>(excessiveSpeedEvents);
    }
    if (!nullToAbsent || stopEvents != null) {
      map['stop_events'] = Variable<int>(stopEvents);
    }
    if (!nullToAbsent || averageRPM != null) {
      map['average_r_p_m'] = Variable<double>(averageRPM);
    }
    map['is_completed'] = Variable<bool>(isCompleted);
    if (!nullToAbsent || ecoScore != null) {
      map['eco_score'] = Variable<int>(ecoScore);
    }
    if (!nullToAbsent || routeDataJson != null) {
      map['route_data_json'] = Variable<String>(routeDataJson);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    return map;
  }

  TripsTableCompanion toCompanion(bool nullToAbsent) {
    return TripsTableCompanion(
      id: Value(id),
      startTime: Value(startTime),
      endTime:
          endTime == null && nullToAbsent
              ? const Value.absent()
              : Value(endTime),
      distanceKm:
          distanceKm == null && nullToAbsent
              ? const Value.absent()
              : Value(distanceKm),
      averageSpeedKmh:
          averageSpeedKmh == null && nullToAbsent
              ? const Value.absent()
              : Value(averageSpeedKmh),
      maxSpeedKmh:
          maxSpeedKmh == null && nullToAbsent
              ? const Value.absent()
              : Value(maxSpeedKmh),
      fuelUsedL:
          fuelUsedL == null && nullToAbsent
              ? const Value.absent()
              : Value(fuelUsedL),
      idlingEvents:
          idlingEvents == null && nullToAbsent
              ? const Value.absent()
              : Value(idlingEvents),
      aggressiveAccelerationEvents:
          aggressiveAccelerationEvents == null && nullToAbsent
              ? const Value.absent()
              : Value(aggressiveAccelerationEvents),
      hardBrakingEvents:
          hardBrakingEvents == null && nullToAbsent
              ? const Value.absent()
              : Value(hardBrakingEvents),
      excessiveSpeedEvents:
          excessiveSpeedEvents == null && nullToAbsent
              ? const Value.absent()
              : Value(excessiveSpeedEvents),
      stopEvents:
          stopEvents == null && nullToAbsent
              ? const Value.absent()
              : Value(stopEvents),
      averageRPM:
          averageRPM == null && nullToAbsent
              ? const Value.absent()
              : Value(averageRPM),
      isCompleted: Value(isCompleted),
      ecoScore:
          ecoScore == null && nullToAbsent
              ? const Value.absent()
              : Value(ecoScore),
      routeDataJson:
          routeDataJson == null && nullToAbsent
              ? const Value.absent()
              : Value(routeDataJson),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
    );
  }

  factory TripsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TripsTableData(
      id: serializer.fromJson<String>(json['id']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime?>(json['endTime']),
      distanceKm: serializer.fromJson<double?>(json['distanceKm']),
      averageSpeedKmh: serializer.fromJson<double?>(json['averageSpeedKmh']),
      maxSpeedKmh: serializer.fromJson<double?>(json['maxSpeedKmh']),
      fuelUsedL: serializer.fromJson<double?>(json['fuelUsedL']),
      idlingEvents: serializer.fromJson<int?>(json['idlingEvents']),
      aggressiveAccelerationEvents: serializer.fromJson<int?>(
        json['aggressiveAccelerationEvents'],
      ),
      hardBrakingEvents: serializer.fromJson<int?>(json['hardBrakingEvents']),
      excessiveSpeedEvents: serializer.fromJson<int?>(
        json['excessiveSpeedEvents'],
      ),
      stopEvents: serializer.fromJson<int?>(json['stopEvents']),
      averageRPM: serializer.fromJson<double?>(json['averageRPM']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      ecoScore: serializer.fromJson<int?>(json['ecoScore']),
      routeDataJson: serializer.fromJson<String?>(json['routeDataJson']),
      userId: serializer.fromJson<String?>(json['userId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime?>(endTime),
      'distanceKm': serializer.toJson<double?>(distanceKm),
      'averageSpeedKmh': serializer.toJson<double?>(averageSpeedKmh),
      'maxSpeedKmh': serializer.toJson<double?>(maxSpeedKmh),
      'fuelUsedL': serializer.toJson<double?>(fuelUsedL),
      'idlingEvents': serializer.toJson<int?>(idlingEvents),
      'aggressiveAccelerationEvents': serializer.toJson<int?>(
        aggressiveAccelerationEvents,
      ),
      'hardBrakingEvents': serializer.toJson<int?>(hardBrakingEvents),
      'excessiveSpeedEvents': serializer.toJson<int?>(excessiveSpeedEvents),
      'stopEvents': serializer.toJson<int?>(stopEvents),
      'averageRPM': serializer.toJson<double?>(averageRPM),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'ecoScore': serializer.toJson<int?>(ecoScore),
      'routeDataJson': serializer.toJson<String?>(routeDataJson),
      'userId': serializer.toJson<String?>(userId),
    };
  }

  TripsTableData copyWith({
    String? id,
    DateTime? startTime,
    Value<DateTime?> endTime = const Value.absent(),
    Value<double?> distanceKm = const Value.absent(),
    Value<double?> averageSpeedKmh = const Value.absent(),
    Value<double?> maxSpeedKmh = const Value.absent(),
    Value<double?> fuelUsedL = const Value.absent(),
    Value<int?> idlingEvents = const Value.absent(),
    Value<int?> aggressiveAccelerationEvents = const Value.absent(),
    Value<int?> hardBrakingEvents = const Value.absent(),
    Value<int?> excessiveSpeedEvents = const Value.absent(),
    Value<int?> stopEvents = const Value.absent(),
    Value<double?> averageRPM = const Value.absent(),
    bool? isCompleted,
    Value<int?> ecoScore = const Value.absent(),
    Value<String?> routeDataJson = const Value.absent(),
    Value<String?> userId = const Value.absent(),
  }) => TripsTableData(
    id: id ?? this.id,
    startTime: startTime ?? this.startTime,
    endTime: endTime.present ? endTime.value : this.endTime,
    distanceKm: distanceKm.present ? distanceKm.value : this.distanceKm,
    averageSpeedKmh:
        averageSpeedKmh.present ? averageSpeedKmh.value : this.averageSpeedKmh,
    maxSpeedKmh: maxSpeedKmh.present ? maxSpeedKmh.value : this.maxSpeedKmh,
    fuelUsedL: fuelUsedL.present ? fuelUsedL.value : this.fuelUsedL,
    idlingEvents: idlingEvents.present ? idlingEvents.value : this.idlingEvents,
    aggressiveAccelerationEvents:
        aggressiveAccelerationEvents.present
            ? aggressiveAccelerationEvents.value
            : this.aggressiveAccelerationEvents,
    hardBrakingEvents:
        hardBrakingEvents.present
            ? hardBrakingEvents.value
            : this.hardBrakingEvents,
    excessiveSpeedEvents:
        excessiveSpeedEvents.present
            ? excessiveSpeedEvents.value
            : this.excessiveSpeedEvents,
    stopEvents: stopEvents.present ? stopEvents.value : this.stopEvents,
    averageRPM: averageRPM.present ? averageRPM.value : this.averageRPM,
    isCompleted: isCompleted ?? this.isCompleted,
    ecoScore: ecoScore.present ? ecoScore.value : this.ecoScore,
    routeDataJson:
        routeDataJson.present ? routeDataJson.value : this.routeDataJson,
    userId: userId.present ? userId.value : this.userId,
  );
  TripsTableData copyWithCompanion(TripsTableCompanion data) {
    return TripsTableData(
      id: data.id.present ? data.id.value : this.id,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      distanceKm:
          data.distanceKm.present ? data.distanceKm.value : this.distanceKm,
      averageSpeedKmh:
          data.averageSpeedKmh.present
              ? data.averageSpeedKmh.value
              : this.averageSpeedKmh,
      maxSpeedKmh:
          data.maxSpeedKmh.present ? data.maxSpeedKmh.value : this.maxSpeedKmh,
      fuelUsedL: data.fuelUsedL.present ? data.fuelUsedL.value : this.fuelUsedL,
      idlingEvents:
          data.idlingEvents.present
              ? data.idlingEvents.value
              : this.idlingEvents,
      aggressiveAccelerationEvents:
          data.aggressiveAccelerationEvents.present
              ? data.aggressiveAccelerationEvents.value
              : this.aggressiveAccelerationEvents,
      hardBrakingEvents:
          data.hardBrakingEvents.present
              ? data.hardBrakingEvents.value
              : this.hardBrakingEvents,
      excessiveSpeedEvents:
          data.excessiveSpeedEvents.present
              ? data.excessiveSpeedEvents.value
              : this.excessiveSpeedEvents,
      stopEvents:
          data.stopEvents.present ? data.stopEvents.value : this.stopEvents,
      averageRPM:
          data.averageRPM.present ? data.averageRPM.value : this.averageRPM,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
      ecoScore: data.ecoScore.present ? data.ecoScore.value : this.ecoScore,
      routeDataJson:
          data.routeDataJson.present
              ? data.routeDataJson.value
              : this.routeDataJson,
      userId: data.userId.present ? data.userId.value : this.userId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TripsTableData(')
          ..write('id: $id, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('distanceKm: $distanceKm, ')
          ..write('averageSpeedKmh: $averageSpeedKmh, ')
          ..write('maxSpeedKmh: $maxSpeedKmh, ')
          ..write('fuelUsedL: $fuelUsedL, ')
          ..write('idlingEvents: $idlingEvents, ')
          ..write(
            'aggressiveAccelerationEvents: $aggressiveAccelerationEvents, ',
          )
          ..write('hardBrakingEvents: $hardBrakingEvents, ')
          ..write('excessiveSpeedEvents: $excessiveSpeedEvents, ')
          ..write('stopEvents: $stopEvents, ')
          ..write('averageRPM: $averageRPM, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('ecoScore: $ecoScore, ')
          ..write('routeDataJson: $routeDataJson, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    startTime,
    endTime,
    distanceKm,
    averageSpeedKmh,
    maxSpeedKmh,
    fuelUsedL,
    idlingEvents,
    aggressiveAccelerationEvents,
    hardBrakingEvents,
    excessiveSpeedEvents,
    stopEvents,
    averageRPM,
    isCompleted,
    ecoScore,
    routeDataJson,
    userId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TripsTableData &&
          other.id == this.id &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.distanceKm == this.distanceKm &&
          other.averageSpeedKmh == this.averageSpeedKmh &&
          other.maxSpeedKmh == this.maxSpeedKmh &&
          other.fuelUsedL == this.fuelUsedL &&
          other.idlingEvents == this.idlingEvents &&
          other.aggressiveAccelerationEvents ==
              this.aggressiveAccelerationEvents &&
          other.hardBrakingEvents == this.hardBrakingEvents &&
          other.excessiveSpeedEvents == this.excessiveSpeedEvents &&
          other.stopEvents == this.stopEvents &&
          other.averageRPM == this.averageRPM &&
          other.isCompleted == this.isCompleted &&
          other.ecoScore == this.ecoScore &&
          other.routeDataJson == this.routeDataJson &&
          other.userId == this.userId);
}

class TripsTableCompanion extends UpdateCompanion<TripsTableData> {
  final Value<String> id;
  final Value<DateTime> startTime;
  final Value<DateTime?> endTime;
  final Value<double?> distanceKm;
  final Value<double?> averageSpeedKmh;
  final Value<double?> maxSpeedKmh;
  final Value<double?> fuelUsedL;
  final Value<int?> idlingEvents;
  final Value<int?> aggressiveAccelerationEvents;
  final Value<int?> hardBrakingEvents;
  final Value<int?> excessiveSpeedEvents;
  final Value<int?> stopEvents;
  final Value<double?> averageRPM;
  final Value<bool> isCompleted;
  final Value<int?> ecoScore;
  final Value<String?> routeDataJson;
  final Value<String?> userId;
  final Value<int> rowid;
  const TripsTableCompanion({
    this.id = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.distanceKm = const Value.absent(),
    this.averageSpeedKmh = const Value.absent(),
    this.maxSpeedKmh = const Value.absent(),
    this.fuelUsedL = const Value.absent(),
    this.idlingEvents = const Value.absent(),
    this.aggressiveAccelerationEvents = const Value.absent(),
    this.hardBrakingEvents = const Value.absent(),
    this.excessiveSpeedEvents = const Value.absent(),
    this.stopEvents = const Value.absent(),
    this.averageRPM = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.ecoScore = const Value.absent(),
    this.routeDataJson = const Value.absent(),
    this.userId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TripsTableCompanion.insert({
    required String id,
    required DateTime startTime,
    this.endTime = const Value.absent(),
    this.distanceKm = const Value.absent(),
    this.averageSpeedKmh = const Value.absent(),
    this.maxSpeedKmh = const Value.absent(),
    this.fuelUsedL = const Value.absent(),
    this.idlingEvents = const Value.absent(),
    this.aggressiveAccelerationEvents = const Value.absent(),
    this.hardBrakingEvents = const Value.absent(),
    this.excessiveSpeedEvents = const Value.absent(),
    this.stopEvents = const Value.absent(),
    this.averageRPM = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.ecoScore = const Value.absent(),
    this.routeDataJson = const Value.absent(),
    this.userId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       startTime = Value(startTime);
  static Insertable<TripsTableData> custom({
    Expression<String>? id,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<double>? distanceKm,
    Expression<double>? averageSpeedKmh,
    Expression<double>? maxSpeedKmh,
    Expression<double>? fuelUsedL,
    Expression<int>? idlingEvents,
    Expression<int>? aggressiveAccelerationEvents,
    Expression<int>? hardBrakingEvents,
    Expression<int>? excessiveSpeedEvents,
    Expression<int>? stopEvents,
    Expression<double>? averageRPM,
    Expression<bool>? isCompleted,
    Expression<int>? ecoScore,
    Expression<String>? routeDataJson,
    Expression<String>? userId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (distanceKm != null) 'distance_km': distanceKm,
      if (averageSpeedKmh != null) 'average_speed_kmh': averageSpeedKmh,
      if (maxSpeedKmh != null) 'max_speed_kmh': maxSpeedKmh,
      if (fuelUsedL != null) 'fuel_used_l': fuelUsedL,
      if (idlingEvents != null) 'idling_events': idlingEvents,
      if (aggressiveAccelerationEvents != null)
        'aggressive_acceleration_events': aggressiveAccelerationEvents,
      if (hardBrakingEvents != null) 'hard_braking_events': hardBrakingEvents,
      if (excessiveSpeedEvents != null)
        'excessive_speed_events': excessiveSpeedEvents,
      if (stopEvents != null) 'stop_events': stopEvents,
      if (averageRPM != null) 'average_r_p_m': averageRPM,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (ecoScore != null) 'eco_score': ecoScore,
      if (routeDataJson != null) 'route_data_json': routeDataJson,
      if (userId != null) 'user_id': userId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TripsTableCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? startTime,
    Value<DateTime?>? endTime,
    Value<double?>? distanceKm,
    Value<double?>? averageSpeedKmh,
    Value<double?>? maxSpeedKmh,
    Value<double?>? fuelUsedL,
    Value<int?>? idlingEvents,
    Value<int?>? aggressiveAccelerationEvents,
    Value<int?>? hardBrakingEvents,
    Value<int?>? excessiveSpeedEvents,
    Value<int?>? stopEvents,
    Value<double?>? averageRPM,
    Value<bool>? isCompleted,
    Value<int?>? ecoScore,
    Value<String?>? routeDataJson,
    Value<String?>? userId,
    Value<int>? rowid,
  }) {
    return TripsTableCompanion(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      distanceKm: distanceKm ?? this.distanceKm,
      averageSpeedKmh: averageSpeedKmh ?? this.averageSpeedKmh,
      maxSpeedKmh: maxSpeedKmh ?? this.maxSpeedKmh,
      fuelUsedL: fuelUsedL ?? this.fuelUsedL,
      idlingEvents: idlingEvents ?? this.idlingEvents,
      aggressiveAccelerationEvents:
          aggressiveAccelerationEvents ?? this.aggressiveAccelerationEvents,
      hardBrakingEvents: hardBrakingEvents ?? this.hardBrakingEvents,
      excessiveSpeedEvents: excessiveSpeedEvents ?? this.excessiveSpeedEvents,
      stopEvents: stopEvents ?? this.stopEvents,
      averageRPM: averageRPM ?? this.averageRPM,
      isCompleted: isCompleted ?? this.isCompleted,
      ecoScore: ecoScore ?? this.ecoScore,
      routeDataJson: routeDataJson ?? this.routeDataJson,
      userId: userId ?? this.userId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (distanceKm.present) {
      map['distance_km'] = Variable<double>(distanceKm.value);
    }
    if (averageSpeedKmh.present) {
      map['average_speed_kmh'] = Variable<double>(averageSpeedKmh.value);
    }
    if (maxSpeedKmh.present) {
      map['max_speed_kmh'] = Variable<double>(maxSpeedKmh.value);
    }
    if (fuelUsedL.present) {
      map['fuel_used_l'] = Variable<double>(fuelUsedL.value);
    }
    if (idlingEvents.present) {
      map['idling_events'] = Variable<int>(idlingEvents.value);
    }
    if (aggressiveAccelerationEvents.present) {
      map['aggressive_acceleration_events'] = Variable<int>(
        aggressiveAccelerationEvents.value,
      );
    }
    if (hardBrakingEvents.present) {
      map['hard_braking_events'] = Variable<int>(hardBrakingEvents.value);
    }
    if (excessiveSpeedEvents.present) {
      map['excessive_speed_events'] = Variable<int>(excessiveSpeedEvents.value);
    }
    if (stopEvents.present) {
      map['stop_events'] = Variable<int>(stopEvents.value);
    }
    if (averageRPM.present) {
      map['average_r_p_m'] = Variable<double>(averageRPM.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (ecoScore.present) {
      map['eco_score'] = Variable<int>(ecoScore.value);
    }
    if (routeDataJson.present) {
      map['route_data_json'] = Variable<String>(routeDataJson.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TripsTableCompanion(')
          ..write('id: $id, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('distanceKm: $distanceKm, ')
          ..write('averageSpeedKmh: $averageSpeedKmh, ')
          ..write('maxSpeedKmh: $maxSpeedKmh, ')
          ..write('fuelUsedL: $fuelUsedL, ')
          ..write('idlingEvents: $idlingEvents, ')
          ..write(
            'aggressiveAccelerationEvents: $aggressiveAccelerationEvents, ',
          )
          ..write('hardBrakingEvents: $hardBrakingEvents, ')
          ..write('excessiveSpeedEvents: $excessiveSpeedEvents, ')
          ..write('stopEvents: $stopEvents, ')
          ..write('averageRPM: $averageRPM, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('ecoScore: $ecoScore, ')
          ..write('routeDataJson: $routeDataJson, ')
          ..write('userId: $userId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TripDataPointsTableTable extends TripDataPointsTable
    with TableInfo<$TripDataPointsTableTable, TripDataPointsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TripDataPointsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<String> tripId = GeneratedColumn<String>(
    'trip_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES trips_table (id)',
    ),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _speedMeta = const VerificationMeta('speed');
  @override
  late final GeneratedColumn<double> speed = GeneratedColumn<double>(
    'speed',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accelerationMeta = const VerificationMeta(
    'acceleration',
  );
  @override
  late final GeneratedColumn<double> acceleration = GeneratedColumn<double>(
    'acceleration',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rpmMeta = const VerificationMeta('rpm');
  @override
  late final GeneratedColumn<double> rpm = GeneratedColumn<double>(
    'rpm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _throttlePositionMeta = const VerificationMeta(
    'throttlePosition',
  );
  @override
  late final GeneratedColumn<double> throttlePosition = GeneratedColumn<double>(
    'throttle_position',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _engineLoadMeta = const VerificationMeta(
    'engineLoad',
  );
  @override
  late final GeneratedColumn<double> engineLoad = GeneratedColumn<double>(
    'engine_load',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fuelRateMeta = const VerificationMeta(
    'fuelRate',
  );
  @override
  late final GeneratedColumn<double> fuelRate = GeneratedColumn<double>(
    'fuel_rate',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rawDataJsonMeta = const VerificationMeta(
    'rawDataJson',
  );
  @override
  late final GeneratedColumn<String> rawDataJson = GeneratedColumn<String>(
    'raw_data_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tripId,
    timestamp,
    latitude,
    longitude,
    speed,
    acceleration,
    rpm,
    throttlePosition,
    engineLoad,
    fuelRate,
    rawDataJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trip_data_points_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TripDataPointsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    }
    if (data.containsKey('speed')) {
      context.handle(
        _speedMeta,
        speed.isAcceptableOrUnknown(data['speed']!, _speedMeta),
      );
    }
    if (data.containsKey('acceleration')) {
      context.handle(
        _accelerationMeta,
        acceleration.isAcceptableOrUnknown(
          data['acceleration']!,
          _accelerationMeta,
        ),
      );
    }
    if (data.containsKey('rpm')) {
      context.handle(
        _rpmMeta,
        rpm.isAcceptableOrUnknown(data['rpm']!, _rpmMeta),
      );
    }
    if (data.containsKey('throttle_position')) {
      context.handle(
        _throttlePositionMeta,
        throttlePosition.isAcceptableOrUnknown(
          data['throttle_position']!,
          _throttlePositionMeta,
        ),
      );
    }
    if (data.containsKey('engine_load')) {
      context.handle(
        _engineLoadMeta,
        engineLoad.isAcceptableOrUnknown(data['engine_load']!, _engineLoadMeta),
      );
    }
    if (data.containsKey('fuel_rate')) {
      context.handle(
        _fuelRateMeta,
        fuelRate.isAcceptableOrUnknown(data['fuel_rate']!, _fuelRateMeta),
      );
    }
    if (data.containsKey('raw_data_json')) {
      context.handle(
        _rawDataJsonMeta,
        rawDataJson.isAcceptableOrUnknown(
          data['raw_data_json']!,
          _rawDataJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TripDataPointsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TripDataPointsTableData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      tripId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}trip_id'],
          )!,
      timestamp:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}timestamp'],
          )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      ),
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      ),
      speed: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}speed'],
      ),
      acceleration: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}acceleration'],
      ),
      rpm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rpm'],
      ),
      throttlePosition: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}throttle_position'],
      ),
      engineLoad: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}engine_load'],
      ),
      fuelRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fuel_rate'],
      ),
      rawDataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_data_json'],
      ),
    );
  }

  @override
  $TripDataPointsTableTable createAlias(String alias) {
    return $TripDataPointsTableTable(attachedDatabase, alias);
  }
}

class TripDataPointsTableData extends DataClass
    implements Insertable<TripDataPointsTableData> {
  final int id;
  final String tripId;
  final DateTime timestamp;
  final double? latitude;
  final double? longitude;
  final double? speed;
  final double? acceleration;
  final double? rpm;
  final double? throttlePosition;
  final double? engineLoad;
  final double? fuelRate;
  final String? rawDataJson;
  const TripDataPointsTableData({
    required this.id,
    required this.tripId,
    required this.timestamp,
    this.latitude,
    this.longitude,
    this.speed,
    this.acceleration,
    this.rpm,
    this.throttlePosition,
    this.engineLoad,
    this.fuelRate,
    this.rawDataJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['trip_id'] = Variable<String>(tripId);
    map['timestamp'] = Variable<DateTime>(timestamp);
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    if (!nullToAbsent || speed != null) {
      map['speed'] = Variable<double>(speed);
    }
    if (!nullToAbsent || acceleration != null) {
      map['acceleration'] = Variable<double>(acceleration);
    }
    if (!nullToAbsent || rpm != null) {
      map['rpm'] = Variable<double>(rpm);
    }
    if (!nullToAbsent || throttlePosition != null) {
      map['throttle_position'] = Variable<double>(throttlePosition);
    }
    if (!nullToAbsent || engineLoad != null) {
      map['engine_load'] = Variable<double>(engineLoad);
    }
    if (!nullToAbsent || fuelRate != null) {
      map['fuel_rate'] = Variable<double>(fuelRate);
    }
    if (!nullToAbsent || rawDataJson != null) {
      map['raw_data_json'] = Variable<String>(rawDataJson);
    }
    return map;
  }

  TripDataPointsTableCompanion toCompanion(bool nullToAbsent) {
    return TripDataPointsTableCompanion(
      id: Value(id),
      tripId: Value(tripId),
      timestamp: Value(timestamp),
      latitude:
          latitude == null && nullToAbsent
              ? const Value.absent()
              : Value(latitude),
      longitude:
          longitude == null && nullToAbsent
              ? const Value.absent()
              : Value(longitude),
      speed:
          speed == null && nullToAbsent ? const Value.absent() : Value(speed),
      acceleration:
          acceleration == null && nullToAbsent
              ? const Value.absent()
              : Value(acceleration),
      rpm: rpm == null && nullToAbsent ? const Value.absent() : Value(rpm),
      throttlePosition:
          throttlePosition == null && nullToAbsent
              ? const Value.absent()
              : Value(throttlePosition),
      engineLoad:
          engineLoad == null && nullToAbsent
              ? const Value.absent()
              : Value(engineLoad),
      fuelRate:
          fuelRate == null && nullToAbsent
              ? const Value.absent()
              : Value(fuelRate),
      rawDataJson:
          rawDataJson == null && nullToAbsent
              ? const Value.absent()
              : Value(rawDataJson),
    );
  }

  factory TripDataPointsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TripDataPointsTableData(
      id: serializer.fromJson<int>(json['id']),
      tripId: serializer.fromJson<String>(json['tripId']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      speed: serializer.fromJson<double?>(json['speed']),
      acceleration: serializer.fromJson<double?>(json['acceleration']),
      rpm: serializer.fromJson<double?>(json['rpm']),
      throttlePosition: serializer.fromJson<double?>(json['throttlePosition']),
      engineLoad: serializer.fromJson<double?>(json['engineLoad']),
      fuelRate: serializer.fromJson<double?>(json['fuelRate']),
      rawDataJson: serializer.fromJson<String?>(json['rawDataJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tripId': serializer.toJson<String>(tripId),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'speed': serializer.toJson<double?>(speed),
      'acceleration': serializer.toJson<double?>(acceleration),
      'rpm': serializer.toJson<double?>(rpm),
      'throttlePosition': serializer.toJson<double?>(throttlePosition),
      'engineLoad': serializer.toJson<double?>(engineLoad),
      'fuelRate': serializer.toJson<double?>(fuelRate),
      'rawDataJson': serializer.toJson<String?>(rawDataJson),
    };
  }

  TripDataPointsTableData copyWith({
    int? id,
    String? tripId,
    DateTime? timestamp,
    Value<double?> latitude = const Value.absent(),
    Value<double?> longitude = const Value.absent(),
    Value<double?> speed = const Value.absent(),
    Value<double?> acceleration = const Value.absent(),
    Value<double?> rpm = const Value.absent(),
    Value<double?> throttlePosition = const Value.absent(),
    Value<double?> engineLoad = const Value.absent(),
    Value<double?> fuelRate = const Value.absent(),
    Value<String?> rawDataJson = const Value.absent(),
  }) => TripDataPointsTableData(
    id: id ?? this.id,
    tripId: tripId ?? this.tripId,
    timestamp: timestamp ?? this.timestamp,
    latitude: latitude.present ? latitude.value : this.latitude,
    longitude: longitude.present ? longitude.value : this.longitude,
    speed: speed.present ? speed.value : this.speed,
    acceleration: acceleration.present ? acceleration.value : this.acceleration,
    rpm: rpm.present ? rpm.value : this.rpm,
    throttlePosition:
        throttlePosition.present
            ? throttlePosition.value
            : this.throttlePosition,
    engineLoad: engineLoad.present ? engineLoad.value : this.engineLoad,
    fuelRate: fuelRate.present ? fuelRate.value : this.fuelRate,
    rawDataJson: rawDataJson.present ? rawDataJson.value : this.rawDataJson,
  );
  TripDataPointsTableData copyWithCompanion(TripDataPointsTableCompanion data) {
    return TripDataPointsTableData(
      id: data.id.present ? data.id.value : this.id,
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      speed: data.speed.present ? data.speed.value : this.speed,
      acceleration:
          data.acceleration.present
              ? data.acceleration.value
              : this.acceleration,
      rpm: data.rpm.present ? data.rpm.value : this.rpm,
      throttlePosition:
          data.throttlePosition.present
              ? data.throttlePosition.value
              : this.throttlePosition,
      engineLoad:
          data.engineLoad.present ? data.engineLoad.value : this.engineLoad,
      fuelRate: data.fuelRate.present ? data.fuelRate.value : this.fuelRate,
      rawDataJson:
          data.rawDataJson.present ? data.rawDataJson.value : this.rawDataJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TripDataPointsTableData(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('timestamp: $timestamp, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('speed: $speed, ')
          ..write('acceleration: $acceleration, ')
          ..write('rpm: $rpm, ')
          ..write('throttlePosition: $throttlePosition, ')
          ..write('engineLoad: $engineLoad, ')
          ..write('fuelRate: $fuelRate, ')
          ..write('rawDataJson: $rawDataJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tripId,
    timestamp,
    latitude,
    longitude,
    speed,
    acceleration,
    rpm,
    throttlePosition,
    engineLoad,
    fuelRate,
    rawDataJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TripDataPointsTableData &&
          other.id == this.id &&
          other.tripId == this.tripId &&
          other.timestamp == this.timestamp &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.speed == this.speed &&
          other.acceleration == this.acceleration &&
          other.rpm == this.rpm &&
          other.throttlePosition == this.throttlePosition &&
          other.engineLoad == this.engineLoad &&
          other.fuelRate == this.fuelRate &&
          other.rawDataJson == this.rawDataJson);
}

class TripDataPointsTableCompanion
    extends UpdateCompanion<TripDataPointsTableData> {
  final Value<int> id;
  final Value<String> tripId;
  final Value<DateTime> timestamp;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<double?> speed;
  final Value<double?> acceleration;
  final Value<double?> rpm;
  final Value<double?> throttlePosition;
  final Value<double?> engineLoad;
  final Value<double?> fuelRate;
  final Value<String?> rawDataJson;
  const TripDataPointsTableCompanion({
    this.id = const Value.absent(),
    this.tripId = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.speed = const Value.absent(),
    this.acceleration = const Value.absent(),
    this.rpm = const Value.absent(),
    this.throttlePosition = const Value.absent(),
    this.engineLoad = const Value.absent(),
    this.fuelRate = const Value.absent(),
    this.rawDataJson = const Value.absent(),
  });
  TripDataPointsTableCompanion.insert({
    this.id = const Value.absent(),
    required String tripId,
    required DateTime timestamp,
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.speed = const Value.absent(),
    this.acceleration = const Value.absent(),
    this.rpm = const Value.absent(),
    this.throttlePosition = const Value.absent(),
    this.engineLoad = const Value.absent(),
    this.fuelRate = const Value.absent(),
    this.rawDataJson = const Value.absent(),
  }) : tripId = Value(tripId),
       timestamp = Value(timestamp);
  static Insertable<TripDataPointsTableData> custom({
    Expression<int>? id,
    Expression<String>? tripId,
    Expression<DateTime>? timestamp,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<double>? speed,
    Expression<double>? acceleration,
    Expression<double>? rpm,
    Expression<double>? throttlePosition,
    Expression<double>? engineLoad,
    Expression<double>? fuelRate,
    Expression<String>? rawDataJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tripId != null) 'trip_id': tripId,
      if (timestamp != null) 'timestamp': timestamp,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (speed != null) 'speed': speed,
      if (acceleration != null) 'acceleration': acceleration,
      if (rpm != null) 'rpm': rpm,
      if (throttlePosition != null) 'throttle_position': throttlePosition,
      if (engineLoad != null) 'engine_load': engineLoad,
      if (fuelRate != null) 'fuel_rate': fuelRate,
      if (rawDataJson != null) 'raw_data_json': rawDataJson,
    });
  }

  TripDataPointsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? tripId,
    Value<DateTime>? timestamp,
    Value<double?>? latitude,
    Value<double?>? longitude,
    Value<double?>? speed,
    Value<double?>? acceleration,
    Value<double?>? rpm,
    Value<double?>? throttlePosition,
    Value<double?>? engineLoad,
    Value<double?>? fuelRate,
    Value<String?>? rawDataJson,
  }) {
    return TripDataPointsTableCompanion(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      timestamp: timestamp ?? this.timestamp,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      speed: speed ?? this.speed,
      acceleration: acceleration ?? this.acceleration,
      rpm: rpm ?? this.rpm,
      throttlePosition: throttlePosition ?? this.throttlePosition,
      engineLoad: engineLoad ?? this.engineLoad,
      fuelRate: fuelRate ?? this.fuelRate,
      rawDataJson: rawDataJson ?? this.rawDataJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tripId.present) {
      map['trip_id'] = Variable<String>(tripId.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (speed.present) {
      map['speed'] = Variable<double>(speed.value);
    }
    if (acceleration.present) {
      map['acceleration'] = Variable<double>(acceleration.value);
    }
    if (rpm.present) {
      map['rpm'] = Variable<double>(rpm.value);
    }
    if (throttlePosition.present) {
      map['throttle_position'] = Variable<double>(throttlePosition.value);
    }
    if (engineLoad.present) {
      map['engine_load'] = Variable<double>(engineLoad.value);
    }
    if (fuelRate.present) {
      map['fuel_rate'] = Variable<double>(fuelRate.value);
    }
    if (rawDataJson.present) {
      map['raw_data_json'] = Variable<String>(rawDataJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TripDataPointsTableCompanion(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('timestamp: $timestamp, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('speed: $speed, ')
          ..write('acceleration: $acceleration, ')
          ..write('rpm: $rpm, ')
          ..write('throttlePosition: $throttlePosition, ')
          ..write('engineLoad: $engineLoad, ')
          ..write('fuelRate: $fuelRate, ')
          ..write('rawDataJson: $rawDataJson')
          ..write(')'))
        .toString();
  }
}

class $DrivingEventsTableTable extends DrivingEventsTable
    with TableInfo<$DrivingEventsTableTable, DrivingEventsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DrivingEventsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<String> tripId = GeneratedColumn<String>(
    'trip_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES trips_table (id)',
    ),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventTypeMeta = const VerificationMeta(
    'eventType',
  );
  @override
  late final GeneratedColumn<String> eventType = GeneratedColumn<String>(
    'event_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _severityMeta = const VerificationMeta(
    'severity',
  );
  @override
  late final GeneratedColumn<double> severity = GeneratedColumn<double>(
    'severity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.0),
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _detailsJsonMeta = const VerificationMeta(
    'detailsJson',
  );
  @override
  late final GeneratedColumn<String> detailsJson = GeneratedColumn<String>(
    'details_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tripId,
    timestamp,
    eventType,
    severity,
    latitude,
    longitude,
    detailsJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'driving_events_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<DrivingEventsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('event_type')) {
      context.handle(
        _eventTypeMeta,
        eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_eventTypeMeta);
    }
    if (data.containsKey('severity')) {
      context.handle(
        _severityMeta,
        severity.isAcceptableOrUnknown(data['severity']!, _severityMeta),
      );
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    }
    if (data.containsKey('details_json')) {
      context.handle(
        _detailsJsonMeta,
        detailsJson.isAcceptableOrUnknown(
          data['details_json']!,
          _detailsJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DrivingEventsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DrivingEventsTableData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      tripId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}trip_id'],
          )!,
      timestamp:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}timestamp'],
          )!,
      eventType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}event_type'],
          )!,
      severity:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}severity'],
          )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      ),
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      ),
      detailsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}details_json'],
      ),
    );
  }

  @override
  $DrivingEventsTableTable createAlias(String alias) {
    return $DrivingEventsTableTable(attachedDatabase, alias);
  }
}

class DrivingEventsTableData extends DataClass
    implements Insertable<DrivingEventsTableData> {
  final int id;
  final String tripId;
  final DateTime timestamp;
  final String eventType;
  final double severity;
  final double? latitude;
  final double? longitude;
  final String? detailsJson;
  const DrivingEventsTableData({
    required this.id,
    required this.tripId,
    required this.timestamp,
    required this.eventType,
    required this.severity,
    this.latitude,
    this.longitude,
    this.detailsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['trip_id'] = Variable<String>(tripId);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['event_type'] = Variable<String>(eventType);
    map['severity'] = Variable<double>(severity);
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    if (!nullToAbsent || detailsJson != null) {
      map['details_json'] = Variable<String>(detailsJson);
    }
    return map;
  }

  DrivingEventsTableCompanion toCompanion(bool nullToAbsent) {
    return DrivingEventsTableCompanion(
      id: Value(id),
      tripId: Value(tripId),
      timestamp: Value(timestamp),
      eventType: Value(eventType),
      severity: Value(severity),
      latitude:
          latitude == null && nullToAbsent
              ? const Value.absent()
              : Value(latitude),
      longitude:
          longitude == null && nullToAbsent
              ? const Value.absent()
              : Value(longitude),
      detailsJson:
          detailsJson == null && nullToAbsent
              ? const Value.absent()
              : Value(detailsJson),
    );
  }

  factory DrivingEventsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DrivingEventsTableData(
      id: serializer.fromJson<int>(json['id']),
      tripId: serializer.fromJson<String>(json['tripId']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      eventType: serializer.fromJson<String>(json['eventType']),
      severity: serializer.fromJson<double>(json['severity']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      detailsJson: serializer.fromJson<String?>(json['detailsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tripId': serializer.toJson<String>(tripId),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'eventType': serializer.toJson<String>(eventType),
      'severity': serializer.toJson<double>(severity),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'detailsJson': serializer.toJson<String?>(detailsJson),
    };
  }

  DrivingEventsTableData copyWith({
    int? id,
    String? tripId,
    DateTime? timestamp,
    String? eventType,
    double? severity,
    Value<double?> latitude = const Value.absent(),
    Value<double?> longitude = const Value.absent(),
    Value<String?> detailsJson = const Value.absent(),
  }) => DrivingEventsTableData(
    id: id ?? this.id,
    tripId: tripId ?? this.tripId,
    timestamp: timestamp ?? this.timestamp,
    eventType: eventType ?? this.eventType,
    severity: severity ?? this.severity,
    latitude: latitude.present ? latitude.value : this.latitude,
    longitude: longitude.present ? longitude.value : this.longitude,
    detailsJson: detailsJson.present ? detailsJson.value : this.detailsJson,
  );
  DrivingEventsTableData copyWithCompanion(DrivingEventsTableCompanion data) {
    return DrivingEventsTableData(
      id: data.id.present ? data.id.value : this.id,
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      severity: data.severity.present ? data.severity.value : this.severity,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      detailsJson:
          data.detailsJson.present ? data.detailsJson.value : this.detailsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DrivingEventsTableData(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('timestamp: $timestamp, ')
          ..write('eventType: $eventType, ')
          ..write('severity: $severity, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('detailsJson: $detailsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tripId,
    timestamp,
    eventType,
    severity,
    latitude,
    longitude,
    detailsJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DrivingEventsTableData &&
          other.id == this.id &&
          other.tripId == this.tripId &&
          other.timestamp == this.timestamp &&
          other.eventType == this.eventType &&
          other.severity == this.severity &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.detailsJson == this.detailsJson);
}

class DrivingEventsTableCompanion
    extends UpdateCompanion<DrivingEventsTableData> {
  final Value<int> id;
  final Value<String> tripId;
  final Value<DateTime> timestamp;
  final Value<String> eventType;
  final Value<double> severity;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<String?> detailsJson;
  const DrivingEventsTableCompanion({
    this.id = const Value.absent(),
    this.tripId = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.eventType = const Value.absent(),
    this.severity = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.detailsJson = const Value.absent(),
  });
  DrivingEventsTableCompanion.insert({
    this.id = const Value.absent(),
    required String tripId,
    required DateTime timestamp,
    required String eventType,
    this.severity = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.detailsJson = const Value.absent(),
  }) : tripId = Value(tripId),
       timestamp = Value(timestamp),
       eventType = Value(eventType);
  static Insertable<DrivingEventsTableData> custom({
    Expression<int>? id,
    Expression<String>? tripId,
    Expression<DateTime>? timestamp,
    Expression<String>? eventType,
    Expression<double>? severity,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? detailsJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tripId != null) 'trip_id': tripId,
      if (timestamp != null) 'timestamp': timestamp,
      if (eventType != null) 'event_type': eventType,
      if (severity != null) 'severity': severity,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (detailsJson != null) 'details_json': detailsJson,
    });
  }

  DrivingEventsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? tripId,
    Value<DateTime>? timestamp,
    Value<String>? eventType,
    Value<double>? severity,
    Value<double?>? latitude,
    Value<double?>? longitude,
    Value<String?>? detailsJson,
  }) {
    return DrivingEventsTableCompanion(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      timestamp: timestamp ?? this.timestamp,
      eventType: eventType ?? this.eventType,
      severity: severity ?? this.severity,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      detailsJson: detailsJson ?? this.detailsJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tripId.present) {
      map['trip_id'] = Variable<String>(tripId.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(eventType.value);
    }
    if (severity.present) {
      map['severity'] = Variable<double>(severity.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (detailsJson.present) {
      map['details_json'] = Variable<String>(detailsJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DrivingEventsTableCompanion(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('timestamp: $timestamp, ')
          ..write('eventType: $eventType, ')
          ..write('severity: $severity, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('detailsJson: $detailsJson')
          ..write(')'))
        .toString();
  }
}

class $UserProfilesTableTable extends UserProfilesTable
    with TableInfo<$UserProfilesTableTable, UserProfilesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 36,
      maxTextLength: 36,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastUpdatedAtMeta = const VerificationMeta(
    'lastUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastUpdatedAt =
      GeneratedColumn<DateTime>(
        'last_updated_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _isPublicMeta = const VerificationMeta(
    'isPublic',
  );
  @override
  late final GeneratedColumn<bool> isPublic = GeneratedColumn<bool>(
    'is_public',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_public" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _allowDataUploadMeta = const VerificationMeta(
    'allowDataUpload',
  );
  @override
  late final GeneratedColumn<bool> allowDataUpload = GeneratedColumn<bool>(
    'allow_data_upload',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("allow_data_upload" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _preferencesJsonMeta = const VerificationMeta(
    'preferencesJson',
  );
  @override
  late final GeneratedColumn<String> preferencesJson = GeneratedColumn<String>(
    'preferences_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    createdAt,
    lastUpdatedAt,
    isPublic,
    allowDataUpload,
    preferencesJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfilesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('last_updated_at')) {
      context.handle(
        _lastUpdatedAtMeta,
        lastUpdatedAt.isAcceptableOrUnknown(
          data['last_updated_at']!,
          _lastUpdatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastUpdatedAtMeta);
    }
    if (data.containsKey('is_public')) {
      context.handle(
        _isPublicMeta,
        isPublic.isAcceptableOrUnknown(data['is_public']!, _isPublicMeta),
      );
    }
    if (data.containsKey('allow_data_upload')) {
      context.handle(
        _allowDataUploadMeta,
        allowDataUpload.isAcceptableOrUnknown(
          data['allow_data_upload']!,
          _allowDataUploadMeta,
        ),
      );
    }
    if (data.containsKey('preferences_json')) {
      context.handle(
        _preferencesJsonMeta,
        preferencesJson.isAcceptableOrUnknown(
          data['preferences_json']!,
          _preferencesJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfilesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfilesTableData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      lastUpdatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}last_updated_at'],
          )!,
      isPublic:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_public'],
          )!,
      allowDataUpload:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}allow_data_upload'],
          )!,
      preferencesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preferences_json'],
      ),
    );
  }

  @override
  $UserProfilesTableTable createAlias(String alias) {
    return $UserProfilesTableTable(attachedDatabase, alias);
  }
}

class UserProfilesTableData extends DataClass
    implements Insertable<UserProfilesTableData> {
  final String id;
  final String? name;
  final DateTime createdAt;
  final DateTime lastUpdatedAt;
  final bool isPublic;
  final bool allowDataUpload;
  final String? preferencesJson;
  const UserProfilesTableData({
    required this.id,
    this.name,
    required this.createdAt,
    required this.lastUpdatedAt,
    required this.isPublic,
    required this.allowDataUpload,
    this.preferencesJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['last_updated_at'] = Variable<DateTime>(lastUpdatedAt);
    map['is_public'] = Variable<bool>(isPublic);
    map['allow_data_upload'] = Variable<bool>(allowDataUpload);
    if (!nullToAbsent || preferencesJson != null) {
      map['preferences_json'] = Variable<String>(preferencesJson);
    }
    return map;
  }

  UserProfilesTableCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesTableCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      createdAt: Value(createdAt),
      lastUpdatedAt: Value(lastUpdatedAt),
      isPublic: Value(isPublic),
      allowDataUpload: Value(allowDataUpload),
      preferencesJson:
          preferencesJson == null && nullToAbsent
              ? const Value.absent()
              : Value(preferencesJson),
    );
  }

  factory UserProfilesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfilesTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastUpdatedAt: serializer.fromJson<DateTime>(json['lastUpdatedAt']),
      isPublic: serializer.fromJson<bool>(json['isPublic']),
      allowDataUpload: serializer.fromJson<bool>(json['allowDataUpload']),
      preferencesJson: serializer.fromJson<String?>(json['preferencesJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String?>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastUpdatedAt': serializer.toJson<DateTime>(lastUpdatedAt),
      'isPublic': serializer.toJson<bool>(isPublic),
      'allowDataUpload': serializer.toJson<bool>(allowDataUpload),
      'preferencesJson': serializer.toJson<String?>(preferencesJson),
    };
  }

  UserProfilesTableData copyWith({
    String? id,
    Value<String?> name = const Value.absent(),
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
    bool? isPublic,
    bool? allowDataUpload,
    Value<String?> preferencesJson = const Value.absent(),
  }) => UserProfilesTableData(
    id: id ?? this.id,
    name: name.present ? name.value : this.name,
    createdAt: createdAt ?? this.createdAt,
    lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    isPublic: isPublic ?? this.isPublic,
    allowDataUpload: allowDataUpload ?? this.allowDataUpload,
    preferencesJson:
        preferencesJson.present ? preferencesJson.value : this.preferencesJson,
  );
  UserProfilesTableData copyWithCompanion(UserProfilesTableCompanion data) {
    return UserProfilesTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastUpdatedAt:
          data.lastUpdatedAt.present
              ? data.lastUpdatedAt.value
              : this.lastUpdatedAt,
      isPublic: data.isPublic.present ? data.isPublic.value : this.isPublic,
      allowDataUpload:
          data.allowDataUpload.present
              ? data.allowDataUpload.value
              : this.allowDataUpload,
      preferencesJson:
          data.preferencesJson.present
              ? data.preferencesJson.value
              : this.preferencesJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastUpdatedAt: $lastUpdatedAt, ')
          ..write('isPublic: $isPublic, ')
          ..write('allowDataUpload: $allowDataUpload, ')
          ..write('preferencesJson: $preferencesJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    createdAt,
    lastUpdatedAt,
    isPublic,
    allowDataUpload,
    preferencesJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfilesTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt &&
          other.lastUpdatedAt == this.lastUpdatedAt &&
          other.isPublic == this.isPublic &&
          other.allowDataUpload == this.allowDataUpload &&
          other.preferencesJson == this.preferencesJson);
}

class UserProfilesTableCompanion
    extends UpdateCompanion<UserProfilesTableData> {
  final Value<String> id;
  final Value<String?> name;
  final Value<DateTime> createdAt;
  final Value<DateTime> lastUpdatedAt;
  final Value<bool> isPublic;
  final Value<bool> allowDataUpload;
  final Value<String?> preferencesJson;
  final Value<int> rowid;
  const UserProfilesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastUpdatedAt = const Value.absent(),
    this.isPublic = const Value.absent(),
    this.allowDataUpload = const Value.absent(),
    this.preferencesJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserProfilesTableCompanion.insert({
    required String id,
    this.name = const Value.absent(),
    required DateTime createdAt,
    required DateTime lastUpdatedAt,
    this.isPublic = const Value.absent(),
    this.allowDataUpload = const Value.absent(),
    this.preferencesJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       lastUpdatedAt = Value(lastUpdatedAt);
  static Insertable<UserProfilesTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastUpdatedAt,
    Expression<bool>? isPublic,
    Expression<bool>? allowDataUpload,
    Expression<String>? preferencesJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (lastUpdatedAt != null) 'last_updated_at': lastUpdatedAt,
      if (isPublic != null) 'is_public': isPublic,
      if (allowDataUpload != null) 'allow_data_upload': allowDataUpload,
      if (preferencesJson != null) 'preferences_json': preferencesJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserProfilesTableCompanion copyWith({
    Value<String>? id,
    Value<String?>? name,
    Value<DateTime>? createdAt,
    Value<DateTime>? lastUpdatedAt,
    Value<bool>? isPublic,
    Value<bool>? allowDataUpload,
    Value<String?>? preferencesJson,
    Value<int>? rowid,
  }) {
    return UserProfilesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      isPublic: isPublic ?? this.isPublic,
      allowDataUpload: allowDataUpload ?? this.allowDataUpload,
      preferencesJson: preferencesJson ?? this.preferencesJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastUpdatedAt.present) {
      map['last_updated_at'] = Variable<DateTime>(lastUpdatedAt.value);
    }
    if (isPublic.present) {
      map['is_public'] = Variable<bool>(isPublic.value);
    }
    if (allowDataUpload.present) {
      map['allow_data_upload'] = Variable<bool>(allowDataUpload.value);
    }
    if (preferencesJson.present) {
      map['preferences_json'] = Variable<String>(preferencesJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastUpdatedAt: $lastUpdatedAt, ')
          ..write('isPublic: $isPublic, ')
          ..write('allowDataUpload: $allowDataUpload, ')
          ..write('preferencesJson: $preferencesJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PerformanceMetricsTableTable extends PerformanceMetricsTable
    with TableInfo<$PerformanceMetricsTableTable, PerformanceMetricsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PerformanceMetricsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES user_profiles_table (id)',
    ),
  );
  static const VerificationMeta _generatedAtMeta = const VerificationMeta(
    'generatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> generatedAt = GeneratedColumn<DateTime>(
    'generated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _periodStartMeta = const VerificationMeta(
    'periodStart',
  );
  @override
  late final GeneratedColumn<DateTime> periodStart = GeneratedColumn<DateTime>(
    'period_start',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _periodEndMeta = const VerificationMeta(
    'periodEnd',
  );
  @override
  late final GeneratedColumn<DateTime> periodEnd = GeneratedColumn<DateTime>(
    'period_end',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalTripsMeta = const VerificationMeta(
    'totalTrips',
  );
  @override
  late final GeneratedColumn<int> totalTrips = GeneratedColumn<int>(
    'total_trips',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalDistanceKmMeta = const VerificationMeta(
    'totalDistanceKm',
  );
  @override
  late final GeneratedColumn<double> totalDistanceKm = GeneratedColumn<double>(
    'total_distance_km',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalDrivingTimeMinutesMeta =
      const VerificationMeta('totalDrivingTimeMinutes');
  @override
  late final GeneratedColumn<double> totalDrivingTimeMinutes =
      GeneratedColumn<double>(
        'total_driving_time_minutes',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _averageSpeedKmhMeta = const VerificationMeta(
    'averageSpeedKmh',
  );
  @override
  late final GeneratedColumn<double> averageSpeedKmh = GeneratedColumn<double>(
    'average_speed_kmh',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estimatedFuelSavingsPercentMeta =
      const VerificationMeta('estimatedFuelSavingsPercent');
  @override
  late final GeneratedColumn<double> estimatedFuelSavingsPercent =
      GeneratedColumn<double>(
        'estimated_fuel_savings_percent',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _estimatedCO2ReductionKgMeta =
      const VerificationMeta('estimatedCO2ReductionKg');
  @override
  late final GeneratedColumn<double> estimatedCO2ReductionKg =
      GeneratedColumn<double>(
        'estimated_c_o2_reduction_kg',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _calmDrivingScoreMeta = const VerificationMeta(
    'calmDrivingScore',
  );
  @override
  late final GeneratedColumn<int> calmDrivingScore = GeneratedColumn<int>(
    'calm_driving_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _speedOptimizationScoreMeta =
      const VerificationMeta('speedOptimizationScore');
  @override
  late final GeneratedColumn<int> speedOptimizationScore = GeneratedColumn<int>(
    'speed_optimization_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idlingScoreMeta = const VerificationMeta(
    'idlingScore',
  );
  @override
  late final GeneratedColumn<int> idlingScore = GeneratedColumn<int>(
    'idling_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _shortDistanceScoreMeta =
      const VerificationMeta('shortDistanceScore');
  @override
  late final GeneratedColumn<int> shortDistanceScore = GeneratedColumn<int>(
    'short_distance_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rpmManagementScoreMeta =
      const VerificationMeta('rpmManagementScore');
  @override
  late final GeneratedColumn<int> rpmManagementScore = GeneratedColumn<int>(
    'rpm_management_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stopManagementScoreMeta =
      const VerificationMeta('stopManagementScore');
  @override
  late final GeneratedColumn<int> stopManagementScore = GeneratedColumn<int>(
    'stop_management_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _followDistanceScoreMeta =
      const VerificationMeta('followDistanceScore');
  @override
  late final GeneratedColumn<int> followDistanceScore = GeneratedColumn<int>(
    'follow_distance_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _overallScoreMeta = const VerificationMeta(
    'overallScore',
  );
  @override
  late final GeneratedColumn<int> overallScore = GeneratedColumn<int>(
    'overall_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _improvementTipsJsonMeta =
      const VerificationMeta('improvementTipsJson');
  @override
  late final GeneratedColumn<String> improvementTipsJson =
      GeneratedColumn<String>(
        'improvement_tips_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    generatedAt,
    periodStart,
    periodEnd,
    totalTrips,
    totalDistanceKm,
    totalDrivingTimeMinutes,
    averageSpeedKmh,
    estimatedFuelSavingsPercent,
    estimatedCO2ReductionKg,
    calmDrivingScore,
    speedOptimizationScore,
    idlingScore,
    shortDistanceScore,
    rpmManagementScore,
    stopManagementScore,
    followDistanceScore,
    overallScore,
    improvementTipsJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'performance_metrics_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PerformanceMetricsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('generated_at')) {
      context.handle(
        _generatedAtMeta,
        generatedAt.isAcceptableOrUnknown(
          data['generated_at']!,
          _generatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_generatedAtMeta);
    }
    if (data.containsKey('period_start')) {
      context.handle(
        _periodStartMeta,
        periodStart.isAcceptableOrUnknown(
          data['period_start']!,
          _periodStartMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_periodStartMeta);
    }
    if (data.containsKey('period_end')) {
      context.handle(
        _periodEndMeta,
        periodEnd.isAcceptableOrUnknown(data['period_end']!, _periodEndMeta),
      );
    } else if (isInserting) {
      context.missing(_periodEndMeta);
    }
    if (data.containsKey('total_trips')) {
      context.handle(
        _totalTripsMeta,
        totalTrips.isAcceptableOrUnknown(data['total_trips']!, _totalTripsMeta),
      );
    } else if (isInserting) {
      context.missing(_totalTripsMeta);
    }
    if (data.containsKey('total_distance_km')) {
      context.handle(
        _totalDistanceKmMeta,
        totalDistanceKm.isAcceptableOrUnknown(
          data['total_distance_km']!,
          _totalDistanceKmMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalDistanceKmMeta);
    }
    if (data.containsKey('total_driving_time_minutes')) {
      context.handle(
        _totalDrivingTimeMinutesMeta,
        totalDrivingTimeMinutes.isAcceptableOrUnknown(
          data['total_driving_time_minutes']!,
          _totalDrivingTimeMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalDrivingTimeMinutesMeta);
    }
    if (data.containsKey('average_speed_kmh')) {
      context.handle(
        _averageSpeedKmhMeta,
        averageSpeedKmh.isAcceptableOrUnknown(
          data['average_speed_kmh']!,
          _averageSpeedKmhMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_averageSpeedKmhMeta);
    }
    if (data.containsKey('estimated_fuel_savings_percent')) {
      context.handle(
        _estimatedFuelSavingsPercentMeta,
        estimatedFuelSavingsPercent.isAcceptableOrUnknown(
          data['estimated_fuel_savings_percent']!,
          _estimatedFuelSavingsPercentMeta,
        ),
      );
    }
    if (data.containsKey('estimated_c_o2_reduction_kg')) {
      context.handle(
        _estimatedCO2ReductionKgMeta,
        estimatedCO2ReductionKg.isAcceptableOrUnknown(
          data['estimated_c_o2_reduction_kg']!,
          _estimatedCO2ReductionKgMeta,
        ),
      );
    }
    if (data.containsKey('calm_driving_score')) {
      context.handle(
        _calmDrivingScoreMeta,
        calmDrivingScore.isAcceptableOrUnknown(
          data['calm_driving_score']!,
          _calmDrivingScoreMeta,
        ),
      );
    }
    if (data.containsKey('speed_optimization_score')) {
      context.handle(
        _speedOptimizationScoreMeta,
        speedOptimizationScore.isAcceptableOrUnknown(
          data['speed_optimization_score']!,
          _speedOptimizationScoreMeta,
        ),
      );
    }
    if (data.containsKey('idling_score')) {
      context.handle(
        _idlingScoreMeta,
        idlingScore.isAcceptableOrUnknown(
          data['idling_score']!,
          _idlingScoreMeta,
        ),
      );
    }
    if (data.containsKey('short_distance_score')) {
      context.handle(
        _shortDistanceScoreMeta,
        shortDistanceScore.isAcceptableOrUnknown(
          data['short_distance_score']!,
          _shortDistanceScoreMeta,
        ),
      );
    }
    if (data.containsKey('rpm_management_score')) {
      context.handle(
        _rpmManagementScoreMeta,
        rpmManagementScore.isAcceptableOrUnknown(
          data['rpm_management_score']!,
          _rpmManagementScoreMeta,
        ),
      );
    }
    if (data.containsKey('stop_management_score')) {
      context.handle(
        _stopManagementScoreMeta,
        stopManagementScore.isAcceptableOrUnknown(
          data['stop_management_score']!,
          _stopManagementScoreMeta,
        ),
      );
    }
    if (data.containsKey('follow_distance_score')) {
      context.handle(
        _followDistanceScoreMeta,
        followDistanceScore.isAcceptableOrUnknown(
          data['follow_distance_score']!,
          _followDistanceScoreMeta,
        ),
      );
    }
    if (data.containsKey('overall_score')) {
      context.handle(
        _overallScoreMeta,
        overallScore.isAcceptableOrUnknown(
          data['overall_score']!,
          _overallScoreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_overallScoreMeta);
    }
    if (data.containsKey('improvement_tips_json')) {
      context.handle(
        _improvementTipsJsonMeta,
        improvementTipsJson.isAcceptableOrUnknown(
          data['improvement_tips_json']!,
          _improvementTipsJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PerformanceMetricsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PerformanceMetricsTableData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      userId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}user_id'],
          )!,
      generatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}generated_at'],
          )!,
      periodStart:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}period_start'],
          )!,
      periodEnd:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}period_end'],
          )!,
      totalTrips:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}total_trips'],
          )!,
      totalDistanceKm:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}total_distance_km'],
          )!,
      totalDrivingTimeMinutes:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}total_driving_time_minutes'],
          )!,
      averageSpeedKmh:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}average_speed_kmh'],
          )!,
      estimatedFuelSavingsPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}estimated_fuel_savings_percent'],
      ),
      estimatedCO2ReductionKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}estimated_c_o2_reduction_kg'],
      ),
      calmDrivingScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}calm_driving_score'],
      ),
      speedOptimizationScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}speed_optimization_score'],
      ),
      idlingScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}idling_score'],
      ),
      shortDistanceScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}short_distance_score'],
      ),
      rpmManagementScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rpm_management_score'],
      ),
      stopManagementScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stop_management_score'],
      ),
      followDistanceScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}follow_distance_score'],
      ),
      overallScore:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}overall_score'],
          )!,
      improvementTipsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}improvement_tips_json'],
      ),
    );
  }

  @override
  $PerformanceMetricsTableTable createAlias(String alias) {
    return $PerformanceMetricsTableTable(attachedDatabase, alias);
  }
}

class PerformanceMetricsTableData extends DataClass
    implements Insertable<PerformanceMetricsTableData> {
  final int id;
  final String userId;
  final DateTime generatedAt;
  final DateTime periodStart;
  final DateTime periodEnd;
  final int totalTrips;
  final double totalDistanceKm;
  final double totalDrivingTimeMinutes;
  final double averageSpeedKmh;
  final double? estimatedFuelSavingsPercent;
  final double? estimatedCO2ReductionKg;
  final int? calmDrivingScore;
  final int? speedOptimizationScore;
  final int? idlingScore;
  final int? shortDistanceScore;
  final int? rpmManagementScore;
  final int? stopManagementScore;
  final int? followDistanceScore;
  final int overallScore;
  final String? improvementTipsJson;
  const PerformanceMetricsTableData({
    required this.id,
    required this.userId,
    required this.generatedAt,
    required this.periodStart,
    required this.periodEnd,
    required this.totalTrips,
    required this.totalDistanceKm,
    required this.totalDrivingTimeMinutes,
    required this.averageSpeedKmh,
    this.estimatedFuelSavingsPercent,
    this.estimatedCO2ReductionKg,
    this.calmDrivingScore,
    this.speedOptimizationScore,
    this.idlingScore,
    this.shortDistanceScore,
    this.rpmManagementScore,
    this.stopManagementScore,
    this.followDistanceScore,
    required this.overallScore,
    this.improvementTipsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<String>(userId);
    map['generated_at'] = Variable<DateTime>(generatedAt);
    map['period_start'] = Variable<DateTime>(periodStart);
    map['period_end'] = Variable<DateTime>(periodEnd);
    map['total_trips'] = Variable<int>(totalTrips);
    map['total_distance_km'] = Variable<double>(totalDistanceKm);
    map['total_driving_time_minutes'] = Variable<double>(
      totalDrivingTimeMinutes,
    );
    map['average_speed_kmh'] = Variable<double>(averageSpeedKmh);
    if (!nullToAbsent || estimatedFuelSavingsPercent != null) {
      map['estimated_fuel_savings_percent'] = Variable<double>(
        estimatedFuelSavingsPercent,
      );
    }
    if (!nullToAbsent || estimatedCO2ReductionKg != null) {
      map['estimated_c_o2_reduction_kg'] = Variable<double>(
        estimatedCO2ReductionKg,
      );
    }
    if (!nullToAbsent || calmDrivingScore != null) {
      map['calm_driving_score'] = Variable<int>(calmDrivingScore);
    }
    if (!nullToAbsent || speedOptimizationScore != null) {
      map['speed_optimization_score'] = Variable<int>(speedOptimizationScore);
    }
    if (!nullToAbsent || idlingScore != null) {
      map['idling_score'] = Variable<int>(idlingScore);
    }
    if (!nullToAbsent || shortDistanceScore != null) {
      map['short_distance_score'] = Variable<int>(shortDistanceScore);
    }
    if (!nullToAbsent || rpmManagementScore != null) {
      map['rpm_management_score'] = Variable<int>(rpmManagementScore);
    }
    if (!nullToAbsent || stopManagementScore != null) {
      map['stop_management_score'] = Variable<int>(stopManagementScore);
    }
    if (!nullToAbsent || followDistanceScore != null) {
      map['follow_distance_score'] = Variable<int>(followDistanceScore);
    }
    map['overall_score'] = Variable<int>(overallScore);
    if (!nullToAbsent || improvementTipsJson != null) {
      map['improvement_tips_json'] = Variable<String>(improvementTipsJson);
    }
    return map;
  }

  PerformanceMetricsTableCompanion toCompanion(bool nullToAbsent) {
    return PerformanceMetricsTableCompanion(
      id: Value(id),
      userId: Value(userId),
      generatedAt: Value(generatedAt),
      periodStart: Value(periodStart),
      periodEnd: Value(periodEnd),
      totalTrips: Value(totalTrips),
      totalDistanceKm: Value(totalDistanceKm),
      totalDrivingTimeMinutes: Value(totalDrivingTimeMinutes),
      averageSpeedKmh: Value(averageSpeedKmh),
      estimatedFuelSavingsPercent:
          estimatedFuelSavingsPercent == null && nullToAbsent
              ? const Value.absent()
              : Value(estimatedFuelSavingsPercent),
      estimatedCO2ReductionKg:
          estimatedCO2ReductionKg == null && nullToAbsent
              ? const Value.absent()
              : Value(estimatedCO2ReductionKg),
      calmDrivingScore:
          calmDrivingScore == null && nullToAbsent
              ? const Value.absent()
              : Value(calmDrivingScore),
      speedOptimizationScore:
          speedOptimizationScore == null && nullToAbsent
              ? const Value.absent()
              : Value(speedOptimizationScore),
      idlingScore:
          idlingScore == null && nullToAbsent
              ? const Value.absent()
              : Value(idlingScore),
      shortDistanceScore:
          shortDistanceScore == null && nullToAbsent
              ? const Value.absent()
              : Value(shortDistanceScore),
      rpmManagementScore:
          rpmManagementScore == null && nullToAbsent
              ? const Value.absent()
              : Value(rpmManagementScore),
      stopManagementScore:
          stopManagementScore == null && nullToAbsent
              ? const Value.absent()
              : Value(stopManagementScore),
      followDistanceScore:
          followDistanceScore == null && nullToAbsent
              ? const Value.absent()
              : Value(followDistanceScore),
      overallScore: Value(overallScore),
      improvementTipsJson:
          improvementTipsJson == null && nullToAbsent
              ? const Value.absent()
              : Value(improvementTipsJson),
    );
  }

  factory PerformanceMetricsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PerformanceMetricsTableData(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      generatedAt: serializer.fromJson<DateTime>(json['generatedAt']),
      periodStart: serializer.fromJson<DateTime>(json['periodStart']),
      periodEnd: serializer.fromJson<DateTime>(json['periodEnd']),
      totalTrips: serializer.fromJson<int>(json['totalTrips']),
      totalDistanceKm: serializer.fromJson<double>(json['totalDistanceKm']),
      totalDrivingTimeMinutes: serializer.fromJson<double>(
        json['totalDrivingTimeMinutes'],
      ),
      averageSpeedKmh: serializer.fromJson<double>(json['averageSpeedKmh']),
      estimatedFuelSavingsPercent: serializer.fromJson<double?>(
        json['estimatedFuelSavingsPercent'],
      ),
      estimatedCO2ReductionKg: serializer.fromJson<double?>(
        json['estimatedCO2ReductionKg'],
      ),
      calmDrivingScore: serializer.fromJson<int?>(json['calmDrivingScore']),
      speedOptimizationScore: serializer.fromJson<int?>(
        json['speedOptimizationScore'],
      ),
      idlingScore: serializer.fromJson<int?>(json['idlingScore']),
      shortDistanceScore: serializer.fromJson<int?>(json['shortDistanceScore']),
      rpmManagementScore: serializer.fromJson<int?>(json['rpmManagementScore']),
      stopManagementScore: serializer.fromJson<int?>(
        json['stopManagementScore'],
      ),
      followDistanceScore: serializer.fromJson<int?>(
        json['followDistanceScore'],
      ),
      overallScore: serializer.fromJson<int>(json['overallScore']),
      improvementTipsJson: serializer.fromJson<String?>(
        json['improvementTipsJson'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String>(userId),
      'generatedAt': serializer.toJson<DateTime>(generatedAt),
      'periodStart': serializer.toJson<DateTime>(periodStart),
      'periodEnd': serializer.toJson<DateTime>(periodEnd),
      'totalTrips': serializer.toJson<int>(totalTrips),
      'totalDistanceKm': serializer.toJson<double>(totalDistanceKm),
      'totalDrivingTimeMinutes': serializer.toJson<double>(
        totalDrivingTimeMinutes,
      ),
      'averageSpeedKmh': serializer.toJson<double>(averageSpeedKmh),
      'estimatedFuelSavingsPercent': serializer.toJson<double?>(
        estimatedFuelSavingsPercent,
      ),
      'estimatedCO2ReductionKg': serializer.toJson<double?>(
        estimatedCO2ReductionKg,
      ),
      'calmDrivingScore': serializer.toJson<int?>(calmDrivingScore),
      'speedOptimizationScore': serializer.toJson<int?>(speedOptimizationScore),
      'idlingScore': serializer.toJson<int?>(idlingScore),
      'shortDistanceScore': serializer.toJson<int?>(shortDistanceScore),
      'rpmManagementScore': serializer.toJson<int?>(rpmManagementScore),
      'stopManagementScore': serializer.toJson<int?>(stopManagementScore),
      'followDistanceScore': serializer.toJson<int?>(followDistanceScore),
      'overallScore': serializer.toJson<int>(overallScore),
      'improvementTipsJson': serializer.toJson<String?>(improvementTipsJson),
    };
  }

  PerformanceMetricsTableData copyWith({
    int? id,
    String? userId,
    DateTime? generatedAt,
    DateTime? periodStart,
    DateTime? periodEnd,
    int? totalTrips,
    double? totalDistanceKm,
    double? totalDrivingTimeMinutes,
    double? averageSpeedKmh,
    Value<double?> estimatedFuelSavingsPercent = const Value.absent(),
    Value<double?> estimatedCO2ReductionKg = const Value.absent(),
    Value<int?> calmDrivingScore = const Value.absent(),
    Value<int?> speedOptimizationScore = const Value.absent(),
    Value<int?> idlingScore = const Value.absent(),
    Value<int?> shortDistanceScore = const Value.absent(),
    Value<int?> rpmManagementScore = const Value.absent(),
    Value<int?> stopManagementScore = const Value.absent(),
    Value<int?> followDistanceScore = const Value.absent(),
    int? overallScore,
    Value<String?> improvementTipsJson = const Value.absent(),
  }) => PerformanceMetricsTableData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    generatedAt: generatedAt ?? this.generatedAt,
    periodStart: periodStart ?? this.periodStart,
    periodEnd: periodEnd ?? this.periodEnd,
    totalTrips: totalTrips ?? this.totalTrips,
    totalDistanceKm: totalDistanceKm ?? this.totalDistanceKm,
    totalDrivingTimeMinutes:
        totalDrivingTimeMinutes ?? this.totalDrivingTimeMinutes,
    averageSpeedKmh: averageSpeedKmh ?? this.averageSpeedKmh,
    estimatedFuelSavingsPercent:
        estimatedFuelSavingsPercent.present
            ? estimatedFuelSavingsPercent.value
            : this.estimatedFuelSavingsPercent,
    estimatedCO2ReductionKg:
        estimatedCO2ReductionKg.present
            ? estimatedCO2ReductionKg.value
            : this.estimatedCO2ReductionKg,
    calmDrivingScore:
        calmDrivingScore.present
            ? calmDrivingScore.value
            : this.calmDrivingScore,
    speedOptimizationScore:
        speedOptimizationScore.present
            ? speedOptimizationScore.value
            : this.speedOptimizationScore,
    idlingScore: idlingScore.present ? idlingScore.value : this.idlingScore,
    shortDistanceScore:
        shortDistanceScore.present
            ? shortDistanceScore.value
            : this.shortDistanceScore,
    rpmManagementScore:
        rpmManagementScore.present
            ? rpmManagementScore.value
            : this.rpmManagementScore,
    stopManagementScore:
        stopManagementScore.present
            ? stopManagementScore.value
            : this.stopManagementScore,
    followDistanceScore:
        followDistanceScore.present
            ? followDistanceScore.value
            : this.followDistanceScore,
    overallScore: overallScore ?? this.overallScore,
    improvementTipsJson:
        improvementTipsJson.present
            ? improvementTipsJson.value
            : this.improvementTipsJson,
  );
  PerformanceMetricsTableData copyWithCompanion(
    PerformanceMetricsTableCompanion data,
  ) {
    return PerformanceMetricsTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      generatedAt:
          data.generatedAt.present ? data.generatedAt.value : this.generatedAt,
      periodStart:
          data.periodStart.present ? data.periodStart.value : this.periodStart,
      periodEnd: data.periodEnd.present ? data.periodEnd.value : this.periodEnd,
      totalTrips:
          data.totalTrips.present ? data.totalTrips.value : this.totalTrips,
      totalDistanceKm:
          data.totalDistanceKm.present
              ? data.totalDistanceKm.value
              : this.totalDistanceKm,
      totalDrivingTimeMinutes:
          data.totalDrivingTimeMinutes.present
              ? data.totalDrivingTimeMinutes.value
              : this.totalDrivingTimeMinutes,
      averageSpeedKmh:
          data.averageSpeedKmh.present
              ? data.averageSpeedKmh.value
              : this.averageSpeedKmh,
      estimatedFuelSavingsPercent:
          data.estimatedFuelSavingsPercent.present
              ? data.estimatedFuelSavingsPercent.value
              : this.estimatedFuelSavingsPercent,
      estimatedCO2ReductionKg:
          data.estimatedCO2ReductionKg.present
              ? data.estimatedCO2ReductionKg.value
              : this.estimatedCO2ReductionKg,
      calmDrivingScore:
          data.calmDrivingScore.present
              ? data.calmDrivingScore.value
              : this.calmDrivingScore,
      speedOptimizationScore:
          data.speedOptimizationScore.present
              ? data.speedOptimizationScore.value
              : this.speedOptimizationScore,
      idlingScore:
          data.idlingScore.present ? data.idlingScore.value : this.idlingScore,
      shortDistanceScore:
          data.shortDistanceScore.present
              ? data.shortDistanceScore.value
              : this.shortDistanceScore,
      rpmManagementScore:
          data.rpmManagementScore.present
              ? data.rpmManagementScore.value
              : this.rpmManagementScore,
      stopManagementScore:
          data.stopManagementScore.present
              ? data.stopManagementScore.value
              : this.stopManagementScore,
      followDistanceScore:
          data.followDistanceScore.present
              ? data.followDistanceScore.value
              : this.followDistanceScore,
      overallScore:
          data.overallScore.present
              ? data.overallScore.value
              : this.overallScore,
      improvementTipsJson:
          data.improvementTipsJson.present
              ? data.improvementTipsJson.value
              : this.improvementTipsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PerformanceMetricsTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('periodStart: $periodStart, ')
          ..write('periodEnd: $periodEnd, ')
          ..write('totalTrips: $totalTrips, ')
          ..write('totalDistanceKm: $totalDistanceKm, ')
          ..write('totalDrivingTimeMinutes: $totalDrivingTimeMinutes, ')
          ..write('averageSpeedKmh: $averageSpeedKmh, ')
          ..write('estimatedFuelSavingsPercent: $estimatedFuelSavingsPercent, ')
          ..write('estimatedCO2ReductionKg: $estimatedCO2ReductionKg, ')
          ..write('calmDrivingScore: $calmDrivingScore, ')
          ..write('speedOptimizationScore: $speedOptimizationScore, ')
          ..write('idlingScore: $idlingScore, ')
          ..write('shortDistanceScore: $shortDistanceScore, ')
          ..write('rpmManagementScore: $rpmManagementScore, ')
          ..write('stopManagementScore: $stopManagementScore, ')
          ..write('followDistanceScore: $followDistanceScore, ')
          ..write('overallScore: $overallScore, ')
          ..write('improvementTipsJson: $improvementTipsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    generatedAt,
    periodStart,
    periodEnd,
    totalTrips,
    totalDistanceKm,
    totalDrivingTimeMinutes,
    averageSpeedKmh,
    estimatedFuelSavingsPercent,
    estimatedCO2ReductionKg,
    calmDrivingScore,
    speedOptimizationScore,
    idlingScore,
    shortDistanceScore,
    rpmManagementScore,
    stopManagementScore,
    followDistanceScore,
    overallScore,
    improvementTipsJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PerformanceMetricsTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.generatedAt == this.generatedAt &&
          other.periodStart == this.periodStart &&
          other.periodEnd == this.periodEnd &&
          other.totalTrips == this.totalTrips &&
          other.totalDistanceKm == this.totalDistanceKm &&
          other.totalDrivingTimeMinutes == this.totalDrivingTimeMinutes &&
          other.averageSpeedKmh == this.averageSpeedKmh &&
          other.estimatedFuelSavingsPercent ==
              this.estimatedFuelSavingsPercent &&
          other.estimatedCO2ReductionKg == this.estimatedCO2ReductionKg &&
          other.calmDrivingScore == this.calmDrivingScore &&
          other.speedOptimizationScore == this.speedOptimizationScore &&
          other.idlingScore == this.idlingScore &&
          other.shortDistanceScore == this.shortDistanceScore &&
          other.rpmManagementScore == this.rpmManagementScore &&
          other.stopManagementScore == this.stopManagementScore &&
          other.followDistanceScore == this.followDistanceScore &&
          other.overallScore == this.overallScore &&
          other.improvementTipsJson == this.improvementTipsJson);
}

class PerformanceMetricsTableCompanion
    extends UpdateCompanion<PerformanceMetricsTableData> {
  final Value<int> id;
  final Value<String> userId;
  final Value<DateTime> generatedAt;
  final Value<DateTime> periodStart;
  final Value<DateTime> periodEnd;
  final Value<int> totalTrips;
  final Value<double> totalDistanceKm;
  final Value<double> totalDrivingTimeMinutes;
  final Value<double> averageSpeedKmh;
  final Value<double?> estimatedFuelSavingsPercent;
  final Value<double?> estimatedCO2ReductionKg;
  final Value<int?> calmDrivingScore;
  final Value<int?> speedOptimizationScore;
  final Value<int?> idlingScore;
  final Value<int?> shortDistanceScore;
  final Value<int?> rpmManagementScore;
  final Value<int?> stopManagementScore;
  final Value<int?> followDistanceScore;
  final Value<int> overallScore;
  final Value<String?> improvementTipsJson;
  const PerformanceMetricsTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.generatedAt = const Value.absent(),
    this.periodStart = const Value.absent(),
    this.periodEnd = const Value.absent(),
    this.totalTrips = const Value.absent(),
    this.totalDistanceKm = const Value.absent(),
    this.totalDrivingTimeMinutes = const Value.absent(),
    this.averageSpeedKmh = const Value.absent(),
    this.estimatedFuelSavingsPercent = const Value.absent(),
    this.estimatedCO2ReductionKg = const Value.absent(),
    this.calmDrivingScore = const Value.absent(),
    this.speedOptimizationScore = const Value.absent(),
    this.idlingScore = const Value.absent(),
    this.shortDistanceScore = const Value.absent(),
    this.rpmManagementScore = const Value.absent(),
    this.stopManagementScore = const Value.absent(),
    this.followDistanceScore = const Value.absent(),
    this.overallScore = const Value.absent(),
    this.improvementTipsJson = const Value.absent(),
  });
  PerformanceMetricsTableCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    required DateTime generatedAt,
    required DateTime periodStart,
    required DateTime periodEnd,
    required int totalTrips,
    required double totalDistanceKm,
    required double totalDrivingTimeMinutes,
    required double averageSpeedKmh,
    this.estimatedFuelSavingsPercent = const Value.absent(),
    this.estimatedCO2ReductionKg = const Value.absent(),
    this.calmDrivingScore = const Value.absent(),
    this.speedOptimizationScore = const Value.absent(),
    this.idlingScore = const Value.absent(),
    this.shortDistanceScore = const Value.absent(),
    this.rpmManagementScore = const Value.absent(),
    this.stopManagementScore = const Value.absent(),
    this.followDistanceScore = const Value.absent(),
    required int overallScore,
    this.improvementTipsJson = const Value.absent(),
  }) : userId = Value(userId),
       generatedAt = Value(generatedAt),
       periodStart = Value(periodStart),
       periodEnd = Value(periodEnd),
       totalTrips = Value(totalTrips),
       totalDistanceKm = Value(totalDistanceKm),
       totalDrivingTimeMinutes = Value(totalDrivingTimeMinutes),
       averageSpeedKmh = Value(averageSpeedKmh),
       overallScore = Value(overallScore);
  static Insertable<PerformanceMetricsTableData> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<DateTime>? generatedAt,
    Expression<DateTime>? periodStart,
    Expression<DateTime>? periodEnd,
    Expression<int>? totalTrips,
    Expression<double>? totalDistanceKm,
    Expression<double>? totalDrivingTimeMinutes,
    Expression<double>? averageSpeedKmh,
    Expression<double>? estimatedFuelSavingsPercent,
    Expression<double>? estimatedCO2ReductionKg,
    Expression<int>? calmDrivingScore,
    Expression<int>? speedOptimizationScore,
    Expression<int>? idlingScore,
    Expression<int>? shortDistanceScore,
    Expression<int>? rpmManagementScore,
    Expression<int>? stopManagementScore,
    Expression<int>? followDistanceScore,
    Expression<int>? overallScore,
    Expression<String>? improvementTipsJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (generatedAt != null) 'generated_at': generatedAt,
      if (periodStart != null) 'period_start': periodStart,
      if (periodEnd != null) 'period_end': periodEnd,
      if (totalTrips != null) 'total_trips': totalTrips,
      if (totalDistanceKm != null) 'total_distance_km': totalDistanceKm,
      if (totalDrivingTimeMinutes != null)
        'total_driving_time_minutes': totalDrivingTimeMinutes,
      if (averageSpeedKmh != null) 'average_speed_kmh': averageSpeedKmh,
      if (estimatedFuelSavingsPercent != null)
        'estimated_fuel_savings_percent': estimatedFuelSavingsPercent,
      if (estimatedCO2ReductionKg != null)
        'estimated_c_o2_reduction_kg': estimatedCO2ReductionKg,
      if (calmDrivingScore != null) 'calm_driving_score': calmDrivingScore,
      if (speedOptimizationScore != null)
        'speed_optimization_score': speedOptimizationScore,
      if (idlingScore != null) 'idling_score': idlingScore,
      if (shortDistanceScore != null)
        'short_distance_score': shortDistanceScore,
      if (rpmManagementScore != null)
        'rpm_management_score': rpmManagementScore,
      if (stopManagementScore != null)
        'stop_management_score': stopManagementScore,
      if (followDistanceScore != null)
        'follow_distance_score': followDistanceScore,
      if (overallScore != null) 'overall_score': overallScore,
      if (improvementTipsJson != null)
        'improvement_tips_json': improvementTipsJson,
    });
  }

  PerformanceMetricsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? userId,
    Value<DateTime>? generatedAt,
    Value<DateTime>? periodStart,
    Value<DateTime>? periodEnd,
    Value<int>? totalTrips,
    Value<double>? totalDistanceKm,
    Value<double>? totalDrivingTimeMinutes,
    Value<double>? averageSpeedKmh,
    Value<double?>? estimatedFuelSavingsPercent,
    Value<double?>? estimatedCO2ReductionKg,
    Value<int?>? calmDrivingScore,
    Value<int?>? speedOptimizationScore,
    Value<int?>? idlingScore,
    Value<int?>? shortDistanceScore,
    Value<int?>? rpmManagementScore,
    Value<int?>? stopManagementScore,
    Value<int?>? followDistanceScore,
    Value<int>? overallScore,
    Value<String?>? improvementTipsJson,
  }) {
    return PerformanceMetricsTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      generatedAt: generatedAt ?? this.generatedAt,
      periodStart: periodStart ?? this.periodStart,
      periodEnd: periodEnd ?? this.periodEnd,
      totalTrips: totalTrips ?? this.totalTrips,
      totalDistanceKm: totalDistanceKm ?? this.totalDistanceKm,
      totalDrivingTimeMinutes:
          totalDrivingTimeMinutes ?? this.totalDrivingTimeMinutes,
      averageSpeedKmh: averageSpeedKmh ?? this.averageSpeedKmh,
      estimatedFuelSavingsPercent:
          estimatedFuelSavingsPercent ?? this.estimatedFuelSavingsPercent,
      estimatedCO2ReductionKg:
          estimatedCO2ReductionKg ?? this.estimatedCO2ReductionKg,
      calmDrivingScore: calmDrivingScore ?? this.calmDrivingScore,
      speedOptimizationScore:
          speedOptimizationScore ?? this.speedOptimizationScore,
      idlingScore: idlingScore ?? this.idlingScore,
      shortDistanceScore: shortDistanceScore ?? this.shortDistanceScore,
      rpmManagementScore: rpmManagementScore ?? this.rpmManagementScore,
      stopManagementScore: stopManagementScore ?? this.stopManagementScore,
      followDistanceScore: followDistanceScore ?? this.followDistanceScore,
      overallScore: overallScore ?? this.overallScore,
      improvementTipsJson: improvementTipsJson ?? this.improvementTipsJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (generatedAt.present) {
      map['generated_at'] = Variable<DateTime>(generatedAt.value);
    }
    if (periodStart.present) {
      map['period_start'] = Variable<DateTime>(periodStart.value);
    }
    if (periodEnd.present) {
      map['period_end'] = Variable<DateTime>(periodEnd.value);
    }
    if (totalTrips.present) {
      map['total_trips'] = Variable<int>(totalTrips.value);
    }
    if (totalDistanceKm.present) {
      map['total_distance_km'] = Variable<double>(totalDistanceKm.value);
    }
    if (totalDrivingTimeMinutes.present) {
      map['total_driving_time_minutes'] = Variable<double>(
        totalDrivingTimeMinutes.value,
      );
    }
    if (averageSpeedKmh.present) {
      map['average_speed_kmh'] = Variable<double>(averageSpeedKmh.value);
    }
    if (estimatedFuelSavingsPercent.present) {
      map['estimated_fuel_savings_percent'] = Variable<double>(
        estimatedFuelSavingsPercent.value,
      );
    }
    if (estimatedCO2ReductionKg.present) {
      map['estimated_c_o2_reduction_kg'] = Variable<double>(
        estimatedCO2ReductionKg.value,
      );
    }
    if (calmDrivingScore.present) {
      map['calm_driving_score'] = Variable<int>(calmDrivingScore.value);
    }
    if (speedOptimizationScore.present) {
      map['speed_optimization_score'] = Variable<int>(
        speedOptimizationScore.value,
      );
    }
    if (idlingScore.present) {
      map['idling_score'] = Variable<int>(idlingScore.value);
    }
    if (shortDistanceScore.present) {
      map['short_distance_score'] = Variable<int>(shortDistanceScore.value);
    }
    if (rpmManagementScore.present) {
      map['rpm_management_score'] = Variable<int>(rpmManagementScore.value);
    }
    if (stopManagementScore.present) {
      map['stop_management_score'] = Variable<int>(stopManagementScore.value);
    }
    if (followDistanceScore.present) {
      map['follow_distance_score'] = Variable<int>(followDistanceScore.value);
    }
    if (overallScore.present) {
      map['overall_score'] = Variable<int>(overallScore.value);
    }
    if (improvementTipsJson.present) {
      map['improvement_tips_json'] = Variable<String>(
        improvementTipsJson.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PerformanceMetricsTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('periodStart: $periodStart, ')
          ..write('periodEnd: $periodEnd, ')
          ..write('totalTrips: $totalTrips, ')
          ..write('totalDistanceKm: $totalDistanceKm, ')
          ..write('totalDrivingTimeMinutes: $totalDrivingTimeMinutes, ')
          ..write('averageSpeedKmh: $averageSpeedKmh, ')
          ..write('estimatedFuelSavingsPercent: $estimatedFuelSavingsPercent, ')
          ..write('estimatedCO2ReductionKg: $estimatedCO2ReductionKg, ')
          ..write('calmDrivingScore: $calmDrivingScore, ')
          ..write('speedOptimizationScore: $speedOptimizationScore, ')
          ..write('idlingScore: $idlingScore, ')
          ..write('shortDistanceScore: $shortDistanceScore, ')
          ..write('rpmManagementScore: $rpmManagementScore, ')
          ..write('stopManagementScore: $stopManagementScore, ')
          ..write('followDistanceScore: $followDistanceScore, ')
          ..write('overallScore: $overallScore, ')
          ..write('improvementTipsJson: $improvementTipsJson')
          ..write(')'))
        .toString();
  }
}

class $BadgesTableTable extends BadgesTable
    with TableInfo<$BadgesTableTable, BadgesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BadgesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES user_profiles_table (id)',
    ),
  );
  static const VerificationMeta _badgeTypeMeta = const VerificationMeta(
    'badgeType',
  );
  @override
  late final GeneratedColumn<String> badgeType = GeneratedColumn<String>(
    'badge_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _earnedDateMeta = const VerificationMeta(
    'earnedDate',
  );
  @override
  late final GeneratedColumn<DateTime> earnedDate = GeneratedColumn<DateTime>(
    'earned_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _metadataJsonMeta = const VerificationMeta(
    'metadataJson',
  );
  @override
  late final GeneratedColumn<String> metadataJson = GeneratedColumn<String>(
    'metadata_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    badgeType,
    earnedDate,
    level,
    metadataJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'badges_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<BadgesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('badge_type')) {
      context.handle(
        _badgeTypeMeta,
        badgeType.isAcceptableOrUnknown(data['badge_type']!, _badgeTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_badgeTypeMeta);
    }
    if (data.containsKey('earned_date')) {
      context.handle(
        _earnedDateMeta,
        earnedDate.isAcceptableOrUnknown(data['earned_date']!, _earnedDateMeta),
      );
    } else if (isInserting) {
      context.missing(_earnedDateMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    }
    if (data.containsKey('metadata_json')) {
      context.handle(
        _metadataJsonMeta,
        metadataJson.isAcceptableOrUnknown(
          data['metadata_json']!,
          _metadataJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BadgesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BadgesTableData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      userId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}user_id'],
          )!,
      badgeType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}badge_type'],
          )!,
      earnedDate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}earned_date'],
          )!,
      level:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}level'],
          )!,
      metadataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata_json'],
      ),
    );
  }

  @override
  $BadgesTableTable createAlias(String alias) {
    return $BadgesTableTable(attachedDatabase, alias);
  }
}

class BadgesTableData extends DataClass implements Insertable<BadgesTableData> {
  final int id;
  final String userId;
  final String badgeType;
  final DateTime earnedDate;
  final int level;
  final String? metadataJson;
  const BadgesTableData({
    required this.id,
    required this.userId,
    required this.badgeType,
    required this.earnedDate,
    required this.level,
    this.metadataJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<String>(userId);
    map['badge_type'] = Variable<String>(badgeType);
    map['earned_date'] = Variable<DateTime>(earnedDate);
    map['level'] = Variable<int>(level);
    if (!nullToAbsent || metadataJson != null) {
      map['metadata_json'] = Variable<String>(metadataJson);
    }
    return map;
  }

  BadgesTableCompanion toCompanion(bool nullToAbsent) {
    return BadgesTableCompanion(
      id: Value(id),
      userId: Value(userId),
      badgeType: Value(badgeType),
      earnedDate: Value(earnedDate),
      level: Value(level),
      metadataJson:
          metadataJson == null && nullToAbsent
              ? const Value.absent()
              : Value(metadataJson),
    );
  }

  factory BadgesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BadgesTableData(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      badgeType: serializer.fromJson<String>(json['badgeType']),
      earnedDate: serializer.fromJson<DateTime>(json['earnedDate']),
      level: serializer.fromJson<int>(json['level']),
      metadataJson: serializer.fromJson<String?>(json['metadataJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String>(userId),
      'badgeType': serializer.toJson<String>(badgeType),
      'earnedDate': serializer.toJson<DateTime>(earnedDate),
      'level': serializer.toJson<int>(level),
      'metadataJson': serializer.toJson<String?>(metadataJson),
    };
  }

  BadgesTableData copyWith({
    int? id,
    String? userId,
    String? badgeType,
    DateTime? earnedDate,
    int? level,
    Value<String?> metadataJson = const Value.absent(),
  }) => BadgesTableData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    badgeType: badgeType ?? this.badgeType,
    earnedDate: earnedDate ?? this.earnedDate,
    level: level ?? this.level,
    metadataJson: metadataJson.present ? metadataJson.value : this.metadataJson,
  );
  BadgesTableData copyWithCompanion(BadgesTableCompanion data) {
    return BadgesTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      badgeType: data.badgeType.present ? data.badgeType.value : this.badgeType,
      earnedDate:
          data.earnedDate.present ? data.earnedDate.value : this.earnedDate,
      level: data.level.present ? data.level.value : this.level,
      metadataJson:
          data.metadataJson.present
              ? data.metadataJson.value
              : this.metadataJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BadgesTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('badgeType: $badgeType, ')
          ..write('earnedDate: $earnedDate, ')
          ..write('level: $level, ')
          ..write('metadataJson: $metadataJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, badgeType, earnedDate, level, metadataJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BadgesTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.badgeType == this.badgeType &&
          other.earnedDate == this.earnedDate &&
          other.level == this.level &&
          other.metadataJson == this.metadataJson);
}

class BadgesTableCompanion extends UpdateCompanion<BadgesTableData> {
  final Value<int> id;
  final Value<String> userId;
  final Value<String> badgeType;
  final Value<DateTime> earnedDate;
  final Value<int> level;
  final Value<String?> metadataJson;
  const BadgesTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.badgeType = const Value.absent(),
    this.earnedDate = const Value.absent(),
    this.level = const Value.absent(),
    this.metadataJson = const Value.absent(),
  });
  BadgesTableCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    required String badgeType,
    required DateTime earnedDate,
    this.level = const Value.absent(),
    this.metadataJson = const Value.absent(),
  }) : userId = Value(userId),
       badgeType = Value(badgeType),
       earnedDate = Value(earnedDate);
  static Insertable<BadgesTableData> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<String>? badgeType,
    Expression<DateTime>? earnedDate,
    Expression<int>? level,
    Expression<String>? metadataJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (badgeType != null) 'badge_type': badgeType,
      if (earnedDate != null) 'earned_date': earnedDate,
      if (level != null) 'level': level,
      if (metadataJson != null) 'metadata_json': metadataJson,
    });
  }

  BadgesTableCompanion copyWith({
    Value<int>? id,
    Value<String>? userId,
    Value<String>? badgeType,
    Value<DateTime>? earnedDate,
    Value<int>? level,
    Value<String?>? metadataJson,
  }) {
    return BadgesTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      badgeType: badgeType ?? this.badgeType,
      earnedDate: earnedDate ?? this.earnedDate,
      level: level ?? this.level,
      metadataJson: metadataJson ?? this.metadataJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (badgeType.present) {
      map['badge_type'] = Variable<String>(badgeType.value);
    }
    if (earnedDate.present) {
      map['earned_date'] = Variable<DateTime>(earnedDate.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (metadataJson.present) {
      map['metadata_json'] = Variable<String>(metadataJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BadgesTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('badgeType: $badgeType, ')
          ..write('earnedDate: $earnedDate, ')
          ..write('level: $level, ')
          ..write('metadataJson: $metadataJson')
          ..write(')'))
        .toString();
  }
}

class $DataPrivacySettingsTableTable extends DataPrivacySettingsTable
    with
        TableInfo<
          $DataPrivacySettingsTableTable,
          DataPrivacySettingsTableData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DataPrivacySettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 36,
      maxTextLength: 36,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES user_profiles_table (id)',
    ),
  );
  static const VerificationMeta _dataTypeMeta = const VerificationMeta(
    'dataType',
  );
  @override
  late final GeneratedColumn<String> dataType = GeneratedColumn<String>(
    'data_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _allowLocalStorageMeta = const VerificationMeta(
    'allowLocalStorage',
  );
  @override
  late final GeneratedColumn<bool> allowLocalStorage = GeneratedColumn<bool>(
    'allow_local_storage',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("allow_local_storage" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _allowCloudSyncMeta = const VerificationMeta(
    'allowCloudSync',
  );
  @override
  late final GeneratedColumn<bool> allowCloudSync = GeneratedColumn<bool>(
    'allow_cloud_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("allow_cloud_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _allowSharingMeta = const VerificationMeta(
    'allowSharing',
  );
  @override
  late final GeneratedColumn<bool> allowSharing = GeneratedColumn<bool>(
    'allow_sharing',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("allow_sharing" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _allowAnonymizedAnalyticsMeta =
      const VerificationMeta('allowAnonymizedAnalytics');
  @override
  late final GeneratedColumn<bool> allowAnonymizedAnalytics =
      GeneratedColumn<bool>(
        'allow_anonymized_analytics',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("allow_anonymized_analytics" IN (0, 1))',
        ),
        defaultValue: const Constant(true),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    dataType,
    allowLocalStorage,
    allowCloudSync,
    allowSharing,
    allowAnonymizedAnalytics,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'data_privacy_settings_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<DataPrivacySettingsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('data_type')) {
      context.handle(
        _dataTypeMeta,
        dataType.isAcceptableOrUnknown(data['data_type']!, _dataTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_dataTypeMeta);
    }
    if (data.containsKey('allow_local_storage')) {
      context.handle(
        _allowLocalStorageMeta,
        allowLocalStorage.isAcceptableOrUnknown(
          data['allow_local_storage']!,
          _allowLocalStorageMeta,
        ),
      );
    }
    if (data.containsKey('allow_cloud_sync')) {
      context.handle(
        _allowCloudSyncMeta,
        allowCloudSync.isAcceptableOrUnknown(
          data['allow_cloud_sync']!,
          _allowCloudSyncMeta,
        ),
      );
    }
    if (data.containsKey('allow_sharing')) {
      context.handle(
        _allowSharingMeta,
        allowSharing.isAcceptableOrUnknown(
          data['allow_sharing']!,
          _allowSharingMeta,
        ),
      );
    }
    if (data.containsKey('allow_anonymized_analytics')) {
      context.handle(
        _allowAnonymizedAnalyticsMeta,
        allowAnonymizedAnalytics.isAcceptableOrUnknown(
          data['allow_anonymized_analytics']!,
          _allowAnonymizedAnalyticsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DataPrivacySettingsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DataPrivacySettingsTableData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      userId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}user_id'],
          )!,
      dataType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}data_type'],
          )!,
      allowLocalStorage:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}allow_local_storage'],
          )!,
      allowCloudSync:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}allow_cloud_sync'],
          )!,
      allowSharing:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}allow_sharing'],
          )!,
      allowAnonymizedAnalytics:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}allow_anonymized_analytics'],
          )!,
    );
  }

  @override
  $DataPrivacySettingsTableTable createAlias(String alias) {
    return $DataPrivacySettingsTableTable(attachedDatabase, alias);
  }
}

class DataPrivacySettingsTableData extends DataClass
    implements Insertable<DataPrivacySettingsTableData> {
  final String id;
  final String userId;
  final String dataType;
  final bool allowLocalStorage;
  final bool allowCloudSync;
  final bool allowSharing;
  final bool allowAnonymizedAnalytics;
  const DataPrivacySettingsTableData({
    required this.id,
    required this.userId,
    required this.dataType,
    required this.allowLocalStorage,
    required this.allowCloudSync,
    required this.allowSharing,
    required this.allowAnonymizedAnalytics,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['data_type'] = Variable<String>(dataType);
    map['allow_local_storage'] = Variable<bool>(allowLocalStorage);
    map['allow_cloud_sync'] = Variable<bool>(allowCloudSync);
    map['allow_sharing'] = Variable<bool>(allowSharing);
    map['allow_anonymized_analytics'] = Variable<bool>(
      allowAnonymizedAnalytics,
    );
    return map;
  }

  DataPrivacySettingsTableCompanion toCompanion(bool nullToAbsent) {
    return DataPrivacySettingsTableCompanion(
      id: Value(id),
      userId: Value(userId),
      dataType: Value(dataType),
      allowLocalStorage: Value(allowLocalStorage),
      allowCloudSync: Value(allowCloudSync),
      allowSharing: Value(allowSharing),
      allowAnonymizedAnalytics: Value(allowAnonymizedAnalytics),
    );
  }

  factory DataPrivacySettingsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DataPrivacySettingsTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      dataType: serializer.fromJson<String>(json['dataType']),
      allowLocalStorage: serializer.fromJson<bool>(json['allowLocalStorage']),
      allowCloudSync: serializer.fromJson<bool>(json['allowCloudSync']),
      allowSharing: serializer.fromJson<bool>(json['allowSharing']),
      allowAnonymizedAnalytics: serializer.fromJson<bool>(
        json['allowAnonymizedAnalytics'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'dataType': serializer.toJson<String>(dataType),
      'allowLocalStorage': serializer.toJson<bool>(allowLocalStorage),
      'allowCloudSync': serializer.toJson<bool>(allowCloudSync),
      'allowSharing': serializer.toJson<bool>(allowSharing),
      'allowAnonymizedAnalytics': serializer.toJson<bool>(
        allowAnonymizedAnalytics,
      ),
    };
  }

  DataPrivacySettingsTableData copyWith({
    String? id,
    String? userId,
    String? dataType,
    bool? allowLocalStorage,
    bool? allowCloudSync,
    bool? allowSharing,
    bool? allowAnonymizedAnalytics,
  }) => DataPrivacySettingsTableData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    dataType: dataType ?? this.dataType,
    allowLocalStorage: allowLocalStorage ?? this.allowLocalStorage,
    allowCloudSync: allowCloudSync ?? this.allowCloudSync,
    allowSharing: allowSharing ?? this.allowSharing,
    allowAnonymizedAnalytics:
        allowAnonymizedAnalytics ?? this.allowAnonymizedAnalytics,
  );
  DataPrivacySettingsTableData copyWithCompanion(
    DataPrivacySettingsTableCompanion data,
  ) {
    return DataPrivacySettingsTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      dataType: data.dataType.present ? data.dataType.value : this.dataType,
      allowLocalStorage:
          data.allowLocalStorage.present
              ? data.allowLocalStorage.value
              : this.allowLocalStorage,
      allowCloudSync:
          data.allowCloudSync.present
              ? data.allowCloudSync.value
              : this.allowCloudSync,
      allowSharing:
          data.allowSharing.present
              ? data.allowSharing.value
              : this.allowSharing,
      allowAnonymizedAnalytics:
          data.allowAnonymizedAnalytics.present
              ? data.allowAnonymizedAnalytics.value
              : this.allowAnonymizedAnalytics,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DataPrivacySettingsTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('dataType: $dataType, ')
          ..write('allowLocalStorage: $allowLocalStorage, ')
          ..write('allowCloudSync: $allowCloudSync, ')
          ..write('allowSharing: $allowSharing, ')
          ..write('allowAnonymizedAnalytics: $allowAnonymizedAnalytics')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    dataType,
    allowLocalStorage,
    allowCloudSync,
    allowSharing,
    allowAnonymizedAnalytics,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DataPrivacySettingsTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.dataType == this.dataType &&
          other.allowLocalStorage == this.allowLocalStorage &&
          other.allowCloudSync == this.allowCloudSync &&
          other.allowSharing == this.allowSharing &&
          other.allowAnonymizedAnalytics == this.allowAnonymizedAnalytics);
}

class DataPrivacySettingsTableCompanion
    extends UpdateCompanion<DataPrivacySettingsTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> dataType;
  final Value<bool> allowLocalStorage;
  final Value<bool> allowCloudSync;
  final Value<bool> allowSharing;
  final Value<bool> allowAnonymizedAnalytics;
  final Value<int> rowid;
  const DataPrivacySettingsTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.dataType = const Value.absent(),
    this.allowLocalStorage = const Value.absent(),
    this.allowCloudSync = const Value.absent(),
    this.allowSharing = const Value.absent(),
    this.allowAnonymizedAnalytics = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DataPrivacySettingsTableCompanion.insert({
    required String id,
    required String userId,
    required String dataType,
    this.allowLocalStorage = const Value.absent(),
    this.allowCloudSync = const Value.absent(),
    this.allowSharing = const Value.absent(),
    this.allowAnonymizedAnalytics = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       dataType = Value(dataType);
  static Insertable<DataPrivacySettingsTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? dataType,
    Expression<bool>? allowLocalStorage,
    Expression<bool>? allowCloudSync,
    Expression<bool>? allowSharing,
    Expression<bool>? allowAnonymizedAnalytics,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (dataType != null) 'data_type': dataType,
      if (allowLocalStorage != null) 'allow_local_storage': allowLocalStorage,
      if (allowCloudSync != null) 'allow_cloud_sync': allowCloudSync,
      if (allowSharing != null) 'allow_sharing': allowSharing,
      if (allowAnonymizedAnalytics != null)
        'allow_anonymized_analytics': allowAnonymizedAnalytics,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DataPrivacySettingsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? dataType,
    Value<bool>? allowLocalStorage,
    Value<bool>? allowCloudSync,
    Value<bool>? allowSharing,
    Value<bool>? allowAnonymizedAnalytics,
    Value<int>? rowid,
  }) {
    return DataPrivacySettingsTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      dataType: dataType ?? this.dataType,
      allowLocalStorage: allowLocalStorage ?? this.allowLocalStorage,
      allowCloudSync: allowCloudSync ?? this.allowCloudSync,
      allowSharing: allowSharing ?? this.allowSharing,
      allowAnonymizedAnalytics:
          allowAnonymizedAnalytics ?? this.allowAnonymizedAnalytics,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (dataType.present) {
      map['data_type'] = Variable<String>(dataType.value);
    }
    if (allowLocalStorage.present) {
      map['allow_local_storage'] = Variable<bool>(allowLocalStorage.value);
    }
    if (allowCloudSync.present) {
      map['allow_cloud_sync'] = Variable<bool>(allowCloudSync.value);
    }
    if (allowSharing.present) {
      map['allow_sharing'] = Variable<bool>(allowSharing.value);
    }
    if (allowAnonymizedAnalytics.present) {
      map['allow_anonymized_analytics'] = Variable<bool>(
        allowAnonymizedAnalytics.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DataPrivacySettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('dataType: $dataType, ')
          ..write('allowLocalStorage: $allowLocalStorage, ')
          ..write('allowCloudSync: $allowCloudSync, ')
          ..write('allowSharing: $allowSharing, ')
          ..write('allowAnonymizedAnalytics: $allowAnonymizedAnalytics, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SocialConnectionsTableTable extends SocialConnectionsTable
    with TableInfo<$SocialConnectionsTableTable, SocialConnectionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SocialConnectionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 36,
      maxTextLength: 36,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES user_profiles_table (id)',
    ),
  );
  static const VerificationMeta _connectedUserIdMeta = const VerificationMeta(
    'connectedUserId',
  );
  @override
  late final GeneratedColumn<String> connectedUserId = GeneratedColumn<String>(
    'connected_user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES user_profiles_table (id)',
    ),
  );
  static const VerificationMeta _connectionTypeMeta = const VerificationMeta(
    'connectionType',
  );
  @override
  late final GeneratedColumn<String> connectionType = GeneratedColumn<String>(
    'connection_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _connectedSinceMeta = const VerificationMeta(
    'connectedSince',
  );
  @override
  late final GeneratedColumn<DateTime> connectedSince =
      GeneratedColumn<DateTime>(
        'connected_since',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _isMutualMeta = const VerificationMeta(
    'isMutual',
  );
  @override
  late final GeneratedColumn<bool> isMutual = GeneratedColumn<bool>(
    'is_mutual',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_mutual" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    connectedUserId,
    connectionType,
    connectedSince,
    isMutual,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'social_connections_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SocialConnectionsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('connected_user_id')) {
      context.handle(
        _connectedUserIdMeta,
        connectedUserId.isAcceptableOrUnknown(
          data['connected_user_id']!,
          _connectedUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_connectedUserIdMeta);
    }
    if (data.containsKey('connection_type')) {
      context.handle(
        _connectionTypeMeta,
        connectionType.isAcceptableOrUnknown(
          data['connection_type']!,
          _connectionTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_connectionTypeMeta);
    }
    if (data.containsKey('connected_since')) {
      context.handle(
        _connectedSinceMeta,
        connectedSince.isAcceptableOrUnknown(
          data['connected_since']!,
          _connectedSinceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_connectedSinceMeta);
    }
    if (data.containsKey('is_mutual')) {
      context.handle(
        _isMutualMeta,
        isMutual.isAcceptableOrUnknown(data['is_mutual']!, _isMutualMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SocialConnectionsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SocialConnectionsTableData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      userId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}user_id'],
          )!,
      connectedUserId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}connected_user_id'],
          )!,
      connectionType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}connection_type'],
          )!,
      connectedSince:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}connected_since'],
          )!,
      isMutual:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_mutual'],
          )!,
    );
  }

  @override
  $SocialConnectionsTableTable createAlias(String alias) {
    return $SocialConnectionsTableTable(attachedDatabase, alias);
  }
}

class SocialConnectionsTableData extends DataClass
    implements Insertable<SocialConnectionsTableData> {
  final String id;
  final String userId;
  final String connectedUserId;
  final String connectionType;
  final DateTime connectedSince;
  final bool isMutual;
  const SocialConnectionsTableData({
    required this.id,
    required this.userId,
    required this.connectedUserId,
    required this.connectionType,
    required this.connectedSince,
    required this.isMutual,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['connected_user_id'] = Variable<String>(connectedUserId);
    map['connection_type'] = Variable<String>(connectionType);
    map['connected_since'] = Variable<DateTime>(connectedSince);
    map['is_mutual'] = Variable<bool>(isMutual);
    return map;
  }

  SocialConnectionsTableCompanion toCompanion(bool nullToAbsent) {
    return SocialConnectionsTableCompanion(
      id: Value(id),
      userId: Value(userId),
      connectedUserId: Value(connectedUserId),
      connectionType: Value(connectionType),
      connectedSince: Value(connectedSince),
      isMutual: Value(isMutual),
    );
  }

  factory SocialConnectionsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SocialConnectionsTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      connectedUserId: serializer.fromJson<String>(json['connectedUserId']),
      connectionType: serializer.fromJson<String>(json['connectionType']),
      connectedSince: serializer.fromJson<DateTime>(json['connectedSince']),
      isMutual: serializer.fromJson<bool>(json['isMutual']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'connectedUserId': serializer.toJson<String>(connectedUserId),
      'connectionType': serializer.toJson<String>(connectionType),
      'connectedSince': serializer.toJson<DateTime>(connectedSince),
      'isMutual': serializer.toJson<bool>(isMutual),
    };
  }

  SocialConnectionsTableData copyWith({
    String? id,
    String? userId,
    String? connectedUserId,
    String? connectionType,
    DateTime? connectedSince,
    bool? isMutual,
  }) => SocialConnectionsTableData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    connectedUserId: connectedUserId ?? this.connectedUserId,
    connectionType: connectionType ?? this.connectionType,
    connectedSince: connectedSince ?? this.connectedSince,
    isMutual: isMutual ?? this.isMutual,
  );
  SocialConnectionsTableData copyWithCompanion(
    SocialConnectionsTableCompanion data,
  ) {
    return SocialConnectionsTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      connectedUserId:
          data.connectedUserId.present
              ? data.connectedUserId.value
              : this.connectedUserId,
      connectionType:
          data.connectionType.present
              ? data.connectionType.value
              : this.connectionType,
      connectedSince:
          data.connectedSince.present
              ? data.connectedSince.value
              : this.connectedSince,
      isMutual: data.isMutual.present ? data.isMutual.value : this.isMutual,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SocialConnectionsTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('connectedUserId: $connectedUserId, ')
          ..write('connectionType: $connectionType, ')
          ..write('connectedSince: $connectedSince, ')
          ..write('isMutual: $isMutual')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    connectedUserId,
    connectionType,
    connectedSince,
    isMutual,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SocialConnectionsTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.connectedUserId == this.connectedUserId &&
          other.connectionType == this.connectionType &&
          other.connectedSince == this.connectedSince &&
          other.isMutual == this.isMutual);
}

class SocialConnectionsTableCompanion
    extends UpdateCompanion<SocialConnectionsTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> connectedUserId;
  final Value<String> connectionType;
  final Value<DateTime> connectedSince;
  final Value<bool> isMutual;
  final Value<int> rowid;
  const SocialConnectionsTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.connectedUserId = const Value.absent(),
    this.connectionType = const Value.absent(),
    this.connectedSince = const Value.absent(),
    this.isMutual = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SocialConnectionsTableCompanion.insert({
    required String id,
    required String userId,
    required String connectedUserId,
    required String connectionType,
    required DateTime connectedSince,
    this.isMutual = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       connectedUserId = Value(connectedUserId),
       connectionType = Value(connectionType),
       connectedSince = Value(connectedSince);
  static Insertable<SocialConnectionsTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? connectedUserId,
    Expression<String>? connectionType,
    Expression<DateTime>? connectedSince,
    Expression<bool>? isMutual,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (connectedUserId != null) 'connected_user_id': connectedUserId,
      if (connectionType != null) 'connection_type': connectionType,
      if (connectedSince != null) 'connected_since': connectedSince,
      if (isMutual != null) 'is_mutual': isMutual,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SocialConnectionsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? connectedUserId,
    Value<String>? connectionType,
    Value<DateTime>? connectedSince,
    Value<bool>? isMutual,
    Value<int>? rowid,
  }) {
    return SocialConnectionsTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      connectedUserId: connectedUserId ?? this.connectedUserId,
      connectionType: connectionType ?? this.connectionType,
      connectedSince: connectedSince ?? this.connectedSince,
      isMutual: isMutual ?? this.isMutual,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (connectedUserId.present) {
      map['connected_user_id'] = Variable<String>(connectedUserId.value);
    }
    if (connectionType.present) {
      map['connection_type'] = Variable<String>(connectionType.value);
    }
    if (connectedSince.present) {
      map['connected_since'] = Variable<DateTime>(connectedSince.value);
    }
    if (isMutual.present) {
      map['is_mutual'] = Variable<bool>(isMutual.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SocialConnectionsTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('connectedUserId: $connectedUserId, ')
          ..write('connectionType: $connectionType, ')
          ..write('connectedSince: $connectedSince, ')
          ..write('isMutual: $isMutual, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SocialInteractionsTableTable extends SocialInteractionsTable
    with TableInfo<$SocialInteractionsTableTable, SocialInteractionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SocialInteractionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 36,
      maxTextLength: 36,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES user_profiles_table (id)',
    ),
  );
  static const VerificationMeta _contentTypeMeta = const VerificationMeta(
    'contentType',
  );
  @override
  late final GeneratedColumn<String> contentType = GeneratedColumn<String>(
    'content_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentIdMeta = const VerificationMeta(
    'contentId',
  );
  @override
  late final GeneratedColumn<String> contentId = GeneratedColumn<String>(
    'content_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _interactionTypeMeta = const VerificationMeta(
    'interactionType',
  );
  @override
  late final GeneratedColumn<String> interactionType = GeneratedColumn<String>(
    'interaction_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    contentType,
    contentId,
    interactionType,
    content,
    timestamp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'social_interactions_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SocialInteractionsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('content_type')) {
      context.handle(
        _contentTypeMeta,
        contentType.isAcceptableOrUnknown(
          data['content_type']!,
          _contentTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentTypeMeta);
    }
    if (data.containsKey('content_id')) {
      context.handle(
        _contentIdMeta,
        contentId.isAcceptableOrUnknown(data['content_id']!, _contentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_contentIdMeta);
    }
    if (data.containsKey('interaction_type')) {
      context.handle(
        _interactionTypeMeta,
        interactionType.isAcceptableOrUnknown(
          data['interaction_type']!,
          _interactionTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_interactionTypeMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SocialInteractionsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SocialInteractionsTableData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      userId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}user_id'],
          )!,
      contentType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}content_type'],
          )!,
      contentId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}content_id'],
          )!,
      interactionType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}interaction_type'],
          )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      ),
      timestamp:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}timestamp'],
          )!,
    );
  }

  @override
  $SocialInteractionsTableTable createAlias(String alias) {
    return $SocialInteractionsTableTable(attachedDatabase, alias);
  }
}

class SocialInteractionsTableData extends DataClass
    implements Insertable<SocialInteractionsTableData> {
  final String id;
  final String userId;
  final String contentType;
  final String contentId;
  final String interactionType;
  final String? content;
  final DateTime timestamp;
  const SocialInteractionsTableData({
    required this.id,
    required this.userId,
    required this.contentType,
    required this.contentId,
    required this.interactionType,
    this.content,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['content_type'] = Variable<String>(contentType);
    map['content_id'] = Variable<String>(contentId);
    map['interaction_type'] = Variable<String>(interactionType);
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(content);
    }
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  SocialInteractionsTableCompanion toCompanion(bool nullToAbsent) {
    return SocialInteractionsTableCompanion(
      id: Value(id),
      userId: Value(userId),
      contentType: Value(contentType),
      contentId: Value(contentId),
      interactionType: Value(interactionType),
      content:
          content == null && nullToAbsent
              ? const Value.absent()
              : Value(content),
      timestamp: Value(timestamp),
    );
  }

  factory SocialInteractionsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SocialInteractionsTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      contentType: serializer.fromJson<String>(json['contentType']),
      contentId: serializer.fromJson<String>(json['contentId']),
      interactionType: serializer.fromJson<String>(json['interactionType']),
      content: serializer.fromJson<String?>(json['content']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'contentType': serializer.toJson<String>(contentType),
      'contentId': serializer.toJson<String>(contentId),
      'interactionType': serializer.toJson<String>(interactionType),
      'content': serializer.toJson<String?>(content),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  SocialInteractionsTableData copyWith({
    String? id,
    String? userId,
    String? contentType,
    String? contentId,
    String? interactionType,
    Value<String?> content = const Value.absent(),
    DateTime? timestamp,
  }) => SocialInteractionsTableData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    contentType: contentType ?? this.contentType,
    contentId: contentId ?? this.contentId,
    interactionType: interactionType ?? this.interactionType,
    content: content.present ? content.value : this.content,
    timestamp: timestamp ?? this.timestamp,
  );
  SocialInteractionsTableData copyWithCompanion(
    SocialInteractionsTableCompanion data,
  ) {
    return SocialInteractionsTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      contentType:
          data.contentType.present ? data.contentType.value : this.contentType,
      contentId: data.contentId.present ? data.contentId.value : this.contentId,
      interactionType:
          data.interactionType.present
              ? data.interactionType.value
              : this.interactionType,
      content: data.content.present ? data.content.value : this.content,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SocialInteractionsTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('contentType: $contentType, ')
          ..write('contentId: $contentId, ')
          ..write('interactionType: $interactionType, ')
          ..write('content: $content, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    contentType,
    contentId,
    interactionType,
    content,
    timestamp,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SocialInteractionsTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.contentType == this.contentType &&
          other.contentId == this.contentId &&
          other.interactionType == this.interactionType &&
          other.content == this.content &&
          other.timestamp == this.timestamp);
}

class SocialInteractionsTableCompanion
    extends UpdateCompanion<SocialInteractionsTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> contentType;
  final Value<String> contentId;
  final Value<String> interactionType;
  final Value<String?> content;
  final Value<DateTime> timestamp;
  final Value<int> rowid;
  const SocialInteractionsTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.contentType = const Value.absent(),
    this.contentId = const Value.absent(),
    this.interactionType = const Value.absent(),
    this.content = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SocialInteractionsTableCompanion.insert({
    required String id,
    required String userId,
    required String contentType,
    required String contentId,
    required String interactionType,
    this.content = const Value.absent(),
    required DateTime timestamp,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       contentType = Value(contentType),
       contentId = Value(contentId),
       interactionType = Value(interactionType),
       timestamp = Value(timestamp);
  static Insertable<SocialInteractionsTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? contentType,
    Expression<String>? contentId,
    Expression<String>? interactionType,
    Expression<String>? content,
    Expression<DateTime>? timestamp,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (contentType != null) 'content_type': contentType,
      if (contentId != null) 'content_id': contentId,
      if (interactionType != null) 'interaction_type': interactionType,
      if (content != null) 'content': content,
      if (timestamp != null) 'timestamp': timestamp,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SocialInteractionsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? contentType,
    Value<String>? contentId,
    Value<String>? interactionType,
    Value<String?>? content,
    Value<DateTime>? timestamp,
    Value<int>? rowid,
  }) {
    return SocialInteractionsTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      contentType: contentType ?? this.contentType,
      contentId: contentId ?? this.contentId,
      interactionType: interactionType ?? this.interactionType,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (contentType.present) {
      map['content_type'] = Variable<String>(contentType.value);
    }
    if (contentId.present) {
      map['content_id'] = Variable<String>(contentId.value);
    }
    if (interactionType.present) {
      map['interaction_type'] = Variable<String>(interactionType.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SocialInteractionsTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('contentType: $contentType, ')
          ..write('contentId: $contentId, ')
          ..write('interactionType: $interactionType, ')
          ..write('content: $content, ')
          ..write('timestamp: $timestamp, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SharedContentTableTable extends SharedContentTable
    with TableInfo<$SharedContentTableTable, SharedContentTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SharedContentTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 36,
      maxTextLength: 36,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES user_profiles_table (id)',
    ),
  );
  static const VerificationMeta _contentTypeMeta = const VerificationMeta(
    'contentType',
  );
  @override
  late final GeneratedColumn<String> contentType = GeneratedColumn<String>(
    'content_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentIdMeta = const VerificationMeta(
    'contentId',
  );
  @override
  late final GeneratedColumn<String> contentId = GeneratedColumn<String>(
    'content_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shareTypeMeta = const VerificationMeta(
    'shareType',
  );
  @override
  late final GeneratedColumn<String> shareType = GeneratedColumn<String>(
    'share_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _externalPlatformMeta = const VerificationMeta(
    'externalPlatform',
  );
  @override
  late final GeneratedColumn<String> externalPlatform = GeneratedColumn<String>(
    'external_platform',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _shareUrlMeta = const VerificationMeta(
    'shareUrl',
  );
  @override
  late final GeneratedColumn<String> shareUrl = GeneratedColumn<String>(
    'share_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sharedAtMeta = const VerificationMeta(
    'sharedAt',
  );
  @override
  late final GeneratedColumn<DateTime> sharedAt = GeneratedColumn<DateTime>(
    'shared_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    contentType,
    contentId,
    shareType,
    externalPlatform,
    shareUrl,
    sharedAt,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shared_content_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SharedContentTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('content_type')) {
      context.handle(
        _contentTypeMeta,
        contentType.isAcceptableOrUnknown(
          data['content_type']!,
          _contentTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentTypeMeta);
    }
    if (data.containsKey('content_id')) {
      context.handle(
        _contentIdMeta,
        contentId.isAcceptableOrUnknown(data['content_id']!, _contentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_contentIdMeta);
    }
    if (data.containsKey('share_type')) {
      context.handle(
        _shareTypeMeta,
        shareType.isAcceptableOrUnknown(data['share_type']!, _shareTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_shareTypeMeta);
    }
    if (data.containsKey('external_platform')) {
      context.handle(
        _externalPlatformMeta,
        externalPlatform.isAcceptableOrUnknown(
          data['external_platform']!,
          _externalPlatformMeta,
        ),
      );
    }
    if (data.containsKey('share_url')) {
      context.handle(
        _shareUrlMeta,
        shareUrl.isAcceptableOrUnknown(data['share_url']!, _shareUrlMeta),
      );
    }
    if (data.containsKey('shared_at')) {
      context.handle(
        _sharedAtMeta,
        sharedAt.isAcceptableOrUnknown(data['shared_at']!, _sharedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_sharedAtMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SharedContentTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SharedContentTableData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      userId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}user_id'],
          )!,
      contentType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}content_type'],
          )!,
      contentId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}content_id'],
          )!,
      shareType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}share_type'],
          )!,
      externalPlatform: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_platform'],
      ),
      shareUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}share_url'],
      ),
      sharedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}shared_at'],
          )!,
      isActive:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_active'],
          )!,
    );
  }

  @override
  $SharedContentTableTable createAlias(String alias) {
    return $SharedContentTableTable(attachedDatabase, alias);
  }
}

class SharedContentTableData extends DataClass
    implements Insertable<SharedContentTableData> {
  final String id;
  final String userId;
  final String contentType;
  final String contentId;
  final String shareType;
  final String? externalPlatform;
  final String? shareUrl;
  final DateTime sharedAt;
  final bool isActive;
  const SharedContentTableData({
    required this.id,
    required this.userId,
    required this.contentType,
    required this.contentId,
    required this.shareType,
    this.externalPlatform,
    this.shareUrl,
    required this.sharedAt,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['content_type'] = Variable<String>(contentType);
    map['content_id'] = Variable<String>(contentId);
    map['share_type'] = Variable<String>(shareType);
    if (!nullToAbsent || externalPlatform != null) {
      map['external_platform'] = Variable<String>(externalPlatform);
    }
    if (!nullToAbsent || shareUrl != null) {
      map['share_url'] = Variable<String>(shareUrl);
    }
    map['shared_at'] = Variable<DateTime>(sharedAt);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  SharedContentTableCompanion toCompanion(bool nullToAbsent) {
    return SharedContentTableCompanion(
      id: Value(id),
      userId: Value(userId),
      contentType: Value(contentType),
      contentId: Value(contentId),
      shareType: Value(shareType),
      externalPlatform:
          externalPlatform == null && nullToAbsent
              ? const Value.absent()
              : Value(externalPlatform),
      shareUrl:
          shareUrl == null && nullToAbsent
              ? const Value.absent()
              : Value(shareUrl),
      sharedAt: Value(sharedAt),
      isActive: Value(isActive),
    );
  }

  factory SharedContentTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SharedContentTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      contentType: serializer.fromJson<String>(json['contentType']),
      contentId: serializer.fromJson<String>(json['contentId']),
      shareType: serializer.fromJson<String>(json['shareType']),
      externalPlatform: serializer.fromJson<String?>(json['externalPlatform']),
      shareUrl: serializer.fromJson<String?>(json['shareUrl']),
      sharedAt: serializer.fromJson<DateTime>(json['sharedAt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'contentType': serializer.toJson<String>(contentType),
      'contentId': serializer.toJson<String>(contentId),
      'shareType': serializer.toJson<String>(shareType),
      'externalPlatform': serializer.toJson<String?>(externalPlatform),
      'shareUrl': serializer.toJson<String?>(shareUrl),
      'sharedAt': serializer.toJson<DateTime>(sharedAt),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  SharedContentTableData copyWith({
    String? id,
    String? userId,
    String? contentType,
    String? contentId,
    String? shareType,
    Value<String?> externalPlatform = const Value.absent(),
    Value<String?> shareUrl = const Value.absent(),
    DateTime? sharedAt,
    bool? isActive,
  }) => SharedContentTableData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    contentType: contentType ?? this.contentType,
    contentId: contentId ?? this.contentId,
    shareType: shareType ?? this.shareType,
    externalPlatform:
        externalPlatform.present
            ? externalPlatform.value
            : this.externalPlatform,
    shareUrl: shareUrl.present ? shareUrl.value : this.shareUrl,
    sharedAt: sharedAt ?? this.sharedAt,
    isActive: isActive ?? this.isActive,
  );
  SharedContentTableData copyWithCompanion(SharedContentTableCompanion data) {
    return SharedContentTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      contentType:
          data.contentType.present ? data.contentType.value : this.contentType,
      contentId: data.contentId.present ? data.contentId.value : this.contentId,
      shareType: data.shareType.present ? data.shareType.value : this.shareType,
      externalPlatform:
          data.externalPlatform.present
              ? data.externalPlatform.value
              : this.externalPlatform,
      shareUrl: data.shareUrl.present ? data.shareUrl.value : this.shareUrl,
      sharedAt: data.sharedAt.present ? data.sharedAt.value : this.sharedAt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SharedContentTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('contentType: $contentType, ')
          ..write('contentId: $contentId, ')
          ..write('shareType: $shareType, ')
          ..write('externalPlatform: $externalPlatform, ')
          ..write('shareUrl: $shareUrl, ')
          ..write('sharedAt: $sharedAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    contentType,
    contentId,
    shareType,
    externalPlatform,
    shareUrl,
    sharedAt,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SharedContentTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.contentType == this.contentType &&
          other.contentId == this.contentId &&
          other.shareType == this.shareType &&
          other.externalPlatform == this.externalPlatform &&
          other.shareUrl == this.shareUrl &&
          other.sharedAt == this.sharedAt &&
          other.isActive == this.isActive);
}

class SharedContentTableCompanion
    extends UpdateCompanion<SharedContentTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> contentType;
  final Value<String> contentId;
  final Value<String> shareType;
  final Value<String?> externalPlatform;
  final Value<String?> shareUrl;
  final Value<DateTime> sharedAt;
  final Value<bool> isActive;
  final Value<int> rowid;
  const SharedContentTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.contentType = const Value.absent(),
    this.contentId = const Value.absent(),
    this.shareType = const Value.absent(),
    this.externalPlatform = const Value.absent(),
    this.shareUrl = const Value.absent(),
    this.sharedAt = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SharedContentTableCompanion.insert({
    required String id,
    required String userId,
    required String contentType,
    required String contentId,
    required String shareType,
    this.externalPlatform = const Value.absent(),
    this.shareUrl = const Value.absent(),
    required DateTime sharedAt,
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       contentType = Value(contentType),
       contentId = Value(contentId),
       shareType = Value(shareType),
       sharedAt = Value(sharedAt);
  static Insertable<SharedContentTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? contentType,
    Expression<String>? contentId,
    Expression<String>? shareType,
    Expression<String>? externalPlatform,
    Expression<String>? shareUrl,
    Expression<DateTime>? sharedAt,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (contentType != null) 'content_type': contentType,
      if (contentId != null) 'content_id': contentId,
      if (shareType != null) 'share_type': shareType,
      if (externalPlatform != null) 'external_platform': externalPlatform,
      if (shareUrl != null) 'share_url': shareUrl,
      if (sharedAt != null) 'shared_at': sharedAt,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SharedContentTableCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? contentType,
    Value<String>? contentId,
    Value<String>? shareType,
    Value<String?>? externalPlatform,
    Value<String?>? shareUrl,
    Value<DateTime>? sharedAt,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return SharedContentTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      contentType: contentType ?? this.contentType,
      contentId: contentId ?? this.contentId,
      shareType: shareType ?? this.shareType,
      externalPlatform: externalPlatform ?? this.externalPlatform,
      shareUrl: shareUrl ?? this.shareUrl,
      sharedAt: sharedAt ?? this.sharedAt,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (contentType.present) {
      map['content_type'] = Variable<String>(contentType.value);
    }
    if (contentId.present) {
      map['content_id'] = Variable<String>(contentId.value);
    }
    if (shareType.present) {
      map['share_type'] = Variable<String>(shareType.value);
    }
    if (externalPlatform.present) {
      map['external_platform'] = Variable<String>(externalPlatform.value);
    }
    if (shareUrl.present) {
      map['share_url'] = Variable<String>(shareUrl.value);
    }
    if (sharedAt.present) {
      map['shared_at'] = Variable<DateTime>(sharedAt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SharedContentTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('contentType: $contentType, ')
          ..write('contentId: $contentId, ')
          ..write('shareType: $shareType, ')
          ..write('externalPlatform: $externalPlatform, ')
          ..write('shareUrl: $shareUrl, ')
          ..write('sharedAt: $sharedAt, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserPreferencesTableTable extends UserPreferencesTable
    with TableInfo<$UserPreferencesTableTable, UserPreferencesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserPreferencesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 36,
      maxTextLength: 36,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES user_profiles_table (id)',
    ),
  );
  static const VerificationMeta _preferenceCategoryMeta =
      const VerificationMeta('preferenceCategory');
  @override
  late final GeneratedColumn<String> preferenceCategory =
      GeneratedColumn<String>(
        'preference_category',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _preferenceNameMeta = const VerificationMeta(
    'preferenceName',
  );
  @override
  late final GeneratedColumn<String> preferenceName = GeneratedColumn<String>(
    'preference_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _preferenceValueMeta = const VerificationMeta(
    'preferenceValue',
  );
  @override
  late final GeneratedColumn<String> preferenceValue = GeneratedColumn<String>(
    'preference_value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    preferenceCategory,
    preferenceName,
    preferenceValue,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_preferences_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserPreferencesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('preference_category')) {
      context.handle(
        _preferenceCategoryMeta,
        preferenceCategory.isAcceptableOrUnknown(
          data['preference_category']!,
          _preferenceCategoryMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_preferenceCategoryMeta);
    }
    if (data.containsKey('preference_name')) {
      context.handle(
        _preferenceNameMeta,
        preferenceName.isAcceptableOrUnknown(
          data['preference_name']!,
          _preferenceNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_preferenceNameMeta);
    }
    if (data.containsKey('preference_value')) {
      context.handle(
        _preferenceValueMeta,
        preferenceValue.isAcceptableOrUnknown(
          data['preference_value']!,
          _preferenceValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_preferenceValueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserPreferencesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserPreferencesTableData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      userId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}user_id'],
          )!,
      preferenceCategory:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}preference_category'],
          )!,
      preferenceName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}preference_name'],
          )!,
      preferenceValue:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}preference_value'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $UserPreferencesTableTable createAlias(String alias) {
    return $UserPreferencesTableTable(attachedDatabase, alias);
  }
}

class UserPreferencesTableData extends DataClass
    implements Insertable<UserPreferencesTableData> {
  final String id;
  final String userId;
  final String preferenceCategory;
  final String preferenceName;
  final String preferenceValue;
  final DateTime updatedAt;
  const UserPreferencesTableData({
    required this.id,
    required this.userId,
    required this.preferenceCategory,
    required this.preferenceName,
    required this.preferenceValue,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['preference_category'] = Variable<String>(preferenceCategory);
    map['preference_name'] = Variable<String>(preferenceName);
    map['preference_value'] = Variable<String>(preferenceValue);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserPreferencesTableCompanion toCompanion(bool nullToAbsent) {
    return UserPreferencesTableCompanion(
      id: Value(id),
      userId: Value(userId),
      preferenceCategory: Value(preferenceCategory),
      preferenceName: Value(preferenceName),
      preferenceValue: Value(preferenceValue),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserPreferencesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserPreferencesTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      preferenceCategory: serializer.fromJson<String>(
        json['preferenceCategory'],
      ),
      preferenceName: serializer.fromJson<String>(json['preferenceName']),
      preferenceValue: serializer.fromJson<String>(json['preferenceValue']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'preferenceCategory': serializer.toJson<String>(preferenceCategory),
      'preferenceName': serializer.toJson<String>(preferenceName),
      'preferenceValue': serializer.toJson<String>(preferenceValue),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserPreferencesTableData copyWith({
    String? id,
    String? userId,
    String? preferenceCategory,
    String? preferenceName,
    String? preferenceValue,
    DateTime? updatedAt,
  }) => UserPreferencesTableData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    preferenceCategory: preferenceCategory ?? this.preferenceCategory,
    preferenceName: preferenceName ?? this.preferenceName,
    preferenceValue: preferenceValue ?? this.preferenceValue,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UserPreferencesTableData copyWithCompanion(
    UserPreferencesTableCompanion data,
  ) {
    return UserPreferencesTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      preferenceCategory:
          data.preferenceCategory.present
              ? data.preferenceCategory.value
              : this.preferenceCategory,
      preferenceName:
          data.preferenceName.present
              ? data.preferenceName.value
              : this.preferenceName,
      preferenceValue:
          data.preferenceValue.present
              ? data.preferenceValue.value
              : this.preferenceValue,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserPreferencesTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('preferenceCategory: $preferenceCategory, ')
          ..write('preferenceName: $preferenceName, ')
          ..write('preferenceValue: $preferenceValue, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    preferenceCategory,
    preferenceName,
    preferenceValue,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserPreferencesTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.preferenceCategory == this.preferenceCategory &&
          other.preferenceName == this.preferenceName &&
          other.preferenceValue == this.preferenceValue &&
          other.updatedAt == this.updatedAt);
}

class UserPreferencesTableCompanion
    extends UpdateCompanion<UserPreferencesTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> preferenceCategory;
  final Value<String> preferenceName;
  final Value<String> preferenceValue;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UserPreferencesTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.preferenceCategory = const Value.absent(),
    this.preferenceName = const Value.absent(),
    this.preferenceValue = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserPreferencesTableCompanion.insert({
    required String id,
    required String userId,
    required String preferenceCategory,
    required String preferenceName,
    required String preferenceValue,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       preferenceCategory = Value(preferenceCategory),
       preferenceName = Value(preferenceName),
       preferenceValue = Value(preferenceValue),
       updatedAt = Value(updatedAt);
  static Insertable<UserPreferencesTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? preferenceCategory,
    Expression<String>? preferenceName,
    Expression<String>? preferenceValue,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (preferenceCategory != null) 'preference_category': preferenceCategory,
      if (preferenceName != null) 'preference_name': preferenceName,
      if (preferenceValue != null) 'preference_value': preferenceValue,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserPreferencesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? preferenceCategory,
    Value<String>? preferenceName,
    Value<String>? preferenceValue,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return UserPreferencesTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      preferenceCategory: preferenceCategory ?? this.preferenceCategory,
      preferenceName: preferenceName ?? this.preferenceName,
      preferenceValue: preferenceValue ?? this.preferenceValue,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (preferenceCategory.present) {
      map['preference_category'] = Variable<String>(preferenceCategory.value);
    }
    if (preferenceName.present) {
      map['preference_name'] = Variable<String>(preferenceName.value);
    }
    if (preferenceValue.present) {
      map['preference_value'] = Variable<String>(preferenceValue.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserPreferencesTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('preferenceCategory: $preferenceCategory, ')
          ..write('preferenceName: $preferenceName, ')
          ..write('preferenceValue: $preferenceValue, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FeedbackEffectivenessTableTable extends FeedbackEffectivenessTable
    with
        TableInfo<
          $FeedbackEffectivenessTableTable,
          FeedbackEffectivenessTableData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FeedbackEffectivenessTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 36,
      maxTextLength: 36,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES user_profiles_table (id)',
    ),
  );
  static const VerificationMeta _feedbackTypeMeta = const VerificationMeta(
    'feedbackType',
  );
  @override
  late final GeneratedColumn<String> feedbackType = GeneratedColumn<String>(
    'feedback_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _drivingBehaviorTypeMeta =
      const VerificationMeta('drivingBehaviorType');
  @override
  late final GeneratedColumn<String> drivingBehaviorType =
      GeneratedColumn<String>(
        'driving_behavior_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _timesDeliveredMeta = const VerificationMeta(
    'timesDelivered',
  );
  @override
  late final GeneratedColumn<int> timesDelivered = GeneratedColumn<int>(
    'times_delivered',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _timesBehaviorImprovedMeta =
      const VerificationMeta('timesBehaviorImproved');
  @override
  late final GeneratedColumn<int> timesBehaviorImproved = GeneratedColumn<int>(
    'times_behavior_improved',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _effectivenessRatioMeta =
      const VerificationMeta('effectivenessRatio');
  @override
  late final GeneratedColumn<double> effectivenessRatio =
      GeneratedColumn<double>(
        'effectiveness_ratio',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _lastUpdatedMeta = const VerificationMeta(
    'lastUpdated',
  );
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
    'last_updated',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    feedbackType,
    drivingBehaviorType,
    timesDelivered,
    timesBehaviorImproved,
    effectivenessRatio,
    lastUpdated,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'feedback_effectiveness_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<FeedbackEffectivenessTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('feedback_type')) {
      context.handle(
        _feedbackTypeMeta,
        feedbackType.isAcceptableOrUnknown(
          data['feedback_type']!,
          _feedbackTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_feedbackTypeMeta);
    }
    if (data.containsKey('driving_behavior_type')) {
      context.handle(
        _drivingBehaviorTypeMeta,
        drivingBehaviorType.isAcceptableOrUnknown(
          data['driving_behavior_type']!,
          _drivingBehaviorTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_drivingBehaviorTypeMeta);
    }
    if (data.containsKey('times_delivered')) {
      context.handle(
        _timesDeliveredMeta,
        timesDelivered.isAcceptableOrUnknown(
          data['times_delivered']!,
          _timesDeliveredMeta,
        ),
      );
    }
    if (data.containsKey('times_behavior_improved')) {
      context.handle(
        _timesBehaviorImprovedMeta,
        timesBehaviorImproved.isAcceptableOrUnknown(
          data['times_behavior_improved']!,
          _timesBehaviorImprovedMeta,
        ),
      );
    }
    if (data.containsKey('effectiveness_ratio')) {
      context.handle(
        _effectivenessRatioMeta,
        effectivenessRatio.isAcceptableOrUnknown(
          data['effectiveness_ratio']!,
          _effectivenessRatioMeta,
        ),
      );
    }
    if (data.containsKey('last_updated')) {
      context.handle(
        _lastUpdatedMeta,
        lastUpdated.isAcceptableOrUnknown(
          data['last_updated']!,
          _lastUpdatedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FeedbackEffectivenessTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FeedbackEffectivenessTableData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      userId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}user_id'],
          )!,
      feedbackType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}feedback_type'],
          )!,
      drivingBehaviorType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}driving_behavior_type'],
          )!,
      timesDelivered:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}times_delivered'],
          )!,
      timesBehaviorImproved:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}times_behavior_improved'],
          )!,
      effectivenessRatio:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}effectiveness_ratio'],
          )!,
      lastUpdated:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}last_updated'],
          )!,
    );
  }

  @override
  $FeedbackEffectivenessTableTable createAlias(String alias) {
    return $FeedbackEffectivenessTableTable(attachedDatabase, alias);
  }
}

class FeedbackEffectivenessTableData extends DataClass
    implements Insertable<FeedbackEffectivenessTableData> {
  final String id;
  final String userId;
  final String feedbackType;
  final String drivingBehaviorType;
  final int timesDelivered;
  final int timesBehaviorImproved;
  final double effectivenessRatio;
  final DateTime lastUpdated;
  const FeedbackEffectivenessTableData({
    required this.id,
    required this.userId,
    required this.feedbackType,
    required this.drivingBehaviorType,
    required this.timesDelivered,
    required this.timesBehaviorImproved,
    required this.effectivenessRatio,
    required this.lastUpdated,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['feedback_type'] = Variable<String>(feedbackType);
    map['driving_behavior_type'] = Variable<String>(drivingBehaviorType);
    map['times_delivered'] = Variable<int>(timesDelivered);
    map['times_behavior_improved'] = Variable<int>(timesBehaviorImproved);
    map['effectiveness_ratio'] = Variable<double>(effectivenessRatio);
    map['last_updated'] = Variable<DateTime>(lastUpdated);
    return map;
  }

  FeedbackEffectivenessTableCompanion toCompanion(bool nullToAbsent) {
    return FeedbackEffectivenessTableCompanion(
      id: Value(id),
      userId: Value(userId),
      feedbackType: Value(feedbackType),
      drivingBehaviorType: Value(drivingBehaviorType),
      timesDelivered: Value(timesDelivered),
      timesBehaviorImproved: Value(timesBehaviorImproved),
      effectivenessRatio: Value(effectivenessRatio),
      lastUpdated: Value(lastUpdated),
    );
  }

  factory FeedbackEffectivenessTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FeedbackEffectivenessTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      feedbackType: serializer.fromJson<String>(json['feedbackType']),
      drivingBehaviorType: serializer.fromJson<String>(
        json['drivingBehaviorType'],
      ),
      timesDelivered: serializer.fromJson<int>(json['timesDelivered']),
      timesBehaviorImproved: serializer.fromJson<int>(
        json['timesBehaviorImproved'],
      ),
      effectivenessRatio: serializer.fromJson<double>(
        json['effectivenessRatio'],
      ),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'feedbackType': serializer.toJson<String>(feedbackType),
      'drivingBehaviorType': serializer.toJson<String>(drivingBehaviorType),
      'timesDelivered': serializer.toJson<int>(timesDelivered),
      'timesBehaviorImproved': serializer.toJson<int>(timesBehaviorImproved),
      'effectivenessRatio': serializer.toJson<double>(effectivenessRatio),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
    };
  }

  FeedbackEffectivenessTableData copyWith({
    String? id,
    String? userId,
    String? feedbackType,
    String? drivingBehaviorType,
    int? timesDelivered,
    int? timesBehaviorImproved,
    double? effectivenessRatio,
    DateTime? lastUpdated,
  }) => FeedbackEffectivenessTableData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    feedbackType: feedbackType ?? this.feedbackType,
    drivingBehaviorType: drivingBehaviorType ?? this.drivingBehaviorType,
    timesDelivered: timesDelivered ?? this.timesDelivered,
    timesBehaviorImproved: timesBehaviorImproved ?? this.timesBehaviorImproved,
    effectivenessRatio: effectivenessRatio ?? this.effectivenessRatio,
    lastUpdated: lastUpdated ?? this.lastUpdated,
  );
  FeedbackEffectivenessTableData copyWithCompanion(
    FeedbackEffectivenessTableCompanion data,
  ) {
    return FeedbackEffectivenessTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      feedbackType:
          data.feedbackType.present
              ? data.feedbackType.value
              : this.feedbackType,
      drivingBehaviorType:
          data.drivingBehaviorType.present
              ? data.drivingBehaviorType.value
              : this.drivingBehaviorType,
      timesDelivered:
          data.timesDelivered.present
              ? data.timesDelivered.value
              : this.timesDelivered,
      timesBehaviorImproved:
          data.timesBehaviorImproved.present
              ? data.timesBehaviorImproved.value
              : this.timesBehaviorImproved,
      effectivenessRatio:
          data.effectivenessRatio.present
              ? data.effectivenessRatio.value
              : this.effectivenessRatio,
      lastUpdated:
          data.lastUpdated.present ? data.lastUpdated.value : this.lastUpdated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FeedbackEffectivenessTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('feedbackType: $feedbackType, ')
          ..write('drivingBehaviorType: $drivingBehaviorType, ')
          ..write('timesDelivered: $timesDelivered, ')
          ..write('timesBehaviorImproved: $timesBehaviorImproved, ')
          ..write('effectivenessRatio: $effectivenessRatio, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    feedbackType,
    drivingBehaviorType,
    timesDelivered,
    timesBehaviorImproved,
    effectivenessRatio,
    lastUpdated,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FeedbackEffectivenessTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.feedbackType == this.feedbackType &&
          other.drivingBehaviorType == this.drivingBehaviorType &&
          other.timesDelivered == this.timesDelivered &&
          other.timesBehaviorImproved == this.timesBehaviorImproved &&
          other.effectivenessRatio == this.effectivenessRatio &&
          other.lastUpdated == this.lastUpdated);
}

class FeedbackEffectivenessTableCompanion
    extends UpdateCompanion<FeedbackEffectivenessTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> feedbackType;
  final Value<String> drivingBehaviorType;
  final Value<int> timesDelivered;
  final Value<int> timesBehaviorImproved;
  final Value<double> effectivenessRatio;
  final Value<DateTime> lastUpdated;
  final Value<int> rowid;
  const FeedbackEffectivenessTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.feedbackType = const Value.absent(),
    this.drivingBehaviorType = const Value.absent(),
    this.timesDelivered = const Value.absent(),
    this.timesBehaviorImproved = const Value.absent(),
    this.effectivenessRatio = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FeedbackEffectivenessTableCompanion.insert({
    required String id,
    required String userId,
    required String feedbackType,
    required String drivingBehaviorType,
    this.timesDelivered = const Value.absent(),
    this.timesBehaviorImproved = const Value.absent(),
    this.effectivenessRatio = const Value.absent(),
    required DateTime lastUpdated,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       feedbackType = Value(feedbackType),
       drivingBehaviorType = Value(drivingBehaviorType),
       lastUpdated = Value(lastUpdated);
  static Insertable<FeedbackEffectivenessTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? feedbackType,
    Expression<String>? drivingBehaviorType,
    Expression<int>? timesDelivered,
    Expression<int>? timesBehaviorImproved,
    Expression<double>? effectivenessRatio,
    Expression<DateTime>? lastUpdated,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (feedbackType != null) 'feedback_type': feedbackType,
      if (drivingBehaviorType != null)
        'driving_behavior_type': drivingBehaviorType,
      if (timesDelivered != null) 'times_delivered': timesDelivered,
      if (timesBehaviorImproved != null)
        'times_behavior_improved': timesBehaviorImproved,
      if (effectivenessRatio != null) 'effectiveness_ratio': effectivenessRatio,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FeedbackEffectivenessTableCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? feedbackType,
    Value<String>? drivingBehaviorType,
    Value<int>? timesDelivered,
    Value<int>? timesBehaviorImproved,
    Value<double>? effectivenessRatio,
    Value<DateTime>? lastUpdated,
    Value<int>? rowid,
  }) {
    return FeedbackEffectivenessTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      feedbackType: feedbackType ?? this.feedbackType,
      drivingBehaviorType: drivingBehaviorType ?? this.drivingBehaviorType,
      timesDelivered: timesDelivered ?? this.timesDelivered,
      timesBehaviorImproved:
          timesBehaviorImproved ?? this.timesBehaviorImproved,
      effectivenessRatio: effectivenessRatio ?? this.effectivenessRatio,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (feedbackType.present) {
      map['feedback_type'] = Variable<String>(feedbackType.value);
    }
    if (drivingBehaviorType.present) {
      map['driving_behavior_type'] = Variable<String>(
        drivingBehaviorType.value,
      );
    }
    if (timesDelivered.present) {
      map['times_delivered'] = Variable<int>(timesDelivered.value);
    }
    if (timesBehaviorImproved.present) {
      map['times_behavior_improved'] = Variable<int>(
        timesBehaviorImproved.value,
      );
    }
    if (effectivenessRatio.present) {
      map['effectiveness_ratio'] = Variable<double>(effectivenessRatio.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FeedbackEffectivenessTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('feedbackType: $feedbackType, ')
          ..write('drivingBehaviorType: $drivingBehaviorType, ')
          ..write('timesDelivered: $timesDelivered, ')
          ..write('timesBehaviorImproved: $timesBehaviorImproved, ')
          ..write('effectivenessRatio: $effectivenessRatio, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChallengesTableTable extends ChallengesTable
    with TableInfo<$ChallengesTableTable, ChallengesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChallengesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 36,
      maxTextLength: 36,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetValueMeta = const VerificationMeta(
    'targetValue',
  );
  @override
  late final GeneratedColumn<int> targetValue = GeneratedColumn<int>(
    'target_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _metricTypeMeta = const VerificationMeta(
    'metricType',
  );
  @override
  late final GeneratedColumn<String> metricType = GeneratedColumn<String>(
    'metric_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSystemMeta = const VerificationMeta(
    'isSystem',
  );
  @override
  late final GeneratedColumn<bool> isSystem = GeneratedColumn<bool>(
    'is_system',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_system" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _creatorIdMeta = const VerificationMeta(
    'creatorId',
  );
  @override
  late final GeneratedColumn<String> creatorId = GeneratedColumn<String>(
    'creator_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES user_profiles_table (id)',
    ),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _difficultyLevelMeta = const VerificationMeta(
    'difficultyLevel',
  );
  @override
  late final GeneratedColumn<int> difficultyLevel = GeneratedColumn<int>(
    'difficulty_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _iconNameMeta = const VerificationMeta(
    'iconName',
  );
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
    'icon_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rewardTypeMeta = const VerificationMeta(
    'rewardType',
  );
  @override
  late final GeneratedColumn<String> rewardType = GeneratedColumn<String>(
    'reward_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rewardValueMeta = const VerificationMeta(
    'rewardValue',
  );
  @override
  late final GeneratedColumn<int> rewardValue = GeneratedColumn<int>(
    'reward_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    type,
    targetValue,
    metricType,
    isSystem,
    creatorId,
    isActive,
    difficultyLevel,
    iconName,
    rewardType,
    rewardValue,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'challenges_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChallengesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('target_value')) {
      context.handle(
        _targetValueMeta,
        targetValue.isAcceptableOrUnknown(
          data['target_value']!,
          _targetValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetValueMeta);
    }
    if (data.containsKey('metric_type')) {
      context.handle(
        _metricTypeMeta,
        metricType.isAcceptableOrUnknown(data['metric_type']!, _metricTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_metricTypeMeta);
    }
    if (data.containsKey('is_system')) {
      context.handle(
        _isSystemMeta,
        isSystem.isAcceptableOrUnknown(data['is_system']!, _isSystemMeta),
      );
    }
    if (data.containsKey('creator_id')) {
      context.handle(
        _creatorIdMeta,
        creatorId.isAcceptableOrUnknown(data['creator_id']!, _creatorIdMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('difficulty_level')) {
      context.handle(
        _difficultyLevelMeta,
        difficultyLevel.isAcceptableOrUnknown(
          data['difficulty_level']!,
          _difficultyLevelMeta,
        ),
      );
    }
    if (data.containsKey('icon_name')) {
      context.handle(
        _iconNameMeta,
        iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta),
      );
    }
    if (data.containsKey('reward_type')) {
      context.handle(
        _rewardTypeMeta,
        rewardType.isAcceptableOrUnknown(data['reward_type']!, _rewardTypeMeta),
      );
    }
    if (data.containsKey('reward_value')) {
      context.handle(
        _rewardValueMeta,
        rewardValue.isAcceptableOrUnknown(
          data['reward_value']!,
          _rewardValueMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChallengesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChallengesTableData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      title:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}title'],
          )!,
      description:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}description'],
          )!,
      type:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}type'],
          )!,
      targetValue:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}target_value'],
          )!,
      metricType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}metric_type'],
          )!,
      isSystem:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_system'],
          )!,
      creatorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}creator_id'],
      ),
      isActive:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_active'],
          )!,
      difficultyLevel:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}difficulty_level'],
          )!,
      iconName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_name'],
      ),
      rewardType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reward_type'],
      ),
      rewardValue:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}reward_value'],
          )!,
    );
  }

  @override
  $ChallengesTableTable createAlias(String alias) {
    return $ChallengesTableTable(attachedDatabase, alias);
  }
}

class ChallengesTableData extends DataClass
    implements Insertable<ChallengesTableData> {
  final String id;
  final String title;
  final String description;
  final String type;
  final int targetValue;
  final String metricType;
  final bool isSystem;
  final String? creatorId;
  final bool isActive;
  final int difficultyLevel;
  final String? iconName;
  final String? rewardType;
  final int rewardValue;
  const ChallengesTableData({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.targetValue,
    required this.metricType,
    required this.isSystem,
    this.creatorId,
    required this.isActive,
    required this.difficultyLevel,
    this.iconName,
    this.rewardType,
    required this.rewardValue,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['type'] = Variable<String>(type);
    map['target_value'] = Variable<int>(targetValue);
    map['metric_type'] = Variable<String>(metricType);
    map['is_system'] = Variable<bool>(isSystem);
    if (!nullToAbsent || creatorId != null) {
      map['creator_id'] = Variable<String>(creatorId);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['difficulty_level'] = Variable<int>(difficultyLevel);
    if (!nullToAbsent || iconName != null) {
      map['icon_name'] = Variable<String>(iconName);
    }
    if (!nullToAbsent || rewardType != null) {
      map['reward_type'] = Variable<String>(rewardType);
    }
    map['reward_value'] = Variable<int>(rewardValue);
    return map;
  }

  ChallengesTableCompanion toCompanion(bool nullToAbsent) {
    return ChallengesTableCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      type: Value(type),
      targetValue: Value(targetValue),
      metricType: Value(metricType),
      isSystem: Value(isSystem),
      creatorId:
          creatorId == null && nullToAbsent
              ? const Value.absent()
              : Value(creatorId),
      isActive: Value(isActive),
      difficultyLevel: Value(difficultyLevel),
      iconName:
          iconName == null && nullToAbsent
              ? const Value.absent()
              : Value(iconName),
      rewardType:
          rewardType == null && nullToAbsent
              ? const Value.absent()
              : Value(rewardType),
      rewardValue: Value(rewardValue),
    );
  }

  factory ChallengesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChallengesTableData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      type: serializer.fromJson<String>(json['type']),
      targetValue: serializer.fromJson<int>(json['targetValue']),
      metricType: serializer.fromJson<String>(json['metricType']),
      isSystem: serializer.fromJson<bool>(json['isSystem']),
      creatorId: serializer.fromJson<String?>(json['creatorId']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      difficultyLevel: serializer.fromJson<int>(json['difficultyLevel']),
      iconName: serializer.fromJson<String?>(json['iconName']),
      rewardType: serializer.fromJson<String?>(json['rewardType']),
      rewardValue: serializer.fromJson<int>(json['rewardValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'type': serializer.toJson<String>(type),
      'targetValue': serializer.toJson<int>(targetValue),
      'metricType': serializer.toJson<String>(metricType),
      'isSystem': serializer.toJson<bool>(isSystem),
      'creatorId': serializer.toJson<String?>(creatorId),
      'isActive': serializer.toJson<bool>(isActive),
      'difficultyLevel': serializer.toJson<int>(difficultyLevel),
      'iconName': serializer.toJson<String?>(iconName),
      'rewardType': serializer.toJson<String?>(rewardType),
      'rewardValue': serializer.toJson<int>(rewardValue),
    };
  }

  ChallengesTableData copyWith({
    String? id,
    String? title,
    String? description,
    String? type,
    int? targetValue,
    String? metricType,
    bool? isSystem,
    Value<String?> creatorId = const Value.absent(),
    bool? isActive,
    int? difficultyLevel,
    Value<String?> iconName = const Value.absent(),
    Value<String?> rewardType = const Value.absent(),
    int? rewardValue,
  }) => ChallengesTableData(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    type: type ?? this.type,
    targetValue: targetValue ?? this.targetValue,
    metricType: metricType ?? this.metricType,
    isSystem: isSystem ?? this.isSystem,
    creatorId: creatorId.present ? creatorId.value : this.creatorId,
    isActive: isActive ?? this.isActive,
    difficultyLevel: difficultyLevel ?? this.difficultyLevel,
    iconName: iconName.present ? iconName.value : this.iconName,
    rewardType: rewardType.present ? rewardType.value : this.rewardType,
    rewardValue: rewardValue ?? this.rewardValue,
  );
  ChallengesTableData copyWithCompanion(ChallengesTableCompanion data) {
    return ChallengesTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      type: data.type.present ? data.type.value : this.type,
      targetValue:
          data.targetValue.present ? data.targetValue.value : this.targetValue,
      metricType:
          data.metricType.present ? data.metricType.value : this.metricType,
      isSystem: data.isSystem.present ? data.isSystem.value : this.isSystem,
      creatorId: data.creatorId.present ? data.creatorId.value : this.creatorId,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      difficultyLevel:
          data.difficultyLevel.present
              ? data.difficultyLevel.value
              : this.difficultyLevel,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      rewardType:
          data.rewardType.present ? data.rewardType.value : this.rewardType,
      rewardValue:
          data.rewardValue.present ? data.rewardValue.value : this.rewardValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChallengesTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('targetValue: $targetValue, ')
          ..write('metricType: $metricType, ')
          ..write('isSystem: $isSystem, ')
          ..write('creatorId: $creatorId, ')
          ..write('isActive: $isActive, ')
          ..write('difficultyLevel: $difficultyLevel, ')
          ..write('iconName: $iconName, ')
          ..write('rewardType: $rewardType, ')
          ..write('rewardValue: $rewardValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    type,
    targetValue,
    metricType,
    isSystem,
    creatorId,
    isActive,
    difficultyLevel,
    iconName,
    rewardType,
    rewardValue,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChallengesTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.type == this.type &&
          other.targetValue == this.targetValue &&
          other.metricType == this.metricType &&
          other.isSystem == this.isSystem &&
          other.creatorId == this.creatorId &&
          other.isActive == this.isActive &&
          other.difficultyLevel == this.difficultyLevel &&
          other.iconName == this.iconName &&
          other.rewardType == this.rewardType &&
          other.rewardValue == this.rewardValue);
}

class ChallengesTableCompanion extends UpdateCompanion<ChallengesTableData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> description;
  final Value<String> type;
  final Value<int> targetValue;
  final Value<String> metricType;
  final Value<bool> isSystem;
  final Value<String?> creatorId;
  final Value<bool> isActive;
  final Value<int> difficultyLevel;
  final Value<String?> iconName;
  final Value<String?> rewardType;
  final Value<int> rewardValue;
  final Value<int> rowid;
  const ChallengesTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.type = const Value.absent(),
    this.targetValue = const Value.absent(),
    this.metricType = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.creatorId = const Value.absent(),
    this.isActive = const Value.absent(),
    this.difficultyLevel = const Value.absent(),
    this.iconName = const Value.absent(),
    this.rewardType = const Value.absent(),
    this.rewardValue = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChallengesTableCompanion.insert({
    required String id,
    required String title,
    required String description,
    required String type,
    required int targetValue,
    required String metricType,
    this.isSystem = const Value.absent(),
    this.creatorId = const Value.absent(),
    this.isActive = const Value.absent(),
    this.difficultyLevel = const Value.absent(),
    this.iconName = const Value.absent(),
    this.rewardType = const Value.absent(),
    this.rewardValue = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       description = Value(description),
       type = Value(type),
       targetValue = Value(targetValue),
       metricType = Value(metricType);
  static Insertable<ChallengesTableData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? type,
    Expression<int>? targetValue,
    Expression<String>? metricType,
    Expression<bool>? isSystem,
    Expression<String>? creatorId,
    Expression<bool>? isActive,
    Expression<int>? difficultyLevel,
    Expression<String>? iconName,
    Expression<String>? rewardType,
    Expression<int>? rewardValue,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (type != null) 'type': type,
      if (targetValue != null) 'target_value': targetValue,
      if (metricType != null) 'metric_type': metricType,
      if (isSystem != null) 'is_system': isSystem,
      if (creatorId != null) 'creator_id': creatorId,
      if (isActive != null) 'is_active': isActive,
      if (difficultyLevel != null) 'difficulty_level': difficultyLevel,
      if (iconName != null) 'icon_name': iconName,
      if (rewardType != null) 'reward_type': rewardType,
      if (rewardValue != null) 'reward_value': rewardValue,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChallengesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? description,
    Value<String>? type,
    Value<int>? targetValue,
    Value<String>? metricType,
    Value<bool>? isSystem,
    Value<String?>? creatorId,
    Value<bool>? isActive,
    Value<int>? difficultyLevel,
    Value<String?>? iconName,
    Value<String?>? rewardType,
    Value<int>? rewardValue,
    Value<int>? rowid,
  }) {
    return ChallengesTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      targetValue: targetValue ?? this.targetValue,
      metricType: metricType ?? this.metricType,
      isSystem: isSystem ?? this.isSystem,
      creatorId: creatorId ?? this.creatorId,
      isActive: isActive ?? this.isActive,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      iconName: iconName ?? this.iconName,
      rewardType: rewardType ?? this.rewardType,
      rewardValue: rewardValue ?? this.rewardValue,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (targetValue.present) {
      map['target_value'] = Variable<int>(targetValue.value);
    }
    if (metricType.present) {
      map['metric_type'] = Variable<String>(metricType.value);
    }
    if (isSystem.present) {
      map['is_system'] = Variable<bool>(isSystem.value);
    }
    if (creatorId.present) {
      map['creator_id'] = Variable<String>(creatorId.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (difficultyLevel.present) {
      map['difficulty_level'] = Variable<int>(difficultyLevel.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (rewardType.present) {
      map['reward_type'] = Variable<String>(rewardType.value);
    }
    if (rewardValue.present) {
      map['reward_value'] = Variable<int>(rewardValue.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChallengesTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('targetValue: $targetValue, ')
          ..write('metricType: $metricType, ')
          ..write('isSystem: $isSystem, ')
          ..write('creatorId: $creatorId, ')
          ..write('isActive: $isActive, ')
          ..write('difficultyLevel: $difficultyLevel, ')
          ..write('iconName: $iconName, ')
          ..write('rewardType: $rewardType, ')
          ..write('rewardValue: $rewardValue, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserChallengesTableTable extends UserChallengesTable
    with TableInfo<$UserChallengesTableTable, UserChallengesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserChallengesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 36,
      maxTextLength: 36,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES user_profiles_table (id)',
    ),
  );
  static const VerificationMeta _challengeIdMeta = const VerificationMeta(
    'challengeId',
  );
  @override
  late final GeneratedColumn<String> challengeId = GeneratedColumn<String>(
    'challenge_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES challenges_table (id)',
    ),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _progressMeta = const VerificationMeta(
    'progress',
  );
  @override
  late final GeneratedColumn<int> progress = GeneratedColumn<int>(
    'progress',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _rewardClaimedMeta = const VerificationMeta(
    'rewardClaimed',
  );
  @override
  late final GeneratedColumn<bool> rewardClaimed = GeneratedColumn<bool>(
    'reward_claimed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reward_claimed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    challengeId,
    startedAt,
    completedAt,
    progress,
    isCompleted,
    rewardClaimed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_challenges_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserChallengesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('challenge_id')) {
      context.handle(
        _challengeIdMeta,
        challengeId.isAcceptableOrUnknown(
          data['challenge_id']!,
          _challengeIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_challengeIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('progress')) {
      context.handle(
        _progressMeta,
        progress.isAcceptableOrUnknown(data['progress']!, _progressMeta),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('reward_claimed')) {
      context.handle(
        _rewardClaimedMeta,
        rewardClaimed.isAcceptableOrUnknown(
          data['reward_claimed']!,
          _rewardClaimedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserChallengesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserChallengesTableData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      userId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}user_id'],
          )!,
      challengeId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}challenge_id'],
          )!,
      startedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}started_at'],
          )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      progress:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}progress'],
          )!,
      isCompleted:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_completed'],
          )!,
      rewardClaimed:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}reward_claimed'],
          )!,
    );
  }

  @override
  $UserChallengesTableTable createAlias(String alias) {
    return $UserChallengesTableTable(attachedDatabase, alias);
  }
}

class UserChallengesTableData extends DataClass
    implements Insertable<UserChallengesTableData> {
  final String id;
  final String userId;
  final String challengeId;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int progress;
  final bool isCompleted;
  final bool rewardClaimed;
  const UserChallengesTableData({
    required this.id,
    required this.userId,
    required this.challengeId,
    required this.startedAt,
    this.completedAt,
    required this.progress,
    required this.isCompleted,
    required this.rewardClaimed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['challenge_id'] = Variable<String>(challengeId);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['progress'] = Variable<int>(progress);
    map['is_completed'] = Variable<bool>(isCompleted);
    map['reward_claimed'] = Variable<bool>(rewardClaimed);
    return map;
  }

  UserChallengesTableCompanion toCompanion(bool nullToAbsent) {
    return UserChallengesTableCompanion(
      id: Value(id),
      userId: Value(userId),
      challengeId: Value(challengeId),
      startedAt: Value(startedAt),
      completedAt:
          completedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(completedAt),
      progress: Value(progress),
      isCompleted: Value(isCompleted),
      rewardClaimed: Value(rewardClaimed),
    );
  }

  factory UserChallengesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserChallengesTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      challengeId: serializer.fromJson<String>(json['challengeId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      progress: serializer.fromJson<int>(json['progress']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      rewardClaimed: serializer.fromJson<bool>(json['rewardClaimed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'challengeId': serializer.toJson<String>(challengeId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'progress': serializer.toJson<int>(progress),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'rewardClaimed': serializer.toJson<bool>(rewardClaimed),
    };
  }

  UserChallengesTableData copyWith({
    String? id,
    String? userId,
    String? challengeId,
    DateTime? startedAt,
    Value<DateTime?> completedAt = const Value.absent(),
    int? progress,
    bool? isCompleted,
    bool? rewardClaimed,
  }) => UserChallengesTableData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    challengeId: challengeId ?? this.challengeId,
    startedAt: startedAt ?? this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    progress: progress ?? this.progress,
    isCompleted: isCompleted ?? this.isCompleted,
    rewardClaimed: rewardClaimed ?? this.rewardClaimed,
  );
  UserChallengesTableData copyWithCompanion(UserChallengesTableCompanion data) {
    return UserChallengesTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      challengeId:
          data.challengeId.present ? data.challengeId.value : this.challengeId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      progress: data.progress.present ? data.progress.value : this.progress,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
      rewardClaimed:
          data.rewardClaimed.present
              ? data.rewardClaimed.value
              : this.rewardClaimed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserChallengesTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('challengeId: $challengeId, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('progress: $progress, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('rewardClaimed: $rewardClaimed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    challengeId,
    startedAt,
    completedAt,
    progress,
    isCompleted,
    rewardClaimed,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserChallengesTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.challengeId == this.challengeId &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.progress == this.progress &&
          other.isCompleted == this.isCompleted &&
          other.rewardClaimed == this.rewardClaimed);
}

class UserChallengesTableCompanion
    extends UpdateCompanion<UserChallengesTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> challengeId;
  final Value<DateTime> startedAt;
  final Value<DateTime?> completedAt;
  final Value<int> progress;
  final Value<bool> isCompleted;
  final Value<bool> rewardClaimed;
  final Value<int> rowid;
  const UserChallengesTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.challengeId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.progress = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.rewardClaimed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserChallengesTableCompanion.insert({
    required String id,
    required String userId,
    required String challengeId,
    required DateTime startedAt,
    this.completedAt = const Value.absent(),
    this.progress = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.rewardClaimed = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       challengeId = Value(challengeId),
       startedAt = Value(startedAt);
  static Insertable<UserChallengesTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? challengeId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<int>? progress,
    Expression<bool>? isCompleted,
    Expression<bool>? rewardClaimed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (challengeId != null) 'challenge_id': challengeId,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (progress != null) 'progress': progress,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (rewardClaimed != null) 'reward_claimed': rewardClaimed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserChallengesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? challengeId,
    Value<DateTime>? startedAt,
    Value<DateTime?>? completedAt,
    Value<int>? progress,
    Value<bool>? isCompleted,
    Value<bool>? rewardClaimed,
    Value<int>? rowid,
  }) {
    return UserChallengesTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      challengeId: challengeId ?? this.challengeId,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      progress: progress ?? this.progress,
      isCompleted: isCompleted ?? this.isCompleted,
      rewardClaimed: rewardClaimed ?? this.rewardClaimed,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (challengeId.present) {
      map['challenge_id'] = Variable<String>(challengeId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (progress.present) {
      map['progress'] = Variable<int>(progress.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (rewardClaimed.present) {
      map['reward_claimed'] = Variable<bool>(rewardClaimed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserChallengesTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('challengeId: $challengeId, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('progress: $progress, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('rewardClaimed: $rewardClaimed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StreaksTableTable extends StreaksTable
    with TableInfo<$StreaksTableTable, StreaksTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StreaksTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 36,
      maxTextLength: 36,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES user_profiles_table (id)',
    ),
  );
  static const VerificationMeta _streakTypeMeta = const VerificationMeta(
    'streakType',
  );
  @override
  late final GeneratedColumn<String> streakType = GeneratedColumn<String>(
    'streak_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentCountMeta = const VerificationMeta(
    'currentCount',
  );
  @override
  late final GeneratedColumn<int> currentCount = GeneratedColumn<int>(
    'current_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _bestCountMeta = const VerificationMeta(
    'bestCount',
  );
  @override
  late final GeneratedColumn<int> bestCount = GeneratedColumn<int>(
    'best_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastRecordedMeta = const VerificationMeta(
    'lastRecorded',
  );
  @override
  late final GeneratedColumn<DateTime> lastRecorded = GeneratedColumn<DateTime>(
    'last_recorded',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextDueMeta = const VerificationMeta(
    'nextDue',
  );
  @override
  late final GeneratedColumn<DateTime> nextDue = GeneratedColumn<DateTime>(
    'next_due',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    streakType,
    currentCount,
    bestCount,
    lastRecorded,
    nextDue,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'streaks_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<StreaksTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('streak_type')) {
      context.handle(
        _streakTypeMeta,
        streakType.isAcceptableOrUnknown(data['streak_type']!, _streakTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_streakTypeMeta);
    }
    if (data.containsKey('current_count')) {
      context.handle(
        _currentCountMeta,
        currentCount.isAcceptableOrUnknown(
          data['current_count']!,
          _currentCountMeta,
        ),
      );
    }
    if (data.containsKey('best_count')) {
      context.handle(
        _bestCountMeta,
        bestCount.isAcceptableOrUnknown(data['best_count']!, _bestCountMeta),
      );
    }
    if (data.containsKey('last_recorded')) {
      context.handle(
        _lastRecordedMeta,
        lastRecorded.isAcceptableOrUnknown(
          data['last_recorded']!,
          _lastRecordedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastRecordedMeta);
    }
    if (data.containsKey('next_due')) {
      context.handle(
        _nextDueMeta,
        nextDue.isAcceptableOrUnknown(data['next_due']!, _nextDueMeta),
      );
    } else if (isInserting) {
      context.missing(_nextDueMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StreaksTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StreaksTableData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      userId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}user_id'],
          )!,
      streakType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}streak_type'],
          )!,
      currentCount:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}current_count'],
          )!,
      bestCount:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}best_count'],
          )!,
      lastRecorded:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}last_recorded'],
          )!,
      nextDue:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}next_due'],
          )!,
      isActive:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_active'],
          )!,
    );
  }

  @override
  $StreaksTableTable createAlias(String alias) {
    return $StreaksTableTable(attachedDatabase, alias);
  }
}

class StreaksTableData extends DataClass
    implements Insertable<StreaksTableData> {
  final String id;
  final String userId;
  final String streakType;
  final int currentCount;
  final int bestCount;
  final DateTime lastRecorded;
  final DateTime nextDue;
  final bool isActive;
  const StreaksTableData({
    required this.id,
    required this.userId,
    required this.streakType,
    required this.currentCount,
    required this.bestCount,
    required this.lastRecorded,
    required this.nextDue,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['streak_type'] = Variable<String>(streakType);
    map['current_count'] = Variable<int>(currentCount);
    map['best_count'] = Variable<int>(bestCount);
    map['last_recorded'] = Variable<DateTime>(lastRecorded);
    map['next_due'] = Variable<DateTime>(nextDue);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  StreaksTableCompanion toCompanion(bool nullToAbsent) {
    return StreaksTableCompanion(
      id: Value(id),
      userId: Value(userId),
      streakType: Value(streakType),
      currentCount: Value(currentCount),
      bestCount: Value(bestCount),
      lastRecorded: Value(lastRecorded),
      nextDue: Value(nextDue),
      isActive: Value(isActive),
    );
  }

  factory StreaksTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StreaksTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      streakType: serializer.fromJson<String>(json['streakType']),
      currentCount: serializer.fromJson<int>(json['currentCount']),
      bestCount: serializer.fromJson<int>(json['bestCount']),
      lastRecorded: serializer.fromJson<DateTime>(json['lastRecorded']),
      nextDue: serializer.fromJson<DateTime>(json['nextDue']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'streakType': serializer.toJson<String>(streakType),
      'currentCount': serializer.toJson<int>(currentCount),
      'bestCount': serializer.toJson<int>(bestCount),
      'lastRecorded': serializer.toJson<DateTime>(lastRecorded),
      'nextDue': serializer.toJson<DateTime>(nextDue),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  StreaksTableData copyWith({
    String? id,
    String? userId,
    String? streakType,
    int? currentCount,
    int? bestCount,
    DateTime? lastRecorded,
    DateTime? nextDue,
    bool? isActive,
  }) => StreaksTableData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    streakType: streakType ?? this.streakType,
    currentCount: currentCount ?? this.currentCount,
    bestCount: bestCount ?? this.bestCount,
    lastRecorded: lastRecorded ?? this.lastRecorded,
    nextDue: nextDue ?? this.nextDue,
    isActive: isActive ?? this.isActive,
  );
  StreaksTableData copyWithCompanion(StreaksTableCompanion data) {
    return StreaksTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      streakType:
          data.streakType.present ? data.streakType.value : this.streakType,
      currentCount:
          data.currentCount.present
              ? data.currentCount.value
              : this.currentCount,
      bestCount: data.bestCount.present ? data.bestCount.value : this.bestCount,
      lastRecorded:
          data.lastRecorded.present
              ? data.lastRecorded.value
              : this.lastRecorded,
      nextDue: data.nextDue.present ? data.nextDue.value : this.nextDue,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StreaksTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('streakType: $streakType, ')
          ..write('currentCount: $currentCount, ')
          ..write('bestCount: $bestCount, ')
          ..write('lastRecorded: $lastRecorded, ')
          ..write('nextDue: $nextDue, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    streakType,
    currentCount,
    bestCount,
    lastRecorded,
    nextDue,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StreaksTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.streakType == this.streakType &&
          other.currentCount == this.currentCount &&
          other.bestCount == this.bestCount &&
          other.lastRecorded == this.lastRecorded &&
          other.nextDue == this.nextDue &&
          other.isActive == this.isActive);
}

class StreaksTableCompanion extends UpdateCompanion<StreaksTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> streakType;
  final Value<int> currentCount;
  final Value<int> bestCount;
  final Value<DateTime> lastRecorded;
  final Value<DateTime> nextDue;
  final Value<bool> isActive;
  final Value<int> rowid;
  const StreaksTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.streakType = const Value.absent(),
    this.currentCount = const Value.absent(),
    this.bestCount = const Value.absent(),
    this.lastRecorded = const Value.absent(),
    this.nextDue = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StreaksTableCompanion.insert({
    required String id,
    required String userId,
    required String streakType,
    this.currentCount = const Value.absent(),
    this.bestCount = const Value.absent(),
    required DateTime lastRecorded,
    required DateTime nextDue,
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       streakType = Value(streakType),
       lastRecorded = Value(lastRecorded),
       nextDue = Value(nextDue);
  static Insertable<StreaksTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? streakType,
    Expression<int>? currentCount,
    Expression<int>? bestCount,
    Expression<DateTime>? lastRecorded,
    Expression<DateTime>? nextDue,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (streakType != null) 'streak_type': streakType,
      if (currentCount != null) 'current_count': currentCount,
      if (bestCount != null) 'best_count': bestCount,
      if (lastRecorded != null) 'last_recorded': lastRecorded,
      if (nextDue != null) 'next_due': nextDue,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StreaksTableCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? streakType,
    Value<int>? currentCount,
    Value<int>? bestCount,
    Value<DateTime>? lastRecorded,
    Value<DateTime>? nextDue,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return StreaksTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      streakType: streakType ?? this.streakType,
      currentCount: currentCount ?? this.currentCount,
      bestCount: bestCount ?? this.bestCount,
      lastRecorded: lastRecorded ?? this.lastRecorded,
      nextDue: nextDue ?? this.nextDue,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (streakType.present) {
      map['streak_type'] = Variable<String>(streakType.value);
    }
    if (currentCount.present) {
      map['current_count'] = Variable<int>(currentCount.value);
    }
    if (bestCount.present) {
      map['best_count'] = Variable<int>(bestCount.value);
    }
    if (lastRecorded.present) {
      map['last_recorded'] = Variable<DateTime>(lastRecorded.value);
    }
    if (nextDue.present) {
      map['next_due'] = Variable<DateTime>(nextDue.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StreaksTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('streakType: $streakType, ')
          ..write('currentCount: $currentCount, ')
          ..write('bestCount: $bestCount, ')
          ..write('lastRecorded: $lastRecorded, ')
          ..write('nextDue: $nextDue, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LeaderboardEntriesTableTable extends LeaderboardEntriesTable
    with TableInfo<$LeaderboardEntriesTableTable, LeaderboardEntriesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LeaderboardEntriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 36,
      maxTextLength: 36,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _leaderboardTypeMeta = const VerificationMeta(
    'leaderboardType',
  );
  @override
  late final GeneratedColumn<String> leaderboardType = GeneratedColumn<String>(
    'leaderboard_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeframeMeta = const VerificationMeta(
    'timeframe',
  );
  @override
  late final GeneratedColumn<String> timeframe = GeneratedColumn<String>(
    'timeframe',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES user_profiles_table (id)',
    ),
  );
  static const VerificationMeta _regionCodeMeta = const VerificationMeta(
    'regionCode',
  );
  @override
  late final GeneratedColumn<String> regionCode = GeneratedColumn<String>(
    'region_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rankMeta = const VerificationMeta('rank');
  @override
  late final GeneratedColumn<int> rank = GeneratedColumn<int>(
    'rank',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta(
    'recordedAt',
  );
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _daysRetainedMeta = const VerificationMeta(
    'daysRetained',
  );
  @override
  late final GeneratedColumn<int> daysRetained = GeneratedColumn<int>(
    'days_retained',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    leaderboardType,
    timeframe,
    userId,
    regionCode,
    rank,
    score,
    recordedAt,
    daysRetained,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'leaderboard_entries_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<LeaderboardEntriesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('leaderboard_type')) {
      context.handle(
        _leaderboardTypeMeta,
        leaderboardType.isAcceptableOrUnknown(
          data['leaderboard_type']!,
          _leaderboardTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_leaderboardTypeMeta);
    }
    if (data.containsKey('timeframe')) {
      context.handle(
        _timeframeMeta,
        timeframe.isAcceptableOrUnknown(data['timeframe']!, _timeframeMeta),
      );
    } else if (isInserting) {
      context.missing(_timeframeMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('region_code')) {
      context.handle(
        _regionCodeMeta,
        regionCode.isAcceptableOrUnknown(data['region_code']!, _regionCodeMeta),
      );
    }
    if (data.containsKey('rank')) {
      context.handle(
        _rankMeta,
        rank.isAcceptableOrUnknown(data['rank']!, _rankMeta),
      );
    } else if (isInserting) {
      context.missing(_rankMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('days_retained')) {
      context.handle(
        _daysRetainedMeta,
        daysRetained.isAcceptableOrUnknown(
          data['days_retained']!,
          _daysRetainedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LeaderboardEntriesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LeaderboardEntriesTableData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      leaderboardType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}leaderboard_type'],
          )!,
      timeframe:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}timeframe'],
          )!,
      userId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}user_id'],
          )!,
      regionCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}region_code'],
      ),
      rank:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}rank'],
          )!,
      score:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}score'],
          )!,
      recordedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}recorded_at'],
          )!,
      daysRetained:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}days_retained'],
          )!,
    );
  }

  @override
  $LeaderboardEntriesTableTable createAlias(String alias) {
    return $LeaderboardEntriesTableTable(attachedDatabase, alias);
  }
}

class LeaderboardEntriesTableData extends DataClass
    implements Insertable<LeaderboardEntriesTableData> {
  final String id;
  final String leaderboardType;
  final String timeframe;
  final String userId;
  final String? regionCode;
  final int rank;
  final int score;
  final DateTime recordedAt;
  final int daysRetained;
  const LeaderboardEntriesTableData({
    required this.id,
    required this.leaderboardType,
    required this.timeframe,
    required this.userId,
    this.regionCode,
    required this.rank,
    required this.score,
    required this.recordedAt,
    required this.daysRetained,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['leaderboard_type'] = Variable<String>(leaderboardType);
    map['timeframe'] = Variable<String>(timeframe);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || regionCode != null) {
      map['region_code'] = Variable<String>(regionCode);
    }
    map['rank'] = Variable<int>(rank);
    map['score'] = Variable<int>(score);
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    map['days_retained'] = Variable<int>(daysRetained);
    return map;
  }

  LeaderboardEntriesTableCompanion toCompanion(bool nullToAbsent) {
    return LeaderboardEntriesTableCompanion(
      id: Value(id),
      leaderboardType: Value(leaderboardType),
      timeframe: Value(timeframe),
      userId: Value(userId),
      regionCode:
          regionCode == null && nullToAbsent
              ? const Value.absent()
              : Value(regionCode),
      rank: Value(rank),
      score: Value(score),
      recordedAt: Value(recordedAt),
      daysRetained: Value(daysRetained),
    );
  }

  factory LeaderboardEntriesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LeaderboardEntriesTableData(
      id: serializer.fromJson<String>(json['id']),
      leaderboardType: serializer.fromJson<String>(json['leaderboardType']),
      timeframe: serializer.fromJson<String>(json['timeframe']),
      userId: serializer.fromJson<String>(json['userId']),
      regionCode: serializer.fromJson<String?>(json['regionCode']),
      rank: serializer.fromJson<int>(json['rank']),
      score: serializer.fromJson<int>(json['score']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
      daysRetained: serializer.fromJson<int>(json['daysRetained']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'leaderboardType': serializer.toJson<String>(leaderboardType),
      'timeframe': serializer.toJson<String>(timeframe),
      'userId': serializer.toJson<String>(userId),
      'regionCode': serializer.toJson<String?>(regionCode),
      'rank': serializer.toJson<int>(rank),
      'score': serializer.toJson<int>(score),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
      'daysRetained': serializer.toJson<int>(daysRetained),
    };
  }

  LeaderboardEntriesTableData copyWith({
    String? id,
    String? leaderboardType,
    String? timeframe,
    String? userId,
    Value<String?> regionCode = const Value.absent(),
    int? rank,
    int? score,
    DateTime? recordedAt,
    int? daysRetained,
  }) => LeaderboardEntriesTableData(
    id: id ?? this.id,
    leaderboardType: leaderboardType ?? this.leaderboardType,
    timeframe: timeframe ?? this.timeframe,
    userId: userId ?? this.userId,
    regionCode: regionCode.present ? regionCode.value : this.regionCode,
    rank: rank ?? this.rank,
    score: score ?? this.score,
    recordedAt: recordedAt ?? this.recordedAt,
    daysRetained: daysRetained ?? this.daysRetained,
  );
  LeaderboardEntriesTableData copyWithCompanion(
    LeaderboardEntriesTableCompanion data,
  ) {
    return LeaderboardEntriesTableData(
      id: data.id.present ? data.id.value : this.id,
      leaderboardType:
          data.leaderboardType.present
              ? data.leaderboardType.value
              : this.leaderboardType,
      timeframe: data.timeframe.present ? data.timeframe.value : this.timeframe,
      userId: data.userId.present ? data.userId.value : this.userId,
      regionCode:
          data.regionCode.present ? data.regionCode.value : this.regionCode,
      rank: data.rank.present ? data.rank.value : this.rank,
      score: data.score.present ? data.score.value : this.score,
      recordedAt:
          data.recordedAt.present ? data.recordedAt.value : this.recordedAt,
      daysRetained:
          data.daysRetained.present
              ? data.daysRetained.value
              : this.daysRetained,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LeaderboardEntriesTableData(')
          ..write('id: $id, ')
          ..write('leaderboardType: $leaderboardType, ')
          ..write('timeframe: $timeframe, ')
          ..write('userId: $userId, ')
          ..write('regionCode: $regionCode, ')
          ..write('rank: $rank, ')
          ..write('score: $score, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('daysRetained: $daysRetained')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    leaderboardType,
    timeframe,
    userId,
    regionCode,
    rank,
    score,
    recordedAt,
    daysRetained,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LeaderboardEntriesTableData &&
          other.id == this.id &&
          other.leaderboardType == this.leaderboardType &&
          other.timeframe == this.timeframe &&
          other.userId == this.userId &&
          other.regionCode == this.regionCode &&
          other.rank == this.rank &&
          other.score == this.score &&
          other.recordedAt == this.recordedAt &&
          other.daysRetained == this.daysRetained);
}

class LeaderboardEntriesTableCompanion
    extends UpdateCompanion<LeaderboardEntriesTableData> {
  final Value<String> id;
  final Value<String> leaderboardType;
  final Value<String> timeframe;
  final Value<String> userId;
  final Value<String?> regionCode;
  final Value<int> rank;
  final Value<int> score;
  final Value<DateTime> recordedAt;
  final Value<int> daysRetained;
  final Value<int> rowid;
  const LeaderboardEntriesTableCompanion({
    this.id = const Value.absent(),
    this.leaderboardType = const Value.absent(),
    this.timeframe = const Value.absent(),
    this.userId = const Value.absent(),
    this.regionCode = const Value.absent(),
    this.rank = const Value.absent(),
    this.score = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.daysRetained = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LeaderboardEntriesTableCompanion.insert({
    required String id,
    required String leaderboardType,
    required String timeframe,
    required String userId,
    this.regionCode = const Value.absent(),
    required int rank,
    required int score,
    required DateTime recordedAt,
    this.daysRetained = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       leaderboardType = Value(leaderboardType),
       timeframe = Value(timeframe),
       userId = Value(userId),
       rank = Value(rank),
       score = Value(score),
       recordedAt = Value(recordedAt);
  static Insertable<LeaderboardEntriesTableData> custom({
    Expression<String>? id,
    Expression<String>? leaderboardType,
    Expression<String>? timeframe,
    Expression<String>? userId,
    Expression<String>? regionCode,
    Expression<int>? rank,
    Expression<int>? score,
    Expression<DateTime>? recordedAt,
    Expression<int>? daysRetained,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (leaderboardType != null) 'leaderboard_type': leaderboardType,
      if (timeframe != null) 'timeframe': timeframe,
      if (userId != null) 'user_id': userId,
      if (regionCode != null) 'region_code': regionCode,
      if (rank != null) 'rank': rank,
      if (score != null) 'score': score,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (daysRetained != null) 'days_retained': daysRetained,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LeaderboardEntriesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? leaderboardType,
    Value<String>? timeframe,
    Value<String>? userId,
    Value<String?>? regionCode,
    Value<int>? rank,
    Value<int>? score,
    Value<DateTime>? recordedAt,
    Value<int>? daysRetained,
    Value<int>? rowid,
  }) {
    return LeaderboardEntriesTableCompanion(
      id: id ?? this.id,
      leaderboardType: leaderboardType ?? this.leaderboardType,
      timeframe: timeframe ?? this.timeframe,
      userId: userId ?? this.userId,
      regionCode: regionCode ?? this.regionCode,
      rank: rank ?? this.rank,
      score: score ?? this.score,
      recordedAt: recordedAt ?? this.recordedAt,
      daysRetained: daysRetained ?? this.daysRetained,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (leaderboardType.present) {
      map['leaderboard_type'] = Variable<String>(leaderboardType.value);
    }
    if (timeframe.present) {
      map['timeframe'] = Variable<String>(timeframe.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (regionCode.present) {
      map['region_code'] = Variable<String>(regionCode.value);
    }
    if (rank.present) {
      map['rank'] = Variable<int>(rank.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (daysRetained.present) {
      map['days_retained'] = Variable<int>(daysRetained.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LeaderboardEntriesTableCompanion(')
          ..write('id: $id, ')
          ..write('leaderboardType: $leaderboardType, ')
          ..write('timeframe: $timeframe, ')
          ..write('userId: $userId, ')
          ..write('regionCode: $regionCode, ')
          ..write('rank: $rank, ')
          ..write('score: $score, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('daysRetained: $daysRetained, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExternalIntegrationsTableTable extends ExternalIntegrationsTable
    with
        TableInfo<
          $ExternalIntegrationsTableTable,
          ExternalIntegrationsTableData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExternalIntegrationsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 36,
      maxTextLength: 36,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES user_profiles_table (id)',
    ),
  );
  static const VerificationMeta _platformTypeMeta = const VerificationMeta(
    'platformType',
  );
  @override
  late final GeneratedColumn<String> platformType = GeneratedColumn<String>(
    'platform_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _externalIdMeta = const VerificationMeta(
    'externalId',
  );
  @override
  late final GeneratedColumn<String> externalId = GeneratedColumn<String>(
    'external_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _integrationStatusMeta = const VerificationMeta(
    'integrationStatus',
  );
  @override
  late final GeneratedColumn<String> integrationStatus =
      GeneratedColumn<String>(
        'integration_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _connectedAtMeta = const VerificationMeta(
    'connectedAt',
  );
  @override
  late final GeneratedColumn<DateTime> connectedAt = GeneratedColumn<DateTime>(
    'connected_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSyncAtMeta = const VerificationMeta(
    'lastSyncAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncAt = GeneratedColumn<DateTime>(
    'last_sync_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accessTokenMeta = const VerificationMeta(
    'accessToken',
  );
  @override
  late final GeneratedColumn<String> accessToken = GeneratedColumn<String>(
    'access_token',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _refreshTokenMeta = const VerificationMeta(
    'refreshToken',
  );
  @override
  late final GeneratedColumn<String> refreshToken = GeneratedColumn<String>(
    'refresh_token',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _integrationDataJsonMeta =
      const VerificationMeta('integrationDataJson');
  @override
  late final GeneratedColumn<String> integrationDataJson =
      GeneratedColumn<String>(
        'integration_data_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    platformType,
    externalId,
    integrationStatus,
    connectedAt,
    lastSyncAt,
    accessToken,
    refreshToken,
    integrationDataJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'external_integrations_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExternalIntegrationsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('platform_type')) {
      context.handle(
        _platformTypeMeta,
        platformType.isAcceptableOrUnknown(
          data['platform_type']!,
          _platformTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_platformTypeMeta);
    }
    if (data.containsKey('external_id')) {
      context.handle(
        _externalIdMeta,
        externalId.isAcceptableOrUnknown(data['external_id']!, _externalIdMeta),
      );
    }
    if (data.containsKey('integration_status')) {
      context.handle(
        _integrationStatusMeta,
        integrationStatus.isAcceptableOrUnknown(
          data['integration_status']!,
          _integrationStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_integrationStatusMeta);
    }
    if (data.containsKey('connected_at')) {
      context.handle(
        _connectedAtMeta,
        connectedAt.isAcceptableOrUnknown(
          data['connected_at']!,
          _connectedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_connectedAtMeta);
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
        _lastSyncAtMeta,
        lastSyncAt.isAcceptableOrUnknown(
          data['last_sync_at']!,
          _lastSyncAtMeta,
        ),
      );
    }
    if (data.containsKey('access_token')) {
      context.handle(
        _accessTokenMeta,
        accessToken.isAcceptableOrUnknown(
          data['access_token']!,
          _accessTokenMeta,
        ),
      );
    }
    if (data.containsKey('refresh_token')) {
      context.handle(
        _refreshTokenMeta,
        refreshToken.isAcceptableOrUnknown(
          data['refresh_token']!,
          _refreshTokenMeta,
        ),
      );
    }
    if (data.containsKey('integration_data_json')) {
      context.handle(
        _integrationDataJsonMeta,
        integrationDataJson.isAcceptableOrUnknown(
          data['integration_data_json']!,
          _integrationDataJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExternalIntegrationsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExternalIntegrationsTableData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      userId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}user_id'],
          )!,
      platformType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}platform_type'],
          )!,
      externalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_id'],
      ),
      integrationStatus:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}integration_status'],
          )!,
      connectedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}connected_at'],
          )!,
      lastSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_at'],
      ),
      accessToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}access_token'],
      ),
      refreshToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}refresh_token'],
      ),
      integrationDataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}integration_data_json'],
      ),
    );
  }

  @override
  $ExternalIntegrationsTableTable createAlias(String alias) {
    return $ExternalIntegrationsTableTable(attachedDatabase, alias);
  }
}

class ExternalIntegrationsTableData extends DataClass
    implements Insertable<ExternalIntegrationsTableData> {
  final String id;
  final String userId;
  final String platformType;
  final String? externalId;
  final String integrationStatus;
  final DateTime connectedAt;
  final DateTime? lastSyncAt;
  final String? accessToken;
  final String? refreshToken;
  final String? integrationDataJson;
  const ExternalIntegrationsTableData({
    required this.id,
    required this.userId,
    required this.platformType,
    this.externalId,
    required this.integrationStatus,
    required this.connectedAt,
    this.lastSyncAt,
    this.accessToken,
    this.refreshToken,
    this.integrationDataJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['platform_type'] = Variable<String>(platformType);
    if (!nullToAbsent || externalId != null) {
      map['external_id'] = Variable<String>(externalId);
    }
    map['integration_status'] = Variable<String>(integrationStatus);
    map['connected_at'] = Variable<DateTime>(connectedAt);
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt);
    }
    if (!nullToAbsent || accessToken != null) {
      map['access_token'] = Variable<String>(accessToken);
    }
    if (!nullToAbsent || refreshToken != null) {
      map['refresh_token'] = Variable<String>(refreshToken);
    }
    if (!nullToAbsent || integrationDataJson != null) {
      map['integration_data_json'] = Variable<String>(integrationDataJson);
    }
    return map;
  }

  ExternalIntegrationsTableCompanion toCompanion(bool nullToAbsent) {
    return ExternalIntegrationsTableCompanion(
      id: Value(id),
      userId: Value(userId),
      platformType: Value(platformType),
      externalId:
          externalId == null && nullToAbsent
              ? const Value.absent()
              : Value(externalId),
      integrationStatus: Value(integrationStatus),
      connectedAt: Value(connectedAt),
      lastSyncAt:
          lastSyncAt == null && nullToAbsent
              ? const Value.absent()
              : Value(lastSyncAt),
      accessToken:
          accessToken == null && nullToAbsent
              ? const Value.absent()
              : Value(accessToken),
      refreshToken:
          refreshToken == null && nullToAbsent
              ? const Value.absent()
              : Value(refreshToken),
      integrationDataJson:
          integrationDataJson == null && nullToAbsent
              ? const Value.absent()
              : Value(integrationDataJson),
    );
  }

  factory ExternalIntegrationsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExternalIntegrationsTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      platformType: serializer.fromJson<String>(json['platformType']),
      externalId: serializer.fromJson<String?>(json['externalId']),
      integrationStatus: serializer.fromJson<String>(json['integrationStatus']),
      connectedAt: serializer.fromJson<DateTime>(json['connectedAt']),
      lastSyncAt: serializer.fromJson<DateTime?>(json['lastSyncAt']),
      accessToken: serializer.fromJson<String?>(json['accessToken']),
      refreshToken: serializer.fromJson<String?>(json['refreshToken']),
      integrationDataJson: serializer.fromJson<String?>(
        json['integrationDataJson'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'platformType': serializer.toJson<String>(platformType),
      'externalId': serializer.toJson<String?>(externalId),
      'integrationStatus': serializer.toJson<String>(integrationStatus),
      'connectedAt': serializer.toJson<DateTime>(connectedAt),
      'lastSyncAt': serializer.toJson<DateTime?>(lastSyncAt),
      'accessToken': serializer.toJson<String?>(accessToken),
      'refreshToken': serializer.toJson<String?>(refreshToken),
      'integrationDataJson': serializer.toJson<String?>(integrationDataJson),
    };
  }

  ExternalIntegrationsTableData copyWith({
    String? id,
    String? userId,
    String? platformType,
    Value<String?> externalId = const Value.absent(),
    String? integrationStatus,
    DateTime? connectedAt,
    Value<DateTime?> lastSyncAt = const Value.absent(),
    Value<String?> accessToken = const Value.absent(),
    Value<String?> refreshToken = const Value.absent(),
    Value<String?> integrationDataJson = const Value.absent(),
  }) => ExternalIntegrationsTableData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    platformType: platformType ?? this.platformType,
    externalId: externalId.present ? externalId.value : this.externalId,
    integrationStatus: integrationStatus ?? this.integrationStatus,
    connectedAt: connectedAt ?? this.connectedAt,
    lastSyncAt: lastSyncAt.present ? lastSyncAt.value : this.lastSyncAt,
    accessToken: accessToken.present ? accessToken.value : this.accessToken,
    refreshToken: refreshToken.present ? refreshToken.value : this.refreshToken,
    integrationDataJson:
        integrationDataJson.present
            ? integrationDataJson.value
            : this.integrationDataJson,
  );
  ExternalIntegrationsTableData copyWithCompanion(
    ExternalIntegrationsTableCompanion data,
  ) {
    return ExternalIntegrationsTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      platformType:
          data.platformType.present
              ? data.platformType.value
              : this.platformType,
      externalId:
          data.externalId.present ? data.externalId.value : this.externalId,
      integrationStatus:
          data.integrationStatus.present
              ? data.integrationStatus.value
              : this.integrationStatus,
      connectedAt:
          data.connectedAt.present ? data.connectedAt.value : this.connectedAt,
      lastSyncAt:
          data.lastSyncAt.present ? data.lastSyncAt.value : this.lastSyncAt,
      accessToken:
          data.accessToken.present ? data.accessToken.value : this.accessToken,
      refreshToken:
          data.refreshToken.present
              ? data.refreshToken.value
              : this.refreshToken,
      integrationDataJson:
          data.integrationDataJson.present
              ? data.integrationDataJson.value
              : this.integrationDataJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExternalIntegrationsTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('platformType: $platformType, ')
          ..write('externalId: $externalId, ')
          ..write('integrationStatus: $integrationStatus, ')
          ..write('connectedAt: $connectedAt, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('accessToken: $accessToken, ')
          ..write('refreshToken: $refreshToken, ')
          ..write('integrationDataJson: $integrationDataJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    platformType,
    externalId,
    integrationStatus,
    connectedAt,
    lastSyncAt,
    accessToken,
    refreshToken,
    integrationDataJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExternalIntegrationsTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.platformType == this.platformType &&
          other.externalId == this.externalId &&
          other.integrationStatus == this.integrationStatus &&
          other.connectedAt == this.connectedAt &&
          other.lastSyncAt == this.lastSyncAt &&
          other.accessToken == this.accessToken &&
          other.refreshToken == this.refreshToken &&
          other.integrationDataJson == this.integrationDataJson);
}

class ExternalIntegrationsTableCompanion
    extends UpdateCompanion<ExternalIntegrationsTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> platformType;
  final Value<String?> externalId;
  final Value<String> integrationStatus;
  final Value<DateTime> connectedAt;
  final Value<DateTime?> lastSyncAt;
  final Value<String?> accessToken;
  final Value<String?> refreshToken;
  final Value<String?> integrationDataJson;
  final Value<int> rowid;
  const ExternalIntegrationsTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.platformType = const Value.absent(),
    this.externalId = const Value.absent(),
    this.integrationStatus = const Value.absent(),
    this.connectedAt = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.accessToken = const Value.absent(),
    this.refreshToken = const Value.absent(),
    this.integrationDataJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExternalIntegrationsTableCompanion.insert({
    required String id,
    required String userId,
    required String platformType,
    this.externalId = const Value.absent(),
    required String integrationStatus,
    required DateTime connectedAt,
    this.lastSyncAt = const Value.absent(),
    this.accessToken = const Value.absent(),
    this.refreshToken = const Value.absent(),
    this.integrationDataJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       platformType = Value(platformType),
       integrationStatus = Value(integrationStatus),
       connectedAt = Value(connectedAt);
  static Insertable<ExternalIntegrationsTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? platformType,
    Expression<String>? externalId,
    Expression<String>? integrationStatus,
    Expression<DateTime>? connectedAt,
    Expression<DateTime>? lastSyncAt,
    Expression<String>? accessToken,
    Expression<String>? refreshToken,
    Expression<String>? integrationDataJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (platformType != null) 'platform_type': platformType,
      if (externalId != null) 'external_id': externalId,
      if (integrationStatus != null) 'integration_status': integrationStatus,
      if (connectedAt != null) 'connected_at': connectedAt,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
      if (accessToken != null) 'access_token': accessToken,
      if (refreshToken != null) 'refresh_token': refreshToken,
      if (integrationDataJson != null)
        'integration_data_json': integrationDataJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExternalIntegrationsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? platformType,
    Value<String?>? externalId,
    Value<String>? integrationStatus,
    Value<DateTime>? connectedAt,
    Value<DateTime?>? lastSyncAt,
    Value<String?>? accessToken,
    Value<String?>? refreshToken,
    Value<String?>? integrationDataJson,
    Value<int>? rowid,
  }) {
    return ExternalIntegrationsTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      platformType: platformType ?? this.platformType,
      externalId: externalId ?? this.externalId,
      integrationStatus: integrationStatus ?? this.integrationStatus,
      connectedAt: connectedAt ?? this.connectedAt,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      integrationDataJson: integrationDataJson ?? this.integrationDataJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (platformType.present) {
      map['platform_type'] = Variable<String>(platformType.value);
    }
    if (externalId.present) {
      map['external_id'] = Variable<String>(externalId.value);
    }
    if (integrationStatus.present) {
      map['integration_status'] = Variable<String>(integrationStatus.value);
    }
    if (connectedAt.present) {
      map['connected_at'] = Variable<DateTime>(connectedAt.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt.value);
    }
    if (accessToken.present) {
      map['access_token'] = Variable<String>(accessToken.value);
    }
    if (refreshToken.present) {
      map['refresh_token'] = Variable<String>(refreshToken.value);
    }
    if (integrationDataJson.present) {
      map['integration_data_json'] = Variable<String>(
        integrationDataJson.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExternalIntegrationsTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('platformType: $platformType, ')
          ..write('externalId: $externalId, ')
          ..write('integrationStatus: $integrationStatus, ')
          ..write('connectedAt: $connectedAt, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('accessToken: $accessToken, ')
          ..write('refreshToken: $refreshToken, ')
          ..write('integrationDataJson: $integrationDataJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncStatusTableTable extends SyncStatusTable
    with TableInfo<$SyncStatusTableTable, SyncStatusTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncStatusTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 36,
      maxTextLength: 36,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES user_profiles_table (id)',
    ),
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetPlatformMeta = const VerificationMeta(
    'targetPlatform',
  );
  @override
  late final GeneratedColumn<String> targetPlatform = GeneratedColumn<String>(
    'target_platform',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastAttemptAtMeta = const VerificationMeta(
    'lastAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastAttemptAt =
      GeneratedColumn<DateTime>(
        'last_attempt_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _errorMessageMeta = const VerificationMeta(
    'errorMessage',
  );
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
    'error_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    entityType,
    entityId,
    targetPlatform,
    syncStatus,
    lastAttemptAt,
    retryCount,
    errorMessage,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_status_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncStatusTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('target_platform')) {
      context.handle(
        _targetPlatformMeta,
        targetPlatform.isAcceptableOrUnknown(
          data['target_platform']!,
          _targetPlatformMeta,
        ),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_syncStatusMeta);
    }
    if (data.containsKey('last_attempt_at')) {
      context.handle(
        _lastAttemptAtMeta,
        lastAttemptAt.isAcceptableOrUnknown(
          data['last_attempt_at']!,
          _lastAttemptAtMeta,
        ),
      );
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('error_message')) {
      context.handle(
        _errorMessageMeta,
        errorMessage.isAcceptableOrUnknown(
          data['error_message']!,
          _errorMessageMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncStatusTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncStatusTableData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      userId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}user_id'],
          )!,
      entityType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}entity_type'],
          )!,
      entityId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}entity_id'],
          )!,
      targetPlatform: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_platform'],
      ),
      syncStatus:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}sync_status'],
          )!,
      lastAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_attempt_at'],
      ),
      retryCount:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}retry_count'],
          )!,
      errorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_message'],
      ),
    );
  }

  @override
  $SyncStatusTableTable createAlias(String alias) {
    return $SyncStatusTableTable(attachedDatabase, alias);
  }
}

class SyncStatusTableData extends DataClass
    implements Insertable<SyncStatusTableData> {
  final String id;
  final String userId;
  final String entityType;
  final String entityId;
  final String? targetPlatform;
  final String syncStatus;
  final DateTime? lastAttemptAt;
  final int retryCount;
  final String? errorMessage;
  const SyncStatusTableData({
    required this.id,
    required this.userId,
    required this.entityType,
    required this.entityId,
    this.targetPlatform,
    required this.syncStatus,
    this.lastAttemptAt,
    required this.retryCount,
    this.errorMessage,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    if (!nullToAbsent || targetPlatform != null) {
      map['target_platform'] = Variable<String>(targetPlatform);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || lastAttemptAt != null) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt);
    }
    map['retry_count'] = Variable<int>(retryCount);
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    return map;
  }

  SyncStatusTableCompanion toCompanion(bool nullToAbsent) {
    return SyncStatusTableCompanion(
      id: Value(id),
      userId: Value(userId),
      entityType: Value(entityType),
      entityId: Value(entityId),
      targetPlatform:
          targetPlatform == null && nullToAbsent
              ? const Value.absent()
              : Value(targetPlatform),
      syncStatus: Value(syncStatus),
      lastAttemptAt:
          lastAttemptAt == null && nullToAbsent
              ? const Value.absent()
              : Value(lastAttemptAt),
      retryCount: Value(retryCount),
      errorMessage:
          errorMessage == null && nullToAbsent
              ? const Value.absent()
              : Value(errorMessage),
    );
  }

  factory SyncStatusTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncStatusTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      targetPlatform: serializer.fromJson<String?>(json['targetPlatform']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      lastAttemptAt: serializer.fromJson<DateTime?>(json['lastAttemptAt']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'targetPlatform': serializer.toJson<String?>(targetPlatform),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'lastAttemptAt': serializer.toJson<DateTime?>(lastAttemptAt),
      'retryCount': serializer.toJson<int>(retryCount),
      'errorMessage': serializer.toJson<String?>(errorMessage),
    };
  }

  SyncStatusTableData copyWith({
    String? id,
    String? userId,
    String? entityType,
    String? entityId,
    Value<String?> targetPlatform = const Value.absent(),
    String? syncStatus,
    Value<DateTime?> lastAttemptAt = const Value.absent(),
    int? retryCount,
    Value<String?> errorMessage = const Value.absent(),
  }) => SyncStatusTableData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    targetPlatform:
        targetPlatform.present ? targetPlatform.value : this.targetPlatform,
    syncStatus: syncStatus ?? this.syncStatus,
    lastAttemptAt:
        lastAttemptAt.present ? lastAttemptAt.value : this.lastAttemptAt,
    retryCount: retryCount ?? this.retryCount,
    errorMessage: errorMessage.present ? errorMessage.value : this.errorMessage,
  );
  SyncStatusTableData copyWithCompanion(SyncStatusTableCompanion data) {
    return SyncStatusTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      targetPlatform:
          data.targetPlatform.present
              ? data.targetPlatform.value
              : this.targetPlatform,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      lastAttemptAt:
          data.lastAttemptAt.present
              ? data.lastAttemptAt.value
              : this.lastAttemptAt,
      retryCount:
          data.retryCount.present ? data.retryCount.value : this.retryCount,
      errorMessage:
          data.errorMessage.present
              ? data.errorMessage.value
              : this.errorMessage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncStatusTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('targetPlatform: $targetPlatform, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastAttemptAt: $lastAttemptAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('errorMessage: $errorMessage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    entityType,
    entityId,
    targetPlatform,
    syncStatus,
    lastAttemptAt,
    retryCount,
    errorMessage,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncStatusTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.targetPlatform == this.targetPlatform &&
          other.syncStatus == this.syncStatus &&
          other.lastAttemptAt == this.lastAttemptAt &&
          other.retryCount == this.retryCount &&
          other.errorMessage == this.errorMessage);
}

class SyncStatusTableCompanion extends UpdateCompanion<SyncStatusTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String?> targetPlatform;
  final Value<String> syncStatus;
  final Value<DateTime?> lastAttemptAt;
  final Value<int> retryCount;
  final Value<String?> errorMessage;
  final Value<int> rowid;
  const SyncStatusTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.targetPlatform = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastAttemptAt = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncStatusTableCompanion.insert({
    required String id,
    required String userId,
    required String entityType,
    required String entityId,
    this.targetPlatform = const Value.absent(),
    required String syncStatus,
    this.lastAttemptAt = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       entityType = Value(entityType),
       entityId = Value(entityId),
       syncStatus = Value(syncStatus);
  static Insertable<SyncStatusTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? targetPlatform,
    Expression<String>? syncStatus,
    Expression<DateTime>? lastAttemptAt,
    Expression<int>? retryCount,
    Expression<String>? errorMessage,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (targetPlatform != null) 'target_platform': targetPlatform,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (lastAttemptAt != null) 'last_attempt_at': lastAttemptAt,
      if (retryCount != null) 'retry_count': retryCount,
      if (errorMessage != null) 'error_message': errorMessage,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncStatusTableCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String?>? targetPlatform,
    Value<String>? syncStatus,
    Value<DateTime?>? lastAttemptAt,
    Value<int>? retryCount,
    Value<String?>? errorMessage,
    Value<int>? rowid,
  }) {
    return SyncStatusTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      targetPlatform: targetPlatform ?? this.targetPlatform,
      syncStatus: syncStatus ?? this.syncStatus,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
      retryCount: retryCount ?? this.retryCount,
      errorMessage: errorMessage ?? this.errorMessage,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (targetPlatform.present) {
      map['target_platform'] = Variable<String>(targetPlatform.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (lastAttemptAt.present) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncStatusTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('targetPlatform: $targetPlatform, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastAttemptAt: $lastAttemptAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TripsTableTable tripsTable = $TripsTableTable(this);
  late final $TripDataPointsTableTable tripDataPointsTable =
      $TripDataPointsTableTable(this);
  late final $DrivingEventsTableTable drivingEventsTable =
      $DrivingEventsTableTable(this);
  late final $UserProfilesTableTable userProfilesTable =
      $UserProfilesTableTable(this);
  late final $PerformanceMetricsTableTable performanceMetricsTable =
      $PerformanceMetricsTableTable(this);
  late final $BadgesTableTable badgesTable = $BadgesTableTable(this);
  late final $DataPrivacySettingsTableTable dataPrivacySettingsTable =
      $DataPrivacySettingsTableTable(this);
  late final $SocialConnectionsTableTable socialConnectionsTable =
      $SocialConnectionsTableTable(this);
  late final $SocialInteractionsTableTable socialInteractionsTable =
      $SocialInteractionsTableTable(this);
  late final $SharedContentTableTable sharedContentTable =
      $SharedContentTableTable(this);
  late final $UserPreferencesTableTable userPreferencesTable =
      $UserPreferencesTableTable(this);
  late final $FeedbackEffectivenessTableTable feedbackEffectivenessTable =
      $FeedbackEffectivenessTableTable(this);
  late final $ChallengesTableTable challengesTable = $ChallengesTableTable(
    this,
  );
  late final $UserChallengesTableTable userChallengesTable =
      $UserChallengesTableTable(this);
  late final $StreaksTableTable streaksTable = $StreaksTableTable(this);
  late final $LeaderboardEntriesTableTable leaderboardEntriesTable =
      $LeaderboardEntriesTableTable(this);
  late final $ExternalIntegrationsTableTable externalIntegrationsTable =
      $ExternalIntegrationsTableTable(this);
  late final $SyncStatusTableTable syncStatusTable = $SyncStatusTableTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    tripsTable,
    tripDataPointsTable,
    drivingEventsTable,
    userProfilesTable,
    performanceMetricsTable,
    badgesTable,
    dataPrivacySettingsTable,
    socialConnectionsTable,
    socialInteractionsTable,
    sharedContentTable,
    userPreferencesTable,
    feedbackEffectivenessTable,
    challengesTable,
    userChallengesTable,
    streaksTable,
    leaderboardEntriesTable,
    externalIntegrationsTable,
    syncStatusTable,
  ];
}

typedef $$TripsTableTableCreateCompanionBuilder =
    TripsTableCompanion Function({
      required String id,
      required DateTime startTime,
      Value<DateTime?> endTime,
      Value<double?> distanceKm,
      Value<double?> averageSpeedKmh,
      Value<double?> maxSpeedKmh,
      Value<double?> fuelUsedL,
      Value<int?> idlingEvents,
      Value<int?> aggressiveAccelerationEvents,
      Value<int?> hardBrakingEvents,
      Value<int?> excessiveSpeedEvents,
      Value<int?> stopEvents,
      Value<double?> averageRPM,
      Value<bool> isCompleted,
      Value<int?> ecoScore,
      Value<String?> routeDataJson,
      Value<String?> userId,
      Value<int> rowid,
    });
typedef $$TripsTableTableUpdateCompanionBuilder =
    TripsTableCompanion Function({
      Value<String> id,
      Value<DateTime> startTime,
      Value<DateTime?> endTime,
      Value<double?> distanceKm,
      Value<double?> averageSpeedKmh,
      Value<double?> maxSpeedKmh,
      Value<double?> fuelUsedL,
      Value<int?> idlingEvents,
      Value<int?> aggressiveAccelerationEvents,
      Value<int?> hardBrakingEvents,
      Value<int?> excessiveSpeedEvents,
      Value<int?> stopEvents,
      Value<double?> averageRPM,
      Value<bool> isCompleted,
      Value<int?> ecoScore,
      Value<String?> routeDataJson,
      Value<String?> userId,
      Value<int> rowid,
    });

final class $$TripsTableTableReferences
    extends BaseReferences<_$AppDatabase, $TripsTableTable, TripsTableData> {
  $$TripsTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $TripDataPointsTableTable,
    List<TripDataPointsTableData>
  >
  _tripDataPointsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.tripDataPointsTable,
        aliasName: $_aliasNameGenerator(
          db.tripsTable.id,
          db.tripDataPointsTable.tripId,
        ),
      );

  $$TripDataPointsTableTableProcessedTableManager get tripDataPointsTableRefs {
    final manager = $$TripDataPointsTableTableTableManager(
      $_db,
      $_db.tripDataPointsTable,
    ).filter((f) => f.tripId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _tripDataPointsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $DrivingEventsTableTable,
    List<DrivingEventsTableData>
  >
  _drivingEventsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.drivingEventsTable,
        aliasName: $_aliasNameGenerator(
          db.tripsTable.id,
          db.drivingEventsTable.tripId,
        ),
      );

  $$DrivingEventsTableTableProcessedTableManager get drivingEventsTableRefs {
    final manager = $$DrivingEventsTableTableTableManager(
      $_db,
      $_db.drivingEventsTable,
    ).filter((f) => f.tripId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _drivingEventsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TripsTableTableFilterComposer
    extends Composer<_$AppDatabase, $TripsTableTable> {
  $$TripsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distanceKm => $composableBuilder(
    column: $table.distanceKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get averageSpeedKmh => $composableBuilder(
    column: $table.averageSpeedKmh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get maxSpeedKmh => $composableBuilder(
    column: $table.maxSpeedKmh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fuelUsedL => $composableBuilder(
    column: $table.fuelUsedL,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get idlingEvents => $composableBuilder(
    column: $table.idlingEvents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get aggressiveAccelerationEvents => $composableBuilder(
    column: $table.aggressiveAccelerationEvents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hardBrakingEvents => $composableBuilder(
    column: $table.hardBrakingEvents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get excessiveSpeedEvents => $composableBuilder(
    column: $table.excessiveSpeedEvents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stopEvents => $composableBuilder(
    column: $table.stopEvents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get averageRPM => $composableBuilder(
    column: $table.averageRPM,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ecoScore => $composableBuilder(
    column: $table.ecoScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get routeDataJson => $composableBuilder(
    column: $table.routeDataJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> tripDataPointsTableRefs(
    Expression<bool> Function($$TripDataPointsTableTableFilterComposer f) f,
  ) {
    final $$TripDataPointsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tripDataPointsTable,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripDataPointsTableTableFilterComposer(
            $db: $db,
            $table: $db.tripDataPointsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> drivingEventsTableRefs(
    Expression<bool> Function($$DrivingEventsTableTableFilterComposer f) f,
  ) {
    final $$DrivingEventsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.drivingEventsTable,
      getReferencedColumn: (t) => t.tripId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DrivingEventsTableTableFilterComposer(
            $db: $db,
            $table: $db.drivingEventsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TripsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TripsTableTable> {
  $$TripsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distanceKm => $composableBuilder(
    column: $table.distanceKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get averageSpeedKmh => $composableBuilder(
    column: $table.averageSpeedKmh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get maxSpeedKmh => $composableBuilder(
    column: $table.maxSpeedKmh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fuelUsedL => $composableBuilder(
    column: $table.fuelUsedL,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get idlingEvents => $composableBuilder(
    column: $table.idlingEvents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get aggressiveAccelerationEvents => $composableBuilder(
    column: $table.aggressiveAccelerationEvents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hardBrakingEvents => $composableBuilder(
    column: $table.hardBrakingEvents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get excessiveSpeedEvents => $composableBuilder(
    column: $table.excessiveSpeedEvents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stopEvents => $composableBuilder(
    column: $table.stopEvents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get averageRPM => $composableBuilder(
    column: $table.averageRPM,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ecoScore => $composableBuilder(
    column: $table.ecoScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get routeDataJson => $composableBuilder(
    column: $table.routeDataJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TripsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TripsTableTable> {
  $$TripsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<double> get distanceKm => $composableBuilder(
    column: $table.distanceKm,
    builder: (column) => column,
  );

  GeneratedColumn<double> get averageSpeedKmh => $composableBuilder(
    column: $table.averageSpeedKmh,
    builder: (column) => column,
  );

  GeneratedColumn<double> get maxSpeedKmh => $composableBuilder(
    column: $table.maxSpeedKmh,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fuelUsedL =>
      $composableBuilder(column: $table.fuelUsedL, builder: (column) => column);

  GeneratedColumn<int> get idlingEvents => $composableBuilder(
    column: $table.idlingEvents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get aggressiveAccelerationEvents => $composableBuilder(
    column: $table.aggressiveAccelerationEvents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hardBrakingEvents => $composableBuilder(
    column: $table.hardBrakingEvents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get excessiveSpeedEvents => $composableBuilder(
    column: $table.excessiveSpeedEvents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get stopEvents => $composableBuilder(
    column: $table.stopEvents,
    builder: (column) => column,
  );

  GeneratedColumn<double> get averageRPM => $composableBuilder(
    column: $table.averageRPM,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ecoScore =>
      $composableBuilder(column: $table.ecoScore, builder: (column) => column);

  GeneratedColumn<String> get routeDataJson => $composableBuilder(
    column: $table.routeDataJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  Expression<T> tripDataPointsTableRefs<T extends Object>(
    Expression<T> Function($$TripDataPointsTableTableAnnotationComposer a) f,
  ) {
    final $$TripDataPointsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.tripDataPointsTable,
          getReferencedColumn: (t) => t.tripId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TripDataPointsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.tripDataPointsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> drivingEventsTableRefs<T extends Object>(
    Expression<T> Function($$DrivingEventsTableTableAnnotationComposer a) f,
  ) {
    final $$DrivingEventsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.drivingEventsTable,
          getReferencedColumn: (t) => t.tripId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DrivingEventsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.drivingEventsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TripsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TripsTableTable,
          TripsTableData,
          $$TripsTableTableFilterComposer,
          $$TripsTableTableOrderingComposer,
          $$TripsTableTableAnnotationComposer,
          $$TripsTableTableCreateCompanionBuilder,
          $$TripsTableTableUpdateCompanionBuilder,
          (TripsTableData, $$TripsTableTableReferences),
          TripsTableData,
          PrefetchHooks Function({
            bool tripDataPointsTableRefs,
            bool drivingEventsTableRefs,
          })
        > {
  $$TripsTableTableTableManager(_$AppDatabase db, $TripsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$TripsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$TripsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$TripsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> startTime = const Value.absent(),
                Value<DateTime?> endTime = const Value.absent(),
                Value<double?> distanceKm = const Value.absent(),
                Value<double?> averageSpeedKmh = const Value.absent(),
                Value<double?> maxSpeedKmh = const Value.absent(),
                Value<double?> fuelUsedL = const Value.absent(),
                Value<int?> idlingEvents = const Value.absent(),
                Value<int?> aggressiveAccelerationEvents = const Value.absent(),
                Value<int?> hardBrakingEvents = const Value.absent(),
                Value<int?> excessiveSpeedEvents = const Value.absent(),
                Value<int?> stopEvents = const Value.absent(),
                Value<double?> averageRPM = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<int?> ecoScore = const Value.absent(),
                Value<String?> routeDataJson = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TripsTableCompanion(
                id: id,
                startTime: startTime,
                endTime: endTime,
                distanceKm: distanceKm,
                averageSpeedKmh: averageSpeedKmh,
                maxSpeedKmh: maxSpeedKmh,
                fuelUsedL: fuelUsedL,
                idlingEvents: idlingEvents,
                aggressiveAccelerationEvents: aggressiveAccelerationEvents,
                hardBrakingEvents: hardBrakingEvents,
                excessiveSpeedEvents: excessiveSpeedEvents,
                stopEvents: stopEvents,
                averageRPM: averageRPM,
                isCompleted: isCompleted,
                ecoScore: ecoScore,
                routeDataJson: routeDataJson,
                userId: userId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime startTime,
                Value<DateTime?> endTime = const Value.absent(),
                Value<double?> distanceKm = const Value.absent(),
                Value<double?> averageSpeedKmh = const Value.absent(),
                Value<double?> maxSpeedKmh = const Value.absent(),
                Value<double?> fuelUsedL = const Value.absent(),
                Value<int?> idlingEvents = const Value.absent(),
                Value<int?> aggressiveAccelerationEvents = const Value.absent(),
                Value<int?> hardBrakingEvents = const Value.absent(),
                Value<int?> excessiveSpeedEvents = const Value.absent(),
                Value<int?> stopEvents = const Value.absent(),
                Value<double?> averageRPM = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<int?> ecoScore = const Value.absent(),
                Value<String?> routeDataJson = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TripsTableCompanion.insert(
                id: id,
                startTime: startTime,
                endTime: endTime,
                distanceKm: distanceKm,
                averageSpeedKmh: averageSpeedKmh,
                maxSpeedKmh: maxSpeedKmh,
                fuelUsedL: fuelUsedL,
                idlingEvents: idlingEvents,
                aggressiveAccelerationEvents: aggressiveAccelerationEvents,
                hardBrakingEvents: hardBrakingEvents,
                excessiveSpeedEvents: excessiveSpeedEvents,
                stopEvents: stopEvents,
                averageRPM: averageRPM,
                isCompleted: isCompleted,
                ecoScore: ecoScore,
                routeDataJson: routeDataJson,
                userId: userId,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$TripsTableTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            tripDataPointsTableRefs = false,
            drivingEventsTableRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (tripDataPointsTableRefs) db.tripDataPointsTable,
                if (drivingEventsTableRefs) db.drivingEventsTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (tripDataPointsTableRefs)
                    await $_getPrefetchedData<
                      TripsTableData,
                      $TripsTableTable,
                      TripDataPointsTableData
                    >(
                      currentTable: table,
                      referencedTable: $$TripsTableTableReferences
                          ._tripDataPointsTableRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$TripsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).tripDataPointsTableRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.tripId == item.id),
                      typedResults: items,
                    ),
                  if (drivingEventsTableRefs)
                    await $_getPrefetchedData<
                      TripsTableData,
                      $TripsTableTable,
                      DrivingEventsTableData
                    >(
                      currentTable: table,
                      referencedTable: $$TripsTableTableReferences
                          ._drivingEventsTableRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$TripsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).drivingEventsTableRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.tripId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TripsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TripsTableTable,
      TripsTableData,
      $$TripsTableTableFilterComposer,
      $$TripsTableTableOrderingComposer,
      $$TripsTableTableAnnotationComposer,
      $$TripsTableTableCreateCompanionBuilder,
      $$TripsTableTableUpdateCompanionBuilder,
      (TripsTableData, $$TripsTableTableReferences),
      TripsTableData,
      PrefetchHooks Function({
        bool tripDataPointsTableRefs,
        bool drivingEventsTableRefs,
      })
    >;
typedef $$TripDataPointsTableTableCreateCompanionBuilder =
    TripDataPointsTableCompanion Function({
      Value<int> id,
      required String tripId,
      required DateTime timestamp,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<double?> speed,
      Value<double?> acceleration,
      Value<double?> rpm,
      Value<double?> throttlePosition,
      Value<double?> engineLoad,
      Value<double?> fuelRate,
      Value<String?> rawDataJson,
    });
typedef $$TripDataPointsTableTableUpdateCompanionBuilder =
    TripDataPointsTableCompanion Function({
      Value<int> id,
      Value<String> tripId,
      Value<DateTime> timestamp,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<double?> speed,
      Value<double?> acceleration,
      Value<double?> rpm,
      Value<double?> throttlePosition,
      Value<double?> engineLoad,
      Value<double?> fuelRate,
      Value<String?> rawDataJson,
    });

final class $$TripDataPointsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TripDataPointsTableTable,
          TripDataPointsTableData
        > {
  $$TripDataPointsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TripsTableTable _tripIdTable(_$AppDatabase db) =>
      db.tripsTable.createAlias(
        $_aliasNameGenerator(db.tripDataPointsTable.tripId, db.tripsTable.id),
      );

  $$TripsTableTableProcessedTableManager get tripId {
    final $_column = $_itemColumn<String>('trip_id')!;

    final manager = $$TripsTableTableTableManager(
      $_db,
      $_db.tripsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tripIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TripDataPointsTableTableFilterComposer
    extends Composer<_$AppDatabase, $TripDataPointsTableTable> {
  $$TripDataPointsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get speed => $composableBuilder(
    column: $table.speed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get acceleration => $composableBuilder(
    column: $table.acceleration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rpm => $composableBuilder(
    column: $table.rpm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get throttlePosition => $composableBuilder(
    column: $table.throttlePosition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get engineLoad => $composableBuilder(
    column: $table.engineLoad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fuelRate => $composableBuilder(
    column: $table.fuelRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawDataJson => $composableBuilder(
    column: $table.rawDataJson,
    builder: (column) => ColumnFilters(column),
  );

  $$TripsTableTableFilterComposer get tripId {
    final $$TripsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.tripsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableTableFilterComposer(
            $db: $db,
            $table: $db.tripsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TripDataPointsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TripDataPointsTableTable> {
  $$TripDataPointsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get speed => $composableBuilder(
    column: $table.speed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get acceleration => $composableBuilder(
    column: $table.acceleration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rpm => $composableBuilder(
    column: $table.rpm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get throttlePosition => $composableBuilder(
    column: $table.throttlePosition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get engineLoad => $composableBuilder(
    column: $table.engineLoad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fuelRate => $composableBuilder(
    column: $table.fuelRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawDataJson => $composableBuilder(
    column: $table.rawDataJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$TripsTableTableOrderingComposer get tripId {
    final $$TripsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.tripsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableTableOrderingComposer(
            $db: $db,
            $table: $db.tripsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TripDataPointsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TripDataPointsTableTable> {
  $$TripDataPointsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<double> get speed =>
      $composableBuilder(column: $table.speed, builder: (column) => column);

  GeneratedColumn<double> get acceleration => $composableBuilder(
    column: $table.acceleration,
    builder: (column) => column,
  );

  GeneratedColumn<double> get rpm =>
      $composableBuilder(column: $table.rpm, builder: (column) => column);

  GeneratedColumn<double> get throttlePosition => $composableBuilder(
    column: $table.throttlePosition,
    builder: (column) => column,
  );

  GeneratedColumn<double> get engineLoad => $composableBuilder(
    column: $table.engineLoad,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fuelRate =>
      $composableBuilder(column: $table.fuelRate, builder: (column) => column);

  GeneratedColumn<String> get rawDataJson => $composableBuilder(
    column: $table.rawDataJson,
    builder: (column) => column,
  );

  $$TripsTableTableAnnotationComposer get tripId {
    final $$TripsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.tripsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.tripsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TripDataPointsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TripDataPointsTableTable,
          TripDataPointsTableData,
          $$TripDataPointsTableTableFilterComposer,
          $$TripDataPointsTableTableOrderingComposer,
          $$TripDataPointsTableTableAnnotationComposer,
          $$TripDataPointsTableTableCreateCompanionBuilder,
          $$TripDataPointsTableTableUpdateCompanionBuilder,
          (TripDataPointsTableData, $$TripDataPointsTableTableReferences),
          TripDataPointsTableData,
          PrefetchHooks Function({bool tripId})
        > {
  $$TripDataPointsTableTableTableManager(
    _$AppDatabase db,
    $TripDataPointsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$TripDataPointsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$TripDataPointsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$TripDataPointsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> tripId = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<double?> speed = const Value.absent(),
                Value<double?> acceleration = const Value.absent(),
                Value<double?> rpm = const Value.absent(),
                Value<double?> throttlePosition = const Value.absent(),
                Value<double?> engineLoad = const Value.absent(),
                Value<double?> fuelRate = const Value.absent(),
                Value<String?> rawDataJson = const Value.absent(),
              }) => TripDataPointsTableCompanion(
                id: id,
                tripId: tripId,
                timestamp: timestamp,
                latitude: latitude,
                longitude: longitude,
                speed: speed,
                acceleration: acceleration,
                rpm: rpm,
                throttlePosition: throttlePosition,
                engineLoad: engineLoad,
                fuelRate: fuelRate,
                rawDataJson: rawDataJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String tripId,
                required DateTime timestamp,
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<double?> speed = const Value.absent(),
                Value<double?> acceleration = const Value.absent(),
                Value<double?> rpm = const Value.absent(),
                Value<double?> throttlePosition = const Value.absent(),
                Value<double?> engineLoad = const Value.absent(),
                Value<double?> fuelRate = const Value.absent(),
                Value<String?> rawDataJson = const Value.absent(),
              }) => TripDataPointsTableCompanion.insert(
                id: id,
                tripId: tripId,
                timestamp: timestamp,
                latitude: latitude,
                longitude: longitude,
                speed: speed,
                acceleration: acceleration,
                rpm: rpm,
                throttlePosition: throttlePosition,
                engineLoad: engineLoad,
                fuelRate: fuelRate,
                rawDataJson: rawDataJson,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$TripDataPointsTableTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({tripId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (tripId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.tripId,
                            referencedTable:
                                $$TripDataPointsTableTableReferences
                                    ._tripIdTable(db),
                            referencedColumn:
                                $$TripDataPointsTableTableReferences
                                    ._tripIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TripDataPointsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TripDataPointsTableTable,
      TripDataPointsTableData,
      $$TripDataPointsTableTableFilterComposer,
      $$TripDataPointsTableTableOrderingComposer,
      $$TripDataPointsTableTableAnnotationComposer,
      $$TripDataPointsTableTableCreateCompanionBuilder,
      $$TripDataPointsTableTableUpdateCompanionBuilder,
      (TripDataPointsTableData, $$TripDataPointsTableTableReferences),
      TripDataPointsTableData,
      PrefetchHooks Function({bool tripId})
    >;
typedef $$DrivingEventsTableTableCreateCompanionBuilder =
    DrivingEventsTableCompanion Function({
      Value<int> id,
      required String tripId,
      required DateTime timestamp,
      required String eventType,
      Value<double> severity,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<String?> detailsJson,
    });
typedef $$DrivingEventsTableTableUpdateCompanionBuilder =
    DrivingEventsTableCompanion Function({
      Value<int> id,
      Value<String> tripId,
      Value<DateTime> timestamp,
      Value<String> eventType,
      Value<double> severity,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<String?> detailsJson,
    });

final class $$DrivingEventsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $DrivingEventsTableTable,
          DrivingEventsTableData
        > {
  $$DrivingEventsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TripsTableTable _tripIdTable(_$AppDatabase db) =>
      db.tripsTable.createAlias(
        $_aliasNameGenerator(db.drivingEventsTable.tripId, db.tripsTable.id),
      );

  $$TripsTableTableProcessedTableManager get tripId {
    final $_column = $_itemColumn<String>('trip_id')!;

    final manager = $$TripsTableTableTableManager(
      $_db,
      $_db.tripsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tripIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DrivingEventsTableTableFilterComposer
    extends Composer<_$AppDatabase, $DrivingEventsTableTable> {
  $$DrivingEventsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detailsJson => $composableBuilder(
    column: $table.detailsJson,
    builder: (column) => ColumnFilters(column),
  );

  $$TripsTableTableFilterComposer get tripId {
    final $$TripsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.tripsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableTableFilterComposer(
            $db: $db,
            $table: $db.tripsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DrivingEventsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DrivingEventsTableTable> {
  $$DrivingEventsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detailsJson => $composableBuilder(
    column: $table.detailsJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$TripsTableTableOrderingComposer get tripId {
    final $$TripsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.tripsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableTableOrderingComposer(
            $db: $db,
            $table: $db.tripsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DrivingEventsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DrivingEventsTableTable> {
  $$DrivingEventsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<double> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get detailsJson => $composableBuilder(
    column: $table.detailsJson,
    builder: (column) => column,
  );

  $$TripsTableTableAnnotationComposer get tripId {
    final $$TripsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tripId,
      referencedTable: $db.tripsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.tripsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DrivingEventsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DrivingEventsTableTable,
          DrivingEventsTableData,
          $$DrivingEventsTableTableFilterComposer,
          $$DrivingEventsTableTableOrderingComposer,
          $$DrivingEventsTableTableAnnotationComposer,
          $$DrivingEventsTableTableCreateCompanionBuilder,
          $$DrivingEventsTableTableUpdateCompanionBuilder,
          (DrivingEventsTableData, $$DrivingEventsTableTableReferences),
          DrivingEventsTableData,
          PrefetchHooks Function({bool tripId})
        > {
  $$DrivingEventsTableTableTableManager(
    _$AppDatabase db,
    $DrivingEventsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$DrivingEventsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$DrivingEventsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$DrivingEventsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> tripId = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<String> eventType = const Value.absent(),
                Value<double> severity = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<String?> detailsJson = const Value.absent(),
              }) => DrivingEventsTableCompanion(
                id: id,
                tripId: tripId,
                timestamp: timestamp,
                eventType: eventType,
                severity: severity,
                latitude: latitude,
                longitude: longitude,
                detailsJson: detailsJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String tripId,
                required DateTime timestamp,
                required String eventType,
                Value<double> severity = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<String?> detailsJson = const Value.absent(),
              }) => DrivingEventsTableCompanion.insert(
                id: id,
                tripId: tripId,
                timestamp: timestamp,
                eventType: eventType,
                severity: severity,
                latitude: latitude,
                longitude: longitude,
                detailsJson: detailsJson,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$DrivingEventsTableTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({tripId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (tripId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.tripId,
                            referencedTable: $$DrivingEventsTableTableReferences
                                ._tripIdTable(db),
                            referencedColumn:
                                $$DrivingEventsTableTableReferences
                                    ._tripIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DrivingEventsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DrivingEventsTableTable,
      DrivingEventsTableData,
      $$DrivingEventsTableTableFilterComposer,
      $$DrivingEventsTableTableOrderingComposer,
      $$DrivingEventsTableTableAnnotationComposer,
      $$DrivingEventsTableTableCreateCompanionBuilder,
      $$DrivingEventsTableTableUpdateCompanionBuilder,
      (DrivingEventsTableData, $$DrivingEventsTableTableReferences),
      DrivingEventsTableData,
      PrefetchHooks Function({bool tripId})
    >;
typedef $$UserProfilesTableTableCreateCompanionBuilder =
    UserProfilesTableCompanion Function({
      required String id,
      Value<String?> name,
      required DateTime createdAt,
      required DateTime lastUpdatedAt,
      Value<bool> isPublic,
      Value<bool> allowDataUpload,
      Value<String?> preferencesJson,
      Value<int> rowid,
    });
typedef $$UserProfilesTableTableUpdateCompanionBuilder =
    UserProfilesTableCompanion Function({
      Value<String> id,
      Value<String?> name,
      Value<DateTime> createdAt,
      Value<DateTime> lastUpdatedAt,
      Value<bool> isPublic,
      Value<bool> allowDataUpload,
      Value<String?> preferencesJson,
      Value<int> rowid,
    });

final class $$UserProfilesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $UserProfilesTableTable,
          UserProfilesTableData
        > {
  $$UserProfilesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $PerformanceMetricsTableTable,
    List<PerformanceMetricsTableData>
  >
  _performanceMetricsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.performanceMetricsTable,
        aliasName: $_aliasNameGenerator(
          db.userProfilesTable.id,
          db.performanceMetricsTable.userId,
        ),
      );

  $$PerformanceMetricsTableTableProcessedTableManager
  get performanceMetricsTableRefs {
    final manager = $$PerformanceMetricsTableTableTableManager(
      $_db,
      $_db.performanceMetricsTable,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _performanceMetricsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BadgesTableTable, List<BadgesTableData>>
  _badgesTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.badgesTable,
    aliasName: $_aliasNameGenerator(
      db.userProfilesTable.id,
      db.badgesTable.userId,
    ),
  );

  $$BadgesTableTableProcessedTableManager get badgesTableRefs {
    final manager = $$BadgesTableTableTableManager(
      $_db,
      $_db.badgesTable,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_badgesTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $DataPrivacySettingsTableTable,
    List<DataPrivacySettingsTableData>
  >
  _dataPrivacySettingsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.dataPrivacySettingsTable,
        aliasName: $_aliasNameGenerator(
          db.userProfilesTable.id,
          db.dataPrivacySettingsTable.userId,
        ),
      );

  $$DataPrivacySettingsTableTableProcessedTableManager
  get dataPrivacySettingsTableRefs {
    final manager = $$DataPrivacySettingsTableTableTableManager(
      $_db,
      $_db.dataPrivacySettingsTable,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _dataPrivacySettingsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $SocialInteractionsTableTable,
    List<SocialInteractionsTableData>
  >
  _socialInteractionsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.socialInteractionsTable,
        aliasName: $_aliasNameGenerator(
          db.userProfilesTable.id,
          db.socialInteractionsTable.userId,
        ),
      );

  $$SocialInteractionsTableTableProcessedTableManager
  get socialInteractionsTableRefs {
    final manager = $$SocialInteractionsTableTableTableManager(
      $_db,
      $_db.socialInteractionsTable,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _socialInteractionsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $SharedContentTableTable,
    List<SharedContentTableData>
  >
  _sharedContentTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.sharedContentTable,
        aliasName: $_aliasNameGenerator(
          db.userProfilesTable.id,
          db.sharedContentTable.userId,
        ),
      );

  $$SharedContentTableTableProcessedTableManager get sharedContentTableRefs {
    final manager = $$SharedContentTableTableTableManager(
      $_db,
      $_db.sharedContentTable,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _sharedContentTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $UserPreferencesTableTable,
    List<UserPreferencesTableData>
  >
  _userPreferencesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.userPreferencesTable,
        aliasName: $_aliasNameGenerator(
          db.userProfilesTable.id,
          db.userPreferencesTable.userId,
        ),
      );

  $$UserPreferencesTableTableProcessedTableManager
  get userPreferencesTableRefs {
    final manager = $$UserPreferencesTableTableTableManager(
      $_db,
      $_db.userPreferencesTable,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _userPreferencesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $FeedbackEffectivenessTableTable,
    List<FeedbackEffectivenessTableData>
  >
  _feedbackEffectivenessTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.feedbackEffectivenessTable,
        aliasName: $_aliasNameGenerator(
          db.userProfilesTable.id,
          db.feedbackEffectivenessTable.userId,
        ),
      );

  $$FeedbackEffectivenessTableTableProcessedTableManager
  get feedbackEffectivenessTableRefs {
    final manager = $$FeedbackEffectivenessTableTableTableManager(
      $_db,
      $_db.feedbackEffectivenessTable,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _feedbackEffectivenessTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ChallengesTableTable, List<ChallengesTableData>>
  _challengesTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.challengesTable,
    aliasName: $_aliasNameGenerator(
      db.userProfilesTable.id,
      db.challengesTable.creatorId,
    ),
  );

  $$ChallengesTableTableProcessedTableManager get challengesTableRefs {
    final manager = $$ChallengesTableTableTableManager(
      $_db,
      $_db.challengesTable,
    ).filter((f) => f.creatorId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _challengesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $UserChallengesTableTable,
    List<UserChallengesTableData>
  >
  _userChallengesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.userChallengesTable,
        aliasName: $_aliasNameGenerator(
          db.userProfilesTable.id,
          db.userChallengesTable.userId,
        ),
      );

  $$UserChallengesTableTableProcessedTableManager get userChallengesTableRefs {
    final manager = $$UserChallengesTableTableTableManager(
      $_db,
      $_db.userChallengesTable,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _userChallengesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StreaksTableTable, List<StreaksTableData>>
  _streaksTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.streaksTable,
    aliasName: $_aliasNameGenerator(
      db.userProfilesTable.id,
      db.streaksTable.userId,
    ),
  );

  $$StreaksTableTableProcessedTableManager get streaksTableRefs {
    final manager = $$StreaksTableTableTableManager(
      $_db,
      $_db.streaksTable,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_streaksTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $LeaderboardEntriesTableTable,
    List<LeaderboardEntriesTableData>
  >
  _leaderboardEntriesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.leaderboardEntriesTable,
        aliasName: $_aliasNameGenerator(
          db.userProfilesTable.id,
          db.leaderboardEntriesTable.userId,
        ),
      );

  $$LeaderboardEntriesTableTableProcessedTableManager
  get leaderboardEntriesTableRefs {
    final manager = $$LeaderboardEntriesTableTableTableManager(
      $_db,
      $_db.leaderboardEntriesTable,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _leaderboardEntriesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ExternalIntegrationsTableTable,
    List<ExternalIntegrationsTableData>
  >
  _externalIntegrationsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.externalIntegrationsTable,
        aliasName: $_aliasNameGenerator(
          db.userProfilesTable.id,
          db.externalIntegrationsTable.userId,
        ),
      );

  $$ExternalIntegrationsTableTableProcessedTableManager
  get externalIntegrationsTableRefs {
    final manager = $$ExternalIntegrationsTableTableTableManager(
      $_db,
      $_db.externalIntegrationsTable,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _externalIntegrationsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SyncStatusTableTable, List<SyncStatusTableData>>
  _syncStatusTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.syncStatusTable,
    aliasName: $_aliasNameGenerator(
      db.userProfilesTable.id,
      db.syncStatusTable.userId,
    ),
  );

  $$SyncStatusTableTableProcessedTableManager get syncStatusTableRefs {
    final manager = $$SyncStatusTableTableTableManager(
      $_db,
      $_db.syncStatusTable,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _syncStatusTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UserProfilesTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfilesTableTable> {
  $$UserProfilesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUpdatedAt => $composableBuilder(
    column: $table.lastUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPublic => $composableBuilder(
    column: $table.isPublic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get allowDataUpload => $composableBuilder(
    column: $table.allowDataUpload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preferencesJson => $composableBuilder(
    column: $table.preferencesJson,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> performanceMetricsTableRefs(
    Expression<bool> Function($$PerformanceMetricsTableTableFilterComposer f) f,
  ) {
    final $$PerformanceMetricsTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.performanceMetricsTable,
          getReferencedColumn: (t) => t.userId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PerformanceMetricsTableTableFilterComposer(
                $db: $db,
                $table: $db.performanceMetricsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> badgesTableRefs(
    Expression<bool> Function($$BadgesTableTableFilterComposer f) f,
  ) {
    final $$BadgesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.badgesTable,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BadgesTableTableFilterComposer(
            $db: $db,
            $table: $db.badgesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> dataPrivacySettingsTableRefs(
    Expression<bool> Function($$DataPrivacySettingsTableTableFilterComposer f)
    f,
  ) {
    final $$DataPrivacySettingsTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.dataPrivacySettingsTable,
          getReferencedColumn: (t) => t.userId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DataPrivacySettingsTableTableFilterComposer(
                $db: $db,
                $table: $db.dataPrivacySettingsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> socialInteractionsTableRefs(
    Expression<bool> Function($$SocialInteractionsTableTableFilterComposer f) f,
  ) {
    final $$SocialInteractionsTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.socialInteractionsTable,
          getReferencedColumn: (t) => t.userId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SocialInteractionsTableTableFilterComposer(
                $db: $db,
                $table: $db.socialInteractionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> sharedContentTableRefs(
    Expression<bool> Function($$SharedContentTableTableFilterComposer f) f,
  ) {
    final $$SharedContentTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sharedContentTable,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SharedContentTableTableFilterComposer(
            $db: $db,
            $table: $db.sharedContentTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> userPreferencesTableRefs(
    Expression<bool> Function($$UserPreferencesTableTableFilterComposer f) f,
  ) {
    final $$UserPreferencesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userPreferencesTable,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserPreferencesTableTableFilterComposer(
            $db: $db,
            $table: $db.userPreferencesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> feedbackEffectivenessTableRefs(
    Expression<bool> Function($$FeedbackEffectivenessTableTableFilterComposer f)
    f,
  ) {
    final $$FeedbackEffectivenessTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.feedbackEffectivenessTable,
          getReferencedColumn: (t) => t.userId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FeedbackEffectivenessTableTableFilterComposer(
                $db: $db,
                $table: $db.feedbackEffectivenessTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> challengesTableRefs(
    Expression<bool> Function($$ChallengesTableTableFilterComposer f) f,
  ) {
    final $$ChallengesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.challengesTable,
      getReferencedColumn: (t) => t.creatorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChallengesTableTableFilterComposer(
            $db: $db,
            $table: $db.challengesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> userChallengesTableRefs(
    Expression<bool> Function($$UserChallengesTableTableFilterComposer f) f,
  ) {
    final $$UserChallengesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userChallengesTable,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserChallengesTableTableFilterComposer(
            $db: $db,
            $table: $db.userChallengesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> streaksTableRefs(
    Expression<bool> Function($$StreaksTableTableFilterComposer f) f,
  ) {
    final $$StreaksTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.streaksTable,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StreaksTableTableFilterComposer(
            $db: $db,
            $table: $db.streaksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> leaderboardEntriesTableRefs(
    Expression<bool> Function($$LeaderboardEntriesTableTableFilterComposer f) f,
  ) {
    final $$LeaderboardEntriesTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.leaderboardEntriesTable,
          getReferencedColumn: (t) => t.userId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LeaderboardEntriesTableTableFilterComposer(
                $db: $db,
                $table: $db.leaderboardEntriesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> externalIntegrationsTableRefs(
    Expression<bool> Function($$ExternalIntegrationsTableTableFilterComposer f)
    f,
  ) {
    final $$ExternalIntegrationsTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.externalIntegrationsTable,
          getReferencedColumn: (t) => t.userId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ExternalIntegrationsTableTableFilterComposer(
                $db: $db,
                $table: $db.externalIntegrationsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> syncStatusTableRefs(
    Expression<bool> Function($$SyncStatusTableTableFilterComposer f) f,
  ) {
    final $$SyncStatusTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.syncStatusTable,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SyncStatusTableTableFilterComposer(
            $db: $db,
            $table: $db.syncStatusTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UserProfilesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfilesTableTable> {
  $$UserProfilesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUpdatedAt => $composableBuilder(
    column: $table.lastUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPublic => $composableBuilder(
    column: $table.isPublic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get allowDataUpload => $composableBuilder(
    column: $table.allowDataUpload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferencesJson => $composableBuilder(
    column: $table.preferencesJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfilesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfilesTableTable> {
  $$UserProfilesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUpdatedAt => $composableBuilder(
    column: $table.lastUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPublic =>
      $composableBuilder(column: $table.isPublic, builder: (column) => column);

  GeneratedColumn<bool> get allowDataUpload => $composableBuilder(
    column: $table.allowDataUpload,
    builder: (column) => column,
  );

  GeneratedColumn<String> get preferencesJson => $composableBuilder(
    column: $table.preferencesJson,
    builder: (column) => column,
  );

  Expression<T> performanceMetricsTableRefs<T extends Object>(
    Expression<T> Function($$PerformanceMetricsTableTableAnnotationComposer a)
    f,
  ) {
    final $$PerformanceMetricsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.performanceMetricsTable,
          getReferencedColumn: (t) => t.userId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PerformanceMetricsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.performanceMetricsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> badgesTableRefs<T extends Object>(
    Expression<T> Function($$BadgesTableTableAnnotationComposer a) f,
  ) {
    final $$BadgesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.badgesTable,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BadgesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.badgesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> dataPrivacySettingsTableRefs<T extends Object>(
    Expression<T> Function($$DataPrivacySettingsTableTableAnnotationComposer a)
    f,
  ) {
    final $$DataPrivacySettingsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.dataPrivacySettingsTable,
          getReferencedColumn: (t) => t.userId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DataPrivacySettingsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.dataPrivacySettingsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> socialInteractionsTableRefs<T extends Object>(
    Expression<T> Function($$SocialInteractionsTableTableAnnotationComposer a)
    f,
  ) {
    final $$SocialInteractionsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.socialInteractionsTable,
          getReferencedColumn: (t) => t.userId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SocialInteractionsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.socialInteractionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> sharedContentTableRefs<T extends Object>(
    Expression<T> Function($$SharedContentTableTableAnnotationComposer a) f,
  ) {
    final $$SharedContentTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.sharedContentTable,
          getReferencedColumn: (t) => t.userId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SharedContentTableTableAnnotationComposer(
                $db: $db,
                $table: $db.sharedContentTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> userPreferencesTableRefs<T extends Object>(
    Expression<T> Function($$UserPreferencesTableTableAnnotationComposer a) f,
  ) {
    final $$UserPreferencesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.userPreferencesTable,
          getReferencedColumn: (t) => t.userId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$UserPreferencesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.userPreferencesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> feedbackEffectivenessTableRefs<T extends Object>(
    Expression<T> Function(
      $$FeedbackEffectivenessTableTableAnnotationComposer a,
    )
    f,
  ) {
    final $$FeedbackEffectivenessTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.feedbackEffectivenessTable,
          getReferencedColumn: (t) => t.userId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FeedbackEffectivenessTableTableAnnotationComposer(
                $db: $db,
                $table: $db.feedbackEffectivenessTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> challengesTableRefs<T extends Object>(
    Expression<T> Function($$ChallengesTableTableAnnotationComposer a) f,
  ) {
    final $$ChallengesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.challengesTable,
      getReferencedColumn: (t) => t.creatorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChallengesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.challengesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> userChallengesTableRefs<T extends Object>(
    Expression<T> Function($$UserChallengesTableTableAnnotationComposer a) f,
  ) {
    final $$UserChallengesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.userChallengesTable,
          getReferencedColumn: (t) => t.userId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$UserChallengesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.userChallengesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> streaksTableRefs<T extends Object>(
    Expression<T> Function($$StreaksTableTableAnnotationComposer a) f,
  ) {
    final $$StreaksTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.streaksTable,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StreaksTableTableAnnotationComposer(
            $db: $db,
            $table: $db.streaksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> leaderboardEntriesTableRefs<T extends Object>(
    Expression<T> Function($$LeaderboardEntriesTableTableAnnotationComposer a)
    f,
  ) {
    final $$LeaderboardEntriesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.leaderboardEntriesTable,
          getReferencedColumn: (t) => t.userId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LeaderboardEntriesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.leaderboardEntriesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> externalIntegrationsTableRefs<T extends Object>(
    Expression<T> Function($$ExternalIntegrationsTableTableAnnotationComposer a)
    f,
  ) {
    final $$ExternalIntegrationsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.externalIntegrationsTable,
          getReferencedColumn: (t) => t.userId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ExternalIntegrationsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.externalIntegrationsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> syncStatusTableRefs<T extends Object>(
    Expression<T> Function($$SyncStatusTableTableAnnotationComposer a) f,
  ) {
    final $$SyncStatusTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.syncStatusTable,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SyncStatusTableTableAnnotationComposer(
            $db: $db,
            $table: $db.syncStatusTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UserProfilesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfilesTableTable,
          UserProfilesTableData,
          $$UserProfilesTableTableFilterComposer,
          $$UserProfilesTableTableOrderingComposer,
          $$UserProfilesTableTableAnnotationComposer,
          $$UserProfilesTableTableCreateCompanionBuilder,
          $$UserProfilesTableTableUpdateCompanionBuilder,
          (UserProfilesTableData, $$UserProfilesTableTableReferences),
          UserProfilesTableData,
          PrefetchHooks Function({
            bool performanceMetricsTableRefs,
            bool badgesTableRefs,
            bool dataPrivacySettingsTableRefs,
            bool socialInteractionsTableRefs,
            bool sharedContentTableRefs,
            bool userPreferencesTableRefs,
            bool feedbackEffectivenessTableRefs,
            bool challengesTableRefs,
            bool userChallengesTableRefs,
            bool streaksTableRefs,
            bool leaderboardEntriesTableRefs,
            bool externalIntegrationsTableRefs,
            bool syncStatusTableRefs,
          })
        > {
  $$UserProfilesTableTableTableManager(
    _$AppDatabase db,
    $UserProfilesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$UserProfilesTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$UserProfilesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$UserProfilesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> lastUpdatedAt = const Value.absent(),
                Value<bool> isPublic = const Value.absent(),
                Value<bool> allowDataUpload = const Value.absent(),
                Value<String?> preferencesJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProfilesTableCompanion(
                id: id,
                name: name,
                createdAt: createdAt,
                lastUpdatedAt: lastUpdatedAt,
                isPublic: isPublic,
                allowDataUpload: allowDataUpload,
                preferencesJson: preferencesJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> name = const Value.absent(),
                required DateTime createdAt,
                required DateTime lastUpdatedAt,
                Value<bool> isPublic = const Value.absent(),
                Value<bool> allowDataUpload = const Value.absent(),
                Value<String?> preferencesJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProfilesTableCompanion.insert(
                id: id,
                name: name,
                createdAt: createdAt,
                lastUpdatedAt: lastUpdatedAt,
                isPublic: isPublic,
                allowDataUpload: allowDataUpload,
                preferencesJson: preferencesJson,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$UserProfilesTableTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            performanceMetricsTableRefs = false,
            badgesTableRefs = false,
            dataPrivacySettingsTableRefs = false,
            socialInteractionsTableRefs = false,
            sharedContentTableRefs = false,
            userPreferencesTableRefs = false,
            feedbackEffectivenessTableRefs = false,
            challengesTableRefs = false,
            userChallengesTableRefs = false,
            streaksTableRefs = false,
            leaderboardEntriesTableRefs = false,
            externalIntegrationsTableRefs = false,
            syncStatusTableRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (performanceMetricsTableRefs) db.performanceMetricsTable,
                if (badgesTableRefs) db.badgesTable,
                if (dataPrivacySettingsTableRefs) db.dataPrivacySettingsTable,
                if (socialInteractionsTableRefs) db.socialInteractionsTable,
                if (sharedContentTableRefs) db.sharedContentTable,
                if (userPreferencesTableRefs) db.userPreferencesTable,
                if (feedbackEffectivenessTableRefs)
                  db.feedbackEffectivenessTable,
                if (challengesTableRefs) db.challengesTable,
                if (userChallengesTableRefs) db.userChallengesTable,
                if (streaksTableRefs) db.streaksTable,
                if (leaderboardEntriesTableRefs) db.leaderboardEntriesTable,
                if (externalIntegrationsTableRefs) db.externalIntegrationsTable,
                if (syncStatusTableRefs) db.syncStatusTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (performanceMetricsTableRefs)
                    await $_getPrefetchedData<
                      UserProfilesTableData,
                      $UserProfilesTableTable,
                      PerformanceMetricsTableData
                    >(
                      currentTable: table,
                      referencedTable: $$UserProfilesTableTableReferences
                          ._performanceMetricsTableRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$UserProfilesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).performanceMetricsTableRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.userId == item.id),
                      typedResults: items,
                    ),
                  if (badgesTableRefs)
                    await $_getPrefetchedData<
                      UserProfilesTableData,
                      $UserProfilesTableTable,
                      BadgesTableData
                    >(
                      currentTable: table,
                      referencedTable: $$UserProfilesTableTableReferences
                          ._badgesTableRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$UserProfilesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).badgesTableRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.userId == item.id),
                      typedResults: items,
                    ),
                  if (dataPrivacySettingsTableRefs)
                    await $_getPrefetchedData<
                      UserProfilesTableData,
                      $UserProfilesTableTable,
                      DataPrivacySettingsTableData
                    >(
                      currentTable: table,
                      referencedTable: $$UserProfilesTableTableReferences
                          ._dataPrivacySettingsTableRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$UserProfilesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).dataPrivacySettingsTableRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.userId == item.id),
                      typedResults: items,
                    ),
                  if (socialInteractionsTableRefs)
                    await $_getPrefetchedData<
                      UserProfilesTableData,
                      $UserProfilesTableTable,
                      SocialInteractionsTableData
                    >(
                      currentTable: table,
                      referencedTable: $$UserProfilesTableTableReferences
                          ._socialInteractionsTableRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$UserProfilesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).socialInteractionsTableRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.userId == item.id),
                      typedResults: items,
                    ),
                  if (sharedContentTableRefs)
                    await $_getPrefetchedData<
                      UserProfilesTableData,
                      $UserProfilesTableTable,
                      SharedContentTableData
                    >(
                      currentTable: table,
                      referencedTable: $$UserProfilesTableTableReferences
                          ._sharedContentTableRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$UserProfilesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).sharedContentTableRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.userId == item.id),
                      typedResults: items,
                    ),
                  if (userPreferencesTableRefs)
                    await $_getPrefetchedData<
                      UserProfilesTableData,
                      $UserProfilesTableTable,
                      UserPreferencesTableData
                    >(
                      currentTable: table,
                      referencedTable: $$UserProfilesTableTableReferences
                          ._userPreferencesTableRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$UserProfilesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).userPreferencesTableRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.userId == item.id),
                      typedResults: items,
                    ),
                  if (feedbackEffectivenessTableRefs)
                    await $_getPrefetchedData<
                      UserProfilesTableData,
                      $UserProfilesTableTable,
                      FeedbackEffectivenessTableData
                    >(
                      currentTable: table,
                      referencedTable: $$UserProfilesTableTableReferences
                          ._feedbackEffectivenessTableRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$UserProfilesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).feedbackEffectivenessTableRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.userId == item.id),
                      typedResults: items,
                    ),
                  if (challengesTableRefs)
                    await $_getPrefetchedData<
                      UserProfilesTableData,
                      $UserProfilesTableTable,
                      ChallengesTableData
                    >(
                      currentTable: table,
                      referencedTable: $$UserProfilesTableTableReferences
                          ._challengesTableRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$UserProfilesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).challengesTableRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.creatorId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (userChallengesTableRefs)
                    await $_getPrefetchedData<
                      UserProfilesTableData,
                      $UserProfilesTableTable,
                      UserChallengesTableData
                    >(
                      currentTable: table,
                      referencedTable: $$UserProfilesTableTableReferences
                          ._userChallengesTableRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$UserProfilesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).userChallengesTableRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.userId == item.id),
                      typedResults: items,
                    ),
                  if (streaksTableRefs)
                    await $_getPrefetchedData<
                      UserProfilesTableData,
                      $UserProfilesTableTable,
                      StreaksTableData
                    >(
                      currentTable: table,
                      referencedTable: $$UserProfilesTableTableReferences
                          ._streaksTableRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$UserProfilesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).streaksTableRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.userId == item.id),
                      typedResults: items,
                    ),
                  if (leaderboardEntriesTableRefs)
                    await $_getPrefetchedData<
                      UserProfilesTableData,
                      $UserProfilesTableTable,
                      LeaderboardEntriesTableData
                    >(
                      currentTable: table,
                      referencedTable: $$UserProfilesTableTableReferences
                          ._leaderboardEntriesTableRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$UserProfilesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).leaderboardEntriesTableRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.userId == item.id),
                      typedResults: items,
                    ),
                  if (externalIntegrationsTableRefs)
                    await $_getPrefetchedData<
                      UserProfilesTableData,
                      $UserProfilesTableTable,
                      ExternalIntegrationsTableData
                    >(
                      currentTable: table,
                      referencedTable: $$UserProfilesTableTableReferences
                          ._externalIntegrationsTableRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$UserProfilesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).externalIntegrationsTableRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.userId == item.id),
                      typedResults: items,
                    ),
                  if (syncStatusTableRefs)
                    await $_getPrefetchedData<
                      UserProfilesTableData,
                      $UserProfilesTableTable,
                      SyncStatusTableData
                    >(
                      currentTable: table,
                      referencedTable: $$UserProfilesTableTableReferences
                          ._syncStatusTableRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$UserProfilesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).syncStatusTableRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.userId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$UserProfilesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfilesTableTable,
      UserProfilesTableData,
      $$UserProfilesTableTableFilterComposer,
      $$UserProfilesTableTableOrderingComposer,
      $$UserProfilesTableTableAnnotationComposer,
      $$UserProfilesTableTableCreateCompanionBuilder,
      $$UserProfilesTableTableUpdateCompanionBuilder,
      (UserProfilesTableData, $$UserProfilesTableTableReferences),
      UserProfilesTableData,
      PrefetchHooks Function({
        bool performanceMetricsTableRefs,
        bool badgesTableRefs,
        bool dataPrivacySettingsTableRefs,
        bool socialInteractionsTableRefs,
        bool sharedContentTableRefs,
        bool userPreferencesTableRefs,
        bool feedbackEffectivenessTableRefs,
        bool challengesTableRefs,
        bool userChallengesTableRefs,
        bool streaksTableRefs,
        bool leaderboardEntriesTableRefs,
        bool externalIntegrationsTableRefs,
        bool syncStatusTableRefs,
      })
    >;
typedef $$PerformanceMetricsTableTableCreateCompanionBuilder =
    PerformanceMetricsTableCompanion Function({
      Value<int> id,
      required String userId,
      required DateTime generatedAt,
      required DateTime periodStart,
      required DateTime periodEnd,
      required int totalTrips,
      required double totalDistanceKm,
      required double totalDrivingTimeMinutes,
      required double averageSpeedKmh,
      Value<double?> estimatedFuelSavingsPercent,
      Value<double?> estimatedCO2ReductionKg,
      Value<int?> calmDrivingScore,
      Value<int?> speedOptimizationScore,
      Value<int?> idlingScore,
      Value<int?> shortDistanceScore,
      Value<int?> rpmManagementScore,
      Value<int?> stopManagementScore,
      Value<int?> followDistanceScore,
      required int overallScore,
      Value<String?> improvementTipsJson,
    });
typedef $$PerformanceMetricsTableTableUpdateCompanionBuilder =
    PerformanceMetricsTableCompanion Function({
      Value<int> id,
      Value<String> userId,
      Value<DateTime> generatedAt,
      Value<DateTime> periodStart,
      Value<DateTime> periodEnd,
      Value<int> totalTrips,
      Value<double> totalDistanceKm,
      Value<double> totalDrivingTimeMinutes,
      Value<double> averageSpeedKmh,
      Value<double?> estimatedFuelSavingsPercent,
      Value<double?> estimatedCO2ReductionKg,
      Value<int?> calmDrivingScore,
      Value<int?> speedOptimizationScore,
      Value<int?> idlingScore,
      Value<int?> shortDistanceScore,
      Value<int?> rpmManagementScore,
      Value<int?> stopManagementScore,
      Value<int?> followDistanceScore,
      Value<int> overallScore,
      Value<String?> improvementTipsJson,
    });

final class $$PerformanceMetricsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PerformanceMetricsTableTable,
          PerformanceMetricsTableData
        > {
  $$PerformanceMetricsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UserProfilesTableTable _userIdTable(_$AppDatabase db) =>
      db.userProfilesTable.createAlias(
        $_aliasNameGenerator(
          db.performanceMetricsTable.userId,
          db.userProfilesTable.id,
        ),
      );

  $$UserProfilesTableTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UserProfilesTableTableTableManager(
      $_db,
      $_db.userProfilesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PerformanceMetricsTableTableFilterComposer
    extends Composer<_$AppDatabase, $PerformanceMetricsTableTable> {
  $$PerformanceMetricsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get periodStart => $composableBuilder(
    column: $table.periodStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get periodEnd => $composableBuilder(
    column: $table.periodEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalTrips => $composableBuilder(
    column: $table.totalTrips,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalDistanceKm => $composableBuilder(
    column: $table.totalDistanceKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalDrivingTimeMinutes => $composableBuilder(
    column: $table.totalDrivingTimeMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get averageSpeedKmh => $composableBuilder(
    column: $table.averageSpeedKmh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get estimatedFuelSavingsPercent => $composableBuilder(
    column: $table.estimatedFuelSavingsPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get estimatedCO2ReductionKg => $composableBuilder(
    column: $table.estimatedCO2ReductionKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get calmDrivingScore => $composableBuilder(
    column: $table.calmDrivingScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get speedOptimizationScore => $composableBuilder(
    column: $table.speedOptimizationScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get idlingScore => $composableBuilder(
    column: $table.idlingScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get shortDistanceScore => $composableBuilder(
    column: $table.shortDistanceScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rpmManagementScore => $composableBuilder(
    column: $table.rpmManagementScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stopManagementScore => $composableBuilder(
    column: $table.stopManagementScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get followDistanceScore => $composableBuilder(
    column: $table.followDistanceScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get overallScore => $composableBuilder(
    column: $table.overallScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get improvementTipsJson => $composableBuilder(
    column: $table.improvementTipsJson,
    builder: (column) => ColumnFilters(column),
  );

  $$UserProfilesTableTableFilterComposer get userId {
    final $$UserProfilesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.userProfilesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableTableFilterComposer(
            $db: $db,
            $table: $db.userProfilesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PerformanceMetricsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PerformanceMetricsTableTable> {
  $$PerformanceMetricsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get periodStart => $composableBuilder(
    column: $table.periodStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get periodEnd => $composableBuilder(
    column: $table.periodEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalTrips => $composableBuilder(
    column: $table.totalTrips,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalDistanceKm => $composableBuilder(
    column: $table.totalDistanceKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalDrivingTimeMinutes => $composableBuilder(
    column: $table.totalDrivingTimeMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get averageSpeedKmh => $composableBuilder(
    column: $table.averageSpeedKmh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get estimatedFuelSavingsPercent => $composableBuilder(
    column: $table.estimatedFuelSavingsPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get estimatedCO2ReductionKg => $composableBuilder(
    column: $table.estimatedCO2ReductionKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get calmDrivingScore => $composableBuilder(
    column: $table.calmDrivingScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get speedOptimizationScore => $composableBuilder(
    column: $table.speedOptimizationScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get idlingScore => $composableBuilder(
    column: $table.idlingScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get shortDistanceScore => $composableBuilder(
    column: $table.shortDistanceScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rpmManagementScore => $composableBuilder(
    column: $table.rpmManagementScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stopManagementScore => $composableBuilder(
    column: $table.stopManagementScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get followDistanceScore => $composableBuilder(
    column: $table.followDistanceScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get overallScore => $composableBuilder(
    column: $table.overallScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get improvementTipsJson => $composableBuilder(
    column: $table.improvementTipsJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$UserProfilesTableTableOrderingComposer get userId {
    final $$UserProfilesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.userProfilesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableTableOrderingComposer(
            $db: $db,
            $table: $db.userProfilesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PerformanceMetricsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PerformanceMetricsTableTable> {
  $$PerformanceMetricsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get periodStart => $composableBuilder(
    column: $table.periodStart,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get periodEnd =>
      $composableBuilder(column: $table.periodEnd, builder: (column) => column);

  GeneratedColumn<int> get totalTrips => $composableBuilder(
    column: $table.totalTrips,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalDistanceKm => $composableBuilder(
    column: $table.totalDistanceKm,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalDrivingTimeMinutes => $composableBuilder(
    column: $table.totalDrivingTimeMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<double> get averageSpeedKmh => $composableBuilder(
    column: $table.averageSpeedKmh,
    builder: (column) => column,
  );

  GeneratedColumn<double> get estimatedFuelSavingsPercent => $composableBuilder(
    column: $table.estimatedFuelSavingsPercent,
    builder: (column) => column,
  );

  GeneratedColumn<double> get estimatedCO2ReductionKg => $composableBuilder(
    column: $table.estimatedCO2ReductionKg,
    builder: (column) => column,
  );

  GeneratedColumn<int> get calmDrivingScore => $composableBuilder(
    column: $table.calmDrivingScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get speedOptimizationScore => $composableBuilder(
    column: $table.speedOptimizationScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get idlingScore => $composableBuilder(
    column: $table.idlingScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get shortDistanceScore => $composableBuilder(
    column: $table.shortDistanceScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rpmManagementScore => $composableBuilder(
    column: $table.rpmManagementScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get stopManagementScore => $composableBuilder(
    column: $table.stopManagementScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get followDistanceScore => $composableBuilder(
    column: $table.followDistanceScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get overallScore => $composableBuilder(
    column: $table.overallScore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get improvementTipsJson => $composableBuilder(
    column: $table.improvementTipsJson,
    builder: (column) => column,
  );

  $$UserProfilesTableTableAnnotationComposer get userId {
    final $$UserProfilesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.userId,
          referencedTable: $db.userProfilesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$UserProfilesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.userProfilesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$PerformanceMetricsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PerformanceMetricsTableTable,
          PerformanceMetricsTableData,
          $$PerformanceMetricsTableTableFilterComposer,
          $$PerformanceMetricsTableTableOrderingComposer,
          $$PerformanceMetricsTableTableAnnotationComposer,
          $$PerformanceMetricsTableTableCreateCompanionBuilder,
          $$PerformanceMetricsTableTableUpdateCompanionBuilder,
          (
            PerformanceMetricsTableData,
            $$PerformanceMetricsTableTableReferences,
          ),
          PerformanceMetricsTableData,
          PrefetchHooks Function({bool userId})
        > {
  $$PerformanceMetricsTableTableTableManager(
    _$AppDatabase db,
    $PerformanceMetricsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$PerformanceMetricsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$PerformanceMetricsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$PerformanceMetricsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime> generatedAt = const Value.absent(),
                Value<DateTime> periodStart = const Value.absent(),
                Value<DateTime> periodEnd = const Value.absent(),
                Value<int> totalTrips = const Value.absent(),
                Value<double> totalDistanceKm = const Value.absent(),
                Value<double> totalDrivingTimeMinutes = const Value.absent(),
                Value<double> averageSpeedKmh = const Value.absent(),
                Value<double?> estimatedFuelSavingsPercent =
                    const Value.absent(),
                Value<double?> estimatedCO2ReductionKg = const Value.absent(),
                Value<int?> calmDrivingScore = const Value.absent(),
                Value<int?> speedOptimizationScore = const Value.absent(),
                Value<int?> idlingScore = const Value.absent(),
                Value<int?> shortDistanceScore = const Value.absent(),
                Value<int?> rpmManagementScore = const Value.absent(),
                Value<int?> stopManagementScore = const Value.absent(),
                Value<int?> followDistanceScore = const Value.absent(),
                Value<int> overallScore = const Value.absent(),
                Value<String?> improvementTipsJson = const Value.absent(),
              }) => PerformanceMetricsTableCompanion(
                id: id,
                userId: userId,
                generatedAt: generatedAt,
                periodStart: periodStart,
                periodEnd: periodEnd,
                totalTrips: totalTrips,
                totalDistanceKm: totalDistanceKm,
                totalDrivingTimeMinutes: totalDrivingTimeMinutes,
                averageSpeedKmh: averageSpeedKmh,
                estimatedFuelSavingsPercent: estimatedFuelSavingsPercent,
                estimatedCO2ReductionKg: estimatedCO2ReductionKg,
                calmDrivingScore: calmDrivingScore,
                speedOptimizationScore: speedOptimizationScore,
                idlingScore: idlingScore,
                shortDistanceScore: shortDistanceScore,
                rpmManagementScore: rpmManagementScore,
                stopManagementScore: stopManagementScore,
                followDistanceScore: followDistanceScore,
                overallScore: overallScore,
                improvementTipsJson: improvementTipsJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String userId,
                required DateTime generatedAt,
                required DateTime periodStart,
                required DateTime periodEnd,
                required int totalTrips,
                required double totalDistanceKm,
                required double totalDrivingTimeMinutes,
                required double averageSpeedKmh,
                Value<double?> estimatedFuelSavingsPercent =
                    const Value.absent(),
                Value<double?> estimatedCO2ReductionKg = const Value.absent(),
                Value<int?> calmDrivingScore = const Value.absent(),
                Value<int?> speedOptimizationScore = const Value.absent(),
                Value<int?> idlingScore = const Value.absent(),
                Value<int?> shortDistanceScore = const Value.absent(),
                Value<int?> rpmManagementScore = const Value.absent(),
                Value<int?> stopManagementScore = const Value.absent(),
                Value<int?> followDistanceScore = const Value.absent(),
                required int overallScore,
                Value<String?> improvementTipsJson = const Value.absent(),
              }) => PerformanceMetricsTableCompanion.insert(
                id: id,
                userId: userId,
                generatedAt: generatedAt,
                periodStart: periodStart,
                periodEnd: periodEnd,
                totalTrips: totalTrips,
                totalDistanceKm: totalDistanceKm,
                totalDrivingTimeMinutes: totalDrivingTimeMinutes,
                averageSpeedKmh: averageSpeedKmh,
                estimatedFuelSavingsPercent: estimatedFuelSavingsPercent,
                estimatedCO2ReductionKg: estimatedCO2ReductionKg,
                calmDrivingScore: calmDrivingScore,
                speedOptimizationScore: speedOptimizationScore,
                idlingScore: idlingScore,
                shortDistanceScore: shortDistanceScore,
                rpmManagementScore: rpmManagementScore,
                stopManagementScore: stopManagementScore,
                followDistanceScore: followDistanceScore,
                overallScore: overallScore,
                improvementTipsJson: improvementTipsJson,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$PerformanceMetricsTableTableReferences(
                            db,
                            table,
                            e,
                          ),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (userId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.userId,
                            referencedTable:
                                $$PerformanceMetricsTableTableReferences
                                    ._userIdTable(db),
                            referencedColumn:
                                $$PerformanceMetricsTableTableReferences
                                    ._userIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PerformanceMetricsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PerformanceMetricsTableTable,
      PerformanceMetricsTableData,
      $$PerformanceMetricsTableTableFilterComposer,
      $$PerformanceMetricsTableTableOrderingComposer,
      $$PerformanceMetricsTableTableAnnotationComposer,
      $$PerformanceMetricsTableTableCreateCompanionBuilder,
      $$PerformanceMetricsTableTableUpdateCompanionBuilder,
      (PerformanceMetricsTableData, $$PerformanceMetricsTableTableReferences),
      PerformanceMetricsTableData,
      PrefetchHooks Function({bool userId})
    >;
typedef $$BadgesTableTableCreateCompanionBuilder =
    BadgesTableCompanion Function({
      Value<int> id,
      required String userId,
      required String badgeType,
      required DateTime earnedDate,
      Value<int> level,
      Value<String?> metadataJson,
    });
typedef $$BadgesTableTableUpdateCompanionBuilder =
    BadgesTableCompanion Function({
      Value<int> id,
      Value<String> userId,
      Value<String> badgeType,
      Value<DateTime> earnedDate,
      Value<int> level,
      Value<String?> metadataJson,
    });

final class $$BadgesTableTableReferences
    extends BaseReferences<_$AppDatabase, $BadgesTableTable, BadgesTableData> {
  $$BadgesTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UserProfilesTableTable _userIdTable(_$AppDatabase db) =>
      db.userProfilesTable.createAlias(
        $_aliasNameGenerator(db.badgesTable.userId, db.userProfilesTable.id),
      );

  $$UserProfilesTableTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UserProfilesTableTableTableManager(
      $_db,
      $_db.userProfilesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BadgesTableTableFilterComposer
    extends Composer<_$AppDatabase, $BadgesTableTable> {
  $$BadgesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get badgeType => $composableBuilder(
    column: $table.badgeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get earnedDate => $composableBuilder(
    column: $table.earnedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => ColumnFilters(column),
  );

  $$UserProfilesTableTableFilterComposer get userId {
    final $$UserProfilesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.userProfilesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableTableFilterComposer(
            $db: $db,
            $table: $db.userProfilesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BadgesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BadgesTableTable> {
  $$BadgesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get badgeType => $composableBuilder(
    column: $table.badgeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get earnedDate => $composableBuilder(
    column: $table.earnedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$UserProfilesTableTableOrderingComposer get userId {
    final $$UserProfilesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.userProfilesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableTableOrderingComposer(
            $db: $db,
            $table: $db.userProfilesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BadgesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BadgesTableTable> {
  $$BadgesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get badgeType =>
      $composableBuilder(column: $table.badgeType, builder: (column) => column);

  GeneratedColumn<DateTime> get earnedDate => $composableBuilder(
    column: $table.earnedDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => column,
  );

  $$UserProfilesTableTableAnnotationComposer get userId {
    final $$UserProfilesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.userId,
          referencedTable: $db.userProfilesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$UserProfilesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.userProfilesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$BadgesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BadgesTableTable,
          BadgesTableData,
          $$BadgesTableTableFilterComposer,
          $$BadgesTableTableOrderingComposer,
          $$BadgesTableTableAnnotationComposer,
          $$BadgesTableTableCreateCompanionBuilder,
          $$BadgesTableTableUpdateCompanionBuilder,
          (BadgesTableData, $$BadgesTableTableReferences),
          BadgesTableData,
          PrefetchHooks Function({bool userId})
        > {
  $$BadgesTableTableTableManager(_$AppDatabase db, $BadgesTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$BadgesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$BadgesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$BadgesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> badgeType = const Value.absent(),
                Value<DateTime> earnedDate = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<String?> metadataJson = const Value.absent(),
              }) => BadgesTableCompanion(
                id: id,
                userId: userId,
                badgeType: badgeType,
                earnedDate: earnedDate,
                level: level,
                metadataJson: metadataJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String userId,
                required String badgeType,
                required DateTime earnedDate,
                Value<int> level = const Value.absent(),
                Value<String?> metadataJson = const Value.absent(),
              }) => BadgesTableCompanion.insert(
                id: id,
                userId: userId,
                badgeType: badgeType,
                earnedDate: earnedDate,
                level: level,
                metadataJson: metadataJson,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$BadgesTableTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (userId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.userId,
                            referencedTable: $$BadgesTableTableReferences
                                ._userIdTable(db),
                            referencedColumn:
                                $$BadgesTableTableReferences
                                    ._userIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BadgesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BadgesTableTable,
      BadgesTableData,
      $$BadgesTableTableFilterComposer,
      $$BadgesTableTableOrderingComposer,
      $$BadgesTableTableAnnotationComposer,
      $$BadgesTableTableCreateCompanionBuilder,
      $$BadgesTableTableUpdateCompanionBuilder,
      (BadgesTableData, $$BadgesTableTableReferences),
      BadgesTableData,
      PrefetchHooks Function({bool userId})
    >;
typedef $$DataPrivacySettingsTableTableCreateCompanionBuilder =
    DataPrivacySettingsTableCompanion Function({
      required String id,
      required String userId,
      required String dataType,
      Value<bool> allowLocalStorage,
      Value<bool> allowCloudSync,
      Value<bool> allowSharing,
      Value<bool> allowAnonymizedAnalytics,
      Value<int> rowid,
    });
typedef $$DataPrivacySettingsTableTableUpdateCompanionBuilder =
    DataPrivacySettingsTableCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> dataType,
      Value<bool> allowLocalStorage,
      Value<bool> allowCloudSync,
      Value<bool> allowSharing,
      Value<bool> allowAnonymizedAnalytics,
      Value<int> rowid,
    });

final class $$DataPrivacySettingsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $DataPrivacySettingsTableTable,
          DataPrivacySettingsTableData
        > {
  $$DataPrivacySettingsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UserProfilesTableTable _userIdTable(_$AppDatabase db) =>
      db.userProfilesTable.createAlias(
        $_aliasNameGenerator(
          db.dataPrivacySettingsTable.userId,
          db.userProfilesTable.id,
        ),
      );

  $$UserProfilesTableTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UserProfilesTableTableTableManager(
      $_db,
      $_db.userProfilesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DataPrivacySettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $DataPrivacySettingsTableTable> {
  $$DataPrivacySettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dataType => $composableBuilder(
    column: $table.dataType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get allowLocalStorage => $composableBuilder(
    column: $table.allowLocalStorage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get allowCloudSync => $composableBuilder(
    column: $table.allowCloudSync,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get allowSharing => $composableBuilder(
    column: $table.allowSharing,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get allowAnonymizedAnalytics => $composableBuilder(
    column: $table.allowAnonymizedAnalytics,
    builder: (column) => ColumnFilters(column),
  );

  $$UserProfilesTableTableFilterComposer get userId {
    final $$UserProfilesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.userProfilesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableTableFilterComposer(
            $db: $db,
            $table: $db.userProfilesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DataPrivacySettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DataPrivacySettingsTableTable> {
  $$DataPrivacySettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dataType => $composableBuilder(
    column: $table.dataType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get allowLocalStorage => $composableBuilder(
    column: $table.allowLocalStorage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get allowCloudSync => $composableBuilder(
    column: $table.allowCloudSync,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get allowSharing => $composableBuilder(
    column: $table.allowSharing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get allowAnonymizedAnalytics => $composableBuilder(
    column: $table.allowAnonymizedAnalytics,
    builder: (column) => ColumnOrderings(column),
  );

  $$UserProfilesTableTableOrderingComposer get userId {
    final $$UserProfilesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.userProfilesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableTableOrderingComposer(
            $db: $db,
            $table: $db.userProfilesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DataPrivacySettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DataPrivacySettingsTableTable> {
  $$DataPrivacySettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dataType =>
      $composableBuilder(column: $table.dataType, builder: (column) => column);

  GeneratedColumn<bool> get allowLocalStorage => $composableBuilder(
    column: $table.allowLocalStorage,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get allowCloudSync => $composableBuilder(
    column: $table.allowCloudSync,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get allowSharing => $composableBuilder(
    column: $table.allowSharing,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get allowAnonymizedAnalytics => $composableBuilder(
    column: $table.allowAnonymizedAnalytics,
    builder: (column) => column,
  );

  $$UserProfilesTableTableAnnotationComposer get userId {
    final $$UserProfilesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.userId,
          referencedTable: $db.userProfilesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$UserProfilesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.userProfilesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$DataPrivacySettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DataPrivacySettingsTableTable,
          DataPrivacySettingsTableData,
          $$DataPrivacySettingsTableTableFilterComposer,
          $$DataPrivacySettingsTableTableOrderingComposer,
          $$DataPrivacySettingsTableTableAnnotationComposer,
          $$DataPrivacySettingsTableTableCreateCompanionBuilder,
          $$DataPrivacySettingsTableTableUpdateCompanionBuilder,
          (
            DataPrivacySettingsTableData,
            $$DataPrivacySettingsTableTableReferences,
          ),
          DataPrivacySettingsTableData,
          PrefetchHooks Function({bool userId})
        > {
  $$DataPrivacySettingsTableTableTableManager(
    _$AppDatabase db,
    $DataPrivacySettingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$DataPrivacySettingsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$DataPrivacySettingsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$DataPrivacySettingsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> dataType = const Value.absent(),
                Value<bool> allowLocalStorage = const Value.absent(),
                Value<bool> allowCloudSync = const Value.absent(),
                Value<bool> allowSharing = const Value.absent(),
                Value<bool> allowAnonymizedAnalytics = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DataPrivacySettingsTableCompanion(
                id: id,
                userId: userId,
                dataType: dataType,
                allowLocalStorage: allowLocalStorage,
                allowCloudSync: allowCloudSync,
                allowSharing: allowSharing,
                allowAnonymizedAnalytics: allowAnonymizedAnalytics,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String dataType,
                Value<bool> allowLocalStorage = const Value.absent(),
                Value<bool> allowCloudSync = const Value.absent(),
                Value<bool> allowSharing = const Value.absent(),
                Value<bool> allowAnonymizedAnalytics = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DataPrivacySettingsTableCompanion.insert(
                id: id,
                userId: userId,
                dataType: dataType,
                allowLocalStorage: allowLocalStorage,
                allowCloudSync: allowCloudSync,
                allowSharing: allowSharing,
                allowAnonymizedAnalytics: allowAnonymizedAnalytics,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$DataPrivacySettingsTableTableReferences(
                            db,
                            table,
                            e,
                          ),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (userId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.userId,
                            referencedTable:
                                $$DataPrivacySettingsTableTableReferences
                                    ._userIdTable(db),
                            referencedColumn:
                                $$DataPrivacySettingsTableTableReferences
                                    ._userIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DataPrivacySettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DataPrivacySettingsTableTable,
      DataPrivacySettingsTableData,
      $$DataPrivacySettingsTableTableFilterComposer,
      $$DataPrivacySettingsTableTableOrderingComposer,
      $$DataPrivacySettingsTableTableAnnotationComposer,
      $$DataPrivacySettingsTableTableCreateCompanionBuilder,
      $$DataPrivacySettingsTableTableUpdateCompanionBuilder,
      (DataPrivacySettingsTableData, $$DataPrivacySettingsTableTableReferences),
      DataPrivacySettingsTableData,
      PrefetchHooks Function({bool userId})
    >;
typedef $$SocialConnectionsTableTableCreateCompanionBuilder =
    SocialConnectionsTableCompanion Function({
      required String id,
      required String userId,
      required String connectedUserId,
      required String connectionType,
      required DateTime connectedSince,
      Value<bool> isMutual,
      Value<int> rowid,
    });
typedef $$SocialConnectionsTableTableUpdateCompanionBuilder =
    SocialConnectionsTableCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> connectedUserId,
      Value<String> connectionType,
      Value<DateTime> connectedSince,
      Value<bool> isMutual,
      Value<int> rowid,
    });

final class $$SocialConnectionsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $SocialConnectionsTableTable,
          SocialConnectionsTableData
        > {
  $$SocialConnectionsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UserProfilesTableTable _userIdTable(_$AppDatabase db) =>
      db.userProfilesTable.createAlias(
        $_aliasNameGenerator(
          db.socialConnectionsTable.userId,
          db.userProfilesTable.id,
        ),
      );

  $$UserProfilesTableTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UserProfilesTableTableTableManager(
      $_db,
      $_db.userProfilesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UserProfilesTableTable _connectedUserIdTable(_$AppDatabase db) =>
      db.userProfilesTable.createAlias(
        $_aliasNameGenerator(
          db.socialConnectionsTable.connectedUserId,
          db.userProfilesTable.id,
        ),
      );

  $$UserProfilesTableTableProcessedTableManager get connectedUserId {
    final $_column = $_itemColumn<String>('connected_user_id')!;

    final manager = $$UserProfilesTableTableTableManager(
      $_db,
      $_db.userProfilesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_connectedUserIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SocialConnectionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SocialConnectionsTableTable> {
  $$SocialConnectionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get connectionType => $composableBuilder(
    column: $table.connectionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get connectedSince => $composableBuilder(
    column: $table.connectedSince,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isMutual => $composableBuilder(
    column: $table.isMutual,
    builder: (column) => ColumnFilters(column),
  );

  $$UserProfilesTableTableFilterComposer get userId {
    final $$UserProfilesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.userProfilesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableTableFilterComposer(
            $db: $db,
            $table: $db.userProfilesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UserProfilesTableTableFilterComposer get connectedUserId {
    final $$UserProfilesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.connectedUserId,
      referencedTable: $db.userProfilesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableTableFilterComposer(
            $db: $db,
            $table: $db.userProfilesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SocialConnectionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SocialConnectionsTableTable> {
  $$SocialConnectionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get connectionType => $composableBuilder(
    column: $table.connectionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get connectedSince => $composableBuilder(
    column: $table.connectedSince,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isMutual => $composableBuilder(
    column: $table.isMutual,
    builder: (column) => ColumnOrderings(column),
  );

  $$UserProfilesTableTableOrderingComposer get userId {
    final $$UserProfilesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.userProfilesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableTableOrderingComposer(
            $db: $db,
            $table: $db.userProfilesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UserProfilesTableTableOrderingComposer get connectedUserId {
    final $$UserProfilesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.connectedUserId,
      referencedTable: $db.userProfilesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableTableOrderingComposer(
            $db: $db,
            $table: $db.userProfilesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SocialConnectionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SocialConnectionsTableTable> {
  $$SocialConnectionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get connectionType => $composableBuilder(
    column: $table.connectionType,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get connectedSince => $composableBuilder(
    column: $table.connectedSince,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isMutual =>
      $composableBuilder(column: $table.isMutual, builder: (column) => column);

  $$UserProfilesTableTableAnnotationComposer get userId {
    final $$UserProfilesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.userId,
          referencedTable: $db.userProfilesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$UserProfilesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.userProfilesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$UserProfilesTableTableAnnotationComposer get connectedUserId {
    final $$UserProfilesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.connectedUserId,
          referencedTable: $db.userProfilesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$UserProfilesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.userProfilesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$SocialConnectionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SocialConnectionsTableTable,
          SocialConnectionsTableData,
          $$SocialConnectionsTableTableFilterComposer,
          $$SocialConnectionsTableTableOrderingComposer,
          $$SocialConnectionsTableTableAnnotationComposer,
          $$SocialConnectionsTableTableCreateCompanionBuilder,
          $$SocialConnectionsTableTableUpdateCompanionBuilder,
          (SocialConnectionsTableData, $$SocialConnectionsTableTableReferences),
          SocialConnectionsTableData,
          PrefetchHooks Function({bool userId, bool connectedUserId})
        > {
  $$SocialConnectionsTableTableTableManager(
    _$AppDatabase db,
    $SocialConnectionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$SocialConnectionsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$SocialConnectionsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$SocialConnectionsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> connectedUserId = const Value.absent(),
                Value<String> connectionType = const Value.absent(),
                Value<DateTime> connectedSince = const Value.absent(),
                Value<bool> isMutual = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SocialConnectionsTableCompanion(
                id: id,
                userId: userId,
                connectedUserId: connectedUserId,
                connectionType: connectionType,
                connectedSince: connectedSince,
                isMutual: isMutual,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String connectedUserId,
                required String connectionType,
                required DateTime connectedSince,
                Value<bool> isMutual = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SocialConnectionsTableCompanion.insert(
                id: id,
                userId: userId,
                connectedUserId: connectedUserId,
                connectionType: connectionType,
                connectedSince: connectedSince,
                isMutual: isMutual,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$SocialConnectionsTableTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({userId = false, connectedUserId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (userId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.userId,
                            referencedTable:
                                $$SocialConnectionsTableTableReferences
                                    ._userIdTable(db),
                            referencedColumn:
                                $$SocialConnectionsTableTableReferences
                                    ._userIdTable(db)
                                    .id,
                          )
                          as T;
                }
                if (connectedUserId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.connectedUserId,
                            referencedTable:
                                $$SocialConnectionsTableTableReferences
                                    ._connectedUserIdTable(db),
                            referencedColumn:
                                $$SocialConnectionsTableTableReferences
                                    ._connectedUserIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SocialConnectionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SocialConnectionsTableTable,
      SocialConnectionsTableData,
      $$SocialConnectionsTableTableFilterComposer,
      $$SocialConnectionsTableTableOrderingComposer,
      $$SocialConnectionsTableTableAnnotationComposer,
      $$SocialConnectionsTableTableCreateCompanionBuilder,
      $$SocialConnectionsTableTableUpdateCompanionBuilder,
      (SocialConnectionsTableData, $$SocialConnectionsTableTableReferences),
      SocialConnectionsTableData,
      PrefetchHooks Function({bool userId, bool connectedUserId})
    >;
typedef $$SocialInteractionsTableTableCreateCompanionBuilder =
    SocialInteractionsTableCompanion Function({
      required String id,
      required String userId,
      required String contentType,
      required String contentId,
      required String interactionType,
      Value<String?> content,
      required DateTime timestamp,
      Value<int> rowid,
    });
typedef $$SocialInteractionsTableTableUpdateCompanionBuilder =
    SocialInteractionsTableCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> contentType,
      Value<String> contentId,
      Value<String> interactionType,
      Value<String?> content,
      Value<DateTime> timestamp,
      Value<int> rowid,
    });

final class $$SocialInteractionsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $SocialInteractionsTableTable,
          SocialInteractionsTableData
        > {
  $$SocialInteractionsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UserProfilesTableTable _userIdTable(_$AppDatabase db) =>
      db.userProfilesTable.createAlias(
        $_aliasNameGenerator(
          db.socialInteractionsTable.userId,
          db.userProfilesTable.id,
        ),
      );

  $$UserProfilesTableTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UserProfilesTableTableTableManager(
      $_db,
      $_db.userProfilesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SocialInteractionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SocialInteractionsTableTable> {
  $$SocialInteractionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get interactionType => $composableBuilder(
    column: $table.interactionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  $$UserProfilesTableTableFilterComposer get userId {
    final $$UserProfilesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.userProfilesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableTableFilterComposer(
            $db: $db,
            $table: $db.userProfilesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SocialInteractionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SocialInteractionsTableTable> {
  $$SocialInteractionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get interactionType => $composableBuilder(
    column: $table.interactionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  $$UserProfilesTableTableOrderingComposer get userId {
    final $$UserProfilesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.userProfilesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableTableOrderingComposer(
            $db: $db,
            $table: $db.userProfilesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SocialInteractionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SocialInteractionsTableTable> {
  $$SocialInteractionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contentId =>
      $composableBuilder(column: $table.contentId, builder: (column) => column);

  GeneratedColumn<String> get interactionType => $composableBuilder(
    column: $table.interactionType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  $$UserProfilesTableTableAnnotationComposer get userId {
    final $$UserProfilesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.userId,
          referencedTable: $db.userProfilesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$UserProfilesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.userProfilesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$SocialInteractionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SocialInteractionsTableTable,
          SocialInteractionsTableData,
          $$SocialInteractionsTableTableFilterComposer,
          $$SocialInteractionsTableTableOrderingComposer,
          $$SocialInteractionsTableTableAnnotationComposer,
          $$SocialInteractionsTableTableCreateCompanionBuilder,
          $$SocialInteractionsTableTableUpdateCompanionBuilder,
          (
            SocialInteractionsTableData,
            $$SocialInteractionsTableTableReferences,
          ),
          SocialInteractionsTableData,
          PrefetchHooks Function({bool userId})
        > {
  $$SocialInteractionsTableTableTableManager(
    _$AppDatabase db,
    $SocialInteractionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$SocialInteractionsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$SocialInteractionsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$SocialInteractionsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> contentType = const Value.absent(),
                Value<String> contentId = const Value.absent(),
                Value<String> interactionType = const Value.absent(),
                Value<String?> content = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SocialInteractionsTableCompanion(
                id: id,
                userId: userId,
                contentType: contentType,
                contentId: contentId,
                interactionType: interactionType,
                content: content,
                timestamp: timestamp,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String contentType,
                required String contentId,
                required String interactionType,
                Value<String?> content = const Value.absent(),
                required DateTime timestamp,
                Value<int> rowid = const Value.absent(),
              }) => SocialInteractionsTableCompanion.insert(
                id: id,
                userId: userId,
                contentType: contentType,
                contentId: contentId,
                interactionType: interactionType,
                content: content,
                timestamp: timestamp,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$SocialInteractionsTableTableReferences(
                            db,
                            table,
                            e,
                          ),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (userId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.userId,
                            referencedTable:
                                $$SocialInteractionsTableTableReferences
                                    ._userIdTable(db),
                            referencedColumn:
                                $$SocialInteractionsTableTableReferences
                                    ._userIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SocialInteractionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SocialInteractionsTableTable,
      SocialInteractionsTableData,
      $$SocialInteractionsTableTableFilterComposer,
      $$SocialInteractionsTableTableOrderingComposer,
      $$SocialInteractionsTableTableAnnotationComposer,
      $$SocialInteractionsTableTableCreateCompanionBuilder,
      $$SocialInteractionsTableTableUpdateCompanionBuilder,
      (SocialInteractionsTableData, $$SocialInteractionsTableTableReferences),
      SocialInteractionsTableData,
      PrefetchHooks Function({bool userId})
    >;
typedef $$SharedContentTableTableCreateCompanionBuilder =
    SharedContentTableCompanion Function({
      required String id,
      required String userId,
      required String contentType,
      required String contentId,
      required String shareType,
      Value<String?> externalPlatform,
      Value<String?> shareUrl,
      required DateTime sharedAt,
      Value<bool> isActive,
      Value<int> rowid,
    });
typedef $$SharedContentTableTableUpdateCompanionBuilder =
    SharedContentTableCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> contentType,
      Value<String> contentId,
      Value<String> shareType,
      Value<String?> externalPlatform,
      Value<String?> shareUrl,
      Value<DateTime> sharedAt,
      Value<bool> isActive,
      Value<int> rowid,
    });

final class $$SharedContentTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $SharedContentTableTable,
          SharedContentTableData
        > {
  $$SharedContentTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UserProfilesTableTable _userIdTable(_$AppDatabase db) =>
      db.userProfilesTable.createAlias(
        $_aliasNameGenerator(
          db.sharedContentTable.userId,
          db.userProfilesTable.id,
        ),
      );

  $$UserProfilesTableTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UserProfilesTableTableTableManager(
      $_db,
      $_db.userProfilesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SharedContentTableTableFilterComposer
    extends Composer<_$AppDatabase, $SharedContentTableTable> {
  $$SharedContentTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shareType => $composableBuilder(
    column: $table.shareType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalPlatform => $composableBuilder(
    column: $table.externalPlatform,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shareUrl => $composableBuilder(
    column: $table.shareUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sharedAt => $composableBuilder(
    column: $table.sharedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  $$UserProfilesTableTableFilterComposer get userId {
    final $$UserProfilesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.userProfilesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableTableFilterComposer(
            $db: $db,
            $table: $db.userProfilesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SharedContentTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SharedContentTableTable> {
  $$SharedContentTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shareType => $composableBuilder(
    column: $table.shareType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalPlatform => $composableBuilder(
    column: $table.externalPlatform,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shareUrl => $composableBuilder(
    column: $table.shareUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sharedAt => $composableBuilder(
    column: $table.sharedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  $$UserProfilesTableTableOrderingComposer get userId {
    final $$UserProfilesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.userProfilesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableTableOrderingComposer(
            $db: $db,
            $table: $db.userProfilesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SharedContentTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SharedContentTableTable> {
  $$SharedContentTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contentId =>
      $composableBuilder(column: $table.contentId, builder: (column) => column);

  GeneratedColumn<String> get shareType =>
      $composableBuilder(column: $table.shareType, builder: (column) => column);

  GeneratedColumn<String> get externalPlatform => $composableBuilder(
    column: $table.externalPlatform,
    builder: (column) => column,
  );

  GeneratedColumn<String> get shareUrl =>
      $composableBuilder(column: $table.shareUrl, builder: (column) => column);

  GeneratedColumn<DateTime> get sharedAt =>
      $composableBuilder(column: $table.sharedAt, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  $$UserProfilesTableTableAnnotationComposer get userId {
    final $$UserProfilesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.userId,
          referencedTable: $db.userProfilesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$UserProfilesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.userProfilesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$SharedContentTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SharedContentTableTable,
          SharedContentTableData,
          $$SharedContentTableTableFilterComposer,
          $$SharedContentTableTableOrderingComposer,
          $$SharedContentTableTableAnnotationComposer,
          $$SharedContentTableTableCreateCompanionBuilder,
          $$SharedContentTableTableUpdateCompanionBuilder,
          (SharedContentTableData, $$SharedContentTableTableReferences),
          SharedContentTableData,
          PrefetchHooks Function({bool userId})
        > {
  $$SharedContentTableTableTableManager(
    _$AppDatabase db,
    $SharedContentTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$SharedContentTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$SharedContentTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$SharedContentTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> contentType = const Value.absent(),
                Value<String> contentId = const Value.absent(),
                Value<String> shareType = const Value.absent(),
                Value<String?> externalPlatform = const Value.absent(),
                Value<String?> shareUrl = const Value.absent(),
                Value<DateTime> sharedAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SharedContentTableCompanion(
                id: id,
                userId: userId,
                contentType: contentType,
                contentId: contentId,
                shareType: shareType,
                externalPlatform: externalPlatform,
                shareUrl: shareUrl,
                sharedAt: sharedAt,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String contentType,
                required String contentId,
                required String shareType,
                Value<String?> externalPlatform = const Value.absent(),
                Value<String?> shareUrl = const Value.absent(),
                required DateTime sharedAt,
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SharedContentTableCompanion.insert(
                id: id,
                userId: userId,
                contentType: contentType,
                contentId: contentId,
                shareType: shareType,
                externalPlatform: externalPlatform,
                shareUrl: shareUrl,
                sharedAt: sharedAt,
                isActive: isActive,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$SharedContentTableTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (userId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.userId,
                            referencedTable: $$SharedContentTableTableReferences
                                ._userIdTable(db),
                            referencedColumn:
                                $$SharedContentTableTableReferences
                                    ._userIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SharedContentTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SharedContentTableTable,
      SharedContentTableData,
      $$SharedContentTableTableFilterComposer,
      $$SharedContentTableTableOrderingComposer,
      $$SharedContentTableTableAnnotationComposer,
      $$SharedContentTableTableCreateCompanionBuilder,
      $$SharedContentTableTableUpdateCompanionBuilder,
      (SharedContentTableData, $$SharedContentTableTableReferences),
      SharedContentTableData,
      PrefetchHooks Function({bool userId})
    >;
typedef $$UserPreferencesTableTableCreateCompanionBuilder =
    UserPreferencesTableCompanion Function({
      required String id,
      required String userId,
      required String preferenceCategory,
      required String preferenceName,
      required String preferenceValue,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$UserPreferencesTableTableUpdateCompanionBuilder =
    UserPreferencesTableCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> preferenceCategory,
      Value<String> preferenceName,
      Value<String> preferenceValue,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$UserPreferencesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $UserPreferencesTableTable,
          UserPreferencesTableData
        > {
  $$UserPreferencesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UserProfilesTableTable _userIdTable(_$AppDatabase db) =>
      db.userProfilesTable.createAlias(
        $_aliasNameGenerator(
          db.userPreferencesTable.userId,
          db.userProfilesTable.id,
        ),
      );

  $$UserProfilesTableTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UserProfilesTableTableTableManager(
      $_db,
      $_db.userProfilesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$UserPreferencesTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserPreferencesTableTable> {
  $$UserPreferencesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preferenceCategory => $composableBuilder(
    column: $table.preferenceCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preferenceName => $composableBuilder(
    column: $table.preferenceName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preferenceValue => $composableBuilder(
    column: $table.preferenceValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UserProfilesTableTableFilterComposer get userId {
    final $$UserProfilesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.userProfilesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableTableFilterComposer(
            $db: $db,
            $table: $db.userProfilesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserPreferencesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserPreferencesTableTable> {
  $$UserPreferencesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferenceCategory => $composableBuilder(
    column: $table.preferenceCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferenceName => $composableBuilder(
    column: $table.preferenceName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferenceValue => $composableBuilder(
    column: $table.preferenceValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UserProfilesTableTableOrderingComposer get userId {
    final $$UserProfilesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.userProfilesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableTableOrderingComposer(
            $db: $db,
            $table: $db.userProfilesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserPreferencesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserPreferencesTableTable> {
  $$UserPreferencesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get preferenceCategory => $composableBuilder(
    column: $table.preferenceCategory,
    builder: (column) => column,
  );

  GeneratedColumn<String> get preferenceName => $composableBuilder(
    column: $table.preferenceName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get preferenceValue => $composableBuilder(
    column: $table.preferenceValue,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$UserProfilesTableTableAnnotationComposer get userId {
    final $$UserProfilesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.userId,
          referencedTable: $db.userProfilesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$UserProfilesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.userProfilesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$UserPreferencesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserPreferencesTableTable,
          UserPreferencesTableData,
          $$UserPreferencesTableTableFilterComposer,
          $$UserPreferencesTableTableOrderingComposer,
          $$UserPreferencesTableTableAnnotationComposer,
          $$UserPreferencesTableTableCreateCompanionBuilder,
          $$UserPreferencesTableTableUpdateCompanionBuilder,
          (UserPreferencesTableData, $$UserPreferencesTableTableReferences),
          UserPreferencesTableData,
          PrefetchHooks Function({bool userId})
        > {
  $$UserPreferencesTableTableTableManager(
    _$AppDatabase db,
    $UserPreferencesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$UserPreferencesTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$UserPreferencesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$UserPreferencesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> preferenceCategory = const Value.absent(),
                Value<String> preferenceName = const Value.absent(),
                Value<String> preferenceValue = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserPreferencesTableCompanion(
                id: id,
                userId: userId,
                preferenceCategory: preferenceCategory,
                preferenceName: preferenceName,
                preferenceValue: preferenceValue,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String preferenceCategory,
                required String preferenceName,
                required String preferenceValue,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => UserPreferencesTableCompanion.insert(
                id: id,
                userId: userId,
                preferenceCategory: preferenceCategory,
                preferenceName: preferenceName,
                preferenceValue: preferenceValue,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$UserPreferencesTableTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (userId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.userId,
                            referencedTable:
                                $$UserPreferencesTableTableReferences
                                    ._userIdTable(db),
                            referencedColumn:
                                $$UserPreferencesTableTableReferences
                                    ._userIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$UserPreferencesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserPreferencesTableTable,
      UserPreferencesTableData,
      $$UserPreferencesTableTableFilterComposer,
      $$UserPreferencesTableTableOrderingComposer,
      $$UserPreferencesTableTableAnnotationComposer,
      $$UserPreferencesTableTableCreateCompanionBuilder,
      $$UserPreferencesTableTableUpdateCompanionBuilder,
      (UserPreferencesTableData, $$UserPreferencesTableTableReferences),
      UserPreferencesTableData,
      PrefetchHooks Function({bool userId})
    >;
typedef $$FeedbackEffectivenessTableTableCreateCompanionBuilder =
    FeedbackEffectivenessTableCompanion Function({
      required String id,
      required String userId,
      required String feedbackType,
      required String drivingBehaviorType,
      Value<int> timesDelivered,
      Value<int> timesBehaviorImproved,
      Value<double> effectivenessRatio,
      required DateTime lastUpdated,
      Value<int> rowid,
    });
typedef $$FeedbackEffectivenessTableTableUpdateCompanionBuilder =
    FeedbackEffectivenessTableCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> feedbackType,
      Value<String> drivingBehaviorType,
      Value<int> timesDelivered,
      Value<int> timesBehaviorImproved,
      Value<double> effectivenessRatio,
      Value<DateTime> lastUpdated,
      Value<int> rowid,
    });

final class $$FeedbackEffectivenessTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $FeedbackEffectivenessTableTable,
          FeedbackEffectivenessTableData
        > {
  $$FeedbackEffectivenessTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UserProfilesTableTable _userIdTable(_$AppDatabase db) =>
      db.userProfilesTable.createAlias(
        $_aliasNameGenerator(
          db.feedbackEffectivenessTable.userId,
          db.userProfilesTable.id,
        ),
      );

  $$UserProfilesTableTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UserProfilesTableTableTableManager(
      $_db,
      $_db.userProfilesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FeedbackEffectivenessTableTableFilterComposer
    extends Composer<_$AppDatabase, $FeedbackEffectivenessTableTable> {
  $$FeedbackEffectivenessTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get feedbackType => $composableBuilder(
    column: $table.feedbackType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get drivingBehaviorType => $composableBuilder(
    column: $table.drivingBehaviorType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timesDelivered => $composableBuilder(
    column: $table.timesDelivered,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timesBehaviorImproved => $composableBuilder(
    column: $table.timesBehaviorImproved,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get effectivenessRatio => $composableBuilder(
    column: $table.effectivenessRatio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnFilters(column),
  );

  $$UserProfilesTableTableFilterComposer get userId {
    final $$UserProfilesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.userProfilesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableTableFilterComposer(
            $db: $db,
            $table: $db.userProfilesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FeedbackEffectivenessTableTableOrderingComposer
    extends Composer<_$AppDatabase, $FeedbackEffectivenessTableTable> {
  $$FeedbackEffectivenessTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get feedbackType => $composableBuilder(
    column: $table.feedbackType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get drivingBehaviorType => $composableBuilder(
    column: $table.drivingBehaviorType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timesDelivered => $composableBuilder(
    column: $table.timesDelivered,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timesBehaviorImproved => $composableBuilder(
    column: $table.timesBehaviorImproved,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get effectivenessRatio => $composableBuilder(
    column: $table.effectivenessRatio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnOrderings(column),
  );

  $$UserProfilesTableTableOrderingComposer get userId {
    final $$UserProfilesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.userProfilesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableTableOrderingComposer(
            $db: $db,
            $table: $db.userProfilesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FeedbackEffectivenessTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $FeedbackEffectivenessTableTable> {
  $$FeedbackEffectivenessTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get feedbackType => $composableBuilder(
    column: $table.feedbackType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get drivingBehaviorType => $composableBuilder(
    column: $table.drivingBehaviorType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timesDelivered => $composableBuilder(
    column: $table.timesDelivered,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timesBehaviorImproved => $composableBuilder(
    column: $table.timesBehaviorImproved,
    builder: (column) => column,
  );

  GeneratedColumn<double> get effectivenessRatio => $composableBuilder(
    column: $table.effectivenessRatio,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => column,
  );

  $$UserProfilesTableTableAnnotationComposer get userId {
    final $$UserProfilesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.userId,
          referencedTable: $db.userProfilesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$UserProfilesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.userProfilesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$FeedbackEffectivenessTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FeedbackEffectivenessTableTable,
          FeedbackEffectivenessTableData,
          $$FeedbackEffectivenessTableTableFilterComposer,
          $$FeedbackEffectivenessTableTableOrderingComposer,
          $$FeedbackEffectivenessTableTableAnnotationComposer,
          $$FeedbackEffectivenessTableTableCreateCompanionBuilder,
          $$FeedbackEffectivenessTableTableUpdateCompanionBuilder,
          (
            FeedbackEffectivenessTableData,
            $$FeedbackEffectivenessTableTableReferences,
          ),
          FeedbackEffectivenessTableData,
          PrefetchHooks Function({bool userId})
        > {
  $$FeedbackEffectivenessTableTableTableManager(
    _$AppDatabase db,
    $FeedbackEffectivenessTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$FeedbackEffectivenessTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$FeedbackEffectivenessTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$FeedbackEffectivenessTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> feedbackType = const Value.absent(),
                Value<String> drivingBehaviorType = const Value.absent(),
                Value<int> timesDelivered = const Value.absent(),
                Value<int> timesBehaviorImproved = const Value.absent(),
                Value<double> effectivenessRatio = const Value.absent(),
                Value<DateTime> lastUpdated = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FeedbackEffectivenessTableCompanion(
                id: id,
                userId: userId,
                feedbackType: feedbackType,
                drivingBehaviorType: drivingBehaviorType,
                timesDelivered: timesDelivered,
                timesBehaviorImproved: timesBehaviorImproved,
                effectivenessRatio: effectivenessRatio,
                lastUpdated: lastUpdated,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String feedbackType,
                required String drivingBehaviorType,
                Value<int> timesDelivered = const Value.absent(),
                Value<int> timesBehaviorImproved = const Value.absent(),
                Value<double> effectivenessRatio = const Value.absent(),
                required DateTime lastUpdated,
                Value<int> rowid = const Value.absent(),
              }) => FeedbackEffectivenessTableCompanion.insert(
                id: id,
                userId: userId,
                feedbackType: feedbackType,
                drivingBehaviorType: drivingBehaviorType,
                timesDelivered: timesDelivered,
                timesBehaviorImproved: timesBehaviorImproved,
                effectivenessRatio: effectivenessRatio,
                lastUpdated: lastUpdated,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$FeedbackEffectivenessTableTableReferences(
                            db,
                            table,
                            e,
                          ),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (userId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.userId,
                            referencedTable:
                                $$FeedbackEffectivenessTableTableReferences
                                    ._userIdTable(db),
                            referencedColumn:
                                $$FeedbackEffectivenessTableTableReferences
                                    ._userIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FeedbackEffectivenessTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FeedbackEffectivenessTableTable,
      FeedbackEffectivenessTableData,
      $$FeedbackEffectivenessTableTableFilterComposer,
      $$FeedbackEffectivenessTableTableOrderingComposer,
      $$FeedbackEffectivenessTableTableAnnotationComposer,
      $$FeedbackEffectivenessTableTableCreateCompanionBuilder,
      $$FeedbackEffectivenessTableTableUpdateCompanionBuilder,
      (
        FeedbackEffectivenessTableData,
        $$FeedbackEffectivenessTableTableReferences,
      ),
      FeedbackEffectivenessTableData,
      PrefetchHooks Function({bool userId})
    >;
typedef $$ChallengesTableTableCreateCompanionBuilder =
    ChallengesTableCompanion Function({
      required String id,
      required String title,
      required String description,
      required String type,
      required int targetValue,
      required String metricType,
      Value<bool> isSystem,
      Value<String?> creatorId,
      Value<bool> isActive,
      Value<int> difficultyLevel,
      Value<String?> iconName,
      Value<String?> rewardType,
      Value<int> rewardValue,
      Value<int> rowid,
    });
typedef $$ChallengesTableTableUpdateCompanionBuilder =
    ChallengesTableCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> description,
      Value<String> type,
      Value<int> targetValue,
      Value<String> metricType,
      Value<bool> isSystem,
      Value<String?> creatorId,
      Value<bool> isActive,
      Value<int> difficultyLevel,
      Value<String?> iconName,
      Value<String?> rewardType,
      Value<int> rewardValue,
      Value<int> rowid,
    });

final class $$ChallengesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ChallengesTableTable,
          ChallengesTableData
        > {
  $$ChallengesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UserProfilesTableTable _creatorIdTable(_$AppDatabase db) =>
      db.userProfilesTable.createAlias(
        $_aliasNameGenerator(
          db.challengesTable.creatorId,
          db.userProfilesTable.id,
        ),
      );

  $$UserProfilesTableTableProcessedTableManager? get creatorId {
    final $_column = $_itemColumn<String>('creator_id');
    if ($_column == null) return null;
    final manager = $$UserProfilesTableTableTableManager(
      $_db,
      $_db.userProfilesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_creatorIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $UserChallengesTableTable,
    List<UserChallengesTableData>
  >
  _userChallengesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.userChallengesTable,
        aliasName: $_aliasNameGenerator(
          db.challengesTable.id,
          db.userChallengesTable.challengeId,
        ),
      );

  $$UserChallengesTableTableProcessedTableManager get userChallengesTableRefs {
    final manager = $$UserChallengesTableTableTableManager(
      $_db,
      $_db.userChallengesTable,
    ).filter((f) => f.challengeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _userChallengesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ChallengesTableTableFilterComposer
    extends Composer<_$AppDatabase, $ChallengesTableTable> {
  $$ChallengesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metricType => $composableBuilder(
    column: $table.metricType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get difficultyLevel => $composableBuilder(
    column: $table.difficultyLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconName => $composableBuilder(
    column: $table.iconName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rewardType => $composableBuilder(
    column: $table.rewardType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rewardValue => $composableBuilder(
    column: $table.rewardValue,
    builder: (column) => ColumnFilters(column),
  );

  $$UserProfilesTableTableFilterComposer get creatorId {
    final $$UserProfilesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.creatorId,
      referencedTable: $db.userProfilesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableTableFilterComposer(
            $db: $db,
            $table: $db.userProfilesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> userChallengesTableRefs(
    Expression<bool> Function($$UserChallengesTableTableFilterComposer f) f,
  ) {
    final $$UserChallengesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userChallengesTable,
      getReferencedColumn: (t) => t.challengeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserChallengesTableTableFilterComposer(
            $db: $db,
            $table: $db.userChallengesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChallengesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ChallengesTableTable> {
  $$ChallengesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metricType => $composableBuilder(
    column: $table.metricType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get difficultyLevel => $composableBuilder(
    column: $table.difficultyLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconName => $composableBuilder(
    column: $table.iconName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rewardType => $composableBuilder(
    column: $table.rewardType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rewardValue => $composableBuilder(
    column: $table.rewardValue,
    builder: (column) => ColumnOrderings(column),
  );

  $$UserProfilesTableTableOrderingComposer get creatorId {
    final $$UserProfilesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.creatorId,
      referencedTable: $db.userProfilesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableTableOrderingComposer(
            $db: $db,
            $table: $db.userProfilesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChallengesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChallengesTableTable> {
  $$ChallengesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get metricType => $composableBuilder(
    column: $table.metricType,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSystem =>
      $composableBuilder(column: $table.isSystem, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get difficultyLevel => $composableBuilder(
    column: $table.difficultyLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get iconName =>
      $composableBuilder(column: $table.iconName, builder: (column) => column);

  GeneratedColumn<String> get rewardType => $composableBuilder(
    column: $table.rewardType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rewardValue => $composableBuilder(
    column: $table.rewardValue,
    builder: (column) => column,
  );

  $$UserProfilesTableTableAnnotationComposer get creatorId {
    final $$UserProfilesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.creatorId,
          referencedTable: $db.userProfilesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$UserProfilesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.userProfilesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> userChallengesTableRefs<T extends Object>(
    Expression<T> Function($$UserChallengesTableTableAnnotationComposer a) f,
  ) {
    final $$UserChallengesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.userChallengesTable,
          getReferencedColumn: (t) => t.challengeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$UserChallengesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.userChallengesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ChallengesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChallengesTableTable,
          ChallengesTableData,
          $$ChallengesTableTableFilterComposer,
          $$ChallengesTableTableOrderingComposer,
          $$ChallengesTableTableAnnotationComposer,
          $$ChallengesTableTableCreateCompanionBuilder,
          $$ChallengesTableTableUpdateCompanionBuilder,
          (ChallengesTableData, $$ChallengesTableTableReferences),
          ChallengesTableData,
          PrefetchHooks Function({bool creatorId, bool userChallengesTableRefs})
        > {
  $$ChallengesTableTableTableManager(
    _$AppDatabase db,
    $ChallengesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$ChallengesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$ChallengesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$ChallengesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> targetValue = const Value.absent(),
                Value<String> metricType = const Value.absent(),
                Value<bool> isSystem = const Value.absent(),
                Value<String?> creatorId = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> difficultyLevel = const Value.absent(),
                Value<String?> iconName = const Value.absent(),
                Value<String?> rewardType = const Value.absent(),
                Value<int> rewardValue = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChallengesTableCompanion(
                id: id,
                title: title,
                description: description,
                type: type,
                targetValue: targetValue,
                metricType: metricType,
                isSystem: isSystem,
                creatorId: creatorId,
                isActive: isActive,
                difficultyLevel: difficultyLevel,
                iconName: iconName,
                rewardType: rewardType,
                rewardValue: rewardValue,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String description,
                required String type,
                required int targetValue,
                required String metricType,
                Value<bool> isSystem = const Value.absent(),
                Value<String?> creatorId = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> difficultyLevel = const Value.absent(),
                Value<String?> iconName = const Value.absent(),
                Value<String?> rewardType = const Value.absent(),
                Value<int> rewardValue = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChallengesTableCompanion.insert(
                id: id,
                title: title,
                description: description,
                type: type,
                targetValue: targetValue,
                metricType: metricType,
                isSystem: isSystem,
                creatorId: creatorId,
                isActive: isActive,
                difficultyLevel: difficultyLevel,
                iconName: iconName,
                rewardType: rewardType,
                rewardValue: rewardValue,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$ChallengesTableTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            creatorId = false,
            userChallengesTableRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (userChallengesTableRefs) db.userChallengesTable,
              ],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (creatorId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.creatorId,
                            referencedTable: $$ChallengesTableTableReferences
                                ._creatorIdTable(db),
                            referencedColumn:
                                $$ChallengesTableTableReferences
                                    ._creatorIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (userChallengesTableRefs)
                    await $_getPrefetchedData<
                      ChallengesTableData,
                      $ChallengesTableTable,
                      UserChallengesTableData
                    >(
                      currentTable: table,
                      referencedTable: $$ChallengesTableTableReferences
                          ._userChallengesTableRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$ChallengesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).userChallengesTableRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.challengeId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ChallengesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChallengesTableTable,
      ChallengesTableData,
      $$ChallengesTableTableFilterComposer,
      $$ChallengesTableTableOrderingComposer,
      $$ChallengesTableTableAnnotationComposer,
      $$ChallengesTableTableCreateCompanionBuilder,
      $$ChallengesTableTableUpdateCompanionBuilder,
      (ChallengesTableData, $$ChallengesTableTableReferences),
      ChallengesTableData,
      PrefetchHooks Function({bool creatorId, bool userChallengesTableRefs})
    >;
typedef $$UserChallengesTableTableCreateCompanionBuilder =
    UserChallengesTableCompanion Function({
      required String id,
      required String userId,
      required String challengeId,
      required DateTime startedAt,
      Value<DateTime?> completedAt,
      Value<int> progress,
      Value<bool> isCompleted,
      Value<bool> rewardClaimed,
      Value<int> rowid,
    });
typedef $$UserChallengesTableTableUpdateCompanionBuilder =
    UserChallengesTableCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> challengeId,
      Value<DateTime> startedAt,
      Value<DateTime?> completedAt,
      Value<int> progress,
      Value<bool> isCompleted,
      Value<bool> rewardClaimed,
      Value<int> rowid,
    });

final class $$UserChallengesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $UserChallengesTableTable,
          UserChallengesTableData
        > {
  $$UserChallengesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UserProfilesTableTable _userIdTable(_$AppDatabase db) =>
      db.userProfilesTable.createAlias(
        $_aliasNameGenerator(
          db.userChallengesTable.userId,
          db.userProfilesTable.id,
        ),
      );

  $$UserProfilesTableTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UserProfilesTableTableTableManager(
      $_db,
      $_db.userProfilesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ChallengesTableTable _challengeIdTable(_$AppDatabase db) =>
      db.challengesTable.createAlias(
        $_aliasNameGenerator(
          db.userChallengesTable.challengeId,
          db.challengesTable.id,
        ),
      );

  $$ChallengesTableTableProcessedTableManager get challengeId {
    final $_column = $_itemColumn<String>('challenge_id')!;

    final manager = $$ChallengesTableTableTableManager(
      $_db,
      $_db.challengesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_challengeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$UserChallengesTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserChallengesTableTable> {
  $$UserChallengesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get rewardClaimed => $composableBuilder(
    column: $table.rewardClaimed,
    builder: (column) => ColumnFilters(column),
  );

  $$UserProfilesTableTableFilterComposer get userId {
    final $$UserProfilesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.userProfilesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableTableFilterComposer(
            $db: $db,
            $table: $db.userProfilesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ChallengesTableTableFilterComposer get challengeId {
    final $$ChallengesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.challengeId,
      referencedTable: $db.challengesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChallengesTableTableFilterComposer(
            $db: $db,
            $table: $db.challengesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserChallengesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserChallengesTableTable> {
  $$UserChallengesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get rewardClaimed => $composableBuilder(
    column: $table.rewardClaimed,
    builder: (column) => ColumnOrderings(column),
  );

  $$UserProfilesTableTableOrderingComposer get userId {
    final $$UserProfilesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.userProfilesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableTableOrderingComposer(
            $db: $db,
            $table: $db.userProfilesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ChallengesTableTableOrderingComposer get challengeId {
    final $$ChallengesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.challengeId,
      referencedTable: $db.challengesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChallengesTableTableOrderingComposer(
            $db: $db,
            $table: $db.challengesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserChallengesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserChallengesTableTable> {
  $$UserChallengesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get rewardClaimed => $composableBuilder(
    column: $table.rewardClaimed,
    builder: (column) => column,
  );

  $$UserProfilesTableTableAnnotationComposer get userId {
    final $$UserProfilesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.userId,
          referencedTable: $db.userProfilesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$UserProfilesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.userProfilesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$ChallengesTableTableAnnotationComposer get challengeId {
    final $$ChallengesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.challengeId,
      referencedTable: $db.challengesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChallengesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.challengesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserChallengesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserChallengesTableTable,
          UserChallengesTableData,
          $$UserChallengesTableTableFilterComposer,
          $$UserChallengesTableTableOrderingComposer,
          $$UserChallengesTableTableAnnotationComposer,
          $$UserChallengesTableTableCreateCompanionBuilder,
          $$UserChallengesTableTableUpdateCompanionBuilder,
          (UserChallengesTableData, $$UserChallengesTableTableReferences),
          UserChallengesTableData,
          PrefetchHooks Function({bool userId, bool challengeId})
        > {
  $$UserChallengesTableTableTableManager(
    _$AppDatabase db,
    $UserChallengesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$UserChallengesTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$UserChallengesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$UserChallengesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> challengeId = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> progress = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<bool> rewardClaimed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserChallengesTableCompanion(
                id: id,
                userId: userId,
                challengeId: challengeId,
                startedAt: startedAt,
                completedAt: completedAt,
                progress: progress,
                isCompleted: isCompleted,
                rewardClaimed: rewardClaimed,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String challengeId,
                required DateTime startedAt,
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> progress = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<bool> rewardClaimed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserChallengesTableCompanion.insert(
                id: id,
                userId: userId,
                challengeId: challengeId,
                startedAt: startedAt,
                completedAt: completedAt,
                progress: progress,
                isCompleted: isCompleted,
                rewardClaimed: rewardClaimed,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$UserChallengesTableTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({userId = false, challengeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (userId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.userId,
                            referencedTable:
                                $$UserChallengesTableTableReferences
                                    ._userIdTable(db),
                            referencedColumn:
                                $$UserChallengesTableTableReferences
                                    ._userIdTable(db)
                                    .id,
                          )
                          as T;
                }
                if (challengeId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.challengeId,
                            referencedTable:
                                $$UserChallengesTableTableReferences
                                    ._challengeIdTable(db),
                            referencedColumn:
                                $$UserChallengesTableTableReferences
                                    ._challengeIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$UserChallengesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserChallengesTableTable,
      UserChallengesTableData,
      $$UserChallengesTableTableFilterComposer,
      $$UserChallengesTableTableOrderingComposer,
      $$UserChallengesTableTableAnnotationComposer,
      $$UserChallengesTableTableCreateCompanionBuilder,
      $$UserChallengesTableTableUpdateCompanionBuilder,
      (UserChallengesTableData, $$UserChallengesTableTableReferences),
      UserChallengesTableData,
      PrefetchHooks Function({bool userId, bool challengeId})
    >;
typedef $$StreaksTableTableCreateCompanionBuilder =
    StreaksTableCompanion Function({
      required String id,
      required String userId,
      required String streakType,
      Value<int> currentCount,
      Value<int> bestCount,
      required DateTime lastRecorded,
      required DateTime nextDue,
      Value<bool> isActive,
      Value<int> rowid,
    });
typedef $$StreaksTableTableUpdateCompanionBuilder =
    StreaksTableCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> streakType,
      Value<int> currentCount,
      Value<int> bestCount,
      Value<DateTime> lastRecorded,
      Value<DateTime> nextDue,
      Value<bool> isActive,
      Value<int> rowid,
    });

final class $$StreaksTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $StreaksTableTable, StreaksTableData> {
  $$StreaksTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UserProfilesTableTable _userIdTable(_$AppDatabase db) =>
      db.userProfilesTable.createAlias(
        $_aliasNameGenerator(db.streaksTable.userId, db.userProfilesTable.id),
      );

  $$UserProfilesTableTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UserProfilesTableTableTableManager(
      $_db,
      $_db.userProfilesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StreaksTableTableFilterComposer
    extends Composer<_$AppDatabase, $StreaksTableTable> {
  $$StreaksTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get streakType => $composableBuilder(
    column: $table.streakType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentCount => $composableBuilder(
    column: $table.currentCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bestCount => $composableBuilder(
    column: $table.bestCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastRecorded => $composableBuilder(
    column: $table.lastRecorded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextDue => $composableBuilder(
    column: $table.nextDue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  $$UserProfilesTableTableFilterComposer get userId {
    final $$UserProfilesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.userProfilesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableTableFilterComposer(
            $db: $db,
            $table: $db.userProfilesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StreaksTableTableOrderingComposer
    extends Composer<_$AppDatabase, $StreaksTableTable> {
  $$StreaksTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get streakType => $composableBuilder(
    column: $table.streakType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentCount => $composableBuilder(
    column: $table.currentCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bestCount => $composableBuilder(
    column: $table.bestCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastRecorded => $composableBuilder(
    column: $table.lastRecorded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextDue => $composableBuilder(
    column: $table.nextDue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  $$UserProfilesTableTableOrderingComposer get userId {
    final $$UserProfilesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.userProfilesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableTableOrderingComposer(
            $db: $db,
            $table: $db.userProfilesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StreaksTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $StreaksTableTable> {
  $$StreaksTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get streakType => $composableBuilder(
    column: $table.streakType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentCount => $composableBuilder(
    column: $table.currentCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bestCount =>
      $composableBuilder(column: $table.bestCount, builder: (column) => column);

  GeneratedColumn<DateTime> get lastRecorded => $composableBuilder(
    column: $table.lastRecorded,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextDue =>
      $composableBuilder(column: $table.nextDue, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  $$UserProfilesTableTableAnnotationComposer get userId {
    final $$UserProfilesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.userId,
          referencedTable: $db.userProfilesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$UserProfilesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.userProfilesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$StreaksTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StreaksTableTable,
          StreaksTableData,
          $$StreaksTableTableFilterComposer,
          $$StreaksTableTableOrderingComposer,
          $$StreaksTableTableAnnotationComposer,
          $$StreaksTableTableCreateCompanionBuilder,
          $$StreaksTableTableUpdateCompanionBuilder,
          (StreaksTableData, $$StreaksTableTableReferences),
          StreaksTableData,
          PrefetchHooks Function({bool userId})
        > {
  $$StreaksTableTableTableManager(_$AppDatabase db, $StreaksTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$StreaksTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$StreaksTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$StreaksTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> streakType = const Value.absent(),
                Value<int> currentCount = const Value.absent(),
                Value<int> bestCount = const Value.absent(),
                Value<DateTime> lastRecorded = const Value.absent(),
                Value<DateTime> nextDue = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StreaksTableCompanion(
                id: id,
                userId: userId,
                streakType: streakType,
                currentCount: currentCount,
                bestCount: bestCount,
                lastRecorded: lastRecorded,
                nextDue: nextDue,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String streakType,
                Value<int> currentCount = const Value.absent(),
                Value<int> bestCount = const Value.absent(),
                required DateTime lastRecorded,
                required DateTime nextDue,
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StreaksTableCompanion.insert(
                id: id,
                userId: userId,
                streakType: streakType,
                currentCount: currentCount,
                bestCount: bestCount,
                lastRecorded: lastRecorded,
                nextDue: nextDue,
                isActive: isActive,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$StreaksTableTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (userId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.userId,
                            referencedTable: $$StreaksTableTableReferences
                                ._userIdTable(db),
                            referencedColumn:
                                $$StreaksTableTableReferences
                                    ._userIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StreaksTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StreaksTableTable,
      StreaksTableData,
      $$StreaksTableTableFilterComposer,
      $$StreaksTableTableOrderingComposer,
      $$StreaksTableTableAnnotationComposer,
      $$StreaksTableTableCreateCompanionBuilder,
      $$StreaksTableTableUpdateCompanionBuilder,
      (StreaksTableData, $$StreaksTableTableReferences),
      StreaksTableData,
      PrefetchHooks Function({bool userId})
    >;
typedef $$LeaderboardEntriesTableTableCreateCompanionBuilder =
    LeaderboardEntriesTableCompanion Function({
      required String id,
      required String leaderboardType,
      required String timeframe,
      required String userId,
      Value<String?> regionCode,
      required int rank,
      required int score,
      required DateTime recordedAt,
      Value<int> daysRetained,
      Value<int> rowid,
    });
typedef $$LeaderboardEntriesTableTableUpdateCompanionBuilder =
    LeaderboardEntriesTableCompanion Function({
      Value<String> id,
      Value<String> leaderboardType,
      Value<String> timeframe,
      Value<String> userId,
      Value<String?> regionCode,
      Value<int> rank,
      Value<int> score,
      Value<DateTime> recordedAt,
      Value<int> daysRetained,
      Value<int> rowid,
    });

final class $$LeaderboardEntriesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $LeaderboardEntriesTableTable,
          LeaderboardEntriesTableData
        > {
  $$LeaderboardEntriesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UserProfilesTableTable _userIdTable(_$AppDatabase db) =>
      db.userProfilesTable.createAlias(
        $_aliasNameGenerator(
          db.leaderboardEntriesTable.userId,
          db.userProfilesTable.id,
        ),
      );

  $$UserProfilesTableTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UserProfilesTableTableTableManager(
      $_db,
      $_db.userProfilesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LeaderboardEntriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $LeaderboardEntriesTableTable> {
  $$LeaderboardEntriesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get leaderboardType => $composableBuilder(
    column: $table.leaderboardType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timeframe => $composableBuilder(
    column: $table.timeframe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get regionCode => $composableBuilder(
    column: $table.regionCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rank => $composableBuilder(
    column: $table.rank,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get daysRetained => $composableBuilder(
    column: $table.daysRetained,
    builder: (column) => ColumnFilters(column),
  );

  $$UserProfilesTableTableFilterComposer get userId {
    final $$UserProfilesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.userProfilesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableTableFilterComposer(
            $db: $db,
            $table: $db.userProfilesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LeaderboardEntriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LeaderboardEntriesTableTable> {
  $$LeaderboardEntriesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get leaderboardType => $composableBuilder(
    column: $table.leaderboardType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timeframe => $composableBuilder(
    column: $table.timeframe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get regionCode => $composableBuilder(
    column: $table.regionCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rank => $composableBuilder(
    column: $table.rank,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get daysRetained => $composableBuilder(
    column: $table.daysRetained,
    builder: (column) => ColumnOrderings(column),
  );

  $$UserProfilesTableTableOrderingComposer get userId {
    final $$UserProfilesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.userProfilesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableTableOrderingComposer(
            $db: $db,
            $table: $db.userProfilesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LeaderboardEntriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LeaderboardEntriesTableTable> {
  $$LeaderboardEntriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get leaderboardType => $composableBuilder(
    column: $table.leaderboardType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get timeframe =>
      $composableBuilder(column: $table.timeframe, builder: (column) => column);

  GeneratedColumn<String> get regionCode => $composableBuilder(
    column: $table.regionCode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rank =>
      $composableBuilder(column: $table.rank, builder: (column) => column);

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get daysRetained => $composableBuilder(
    column: $table.daysRetained,
    builder: (column) => column,
  );

  $$UserProfilesTableTableAnnotationComposer get userId {
    final $$UserProfilesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.userId,
          referencedTable: $db.userProfilesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$UserProfilesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.userProfilesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$LeaderboardEntriesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LeaderboardEntriesTableTable,
          LeaderboardEntriesTableData,
          $$LeaderboardEntriesTableTableFilterComposer,
          $$LeaderboardEntriesTableTableOrderingComposer,
          $$LeaderboardEntriesTableTableAnnotationComposer,
          $$LeaderboardEntriesTableTableCreateCompanionBuilder,
          $$LeaderboardEntriesTableTableUpdateCompanionBuilder,
          (
            LeaderboardEntriesTableData,
            $$LeaderboardEntriesTableTableReferences,
          ),
          LeaderboardEntriesTableData,
          PrefetchHooks Function({bool userId})
        > {
  $$LeaderboardEntriesTableTableTableManager(
    _$AppDatabase db,
    $LeaderboardEntriesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$LeaderboardEntriesTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$LeaderboardEntriesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$LeaderboardEntriesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> leaderboardType = const Value.absent(),
                Value<String> timeframe = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String?> regionCode = const Value.absent(),
                Value<int> rank = const Value.absent(),
                Value<int> score = const Value.absent(),
                Value<DateTime> recordedAt = const Value.absent(),
                Value<int> daysRetained = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LeaderboardEntriesTableCompanion(
                id: id,
                leaderboardType: leaderboardType,
                timeframe: timeframe,
                userId: userId,
                regionCode: regionCode,
                rank: rank,
                score: score,
                recordedAt: recordedAt,
                daysRetained: daysRetained,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String leaderboardType,
                required String timeframe,
                required String userId,
                Value<String?> regionCode = const Value.absent(),
                required int rank,
                required int score,
                required DateTime recordedAt,
                Value<int> daysRetained = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LeaderboardEntriesTableCompanion.insert(
                id: id,
                leaderboardType: leaderboardType,
                timeframe: timeframe,
                userId: userId,
                regionCode: regionCode,
                rank: rank,
                score: score,
                recordedAt: recordedAt,
                daysRetained: daysRetained,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$LeaderboardEntriesTableTableReferences(
                            db,
                            table,
                            e,
                          ),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (userId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.userId,
                            referencedTable:
                                $$LeaderboardEntriesTableTableReferences
                                    ._userIdTable(db),
                            referencedColumn:
                                $$LeaderboardEntriesTableTableReferences
                                    ._userIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LeaderboardEntriesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LeaderboardEntriesTableTable,
      LeaderboardEntriesTableData,
      $$LeaderboardEntriesTableTableFilterComposer,
      $$LeaderboardEntriesTableTableOrderingComposer,
      $$LeaderboardEntriesTableTableAnnotationComposer,
      $$LeaderboardEntriesTableTableCreateCompanionBuilder,
      $$LeaderboardEntriesTableTableUpdateCompanionBuilder,
      (LeaderboardEntriesTableData, $$LeaderboardEntriesTableTableReferences),
      LeaderboardEntriesTableData,
      PrefetchHooks Function({bool userId})
    >;
typedef $$ExternalIntegrationsTableTableCreateCompanionBuilder =
    ExternalIntegrationsTableCompanion Function({
      required String id,
      required String userId,
      required String platformType,
      Value<String?> externalId,
      required String integrationStatus,
      required DateTime connectedAt,
      Value<DateTime?> lastSyncAt,
      Value<String?> accessToken,
      Value<String?> refreshToken,
      Value<String?> integrationDataJson,
      Value<int> rowid,
    });
typedef $$ExternalIntegrationsTableTableUpdateCompanionBuilder =
    ExternalIntegrationsTableCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> platformType,
      Value<String?> externalId,
      Value<String> integrationStatus,
      Value<DateTime> connectedAt,
      Value<DateTime?> lastSyncAt,
      Value<String?> accessToken,
      Value<String?> refreshToken,
      Value<String?> integrationDataJson,
      Value<int> rowid,
    });

final class $$ExternalIntegrationsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ExternalIntegrationsTableTable,
          ExternalIntegrationsTableData
        > {
  $$ExternalIntegrationsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UserProfilesTableTable _userIdTable(_$AppDatabase db) =>
      db.userProfilesTable.createAlias(
        $_aliasNameGenerator(
          db.externalIntegrationsTable.userId,
          db.userProfilesTable.id,
        ),
      );

  $$UserProfilesTableTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UserProfilesTableTableTableManager(
      $_db,
      $_db.userProfilesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExternalIntegrationsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ExternalIntegrationsTableTable> {
  $$ExternalIntegrationsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get platformType => $composableBuilder(
    column: $table.platformType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get integrationStatus => $composableBuilder(
    column: $table.integrationStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get connectedAt => $composableBuilder(
    column: $table.connectedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accessToken => $composableBuilder(
    column: $table.accessToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get refreshToken => $composableBuilder(
    column: $table.refreshToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get integrationDataJson => $composableBuilder(
    column: $table.integrationDataJson,
    builder: (column) => ColumnFilters(column),
  );

  $$UserProfilesTableTableFilterComposer get userId {
    final $$UserProfilesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.userProfilesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableTableFilterComposer(
            $db: $db,
            $table: $db.userProfilesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExternalIntegrationsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ExternalIntegrationsTableTable> {
  $$ExternalIntegrationsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get platformType => $composableBuilder(
    column: $table.platformType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get integrationStatus => $composableBuilder(
    column: $table.integrationStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get connectedAt => $composableBuilder(
    column: $table.connectedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accessToken => $composableBuilder(
    column: $table.accessToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get refreshToken => $composableBuilder(
    column: $table.refreshToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get integrationDataJson => $composableBuilder(
    column: $table.integrationDataJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$UserProfilesTableTableOrderingComposer get userId {
    final $$UserProfilesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.userProfilesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableTableOrderingComposer(
            $db: $db,
            $table: $db.userProfilesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExternalIntegrationsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExternalIntegrationsTableTable> {
  $$ExternalIntegrationsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get platformType => $composableBuilder(
    column: $table.platformType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get integrationStatus => $composableBuilder(
    column: $table.integrationStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get connectedAt => $composableBuilder(
    column: $table.connectedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accessToken => $composableBuilder(
    column: $table.accessToken,
    builder: (column) => column,
  );

  GeneratedColumn<String> get refreshToken => $composableBuilder(
    column: $table.refreshToken,
    builder: (column) => column,
  );

  GeneratedColumn<String> get integrationDataJson => $composableBuilder(
    column: $table.integrationDataJson,
    builder: (column) => column,
  );

  $$UserProfilesTableTableAnnotationComposer get userId {
    final $$UserProfilesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.userId,
          referencedTable: $db.userProfilesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$UserProfilesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.userProfilesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ExternalIntegrationsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExternalIntegrationsTableTable,
          ExternalIntegrationsTableData,
          $$ExternalIntegrationsTableTableFilterComposer,
          $$ExternalIntegrationsTableTableOrderingComposer,
          $$ExternalIntegrationsTableTableAnnotationComposer,
          $$ExternalIntegrationsTableTableCreateCompanionBuilder,
          $$ExternalIntegrationsTableTableUpdateCompanionBuilder,
          (
            ExternalIntegrationsTableData,
            $$ExternalIntegrationsTableTableReferences,
          ),
          ExternalIntegrationsTableData,
          PrefetchHooks Function({bool userId})
        > {
  $$ExternalIntegrationsTableTableTableManager(
    _$AppDatabase db,
    $ExternalIntegrationsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ExternalIntegrationsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$ExternalIntegrationsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$ExternalIntegrationsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> platformType = const Value.absent(),
                Value<String?> externalId = const Value.absent(),
                Value<String> integrationStatus = const Value.absent(),
                Value<DateTime> connectedAt = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<String?> accessToken = const Value.absent(),
                Value<String?> refreshToken = const Value.absent(),
                Value<String?> integrationDataJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExternalIntegrationsTableCompanion(
                id: id,
                userId: userId,
                platformType: platformType,
                externalId: externalId,
                integrationStatus: integrationStatus,
                connectedAt: connectedAt,
                lastSyncAt: lastSyncAt,
                accessToken: accessToken,
                refreshToken: refreshToken,
                integrationDataJson: integrationDataJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String platformType,
                Value<String?> externalId = const Value.absent(),
                required String integrationStatus,
                required DateTime connectedAt,
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<String?> accessToken = const Value.absent(),
                Value<String?> refreshToken = const Value.absent(),
                Value<String?> integrationDataJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExternalIntegrationsTableCompanion.insert(
                id: id,
                userId: userId,
                platformType: platformType,
                externalId: externalId,
                integrationStatus: integrationStatus,
                connectedAt: connectedAt,
                lastSyncAt: lastSyncAt,
                accessToken: accessToken,
                refreshToken: refreshToken,
                integrationDataJson: integrationDataJson,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$ExternalIntegrationsTableTableReferences(
                            db,
                            table,
                            e,
                          ),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (userId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.userId,
                            referencedTable:
                                $$ExternalIntegrationsTableTableReferences
                                    ._userIdTable(db),
                            referencedColumn:
                                $$ExternalIntegrationsTableTableReferences
                                    ._userIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ExternalIntegrationsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExternalIntegrationsTableTable,
      ExternalIntegrationsTableData,
      $$ExternalIntegrationsTableTableFilterComposer,
      $$ExternalIntegrationsTableTableOrderingComposer,
      $$ExternalIntegrationsTableTableAnnotationComposer,
      $$ExternalIntegrationsTableTableCreateCompanionBuilder,
      $$ExternalIntegrationsTableTableUpdateCompanionBuilder,
      (
        ExternalIntegrationsTableData,
        $$ExternalIntegrationsTableTableReferences,
      ),
      ExternalIntegrationsTableData,
      PrefetchHooks Function({bool userId})
    >;
typedef $$SyncStatusTableTableCreateCompanionBuilder =
    SyncStatusTableCompanion Function({
      required String id,
      required String userId,
      required String entityType,
      required String entityId,
      Value<String?> targetPlatform,
      required String syncStatus,
      Value<DateTime?> lastAttemptAt,
      Value<int> retryCount,
      Value<String?> errorMessage,
      Value<int> rowid,
    });
typedef $$SyncStatusTableTableUpdateCompanionBuilder =
    SyncStatusTableCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> entityType,
      Value<String> entityId,
      Value<String?> targetPlatform,
      Value<String> syncStatus,
      Value<DateTime?> lastAttemptAt,
      Value<int> retryCount,
      Value<String?> errorMessage,
      Value<int> rowid,
    });

final class $$SyncStatusTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $SyncStatusTableTable,
          SyncStatusTableData
        > {
  $$SyncStatusTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UserProfilesTableTable _userIdTable(_$AppDatabase db) =>
      db.userProfilesTable.createAlias(
        $_aliasNameGenerator(
          db.syncStatusTable.userId,
          db.userProfilesTable.id,
        ),
      );

  $$UserProfilesTableTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UserProfilesTableTableTableManager(
      $_db,
      $_db.userProfilesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SyncStatusTableTableFilterComposer
    extends Composer<_$AppDatabase, $SyncStatusTableTable> {
  $$SyncStatusTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetPlatform => $composableBuilder(
    column: $table.targetPlatform,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnFilters(column),
  );

  $$UserProfilesTableTableFilterComposer get userId {
    final $$UserProfilesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.userProfilesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableTableFilterComposer(
            $db: $db,
            $table: $db.userProfilesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SyncStatusTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncStatusTableTable> {
  $$SyncStatusTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetPlatform => $composableBuilder(
    column: $table.targetPlatform,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnOrderings(column),
  );

  $$UserProfilesTableTableOrderingComposer get userId {
    final $$UserProfilesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.userProfilesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableTableOrderingComposer(
            $db: $db,
            $table: $db.userProfilesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SyncStatusTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncStatusTableTable> {
  $$SyncStatusTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get targetPlatform => $composableBuilder(
    column: $table.targetPlatform,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => column,
  );

  $$UserProfilesTableTableAnnotationComposer get userId {
    final $$UserProfilesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.userId,
          referencedTable: $db.userProfilesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$UserProfilesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.userProfilesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$SyncStatusTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncStatusTableTable,
          SyncStatusTableData,
          $$SyncStatusTableTableFilterComposer,
          $$SyncStatusTableTableOrderingComposer,
          $$SyncStatusTableTableAnnotationComposer,
          $$SyncStatusTableTableCreateCompanionBuilder,
          $$SyncStatusTableTableUpdateCompanionBuilder,
          (SyncStatusTableData, $$SyncStatusTableTableReferences),
          SyncStatusTableData,
          PrefetchHooks Function({bool userId})
        > {
  $$SyncStatusTableTableTableManager(
    _$AppDatabase db,
    $SyncStatusTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$SyncStatusTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$SyncStatusTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$SyncStatusTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String?> targetPlatform = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> lastAttemptAt = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncStatusTableCompanion(
                id: id,
                userId: userId,
                entityType: entityType,
                entityId: entityId,
                targetPlatform: targetPlatform,
                syncStatus: syncStatus,
                lastAttemptAt: lastAttemptAt,
                retryCount: retryCount,
                errorMessage: errorMessage,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String entityType,
                required String entityId,
                Value<String?> targetPlatform = const Value.absent(),
                required String syncStatus,
                Value<DateTime?> lastAttemptAt = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncStatusTableCompanion.insert(
                id: id,
                userId: userId,
                entityType: entityType,
                entityId: entityId,
                targetPlatform: targetPlatform,
                syncStatus: syncStatus,
                lastAttemptAt: lastAttemptAt,
                retryCount: retryCount,
                errorMessage: errorMessage,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$SyncStatusTableTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (userId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.userId,
                            referencedTable: $$SyncStatusTableTableReferences
                                ._userIdTable(db),
                            referencedColumn:
                                $$SyncStatusTableTableReferences
                                    ._userIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SyncStatusTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncStatusTableTable,
      SyncStatusTableData,
      $$SyncStatusTableTableFilterComposer,
      $$SyncStatusTableTableOrderingComposer,
      $$SyncStatusTableTableAnnotationComposer,
      $$SyncStatusTableTableCreateCompanionBuilder,
      $$SyncStatusTableTableUpdateCompanionBuilder,
      (SyncStatusTableData, $$SyncStatusTableTableReferences),
      SyncStatusTableData,
      PrefetchHooks Function({bool userId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TripsTableTableTableManager get tripsTable =>
      $$TripsTableTableTableManager(_db, _db.tripsTable);
  $$TripDataPointsTableTableTableManager get tripDataPointsTable =>
      $$TripDataPointsTableTableTableManager(_db, _db.tripDataPointsTable);
  $$DrivingEventsTableTableTableManager get drivingEventsTable =>
      $$DrivingEventsTableTableTableManager(_db, _db.drivingEventsTable);
  $$UserProfilesTableTableTableManager get userProfilesTable =>
      $$UserProfilesTableTableTableManager(_db, _db.userProfilesTable);
  $$PerformanceMetricsTableTableTableManager get performanceMetricsTable =>
      $$PerformanceMetricsTableTableTableManager(
        _db,
        _db.performanceMetricsTable,
      );
  $$BadgesTableTableTableManager get badgesTable =>
      $$BadgesTableTableTableManager(_db, _db.badgesTable);
  $$DataPrivacySettingsTableTableTableManager get dataPrivacySettingsTable =>
      $$DataPrivacySettingsTableTableTableManager(
        _db,
        _db.dataPrivacySettingsTable,
      );
  $$SocialConnectionsTableTableTableManager get socialConnectionsTable =>
      $$SocialConnectionsTableTableTableManager(
        _db,
        _db.socialConnectionsTable,
      );
  $$SocialInteractionsTableTableTableManager get socialInteractionsTable =>
      $$SocialInteractionsTableTableTableManager(
        _db,
        _db.socialInteractionsTable,
      );
  $$SharedContentTableTableTableManager get sharedContentTable =>
      $$SharedContentTableTableTableManager(_db, _db.sharedContentTable);
  $$UserPreferencesTableTableTableManager get userPreferencesTable =>
      $$UserPreferencesTableTableTableManager(_db, _db.userPreferencesTable);
  $$FeedbackEffectivenessTableTableTableManager
  get feedbackEffectivenessTable =>
      $$FeedbackEffectivenessTableTableTableManager(
        _db,
        _db.feedbackEffectivenessTable,
      );
  $$ChallengesTableTableTableManager get challengesTable =>
      $$ChallengesTableTableTableManager(_db, _db.challengesTable);
  $$UserChallengesTableTableTableManager get userChallengesTable =>
      $$UserChallengesTableTableTableManager(_db, _db.userChallengesTable);
  $$StreaksTableTableTableManager get streaksTable =>
      $$StreaksTableTableTableManager(_db, _db.streaksTable);
  $$LeaderboardEntriesTableTableTableManager get leaderboardEntriesTable =>
      $$LeaderboardEntriesTableTableTableManager(
        _db,
        _db.leaderboardEntriesTable,
      );
  $$ExternalIntegrationsTableTableTableManager get externalIntegrationsTable =>
      $$ExternalIntegrationsTableTableTableManager(
        _db,
        _db.externalIntegrationsTable,
      );
  $$SyncStatusTableTableTableManager get syncStatusTable =>
      $$SyncStatusTableTableTableManager(_db, _db.syncStatusTable);
}
