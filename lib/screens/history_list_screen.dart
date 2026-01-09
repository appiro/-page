import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout.dart';
import '../providers/workout_provider.dart';
import '../utils/date_helper.dart';
import '../utils/constants.dart';
import 'workout_editor_screen.dart';

class HistoryListScreen extends StatefulWidget {
  const HistoryListScreen({super.key});

  @override
  State<HistoryListScreen> createState() => _HistoryListScreenState();
}

class _HistoryListScreenState extends State<HistoryListScreen> {
  @override
  Widget build(BuildContext context) {
    final workoutProvider = context.watch<WorkoutProvider>();
    final workouts = workoutProvider.workouts;

    // Sort workouts by date (newest first)
    final sortedWorkouts = [...workouts];
    sortedWorkouts.sort((a, b) => b.workoutDateKey.compareTo(a.workoutDateKey));

    return Scaffold(
      appBar: AppBar(
        title: const Text('ワークアウト履歴'),
      ),
      body: workoutProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : sortedWorkouts.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  itemCount: sortedWorkouts.length,
                  itemBuilder: (context, index) {
                    final workout = sortedWorkouts[index];
                    return _buildWorkoutCard(workout);
                  },
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.fitness_center,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'まだワークアウトがありません',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '最初のワークアウトを記録しましょう！',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutCard(Workout workout) {
    final date = DateHelper.fromDateKey(workout.workoutDateKey);
    final isToday = DateHelper.isToday(date);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => WorkoutEditorScreen(workout: workout),
            ),
          );
        },
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date and Title
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              DateHelper.formatDisplayDate(date),
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            if (isToday) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppConstants.primaryColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  '今日',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (workout.title.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            workout.title,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[700],
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (workout.coinGranted)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppConstants.successColor.withAlpha(25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: AppConstants.successColor,
                        size: 24,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Stats
              Row(
                children: [
                  _buildStat(
                    Icons.fitness_center,
                    '${workout.items.length}種目',
                    Colors.blue,
                  ),
                  const SizedBox(width: 16),
                  _buildStat(
                    Icons.repeat,
                    '${workout.totalSets}セット',
                    Colors.orange,
                  ),
                  const SizedBox(width: 16),
                  _buildStat(
                    Icons.trending_up,
                    '${workout.totalVolume.toStringAsFixed(0)}kg',
                    Colors.green,
                  ),
                ],
              ),

              // Exercise List Preview
              if (workout.items.isNotEmpty) ...[
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: workout.items.take(5).map((item) {
                    return Chip(
                      label: Text(
                        item.exerciseName,
                        style: const TextStyle(fontSize: 12),
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    );
                  }).toList(),
                ),
                if (workout.items.length > 5)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '他${workout.items.length - 5}種目',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
