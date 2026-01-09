import 'package:flutter/foundation.dart';
import '../models/body_composition_entry.dart';
import '../repositories/fit_repository.dart';

class StatsProvider with ChangeNotifier {
  final FitRepository _repository;
  final String uid;

  bool _isLoading = false;
  String? _errorMessage;

  StatsProvider({
    required FitRepository repository,
    required this.uid,
  }) : _repository = repository;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<List<Map<String, dynamic>>> getExerciseHistory(String exerciseId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final history = await _repository.getExerciseHistory(uid, exerciseId);
      _isLoading = false;
      notifyListeners();
      return history;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return [];
    }
  }

  // ==================== Body Composition ====================

  Future<void> saveBodyCompositionEntry(BodyCompositionEntry entry) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.saveBodyCompositionEntry(uid, entry);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      // Re-throw so UI can handle success/fail message
      rethrow;
    }
  }

  Future<void> deleteBodyCompositionEntry(String entryId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.deleteBodyCompositionEntry(uid, entryId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Fetch recent history (e.g. last 30 days or all)
  Future<List<BodyCompositionEntry>> getBodyCompositionHistory({DateTime? startDate, DateTime? endDate}) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Default to last 365 days if not specified
      final start = startDate ?? DateTime.now().subtract(const Duration(days: 365));
      final end = endDate ?? DateTime.now();
      
      final history = await _repository.getBodyCompositionHistory(uid, start, end);
      _isLoading = false;
      notifyListeners();
      return history;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return [];
    }
  }

  Stream<List<BodyCompositionEntry>> get bodyCompositionStream {
    return _repository.getBodyCompositionStream(uid);
  }

  // Calculate 1RM using Epley formula
  double calculate1RM(double weight, int reps) {
    if (reps == 0) return 0;
    if (reps == 1) return weight;
    return weight * (1 + reps / 30.0);
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
