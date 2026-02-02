import '../models/workout.dart';
import '../models/workout_set.dart';
import '../utils/rm_calculator.dart';
import '../repositories/fit_repository.dart';

class StatsService {
  final FitRepository _repository;

  StatsService(this._repository);

  // Get max weight history for an exercise
  Future<List<DataPoint>> getMaxWeightHistory(
    String uid,
    String exerciseId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final workouts = await _repository.getWorkoutsByDateRange(
        uid,
        startDate,
        endDate,
      );

      final dataPoints = <DataPoint>[];

      for (var workout in workouts) {
        final items = workout.items
            .where((i) => i.exerciseId == exerciseId)
            .toList();
        if (items.isEmpty) continue;

        final item = items.first;

        if (item.sets.isNotEmpty) {
          // Find max weight in this workout (filter out time-based sets)
          final weightSets = item.sets
              .where((s) => s.weight != null && s.reps != null)
              .toList();
          if (weightSets.isEmpty) continue;

          final maxWeight = weightSets
              .map((s) => s.weight!)
              .reduce((a, b) => a > b ? a : b);

          dataPoints.add(
            DataPoint(
              date: DateTime.parse(workout.workoutDateKey),
              value: maxWeight,
            ),
          );
        }
      }

      // Sort by date
      dataPoints.sort((a, b) => a.date.compareTo(b.date));

      return dataPoints;
    } catch (e) {
      throw Exception('Failed to get max weight history: ${e.toString()}');
    }
  }

  // Get estimated 1RM history for an exercise
  Future<List<DataPoint>> getEstimated1RMHistory(
    String uid,
    String exerciseId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final workouts = await _repository.getWorkoutsByDateRange(
        uid,
        startDate,
        endDate,
      );

      final dataPoints = <DataPoint>[];

      for (var workout in workouts) {
        final items = workout.items
            .where((i) => i.exerciseId == exerciseId)
            .toList();
        if (items.isEmpty) continue;

        final item = items.first;

        if (item.sets.isNotEmpty) {
          // Calculate max 1RM from all sets (filter out time-based sets)
          double maxRM = 0.0;
          for (var set in item.sets) {
            if (set.weight != null && set.reps != null) {
              final rm = RMCalculator.calculateOneRepMax(
                set.weight!,
                set.reps!,
              );
              if (rm > maxRM) {
                maxRM = rm;
              }
            }
          }

          if (maxRM > 0) {
            dataPoints.add(
              DataPoint(
                date: DateTime.parse(workout.workoutDateKey),
                value: maxRM,
              ),
            );
          }
        }
      }

      // Sort by date
      dataPoints.sort((a, b) => a.date.compareTo(b.date));

      return dataPoints;
    } catch (e) {
      throw Exception('Failed to get 1RM history: ${e.toString()}');
    }
  }

  // Compare progress between two periods
  Future<ProgressComparison> compareProgress(
    String uid,
    String exerciseId,
    DateTime period1Start,
    DateTime period1End,
    DateTime period2Start,
    DateTime period2End,
  ) async {
    try {
      final period1Workouts = await _repository.getWorkoutsByDateRange(
        uid,
        period1Start,
        period1End,
      );

      final period2Workouts = await _repository.getWorkoutsByDateRange(
        uid,
        period2Start,
        period2End,
      );

      final period1Stats = _calculatePeriodStats(period1Workouts, exerciseId);
      final period2Stats = _calculatePeriodStats(period2Workouts, exerciseId);

      return ProgressComparison(
        period1Stats: period1Stats,
        period2Stats: period2Stats,
        weightDifference: period2Stats.avgWeight - period1Stats.avgWeight,
        repsDifference: (period2Stats.avgReps - period1Stats.avgReps).round(),
        volumeDifference: period2Stats.totalVolume - period1Stats.totalVolume,
      );
    } catch (e) {
      throw Exception('Failed to compare progress: ${e.toString()}');
    }
  }

  // Calculate statistics for a period
  PeriodStats _calculatePeriodStats(List<Workout> workouts, String exerciseId) {
    double totalWeight = 0;
    int totalReps = 0;
    int totalSets = 0;
    double totalVolume = 0;

    for (var workout in workouts) {
      final items = workout.items
          .where((i) => i.exerciseId == exerciseId)
          .toList();
      if (items.isEmpty) continue;

      final item = items.first;

      for (var set in item.sets) {
        // Only include weight×reps based sets
        if (set.weight != null && set.reps != null) {
          totalWeight += set.weight!;
          totalReps += set.reps!;
          totalSets++;
          totalVolume += set.volume;
        }
      }
    }

    return PeriodStats(
      avgWeight: totalSets > 0 ? totalWeight / totalSets : 0,
      avgReps: totalSets > 0 ? totalReps / totalSets : 0,
      totalVolume: totalVolume,
      totalSets: totalSets,
    );
  }

  // Get comparison with last workout
  Future<LastWorkoutComparison?> compareWithLastWorkout(
    String uid,
    String exerciseId,
    String currentDateKey,
    List<WorkoutSet> currentSets,
  ) async {
    try {
      final lastRecord = await _repository.getLastRecordForExercise(
        uid,
        exerciseId,
        currentDateKey,
      );

      if (lastRecord.isEmpty || currentSets.isEmpty) {
        return null;
      }

      // Filter out time-based sets
      final weightBasedCurrentSets = currentSets
          .where((s) => s.weight != null && s.reps != null)
          .toList();
      if (weightBasedCurrentSets.isEmpty) return null;

      // Find max weight from last record
      final lastMaxWeight = lastRecord
          .map((s) => (s['weight'] as num).toDouble())
          .reduce((a, b) => a > b ? a : b);

      // Find max weight from current sets
      final currentMaxWeight = weightBasedCurrentSets
          .map((s) => s.weight!)
          .reduce((a, b) => a > b ? a : b);

      // Find max reps at max weight
      final lastMaxReps = lastRecord
          .where((s) => (s['weight'] as num).toDouble() == lastMaxWeight)
          .map((s) => s['reps'] as int)
          .reduce((a, b) => a > b ? a : b);

      final currentMaxReps = weightBasedCurrentSets
          .where((s) => s.weight == currentMaxWeight)
          .map((s) => s.reps!)
          .reduce((a, b) => a > b ? a : b);

      return LastWorkoutComparison(
        weightDifference: currentMaxWeight - lastMaxWeight,
        repsDifference: currentMaxReps - lastMaxReps,
        lastMaxWeight: lastMaxWeight,
        lastMaxReps: lastMaxReps,
      );
    } catch (e) {
      return null;
    }
  }
}

