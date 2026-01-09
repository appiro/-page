import 'package:drift/drift.dart';
import '../data/local_database.dart';
import '../models/workout.dart';
import '../models/workout_item.dart';
import '../models/workout_set.dart';
import '../models/body_part.dart';
import '../models/exercise.dart';
import '../models/user_profile.dart';
import '../models/economy_state.dart';
import '../models/body_composition_entry.dart';
import 'fit_repository.dart';
import 'package:uuid/uuid.dart';
import 'package:collection/collection.dart'; // Keep if needed, though usually for list ops

class LocalRepository implements FitRepository {
  final LocalDatabase _db;
  final Uuid _uuid = const Uuid();

  LocalRepository(this._db);

  // ==================== User Profile ====================

  @override
  Future<UserProfile?> getUserProfile(String uid) async {
    final entity = await (_db.select(_db.localUserProfiles)..where((t) => t.uid.equals(uid))).getSingleOrNull();
    
    if (entity != null) {
      return UserProfile(
        uid: entity.uid,
        email: entity.email ?? '',
        displayName: entity.displayName ?? 'Guest User',
        weeklyGoal: entity.weeklyGoal,
        weekStartsOn: entity.weekStartsOn,
        weeklyGoalUpdatedAt: entity.weeklyGoalUpdatedAt,
        vibrationOn: entity.vibrationOn,
        notificationsOn: entity.notificationsOn,
        createdAt: entity.createdAt ?? DateTime.now(),
        updatedAt: entity.updatedAt ?? DateTime.now(),
      );
    }

    // Return default profile for guest and save it
    final defaultProfile = UserProfile(
      uid: uid,
      email: 'guest@example.com',
      displayName: 'Guest User',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Save default to DB
    await _db.into(_db.localUserProfiles).insert(LocalUserProfilesCompanion.insert(
      uid: uid,
      email: Value(defaultProfile.email),
      displayName: Value(defaultProfile.displayName),
      weeklyGoal: Value(defaultProfile.weeklyGoal),
      weekStartsOn: Value(defaultProfile.weekStartsOn),
      vibrationOn: Value(defaultProfile.vibrationOn),
      notificationsOn: Value(defaultProfile.notificationsOn),
      createdAt: Value(defaultProfile.createdAt),
      updatedAt: Value(defaultProfile.updatedAt),
    ));

    return defaultProfile;
  }

  @override
  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    // Ensure profile exists
    final exists = await (_db.select(_db.localUserProfiles)..where((t) => t.uid.equals(uid))).getSingleOrNull();

    if (exists == null) {
       await getUserProfile(uid); // Creates default
    }

    final companion = LocalUserProfilesCompanion(
      email: data.containsKey('email') ? Value(data['email']) : const Value.absent(),
      displayName: data.containsKey('displayName') ? Value(data['displayName']) : const Value.absent(),
      weeklyGoal: data.containsKey('weeklyGoal') ? Value(data['weeklyGoal']) : const Value.absent(),
      weekStartsOn: data.containsKey('weekStartsOn') ? Value(data['weekStartsOn']) : const Value.absent(),
      weeklyGoalUpdatedAt: data.containsKey('weeklyGoalUpdatedAt') 
          ? Value(data['weeklyGoalUpdatedAt'] as DateTime?) 
          : const Value.absent(),
      vibrationOn: data.containsKey('vibrationOn') ? Value(data['vibrationOn']) : const Value.absent(),
      notificationsOn: data.containsKey('notificationsOn') ? Value(data['notificationsOn']) : const Value.absent(),
      updatedAt: Value(DateTime.now()),
    );

    await (_db.update(_db.localUserProfiles)..where((t) => t.uid.equals(uid))).write(companion);
  }

  // ==================== Workouts ====================

