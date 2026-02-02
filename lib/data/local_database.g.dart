// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database.dart';

// ignore_for_file: type=lint
class $WorkoutsTable extends Workouts
    with TableInfo<$WorkoutsTable, WorkoutEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workoutDateKeyMeta = const VerificationMeta(
    'workoutDateKey',
  );
  @override
  late final GeneratedColumn<String> workoutDateKey = GeneratedColumn<String>(
    'workout_date_key',
    aliasedName,
    false,
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
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
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
  static const VerificationMeta _coinRewardMeta = const VerificationMeta(
    'coinReward',
  );
  @override
  late final GeneratedColumn<int> coinReward = GeneratedColumn<int>(
    'coin_reward',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    title,
    note,
    workoutDateKey,
    startTime,
    endTime,
    isCompleted,
    coinReward,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workouts';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutEntity> instance, {
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
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    } else if (isInserting) {
      context.missing(_noteMeta);
    }
    if (data.containsKey('workout_date_key')) {
      context.handle(
        _workoutDateKeyMeta,
        workoutDateKey.isAcceptableOrUnknown(
          data['workout_date_key']!,
          _workoutDateKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workoutDateKeyMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
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
    if (data.containsKey('coin_reward')) {
      context.handle(
        _coinRewardMeta,
        coinReward.isAcceptableOrUnknown(data['coin_reward']!, _coinRewardMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      workoutDateKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workout_date_key'],
      )!,
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_time'],
      ),
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_time'],
      ),
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      coinReward: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}coin_reward'],
      )!,
    );
  }

  @override
  $WorkoutsTable createAlias(String alias) {
    return $WorkoutsTable(attachedDatabase, alias);
  }
}

