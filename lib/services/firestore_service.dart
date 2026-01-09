import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/workout.dart';
import '../models/body_part.dart';
import '../models/exercise.dart';
import '../models/user_profile.dart';
import '../models/economy_state.dart';
import '../utils/constants.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get user reference
  DocumentReference _userDoc(String uid) {
    return _firestore.collection(AppConstants.usersCollection).doc(uid);
  }

  // ==================== User Profile ====================

  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      final doc = await _userDoc(uid).get();
      if (!doc.exists) return null;
      return UserProfile.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get user profile: ${e.toString()}');
    }
  }

  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = Timestamp.now();
      await _userDoc(uid).update(data);
    } catch (e) {
      throw Exception('Failed to update user profile: ${e.toString()}');
    }
  }

  // ==================== Workouts ====================

  Future<Workout> createWorkout(String uid, Workout workout) async {
    try {
      final docRef = _userDoc(uid)
          .collection(AppConstants.workoutsSubcollection)
          .doc();
      
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

  Future<void> deleteWorkout(String uid, String workoutId) async {
    try {
      await _userDoc(uid)
          .collection(AppConstants.workoutsSubcollection)
          .doc(workoutId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete workout: ${e.toString()}');
    }
  }

  Future<Workout?> getWorkout(String uid, String workoutId) async {
    try {
      final doc = await _userDoc(uid)
          .collection(AppConstants.workoutsSubcollection)
          .doc(workoutId)
          .get();
      
      if (!doc.exists) return null;
      return Workout.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get workout: ${e.toString()}');
    }
  }

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

  Stream<List<Workout>> getWorkoutsStream(String uid) {
    return _userDoc(uid)
        .collection(AppConstants.workoutsSubcollection)
        .orderBy('workoutDateKey', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Workout.fromFirestore(doc))
            .toList());
  }

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

  Future<List<Workout>> getWorkoutsForWeek(String uid, List<String> dateKeys) async {
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

  // Get last record for an exercise (before a specific date)
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
        final item = workout.items.where((i) => i.exerciseId == exerciseId).firstOrNull;
        
        if (item != null) {
          // Return the sets from this exercise
          return item.sets.map((set) => {
            'weight': set.weight,
            'reps': set.reps,
            'assisted': set.assisted,
          }).toList();
        }
      }

      return [];
    } catch (e) {
      throw Exception('Failed to get last record: ${e.toString()}');
    }
  }

  // ==================== Body Parts ====================

  Future<BodyPart> createBodyPart(String uid, String name, int order) async {
    try {
      final docRef = _userDoc(uid)
          .collection(AppConstants.bodyPartsSubcollection)
          .doc();
      
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

  Stream<List<BodyPart>> getBodyPartsStream(String uid) {
    return _userDoc(uid)
        .collection(AppConstants.bodyPartsSubcollection)
        .where('isArchived', isEqualTo: false)
        .orderBy('order')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BodyPart.fromFirestore(doc))
            .toList());
  }

  Future<List<BodyPart>> getBodyParts(String uid) async {
    try {
      final snapshot = await _userDoc(uid)
          .collection(AppConstants.bodyPartsSubcollection)
          .where('isArchived', isEqualTo: false)
          .get();
      
      return snapshot.docs
          .map((doc) => BodyPart.fromFirestore(doc))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // ==================== Exercises ====================

  Future<Exercise> createExercise(
    String uid,
    String name,
    String bodyPartId,
    int order,
  ) async {
    try {
      final docRef = _userDoc(uid)
          .collection(AppConstants.exercisesSubcollection)
          .doc();
      
      final exercise = Exercise(
        id: docRef.id,
        name: name,
        bodyPartId: bodyPartId,
        order: order,
        createdAt: DateTime.now(),
      );

      await docRef.set(exercise.toFirestore());
      return exercise;
    } catch (e) {
      throw Exception('Failed to create exercise: ${e.toString()}');
    }
  }

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

  Stream<List<Exercise>> getExercisesStream(String uid) {
    return _userDoc(uid)
        .collection(AppConstants.exercisesSubcollection)
        .where('isArchived', isEqualTo: false)
        .orderBy('bodyPartId')
        .orderBy('order')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Exercise.fromFirestore(doc))
            .toList());
  }

  Future<Exercise?> getExercise(String uid, String exerciseId) async {
    try {
      final doc = await _userDoc(uid)
          .collection(AppConstants.exercisesSubcollection)
          .doc(exerciseId)
          .get();
      
      if (!doc.exists) return null;
      return Exercise.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get exercise: ${e.toString()}');
    }
  }

  // ==================== Economy ====================

  Future<EconomyState> getEconomyState(String uid) async {
    try {
      final doc = await _userDoc(uid)
          .collection('economy')
          .doc('state')
          .get();
      
      return EconomyState.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get economy state: ${e.toString()}');
    }
  }

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

  Stream<EconomyState> getEconomyStateStream(String uid) {
    return _userDoc(uid)
        .collection('economy')
        .doc('state')
        .snapshots()
        .map((doc) => EconomyState.fromFirestore(doc));
  }

  // ==================== Helper Methods ====================

  String _dateToKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

// Extension to get first element or null
extension FirstWhereOrNullExtension<E> on Iterable<E> {
  E? get firstOrNull {
    var iterator = this.iterator;
    if (iterator.moveNext()) {
      return iterator.current;
    }
    return null;
  }
}