// Data models for stats
class DataPoint {
  final DateTime date;
  final double value;

  DataPoint({required this.date, required this.value});
}

class PeriodStats {
  final double avgWeight;
  final double avgReps;
  final double totalVolume;
  final int totalSets;

  PeriodStats({
    required this.avgWeight,
    required this.avgReps,
    required this.totalVolume,
    required this.totalSets,
  });
}

class ProgressComparison {
  final PeriodStats period1Stats;
  final PeriodStats period2Stats;
  final double weightDifference;
  final int repsDifference;
  final double volumeDifference;

  ProgressComparison({
    required this.period1Stats,
    required this.period2Stats,
    required this.weightDifference,
    required this.repsDifference,
    required this.volumeDifference,
  });
}

class LastWorkoutComparison {
  final double weightDifference;
  final int repsDifference;
  final double lastMaxWeight;
  final int lastMaxReps;

  LastWorkoutComparison({
    required this.weightDifference,
    required this.repsDifference,
    required this.lastMaxWeight,
    required this.lastMaxReps,
  });

  String getDisplayText(String unit) {
    if (weightDifference > 0) {
      return '+${weightDifference.toStringAsFixed(1)} $unit';
    } else if (weightDifference < 0) {
      return '${weightDifference.toStringAsFixed(1)} $unit';
    } else if (repsDifference > 0) {
      return '+$repsDifference reps';
    } else if (repsDifference < 0) {
      return '$repsDifference reps';
    } else {
      return 'Same as last time';
    }
  }
}
