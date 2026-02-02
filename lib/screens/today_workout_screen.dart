import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout.dart';
import '../providers/workout_provider.dart';
import '../providers/economy_provider.dart';
import '../screens/workout_exercise_list_screen.dart';
import '../screens/timer_screen.dart';
import '../utils/date_helper.dart';
import '../utils/constants.dart';

class TodayWorkoutScreen extends StatefulWidget {
  final Workout workout;

  const TodayWorkoutScreen({super.key, required this.workout});

  @override
  State<TodayWorkoutScreen> createState() => _TodayWorkoutScreenState();
}

class _TodayWorkoutScreenState extends State<TodayWorkoutScreen> {
  late Workout _currentWorkout;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  bool _isDirty = false;
  bool _canPop = false;
  int _initialUniqueCount = 0;

  @override
  void initState() {
    super.initState();
    _currentWorkout = widget.workout;
    _titleController.text = widget.workout.title;
    _noteController.text = widget.workout.note;
    _initialUniqueCount = widget.workout.items.length;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
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

  Future<void> _saveWorkout({bool closeScreen = false}) async {
    try {
      final workoutProvider = context.read<WorkoutProvider>();
      final updatedWorkout = _currentWorkout.copyWith(
        title: _titleController.text,
        note: _noteController.text,
      );

      // If workout has no items, delete it instead of saving an empty record
      if (updatedWorkout.items.isEmpty) {
        if (updatedWorkout.id.isNotEmpty) {
          await workoutProvider.deleteWorkout(updatedWorkout.id);
        }
      } else {
        await workoutProvider.updateCurrentWorkout(updatedWorkout);
      }

      if (mounted) {
        setState(() {
          _isDirty = false;
          _currentWorkout = updatedWorkout;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('保存しました'),
            duration: Duration(seconds: 1),
          ),
        );

        if (closeScreen) {
          setState(() {
            _canPop = true;
          });
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      debugPrint('Error saving workout: ${e.toString()}');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('保存に失敗しました: ${e.toString()}')));
      }
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

      // Save first
      await _saveWorkout();

      // Pass initial unique count to calculate diff for tickets
      final int awardedTickets = await workoutProvider.completeWorkout(
        previousUniqueCount: _initialUniqueCount,
      );

      if (mounted) {
        setState(() {
          _currentWorkout = _currentWorkout.copyWith(coinGranted: true);
        });
      }

      // Check weekly goal
      await economyProvider.checkWeeklyGoal();

      if (mounted) {
        String message = 'お疲れ様でした!\nコインを獲得しました';
        if (wasCoinGranted) {
          message = '追加の種目を記録しました!';
        }

        if (awardedTickets > 0) {
          message += '\n釣りチケットを${awardedTickets}枚獲得しました!';
        } else if (awardedTickets == 0 && wasCoinGranted) {
          message = '追加の記録を保存しました!';
        }

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('完了! 🎉'),
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

  Future<void> _showTitleHistoryDialog() async {
    final workoutProvider = context.read<WorkoutProvider>();
    final titles = await workoutProvider.getPreviousTitles();

    if (!mounted) return;

    if (titles.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('過去の入力履歴がありません')));
      return;
    }

    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('過去のワークアウト名'),
        children: titles
            .map(
              (title) => SimpleDialogOption(
                onPressed: () {
                  _titleController.text = title;
                  setState(() {
                    _isDirty = true;
                  });
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(title),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Future<void> _navigateToExerciseList() async {
    // Save current changes before navigating
    if (_isDirty) {
      await _saveWorkout();
    }

    if (mounted) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              WorkoutExerciseListScreen(workout: _currentWorkout),
        ),
      );

      // Refresh workout data when returning
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

  Future<void> _handleBack() async {
    if (_isDirty) {
      final shouldSave = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('変更を保存しますか?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('保存せずに戻ると、変更内容は破棄されます。'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('保存する'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('保存しない', style: TextStyle(color: Colors.red)),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: const Text(
                  'キャンセル',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      );

      if (shouldSave == true) {
        await _saveWorkout(closeScreen: true);
      } else if (shouldSave == false) {
        await _cleanupAndClose();
      }
    } else {
      await _cleanupAndClose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final date = DateHelper.fromDateKey(_currentWorkout.workoutDateKey);
    final isToday = DateHelper.isToday(date);
    final totalSets = _currentWorkout.totalSets;
    final totalVolume = _currentWorkout.totalVolume;
    final exerciseCount = _currentWorkout.items.length;

    return PopScope(
      canPop: _canPop,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        await _handleBack();
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
          actions: [
            IconButton(
              icon: const Icon(Icons.timer),
              tooltip: 'タイマー',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const TimerScreen()),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Input
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'ワークアウト名 (任意)',
                        hintText: '例: 胸トレ、背中トレ',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => setState(() => _isDirty = true),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.history),
                    tooltip: '履歴から選択',
                    onPressed: _showTitleHistoryDialog,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Summary Card
              // Summary Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 20,
                      ),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppConstants.primaryColor,
                            AppConstants.primaryColor,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.analytics, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'ワークアウト概要',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildSummaryItem(
                            context,
                            icon: Icons.fitness_center,
                            label: '種目',
                            value: '$exerciseCount',
                          ),
                          _buildContainerDivider(),
                          _buildSummaryItem(
                            context,
                            icon: Icons.format_list_numbered,
                            label: 'セット',
                            value: '$totalSets',
                          ),
                          _buildContainerDivider(),
                          _buildSummaryItem(
                            context,
                            icon: Icons.monitor_weight,
                            label: 'ボリューム',
                            value: '${totalVolume.toStringAsFixed(0)}',
                            unit: 'kg',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Exercise List Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _navigateToExerciseList,
                  icon: const Icon(Icons.list),
                  label: const Text('筋トレ一覧へ'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppConstants.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Notes
              TextField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'メモ (任意)',
                  hintText: '感想や体調など...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                onChanged: (_) => setState(() => _isDirty = true),
              ),
              const SizedBox(height: 24),

              // Complete Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final currentItemCount = _currentWorkout.items.length;
                    final bool hasNewTickets =
                        _currentWorkout.coinGranted &&
                        (currentItemCount > _initialUniqueCount);
                    final bool needsCompletion =
                        !_currentWorkout.coinGranted || hasNewTickets;

                    if (needsCompletion) {
                      await _completeWorkout();
                    } else {
                      await _saveWorkout(closeScreen: true);
                    }
                  },
                  icon: const Icon(Icons.check_circle),
                  label: const Text('保存して完了'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppConstants.successColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    String? unit,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppConstants.primaryColor, size: 28),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppConstants.primaryColor,
                fontSize: 24,
              ),
            ),
            if (unit != null) ...[
              const SizedBox(width: 4),
              Text(
                unit,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppConstants.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildContainerDivider() {
    return Container(height: 40, width: 1, color: Colors.grey[200]);
  }
}
