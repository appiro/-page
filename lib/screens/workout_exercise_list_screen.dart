import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout.dart';
import '../models/workout_item.dart';
import '../models/exercise.dart';
import '../providers/workout_provider.dart';
import '../providers/master_provider.dart';
import '../providers/economy_provider.dart';

import '../widgets/exercise_summary_card.dart';
import '../screens/exercise_picker_screen.dart';
import '../screens/workout_exercise_edit_screen.dart';
import '../utils/constants.dart';
import '../utils/date_helper.dart';

class WorkoutExerciseListScreen extends StatefulWidget {
  final Workout workout;

  const WorkoutExerciseListScreen({super.key, required this.workout});

  @override
  State<WorkoutExerciseListScreen> createState() =>
      _WorkoutExerciseListScreenState();
}

class _WorkoutExerciseListScreenState extends State<WorkoutExerciseListScreen> {
  late Workout _currentWorkout;
  int _initialUniqueCount = 0;
  bool _canPop = false;

  @override
  void initState() {
    super.initState();
    _currentWorkout = widget.workout;

    // Calculate initial unique exercises count
    final uniqueExercises = _currentWorkout.items
        .map((e) => e.exerciseId)
        .toSet();
    _initialUniqueCount = uniqueExercises.length;

    _refreshWorkout();
  }

  Future<void> _refreshWorkout() async {
    try {
      final workoutProvider = context.read<WorkoutProvider>();
      final updated = await workoutProvider.getOrCreateWorkoutForDate(
        _currentWorkout.workoutDateKey,
      );
      if (mounted) {
        setState(() {
          _currentWorkout = updated;
        });
      }
    } catch (e) {
      debugPrint('Failed to refresh workout: $e');
    }
  }

  Future<void> _addExercise() async {
    try {
      final masterProvider = context.read<MasterProvider>();

      if (masterProvider.exercises.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('種目がありません')));
        }
        return;
      }

      final Exercise? selectedExercise = await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ExercisePickerScreen()),
      );

      if (selectedExercise == null) return;

      // Get body part info
      final bodyPart = masterProvider.getBodyPart(selectedExercise.bodyPartId);

      // Create new workout item
      final newItem = WorkoutItem(
        exerciseId: selectedExercise.id,
        exerciseName: selectedExercise.name,
        bodyPartId: selectedExercise.bodyPartId,
        bodyPartName: bodyPart?.name ?? 'Unknown',
        sets: [],
        memo: '',
        order: _currentWorkout.items.length,
      );

      // Navigate to edit screen for the new exercise
      if (mounted) {
        final result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => WorkoutExerciseEditScreen(
              workout: _currentWorkout,
              newItem: newItem,
            ),
          ),
        );

        // Refresh if exercise was saved
        if (result == true) {
          await _refreshWorkout();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('エラー: ${e.toString()}')));
      }
    }
  }

  Future<void> _editExercise(int index) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WorkoutExerciseEditScreen(
          workout: _currentWorkout,
          exerciseIndex: index,
        ),
      ),
    );

    // Refresh if exercise was saved or deleted
    if (result == true) {
      await _refreshWorkout();
    }
  }

  Future<void> _cleanupAndClose() async {
    // If the workout was initially empty and we are closing without saving
    if (widget.workout.items.isEmpty && widget.workout.id.isNotEmpty) {
      try {
        await context.read<WorkoutProvider>().deleteWorkout(widget.workout.id);
      } catch (e) {
        debugPrint('Error cleaning up empty workout: $e');
      }
    }

    if (mounted) {
      setState(() {
        _canPop = true;
      });
      Navigator.of(context).pop();
    }
  }

  Future<void> _completeWorkout() async {
    // Validate that there's at least one exercise with sets
    if (_currentWorkout.items.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('種目を1つ以上追加してください')));
      return;
    }

    bool hasValidSets = false;
    for (var item in _currentWorkout.items) {
      if (item.sets.isNotEmpty) {
        hasValidSets = true;
        break;
      }
    }

    if (!hasValidSets) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('セットを1つ以上追加してください')));
      return;
    }

    try {
      final workoutProvider = context.read<WorkoutProvider>();
      final economyProvider = context.read<EconomyProvider>();

      final bool wasCoinGranted = _currentWorkout.coinGranted;

      // Pass initial unique count to calculate diff for tickets
      final int awardedTickets = await workoutProvider.completeWorkout(
        previousUniqueCount: _initialUniqueCount,
      );

      // Refresh local state to reflect changes (e.g. coinGranted)
      setState(() {
        _currentWorkout = _currentWorkout.copyWith(coinGranted: true);
      });

      // Register for volume stats and title calculation
      await economyProvider.registerWorkoutCompletion(_currentWorkout);

      // Check weekly goal
      await economyProvider.checkWeeklyGoal();

      if (mounted) {
        String message = '記録を保存しました!';
        if (!wasCoinGranted) {
          message = 'お疲れ様でした!\n記録を保存し、コインを獲得しました!';
        }

        if (awardedTickets > 0) {
          message += '\n釣りチケットを${awardedTickets}枚獲得しました!';
        }

        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('保存完了!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: AppConstants.successColor,
                  size: 64,
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  setState(() {
                    _canPop = true;
                  });
                  Navigator.of(context).pop(); // Return to home
                },
                child: const Text('閉じる'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalSets = _currentWorkout.totalSets;
    final totalVolume = _currentWorkout.totalVolume;
    final date = DateHelper.fromDateKey(_currentWorkout.workoutDateKey);
    final isToday = DateHelper.isToday(date);

    return PopScope(
      canPop: _canPop,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        await _cleanupAndClose();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(isToday ? '今日のワークアウト' : 'ワークアウト'),
              Text(
                DateHelper.formatDisplayDate(date),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            // Summary Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              decoration: BoxDecoration(
                color: AppConstants.primaryColor.withOpacity(0.05),
                border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSummaryItem(
                    context,
                    icon: Icons.fitness_center,
                    label: '種目',
                    value: '${_currentWorkout.items.length}',
                  ),
                  _buildSummaryItem(
                    context,
                    icon: Icons.format_list_numbered,
                    label: 'セット',
                    value: '$totalSets',
                  ),
                  _buildSummaryItem(
                    context,
                    icon: Icons.monitor_weight,
                    label: 'ボリューム',
                    value: '${totalVolume.toStringAsFixed(0)} kg',
                  ),
                ],
              ),
            ),

            // Exercise List
            Expanded(
              child: _currentWorkout.items.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
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
                              'まだ種目がありません',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '下のボタンから種目を追加してください',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _refreshWorkout,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(
                          AppConstants.defaultPadding,
                        ),
                        itemCount: _currentWorkout.items.length,
                        itemBuilder: (context, index) {
                          final item = _currentWorkout.items[index];
                          return ExerciseSummaryCard(
                            item: item,
                            onTap: () => _editExercise(index),
                          );
                        },
                      ),
                    ),
            ),

            // Bottom Buttons
            Container(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(25),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    // Add Exercise Button
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _addExercise,
                        icon: const Icon(Icons.add),
                        label: const Text('種目追加'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(
                            color: AppConstants.primaryColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Save Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _completeWorkout,
                        icon: const Icon(Icons.check),
                        label: const Text('保存'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: AppConstants.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppConstants.primaryColor, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppConstants.primaryColor,
          ),
        ),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }
}