class WorkoutEntity extends DataClass implements Insertable<WorkoutEntity> {
  final String id;
  final String userId;
  final String title;
  final String note;
  final String workoutDateKey;
  final DateTime? startTime;
  final DateTime? endTime;
  final bool isCompleted;
  final int coinReward;
  const WorkoutEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.note,
    required this.workoutDateKey,
    this.startTime,
    this.endTime,
    required this.isCompleted,
    required this.coinReward,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['title'] = Variable<String>(title);
    map['note'] = Variable<String>(note);
    map['workout_date_key'] = Variable<String>(workoutDateKey);
    if (!nullToAbsent || startTime != null) {
      map['start_time'] = Variable<DateTime>(startTime);
    }
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<DateTime>(endTime);
    }
    map['is_completed'] = Variable<bool>(isCompleted);
    map['coin_reward'] = Variable<int>(coinReward);
    return map;
  }

  WorkoutsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutsCompanion(
      id: Value(id),
      userId: Value(userId),
      title: Value(title),
      note: Value(note),
      workoutDateKey: Value(workoutDateKey),
      startTime: startTime == null && nullToAbsent
          ? const Value.absent()
          : Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      isCompleted: Value(isCompleted),
      coinReward: Value(coinReward),
    );
  }

  factory WorkoutEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutEntity(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      title: serializer.fromJson<String>(json['title']),
      note: serializer.fromJson<String>(json['note']),
      workoutDateKey: serializer.fromJson<String>(json['workoutDateKey']),
      startTime: serializer.fromJson<DateTime?>(json['startTime']),
      endTime: serializer.fromJson<DateTime?>(json['endTime']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      coinReward: serializer.fromJson<int>(json['coinReward']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'title': serializer.toJson<String>(title),
      'note': serializer.toJson<String>(note),
      'workoutDateKey': serializer.toJson<String>(workoutDateKey),
      'startTime': serializer.toJson<DateTime?>(startTime),
      'endTime': serializer.toJson<DateTime?>(endTime),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'coinReward': serializer.toJson<int>(coinReward),
    };
  }

  WorkoutEntity copyWith({
    String? id,
    String? userId,
    String? title,
    String? note,
    String? workoutDateKey,
    Value<DateTime?> startTime = const Value.absent(),
    Value<DateTime?> endTime = const Value.absent(),
    bool? isCompleted,
    int? coinReward,
  }) => WorkoutEntity(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    title: title ?? this.title,
    note: note ?? this.note,
    workoutDateKey: workoutDateKey ?? this.workoutDateKey,
    startTime: startTime.present ? startTime.value : this.startTime,
    endTime: endTime.present ? endTime.value : this.endTime,
    isCompleted: isCompleted ?? this.isCompleted,
    coinReward: coinReward ?? this.coinReward,
  );
  WorkoutEntity copyWithCompanion(WorkoutsCompanion data) {
    return WorkoutEntity(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      title: data.title.present ? data.title.value : this.title,
      note: data.note.present ? data.note.value : this.note,
      workoutDateKey: data.workoutDateKey.present
          ? data.workoutDateKey.value
          : this.workoutDateKey,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      coinReward: data.coinReward.present
          ? data.coinReward.value
          : this.coinReward,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutEntity(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('note: $note, ')
          ..write('workoutDateKey: $workoutDateKey, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('coinReward: $coinReward')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    title,
    note,
    workoutDateKey,
    startTime,
    endTime,
    isCompleted,
    coinReward,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutEntity &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.title == this.title &&
          other.note == this.note &&
          other.workoutDateKey == this.workoutDateKey &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.isCompleted == this.isCompleted &&
          other.coinReward == this.coinReward);
}

class WorkoutsCompanion extends UpdateCompanion<WorkoutEntity> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> title;
  final Value<String> note;
  final Value<String> workoutDateKey;
  final Value<DateTime?> startTime;
  final Value<DateTime?> endTime;
  final Value<bool> isCompleted;
  final Value<int> coinReward;
  final Value<int> rowid;
  const WorkoutsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.title = const Value.absent(),
    this.note = const Value.absent(),
    this.workoutDateKey = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.coinReward = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutsCompanion.insert({
    required String id,
    required String userId,
    required String title,
    required String note,
    required String workoutDateKey,
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.coinReward = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       title = Value(title),
       note = Value(note),
       workoutDateKey = Value(workoutDateKey);
  static Insertable<WorkoutEntity> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? title,
    Expression<String>? note,
    Expression<String>? workoutDateKey,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<bool>? isCompleted,
    Expression<int>? coinReward,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (title != null) 'title': title,
      if (note != null) 'note': note,
      if (workoutDateKey != null) 'workout_date_key': workoutDateKey,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (coinReward != null) 'coin_reward': coinReward,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? title,
    Value<String>? note,
    Value<String>? workoutDateKey,
    Value<DateTime?>? startTime,
    Value<DateTime?>? endTime,
    Value<bool>? isCompleted,
    Value<int>? coinReward,
    Value<int>? rowid,
  }) {
    return WorkoutsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      note: note ?? this.note,
      workoutDateKey: workoutDateKey ?? this.workoutDateKey,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isCompleted: isCompleted ?? this.isCompleted,
      coinReward: coinReward ?? this.coinReward,
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
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (workoutDateKey.present) {
      map['workout_date_key'] = Variable<String>(workoutDateKey.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (coinReward.present) {
      map['coin_reward'] = Variable<int>(coinReward.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('note: $note, ')
          ..write('workoutDateKey: $workoutDateKey, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('coinReward: $coinReward, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutItemsTable extends WorkoutItems
    with TableInfo<$WorkoutItemsTable, WorkoutItemEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workoutIdMeta = const VerificationMeta(
    'workoutId',
  );
  @override
  late final GeneratedColumn<String> workoutId = GeneratedColumn<String>(
    'workout_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workouts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _memoMeta = const VerificationMeta('memo');
  @override
  late final GeneratedColumn<String> memo = GeneratedColumn<String>(
    'memo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workoutId,
    exerciseId,
    memo,
    orderIndex,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutItemEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('workout_id')) {
      context.handle(
        _workoutIdMeta,
        workoutId.isAcceptableOrUnknown(data['workout_id']!, _workoutIdMeta),
      );
    } else if (isInserting) {
      context.missing(_workoutIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('memo')) {
      context.handle(
        _memoMeta,
        memo.isAcceptableOrUnknown(data['memo']!, _memoMeta),
      );
    } else if (isInserting) {
      context.missing(_memoMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutItemEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutItemEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      workoutId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workout_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      memo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}memo'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
    );
  }

  @override
  $WorkoutItemsTable createAlias(String alias) {
    return $WorkoutItemsTable(attachedDatabase, alias);
  }
}

class WorkoutItemEntity extends DataClass
    implements Insertable<WorkoutItemEntity> {
  final String id;
  final String workoutId;
  final String exerciseId;
  final String memo;
  final int orderIndex;
  const WorkoutItemEntity({
    required this.id,
    required this.workoutId,
    required this.exerciseId,
    required this.memo,
    required this.orderIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['workout_id'] = Variable<String>(workoutId);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['memo'] = Variable<String>(memo);
    map['order_index'] = Variable<int>(orderIndex);
    return map;
  }

  WorkoutItemsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutItemsCompanion(
      id: Value(id),
      workoutId: Value(workoutId),
      exerciseId: Value(exerciseId),
      memo: Value(memo),
      orderIndex: Value(orderIndex),
    );
  }

  factory WorkoutItemEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutItemEntity(
      id: serializer.fromJson<String>(json['id']),
      workoutId: serializer.fromJson<String>(json['workoutId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      memo: serializer.fromJson<String>(json['memo']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workoutId': serializer.toJson<String>(workoutId),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'memo': serializer.toJson<String>(memo),
      'orderIndex': serializer.toJson<int>(orderIndex),
    };
  }

  WorkoutItemEntity copyWith({
    String? id,
    String? workoutId,
    String? exerciseId,
    String? memo,
    int? orderIndex,
  }) => WorkoutItemEntity(
    id: id ?? this.id,
    workoutId: workoutId ?? this.workoutId,
    exerciseId: exerciseId ?? this.exerciseId,
    memo: memo ?? this.memo,
    orderIndex: orderIndex ?? this.orderIndex,
  );
  WorkoutItemEntity copyWithCompanion(WorkoutItemsCompanion data) {
    return WorkoutItemEntity(
      id: data.id.present ? data.id.value : this.id,
      workoutId: data.workoutId.present ? data.workoutId.value : this.workoutId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      memo: data.memo.present ? data.memo.value : this.memo,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutItemEntity(')
          ..write('id: $id, ')
          ..write('workoutId: $workoutId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('memo: $memo, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, workoutId, exerciseId, memo, orderIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutItemEntity &&
          other.id == this.id &&
          other.workoutId == this.workoutId &&
          other.exerciseId == this.exerciseId &&
          other.memo == this.memo &&
          other.orderIndex == this.orderIndex);
}

class WorkoutItemsCompanion extends UpdateCompanion<WorkoutItemEntity> {
  final Value<String> id;
  final Value<String> workoutId;
  final Value<String> exerciseId;
  final Value<String> memo;
  final Value<int> orderIndex;
  final Value<int> rowid;
  const WorkoutItemsCompanion({
    this.id = const Value.absent(),
    this.workoutId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.memo = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutItemsCompanion.insert({
    required String id,
    required String workoutId,
    required String exerciseId,
    required String memo,
    required int orderIndex,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       workoutId = Value(workoutId),
       exerciseId = Value(exerciseId),
       memo = Value(memo),
       orderIndex = Value(orderIndex);
  static Insertable<WorkoutItemEntity> custom({
    Expression<String>? id,
    Expression<String>? workoutId,
    Expression<String>? exerciseId,
    Expression<String>? memo,
    Expression<int>? orderIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workoutId != null) 'workout_id': workoutId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (memo != null) 'memo': memo,
      if (orderIndex != null) 'order_index': orderIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? workoutId,
    Value<String>? exerciseId,
    Value<String>? memo,
    Value<int>? orderIndex,
    Value<int>? rowid,
  }) {
    return WorkoutItemsCompanion(
      id: id ?? this.id,
      workoutId: workoutId ?? this.workoutId,
      exerciseId: exerciseId ?? this.exerciseId,
      memo: memo ?? this.memo,
      orderIndex: orderIndex ?? this.orderIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workoutId.present) {
      map['workout_id'] = Variable<String>(workoutId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (memo.present) {
      map['memo'] = Variable<String>(memo.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutItemsCompanion(')
          ..write('id: $id, ')
          ..write('workoutId: $workoutId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('memo: $memo, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSetsTable extends WorkoutSets
    with TableInfo<$WorkoutSetsTable, WorkoutSetEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_items (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
    'weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isWarmupMeta = const VerificationMeta(
    'isWarmup',
  );
  @override
  late final GeneratedColumn<bool> isWarmup = GeneratedColumn<bool>(
    'is_warmup',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_warmup" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isAssistedMeta = const VerificationMeta(
    'isAssisted',
  );
  @override
  late final GeneratedColumn<bool> isAssisted = GeneratedColumn<bool>(
    'is_assisted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_assisted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _indexMeta = const VerificationMeta('index');
  @override
  late final GeneratedColumn<int> index = GeneratedColumn<int>(
    'index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    itemId,
    weight,
    reps,
    isWarmup,
    isAssisted,
    index,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_sets';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSetEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    } else if (isInserting) {
      context.missing(_weightMeta);
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
      );
    } else if (isInserting) {
      context.missing(_repsMeta);
    }
    if (data.containsKey('is_warmup')) {
      context.handle(
        _isWarmupMeta,
        isWarmup.isAcceptableOrUnknown(data['is_warmup']!, _isWarmupMeta),
      );
    }
    if (data.containsKey('is_assisted')) {
      context.handle(
        _isAssistedMeta,
        isAssisted.isAcceptableOrUnknown(data['is_assisted']!, _isAssistedMeta),
      );
    }
    if (data.containsKey('index')) {
      context.handle(
        _indexMeta,
        index.isAcceptableOrUnknown(data['index']!, _indexMeta),
      );
    } else if (isInserting) {
      context.missing(_indexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSetEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSetEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight'],
      )!,
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
      )!,
      isWarmup: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_warmup'],
      )!,
      isAssisted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_assisted'],
      )!,
      index: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}index'],
      )!,
    );
  }

  @override
  $WorkoutSetsTable createAlias(String alias) {
    return $WorkoutSetsTable(attachedDatabase, alias);
  }
}

class WorkoutSetEntity extends DataClass
    implements Insertable<WorkoutSetEntity> {
  final String id;
  final String itemId;
  final double? weight;
  final int? reps;
  final int? durationSec;
  final bool isWarmup;
  final bool isAssisted;
  final int index;
  const WorkoutSetEntity({
    required this.id,
    required this.itemId,
    this.weight,
    this.reps,
    this.durationSec,
    required this.isWarmup,
    required this.isAssisted,
    required this.index,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['item_id'] = Variable<String>(itemId);
    if (!nullToAbsent || weight != null) {
      map['weight'] = Variable<double>(weight);
    }
    if (!nullToAbsent || reps != null) {
      map['reps'] = Variable<int>(reps);
    }
    if (!nullToAbsent || durationSec != null) {
      map['durationSec'] = Variable<int>(durationSec);
    }
    map['is_warmup'] = Variable<bool>(isWarmup);
    map['is_assisted'] = Variable<bool>(isAssisted);
    map['index'] = Variable<int>(index);
    return map;
  }

  WorkoutSetsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSetsCompanion(
      id: Value(id),
      itemId: Value(itemId),
      weight: weight == null && nullToAbsent
          ? const Value.absent()
          : Value(weight),
      reps: reps == null && nullToAbsent ? const Value.absent() : Value(reps),
      durationSec: durationSec == null && nullToAbsent
          ? const Value.absent()
          : Value(durationSec),
      isWarmup: Value(isWarmup),
      isAssisted: Value(isAssisted),
      index: Value(index),
    );
  }

  factory WorkoutSetEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSetEntity(
      id: serializer.fromJson<String>(json['id']),
      itemId: serializer.fromJson<String>(json['itemId']),
      weight: serializer.fromJson<double?>(json['weight']),
      reps: serializer.fromJson<int?>(json['reps']),
      durationSec: serializer.fromJson<int?>(json['durationSec']),
      isWarmup: serializer.fromJson<bool>(json['isWarmup']),
      isAssisted: serializer.fromJson<bool>(json['isAssisted']),
      index: serializer.fromJson<int>(json['index']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'itemId': serializer.toJson<String>(itemId),
      'weight': serializer.toJson<double?>(weight),
      'reps': serializer.toJson<int?>(reps),
      'durationSec': serializer.toJson<int?>(durationSec),
      'isWarmup': serializer.toJson<bool>(isWarmup),
      'isAssisted': serializer.toJson<bool>(isAssisted),
      'index': serializer.toJson<int>(index),
    };
  }

  WorkoutSetEntity copyWith({
    String? id,
    String? itemId,
    Value<double?> weight = const Value.absent(),
    Value<int?> reps = const Value.absent(),
    Value<int?> durationSec = const Value.absent(),
    bool? isWarmup,
    bool? isAssisted,
    int? index,
  }) => WorkoutSetEntity(
    id: id ?? this.id,
    itemId: itemId ?? this.itemId,
    weight: weight.present ? weight.value : this.weight,
    reps: reps.present ? reps.value : this.reps,
    durationSec: durationSec.present ? durationSec.value : this.durationSec,
    isWarmup: isWarmup ?? this.isWarmup,
    isAssisted: isAssisted ?? this.isAssisted,
    index: index ?? this.index,
  );
  WorkoutSetEntity copyWithCompanion(WorkoutSetsCompanion data) {
    return WorkoutSetEntity(
      id: data.id.present ? data.id.value : this.id,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      weight: data.weight.present ? data.weight.value : this.weight,
      reps: data.reps.present ? data.reps.value : this.reps,
      durationSec: data.durationSec.present
          ? data.durationSec.value
          : this.durationSec,
      isWarmup: data.isWarmup.present ? data.isWarmup.value : this.isWarmup,
      isAssisted: data.isAssisted.present
          ? data.isAssisted.value
          : this.isAssisted,
      index: data.index.present ? data.index.value : this.index,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSetEntity(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('weight: $weight, ')
          ..write('reps: $reps, ')
          ..write('durationSec: $durationSec, ')
          ..write('isWarmup: $isWarmup, ')
          ..write('isAssisted: $isAssisted, ')
          ..write('index: $index')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    itemId,
    weight,
    reps,
    durationSec,
    isWarmup,
    isAssisted,
    index,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSetEntity &&
          other.id == this.id &&
          other.itemId == this.itemId &&
          other.weight == this.weight &&
          other.reps == this.reps &&
          other.durationSec == this.durationSec &&
          other.isWarmup == this.isWarmup &&
          other.isAssisted == this.isAssisted &&
          other.index == this.index);
}

class WorkoutSetsCompanion extends UpdateCompanion<WorkoutSetEntity> {
  final Value<String> id;
  final Value<String> itemId;
  final Value<double?> weight;
  final Value<int?> reps;
  final Value<int?> durationSec;
  final Value<bool> isWarmup;
  final Value<bool> isAssisted;
  final Value<int> index;
  final Value<int> rowid;
  const WorkoutSetsCompanion({
    this.id = const Value.absent(),
    this.itemId = const Value.absent(),
    this.weight = const Value.absent(),
    this.reps = const Value.absent(),
    this.durationSec = const Value.absent(),
    this.isWarmup = const Value.absent(),
    this.isAssisted = const Value.absent(),
    this.index = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutSetsCompanion.insert({
    required String id,
    required String itemId,
    this.weight = const Value.absent(),
    this.reps = const Value.absent(),
    this.durationSec = const Value.absent(),
    this.isWarmup = const Value.absent(),
    this.isAssisted = const Value.absent(),
    required int index,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       itemId = Value(itemId),
       index = Value(index);
  static Insertable<WorkoutSetEntity> custom({
    Expression<String>? id,
    Expression<String>? itemId,
    Expression<double>? weight,
    Expression<int>? reps,
    Expression<int>? durationSec,
    Expression<bool>? isWarmup,
    Expression<bool>? isAssisted,
    Expression<int>? index,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemId != null) 'item_id': itemId,
      if (weight != null) 'weight': weight,
      if (reps != null) 'reps': reps,
      if (durationSec != null) 'durationSec': durationSec,
      if (isWarmup != null) 'is_warmup': isWarmup,
      if (isAssisted != null) 'is_assisted': isAssisted,
      if (index != null) 'index': index,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutSetsCompanion copyWith({
    Value<String>? id,
    Value<String>? itemId,
    Value<double?>? weight,
    Value<int?>? reps,
    Value<int?>? durationSec,
    Value<bool>? isWarmup,
    Value<bool>? isAssisted,
    Value<int>? index,
    Value<int>? rowid,
  }) {
    return WorkoutSetsCompanion(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
      durationSec: durationSec ?? this.durationSec,
      isWarmup: isWarmup ?? this.isWarmup,
      isAssisted: isAssisted ?? this.isAssisted,
      index: index ?? this.index,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (durationSec.present) {
      map['durationSec'] = Variable<int>(durationSec.value);
    }
    if (isWarmup.present) {
      map['is_warmup'] = Variable<bool>(isWarmup.value);
    }
    if (isAssisted.present) {
      map['is_assisted'] = Variable<bool>(isAssisted.value);
    }
    if (index.present) {
      map['index'] = Variable<int>(index.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSetsCompanion(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('weight: $weight, ')
          ..write('reps: $reps, ')
          ..write('durationSec: $durationSec, ')
          ..write('isWarmup: $isWarmup, ')
          ..write('isAssisted: $isAssisted, ')
          ..write('index: $index, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalBodyPartsTable extends LocalBodyParts
    with TableInfo<$LocalBodyPartsTable, LocalBodyPartEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalBodyPartsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    orderIndex,
    isArchived,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_body_parts';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalBodyPartEntity> instance, {
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
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalBodyPartEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalBodyPartEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
    );
  }

  @override
  $LocalBodyPartsTable createAlias(String alias) {
    return $LocalBodyPartsTable(attachedDatabase, alias);
  }
}

class LocalBodyPartEntity extends DataClass
    implements Insertable<LocalBodyPartEntity> {
  final String id;
  final String name;
  final int orderIndex;
  final bool isArchived;
  final DateTime? createdAt;
  const LocalBodyPartEntity({
    required this.id,
    required this.name,
    required this.orderIndex,
    required this.isArchived,
    this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['order_index'] = Variable<int>(orderIndex);
    map['is_archived'] = Variable<bool>(isArchived);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  LocalBodyPartsCompanion toCompanion(bool nullToAbsent) {
    return LocalBodyPartsCompanion(
      id: Value(id),
      name: Value(name),
      orderIndex: Value(orderIndex),
      isArchived: Value(isArchived),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory LocalBodyPartEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalBodyPartEntity(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  LocalBodyPartEntity copyWith({
    String? id,
    String? name,
    int? orderIndex,
    bool? isArchived,
    Value<DateTime?> createdAt = const Value.absent(),
  }) => LocalBodyPartEntity(
    id: id ?? this.id,
    name: name ?? this.name,
    orderIndex: orderIndex ?? this.orderIndex,
    isArchived: isArchived ?? this.isArchived,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
  );
  LocalBodyPartEntity copyWithCompanion(LocalBodyPartsCompanion data) {
    return LocalBodyPartEntity(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalBodyPartEntity(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, orderIndex, isArchived, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalBodyPartEntity &&
          other.id == this.id &&
          other.name == this.name &&
          other.orderIndex == this.orderIndex &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt);
}

class LocalBodyPartsCompanion extends UpdateCompanion<LocalBodyPartEntity> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> orderIndex;
  final Value<bool> isArchived;
  final Value<DateTime?> createdAt;
  final Value<int> rowid;
  const LocalBodyPartsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalBodyPartsCompanion.insert({
    required String id,
    required String name,
    required int orderIndex,
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       orderIndex = Value(orderIndex);
  static Insertable<LocalBodyPartEntity> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? orderIndex,
    Expression<bool>? isArchived,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (orderIndex != null) 'order_index': orderIndex,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalBodyPartsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? orderIndex,
    Value<bool>? isArchived,
    Value<DateTime?>? createdAt,
    Value<int>? rowid,
  }) {
    return LocalBodyPartsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      orderIndex: orderIndex ?? this.orderIndex,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
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
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalBodyPartsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalExercisesTable extends LocalExercises
    with TableInfo<$LocalExercisesTable, LocalExerciseEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyPartIdMeta = const VerificationMeta(
    'bodyPartId',
  );
  @override
  late final GeneratedColumn<String> bodyPartId = GeneratedColumn<String>(
    'body_part_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _measureTypeMeta = const VerificationMeta(
    'measureType',
  );
  @override
  late final GeneratedColumn<String> measureType = GeneratedColumn<String>(
    'measure_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('weightReps'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    bodyPartId,
    orderIndex,
    isArchived,
    createdAt,
    measureType,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalExerciseEntity> instance, {
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
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('body_part_id')) {
      context.handle(
        _bodyPartIdMeta,
        bodyPartId.isAcceptableOrUnknown(
          data['body_part_id']!,
          _bodyPartIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_bodyPartIdMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('measure_type')) {
      context.handle(
        _measureTypeMeta,
        measureType.isAcceptableOrUnknown(
          data['measure_type']!,
          _measureTypeMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalExerciseEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalExerciseEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      bodyPartId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body_part_id'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      measureType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}measure_type'],
      )!,
    );
  }

  @override
  $LocalExercisesTable createAlias(String alias) {
    return $LocalExercisesTable(attachedDatabase, alias);
  }
}

class LocalExerciseEntity extends DataClass
    implements Insertable<LocalExerciseEntity> {
  final String id;
  final String name;
  final String bodyPartId;
  final int orderIndex;
  final bool isArchived;
  final DateTime? createdAt;
  final String measureType;
  const LocalExerciseEntity({
    required this.id,
    required this.name,
    required this.bodyPartId,
    required this.orderIndex,
    required this.isArchived,
    this.createdAt,
    required this.measureType,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['body_part_id'] = Variable<String>(bodyPartId);
    map['order_index'] = Variable<int>(orderIndex);
    map['is_archived'] = Variable<bool>(isArchived);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    map['measure_type'] = Variable<String>(measureType);
    return map;
  }

  LocalExercisesCompanion toCompanion(bool nullToAbsent) {
    return LocalExercisesCompanion(
      id: Value(id),
      name: Value(name),
      bodyPartId: Value(bodyPartId),
      orderIndex: Value(orderIndex),
      isArchived: Value(isArchived),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      measureType: Value(measureType),
    );
  }

  factory LocalExerciseEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalExerciseEntity(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      bodyPartId: serializer.fromJson<String>(json['bodyPartId']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      measureType: serializer.fromJson<String>(json['measureType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'bodyPartId': serializer.toJson<String>(bodyPartId),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'measureType': serializer.toJson<String>(measureType),
    };
  }

  LocalExerciseEntity copyWith({
    String? id,
    String? name,
    String? bodyPartId,
    int? orderIndex,
    bool? isArchived,
    Value<DateTime?> createdAt = const Value.absent(),
    String? measureType,
  }) => LocalExerciseEntity(
    id: id ?? this.id,
    name: name ?? this.name,
    bodyPartId: bodyPartId ?? this.bodyPartId,
    orderIndex: orderIndex ?? this.orderIndex,
    isArchived: isArchived ?? this.isArchived,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    measureType: measureType ?? this.measureType,
  );
  LocalExerciseEntity copyWithCompanion(LocalExercisesCompanion data) {
    return LocalExerciseEntity(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      bodyPartId: data.bodyPartId.present
          ? data.bodyPartId.value
          : this.bodyPartId,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      measureType: data.measureType.present
          ? data.measureType.value
          : this.measureType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalExerciseEntity(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('bodyPartId: $bodyPartId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    bodyPartId,
    orderIndex,
    isArchived,
    createdAt,
    measureType,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalExerciseEntity &&
          other.id == this.id &&
          other.name == this.name &&
          other.bodyPartId == this.bodyPartId &&
          other.orderIndex == this.orderIndex &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt &&
          other.measureType == this.measureType);
}

class LocalExercisesCompanion extends UpdateCompanion<LocalExerciseEntity> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> bodyPartId;
  final Value<int> orderIndex;
  final Value<bool> isArchived;
  final Value<DateTime?> createdAt;
  final Value<String> measureType;
  final Value<int> rowid;
  const LocalExercisesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.bodyPartId = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.measureType = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalExercisesCompanion.insert({
    required String id,
    required String name,
    required String bodyPartId,
    required int orderIndex,
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.measureType = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       bodyPartId = Value(bodyPartId),
       orderIndex = Value(orderIndex);
  static Insertable<LocalExerciseEntity> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? bodyPartId,
    Expression<int>? orderIndex,
    Expression<bool>? isArchived,
    Expression<DateTime>? createdAt,
    Expression<String>? measureType,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (bodyPartId != null) 'body_part_id': bodyPartId,
      if (orderIndex != null) 'order_index': orderIndex,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalExercisesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? bodyPartId,
    Value<int>? orderIndex,
    Value<bool>? isArchived,
    Value<DateTime?>? createdAt,
    Value<String>? measureType,
    Value<int>? rowid,
  }) {
    return LocalExercisesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      bodyPartId: bodyPartId ?? this.bodyPartId,
      orderIndex: orderIndex ?? this.orderIndex,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      measureType: measureType ?? this.measureType,
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
    if (bodyPartId.present) {
      map['body_part_id'] = Variable<String>(bodyPartId.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (measureType.present) {
      map['measure_type'] = Variable<String>(measureType.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalExercisesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('bodyPartId: $bodyPartId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('measureType: $measureType, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalEconomyStateTable extends LocalEconomyState
    with TableInfo<$LocalEconomyStateTable, LocalEconomyStateEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalEconomyStateTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalCoinsMeta = const VerificationMeta(
    'totalCoins',
  );
  @override
  late final GeneratedColumn<int> totalCoins = GeneratedColumn<int>(
    'total_coins',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _fishingTicketsMeta = const VerificationMeta(
    'fishingTickets',
  );
  @override
  late final GeneratedColumn<int> fishingTickets = GeneratedColumn<int>(
    'fishing_tickets',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _equippedTitleIdMeta = const VerificationMeta(
    'equippedTitleId',
  );
  @override
  late final GeneratedColumn<String> equippedTitleId = GeneratedColumn<String>(
    'equipped_title_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    totalCoins,
    fishingTickets,
    equippedTitleId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_economy_state';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalEconomyStateEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('total_coins')) {
      context.handle(
        _totalCoinsMeta,
        totalCoins.isAcceptableOrUnknown(data['total_coins']!, _totalCoinsMeta),
      );
    }
    if (data.containsKey('fishing_tickets')) {
      context.handle(
        _fishingTicketsMeta,
        fishingTickets.isAcceptableOrUnknown(
          data['fishing_tickets']!,
          _fishingTicketsMeta,
        ),
      );
    }
    if (data.containsKey('equipped_title_id')) {
      context.handle(
        _equippedTitleIdMeta,
        equippedTitleId.isAcceptableOrUnknown(
          data['equipped_title_id']!,
          _equippedTitleIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalEconomyStateEntity map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalEconomyStateEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      totalCoins: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_coins'],
      )!,
      fishingTickets: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fishing_tickets'],
      )!,
      equippedTitleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}equipped_title_id'],
      ),
    );
  }

  @override
  $LocalEconomyStateTable createAlias(String alias) {
    return $LocalEconomyStateTable(attachedDatabase, alias);
  }
}

class LocalEconomyStateEntity extends DataClass
    implements Insertable<LocalEconomyStateEntity> {
  final String id;
  final int totalCoins;
  final int fishingTickets;
  final String? equippedTitleId;
  const LocalEconomyStateEntity({
    required this.id,
    required this.totalCoins,
    required this.fishingTickets,
    this.equippedTitleId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['total_coins'] = Variable<int>(totalCoins);
    map['fishing_tickets'] = Variable<int>(fishingTickets);
    if (!nullToAbsent || equippedTitleId != null) {
      map['equipped_title_id'] = Variable<String>(equippedTitleId);
    }
    return map;
  }

  LocalEconomyStateCompanion toCompanion(bool nullToAbsent) {
    return LocalEconomyStateCompanion(
      id: Value(id),
      totalCoins: Value(totalCoins),
      fishingTickets: Value(fishingTickets),
      equippedTitleId: equippedTitleId == null && nullToAbsent
          ? const Value.absent()
          : Value(equippedTitleId),
    );
  }

  factory LocalEconomyStateEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalEconomyStateEntity(
      id: serializer.fromJson<String>(json['id']),
      totalCoins: serializer.fromJson<int>(json['totalCoins']),
      fishingTickets: serializer.fromJson<int>(json['fishingTickets']),
      equippedTitleId: serializer.fromJson<String?>(json['equippedTitleId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'totalCoins': serializer.toJson<int>(totalCoins),
      'fishingTickets': serializer.toJson<int>(fishingTickets),
      'equippedTitleId': serializer.toJson<String?>(equippedTitleId),
    };
  }

  LocalEconomyStateEntity copyWith({
    String? id,
    int? totalCoins,
    int? fishingTickets,
    Value<String?> equippedTitleId = const Value.absent(),
  }) => LocalEconomyStateEntity(
    id: id ?? this.id,
    totalCoins: totalCoins ?? this.totalCoins,
    fishingTickets: fishingTickets ?? this.fishingTickets,
    equippedTitleId: equippedTitleId.present
        ? equippedTitleId.value
        : this.equippedTitleId,
  );
  LocalEconomyStateEntity copyWithCompanion(LocalEconomyStateCompanion data) {
    return LocalEconomyStateEntity(
      id: data.id.present ? data.id.value : this.id,
      totalCoins: data.totalCoins.present
          ? data.totalCoins.value
          : this.totalCoins,
      fishingTickets: data.fishingTickets.present
          ? data.fishingTickets.value
          : this.fishingTickets,
      equippedTitleId: data.equippedTitleId.present
          ? data.equippedTitleId.value
          : this.equippedTitleId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalEconomyStateEntity(')
          ..write('id: $id, ')
          ..write('totalCoins: $totalCoins, ')
          ..write('fishingTickets: $fishingTickets, ')
          ..write('equippedTitleId: $equippedTitleId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, totalCoins, fishingTickets, equippedTitleId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalEconomyStateEntity &&
          other.id == this.id &&
          other.totalCoins == this.totalCoins &&
          other.fishingTickets == this.fishingTickets &&
          other.equippedTitleId == this.equippedTitleId);
}

class LocalEconomyStateCompanion
    extends UpdateCompanion<LocalEconomyStateEntity> {
  final Value<String> id;
  final Value<int> totalCoins;
  final Value<int> fishingTickets;
  final Value<String?> equippedTitleId;
  final Value<int> rowid;
  const LocalEconomyStateCompanion({
    this.id = const Value.absent(),
    this.totalCoins = const Value.absent(),
    this.fishingTickets = const Value.absent(),
    this.equippedTitleId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalEconomyStateCompanion.insert({
    required String id,
    this.totalCoins = const Value.absent(),
    this.fishingTickets = const Value.absent(),
    this.equippedTitleId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<LocalEconomyStateEntity> custom({
    Expression<String>? id,
    Expression<int>? totalCoins,
    Expression<int>? fishingTickets,
    Expression<String>? equippedTitleId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (totalCoins != null) 'total_coins': totalCoins,
      if (fishingTickets != null) 'fishing_tickets': fishingTickets,
      if (equippedTitleId != null) 'equipped_title_id': equippedTitleId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalEconomyStateCompanion copyWith({
    Value<String>? id,
    Value<int>? totalCoins,
    Value<int>? fishingTickets,
    Value<String?>? equippedTitleId,
    Value<int>? rowid,
  }) {
    return LocalEconomyStateCompanion(
      id: id ?? this.id,
      totalCoins: totalCoins ?? this.totalCoins,
      fishingTickets: fishingTickets ?? this.fishingTickets,
      equippedTitleId: equippedTitleId ?? this.equippedTitleId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (totalCoins.present) {
      map['total_coins'] = Variable<int>(totalCoins.value);
    }
    if (fishingTickets.present) {
      map['fishing_tickets'] = Variable<int>(fishingTickets.value);
    }
    if (equippedTitleId.present) {
      map['equipped_title_id'] = Variable<String>(equippedTitleId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalEconomyStateCompanion(')
          ..write('id: $id, ')
          ..write('totalCoins: $totalCoins, ')
          ..write('fishingTickets: $fishingTickets, ')
          ..write('equippedTitleId: $equippedTitleId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalAchievementsTable extends LocalAchievements
    with TableInfo<$LocalAchievementsTable, LocalAchievementEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalAchievementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _achievementKeyMeta = const VerificationMeta(
    'achievementKey',
  );
  @override
  late final GeneratedColumn<String> achievementKey = GeneratedColumn<String>(
    'achievement_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _countMeta = const VerificationMeta('count');
  @override
  late final GeneratedColumn<int> count = GeneratedColumn<int>(
    'count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [achievementKey, count];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_achievements';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalAchievementEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('achievement_key')) {
      context.handle(
        _achievementKeyMeta,
        achievementKey.isAcceptableOrUnknown(
          data['achievement_key']!,
          _achievementKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_achievementKeyMeta);
    }
    if (data.containsKey('count')) {
      context.handle(
        _countMeta,
        count.isAcceptableOrUnknown(data['count']!, _countMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {achievementKey};
  @override
  LocalAchievementEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalAchievementEntity(
      achievementKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}achievement_key'],
      )!,
      count: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}count'],
      )!,
    );
  }

  @override
  $LocalAchievementsTable createAlias(String alias) {
    return $LocalAchievementsTable(attachedDatabase, alias);
  }
}

class LocalAchievementEntity extends DataClass
    implements Insertable<LocalAchievementEntity> {
  final String achievementKey;
  final int count;
  const LocalAchievementEntity({
    required this.achievementKey,
    required this.count,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['achievement_key'] = Variable<String>(achievementKey);
    map['count'] = Variable<int>(count);
    return map;
  }

  LocalAchievementsCompanion toCompanion(bool nullToAbsent) {
    return LocalAchievementsCompanion(
      achievementKey: Value(achievementKey),
      count: Value(count),
    );
  }

  factory LocalAchievementEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalAchievementEntity(
      achievementKey: serializer.fromJson<String>(json['achievementKey']),
      count: serializer.fromJson<int>(json['count']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'achievementKey': serializer.toJson<String>(achievementKey),
      'count': serializer.toJson<int>(count),
    };
  }

  LocalAchievementEntity copyWith({String? achievementKey, int? count}) =>
      LocalAchievementEntity(
        achievementKey: achievementKey ?? this.achievementKey,
        count: count ?? this.count,
      );
  LocalAchievementEntity copyWithCompanion(LocalAchievementsCompanion data) {
    return LocalAchievementEntity(
      achievementKey: data.achievementKey.present
          ? data.achievementKey.value
          : this.achievementKey,
      count: data.count.present ? data.count.value : this.count,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalAchievementEntity(')
          ..write('achievementKey: $achievementKey, ')
          ..write('count: $count')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(achievementKey, count);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalAchievementEntity &&
          other.achievementKey == this.achievementKey &&
          other.count == this.count);
}

class LocalAchievementsCompanion
    extends UpdateCompanion<LocalAchievementEntity> {
  final Value<String> achievementKey;
  final Value<int> count;
  final Value<int> rowid;
  const LocalAchievementsCompanion({
    this.achievementKey = const Value.absent(),
    this.count = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalAchievementsCompanion.insert({
    required String achievementKey,
    this.count = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : achievementKey = Value(achievementKey);
  static Insertable<LocalAchievementEntity> custom({
    Expression<String>? achievementKey,
    Expression<int>? count,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (achievementKey != null) 'achievement_key': achievementKey,
      if (count != null) 'count': count,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalAchievementsCompanion copyWith({
    Value<String>? achievementKey,
    Value<int>? count,
    Value<int>? rowid,
  }) {
    return LocalAchievementsCompanion(
      achievementKey: achievementKey ?? this.achievementKey,
      count: count ?? this.count,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (achievementKey.present) {
      map['achievement_key'] = Variable<String>(achievementKey.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalAchievementsCompanion(')
          ..write('achievementKey: $achievementKey, ')
          ..write('count: $count, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalInventoryTable extends LocalInventory
    with TableInfo<$LocalInventoryTable, LocalInventoryEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalInventoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remainingUsesMeta = const VerificationMeta(
    'remainingUses',
  );
  @override
  late final GeneratedColumn<int> remainingUses = GeneratedColumn<int>(
    'remaining_uses',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _acquiredAtMeta = const VerificationMeta(
    'acquiredAt',
  );
  @override
  late final GeneratedColumn<DateTime> acquiredAt = GeneratedColumn<DateTime>(
    'acquired_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isEquippedMeta = const VerificationMeta(
    'isEquipped',
  );
  @override
  late final GeneratedColumn<bool> isEquipped = GeneratedColumn<bool>(
    'is_equipped',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_equipped" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    itemId,
    remainingUses,
    acquiredAt,
    isEquipped,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_inventory';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalInventoryEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('remaining_uses')) {
      context.handle(
        _remainingUsesMeta,
        remainingUses.isAcceptableOrUnknown(
          data['remaining_uses']!,
          _remainingUsesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_remainingUsesMeta);
    }
    if (data.containsKey('acquired_at')) {
      context.handle(
        _acquiredAtMeta,
        acquiredAt.isAcceptableOrUnknown(data['acquired_at']!, _acquiredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_acquiredAtMeta);
    }
    if (data.containsKey('is_equipped')) {
      context.handle(
        _isEquippedMeta,
        isEquipped.isAcceptableOrUnknown(data['is_equipped']!, _isEquippedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalInventoryEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalInventoryEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
      remainingUses: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}remaining_uses'],
      )!,
      acquiredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}acquired_at'],
      )!,
      isEquipped: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_equipped'],
      )!,
    );
  }

  @override
  $LocalInventoryTable createAlias(String alias) {
    return $LocalInventoryTable(attachedDatabase, alias);
  }
}

class LocalInventoryEntity extends DataClass
    implements Insertable<LocalInventoryEntity> {
  final String id;
  final String itemId;
  final int remainingUses;
  final DateTime acquiredAt;
  final bool isEquipped;
  const LocalInventoryEntity({
    required this.id,
    required this.itemId,
    required this.remainingUses,
    required this.acquiredAt,
    required this.isEquipped,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['item_id'] = Variable<String>(itemId);
    map['remaining_uses'] = Variable<int>(remainingUses);
    map['acquired_at'] = Variable<DateTime>(acquiredAt);
    map['is_equipped'] = Variable<bool>(isEquipped);
    return map;
  }

  LocalInventoryCompanion toCompanion(bool nullToAbsent) {
    return LocalInventoryCompanion(
      id: Value(id),
      itemId: Value(itemId),
      remainingUses: Value(remainingUses),
      acquiredAt: Value(acquiredAt),
      isEquipped: Value(isEquipped),
    );
  }

  factory LocalInventoryEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalInventoryEntity(
      id: serializer.fromJson<String>(json['id']),
      itemId: serializer.fromJson<String>(json['itemId']),
      remainingUses: serializer.fromJson<int>(json['remainingUses']),
      acquiredAt: serializer.fromJson<DateTime>(json['acquiredAt']),
      isEquipped: serializer.fromJson<bool>(json['isEquipped']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'itemId': serializer.toJson<String>(itemId),
      'remainingUses': serializer.toJson<int>(remainingUses),
      'acquiredAt': serializer.toJson<DateTime>(acquiredAt),
      'isEquipped': serializer.toJson<bool>(isEquipped),
    };
  }

  LocalInventoryEntity copyWith({
    String? id,
    String? itemId,
    int? remainingUses,
    DateTime? acquiredAt,
    bool? isEquipped,
  }) => LocalInventoryEntity(
    id: id ?? this.id,
    itemId: itemId ?? this.itemId,
    remainingUses: remainingUses ?? this.remainingUses,
    acquiredAt: acquiredAt ?? this.acquiredAt,
    isEquipped: isEquipped ?? this.isEquipped,
  );
  LocalInventoryEntity copyWithCompanion(LocalInventoryCompanion data) {
    return LocalInventoryEntity(
      id: data.id.present ? data.id.value : this.id,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      remainingUses: data.remainingUses.present
          ? data.remainingUses.value
          : this.remainingUses,
      acquiredAt: data.acquiredAt.present
          ? data.acquiredAt.value
          : this.acquiredAt,
      isEquipped: data.isEquipped.present
          ? data.isEquipped.value
          : this.isEquipped,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalInventoryEntity(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('remainingUses: $remainingUses, ')
          ..write('acquiredAt: $acquiredAt, ')
          ..write('isEquipped: $isEquipped')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, itemId, remainingUses, acquiredAt, isEquipped);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalInventoryEntity &&
          other.id == this.id &&
          other.itemId == this.itemId &&
          other.remainingUses == this.remainingUses &&
          other.acquiredAt == this.acquiredAt &&
          other.isEquipped == this.isEquipped);
}

class LocalInventoryCompanion extends UpdateCompanion<LocalInventoryEntity> {
  final Value<String> id;
  final Value<String> itemId;
  final Value<int> remainingUses;
  final Value<DateTime> acquiredAt;
  final Value<bool> isEquipped;
  final Value<int> rowid;
  const LocalInventoryCompanion({
    this.id = const Value.absent(),
    this.itemId = const Value.absent(),
    this.remainingUses = const Value.absent(),
    this.acquiredAt = const Value.absent(),
    this.isEquipped = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalInventoryCompanion.insert({
    required String id,
    required String itemId,
    required int remainingUses,
    required DateTime acquiredAt,
    this.isEquipped = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       itemId = Value(itemId),
       remainingUses = Value(remainingUses),
       acquiredAt = Value(acquiredAt);
  static Insertable<LocalInventoryEntity> custom({
    Expression<String>? id,
    Expression<String>? itemId,
    Expression<int>? remainingUses,
    Expression<DateTime>? acquiredAt,
    Expression<bool>? isEquipped,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemId != null) 'item_id': itemId,
      if (remainingUses != null) 'remaining_uses': remainingUses,
      if (acquiredAt != null) 'acquired_at': acquiredAt,
      if (isEquipped != null) 'is_equipped': isEquipped,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalInventoryCompanion copyWith({
    Value<String>? id,
    Value<String>? itemId,
    Value<int>? remainingUses,
    Value<DateTime>? acquiredAt,
    Value<bool>? isEquipped,
    Value<int>? rowid,
  }) {
    return LocalInventoryCompanion(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      remainingUses: remainingUses ?? this.remainingUses,
      acquiredAt: acquiredAt ?? this.acquiredAt,
      isEquipped: isEquipped ?? this.isEquipped,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (remainingUses.present) {
      map['remaining_uses'] = Variable<int>(remainingUses.value);
    }
    if (acquiredAt.present) {
      map['acquired_at'] = Variable<DateTime>(acquiredAt.value);
    }
    if (isEquipped.present) {
      map['is_equipped'] = Variable<bool>(isEquipped.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalInventoryCompanion(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('remainingUses: $remainingUses, ')
          ..write('acquiredAt: $acquiredAt, ')
          ..write('isEquipped: $isEquipped, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalFishCollectionTable extends LocalFishCollection
    with TableInfo<$LocalFishCollectionTable, LocalFishCollectionEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalFishCollectionTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _fishIdMeta = const VerificationMeta('fishId');
  @override
  late final GeneratedColumn<String> fishId = GeneratedColumn<String>(
    'fish_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _countMeta = const VerificationMeta('count');
  @override
  late final GeneratedColumn<int> count = GeneratedColumn<int>(
    'count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [fishId, count];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_fish_collection';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalFishCollectionEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('fish_id')) {
      context.handle(
        _fishIdMeta,
        fishId.isAcceptableOrUnknown(data['fish_id']!, _fishIdMeta),
      );
    } else if (isInserting) {
      context.missing(_fishIdMeta);
    }
    if (data.containsKey('count')) {
      context.handle(
        _countMeta,
        count.isAcceptableOrUnknown(data['count']!, _countMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {fishId};
  @override
  LocalFishCollectionEntity map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalFishCollectionEntity(
      fishId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fish_id'],
      )!,
      count: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}count'],
      )!,
    );
  }

  @override
  $LocalFishCollectionTable createAlias(String alias) {
    return $LocalFishCollectionTable(attachedDatabase, alias);
  }
}

class LocalFishCollectionEntity extends DataClass
    implements Insertable<LocalFishCollectionEntity> {
  final String fishId;
  final int count;
  const LocalFishCollectionEntity({required this.fishId, required this.count});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['fish_id'] = Variable<String>(fishId);
    map['count'] = Variable<int>(count);
    return map;
  }

  LocalFishCollectionCompanion toCompanion(bool nullToAbsent) {
    return LocalFishCollectionCompanion(
      fishId: Value(fishId),
      count: Value(count),
    );
  }

  factory LocalFishCollectionEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalFishCollectionEntity(
      fishId: serializer.fromJson<String>(json['fishId']),
      count: serializer.fromJson<int>(json['count']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'fishId': serializer.toJson<String>(fishId),
      'count': serializer.toJson<int>(count),
    };
  }

  LocalFishCollectionEntity copyWith({String? fishId, int? count}) =>
      LocalFishCollectionEntity(
        fishId: fishId ?? this.fishId,
        count: count ?? this.count,
      );
  LocalFishCollectionEntity copyWithCompanion(
    LocalFishCollectionCompanion data,
  ) {
    return LocalFishCollectionEntity(
      fishId: data.fishId.present ? data.fishId.value : this.fishId,
      count: data.count.present ? data.count.value : this.count,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalFishCollectionEntity(')
          ..write('fishId: $fishId, ')
          ..write('count: $count')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(fishId, count);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalFishCollectionEntity &&
          other.fishId == this.fishId &&
          other.count == this.count);
}

class LocalFishCollectionCompanion
    extends UpdateCompanion<LocalFishCollectionEntity> {
  final Value<String> fishId;
  final Value<int> count;
  final Value<int> rowid;
  const LocalFishCollectionCompanion({
    this.fishId = const Value.absent(),
    this.count = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalFishCollectionCompanion.insert({
    required String fishId,
    this.count = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : fishId = Value(fishId);
  static Insertable<LocalFishCollectionEntity> custom({
    Expression<String>? fishId,
    Expression<int>? count,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (fishId != null) 'fish_id': fishId,
      if (count != null) 'count': count,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalFishCollectionCompanion copyWith({
    Value<String>? fishId,
    Value<int>? count,
    Value<int>? rowid,
  }) {
    return LocalFishCollectionCompanion(
      fishId: fishId ?? this.fishId,
      count: count ?? this.count,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (fishId.present) {
      map['fish_id'] = Variable<String>(fishId.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalFishCollectionCompanion(')
          ..write('fishId: $fishId, ')
          ..write('count: $count, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalPurchasedItemsTable extends LocalPurchasedItems
    with TableInfo<$LocalPurchasedItemsTable, LocalPurchasedItemEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalPurchasedItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purchasedAtMeta = const VerificationMeta(
    'purchasedAt',
  );
  @override
  late final GeneratedColumn<DateTime> purchasedAt = GeneratedColumn<DateTime>(
    'purchased_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [itemId, purchasedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_purchased_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalPurchasedItemEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('purchased_at')) {
      context.handle(
        _purchasedAtMeta,
        purchasedAt.isAcceptableOrUnknown(
          data['purchased_at']!,
          _purchasedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {itemId};
  @override
  LocalPurchasedItemEntity map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalPurchasedItemEntity(
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
      purchasedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}purchased_at'],
      ),
    );
  }

  @override
  $LocalPurchasedItemsTable createAlias(String alias) {
    return $LocalPurchasedItemsTable(attachedDatabase, alias);
  }
}

class LocalPurchasedItemEntity extends DataClass
    implements Insertable<LocalPurchasedItemEntity> {
  final String itemId;
  final DateTime? purchasedAt;
  const LocalPurchasedItemEntity({required this.itemId, this.purchasedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['item_id'] = Variable<String>(itemId);
    if (!nullToAbsent || purchasedAt != null) {
      map['purchased_at'] = Variable<DateTime>(purchasedAt);
    }
    return map;
  }

  LocalPurchasedItemsCompanion toCompanion(bool nullToAbsent) {
    return LocalPurchasedItemsCompanion(
      itemId: Value(itemId),
      purchasedAt: purchasedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(purchasedAt),
    );
  }

  factory LocalPurchasedItemEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalPurchasedItemEntity(
      itemId: serializer.fromJson<String>(json['itemId']),
      purchasedAt: serializer.fromJson<DateTime?>(json['purchasedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'itemId': serializer.toJson<String>(itemId),
      'purchasedAt': serializer.toJson<DateTime?>(purchasedAt),
    };
  }

  LocalPurchasedItemEntity copyWith({
    String? itemId,
    Value<DateTime?> purchasedAt = const Value.absent(),
  }) => LocalPurchasedItemEntity(
    itemId: itemId ?? this.itemId,
    purchasedAt: purchasedAt.present ? purchasedAt.value : this.purchasedAt,
  );
  LocalPurchasedItemEntity copyWithCompanion(
    LocalPurchasedItemsCompanion data,
  ) {
    return LocalPurchasedItemEntity(
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      purchasedAt: data.purchasedAt.present
          ? data.purchasedAt.value
          : this.purchasedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalPurchasedItemEntity(')
          ..write('itemId: $itemId, ')
          ..write('purchasedAt: $purchasedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(itemId, purchasedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalPurchasedItemEntity &&
          other.itemId == this.itemId &&
          other.purchasedAt == this.purchasedAt);
}

class LocalPurchasedItemsCompanion
    extends UpdateCompanion<LocalPurchasedItemEntity> {
  final Value<String> itemId;
  final Value<DateTime?> purchasedAt;
  final Value<int> rowid;
  const LocalPurchasedItemsCompanion({
    this.itemId = const Value.absent(),
    this.purchasedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalPurchasedItemsCompanion.insert({
    required String itemId,
    this.purchasedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : itemId = Value(itemId);
  static Insertable<LocalPurchasedItemEntity> custom({
    Expression<String>? itemId,
    Expression<DateTime>? purchasedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (itemId != null) 'item_id': itemId,
      if (purchasedAt != null) 'purchased_at': purchasedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalPurchasedItemsCompanion copyWith({
    Value<String>? itemId,
    Value<DateTime?>? purchasedAt,
    Value<int>? rowid,
  }) {
    return LocalPurchasedItemsCompanion(
      itemId: itemId ?? this.itemId,
      purchasedAt: purchasedAt ?? this.purchasedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (purchasedAt.present) {
      map['purchased_at'] = Variable<DateTime>(purchasedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalPurchasedItemsCompanion(')
          ..write('itemId: $itemId, ')
          ..write('purchasedAt: $purchasedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalUnlockedTitlesTable extends LocalUnlockedTitles
    with TableInfo<$LocalUnlockedTitlesTable, LocalUnlockedTitleEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalUnlockedTitlesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _titleIdMeta = const VerificationMeta(
    'titleId',
  );
  @override
  late final GeneratedColumn<String> titleId = GeneratedColumn<String>(
    'title_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unlockedAtMeta = const VerificationMeta(
    'unlockedAt',
  );
  @override
  late final GeneratedColumn<DateTime> unlockedAt = GeneratedColumn<DateTime>(
    'unlocked_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [titleId, unlockedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_unlocked_titles';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalUnlockedTitleEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('title_id')) {
      context.handle(
        _titleIdMeta,
        titleId.isAcceptableOrUnknown(data['title_id']!, _titleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_titleIdMeta);
    }
    if (data.containsKey('unlocked_at')) {
      context.handle(
        _unlockedAtMeta,
        unlockedAt.isAcceptableOrUnknown(data['unlocked_at']!, _unlockedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {titleId};
  @override
  LocalUnlockedTitleEntity map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalUnlockedTitleEntity(
      titleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_id'],
      )!,
      unlockedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}unlocked_at'],
      ),
    );
  }

  @override
  $LocalUnlockedTitlesTable createAlias(String alias) {
    return $LocalUnlockedTitlesTable(attachedDatabase, alias);
  }
}

class LocalUnlockedTitleEntity extends DataClass
    implements Insertable<LocalUnlockedTitleEntity> {
  final String titleId;
  final DateTime? unlockedAt;
  const LocalUnlockedTitleEntity({required this.titleId, this.unlockedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['title_id'] = Variable<String>(titleId);
    if (!nullToAbsent || unlockedAt != null) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt);
    }
    return map;
  }

  LocalUnlockedTitlesCompanion toCompanion(bool nullToAbsent) {
    return LocalUnlockedTitlesCompanion(
      titleId: Value(titleId),
      unlockedAt: unlockedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(unlockedAt),
    );
  }

  factory LocalUnlockedTitleEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalUnlockedTitleEntity(
      titleId: serializer.fromJson<String>(json['titleId']),
      unlockedAt: serializer.fromJson<DateTime?>(json['unlockedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'titleId': serializer.toJson<String>(titleId),
      'unlockedAt': serializer.toJson<DateTime?>(unlockedAt),
    };
  }

  LocalUnlockedTitleEntity copyWith({
    String? titleId,
    Value<DateTime?> unlockedAt = const Value.absent(),
  }) => LocalUnlockedTitleEntity(
    titleId: titleId ?? this.titleId,
    unlockedAt: unlockedAt.present ? unlockedAt.value : this.unlockedAt,
  );
  LocalUnlockedTitleEntity copyWithCompanion(
    LocalUnlockedTitlesCompanion data,
  ) {
    return LocalUnlockedTitleEntity(
      titleId: data.titleId.present ? data.titleId.value : this.titleId,
      unlockedAt: data.unlockedAt.present
          ? data.unlockedAt.value
          : this.unlockedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalUnlockedTitleEntity(')
          ..write('titleId: $titleId, ')
          ..write('unlockedAt: $unlockedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(titleId, unlockedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalUnlockedTitleEntity &&
          other.titleId == this.titleId &&
          other.unlockedAt == this.unlockedAt);
}

class LocalUnlockedTitlesCompanion
    extends UpdateCompanion<LocalUnlockedTitleEntity> {
  final Value<String> titleId;
  final Value<DateTime?> unlockedAt;
  final Value<int> rowid;
  const LocalUnlockedTitlesCompanion({
    this.titleId = const Value.absent(),
    this.unlockedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalUnlockedTitlesCompanion.insert({
    required String titleId,
    this.unlockedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : titleId = Value(titleId);
  static Insertable<LocalUnlockedTitleEntity> custom({
    Expression<String>? titleId,
    Expression<DateTime>? unlockedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (titleId != null) 'title_id': titleId,
      if (unlockedAt != null) 'unlocked_at': unlockedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalUnlockedTitlesCompanion copyWith({
    Value<String>? titleId,
    Value<DateTime?>? unlockedAt,
    Value<int>? rowid,
  }) {
    return LocalUnlockedTitlesCompanion(
      titleId: titleId ?? this.titleId,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (titleId.present) {
      map['title_id'] = Variable<String>(titleId.value);
    }
    if (unlockedAt.present) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalUnlockedTitlesCompanion(')
          ..write('titleId: $titleId, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalBodyCompositionEntriesTable extends LocalBodyCompositionEntries
    with
        TableInfo<
          $LocalBodyCompositionEntriesTable,
          LocalBodyCompositionEntryEntity
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalBodyCompositionEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateKeyMeta = const VerificationMeta(
    'dateKey',
  );
  @override
  late final GeneratedColumn<String> dateKey = GeneratedColumn<String>(
    'date_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
    'weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyFatPercentageMeta = const VerificationMeta(
    'bodyFatPercentage',
  );
  @override
  late final GeneratedColumn<double> bodyFatPercentage =
      GeneratedColumn<double>(
        'body_fat_percentage',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _muscleMassMeta = const VerificationMeta(
    'muscleMass',
  );
  @override
  late final GeneratedColumn<double> muscleMass = GeneratedColumn<double>(
    'muscle_mass',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('manual'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dateKey,
    timestamp,
    weight,
    bodyFatPercentage,
    muscleMass,
    note,
    source,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_body_composition_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalBodyCompositionEntryEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date_key')) {
      context.handle(
        _dateKeyMeta,
        dateKey.isAcceptableOrUnknown(data['date_key']!, _dateKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_dateKeyMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    } else if (isInserting) {
      context.missing(_weightMeta);
    }
    if (data.containsKey('body_fat_percentage')) {
      context.handle(
        _bodyFatPercentageMeta,
        bodyFatPercentage.isAcceptableOrUnknown(
          data['body_fat_percentage']!,
          _bodyFatPercentageMeta,
        ),
      );
    }
    if (data.containsKey('muscle_mass')) {
      context.handle(
        _muscleMassMeta,
        muscleMass.isAcceptableOrUnknown(data['muscle_mass']!, _muscleMassMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalBodyCompositionEntryEntity map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalBodyCompositionEntryEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      dateKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_key'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight'],
      )!,
      bodyFatPercentage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}body_fat_percentage'],
      ),
      muscleMass: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}muscle_mass'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $LocalBodyCompositionEntriesTable createAlias(String alias) {
    return $LocalBodyCompositionEntriesTable(attachedDatabase, alias);
  }
}

class LocalBodyCompositionEntryEntity extends DataClass
    implements Insertable<LocalBodyCompositionEntryEntity> {
  final String id;
  final String dateKey;
  final DateTime timestamp;
  final double weight;
  final double? bodyFatPercentage;
  final double? muscleMass;
  final String? note;
  final String source;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const LocalBodyCompositionEntryEntity({
    required this.id,
    required this.dateKey,
    required this.timestamp,
    required this.weight,
    this.bodyFatPercentage,
    this.muscleMass,
    this.note,
    required this.source,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date_key'] = Variable<String>(dateKey);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['weight'] = Variable<double>(weight);
    if (!nullToAbsent || bodyFatPercentage != null) {
      map['body_fat_percentage'] = Variable<double>(bodyFatPercentage);
    }
    if (!nullToAbsent || muscleMass != null) {
      map['muscle_mass'] = Variable<double>(muscleMass);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  LocalBodyCompositionEntriesCompanion toCompanion(bool nullToAbsent) {
    return LocalBodyCompositionEntriesCompanion(
      id: Value(id),
      dateKey: Value(dateKey),
      timestamp: Value(timestamp),
      weight: Value(weight),
      bodyFatPercentage: bodyFatPercentage == null && nullToAbsent
          ? const Value.absent()
          : Value(bodyFatPercentage),
      muscleMass: muscleMass == null && nullToAbsent
          ? const Value.absent()
          : Value(muscleMass),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      source: Value(source),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory LocalBodyCompositionEntryEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalBodyCompositionEntryEntity(
      id: serializer.fromJson<String>(json['id']),
      dateKey: serializer.fromJson<String>(json['dateKey']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      weight: serializer.fromJson<double>(json['weight']),
      bodyFatPercentage: serializer.fromJson<double?>(
        json['bodyFatPercentage'],
      ),
      muscleMass: serializer.fromJson<double?>(json['muscleMass']),
      note: serializer.fromJson<String?>(json['note']),
      source: serializer.fromJson<String>(json['source']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'dateKey': serializer.toJson<String>(dateKey),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'weight': serializer.toJson<double>(weight),
      'bodyFatPercentage': serializer.toJson<double?>(bodyFatPercentage),
      'muscleMass': serializer.toJson<double?>(muscleMass),
      'note': serializer.toJson<String?>(note),
      'source': serializer.toJson<String>(source),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  LocalBodyCompositionEntryEntity copyWith({
    String? id,
    String? dateKey,
    DateTime? timestamp,
    double? weight,
    Value<double?> bodyFatPercentage = const Value.absent(),
    Value<double?> muscleMass = const Value.absent(),
    Value<String?> note = const Value.absent(),
    String? source,
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => LocalBodyCompositionEntryEntity(
    id: id ?? this.id,
    dateKey: dateKey ?? this.dateKey,
    timestamp: timestamp ?? this.timestamp,
    weight: weight ?? this.weight,
    bodyFatPercentage: bodyFatPercentage.present
        ? bodyFatPercentage.value
        : this.bodyFatPercentage,
    muscleMass: muscleMass.present ? muscleMass.value : this.muscleMass,
    note: note.present ? note.value : this.note,
    source: source ?? this.source,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  LocalBodyCompositionEntryEntity copyWithCompanion(
    LocalBodyCompositionEntriesCompanion data,
  ) {
    return LocalBodyCompositionEntryEntity(
      id: data.id.present ? data.id.value : this.id,
      dateKey: data.dateKey.present ? data.dateKey.value : this.dateKey,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      weight: data.weight.present ? data.weight.value : this.weight,
      bodyFatPercentage: data.bodyFatPercentage.present
          ? data.bodyFatPercentage.value
          : this.bodyFatPercentage,
      muscleMass: data.muscleMass.present
          ? data.muscleMass.value
          : this.muscleMass,
      note: data.note.present ? data.note.value : this.note,
      source: data.source.present ? data.source.value : this.source,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalBodyCompositionEntryEntity(')
          ..write('id: $id, ')
          ..write('dateKey: $dateKey, ')
          ..write('timestamp: $timestamp, ')
          ..write('weight: $weight, ')
          ..write('bodyFatPercentage: $bodyFatPercentage, ')
          ..write('muscleMass: $muscleMass, ')
          ..write('note: $note, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    dateKey,
    timestamp,
    weight,
    bodyFatPercentage,
    muscleMass,
    note,
    source,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalBodyCompositionEntryEntity &&
          other.id == this.id &&
          other.dateKey == this.dateKey &&
          other.timestamp == this.timestamp &&
          other.weight == this.weight &&
          other.bodyFatPercentage == this.bodyFatPercentage &&
          other.muscleMass == this.muscleMass &&
          other.note == this.note &&
          other.source == this.source &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LocalBodyCompositionEntriesCompanion
    extends UpdateCompanion<LocalBodyCompositionEntryEntity> {
  final Value<String> id;
  final Value<String> dateKey;
  final Value<DateTime> timestamp;
  final Value<double> weight;
  final Value<double?> bodyFatPercentage;
  final Value<double?> muscleMass;
  final Value<String?> note;
  final Value<String> source;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const LocalBodyCompositionEntriesCompanion({
    this.id = const Value.absent(),
    this.dateKey = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.weight = const Value.absent(),
    this.bodyFatPercentage = const Value.absent(),
    this.muscleMass = const Value.absent(),
    this.note = const Value.absent(),
    this.source = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalBodyCompositionEntriesCompanion.insert({
    required String id,
    required String dateKey,
    required DateTime timestamp,
    required double weight,
    this.bodyFatPercentage = const Value.absent(),
    this.muscleMass = const Value.absent(),
    this.note = const Value.absent(),
    this.source = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       dateKey = Value(dateKey),
       timestamp = Value(timestamp),
       weight = Value(weight);
  static Insertable<LocalBodyCompositionEntryEntity> custom({
    Expression<String>? id,
    Expression<String>? dateKey,
    Expression<DateTime>? timestamp,
    Expression<double>? weight,
    Expression<double>? bodyFatPercentage,
    Expression<double>? muscleMass,
    Expression<String>? note,
    Expression<String>? source,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dateKey != null) 'date_key': dateKey,
      if (timestamp != null) 'timestamp': timestamp,
      if (weight != null) 'weight': weight,
      if (bodyFatPercentage != null) 'body_fat_percentage': bodyFatPercentage,
      if (muscleMass != null) 'muscle_mass': muscleMass,
      if (note != null) 'note': note,
      if (source != null) 'source': source,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalBodyCompositionEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? dateKey,
    Value<DateTime>? timestamp,
    Value<double>? weight,
    Value<double?>? bodyFatPercentage,
    Value<double?>? muscleMass,
    Value<String?>? note,
    Value<String>? source,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return LocalBodyCompositionEntriesCompanion(
      id: id ?? this.id,
      dateKey: dateKey ?? this.dateKey,
      timestamp: timestamp ?? this.timestamp,
      weight: weight ?? this.weight,
      bodyFatPercentage: bodyFatPercentage ?? this.bodyFatPercentage,
      muscleMass: muscleMass ?? this.muscleMass,
      note: note ?? this.note,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
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
    if (dateKey.present) {
      map['date_key'] = Variable<String>(dateKey.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (bodyFatPercentage.present) {
      map['body_fat_percentage'] = Variable<double>(bodyFatPercentage.value);
    }
    if (muscleMass.present) {
      map['muscle_mass'] = Variable<double>(muscleMass.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
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
    return (StringBuffer('LocalBodyCompositionEntriesCompanion(')
          ..write('id: $id, ')
          ..write('dateKey: $dateKey, ')
          ..write('timestamp: $timestamp, ')
          ..write('weight: $weight, ')
          ..write('bodyFatPercentage: $bodyFatPercentage, ')
          ..write('muscleMass: $muscleMass, ')
          ..write('note: $note, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalUserProfilesTable extends LocalUserProfiles
    with TableInfo<$LocalUserProfilesTable, LocalUserProfileEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalUserProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _uidMeta = const VerificationMeta('uid');
  @override
  late final GeneratedColumn<String> uid = GeneratedColumn<String>(
    'uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weeklyGoalMeta = const VerificationMeta(
    'weeklyGoal',
  );
  @override
  late final GeneratedColumn<int> weeklyGoal = GeneratedColumn<int>(
    'weekly_goal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _weekStartsOnMeta = const VerificationMeta(
    'weekStartsOn',
  );
  @override
  late final GeneratedColumn<String> weekStartsOn = GeneratedColumn<String>(
    'week_starts_on',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('mon'),
  );
  static const VerificationMeta _weeklyGoalUpdatedAtMeta =
      const VerificationMeta('weeklyGoalUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> weeklyGoalUpdatedAt =
      GeneratedColumn<DateTime>(
        'weekly_goal_updated_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _weeklyGoalAnchorMeta = const VerificationMeta(
    'weeklyGoalAnchor',
  );
  @override
  late final GeneratedColumn<DateTime> weeklyGoalAnchor =
      GeneratedColumn<DateTime>(
        'weekly_goal_anchor',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastRewardedCycleIndexMeta =
      const VerificationMeta('lastRewardedCycleIndex');
  @override
  late final GeneratedColumn<int> lastRewardedCycleIndex = GeneratedColumn<int>(
    'last_rewarded_cycle_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(-1),
  );
  static const VerificationMeta _vibrationOnMeta = const VerificationMeta(
    'vibrationOn',
  );
  @override
  late final GeneratedColumn<bool> vibrationOn = GeneratedColumn<bool>(
    'vibration_on',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("vibration_on" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _notificationsOnMeta = const VerificationMeta(
    'notificationsOn',
  );
  @override
  late final GeneratedColumn<bool> notificationsOn = GeneratedColumn<bool>(
    'notifications_on',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notifications_on" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _seenTutorialsMeta = const VerificationMeta(
    'seenTutorials',
  );
  @override
  late final GeneratedColumn<String> seenTutorials = GeneratedColumn<String>(
    'seen_tutorials',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    uid,
    email,
    displayName,
    weeklyGoal,
    weekStartsOn,
    weeklyGoalUpdatedAt,
    weeklyGoalAnchor,
    lastRewardedCycleIndex,
    vibrationOn,
    notificationsOn,
    seenTutorials,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_user_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalUserProfileEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('uid')) {
      context.handle(
        _uidMeta,
        uid.isAcceptableOrUnknown(data['uid']!, _uidMeta),
      );
    } else if (isInserting) {
      context.missing(_uidMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('weekly_goal')) {
      context.handle(
        _weeklyGoalMeta,
        weeklyGoal.isAcceptableOrUnknown(data['weekly_goal']!, _weeklyGoalMeta),
      );
    }
    if (data.containsKey('week_starts_on')) {
      context.handle(
        _weekStartsOnMeta,
        weekStartsOn.isAcceptableOrUnknown(
          data['week_starts_on']!,
          _weekStartsOnMeta,
        ),
      );
    }
    if (data.containsKey('weekly_goal_updated_at')) {
      context.handle(
        _weeklyGoalUpdatedAtMeta,
        weeklyGoalUpdatedAt.isAcceptableOrUnknown(
          data['weekly_goal_updated_at']!,
          _weeklyGoalUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('weekly_goal_anchor')) {
      context.handle(
        _weeklyGoalAnchorMeta,
        weeklyGoalAnchor.isAcceptableOrUnknown(
          data['weekly_goal_anchor']!,
          _weeklyGoalAnchorMeta,
        ),
      );
    }
    if (data.containsKey('last_rewarded_cycle_index')) {
      context.handle(
        _lastRewardedCycleIndexMeta,
        lastRewardedCycleIndex.isAcceptableOrUnknown(
          data['last_rewarded_cycle_index']!,
          _lastRewardedCycleIndexMeta,
        ),
      );
    }
    if (data.containsKey('vibration_on')) {
      context.handle(
        _vibrationOnMeta,
        vibrationOn.isAcceptableOrUnknown(
          data['vibration_on']!,
          _vibrationOnMeta,
        ),
      );
    }
    if (data.containsKey('notifications_on')) {
      context.handle(
        _notificationsOnMeta,
        notificationsOn.isAcceptableOrUnknown(
          data['notifications_on']!,
          _notificationsOnMeta,
        ),
      );
    }
    if (data.containsKey('seen_tutorials')) {
      context.handle(
        _seenTutorialsMeta,
        seenTutorials.isAcceptableOrUnknown(
          data['seen_tutorials']!,
          _seenTutorialsMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {uid};
  @override
  LocalUserProfileEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalUserProfileEntity(
      uid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uid'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      ),
      weeklyGoal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekly_goal'],
      )!,
      weekStartsOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}week_starts_on'],
      )!,
      weeklyGoalUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}weekly_goal_updated_at'],
      ),
      weeklyGoalAnchor: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}weekly_goal_anchor'],
      ),
      lastRewardedCycleIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_rewarded_cycle_index'],
      )!,
      vibrationOn: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}vibration_on'],
      )!,
      notificationsOn: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notifications_on'],
      )!,
      seenTutorials: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}seen_tutorials'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $LocalUserProfilesTable createAlias(String alias) {
    return $LocalUserProfilesTable(attachedDatabase, alias);
  }
}

class LocalUserProfileEntity extends DataClass
    implements Insertable<LocalUserProfileEntity> {
  final String uid;
  final String? email;
  final String? displayName;
  final int weeklyGoal;
  final String weekStartsOn;
  final DateTime? weeklyGoalUpdatedAt;
  final DateTime? weeklyGoalAnchor;
  final int lastRewardedCycleIndex;
  final bool vibrationOn;
  final bool notificationsOn;
  final String seenTutorials;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const LocalUserProfileEntity({
    required this.uid,
    this.email,
    this.displayName,
    required this.weeklyGoal,
    required this.weekStartsOn,
    this.weeklyGoalUpdatedAt,
    this.weeklyGoalAnchor,
    required this.lastRewardedCycleIndex,
    required this.vibrationOn,
    required this.notificationsOn,
    required this.seenTutorials,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uid'] = Variable<String>(uid);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    map['weekly_goal'] = Variable<int>(weeklyGoal);
    map['week_starts_on'] = Variable<String>(weekStartsOn);
    if (!nullToAbsent || weeklyGoalUpdatedAt != null) {
      map['weekly_goal_updated_at'] = Variable<DateTime>(weeklyGoalUpdatedAt);
    }
    if (!nullToAbsent || weeklyGoalAnchor != null) {
      map['weekly_goal_anchor'] = Variable<DateTime>(weeklyGoalAnchor);
    }
    map['last_rewarded_cycle_index'] = Variable<int>(lastRewardedCycleIndex);
    map['vibration_on'] = Variable<bool>(vibrationOn);
    map['notifications_on'] = Variable<bool>(notificationsOn);
    map['seen_tutorials'] = Variable<String>(seenTutorials);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  LocalUserProfilesCompanion toCompanion(bool nullToAbsent) {
    return LocalUserProfilesCompanion(
      uid: Value(uid),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      weeklyGoal: Value(weeklyGoal),
      weekStartsOn: Value(weekStartsOn),
      weeklyGoalUpdatedAt: weeklyGoalUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(weeklyGoalUpdatedAt),
      weeklyGoalAnchor: weeklyGoalAnchor == null && nullToAbsent
          ? const Value.absent()
          : Value(weeklyGoalAnchor),
      lastRewardedCycleIndex: Value(lastRewardedCycleIndex),
      vibrationOn: Value(vibrationOn),
      notificationsOn: Value(notificationsOn),
      seenTutorials: Value(seenTutorials),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory LocalUserProfileEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalUserProfileEntity(
      uid: serializer.fromJson<String>(json['uid']),
      email: serializer.fromJson<String?>(json['email']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      weeklyGoal: serializer.fromJson<int>(json['weeklyGoal']),
      weekStartsOn: serializer.fromJson<String>(json['weekStartsOn']),
      weeklyGoalUpdatedAt: serializer.fromJson<DateTime?>(
        json['weeklyGoalUpdatedAt'],
      ),
      weeklyGoalAnchor: serializer.fromJson<DateTime?>(
        json['weeklyGoalAnchor'],
      ),
      lastRewardedCycleIndex: serializer.fromJson<int>(
        json['lastRewardedCycleIndex'],
      ),
      vibrationOn: serializer.fromJson<bool>(json['vibrationOn']),
      notificationsOn: serializer.fromJson<bool>(json['notificationsOn']),
      seenTutorials: serializer.fromJson<String>(json['seenTutorials']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uid': serializer.toJson<String>(uid),
      'email': serializer.toJson<String?>(email),
      'displayName': serializer.toJson<String?>(displayName),
      'weeklyGoal': serializer.toJson<int>(weeklyGoal),
      'weekStartsOn': serializer.toJson<String>(weekStartsOn),
      'weeklyGoalUpdatedAt': serializer.toJson<DateTime?>(weeklyGoalUpdatedAt),
      'weeklyGoalAnchor': serializer.toJson<DateTime?>(weeklyGoalAnchor),
      'lastRewardedCycleIndex': serializer.toJson<int>(lastRewardedCycleIndex),
      'vibrationOn': serializer.toJson<bool>(vibrationOn),
      'notificationsOn': serializer.toJson<bool>(notificationsOn),
      'seenTutorials': serializer.toJson<String>(seenTutorials),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  LocalUserProfileEntity copyWith({
    String? uid,
    Value<String?> email = const Value.absent(),
    Value<String?> displayName = const Value.absent(),
    int? weeklyGoal,
    String? weekStartsOn,
    Value<DateTime?> weeklyGoalUpdatedAt = const Value.absent(),
    Value<DateTime?> weeklyGoalAnchor = const Value.absent(),
    int? lastRewardedCycleIndex,
    bool? vibrationOn,
    bool? notificationsOn,
    String? seenTutorials,
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => LocalUserProfileEntity(
    uid: uid ?? this.uid,
    email: email.present ? email.value : this.email,
    displayName: displayName.present ? displayName.value : this.displayName,
    weeklyGoal: weeklyGoal ?? this.weeklyGoal,
    weekStartsOn: weekStartsOn ?? this.weekStartsOn,
    weeklyGoalUpdatedAt: weeklyGoalUpdatedAt.present
        ? weeklyGoalUpdatedAt.value
        : this.weeklyGoalUpdatedAt,
    weeklyGoalAnchor: weeklyGoalAnchor.present
        ? weeklyGoalAnchor.value
        : this.weeklyGoalAnchor,
    lastRewardedCycleIndex:
        lastRewardedCycleIndex ?? this.lastRewardedCycleIndex,
    vibrationOn: vibrationOn ?? this.vibrationOn,
    notificationsOn: notificationsOn ?? this.notificationsOn,
    seenTutorials: seenTutorials ?? this.seenTutorials,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  LocalUserProfileEntity copyWithCompanion(LocalUserProfilesCompanion data) {
    return LocalUserProfileEntity(
      uid: data.uid.present ? data.uid.value : this.uid,
      email: data.email.present ? data.email.value : this.email,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      weeklyGoal: data.weeklyGoal.present
          ? data.weeklyGoal.value
          : this.weeklyGoal,
      weekStartsOn: data.weekStartsOn.present
          ? data.weekStartsOn.value
          : this.weekStartsOn,
      weeklyGoalUpdatedAt: data.weeklyGoalUpdatedAt.present
          ? data.weeklyGoalUpdatedAt.value
          : this.weeklyGoalUpdatedAt,
      weeklyGoalAnchor: data.weeklyGoalAnchor.present
          ? data.weeklyGoalAnchor.value
          : this.weeklyGoalAnchor,
      lastRewardedCycleIndex: data.lastRewardedCycleIndex.present
          ? data.lastRewardedCycleIndex.value
          : this.lastRewardedCycleIndex,
      vibrationOn: data.vibrationOn.present
          ? data.vibrationOn.value
          : this.vibrationOn,
      notificationsOn: data.notificationsOn.present
          ? data.notificationsOn.value
          : this.notificationsOn,
      seenTutorials: data.seenTutorials.present
          ? data.seenTutorials.value
          : this.seenTutorials,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalUserProfileEntity(')
          ..write('uid: $uid, ')
          ..write('email: $email, ')
          ..write('displayName: $displayName, ')
          ..write('weeklyGoal: $weeklyGoal, ')
          ..write('weekStartsOn: $weekStartsOn, ')
          ..write('weeklyGoalUpdatedAt: $weeklyGoalUpdatedAt, ')
          ..write('weeklyGoalAnchor: $weeklyGoalAnchor, ')
          ..write('lastRewardedCycleIndex: $lastRewardedCycleIndex, ')
          ..write('vibrationOn: $vibrationOn, ')
          ..write('notificationsOn: $notificationsOn, ')
          ..write('seenTutorials: $seenTutorials, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    uid,
    email,
    displayName,
    weeklyGoal,
    weekStartsOn,
    weeklyGoalUpdatedAt,
    weeklyGoalAnchor,
    lastRewardedCycleIndex,
    vibrationOn,
    notificationsOn,
    seenTutorials,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalUserProfileEntity &&
          other.uid == this.uid &&
          other.email == this.email &&
          other.displayName == this.displayName &&
          other.weeklyGoal == this.weeklyGoal &&
          other.weekStartsOn == this.weekStartsOn &&
          other.weeklyGoalUpdatedAt == this.weeklyGoalUpdatedAt &&
          other.weeklyGoalAnchor == this.weeklyGoalAnchor &&
          other.lastRewardedCycleIndex == this.lastRewardedCycleIndex &&
          other.vibrationOn == this.vibrationOn &&
          other.notificationsOn == this.notificationsOn &&
          other.seenTutorials == this.seenTutorials &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LocalUserProfilesCompanion
    extends UpdateCompanion<LocalUserProfileEntity> {
  final Value<String> uid;
  final Value<String?> email;
  final Value<String?> displayName;
  final Value<int> weeklyGoal;
  final Value<String> weekStartsOn;
  final Value<DateTime?> weeklyGoalUpdatedAt;
  final Value<DateTime?> weeklyGoalAnchor;
  final Value<int> lastRewardedCycleIndex;
  final Value<bool> vibrationOn;
  final Value<bool> notificationsOn;
  final Value<String> seenTutorials;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const LocalUserProfilesCompanion({
    this.uid = const Value.absent(),
    this.email = const Value.absent(),
    this.displayName = const Value.absent(),
    this.weeklyGoal = const Value.absent(),
    this.weekStartsOn = const Value.absent(),
    this.weeklyGoalUpdatedAt = const Value.absent(),
    this.weeklyGoalAnchor = const Value.absent(),
    this.lastRewardedCycleIndex = const Value.absent(),
    this.vibrationOn = const Value.absent(),
    this.notificationsOn = const Value.absent(),
    this.seenTutorials = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalUserProfilesCompanion.insert({
    required String uid,
    this.email = const Value.absent(),
    this.displayName = const Value.absent(),
    this.weeklyGoal = const Value.absent(),
    this.weekStartsOn = const Value.absent(),
    this.weeklyGoalUpdatedAt = const Value.absent(),
    this.weeklyGoalAnchor = const Value.absent(),
    this.lastRewardedCycleIndex = const Value.absent(),
    this.vibrationOn = const Value.absent(),
    this.notificationsOn = const Value.absent(),
    this.seenTutorials = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : uid = Value(uid);
  static Insertable<LocalUserProfileEntity> custom({
    Expression<String>? uid,
    Expression<String>? email,
    Expression<String>? displayName,
    Expression<int>? weeklyGoal,
    Expression<String>? weekStartsOn,
    Expression<DateTime>? weeklyGoalUpdatedAt,
    Expression<DateTime>? weeklyGoalAnchor,
    Expression<int>? lastRewardedCycleIndex,
    Expression<bool>? vibrationOn,
    Expression<bool>? notificationsOn,
    Expression<String>? seenTutorials,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (uid != null) 'uid': uid,
      if (email != null) 'email': email,
      if (displayName != null) 'display_name': displayName,
      if (weeklyGoal != null) 'weekly_goal': weeklyGoal,
      if (weekStartsOn != null) 'week_starts_on': weekStartsOn,
      if (weeklyGoalUpdatedAt != null)
        'weekly_goal_updated_at': weeklyGoalUpdatedAt,
      if (weeklyGoalAnchor != null) 'weekly_goal_anchor': weeklyGoalAnchor,
      if (lastRewardedCycleIndex != null)
        'last_rewarded_cycle_index': lastRewardedCycleIndex,
      if (vibrationOn != null) 'vibration_on': vibrationOn,
      if (notificationsOn != null) 'notifications_on': notificationsOn,
      if (seenTutorials != null) 'seen_tutorials': seenTutorials,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalUserProfilesCompanion copyWith({
    Value<String>? uid,
    Value<String?>? email,
    Value<String?>? displayName,
    Value<int>? weeklyGoal,
    Value<String>? weekStartsOn,
    Value<DateTime?>? weeklyGoalUpdatedAt,
    Value<DateTime?>? weeklyGoalAnchor,
    Value<int>? lastRewardedCycleIndex,
    Value<bool>? vibrationOn,
    Value<bool>? notificationsOn,
    Value<String>? seenTutorials,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return LocalUserProfilesCompanion(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      weeklyGoal: weeklyGoal ?? this.weeklyGoal,
      weekStartsOn: weekStartsOn ?? this.weekStartsOn,
      weeklyGoalUpdatedAt: weeklyGoalUpdatedAt ?? this.weeklyGoalUpdatedAt,
      weeklyGoalAnchor: weeklyGoalAnchor ?? this.weeklyGoalAnchor,
      lastRewardedCycleIndex:
          lastRewardedCycleIndex ?? this.lastRewardedCycleIndex,
      vibrationOn: vibrationOn ?? this.vibrationOn,
      notificationsOn: notificationsOn ?? this.notificationsOn,
      seenTutorials: seenTutorials ?? this.seenTutorials,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uid.present) {
      map['uid'] = Variable<String>(uid.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (weeklyGoal.present) {
      map['weekly_goal'] = Variable<int>(weeklyGoal.value);
    }
    if (weekStartsOn.present) {
      map['week_starts_on'] = Variable<String>(weekStartsOn.value);
    }
    if (weeklyGoalUpdatedAt.present) {
      map['weekly_goal_updated_at'] = Variable<DateTime>(
        weeklyGoalUpdatedAt.value,
      );
    }
    if (weeklyGoalAnchor.present) {
      map['weekly_goal_anchor'] = Variable<DateTime>(weeklyGoalAnchor.value);
    }
    if (lastRewardedCycleIndex.present) {
      map['last_rewarded_cycle_index'] = Variable<int>(
        lastRewardedCycleIndex.value,
      );
    }
    if (vibrationOn.present) {
      map['vibration_on'] = Variable<bool>(vibrationOn.value);
    }
    if (notificationsOn.present) {
      map['notifications_on'] = Variable<bool>(notificationsOn.value);
    }
    if (seenTutorials.present) {
      map['seen_tutorials'] = Variable<String>(seenTutorials.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
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
    return (StringBuffer('LocalUserProfilesCompanion(')
          ..write('uid: $uid, ')
          ..write('email: $email, ')
          ..write('displayName: $displayName, ')
          ..write('weeklyGoal: $weeklyGoal, ')
          ..write('weekStartsOn: $weekStartsOn, ')
          ..write('weeklyGoalUpdatedAt: $weeklyGoalUpdatedAt, ')
          ..write('weeklyGoalAnchor: $weeklyGoalAnchor, ')
          ..write('lastRewardedCycleIndex: $lastRewardedCycleIndex, ')
          ..write('vibrationOn: $vibrationOn, ')
          ..write('notificationsOn: $notificationsOn, ')
          ..write('seenTutorials: $seenTutorials, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$LocalDatabase extends GeneratedDatabase {
  _$LocalDatabase(QueryExecutor e) : super(e);
  $LocalDatabaseManager get managers => $LocalDatabaseManager(this);
  late final $WorkoutsTable workouts = $WorkoutsTable(this);
  late final $WorkoutItemsTable workoutItems = $WorkoutItemsTable(this);
  late final $WorkoutSetsTable workoutSets = $WorkoutSetsTable(this);
  late final $LocalBodyPartsTable localBodyParts = $LocalBodyPartsTable(this);
  late final $LocalExercisesTable localExercises = $LocalExercisesTable(this);
  late final $LocalEconomyStateTable localEconomyState =
      $LocalEconomyStateTable(this);
  late final $LocalAchievementsTable localAchievements =
      $LocalAchievementsTable(this);
  late final $LocalInventoryTable localInventory = $LocalInventoryTable(this);
  late final $LocalFishCollectionTable localFishCollection =
      $LocalFishCollectionTable(this);
  late final $LocalPurchasedItemsTable localPurchasedItems =
      $LocalPurchasedItemsTable(this);
  late final $LocalUnlockedTitlesTable localUnlockedTitles =
      $LocalUnlockedTitlesTable(this);
  late final $LocalBodyCompositionEntriesTable localBodyCompositionEntries =
      $LocalBodyCompositionEntriesTable(this);
  late final $LocalUserProfilesTable localUserProfiles =
      $LocalUserProfilesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    workouts,
    workoutItems,
    workoutSets,
    localBodyParts,
    localExercises,
    localEconomyState,
    localAchievements,
    localInventory,
    localFishCollection,
    localPurchasedItems,
    localUnlockedTitles,
    localBodyCompositionEntries,
    localUserProfiles,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'workouts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('workout_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'workout_items',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('workout_sets', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$WorkoutsTableCreateCompanionBuilder =
    WorkoutsCompanion Function({
      required String id,
      required String userId,
      required String title,
      required String note,
      required String workoutDateKey,
      Value<DateTime?> startTime,
      Value<DateTime?> endTime,
      Value<bool> isCompleted,
      Value<int> coinReward,
      Value<int> rowid,
    });
typedef $$WorkoutsTableUpdateCompanionBuilder =
    WorkoutsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> title,
      Value<String> note,
      Value<String> workoutDateKey,
      Value<DateTime?> startTime,
      Value<DateTime?> endTime,
      Value<bool> isCompleted,
      Value<int> coinReward,
      Value<int> rowid,
    });

final class $$WorkoutsTableReferences
    extends BaseReferences<_$LocalDatabase, $WorkoutsTable, WorkoutEntity> {
  $$WorkoutsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$WorkoutItemsTable, List<WorkoutItemEntity>>
  _workoutItemsRefsTable(_$LocalDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutItems,
    aliasName: $_aliasNameGenerator(db.workouts.id, db.workoutItems.workoutId),
  );

  $$WorkoutItemsTableProcessedTableManager get workoutItemsRefs {
    final manager = $$WorkoutItemsTableTableManager(
      $_db,
      $_db.workoutItems,
    ).filter((f) => f.workoutId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_workoutItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutsTableFilterComposer
    extends Composer<_$LocalDatabase, $WorkoutsTable> {
  $$WorkoutsTableFilterComposer({
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

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workoutDateKey => $composableBuilder(
    column: $table.workoutDateKey,
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

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get coinReward => $composableBuilder(
    column: $table.coinReward,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> workoutItemsRefs(
    Expression<bool> Function($$WorkoutItemsTableFilterComposer f) f,
  ) {
    final $$WorkoutItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutItems,
      getReferencedColumn: (t) => t.workoutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutItemsTableFilterComposer(
            $db: $db,
            $table: $db.workoutItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutsTableOrderingComposer
    extends Composer<_$LocalDatabase, $WorkoutsTable> {
  $$WorkoutsTableOrderingComposer({
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

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workoutDateKey => $composableBuilder(
    column: $table.workoutDateKey,
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

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get coinReward => $composableBuilder(
    column: $table.coinReward,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkoutsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $WorkoutsTable> {
  $$WorkoutsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get workoutDateKey => $composableBuilder(
    column: $table.workoutDateKey,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get coinReward => $composableBuilder(
    column: $table.coinReward,
    builder: (column) => column,
  );

  Expression<T> workoutItemsRefs<T extends Object>(
    Expression<T> Function($$WorkoutItemsTableAnnotationComposer a) f,
  ) {
    final $$WorkoutItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutItems,
      getReferencedColumn: (t) => t.workoutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $WorkoutsTable,
          WorkoutEntity,
          $$WorkoutsTableFilterComposer,
          $$WorkoutsTableOrderingComposer,
          $$WorkoutsTableAnnotationComposer,
          $$WorkoutsTableCreateCompanionBuilder,
          $$WorkoutsTableUpdateCompanionBuilder,
          (WorkoutEntity, $$WorkoutsTableReferences),
          WorkoutEntity,
          PrefetchHooks Function({bool workoutItemsRefs})
        > {
  $$WorkoutsTableTableManager(_$LocalDatabase db, $WorkoutsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<String> workoutDateKey = const Value.absent(),
                Value<DateTime?> startTime = const Value.absent(),
                Value<DateTime?> endTime = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<int> coinReward = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutsCompanion(
                id: id,
                userId: userId,
                title: title,
                note: note,
                workoutDateKey: workoutDateKey,
                startTime: startTime,
                endTime: endTime,
                isCompleted: isCompleted,
                coinReward: coinReward,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String title,
                required String note,
                required String workoutDateKey,
                Value<DateTime?> startTime = const Value.absent(),
                Value<DateTime?> endTime = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<int> coinReward = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutsCompanion.insert(
                id: id,
                userId: userId,
                title: title,
                note: note,
                workoutDateKey: workoutDateKey,
                startTime: startTime,
                endTime: endTime,
                isCompleted: isCompleted,
                coinReward: coinReward,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WorkoutsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workoutItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (workoutItemsRefs) db.workoutItems],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (workoutItemsRefs)
                    await $_getPrefetchedData<
                      WorkoutEntity,
                      $WorkoutsTable,
                      WorkoutItemEntity
                    >(
                      currentTable: table,
                      referencedTable: $$WorkoutsTableReferences
                          ._workoutItemsRefsTable(db),
                      managerFromTypedResult: (p0) => $$WorkoutsTableReferences(
                        db,
                        table,
                        p0,
                      ).workoutItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.workoutId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$WorkoutsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $WorkoutsTable,
      WorkoutEntity,
      $$WorkoutsTableFilterComposer,
      $$WorkoutsTableOrderingComposer,
      $$WorkoutsTableAnnotationComposer,
      $$WorkoutsTableCreateCompanionBuilder,
      $$WorkoutsTableUpdateCompanionBuilder,
      (WorkoutEntity, $$WorkoutsTableReferences),
      WorkoutEntity,
      PrefetchHooks Function({bool workoutItemsRefs})
    >;
typedef $$WorkoutItemsTableCreateCompanionBuilder =
    WorkoutItemsCompanion Function({
      required String id,
      required String workoutId,
      required String exerciseId,
      required String memo,
      required int orderIndex,
      Value<int> rowid,
    });
typedef $$WorkoutItemsTableUpdateCompanionBuilder =
    WorkoutItemsCompanion Function({
      Value<String> id,
      Value<String> workoutId,
      Value<String> exerciseId,
      Value<String> memo,
      Value<int> orderIndex,
      Value<int> rowid,
    });

final class $$WorkoutItemsTableReferences
    extends
        BaseReferences<_$LocalDatabase, $WorkoutItemsTable, WorkoutItemEntity> {
  $$WorkoutItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WorkoutsTable _workoutIdTable(_$LocalDatabase db) =>
      db.workouts.createAlias(
        $_aliasNameGenerator(db.workoutItems.workoutId, db.workouts.id),
      );

  $$WorkoutsTableProcessedTableManager get workoutId {
    final $_column = $_itemColumn<String>('workout_id')!;

    final manager = $$WorkoutsTableTableManager(
      $_db,
      $_db.workouts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workoutIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$WorkoutSetsTable, List<WorkoutSetEntity>>
  _workoutSetsRefsTable(_$LocalDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutSets,
    aliasName: $_aliasNameGenerator(db.workoutItems.id, db.workoutSets.itemId),
  );

  $$WorkoutSetsTableProcessedTableManager get workoutSetsRefs {
    final manager = $$WorkoutSetsTableTableManager(
      $_db,
      $_db.workoutSets,
    ).filter((f) => f.itemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_workoutSetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutItemsTableFilterComposer
    extends Composer<_$LocalDatabase, $WorkoutItemsTable> {
  $$WorkoutItemsTableFilterComposer({
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

  ColumnFilters<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutsTableFilterComposer get workoutId {
    final $$WorkoutsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableFilterComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> workoutSetsRefs(
    Expression<bool> Function($$WorkoutSetsTableFilterComposer f) f,
  ) {
    final $$WorkoutSetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSets,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutItemsTableOrderingComposer
    extends Composer<_$LocalDatabase, $WorkoutItemsTable> {
  $$WorkoutItemsTableOrderingComposer({
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

  ColumnOrderings<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutsTableOrderingComposer get workoutId {
    final $$WorkoutsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableOrderingComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutItemsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $WorkoutItemsTable> {
  $$WorkoutItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  $$WorkoutsTableAnnotationComposer get workoutId {
    final $$WorkoutsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableAnnotationComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> workoutSetsRefs<T extends Object>(
    Expression<T> Function($$WorkoutSetsTableAnnotationComposer a) f,
  ) {
    final $$WorkoutSetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSets,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutItemsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $WorkoutItemsTable,
          WorkoutItemEntity,
          $$WorkoutItemsTableFilterComposer,
          $$WorkoutItemsTableOrderingComposer,
          $$WorkoutItemsTableAnnotationComposer,
          $$WorkoutItemsTableCreateCompanionBuilder,
          $$WorkoutItemsTableUpdateCompanionBuilder,
          (WorkoutItemEntity, $$WorkoutItemsTableReferences),
          WorkoutItemEntity,
          PrefetchHooks Function({bool workoutId, bool workoutSetsRefs})
        > {
  $$WorkoutItemsTableTableManager(_$LocalDatabase db, $WorkoutItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> workoutId = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<String> memo = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutItemsCompanion(
                id: id,
                workoutId: workoutId,
                exerciseId: exerciseId,
                memo: memo,
                orderIndex: orderIndex,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String workoutId,
                required String exerciseId,
                required String memo,
                required int orderIndex,
                Value<int> rowid = const Value.absent(),
              }) => WorkoutItemsCompanion.insert(
                id: id,
                workoutId: workoutId,
                exerciseId: exerciseId,
                memo: memo,
                orderIndex: orderIndex,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WorkoutItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({workoutId = false, workoutSetsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (workoutSetsRefs) db.workoutSets,
                  ],
                  addJoins:
                      <
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
                        if (workoutId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.workoutId,
                                    referencedTable:
                                        $$WorkoutItemsTableReferences
                                            ._workoutIdTable(db),
                                    referencedColumn:
                                        $$WorkoutItemsTableReferences
                                            ._workoutIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (workoutSetsRefs)
                        await $_getPrefetchedData<
                          WorkoutItemEntity,
                          $WorkoutItemsTable,
                          WorkoutSetEntity
                        >(
                          currentTable: table,
                          referencedTable: $$WorkoutItemsTableReferences
                              ._workoutSetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutSetsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.itemId == item.id,
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

typedef $$WorkoutItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $WorkoutItemsTable,
      WorkoutItemEntity,
      $$WorkoutItemsTableFilterComposer,
      $$WorkoutItemsTableOrderingComposer,
      $$WorkoutItemsTableAnnotationComposer,
      $$WorkoutItemsTableCreateCompanionBuilder,
      $$WorkoutItemsTableUpdateCompanionBuilder,
      (WorkoutItemEntity, $$WorkoutItemsTableReferences),
      WorkoutItemEntity,
      PrefetchHooks Function({bool workoutId, bool workoutSetsRefs})
    >;
typedef $$WorkoutSetsTableCreateCompanionBuilder =
    WorkoutSetsCompanion Function({
      required String id,
      required String itemId,
      required double weight,
      required int reps,
      Value<bool> isWarmup,
      Value<bool> isAssisted,
      required int index,
      Value<int> rowid,
    });
typedef $$WorkoutSetsTableUpdateCompanionBuilder =
    WorkoutSetsCompanion Function({
      Value<String> id,
      Value<String> itemId,
      Value<double> weight,
      Value<int> reps,
      Value<bool> isWarmup,
      Value<bool> isAssisted,
      Value<int> index,
      Value<int> rowid,
    });

final class $$WorkoutSetsTableReferences
    extends
        BaseReferences<_$LocalDatabase, $WorkoutSetsTable, WorkoutSetEntity> {
  $$WorkoutSetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WorkoutItemsTable _itemIdTable(_$LocalDatabase db) =>
      db.workoutItems.createAlias(
        $_aliasNameGenerator(db.workoutSets.itemId, db.workoutItems.id),
      );

  $$WorkoutItemsTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<String>('item_id')!;

    final manager = $$WorkoutItemsTableTableManager(
      $_db,
      $_db.workoutItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WorkoutSetsTableFilterComposer
    extends Composer<_$LocalDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableFilterComposer({
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

  ColumnFilters<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isWarmup => $composableBuilder(
    column: $table.isWarmup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAssisted => $composableBuilder(
    column: $table.isAssisted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get index => $composableBuilder(
    column: $table.index,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutItemsTableFilterComposer get itemId {
    final $$WorkoutItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.workoutItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutItemsTableFilterComposer(
            $db: $db,
            $table: $db.workoutItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetsTableOrderingComposer
    extends Composer<_$LocalDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableOrderingComposer({
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

  ColumnOrderings<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isWarmup => $composableBuilder(
    column: $table.isWarmup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAssisted => $composableBuilder(
    column: $table.isAssisted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get index => $composableBuilder(
    column: $table.index,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutItemsTableOrderingComposer get itemId {
    final $$WorkoutItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.workoutItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutItemsTableOrderingComposer(
            $db: $db,
            $table: $db.workoutItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<bool> get isWarmup =>
      $composableBuilder(column: $table.isWarmup, builder: (column) => column);

  GeneratedColumn<bool> get isAssisted => $composableBuilder(
    column: $table.isAssisted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get index =>
      $composableBuilder(column: $table.index, builder: (column) => column);

  $$WorkoutItemsTableAnnotationComposer get itemId {
    final $$WorkoutItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.workoutItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $WorkoutSetsTable,
          WorkoutSetEntity,
          $$WorkoutSetsTableFilterComposer,
          $$WorkoutSetsTableOrderingComposer,
          $$WorkoutSetsTableAnnotationComposer,
          $$WorkoutSetsTableCreateCompanionBuilder,
          $$WorkoutSetsTableUpdateCompanionBuilder,
          (WorkoutSetEntity, $$WorkoutSetsTableReferences),
          WorkoutSetEntity,
          PrefetchHooks Function({bool itemId})
        > {
  $$WorkoutSetsTableTableManager(_$LocalDatabase db, $WorkoutSetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> itemId = const Value.absent(),
                Value<double> weight = const Value.absent(),
                Value<int> reps = const Value.absent(),
                Value<bool> isWarmup = const Value.absent(),
                Value<bool> isAssisted = const Value.absent(),
                Value<int> index = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSetsCompanion(
                id: id,
                itemId: itemId,
                weight: weight,
                reps: reps,
                isWarmup: isWarmup,
                isAssisted: isAssisted,
                index: index,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String itemId,
                required double weight,
                required int reps,
                Value<bool> isWarmup = const Value.absent(),
                Value<bool> isAssisted = const Value.absent(),
                required int index,
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSetsCompanion.insert(
                id: id,
                itemId: itemId,
                weight: Value(weight),
                reps: Value(reps),
                isWarmup: isWarmup,
                isAssisted: isAssisted,
                index: index,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WorkoutSetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({itemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                    if (itemId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.itemId,
                                referencedTable: $$WorkoutSetsTableReferences
                                    ._itemIdTable(db),
                                referencedColumn: $$WorkoutSetsTableReferences
                                    ._itemIdTable(db)
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

typedef $$WorkoutSetsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $WorkoutSetsTable,
      WorkoutSetEntity,
      $$WorkoutSetsTableFilterComposer,
      $$WorkoutSetsTableOrderingComposer,
      $$WorkoutSetsTableAnnotationComposer,
      $$WorkoutSetsTableCreateCompanionBuilder,
      $$WorkoutSetsTableUpdateCompanionBuilder,
      (WorkoutSetEntity, $$WorkoutSetsTableReferences),
      WorkoutSetEntity,
      PrefetchHooks Function({bool itemId})
    >;
typedef $$LocalBodyPartsTableCreateCompanionBuilder =
    LocalBodyPartsCompanion Function({
      required String id,
      required String name,
      required int orderIndex,
      Value<bool> isArchived,
      Value<DateTime?> createdAt,
      Value<int> rowid,
    });
typedef $$LocalBodyPartsTableUpdateCompanionBuilder =
    LocalBodyPartsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> orderIndex,
      Value<bool> isArchived,
      Value<DateTime?> createdAt,
      Value<int> rowid,
    });

class $$LocalBodyPartsTableFilterComposer
    extends Composer<_$LocalDatabase, $LocalBodyPartsTable> {
  $$LocalBodyPartsTableFilterComposer({
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

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalBodyPartsTableOrderingComposer
    extends Composer<_$LocalDatabase, $LocalBodyPartsTable> {
  $$LocalBodyPartsTableOrderingComposer({
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

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalBodyPartsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $LocalBodyPartsTable> {
  $$LocalBodyPartsTableAnnotationComposer({
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

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$LocalBodyPartsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $LocalBodyPartsTable,
          LocalBodyPartEntity,
          $$LocalBodyPartsTableFilterComposer,
          $$LocalBodyPartsTableOrderingComposer,
          $$LocalBodyPartsTableAnnotationComposer,
          $$LocalBodyPartsTableCreateCompanionBuilder,
          $$LocalBodyPartsTableUpdateCompanionBuilder,
          (
            LocalBodyPartEntity,
            BaseReferences<
              _$LocalDatabase,
              $LocalBodyPartsTable,
              LocalBodyPartEntity
            >,
          ),
          LocalBodyPartEntity,
          PrefetchHooks Function()
        > {
  $$LocalBodyPartsTableTableManager(
    _$LocalDatabase db,
    $LocalBodyPartsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalBodyPartsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalBodyPartsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalBodyPartsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalBodyPartsCompanion(
                id: id,
                name: name,
                orderIndex: orderIndex,
                isArchived: isArchived,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required int orderIndex,
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalBodyPartsCompanion.insert(
                id: id,
                name: name,
                orderIndex: orderIndex,
                isArchived: isArchived,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalBodyPartsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $LocalBodyPartsTable,
      LocalBodyPartEntity,
      $$LocalBodyPartsTableFilterComposer,
      $$LocalBodyPartsTableOrderingComposer,
      $$LocalBodyPartsTableAnnotationComposer,
      $$LocalBodyPartsTableCreateCompanionBuilder,
      $$LocalBodyPartsTableUpdateCompanionBuilder,
      (
        LocalBodyPartEntity,
        BaseReferences<
          _$LocalDatabase,
          $LocalBodyPartsTable,
          LocalBodyPartEntity
        >,
      ),
      LocalBodyPartEntity,
      PrefetchHooks Function()
    >;
typedef $$LocalExercisesTableCreateCompanionBuilder =
    LocalExercisesCompanion Function({
      required String id,
      required String name,
      required String bodyPartId,
      required int orderIndex,
      Value<bool> isArchived,
      Value<DateTime?> createdAt,
      Value<int> rowid,
    });
typedef $$LocalExercisesTableUpdateCompanionBuilder =
    LocalExercisesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> bodyPartId,
      Value<int> orderIndex,
      Value<bool> isArchived,
      Value<DateTime?> createdAt,
      Value<int> rowid,
    });

class $$LocalExercisesTableFilterComposer
    extends Composer<_$LocalDatabase, $LocalExercisesTable> {
  $$LocalExercisesTableFilterComposer({
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

  ColumnFilters<String> get bodyPartId => $composableBuilder(
    column: $table.bodyPartId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalExercisesTableOrderingComposer
    extends Composer<_$LocalDatabase, $LocalExercisesTable> {
  $$LocalExercisesTableOrderingComposer({
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

  ColumnOrderings<String> get bodyPartId => $composableBuilder(
    column: $table.bodyPartId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalExercisesTableAnnotationComposer
    extends Composer<_$LocalDatabase, $LocalExercisesTable> {
  $$LocalExercisesTableAnnotationComposer({
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

  GeneratedColumn<String> get bodyPartId => $composableBuilder(
    column: $table.bodyPartId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$LocalExercisesTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $LocalExercisesTable,
          LocalExerciseEntity,
          $$LocalExercisesTableFilterComposer,
          $$LocalExercisesTableOrderingComposer,
          $$LocalExercisesTableAnnotationComposer,
          $$LocalExercisesTableCreateCompanionBuilder,
          $$LocalExercisesTableUpdateCompanionBuilder,
          (
            LocalExerciseEntity,
            BaseReferences<
              _$LocalDatabase,
              $LocalExercisesTable,
              LocalExerciseEntity
            >,
          ),
          LocalExerciseEntity,
          PrefetchHooks Function()
        > {
  $$LocalExercisesTableTableManager(
    _$LocalDatabase db,
    $LocalExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> bodyPartId = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalExercisesCompanion(
                id: id,
                name: name,
                bodyPartId: bodyPartId,
                orderIndex: orderIndex,
                isArchived: isArchived,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String bodyPartId,
                required int orderIndex,
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalExercisesCompanion.insert(
                id: id,
                name: name,
                bodyPartId: bodyPartId,
                orderIndex: orderIndex,
                isArchived: isArchived,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $LocalExercisesTable,
      LocalExerciseEntity,
      $$LocalExercisesTableFilterComposer,
      $$LocalExercisesTableOrderingComposer,
      $$LocalExercisesTableAnnotationComposer,
      $$LocalExercisesTableCreateCompanionBuilder,
      $$LocalExercisesTableUpdateCompanionBuilder,
      (
        LocalExerciseEntity,
        BaseReferences<
          _$LocalDatabase,
          $LocalExercisesTable,
          LocalExerciseEntity
        >,
      ),
      LocalExerciseEntity,
      PrefetchHooks Function()
    >;
typedef $$LocalEconomyStateTableCreateCompanionBuilder =
    LocalEconomyStateCompanion Function({
      required String id,
      Value<int> totalCoins,
      Value<int> fishingTickets,
      Value<String?> equippedTitleId,
      Value<int> rowid,
    });
typedef $$LocalEconomyStateTableUpdateCompanionBuilder =
    LocalEconomyStateCompanion Function({
      Value<String> id,
      Value<int> totalCoins,
      Value<int> fishingTickets,
      Value<String?> equippedTitleId,
      Value<int> rowid,
    });

class $$LocalEconomyStateTableFilterComposer
    extends Composer<_$LocalDatabase, $LocalEconomyStateTable> {
  $$LocalEconomyStateTableFilterComposer({
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

  ColumnFilters<int> get totalCoins => $composableBuilder(
    column: $table.totalCoins,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fishingTickets => $composableBuilder(
    column: $table.fishingTickets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get equippedTitleId => $composableBuilder(
    column: $table.equippedTitleId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalEconomyStateTableOrderingComposer
    extends Composer<_$LocalDatabase, $LocalEconomyStateTable> {
  $$LocalEconomyStateTableOrderingComposer({
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

  ColumnOrderings<int> get totalCoins => $composableBuilder(
    column: $table.totalCoins,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fishingTickets => $composableBuilder(
    column: $table.fishingTickets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equippedTitleId => $composableBuilder(
    column: $table.equippedTitleId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalEconomyStateTableAnnotationComposer
    extends Composer<_$LocalDatabase, $LocalEconomyStateTable> {
  $$LocalEconomyStateTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get totalCoins => $composableBuilder(
    column: $table.totalCoins,
    builder: (column) => column,
  );

  GeneratedColumn<int> get fishingTickets => $composableBuilder(
    column: $table.fishingTickets,
    builder: (column) => column,
  );

  GeneratedColumn<String> get equippedTitleId => $composableBuilder(
    column: $table.equippedTitleId,
    builder: (column) => column,
  );
}

class $$LocalEconomyStateTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $LocalEconomyStateTable,
          LocalEconomyStateEntity,
          $$LocalEconomyStateTableFilterComposer,
          $$LocalEconomyStateTableOrderingComposer,
          $$LocalEconomyStateTableAnnotationComposer,
          $$LocalEconomyStateTableCreateCompanionBuilder,
          $$LocalEconomyStateTableUpdateCompanionBuilder,
          (
            LocalEconomyStateEntity,
            BaseReferences<
              _$LocalDatabase,
              $LocalEconomyStateTable,
              LocalEconomyStateEntity
            >,
          ),
          LocalEconomyStateEntity,
          PrefetchHooks Function()
        > {
  $$LocalEconomyStateTableTableManager(
    _$LocalDatabase db,
    $LocalEconomyStateTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalEconomyStateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalEconomyStateTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalEconomyStateTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> totalCoins = const Value.absent(),
                Value<int> fishingTickets = const Value.absent(),
                Value<String?> equippedTitleId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalEconomyStateCompanion(
                id: id,
                totalCoins: totalCoins,
                fishingTickets: fishingTickets,
                equippedTitleId: equippedTitleId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<int> totalCoins = const Value.absent(),
                Value<int> fishingTickets = const Value.absent(),
                Value<String?> equippedTitleId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalEconomyStateCompanion.insert(
                id: id,
                totalCoins: totalCoins,
                fishingTickets: fishingTickets,
                equippedTitleId: equippedTitleId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalEconomyStateTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $LocalEconomyStateTable,
      LocalEconomyStateEntity,
      $$LocalEconomyStateTableFilterComposer,
      $$LocalEconomyStateTableOrderingComposer,
      $$LocalEconomyStateTableAnnotationComposer,
      $$LocalEconomyStateTableCreateCompanionBuilder,
      $$LocalEconomyStateTableUpdateCompanionBuilder,
      (
        LocalEconomyStateEntity,
        BaseReferences<
          _$LocalDatabase,
          $LocalEconomyStateTable,
          LocalEconomyStateEntity
        >,
      ),
      LocalEconomyStateEntity,
      PrefetchHooks Function()
    >;
typedef $$LocalAchievementsTableCreateCompanionBuilder =
    LocalAchievementsCompanion Function({
      required String achievementKey,
      Value<int> count,
      Value<int> rowid,
    });
typedef $$LocalAchievementsTableUpdateCompanionBuilder =
    LocalAchievementsCompanion Function({
      Value<String> achievementKey,
      Value<int> count,
      Value<int> rowid,
    });

class $$LocalAchievementsTableFilterComposer
    extends Composer<_$LocalDatabase, $LocalAchievementsTable> {
  $$LocalAchievementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get achievementKey => $composableBuilder(
    column: $table.achievementKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalAchievementsTableOrderingComposer
    extends Composer<_$LocalDatabase, $LocalAchievementsTable> {
  $$LocalAchievementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get achievementKey => $composableBuilder(
    column: $table.achievementKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalAchievementsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $LocalAchievementsTable> {
  $$LocalAchievementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get achievementKey => $composableBuilder(
    column: $table.achievementKey,
    builder: (column) => column,
  );

  GeneratedColumn<int> get count =>
      $composableBuilder(column: $table.count, builder: (column) => column);
}

class $$LocalAchievementsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $LocalAchievementsTable,
          LocalAchievementEntity,
          $$LocalAchievementsTableFilterComposer,
          $$LocalAchievementsTableOrderingComposer,
          $$LocalAchievementsTableAnnotationComposer,
          $$LocalAchievementsTableCreateCompanionBuilder,
          $$LocalAchievementsTableUpdateCompanionBuilder,
          (
            LocalAchievementEntity,
            BaseReferences<
              _$LocalDatabase,
              $LocalAchievementsTable,
              LocalAchievementEntity
            >,
          ),
          LocalAchievementEntity,
          PrefetchHooks Function()
        > {
  $$LocalAchievementsTableTableManager(
    _$LocalDatabase db,
    $LocalAchievementsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalAchievementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalAchievementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalAchievementsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> achievementKey = const Value.absent(),
                Value<int> count = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalAchievementsCompanion(
                achievementKey: achievementKey,
                count: count,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String achievementKey,
                Value<int> count = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalAchievementsCompanion.insert(
                achievementKey: achievementKey,
                count: count,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalAchievementsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $LocalAchievementsTable,
      LocalAchievementEntity,
      $$LocalAchievementsTableFilterComposer,
      $$LocalAchievementsTableOrderingComposer,
      $$LocalAchievementsTableAnnotationComposer,
      $$LocalAchievementsTableCreateCompanionBuilder,
      $$LocalAchievementsTableUpdateCompanionBuilder,
      (
        LocalAchievementEntity,
        BaseReferences<
          _$LocalDatabase,
          $LocalAchievementsTable,
          LocalAchievementEntity
        >,
      ),
      LocalAchievementEntity,
      PrefetchHooks Function()
    >;
typedef $$LocalInventoryTableCreateCompanionBuilder =
    LocalInventoryCompanion Function({
      required String id,
      required String itemId,
      required int remainingUses,
      required DateTime acquiredAt,
      Value<bool> isEquipped,
      Value<int> rowid,
    });
typedef $$LocalInventoryTableUpdateCompanionBuilder =
    LocalInventoryCompanion Function({
      Value<String> id,
      Value<String> itemId,
      Value<int> remainingUses,
      Value<DateTime> acquiredAt,
      Value<bool> isEquipped,
      Value<int> rowid,
    });

class $$LocalInventoryTableFilterComposer
    extends Composer<_$LocalDatabase, $LocalInventoryTable> {
  $$LocalInventoryTableFilterComposer({
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

  ColumnFilters<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get remainingUses => $composableBuilder(
    column: $table.remainingUses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get acquiredAt => $composableBuilder(
    column: $table.acquiredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEquipped => $composableBuilder(
    column: $table.isEquipped,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalInventoryTableOrderingComposer
    extends Composer<_$LocalDatabase, $LocalInventoryTable> {
  $$LocalInventoryTableOrderingComposer({
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

  ColumnOrderings<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get remainingUses => $composableBuilder(
    column: $table.remainingUses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get acquiredAt => $composableBuilder(
    column: $table.acquiredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEquipped => $composableBuilder(
    column: $table.isEquipped,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalInventoryTableAnnotationComposer
    extends Composer<_$LocalDatabase, $LocalInventoryTable> {
  $$LocalInventoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<int> get remainingUses => $composableBuilder(
    column: $table.remainingUses,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get acquiredAt => $composableBuilder(
    column: $table.acquiredAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isEquipped => $composableBuilder(
    column: $table.isEquipped,
    builder: (column) => column,
  );
}

class $$LocalInventoryTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $LocalInventoryTable,
          LocalInventoryEntity,
          $$LocalInventoryTableFilterComposer,
          $$LocalInventoryTableOrderingComposer,
          $$LocalInventoryTableAnnotationComposer,
          $$LocalInventoryTableCreateCompanionBuilder,
          $$LocalInventoryTableUpdateCompanionBuilder,
          (
            LocalInventoryEntity,
            BaseReferences<
              _$LocalDatabase,
              $LocalInventoryTable,
              LocalInventoryEntity
            >,
          ),
          LocalInventoryEntity,
          PrefetchHooks Function()
        > {
  $$LocalInventoryTableTableManager(
    _$LocalDatabase db,
    $LocalInventoryTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalInventoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalInventoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalInventoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> itemId = const Value.absent(),
                Value<int> remainingUses = const Value.absent(),
                Value<DateTime> acquiredAt = const Value.absent(),
                Value<bool> isEquipped = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalInventoryCompanion(
                id: id,
                itemId: itemId,
                remainingUses: remainingUses,
                acquiredAt: acquiredAt,
                isEquipped: isEquipped,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String itemId,
                required int remainingUses,
                required DateTime acquiredAt,
                Value<bool> isEquipped = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalInventoryCompanion.insert(
                id: id,
                itemId: itemId,
                remainingUses: remainingUses,
                acquiredAt: acquiredAt,
                isEquipped: isEquipped,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalInventoryTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $LocalInventoryTable,
      LocalInventoryEntity,
      $$LocalInventoryTableFilterComposer,
      $$LocalInventoryTableOrderingComposer,
      $$LocalInventoryTableAnnotationComposer,
      $$LocalInventoryTableCreateCompanionBuilder,
      $$LocalInventoryTableUpdateCompanionBuilder,
      (
        LocalInventoryEntity,
        BaseReferences<
          _$LocalDatabase,
          $LocalInventoryTable,
          LocalInventoryEntity
        >,
      ),
      LocalInventoryEntity,
      PrefetchHooks Function()
    >;
typedef $$LocalFishCollectionTableCreateCompanionBuilder =
    LocalFishCollectionCompanion Function({
      required String fishId,
      Value<int> count,
      Value<int> rowid,
    });
typedef $$LocalFishCollectionTableUpdateCompanionBuilder =
    LocalFishCollectionCompanion Function({
      Value<String> fishId,
      Value<int> count,
      Value<int> rowid,
    });

class $$LocalFishCollectionTableFilterComposer
    extends Composer<_$LocalDatabase, $LocalFishCollectionTable> {
  $$LocalFishCollectionTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get fishId => $composableBuilder(
    column: $table.fishId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalFishCollectionTableOrderingComposer
    extends Composer<_$LocalDatabase, $LocalFishCollectionTable> {
  $$LocalFishCollectionTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get fishId => $composableBuilder(
    column: $table.fishId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalFishCollectionTableAnnotationComposer
    extends Composer<_$LocalDatabase, $LocalFishCollectionTable> {
  $$LocalFishCollectionTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get fishId =>
      $composableBuilder(column: $table.fishId, builder: (column) => column);

  GeneratedColumn<int> get count =>
      $composableBuilder(column: $table.count, builder: (column) => column);
}

class $$LocalFishCollectionTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $LocalFishCollectionTable,
          LocalFishCollectionEntity,
          $$LocalFishCollectionTableFilterComposer,
          $$LocalFishCollectionTableOrderingComposer,
          $$LocalFishCollectionTableAnnotationComposer,
          $$LocalFishCollectionTableCreateCompanionBuilder,
          $$LocalFishCollectionTableUpdateCompanionBuilder,
          (
            LocalFishCollectionEntity,
            BaseReferences<
              _$LocalDatabase,
              $LocalFishCollectionTable,
              LocalFishCollectionEntity
            >,
          ),
          LocalFishCollectionEntity,
          PrefetchHooks Function()
        > {
  $$LocalFishCollectionTableTableManager(
    _$LocalDatabase db,
    $LocalFishCollectionTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalFishCollectionTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalFishCollectionTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalFishCollectionTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> fishId = const Value.absent(),
                Value<int> count = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalFishCollectionCompanion(
                fishId: fishId,
                count: count,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String fishId,
                Value<int> count = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalFishCollectionCompanion.insert(
                fishId: fishId,
                count: count,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalFishCollectionTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $LocalFishCollectionTable,
      LocalFishCollectionEntity,
      $$LocalFishCollectionTableFilterComposer,
      $$LocalFishCollectionTableOrderingComposer,
      $$LocalFishCollectionTableAnnotationComposer,
      $$LocalFishCollectionTableCreateCompanionBuilder,
      $$LocalFishCollectionTableUpdateCompanionBuilder,
      (
        LocalFishCollectionEntity,
        BaseReferences<
          _$LocalDatabase,
          $LocalFishCollectionTable,
          LocalFishCollectionEntity
        >,
      ),
      LocalFishCollectionEntity,
      PrefetchHooks Function()
    >;
typedef $$LocalPurchasedItemsTableCreateCompanionBuilder =
    LocalPurchasedItemsCompanion Function({
      required String itemId,
      Value<DateTime?> purchasedAt,
      Value<int> rowid,
    });
typedef $$LocalPurchasedItemsTableUpdateCompanionBuilder =
    LocalPurchasedItemsCompanion Function({
      Value<String> itemId,
      Value<DateTime?> purchasedAt,
      Value<int> rowid,
    });

class $$LocalPurchasedItemsTableFilterComposer
    extends Composer<_$LocalDatabase, $LocalPurchasedItemsTable> {
  $$LocalPurchasedItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalPurchasedItemsTableOrderingComposer
    extends Composer<_$LocalDatabase, $LocalPurchasedItemsTable> {
  $$LocalPurchasedItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalPurchasedItemsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $LocalPurchasedItemsTable> {
  $$LocalPurchasedItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => column,
  );
}

class $$LocalPurchasedItemsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $LocalPurchasedItemsTable,
          LocalPurchasedItemEntity,
          $$LocalPurchasedItemsTableFilterComposer,
          $$LocalPurchasedItemsTableOrderingComposer,
          $$LocalPurchasedItemsTableAnnotationComposer,
          $$LocalPurchasedItemsTableCreateCompanionBuilder,
          $$LocalPurchasedItemsTableUpdateCompanionBuilder,
          (
            LocalPurchasedItemEntity,
            BaseReferences<
              _$LocalDatabase,
              $LocalPurchasedItemsTable,
              LocalPurchasedItemEntity
            >,
          ),
          LocalPurchasedItemEntity,
          PrefetchHooks Function()
        > {
  $$LocalPurchasedItemsTableTableManager(
    _$LocalDatabase db,
    $LocalPurchasedItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalPurchasedItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalPurchasedItemsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalPurchasedItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> itemId = const Value.absent(),
                Value<DateTime?> purchasedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalPurchasedItemsCompanion(
                itemId: itemId,
                purchasedAt: purchasedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String itemId,
                Value<DateTime?> purchasedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalPurchasedItemsCompanion.insert(
                itemId: itemId,
                purchasedAt: purchasedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalPurchasedItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $LocalPurchasedItemsTable,
      LocalPurchasedItemEntity,
      $$LocalPurchasedItemsTableFilterComposer,
      $$LocalPurchasedItemsTableOrderingComposer,
      $$LocalPurchasedItemsTableAnnotationComposer,
      $$LocalPurchasedItemsTableCreateCompanionBuilder,
      $$LocalPurchasedItemsTableUpdateCompanionBuilder,
      (
        LocalPurchasedItemEntity,
        BaseReferences<
          _$LocalDatabase,
          $LocalPurchasedItemsTable,
          LocalPurchasedItemEntity
        >,
      ),
      LocalPurchasedItemEntity,
      PrefetchHooks Function()
    >;
typedef $$LocalUnlockedTitlesTableCreateCompanionBuilder =
    LocalUnlockedTitlesCompanion Function({
      required String titleId,
      Value<DateTime?> unlockedAt,
      Value<int> rowid,
    });
typedef $$LocalUnlockedTitlesTableUpdateCompanionBuilder =
    LocalUnlockedTitlesCompanion Function({
      Value<String> titleId,
      Value<DateTime?> unlockedAt,
      Value<int> rowid,
    });

class $$LocalUnlockedTitlesTableFilterComposer
    extends Composer<_$LocalDatabase, $LocalUnlockedTitlesTable> {
  $$LocalUnlockedTitlesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get titleId => $composableBuilder(
    column: $table.titleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalUnlockedTitlesTableOrderingComposer
    extends Composer<_$LocalDatabase, $LocalUnlockedTitlesTable> {
  $$LocalUnlockedTitlesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get titleId => $composableBuilder(
    column: $table.titleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalUnlockedTitlesTableAnnotationComposer
    extends Composer<_$LocalDatabase, $LocalUnlockedTitlesTable> {
  $$LocalUnlockedTitlesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get titleId =>
      $composableBuilder(column: $table.titleId, builder: (column) => column);

  GeneratedColumn<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => column,
  );
}

class $$LocalUnlockedTitlesTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $LocalUnlockedTitlesTable,
          LocalUnlockedTitleEntity,
          $$LocalUnlockedTitlesTableFilterComposer,
          $$LocalUnlockedTitlesTableOrderingComposer,
          $$LocalUnlockedTitlesTableAnnotationComposer,
          $$LocalUnlockedTitlesTableCreateCompanionBuilder,
          $$LocalUnlockedTitlesTableUpdateCompanionBuilder,
          (
            LocalUnlockedTitleEntity,
            BaseReferences<
              _$LocalDatabase,
              $LocalUnlockedTitlesTable,
              LocalUnlockedTitleEntity
            >,
          ),
          LocalUnlockedTitleEntity,
          PrefetchHooks Function()
        > {
  $$LocalUnlockedTitlesTableTableManager(
    _$LocalDatabase db,
    $LocalUnlockedTitlesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalUnlockedTitlesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalUnlockedTitlesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalUnlockedTitlesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> titleId = const Value.absent(),
                Value<DateTime?> unlockedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalUnlockedTitlesCompanion(
                titleId: titleId,
                unlockedAt: unlockedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String titleId,
                Value<DateTime?> unlockedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalUnlockedTitlesCompanion.insert(
                titleId: titleId,
                unlockedAt: unlockedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalUnlockedTitlesTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $LocalUnlockedTitlesTable,
      LocalUnlockedTitleEntity,
      $$LocalUnlockedTitlesTableFilterComposer,
      $$LocalUnlockedTitlesTableOrderingComposer,
      $$LocalUnlockedTitlesTableAnnotationComposer,
      $$LocalUnlockedTitlesTableCreateCompanionBuilder,
      $$LocalUnlockedTitlesTableUpdateCompanionBuilder,
      (
        LocalUnlockedTitleEntity,
        BaseReferences<
          _$LocalDatabase,
          $LocalUnlockedTitlesTable,
          LocalUnlockedTitleEntity
        >,
      ),
      LocalUnlockedTitleEntity,
      PrefetchHooks Function()
    >;
typedef $$LocalBodyCompositionEntriesTableCreateCompanionBuilder =
    LocalBodyCompositionEntriesCompanion Function({
      required String id,
      required String dateKey,
      required DateTime timestamp,
      required double weight,
      Value<double?> bodyFatPercentage,
      Value<double?> muscleMass,
      Value<String?> note,
      Value<String> source,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$LocalBodyCompositionEntriesTableUpdateCompanionBuilder =
    LocalBodyCompositionEntriesCompanion Function({
      Value<String> id,
      Value<String> dateKey,
      Value<DateTime> timestamp,
      Value<double> weight,
      Value<double?> bodyFatPercentage,
      Value<double?> muscleMass,
      Value<String?> note,
      Value<String> source,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

class $$LocalBodyCompositionEntriesTableFilterComposer
    extends Composer<_$LocalDatabase, $LocalBodyCompositionEntriesTable> {
  $$LocalBodyCompositionEntriesTableFilterComposer({
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

  ColumnFilters<String> get dateKey => $composableBuilder(
    column: $table.dateKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bodyFatPercentage => $composableBuilder(
    column: $table.bodyFatPercentage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get muscleMass => $composableBuilder(
    column: $table.muscleMass,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalBodyCompositionEntriesTableOrderingComposer
    extends Composer<_$LocalDatabase, $LocalBodyCompositionEntriesTable> {
  $$LocalBodyCompositionEntriesTableOrderingComposer({
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

  ColumnOrderings<String> get dateKey => $composableBuilder(
    column: $table.dateKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bodyFatPercentage => $composableBuilder(
    column: $table.bodyFatPercentage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get muscleMass => $composableBuilder(
    column: $table.muscleMass,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalBodyCompositionEntriesTableAnnotationComposer
    extends Composer<_$LocalDatabase, $LocalBodyCompositionEntriesTable> {
  $$LocalBodyCompositionEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dateKey =>
      $composableBuilder(column: $table.dateKey, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<double> get bodyFatPercentage => $composableBuilder(
    column: $table.bodyFatPercentage,
    builder: (column) => column,
  );

  GeneratedColumn<double> get muscleMass => $composableBuilder(
    column: $table.muscleMass,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalBodyCompositionEntriesTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $LocalBodyCompositionEntriesTable,
          LocalBodyCompositionEntryEntity,
          $$LocalBodyCompositionEntriesTableFilterComposer,
          $$LocalBodyCompositionEntriesTableOrderingComposer,
          $$LocalBodyCompositionEntriesTableAnnotationComposer,
          $$LocalBodyCompositionEntriesTableCreateCompanionBuilder,
          $$LocalBodyCompositionEntriesTableUpdateCompanionBuilder,
          (
            LocalBodyCompositionEntryEntity,
            BaseReferences<
              _$LocalDatabase,
              $LocalBodyCompositionEntriesTable,
              LocalBodyCompositionEntryEntity
            >,
          ),
          LocalBodyCompositionEntryEntity,
          PrefetchHooks Function()
        > {
  $$LocalBodyCompositionEntriesTableTableManager(
    _$LocalDatabase db,
    $LocalBodyCompositionEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalBodyCompositionEntriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LocalBodyCompositionEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalBodyCompositionEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> dateKey = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<double> weight = const Value.absent(),
                Value<double?> bodyFatPercentage = const Value.absent(),
                Value<double?> muscleMass = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalBodyCompositionEntriesCompanion(
                id: id,
                dateKey: dateKey,
                timestamp: timestamp,
                weight: weight,
                bodyFatPercentage: bodyFatPercentage,
                muscleMass: muscleMass,
                note: note,
                source: source,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String dateKey,
                required DateTime timestamp,
                required double weight,
                Value<double?> bodyFatPercentage = const Value.absent(),
                Value<double?> muscleMass = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalBodyCompositionEntriesCompanion.insert(
                id: id,
                dateKey: dateKey,
                timestamp: timestamp,
                weight: weight,
                bodyFatPercentage: bodyFatPercentage,
                muscleMass: muscleMass,
                note: note,
                source: source,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalBodyCompositionEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $LocalBodyCompositionEntriesTable,
      LocalBodyCompositionEntryEntity,
      $$LocalBodyCompositionEntriesTableFilterComposer,
      $$LocalBodyCompositionEntriesTableOrderingComposer,
      $$LocalBodyCompositionEntriesTableAnnotationComposer,
      $$LocalBodyCompositionEntriesTableCreateCompanionBuilder,
      $$LocalBodyCompositionEntriesTableUpdateCompanionBuilder,
      (
        LocalBodyCompositionEntryEntity,
        BaseReferences<
          _$LocalDatabase,
          $LocalBodyCompositionEntriesTable,
          LocalBodyCompositionEntryEntity
        >,
      ),
      LocalBodyCompositionEntryEntity,
      PrefetchHooks Function()
    >;
typedef $$LocalUserProfilesTableCreateCompanionBuilder =
    LocalUserProfilesCompanion Function({
      required String uid,
      Value<String?> email,
      Value<String?> displayName,
      Value<int> weeklyGoal,
      Value<String> weekStartsOn,
      Value<DateTime?> weeklyGoalUpdatedAt,
      Value<DateTime?> weeklyGoalAnchor,
      Value<int> lastRewardedCycleIndex,
      Value<bool> vibrationOn,
      Value<bool> notificationsOn,
      Value<String> seenTutorials,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$LocalUserProfilesTableUpdateCompanionBuilder =
    LocalUserProfilesCompanion Function({
      Value<String> uid,
      Value<String?> email,
      Value<String?> displayName,
      Value<int> weeklyGoal,
      Value<String> weekStartsOn,
      Value<DateTime?> weeklyGoalUpdatedAt,
      Value<DateTime?> weeklyGoalAnchor,
      Value<int> lastRewardedCycleIndex,
      Value<bool> vibrationOn,
      Value<bool> notificationsOn,
      Value<String> seenTutorials,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

class $$LocalUserProfilesTableFilterComposer
    extends Composer<_$LocalDatabase, $LocalUserProfilesTable> {
  $$LocalUserProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weeklyGoal => $composableBuilder(
    column: $table.weeklyGoal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weekStartsOn => $composableBuilder(
    column: $table.weekStartsOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get weeklyGoalUpdatedAt => $composableBuilder(
    column: $table.weeklyGoalUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get weeklyGoalAnchor => $composableBuilder(
    column: $table.weeklyGoalAnchor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastRewardedCycleIndex => $composableBuilder(
    column: $table.lastRewardedCycleIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get vibrationOn => $composableBuilder(
    column: $table.vibrationOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notificationsOn => $composableBuilder(
    column: $table.notificationsOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get seenTutorials => $composableBuilder(
    column: $table.seenTutorials,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalUserProfilesTableOrderingComposer
    extends Composer<_$LocalDatabase, $LocalUserProfilesTable> {
  $$LocalUserProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weeklyGoal => $composableBuilder(
    column: $table.weeklyGoal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weekStartsOn => $composableBuilder(
    column: $table.weekStartsOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get weeklyGoalUpdatedAt => $composableBuilder(
    column: $table.weeklyGoalUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get weeklyGoalAnchor => $composableBuilder(
    column: $table.weeklyGoalAnchor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastRewardedCycleIndex => $composableBuilder(
    column: $table.lastRewardedCycleIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get vibrationOn => $composableBuilder(
    column: $table.vibrationOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notificationsOn => $composableBuilder(
    column: $table.notificationsOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get seenTutorials => $composableBuilder(
    column: $table.seenTutorials,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalUserProfilesTableAnnotationComposer
    extends Composer<_$LocalDatabase, $LocalUserProfilesTable> {
  $$LocalUserProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get uid =>
      $composableBuilder(column: $table.uid, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get weeklyGoal => $composableBuilder(
    column: $table.weeklyGoal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get weekStartsOn => $composableBuilder(
    column: $table.weekStartsOn,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get weeklyGoalUpdatedAt => $composableBuilder(
    column: $table.weeklyGoalUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get weeklyGoalAnchor => $composableBuilder(
    column: $table.weeklyGoalAnchor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastRewardedCycleIndex => $composableBuilder(
    column: $table.lastRewardedCycleIndex,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get vibrationOn => $composableBuilder(
    column: $table.vibrationOn,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get notificationsOn => $composableBuilder(
    column: $table.notificationsOn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get seenTutorials => $composableBuilder(
    column: $table.seenTutorials,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalUserProfilesTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $LocalUserProfilesTable,
          LocalUserProfileEntity,
          $$LocalUserProfilesTableFilterComposer,
          $$LocalUserProfilesTableOrderingComposer,
          $$LocalUserProfilesTableAnnotationComposer,
          $$LocalUserProfilesTableCreateCompanionBuilder,
          $$LocalUserProfilesTableUpdateCompanionBuilder,
          (
            LocalUserProfileEntity,
            BaseReferences<
              _$LocalDatabase,
              $LocalUserProfilesTable,
              LocalUserProfileEntity
            >,
          ),
          LocalUserProfileEntity,
          PrefetchHooks Function()
        > {
  $$LocalUserProfilesTableTableManager(
    _$LocalDatabase db,
    $LocalUserProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalUserProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalUserProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalUserProfilesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> uid = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<int> weeklyGoal = const Value.absent(),
                Value<String> weekStartsOn = const Value.absent(),
                Value<DateTime?> weeklyGoalUpdatedAt = const Value.absent(),
                Value<DateTime?> weeklyGoalAnchor = const Value.absent(),
                Value<int> lastRewardedCycleIndex = const Value.absent(),
                Value<bool> vibrationOn = const Value.absent(),
                Value<bool> notificationsOn = const Value.absent(),
                Value<String> seenTutorials = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalUserProfilesCompanion(
                uid: uid,
                email: email,
                displayName: displayName,
                weeklyGoal: weeklyGoal,
                weekStartsOn: weekStartsOn,
                weeklyGoalUpdatedAt: weeklyGoalUpdatedAt,
                weeklyGoalAnchor: weeklyGoalAnchor,
                lastRewardedCycleIndex: lastRewardedCycleIndex,
                vibrationOn: vibrationOn,
                notificationsOn: notificationsOn,
                seenTutorials: seenTutorials,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String uid,
                Value<String?> email = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<int> weeklyGoal = const Value.absent(),
                Value<String> weekStartsOn = const Value.absent(),
                Value<DateTime?> weeklyGoalUpdatedAt = const Value.absent(),
                Value<DateTime?> weeklyGoalAnchor = const Value.absent(),
                Value<int> lastRewardedCycleIndex = const Value.absent(),
                Value<bool> vibrationOn = const Value.absent(),
                Value<bool> notificationsOn = const Value.absent(),
                Value<String> seenTutorials = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalUserProfilesCompanion.insert(
                uid: uid,
                email: email,
                displayName: displayName,
                weeklyGoal: weeklyGoal,
                weekStartsOn: weekStartsOn,
                weeklyGoalUpdatedAt: weeklyGoalUpdatedAt,
                weeklyGoalAnchor: weeklyGoalAnchor,
                lastRewardedCycleIndex: lastRewardedCycleIndex,
                vibrationOn: vibrationOn,
                notificationsOn: notificationsOn,
                seenTutorials: seenTutorials,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalUserProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $LocalUserProfilesTable,
      LocalUserProfileEntity,
      $$LocalUserProfilesTableFilterComposer,
      $$LocalUserProfilesTableOrderingComposer,
      $$LocalUserProfilesTableAnnotationComposer,
      $$LocalUserProfilesTableCreateCompanionBuilder,
      $$LocalUserProfilesTableUpdateCompanionBuilder,
      (
        LocalUserProfileEntity,
        BaseReferences<
          _$LocalDatabase,
          $LocalUserProfilesTable,
          LocalUserProfileEntity
        >,
      ),
      LocalUserProfileEntity,
      PrefetchHooks Function()
    >;

class $LocalDatabaseManager {
  final _$LocalDatabase _db;
  $LocalDatabaseManager(this._db);
  $$WorkoutsTableTableManager get workouts =>
      $$WorkoutsTableTableManager(_db, _db.workouts);
  $$WorkoutItemsTableTableManager get workoutItems =>
      $$WorkoutItemsTableTableManager(_db, _db.workoutItems);
  $$WorkoutSetsTableTableManager get workoutSets =>
      $$WorkoutSetsTableTableManager(_db, _db.workoutSets);
  $$LocalBodyPartsTableTableManager get localBodyParts =>
      $$LocalBodyPartsTableTableManager(_db, _db.localBodyParts);
  $$LocalExercisesTableTableManager get localExercises =>
      $$LocalExercisesTableTableManager(_db, _db.localExercises);
  $$LocalEconomyStateTableTableManager get localEconomyState =>
      $$LocalEconomyStateTableTableManager(_db, _db.localEconomyState);
  $$LocalAchievementsTableTableManager get localAchievements =>
      $$LocalAchievementsTableTableManager(_db, _db.localAchievements);
  $$LocalInventoryTableTableManager get localInventory =>
      $$LocalInventoryTableTableManager(_db, _db.localInventory);
  $$LocalFishCollectionTableTableManager get localFishCollection =>
      $$LocalFishCollectionTableTableManager(_db, _db.localFishCollection);
  $$LocalPurchasedItemsTableTableManager get localPurchasedItems =>
      $$LocalPurchasedItemsTableTableManager(_db, _db.localPurchasedItems);
  $$LocalUnlockedTitlesTableTableManager get localUnlockedTitles =>
      $$LocalUnlockedTitlesTableTableManager(_db, _db.localUnlockedTitles);
  $$LocalBodyCompositionEntriesTableTableManager
  get localBodyCompositionEntries =>
      $$LocalBodyCompositionEntriesTableTableManager(
        _db,
        _db.localBodyCompositionEntries,
      );
  $$LocalUserProfilesTableTableManager get localUserProfiles =>
      $$LocalUserProfilesTableTableManager(_db, _db.localUserProfiles);
}
