import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout.dart';
import '../models/workout_item.dart';
import '../models/workout_set.dart';
import '../models/exercise.dart';
import '../providers/workout_provider.dart';
import '../providers/master_provider.dart';
import '../providers/economy_provider.dart';
import '../widgets/exercise_card.dart';
import '../screens/exercise_picker_screen.dart';
import '../utils/date_helper.dart';
import '../utils/constants.dart';
import 'timer_screen.dart';

class WorkoutEditorScreen extends StatefulWidget {
  final Workout workout;

  const WorkoutEditorScreen({super.key, required this.workout});

  @override
  State<WorkoutEditorScreen> createState() => _WorkoutEditorScreenState();
}

class _WorkoutEditorScreenState extends State<WorkoutEditorScreen> {
  late Workout _currentWorkout;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final Map<String, List<Map<String, dynamic>>> _lastRecords = {};
  bool _isLoading = false;
  bool _isSaving = false;
  bool _isDirty = false;
  String? _addedExerciseId;
  bool _canPop = false;

  @override
  void initState() {
    super.initState();
    _currentWorkout = widget.workout;
    _titleController.text = widget.workout.title;
    _noteController.text = widget.workout.note;
    _loadLastRecords();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _loadLastRecords() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      final workoutProvider = context.read<WorkoutProvider>();
      
      for (var item in _currentWorkout.items) {
        try {
          final lastRecord = await workoutProvider.getLastRecord(
            item.exerciseId,
            _currentWorkout.workoutDateKey,
          );
          _lastRecords[item.exerciseId] = lastRecord;
        } catch (e) {
          // Ignore errors loading individual records
          debugPrint('Failed to load last record for ${item.exerciseId}: $e');
        }
      }
    } catch (e) {
      // Provider not available, skip loading last records
      debugPrint('Provider not available, skipping last records: $e');
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveWorkout({bool closeScreen = false}) async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

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
      // Just update local state if Provider not available
      debugPrint('Error saving workout: ${e.toString()}');
      _currentWorkout = _currentWorkout.copyWith(
        title: _titleController.text,
        note: _noteController.text,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _completeWorkout() async {
    // Validate that there's at least one exercise with sets
    if (_currentWorkout.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('種目を1つ以上追加してください')),
      );
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('セットを1つ以上追加してください')),
      );
      return;
    }

    // Save handled by caller


    // Then complete and award coins
    try {
      final workoutProvider = context.read<WorkoutProvider>();
      final economyProvider = context.read<EconomyProvider>();
      
      await workoutProvider.completeWorkout();
      
      // Check weekly goal
      await economyProvider.checkWeeklyGoal();

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('完了！🎉'),
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
                  'お疲れ様でした！\nコインを獲得しました',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _addExercise() async {
    try {
      final masterProvider = context.read<MasterProvider>();
      
      if (masterProvider.exercises.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('種目がありません')),
        );
        return;
      }

    final Exercise? selectedExercise = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ExercisePickerScreen(),
      ),
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
      sets: [WorkoutSet(weight: 0, reps: 0)],
      memo: '',
      order: _currentWorkout.items.length,
    );

      // Load last record for this exercise
      try {
        final workoutProvider = context.read<WorkoutProvider>();
        final lastRecord = await workoutProvider.getLastRecord(
          selectedExercise.id,
          _currentWorkout.workoutDateKey,
        );
        _lastRecords[selectedExercise.id] = lastRecord;
      } catch (e) {
        debugPrint('Failed to load last record: $e');
      }

      setState(() {
        _isDirty = true;
        _addedExerciseId = newItem.id;
        _currentWorkout = _currentWorkout.copyWith(
          items: [..._currentWorkout.items, newItem],
        );
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _addedExerciseId = null;
          });
        }
      });

      // No auto-save
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('エラー: ${e.toString()}')),
        );
      }
    }
  }

  void _updateExercise(int index, WorkoutItem item) {
    final newItems = [..._currentWorkout.items];
    newItems[index] = item;
    
    setState(() {
      _isDirty = true;
      _currentWorkout = _currentWorkout.copyWith(items: newItems);
    });
    // No auto-save
  }

  void _deleteExercise(int index) {
    final newItems = [..._currentWorkout.items];
    newItems.removeAt(index);
    
    setState(() {
      _isDirty = true;
      _currentWorkout = _currentWorkout.copyWith(items: newItems);
    });
    // No auto-save
  }

  Future<void> _showTitleHistoryDialog() async {
    final workoutProvider = context.read<WorkoutProvider>();
    final titles = await workoutProvider.getPreviousTitles();
    
    if (!mounted) return;
    
    if (titles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('過去の入力履歴がありません')),
      );
      return;
    }
    
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('過去のワークアウト名'),
        children: titles.map((title) => SimpleDialogOption(
          onPressed: () {
            _titleController.text = title;
            setState(() => _isDirty = true);
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(title),
          ),
        )).toList(),
      ),
    );
  }

  Future<void> _cleanupAndClose() async {
    // If the workout was initially empty (newly created) and we are closing without saving
    // (or discarding changes), delete the empty record to avoid clutter.
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

  @override
  Widget build(BuildContext context) {
    final date = DateHelper.fromDateKey(_currentWorkout.workoutDateKey);
    final isToday = DateHelper.isToday(date);

    return PopScope(
      canPop: _canPop,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        if (_isDirty) {
          final shouldSave = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('変更を保存しますか？'),
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
                    child: const Text('キャンセル', style: TextStyle(color: Colors.grey)),
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
                MaterialPageRoute(
                  builder: (context) => const TimerScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
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
                        const SizedBox(height: 16),

                        // Exercise List
                        if (_currentWorkout.items.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.fitness_center,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'まだ種目がありません',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          color: Colors.grey[600],
                                        ),
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
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _currentWorkout.items.length,
                            itemBuilder: (context, index) {
                              final item = _currentWorkout.items[index];
                              return ExerciseCard(
                                item: item,
                                index: index,
                                lastRecord: _lastRecords[item.exerciseId] ?? [],
                                onChanged: (updatedItem) => _updateExercise(index, updatedItem),
                                onDelete: () => _deleteExercise(index),
                                shouldFocusOnLoad: item.id == _addedExerciseId,
                              );
                            },
                          ),

                        const SizedBox(height: 16),

                        // Notes
                        TextField(
                          controller: _noteController,
                          decoration: const InputDecoration(
                            labelText: 'メモ (任意)',
                            hintText: '感想や体調など...',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                          onChanged: (_) => setState(() => _isDirty = true),
                        ),

                        const SizedBox(height: 80), // Space for FAB
                      ],
                    ),
                  ),
                ),

                // Bottom Action Bar
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
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _addExercise,
                            icon: const Icon(Icons.add),
                            label: const Text('種目を追加'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await _saveWorkout(closeScreen: true);
                              if (!_currentWorkout.coinGranted) {
                                await _completeWorkout();
                              }
                            },
                            icon: const Icon(Icons.check),
                            label: const Text('保存'),
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
              ],
            ),
    ),
  );
  }
}
