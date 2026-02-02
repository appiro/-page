import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout_item.dart';
import '../providers/favorite_exercise_provider.dart';
import '../providers/master_provider.dart';
import '../models/exercise_measure_type.dart';
import '../utils/constants.dart';

class ExerciseSummaryCard extends StatelessWidget {
  final WorkoutItem item;
  final VoidCallback onTap;

  const ExerciseSummaryCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final totalVolume = item.totalVolume;
    final setCount = item.sets.length;
    final favoriteProvider = context.watch<FavoriteExerciseProvider>();
    final isFavorite = favoriteProvider.isFavorite(item.exerciseId);

    // Measure Type Logic
    final masterProvider = context.read<MasterProvider>();
    final exercise = masterProvider.getExercise(item.exerciseId);
    final measureType = exercise?.measureType ?? ExerciseMeasureType.weightReps;

    int totalDuration = 0;
    if (measureType == ExerciseMeasureType.time) {
      totalDuration = item.sets.fold(0, (sum, s) => sum + (s.durationSec ?? 0));
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Favorite Star
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.star : Icons.star_border,
                  color: isFavorite ? Colors.amber : Colors.grey,
                  size: 24,
                ),
                onPressed: () async {
                  await favoriteProvider.toggleFavorite(item.exerciseId);
                },
                tooltip: isFavorite ? 'お気に入りから削除' : 'お気に入りに追加',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 12),

              // Exercise Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.exerciseName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.bodyPartName,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.fitness_center,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$setCount セット',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const SizedBox(width: 16),
                        if (measureType == ExerciseMeasureType.time) ...[
                          Icon(Icons.timer, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            '${totalDuration}s',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ] else ...[
                          Icon(
                            Icons.monitor_weight,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${totalVolume.toStringAsFixed(1)} kg',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Arrow Icon
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
