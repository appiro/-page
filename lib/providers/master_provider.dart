import 'package:flutter/foundation.dart';
import '../models/body_part.dart';
import '../models/exercise.dart';
import '../repositories/fit_repository.dart';
import '../utils/default_data_helper.dart';

class MasterProvider with ChangeNotifier {
  final FitRepository _repository;
  final String uid;

  List<BodyPart> _bodyParts = [];
  List<Exercise> _exercises = [];
  bool _isLoading = false;
  String? _errorMessage;

  MasterProvider({
    required FitRepository repository,
    required this.uid,
  }) : _repository = repository {
    _loadData();
  }

  List<BodyPart> get bodyParts => _bodyParts;
  List<Exercise> get exercises => _exercises;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> _loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Try to create default data (idempotent check inside)
      await DefaultDataHelper.createDefaultData(uid, _repository);

      // Listen to body parts stream
      _repository.getBodyPartsStream(uid).listen(
        (bodyParts) {
          _bodyParts = bodyParts;
          notifyListeners();
        },
        onError: (error) {
          debugPrint('Body parts stream error: $error');
        },
      );

      // Listen to exercises stream
      _repository.getExercisesStream(uid).listen(
        (exercises) {
          _exercises = exercises;
          notifyListeners();
        },
        onError: (error) {
          debugPrint('Exercises stream error: $error');
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

  Future<void> createExercise(String name, String bodyPartId) async {
    try {
      // Count exercises in this body part to determine order
      final exercisesInBodyPart = _exercises
          .where((e) => e.bodyPartId == bodyPartId)
          .length;
      
      await _repository.createExercise(uid, name, bodyPartId, exercisesInBodyPart);
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
}
