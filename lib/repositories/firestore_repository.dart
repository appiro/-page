import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/workout.dart';
import '../models/body_part.dart';
import '../models/exercise.dart';
import '../models/exercise_measure_type.dart';
import '../models/user_profile.dart';
import '../models/economy_state.dart';
import '../models/body_composition_entry.dart';
import '../utils/constants.dart';
import 'fit_repository.dart';

class FirestoreRepository implements FitRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get user reference
  DocumentReference _userDoc(String uid) {
    return _firestore.collection(AppConstants.usersCollection).doc(uid);
  }

  // ==================== User Profile ====================

  @override
  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      final doc = await _userDoc(uid).get();
      if (!doc.exists) return null;
      return UserProfile.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get user profile: ${e.toString()}');
    }
  }

  @override
  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = Timestamp.now();
      // Use set with merge to create document if it doesn't exist
      await _userDoc(uid).set(data, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to update user profile: ${e.toString()}');
    }
  }

  // ==================== Workouts ====================

  @override
  Future<Workout> createWorkout(String uid, Workout workout) async {
    try {
      final docRef = _userDoc(
        uid,
      ).collection(AppConstants.workoutsSubcollection).doc();

      final newWorkout = Workout(
        id: docRef.id,
        workoutDateKey: workout.workoutDateKey,
        title: workout.title,
        note: workout.note,
        items: workout.items,
        coinGranted: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await docRef.set(newWorkout.toFirestore());
      return newWorkout;
    } catch (e) {
      throw Exception('Failed to create workout: ${e.toString()}');
    }
  }

  @override
  Future<void> updateWorkout(String uid, Workout workout) async {
    try {
      final updatedWorkout = workout.copyWith(updatedAt: DateTime.now());
      await _userDoc(uid)
          .collection(AppConstants.workoutsSubcollection)
          .doc(workout.id)
          .update(updatedWorkout.toFirestore());
    } catch (e) {
      throw Exception('Failed to update workout: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteWorkout(String uid, String workoutId) async {
    try {
      await _userDoc(
        uid,
      ).collection(AppConstants.workoutsSubcollection).doc(workoutId).delete();
    } catch (e) {
      throw Exception('Failed to delete workout: ${e.toString()}');
    }
  }

  @override
  Future<Workout?> getWorkout(String uid, String workoutId) async {
    try {
      final doc = await _userDoc(
        uid,
      ).collection(AppConstants.workoutsSubcollection).doc(workoutId).get();

      if (!doc.exists) return null;
      return Workout.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get workout: ${e.toString()}');
    }
  }

  @override
  Future<Workout?> getWorkoutByDate(String uid, String dateKey) async {
    try {
      final querySnapshot = await _userDoc(uid)
          .collection(AppConstants.workoutsSubcollection)
          .where('workoutDateKey', isEqualTo: dateKey)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) return null;
      return Workout.fromFirestore(querySnapshot.docs.first);
    } catch (e) {
      throw Exception('Failed to get workout by date: ${e.toString()}');
    }
  }

  @override
  Stream<List<Workout>> getWorkoutsStream(String uid) {
    return _userDoc(uid)
        .collection(AppConstants.workoutsSubcollection)
        .orderBy('workoutDateKey', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Workout.fromFirestore(doc)).toList(),
        );
  }

  @override
  Future<List<Workout>> getWorkoutsByDateRange(
    String uid,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final startKey = _dateToKey(startDate);
      final endKey = _dateToKey(endDate);

      final querySnapshot = await _userDoc(uid)
          .collection(AppConstants.workoutsSubcollection)
          .where('workoutDateKey', isGreaterThanOrEqualTo: startKey)
          .where('workoutDateKey', isLessThanOrEqualTo: endKey)
          .get();

      return querySnapshot.docs
          .map((doc) => Workout.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get workouts by date range: ${e.toString()}');
    }
  }

  @override
  Future<List<Workout>> getWorkoutsForWeek(
    String uid,
    List<String> dateKeys,
  ) async {
    try {
      final querySnapshot = await _userDoc(uid)
          .collection(AppConstants.workoutsSubcollection)
          .where('workoutDateKey', whereIn: dateKeys)
          .get();

      return querySnapshot.docs
          .map((doc) => Workout.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get workouts for week: ${e.toString()}');
    }
  }

  @override
  Future<List<String>> getDistinctWorkoutTitles(String uid) async {
    // Firestore implementation stub
    return [];
  }

  @override
  Future<List<Workout>> searchWorkoutsByTitle(
    String uid,
    String titleQuery,
  ) async {
    return [];
  }

  @override
  Future<List<Workout>> getAllWorkouts(String uid) async {
    return []; // Not optimized for Firestore
  }

  @override
  Future<List<Map<String, dynamic>>> getLastRecordForExercise(
    String uid,
    String exerciseId,
    String beforeDateKey,
  ) async {
    try {
      final querySnapshot = await _userDoc(uid)
          .collection(AppConstants.workoutsSubcollection)
          .where('workoutDateKey', isLessThan: beforeDateKey)
          .orderBy('workoutDateKey', descending: true)
          .limit(20) // Get recent workouts
          .get();

      // Find the most recent workout containing this exercise
      for (var doc in querySnapshot.docs) {
        final workout = Workout.fromFirestore(doc);
        final item = workout.items
            .where((i) => i.exerciseId == exerciseId)
            .firstOrNull;

        if (item != null) {
          // Return the sets from this exercise
          return item.sets
              .map(
                (set) => {
                  'weight': set.weight,
                  'reps': set.reps,
                  'durationSec': set.durationSec,
                  'assisted': set.assisted,
                },
              )
              .toList();
        }
      }

      return [];
    } catch (e) {
      throw Exception('Failed to get last record: ${e.toString()}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getExerciseHistory(
    String uid,
    String exerciseId,
  ) async {
    try {
      // Note: This query might require a composite index on Firestore
      // workouts/{workoutId} where items contains exerciseId ordered by workoutDateKey
      // Since 'items' is an array of objects, simple querying is hard.
      // We will query workouts ordered by date and client-side filter for now.
      // Limiting to 50 recent workouts to avoid massive reads.

      final querySnapshot = await _userDoc(uid)
          .collection(AppConstants.workoutsSubcollection)
          .orderBy('workoutDateKey', descending: true)
          .limit(50)
          .get();

      List<Map<String, dynamic>> history = [];

      for (var doc in querySnapshot.docs) {
        final workout = Workout.fromFirestore(doc);
        final item = workout.items
            .where((i) => i.exerciseId == exerciseId)
            .firstOrNull;

        if (item != null) {
          history.add({
            'workoutDateKey': workout.workoutDateKey,
            'sets': item.sets
                .map(
                  (set) => {
                    'weight': set.weight,
                    'reps': set.reps,
                    'durationSec': set.durationSec,
                    'assisted': set.assisted,
                  },
                )
                .toList(),
          });
        }
      }

      return history;
    } catch (e) {
      throw Exception('Failed to get exercise history: ${e.toString()}');
    }
  }

  // ==================== Body Parts ====================

  @override
  Future<BodyPart> createBodyPart(String uid, String name, int order) async {
    try {
      final docRef = _userDoc(
        uid,
      ).collection(AppConstants.bodyPartsSubcollection).doc();

      final bodyPart = BodyPart(
        id: docRef.id,
        name: name,
        order: order,
        createdAt: DateTime.now(),
      );

      await docRef.set(bodyPart.toFirestore());
      return bodyPart;
    } catch (e) {
      throw Exception('Failed to create body part: ${e.toString()}');
    }
  }

  @override
  Future<void> updateBodyPart(String uid, BodyPart bodyPart) async {
    try {
      await _userDoc(uid)
          .collection(AppConstants.bodyPartsSubcollection)
          .doc(bodyPart.id)
          .update(bodyPart.toFirestore());
    } catch (e) {
      throw Exception('Failed to update body part: ${e.toString()}');
    }
  }

  @override
  Stream<List<BodyPart>> getBodyPartsStream(String uid) {
    return _userDoc(uid)
        .collection(AppConstants.bodyPartsSubcollection)
        .where('isArchived', isEqualTo: false)
        .orderBy('order')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => BodyPart.fromFirestore(doc)).toList(),
        );
  }

  @override
  Future<List<BodyPart>> getBodyParts(String uid) async {
    try {
      final snapshot = await _userDoc(uid)
          .collection(AppConstants.bodyPartsSubcollection)
          .where('isArchived', isEqualTo: false)
          .get();

      return snapshot.docs.map((doc) => BodyPart.fromFirestore(doc)).toList();
    } catch (e) {
      return [];
    }
  }

  // ==================== Exercises ====================

  @override
  Future<Exercise> createExercise(
    String uid,
    String name,
    String bodyPartId,
    int order, {
    ExerciseMeasureType measureType = ExerciseMeasureType.weightReps,
  }) async {
    try {
      final docRef = _userDoc(
        uid,
      ).collection(AppConstants.exercisesSubcollection).doc();

      final exercise = Exercise(
        id: docRef.id,
        name: name,
        bodyPartId: bodyPartId,
        order: order,
        createdAt: DateTime.now(),
        measureType: measureType,
      );

      await docRef.set(exercise.toFirestore());
      return exercise;
    } catch (e) {
      throw Exception('Failed to create exercise: ${e.toString()}');
    }
  }

  @override
  Future<void> updateExercise(String uid, Exercise exercise) async {
    try {
      await _userDoc(uid)
          .collection(AppConstants.exercisesSubcollection)
          .doc(exercise.id)
          .update(exercise.toFirestore());
    } catch (e) {
      throw Exception('Failed to update exercise: ${e.toString()}');
    }
  }

  @override
  Stream<List<Exercise>> getExercisesStream(String uid) {
    return _userDoc(uid)
        .collection(AppConstants.exercisesSubcollection)
        .where('isArchived', isEqualTo: false)
        .orderBy('bodyPartId')
        .orderBy('order')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Exercise.fromFirestore(doc)).toList(),
        );
  }

  @override
  Future<Exercise?> getExercise(String uid, String exerciseId) async {
    try {
      final doc = await _userDoc(
        uid,
      ).collection(AppConstants.exercisesSubcollection).doc(exerciseId).get();

      if (!doc.exists) return null;
      return Exercise.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get exercise: ${e.toString()}');
    }
  }

  // ==================== Economy ====================

  @override
  Future<EconomyState> getEconomyState(String uid) async {
    try {
      final economyDocFuture = _userDoc(
        uid,
      ).collection('economy').doc('state').get();
      final workoutsFuture = _userDoc(
        uid,
      ).collection(AppConstants.workoutsSubcollection).get();

      final results = await Future.wait([economyDocFuture, workoutsFuture]);
      final economyDoc = results[0] as DocumentSnapshot<Map<String, dynamic>>;
      final workoutsSnapshot =
          results[1] as QuerySnapshot<Map<String, dynamic>>;

      EconomyState state;
      if (economyDoc.exists) {
        state = EconomyState.fromFirestore(economyDoc);
      } else {
        state = EconomyState(totalCoins: 0, achievementCounts: {});
      }

      int totalWorkouts = 0;
      double totalVolume = 0;
      double maxVolume = 0;

      for (var doc in workoutsSnapshot.docs) {
        final workout = Workout.fromFirestore(doc);
        if (workout.isCompleted || workout.coinGranted) {
          totalWorkouts++;
          final vol = workout.totalVolume;
          totalVolume += vol;
          if (vol > maxVolume) maxVolume = vol;
        }
      }

      final newCounts = Map<String, int>.from(state.achievementCounts);
      newCounts['totalWorkouts'] = totalWorkouts;
      newCounts['totalVolume'] = totalVolume.round();
      newCounts['maxVolume'] = maxVolume.round();

      return state.copyWith(achievementCounts: newCounts);
    } catch (e) {
      throw Exception('Failed to get economy state: ${e.toString()}');
    }
  }

  @override
  Future<void> updateEconomyState(String uid, EconomyState state) async {
    try {
      await _userDoc(uid)
          .collection('economy')
          .doc('state')
          .set(state.toFirestore(), SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to update economy state: ${e.toString()}');
    }
  }

  @override
  Stream<EconomyState> getEconomyStateStream(String uid) {
    // Manually merge streams since we need calculated stats from workouts
    final controller = StreamController<EconomyState>();

    StreamSubscription? workoutsSub;
    StreamSubscription? economySub;

    EconomyState? lastEconomyState;
    List<Workout>? lastWorkouts;

    void emitUpdate() {
      if (lastEconomyState == null) return; // Wait for economy state

      final workouts = lastWorkouts ?? [];

      int totalWorkouts = 0;
      double totalVolume = 0;
      double maxVolume = 0;

      for (var workout in workouts) {
        if (workout.isCompleted || workout.coinGranted) {
          totalWorkouts++;
          final vol = workout.totalVolume;
          totalVolume += vol;
          if (vol > maxVolume) maxVolume = vol;
        }
      }

      // Update stats
      final newCounts = Map<String, int>.from(
        lastEconomyState!.achievementCounts,
      );
      newCounts['totalWorkouts'] = totalWorkouts;
      newCounts['totalVolume'] = totalVolume.round();
      newCounts['maxVolume'] = maxVolume.round();

      if (!controller.isClosed) {
        controller.add(
          lastEconomyState!.copyWith(achievementCounts: newCounts),
        );
      }
    }

    // Subscribe to economy state
    economySub = _userDoc(uid)
        .collection('economy')
        .doc('state')
        .snapshots()
        .listen((snapshot) {
          if (snapshot.exists) {
            lastEconomyState = EconomyState.fromFirestore(snapshot);
          } else {
            lastEconomyState = EconomyState(
              totalCoins: 0,
              achievementCounts: {},
            );
          }
          emitUpdate();
        });

    // Subscribe to workouts
    workoutsSub = _userDoc(uid)
        .collection(AppConstants.workoutsSubcollection)
        .snapshots()
        .listen((snapshot) {
          lastWorkouts = snapshot.docs
              .map((doc) => Workout.fromFirestore(doc))
              .toList();
          emitUpdate();
        });

    controller.onCancel = () {
      workoutsSub?.cancel();
      economySub?.cancel();
    };

    return controller.stream;
  }

  // ==================== Body Composition ====================

  @override
  Future<void> saveBodyCompositionEntry(
    String uid,
    BodyCompositionEntry entry,
  ) async {
    try {
      await _userDoc(
        uid,
      ).collection('body_composition').doc(entry.id).set(entry.toFirestore());
    } catch (e) {
      throw Exception('Failed to save body composition entry: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteBodyCompositionEntry(String uid, String entryId) async {
    try {
      await _userDoc(uid).collection('body_composition').doc(entryId).delete();
    } catch (e) {
      throw Exception(
        'Failed to delete body composition entry: ${e.toString()}',
      );
    }
  }

  @override
  Future<BodyCompositionEntry?> getBodyCompositionByDate(
    String uid,
    String dateKey,
  ) async {
    try {
      final querySnapshot = await _userDoc(uid)
          .collection('body_composition')
          .where('dateKey', isEqualTo: dateKey)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) return null;
      return BodyCompositionEntry.fromFirestore(querySnapshot.docs.first);
    } catch (e) {
      throw Exception(
        'Failed to get body composition by date: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<BodyCompositionEntry>> getBodyCompositionHistory(
    String uid,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final startKey = _dateToKey(startDate);
      final endKey = _dateToKey(endDate);

      final querySnapshot = await _userDoc(uid)
          .collection('body_composition')
          .where('dateKey', isGreaterThanOrEqualTo: startKey)
          .where('dateKey', isLessThanOrEqualTo: endKey)
          .orderBy('dateKey', descending: false)
          .get();

      return querySnapshot.docs
          .map((doc) => BodyCompositionEntry.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception(
        'Failed to get body composition history: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<BodyCompositionEntry>> getAllBodyCompositionEntries(
    String uid,
  ) async {
    return [];
  }

  @override
  Stream<List<BodyCompositionEntry>> getBodyCompositionStream(String uid) {
    return _userDoc(uid)
        .collection('body_composition')
        .orderBy('dateKey', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => BodyCompositionEntry.fromFirestore(doc))
              .toList(),
        );
  }

  // ==================== Helper Methods ====================

  String _dateToKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

// Extension to get first element or null (local duplicate to avoid dependency loop if needed)
extension FirstWhereOrNullExtension<E> on Iterable<E> {
  E? get firstOrNull {
    var iterator = this.iterator;
    if (iterator.moveNext()) {
      return iterator.current;
    }
    return null;
  }
}
