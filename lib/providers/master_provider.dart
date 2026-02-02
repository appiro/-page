import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/body_part.dart';
import '../models/exercise.dart';
import '../models/exercise_measure_type.dart';
import '../repositories/fit_repository.dart';
import '../utils/default_data_helper.dart';

class MasterProvider with ChangeNotifier {
  final FitRepository _repository;
  final String uid;

  List<BodyPart> _bodyParts = [];
  List<Exercise> _exercises = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _disposed = false;
  StreamSubscription<List<BodyPart>>? _bodyPartsSubscription;
  StreamSubscription<List<Exercise>>? _exercisesSubscription;

  // Static default exercises available immediately on startup
  static final List<Exercise> _defaultExercises = [
    Exercise(
      id: 'default_bench',
      name: 'ベンチプレス',
      bodyPartId: 'chest',
      order: 0,
      createdAt: DateTime.now(),
    ),
    Exercise(
      id: 'default_squat',
      name: 'スクワット',
      bodyPartId: 'legs',
      order: 1,
      createdAt: DateTime.now(),
    ),
    Exercise(
      id: 'default_deadlift',
      name: 'デッドリフト',
      bodyPartId: 'back',
      order: 2,
      createdAt: DateTime.now(),
    ),
    Exercise(
      id: 'default_pullup',
      name: '懸垂',
      bodyPartId: 'back',
      order: 3,
      createdAt: DateTime.now(),
    ),
    Exercise(
      id: 'default_row',
      name: 'ベントオーバーロー',
      bodyPartId: 'back',
      order: 4,
      createdAt: DateTime.now(),
    ),
    Exercise(
      id: 'default_shoulder',
      name: 'ショルダープレス',
      bodyPartId: 'shoulders',
      order: 5,
      createdAt: DateTime.now(),
    ),
  ];

  MasterProvider({required FitRepository repository, required this.uid})
    : _repository = repository {
    // Immediately provide default exercises for instant availability
    _exercises = List.from(_defaultExercises);
    // Then load real data in background
    _loadData();
  }

  List<BodyPart> get bodyParts => _bodyParts;
  List<Exercise> get exercises => _exercises;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> _loadData() async {
    if (_disposed) return;
    _isLoading = true;
    notifyListeners();

    try {
      // Try to create default data (idempotent check inside)
      await DefaultDataHelper.createDefaultData(uid, _repository);
      // Migrate exercise measure types for existing data
      await DefaultDataHelper.migrateMeasureTypes(uid, _repository);
      // Ensure 'Other' body part exists
      await DefaultDataHelper.ensureOtherBodyPartExists(uid, _repository);

      // Listen to body parts stream
      _bodyPartsSubscription = _repository
          .getBodyPartsStream(uid)
          .listen(
            (bodyParts) {
              if (_disposed) return;
              _bodyParts = bodyParts;
              notifyListeners();
            },
            onError: (error) {
              debugPrint('Body parts stream error: $error');
            },
          );

      // Listen to exercises stream
      _exercisesSubscription = _repository
          .getExercisesStream(uid)
          .listen(
            (exercises) {
              if (_disposed) return;
              _exercises = exercises;
              notifyListeners();
            },
            onError: (error) {
              debugPrint('Exercises stream error: $error');
            },
          );

      if (_disposed) return;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (_disposed) return;
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // ==================== Body Parts ====================

  Future<void> createBodyPart(String name) async {
    try {
      final order = _bodyParts.length;
      await _repository.createBodyPart(uid, name, order);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateBodyPart(BodyPart bodyPart) async {
    try {
      await _repository.updateBodyPart(uid, bodyPart);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> archiveBodyPart(String bodyPartId) async {
    try {
      final bodyPart = _bodyParts.firstWhere((bp) => bp.id == bodyPartId);
      final archived = bodyPart.copyWith(isArchived: true);
      await _repository.updateBodyPart(uid, archived);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // ==================== Exercises ====================

  Future<void> createExercise(
    String name,
    String bodyPartId, {
    ExerciseMeasureType measureType = ExerciseMeasureType.weightReps,
  }) async {
    try {
      // Count exercises in this body part to determine order
      final exercisesInBodyPart = _exercises
          .where((e) => e.bodyPartId == bodyPartId)
          .length;

      await _repository.createExercise(
        uid,
        name,
        bodyPartId,
        exercisesInBodyPart,
        measureType: measureType,
      );
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateExercise(Exercise exercise) async {
    try {
      await _repository.updateExercise(uid, exercise);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> archiveExercise(String exerciseId) async {
    try {
      final exercise = _exercises.firstWhere((e) => e.id == exerciseId);
      final archived = exercise.copyWith(isArchived: true);
      await _repository.updateExercise(uid, archived);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Get exercises for a specific body part
  List<Exercise> getExercisesForBodyPart(String bodyPartId) {
    return _exercises.where((e) => e.bodyPartId == bodyPartId).toList();
  }

  // Get body part by ID
  BodyPart? getBodyPart(String bodyPartId) {
    try {
      return _bodyParts.firstWhere((bp) => bp.id == bodyPartId);
    } catch (e) {
      return null;
    }
  }

  // Get exercise by ID
  Exercise? getExercise(String exerciseId) {
    try {
      return _exercises.firstWhere((e) => e.id == exerciseId);
    } catch (e) {
      return null;
    }
  }

  // Search exercises by name
  List<Exercise> searchExercises(String query) {
    if (query.isEmpty) return _exercises;

    final lowerQuery = query.toLowerCase();
    return _exercises
        .where((e) => e.name.toLowerCase().contains(lowerQuery))
        .toList();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _bodyPartsSubscription?.cancel();
    _exercisesSubscription?.cancel();
    super.dispose();
  }
}
