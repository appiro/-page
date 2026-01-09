import '../models/user_profile.dart';
import '../models/workout.dart';
import '../models/body_part.dart';
import '../models/exercise.dart';
import '../models/economy_state.dart';
import '../models/body_composition_entry.dart';

abstract class FitRepository {
  // ==================== User Profile ====================
  Future<UserProfile?> getUserProfile(String uid);
  Future<void> updateUserProfile(String uid, Map<String, dynamic> data);

  // ==================== Workouts ====================
  Future<Workout> createWorkout(String uid, Workout workout);
  Future<void> updateWorkout(String uid, Workout workout);
  Future<void> deleteWorkout(String uid, String workoutId);
  Future<Workout?> getWorkout(String uid, String workoutId);
  Future<Workout?> getWorkoutByDate(String uid, String dateKey);
  Stream<List<Workout>> getWorkoutsStream(String uid);
  Future<List<Workout>> getWorkoutsByDateRange(String uid, DateTime startDate, DateTime endDate);
  Future<List<Workout>> getWorkoutsForWeek(String uid, List<String> dateKeys);
  Future<List<String>> getDistinctWorkoutTitles(String uid);
  Future<List<Workout>> searchWorkoutsByTitle(String uid, String titleQuery);
  Future<List<Workout>> getAllWorkouts(String uid); // For Data Migration
  Future<List<Map<String, dynamic>>> getLastRecordForExercise(String uid, String exerciseId, String beforeDateKey);
  Future<List<Map<String, dynamic>>> getExerciseHistory(String uid, String exerciseId);

  // ==================== Body Parts ====================
  Future<BodyPart> createBodyPart(String uid, String name, int order);
  Future<void> updateBodyPart(String uid, BodyPart bodyPart);
  Stream<List<BodyPart>> getBodyPartsStream(String uid);
  Future<List<BodyPart>> getBodyParts(String uid);

  // ==================== Exercises ====================
  Future<Exercise> createExercise(String uid, String name, String bodyPartId, int order);
  Future<void> updateExercise(String uid, Exercise exercise);
  Stream<List<Exercise>> getExercisesStream(String uid);
  Future<Exercise?> getExercise(String uid, String exerciseId);

  // ==================== Economy ====================
  Future<EconomyState> getEconomyState(String uid);
  Future<void> updateEconomyState(String uid, EconomyState state);
  Stream<EconomyState> getEconomyStateStream(String uid);

  // ==================== Body Composition ====================
  Future<void> saveBodyCompositionEntry(String uid, BodyCompositionEntry entry);
  Future<void> deleteBodyCompositionEntry(String uid, String entryId);
  Future<BodyCompositionEntry?> getBodyCompositionByDate(String uid, String dateKey);
  Future<List<BodyCompositionEntry>> getBodyCompositionHistory(String uid, DateTime startDate, DateTime endDate);
  Future<List<BodyCompositionEntry>> getAllBodyCompositionEntries(String uid); // For Data Migration
  Stream<List<BodyCompositionEntry>> getBodyCompositionStream(String uid);
}