  Future<Workout> _getDetailedWorkout(WorkoutEntity entity) async {
    final items = await (
      _db.select(_db.workoutItems)
        ..where((t) => t.workoutId.equals(entity.id))
        ..orderBy([(t) => OrderingTerm(expression: t.orderIndex)])
    ).get();

    List<WorkoutItem> workoutItems = [];

    for (var itemEntity in items) {
      final sets = await (
        _db.select(_db.workoutSets)
          ..where((t) => t.itemId.equals(itemEntity.id))
          ..orderBy([(t) => OrderingTerm(expression: t.index)])
      ).get();

      // Fetch exercise details to get name and body part
      final exercise = await (_db.select(_db.localExercises)
        ..where((t) => t.id.equals(itemEntity.exerciseId))
      ).getSingleOrNull();

      String exerciseName = 'Unknown Exercise';
      String bodyPartId = '';
      String bodyPartName = 'Unknown';

      if (exercise != null) {
        exerciseName = exercise.name;
        bodyPartId = exercise.bodyPartId;

        final bodyPart = await (_db.select(_db.localBodyParts)
          ..where((t) => t.id.equals(exercise.bodyPartId))
        ).getSingleOrNull();
        if (bodyPart != null) {
          bodyPartName = bodyPart.name;
        }
      }

      workoutItems.add(WorkoutItem(
        // WorkoutItem model does not have 'id'
        exerciseId: itemEntity.exerciseId,
        exerciseName: exerciseName,
        bodyPartId: bodyPartId,
        bodyPartName: bodyPartName,
        order: itemEntity.orderIndex,
        memo: itemEntity.memo,
        sets: sets.map((s) => WorkoutSet(
          // WorkoutSet model does not have 'id'
          weight: s.weight,
          reps: s.reps,
          assisted: s.isAssisted,
          // isWarmup removed as it is not in WorkoutSet model
        )).toList(),
      ));
    }

    return Workout(
      id: entity.id,
      workoutDateKey: entity.workoutDateKey,
      title: entity.title,
      note: entity.note,
      items: workoutItems,
      coinGranted: entity.coinReward > 0, // Using coinReward > 0 to imply granted
      createdAt: DateTime.now(), // Fallback
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<Workout> createWorkout(String uid, Workout workout) async {
    final workoutId = workout.id.isEmpty ? _uuid.v4() : workout.id;
    final workoutToSave = workout.copyWith(id: workoutId);

    // Transaction to save everything
    await _db.transaction(() async {
      await _db.into(_db.workouts).insert(WorkoutsCompanion.insert(
        id: workoutId,
        userId: uid,
        title: workoutToSave.title,
        note: workoutToSave.note,
        workoutDateKey: workoutToSave.workoutDateKey,
        isCompleted: Value(false),
        coinReward: Value(workoutToSave.coinGranted ? 1 : 0), // Simple mapping
      ));

      for (var i = 0; i < workoutToSave.items.length; i++) {
        final item = workoutToSave.items[i];
        final itemId = _uuid.v4(); // Generate ID since model doesn't have it
        
        await _db.into(_db.workoutItems).insert(WorkoutItemsCompanion.insert(
          id: itemId,
          workoutId: workoutId,
          exerciseId: item.exerciseId,
          memo: item.memo,
          orderIndex: i,
        ));

        for (var j = 0; j < item.sets.length; j++) {
          final set = item.sets[j];
          final setId = _uuid.v4(); // Generate ID
          
          await _db.into(_db.workoutSets).insert(WorkoutSetsCompanion.insert(
            id: setId,
            itemId: itemId,
            weight: set.weight,
            reps: set.reps,
            isWarmup: Value(false), // Defaulting to false as model doesn't track it
            isAssisted: Value(set.assisted),
            index: j,
          ));
        }
      }
    });
    
    return workoutToSave; 
  }

  @override
  Future<void> updateWorkout(String uid, Workout workout) async {
    await _db.transaction(() async {
      // Update workout details
      await (_db.update(_db.workouts)..where((t) => t.id.equals(workout.id))).write(
        WorkoutsCompanion(
          title: Value(workout.title),
          note: Value(workout.note),
          workoutDateKey: Value(workout.workoutDateKey),
          coinReward: Value(workout.coinGranted ? 1 : 0),
        ),
      );

      // Delete existing items/sets to replace them
      final existingItems = await (_db.select(_db.workoutItems)..where((t) => t.workoutId.equals(workout.id))).get();
      for (var item in existingItems) {
        await (_db.delete(_db.workoutSets)..where((t) => t.itemId.equals(item.id))).go();
      }
      await (_db.delete(_db.workoutItems)..where((t) => t.workoutId.equals(workout.id))).go();

      // Re-insert items
      for (var i = 0; i < workout.items.length; i++) {
        final item = workout.items[i];
        final itemId = _uuid.v4();
        
        await _db.into(_db.workoutItems).insert(WorkoutItemsCompanion.insert(
          id: itemId,
          workoutId: workout.id,
          exerciseId: item.exerciseId,
          memo: item.memo,
          orderIndex: i,
        ));

        for (var j = 0; j < item.sets.length; j++) {
          final set = item.sets[j];
          final setId = _uuid.v4();
          
          await _db.into(_db.workoutSets).insert(WorkoutSetsCompanion.insert(
            id: setId,
            itemId: itemId,
            weight: set.weight,
            reps: set.reps,
            isWarmup: Value(false),
            isAssisted: Value(set.assisted),
            index: j,
          ));
        }
      }
    });
  }

  @override
  Future<void> deleteWorkout(String uid, String workoutId) async {
    final existingItems = await (_db.select(_db.workoutItems)..where((t) => t.workoutId.equals(workoutId))).get();
    for (var item in existingItems) {
      await (_db.delete(_db.workoutSets)..where((t) => t.itemId.equals(item.id))).go();
    }
    await (_db.delete(_db.workoutItems)..where((t) => t.workoutId.equals(workoutId))).go();
    await (_db.delete(_db.workouts)..where((t) => t.id.equals(workoutId))).go();
  }

  @override
  Future<Workout?> getWorkout(String uid, String workoutId) async {
    final entity = await (_db.select(_db.workouts)..where((t) => t.id.equals(workoutId))).getSingleOrNull();
    if (entity == null) return null;
    return _getDetailedWorkout(entity);
  }

  @override
  Future<Workout?> getWorkoutByDate(String uid, String dateKey) async {
    final entity = await (_db.select(_db.workouts)..where((t) => t.workoutDateKey.equals(dateKey))).getSingleOrNull();
    if (entity == null) return null;
    return _getDetailedWorkout(entity);
  }

  @override
  Stream<List<Workout>> getWorkoutsStream(String uid) {
    return (_db.select(_db.workouts)
      ..orderBy([(t) => OrderingTerm(expression: t.workoutDateKey, mode: OrderingMode.desc)])
    ).watch().asyncMap((entities) async {
      return await Future.wait(entities.map((e) => _getDetailedWorkout(e)));
    });
  }

  @override
  Future<List<Workout>> getWorkoutsByDateRange(String uid, DateTime startDate, DateTime endDate) async {
    final startKey = '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}';
    final endKey = '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}';

    final entities = await (_db.select(_db.workouts)
      ..where((t) => t.workoutDateKey.isBetween(Variable(startKey), Variable(endKey)))
    ).get();

    return await Future.wait(entities.map((e) => _getDetailedWorkout(e)));
  }

  @override
  Future<List<Workout>> getWorkoutsForWeek(String uid, List<String> dateKeys) async {
    final entities = await (_db.select(_db.workouts)
      ..where((t) => t.workoutDateKey.isIn(dateKeys))
    ).get();

    return await Future.wait(entities.map((e) => _getDetailedWorkout(e)));
  }

  @override
  Future<List<String>> getDistinctWorkoutTitles(String uid) async {
    final query = _db.selectOnly(_db.workouts, distinct: true)
      ..addColumns([_db.workouts.title])
      ..where(_db.workouts.title.isNotNull() & _db.workouts.title.equals('').not());
      
    final results = await query.get();
    return results.map((row) => row.read(_db.workouts.title)!).toList();
  }

  @override
  Future<List<Workout>> searchWorkoutsByTitle(String uid, String titleQuery) async {
    final query = _db.select(_db.workouts)
      ..where((t) => t.title.like('%$titleQuery%'))
      ..orderBy([(t) => OrderingTerm(expression: t.workoutDateKey, mode: OrderingMode.desc)]);
      
    final entities = await query.get();
    
    final workouts = <Workout>[];
    for (final entity in entities) {
        workouts.add(await _getDetailedWorkout(entity));
    }
    return workouts;
  }

  @override
  Future<List<Map<String, dynamic>>> getLastRecordForExercise(String uid, String exerciseId, String beforeDateKey) async {
    // Join Workouts and WorkoutItems to find optimal previous record efficiently
    final query = _db.select(_db.workoutItems).join([
      innerJoin(_db.workouts, _db.workouts.id.equalsExp(_db.workoutItems.workoutId))
    ]);

    query.where(_db.workoutItems.exerciseId.equals(exerciseId) & 
                _db.workouts.workoutDateKey.isSmallerThanValue(beforeDateKey));
    
    query.orderBy([OrderingTerm(expression: _db.workouts.workoutDateKey, mode: OrderingMode.desc)]);
    query.limit(1);

    final result = await query.getSingleOrNull();

    if (result == null) return [];

    final item = result.readTable(_db.workoutItems);

    // Get sets for this item
    final sets = await (_db.select(_db.workoutSets)
      ..where((t) => t.itemId.equals(item.id))
      ..orderBy([(t) => OrderingTerm(expression: t.index)])
    ).get();

    return sets.map((s) => {
      'weight': s.weight,
      'reps': s.reps,
      'assisted': s.isAssisted,
    }).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getExerciseHistory(String uid, String exerciseId) async {
    // Join Workouts and WorkoutItems
    final query = _db.select(_db.workoutItems).join([
      innerJoin(_db.workouts, _db.workouts.id.equalsExp(_db.workoutItems.workoutId))
    ]);

    query.where(_db.workoutItems.exerciseId.equals(exerciseId));
    
    // Order by date descending
    query.orderBy([OrderingTerm(expression: _db.workouts.workoutDateKey, mode: OrderingMode.desc)]);

    final results = await query.get();
    
    List<Map<String, dynamic>> history = [];

    for (var result in results) {
      final item = result.readTable(_db.workoutItems);
      final workout = result.readTable(_db.workouts);
      
      // Get sets for this item
      final sets = await (_db.select(_db.workoutSets)
        ..where((t) => t.itemId.equals(item.id))
        ..orderBy([(t) => OrderingTerm(expression: t.index)])
      ).get();

      history.add({
        'workoutDateKey': workout.workoutDateKey,
        'sets': sets.map((s) => {
          'weight': s.weight,
          'reps': s.reps,
          'assisted': s.isAssisted,
        }).toList(),
      });
    }

    return history;
  }

  // ==================== Body Parts ====================

  @override
  Future<BodyPart> createBodyPart(String uid, String name, int order) async {
    final id = _uuid.v4();
    await _db.into(_db.localBodyParts).insert(LocalBodyPartsCompanion.insert(
      id: id,
      name: name,
      orderIndex: order,
    ));
    return BodyPart(id: id, name: name, order: order, createdAt: DateTime.now());
  }

  @override
  Future<void> updateBodyPart(String uid, BodyPart bodyPart) async {
    await (_db.update(_db.localBodyParts)..where((t) => t.id.equals(bodyPart.id))).write(
      LocalBodyPartsCompanion(
        name: Value(bodyPart.name),
        orderIndex: Value(bodyPart.order),
      ),
    );
  }

  @override
  Stream<List<BodyPart>> getBodyPartsStream(String uid) {
    return (_db.select(_db.localBodyParts)
      ..where((t) => t.isArchived.equals(false))
      ..orderBy([(t) => OrderingTerm(expression: t.orderIndex)])
    ).watch().map((entities) => entities.map((e) => BodyPart(
      id: e.id,
      name: e.name,
      order: e.orderIndex,
      createdAt: e.createdAt ?? DateTime.now(),
    )).toList());
  }

  @override
  Future<List<BodyPart>> getBodyParts(String uid) async {
    final entities = await (_db.select(_db.localBodyParts)
      ..where((t) => t.isArchived.equals(false))
    ).get();
    
    return entities.map((e) => BodyPart(
      id: e.id,
      name: e.name,
      order: e.orderIndex,
      createdAt: e.createdAt ?? DateTime.now(),
    )).toList();
  }

  // ==================== Exercises ====================

  @override
  Future<Exercise> createExercise(String uid, String name, String bodyPartId, int order) async {
    final id = 'local_${_uuid.v4()}';
    await _db.into(_db.localExercises).insert(LocalExercisesCompanion.insert(
      id: id,
      name: name,
      bodyPartId: bodyPartId,
      orderIndex: order,
    ));
    return Exercise(id: id, name: name, bodyPartId: bodyPartId, order: order, createdAt: DateTime.now());
  }

  @override
  Future<void> updateExercise(String uid, Exercise exercise) async {
    await (_db.update(_db.localExercises)..where((t) => t.id.equals(exercise.id))).write(
      LocalExercisesCompanion(
        name: Value(exercise.name),
        bodyPartId: Value(exercise.bodyPartId),
        orderIndex: Value(exercise.order),
        isArchived: Value(exercise.isArchived),
      ),
    );
  }

  @override
  Stream<List<Exercise>> getExercisesStream(String uid) {
    return (_db.select(_db.localExercises)
      ..where((t) => t.isArchived.equals(false))
      ..orderBy([(t) => OrderingTerm(expression: t.orderIndex)])
    ).watch().map((entities) => entities.map((e) => Exercise(
      id: e.id,
      name: e.name,
      bodyPartId: e.bodyPartId,
      order: e.orderIndex,
      createdAt: e.createdAt ?? DateTime.now(),
    )).toList());
  }

  @override
  Future<Exercise?> getExercise(String uid, String exerciseId) async {
    final entity = await (_db.select(_db.localExercises)..where((t) => t.id.equals(exerciseId))).getSingleOrNull();
    if (entity == null) return null;
    return Exercise(
      id: entity.id,
      name: entity.name,
      bodyPartId: entity.bodyPartId,
      order: entity.orderIndex,
      createdAt: entity.createdAt ?? DateTime.now(),
    );
  }

  // ==================== Economy ====================

  @override
  Future<EconomyState> getEconomyState(String uid) async {
    final state = await (_db.select(_db.localEconomyState)).getSingleOrNull();
    final items = await _db.select(_db.localPurchasedItems).get();
    final titles = await _db.select(_db.localUnlockedTitles).get();

    return EconomyState(
      totalCoins: state?.totalCoins ?? 0,
      purchasedItemIds: items.map((i) => i.itemId).toList(),
      unlockedTitleIds: titles.map((t) => t.titleId).toList(),
      // Mappings below are empty because local store doesn't track equipped title etc efficiently yet
      // You might need to update LocalEconomyState table to store 'equippedTitleId' and others
      // For now, returning defaults
      equippedTitleId: null,
      achievementCounts: {},
    );
  }

  @override
  Future<void> updateEconomyState(String uid, EconomyState state) async {
    await _db.transaction(() async {
      // Update coins
      // Check if exists
      final exists = await (_db.select(_db.localEconomyState)).getSingleOrNull();
      if (exists != null) {
        await (_db.update(_db.localEconomyState)).write(LocalEconomyStateCompanion(
          totalCoins: Value(state.totalCoins),
        ));
      } else {
        await _db.into(_db.localEconomyState).insert(LocalEconomyStateCompanion(
          id: Value('state'),
          totalCoins: Value(state.totalCoins),
        ));
      }

      // Update items (simplified: just add new ones if not existing)
      for (var itemId in state.purchasedItemIds) {
        await _db.into(_db.localPurchasedItems).insertOnConflictUpdate(LocalPurchasedItemsCompanion(
          itemId: Value(itemId),
          purchasedAt: Value(DateTime.now()),
        ));
      }
      
      // Update titles
      for (var titleId in state.unlockedTitleIds) {
        await _db.into(_db.localUnlockedTitles).insertOnConflictUpdate(LocalUnlockedTitlesCompanion(
          titleId: Value(titleId),
          unlockedAt: Value(DateTime.now()),
        ));
      }
    });
  }

  @override
  Stream<EconomyState> getEconomyStateStream(String uid) {
    return _db.select(_db.localEconomyState).watchSingleOrNull().asyncMap((state) async {
      final items = await _db.select(_db.localPurchasedItems).get();
      final titles = await _db.select(_db.localUnlockedTitles).get();

      return EconomyState(
        totalCoins: state?.totalCoins ?? 0,
        purchasedItemIds: items.map((i) => i.itemId).toList(),
        unlockedTitleIds: titles.map((t) => t.titleId).toList(),
        equippedTitleId: null,
        achievementCounts: {},
      );
    });
  }


  // ==================== Body Composition ====================

  // ==================== Body Composition ====================

  @override
  Future<void> saveBodyCompositionEntry(String uid, BodyCompositionEntry entry) async {
    // Check if an entry already exists for this date
    final existing = await getBodyCompositionByDate(uid, entry.dateKey);
    
    // If exists, use the existing ID to ensure update instead of insert
    final entryId = existing?.id ?? entry.id;
    final createdAt = existing?.createdAt ?? entry.createdAt;
    
    await _db.into(_db.localBodyCompositionEntries).insertOnConflictUpdate(LocalBodyCompositionEntriesCompanion(
      id: Value(entryId),
      dateKey: Value(entry.dateKey),
      timestamp: Value(entry.timestamp),
      weight: Value(entry.weight),
      bodyFatPercentage: Value(entry.bodyFatPercentage),
      muscleMass: Value(entry.muscleMass),
      note: Value(entry.note),
      source: Value(entry.source),
      createdAt: Value(createdAt),
      updatedAt: Value(DateTime.now()),
    ));
  }

  @override
  Future<void> deleteBodyCompositionEntry(String uid, String entryId) async {
    await (_db.delete(_db.localBodyCompositionEntries)..where((t) => t.id.equals(entryId))).go();
  }

  @override
  Future<BodyCompositionEntry?> getBodyCompositionByDate(String uid, String dateKey) async {
    final entity = await (_db.select(_db.localBodyCompositionEntries)
      ..where((t) => t.dateKey.equals(dateKey))
    ).getSingleOrNull();

    if (entity == null) return null;

    return BodyCompositionEntry(
      id: entity.id,
      dateKey: entity.dateKey,
      timestamp: entity.timestamp,
      weight: entity.weight,
      bodyFatPercentage: entity.bodyFatPercentage,
      muscleMass: entity.muscleMass,
      note: entity.note,
      source: entity.source,
      createdAt: entity.createdAt ?? DateTime.now(),
      updatedAt: entity.updatedAt ?? DateTime.now(),
    );
  }

  @override
  Future<List<BodyCompositionEntry>> getBodyCompositionHistory(String uid, DateTime startDate, DateTime endDate) async {
    final startKey = '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}';
    final endKey = '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}';

    final entities = await (_db.select(_db.localBodyCompositionEntries)
      ..where((t) => t.dateKey.isBetween(Variable(startKey), Variable(endKey)))
      ..orderBy([(t) => OrderingTerm(expression: t.dateKey, mode: OrderingMode.asc)])
    ).get();

    return entities.map((e) => BodyCompositionEntry(
      id: e.id,
      dateKey: e.dateKey,
      timestamp: e.timestamp,
      weight: e.weight,
      bodyFatPercentage: e.bodyFatPercentage,
      muscleMass: e.muscleMass,
      note: e.note,
      source: e.source,
      createdAt: e.createdAt ?? DateTime.now(),
      updatedAt: e.updatedAt ?? DateTime.now(),
    )).toList();
  }

  @override
  Stream<List<BodyCompositionEntry>> getBodyCompositionStream(String uid) {
    return (_db.select(_db.localBodyCompositionEntries)
      ..orderBy([(t) => OrderingTerm(expression: t.dateKey, mode: OrderingMode.desc)])
    ).watch().map((entities) => entities.map((e) => BodyCompositionEntry(
      id: e.id,
      dateKey: e.dateKey,
      timestamp: e.timestamp,
      weight: e.weight,
      bodyFatPercentage: e.bodyFatPercentage,
      muscleMass: e.muscleMass,
      note: e.note,
      source: e.source,
      createdAt: e.createdAt ?? DateTime.now(),
      updatedAt: e.updatedAt ?? DateTime.now(),
    )).toList());
  }
}
