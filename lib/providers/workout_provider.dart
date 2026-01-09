import 'package:flutter/foundation.dart';
import '../models/workout.dart';
import '../models/workout_item.dart';
import '../models/workout_set.dart';
import '../repositories/fit_repository.dart';
import '../services/economy_service.dart';
import '../utils/constants.dart';
import '../utils/date_helper.dart';

class WorkoutProvider with ChangeNotifier {
  final FitRepository _repository;
  final EconomyService _economyService;
  final String uid;

  List<Workout> _workouts = [];
  Workout? _currentWorkout;
  bool _isLoading = false;
  String? _errorMessage;

  WorkoutProvider({
    required FitRepository repository,
    required EconomyService economyService,
    required this.uid,
  })  : _repository = repository,
        _economyService = economyService {
    _loadWorkouts();
  }

  List<Workout> get workouts => _workouts;
  Workout? get currentWorkout => _currentWorkout;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Load all workouts
  Future<void> _loadWorkouts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _repository.getWorkoutsStream(uid).listen(
        (workouts) {
          _workouts = workouts;
          notifyListeners();
        },
        onError: (error) {
          debugPrint('Workouts stream error: $error');
        },
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get or create today's workout
  Future<Workout> getTodayWorkout() async {
    final todayKey = DateHelper.getTodayKey();
    return await getOrCreateWorkoutForDate(todayKey);
  }

  // Get or create workout for specific date
  Future<Workout> getOrCreateWorkoutForDate(String dateKey) async {
    try {
      // Check if workout already exists
      final existing = await _repository.getWorkoutByDate(uid, dateKey);
      if (existing != null) {
        _currentWorkout = existing;
        notifyListeners();
        return existing;
      }

      // Create new workout
      final newWorkout = Workout(
        id: '', // Repo will assign ID if empty
        workoutDateKey: dateKey,
        items: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final created = await _repository.createWorkout(uid, newWorkout);
      _currentWorkout = created;
      notifyListeners();
      return created;
    } catch (e) {
      debugPrint('Failed to get/create workout: $e');
      rethrow;
    }
  }

  // Load specific workout
  Future<void> loadWorkout(String workoutId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final workout = await _repository.getWorkout(uid, workoutId);
      _currentWorkout = workout;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update current workout
  Future<void> updateCurrentWorkout(Workout workout) async {
    try {
      await _repository.updateWorkout(uid, workout);
      _currentWorkout = workout;
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to update workout: $e');
      // Update local state primarily, but ideally show error
      _currentWorkout = workout;
      notifyListeners();
    }
  }

  // Add exercise to current workout
  Future<void> addExercise(WorkoutItem item) async {
    if (_currentWorkout == null) return;

    final updatedItems = [..._currentWorkout!.items, item];
    final updatedWorkout = _currentWorkout!.copyWith(items: updatedItems);
    await updateCurrentWorkout(updatedWorkout);
  }

  // Update exercise in current workout
  Future<void> updateExercise(int index, WorkoutItem item) async {
    if (_currentWorkout == null) return;

    final updatedItems = [..._currentWorkout!.items];
    updatedItems[index] = item;
    final updatedWorkout = _currentWorkout!.copyWith(items: updatedItems);
    await updateCurrentWorkout(updatedWorkout);
  }

  // Remove exercise from current workout
  Future<void> removeExercise(int index) async {
    if (_currentWorkout == null) return;

    final updatedItems = [..._currentWorkout!.items];
    updatedItems.removeAt(index);
    final updatedWorkout = _currentWorkout!.copyWith(items: updatedItems);
    await updateCurrentWorkout(updatedWorkout);
  }

  // Add set to exercise
  Future<void> addSet(int exerciseIndex, WorkoutSet set) async {
    if (_currentWorkout == null) return;

    final item = _currentWorkout!.items[exerciseIndex];
    final updatedSets = [...item.sets, set];
    final updatedItem = item.copyWith(sets: updatedSets);
    await updateExercise(exerciseIndex, updatedItem);
  }

  // Update set in exercise
  Future<void> updateSet(int exerciseIndex, int setIndex, WorkoutSet set) async {
    if (_currentWorkout == null) return;

    final item = _currentWorkout!.items[exerciseIndex];
    final updatedSets = [...item.sets];
    updatedSets[setIndex] = set;
    final updatedItem = item.copyWith(sets: updatedSets);
    await updateExercise(exerciseIndex, updatedItem);
  }

  // Remove set from exercise
  Future<void> removeSet(int exerciseIndex, int setIndex) async {
    if (_currentWorkout == null) return;

    final item = _currentWorkout!.items[exerciseIndex];
    final updatedSets = [...item.sets];
    updatedSets.removeAt(setIndex);
    final updatedItem = item.copyWith(sets: updatedSets);
    await updateExercise(exerciseIndex, updatedItem);
  }

  // Complete workout and award coins
  Future<void> completeWorkout() async {
    if (_currentWorkout == null) return;
    if (_currentWorkout!.coinGranted) return; // Already awarded

    try {
      // Calculate coins 
      final coins = _economyService.calculateCoins(_currentWorkout!);
      
      if (coins > 0) {
        await _economyService.awardCoins(uid, coins);
      }

      // Increment total workouts achievement
      await _economyService.incrementAchievement(
        uid,
        AppConstants.achievementTotalWorkouts,
      );

      // Check for title unlocks
      await _economyService.checkAndUnlockTitles(uid);

      // Mark workout as coin granted
      final updatedWorkout = _currentWorkout!.copyWith(coinGranted: true);
      await updateCurrentWorkout(updatedWorkout);
    } catch (e) {
      debugPrint('Failed to complete workout: $e');
      // Ensure local state is updated even if economy fails
      final updatedWorkout = _currentWorkout!.copyWith(coinGranted: true);
      _currentWorkout = updatedWorkout;
      notifyListeners();
    }
  }

  // Delete workout
  Future<void> deleteWorkout(String workoutId) async {
    try {
      // Check if we need to deduct coins
      // Try to find in local list first, otherwise fetch from repo
      Workout? workout;
      try {
        workout = _workouts.firstWhere((w) => w.id == workoutId);
      } catch (_) {
        workout = await _repository.getWorkout(uid, workoutId);
      }

      if (workout != null && workout.coinGranted) {
        final coins = _economyService.calculateCoins(workout);
        if (coins > 0) {
          await _economyService.deductCoins(uid, coins);
        }
      }

      await _repository.deleteWorkout(uid, workoutId);
      if (_currentWorkout?.id == workoutId) {
        _currentWorkout = null;
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Get last record for exercise
  Future<List<Map<String, dynamic>>> getLastRecord(
    String exerciseId,
    String beforeDateKey,
  ) async {
    try {
      return await _repository.getLastRecordForExercise(
        uid,
        exerciseId,
        beforeDateKey,
      );
    } catch (e) {
      return [];
    }
  }

  // Get previous workout titles
  Future<List<String>> getPreviousTitles() async {
    return await _repository.getDistinctWorkoutTitles(uid);
  }

  // Search workouts by title
  Future<List<Workout>> searchWorkouts(String query) async {
    return await _repository.searchWorkoutsByTitle(uid, query);
  }

  // Get workouts in date range (for calendar)
  Future<List<Workout>> getWorkoutsInRange(DateTime start, DateTime end) async {
    try {
      return await _repository.getWorkoutsByDateRange(uid, start, end);
    } catch (e) {
      return [];
    }
  }

  // Clear current workout
  void clearCurrentWorkout() {
    _currentWorkout = null;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
