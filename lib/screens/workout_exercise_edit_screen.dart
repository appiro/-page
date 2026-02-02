import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout.dart';
import '../models/workout_item.dart';
import '../models/workout_set.dart';
import '../providers/workout_provider.dart';
import '../providers/economy_provider.dart';
import '../providers/master_provider.dart';
import '../models/exercise_measure_type.dart';
import '../widgets/set_input_row.dart';
import '../widgets/last_record_display.dart';
import '../utils/constants.dart';

class WorkoutExerciseEditScreen extends StatefulWidget {
  final Workout workout;
  final int? exerciseIndex; // null = new exercise, otherwise edit existing
  final WorkoutItem? newItem; // Used when adding a new exercise

  const WorkoutExerciseEditScreen({
    super.key,
    required this.workout,
    this.exerciseIndex,
    this.newItem,
  });

  @override
  State<WorkoutExerciseEditScreen> createState() =>
      _WorkoutExerciseEditScreenState();
}

class _WorkoutExerciseEditScreenState extends State<WorkoutExerciseEditScreen> {
  late WorkoutItem _currentItem;
  final TextEditingController _memoController = TextEditingController();
  List<Map<String, dynamic>> _lastRecord = [];
  bool _isLoading = false;
  bool _hideLastRecord = false;
  bool _isDirty = false;
  int? _newlyAddedSetIndex;
  bool _canPop = false;

  @override
  void initState() {
    super.initState();

    if (widget.exerciseIndex != null) {
      // Edit existing exercise
      _currentItem = widget.workout.items[widget.exerciseIndex!];
    } else if (widget.newItem != null) {
      // Add new exercise
      _currentItem = widget.newItem!;
    } else {
      throw ArgumentError('Either exerciseIndex or newItem must be provided');
    }

    _memoController.text = _currentItem.memo;
    _loadLastRecord();
  }

  @override
  void dispose() {
    _memoController.dispose();
    super.dispose();
  }

  Future<void> _loadLastRecord() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final workoutProvider = context.read<WorkoutProvider>();
      final lastRecord = await workoutProvider.getLastRecord(
        _currentItem.exerciseId,
        widget.workout.workoutDateKey,
      );

      if (mounted) {
        setState(() {
          _lastRecord = lastRecord;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Failed to load last record: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _addSet() {
    final masterProvider = context.read<MasterProvider>();
    final exercise = masterProvider.getExercise(_currentItem.exerciseId);
    final measureType = exercise?.measureType ?? ExerciseMeasureType.weightReps;

    WorkoutSet newSet;
    if (measureType == ExerciseMeasureType.time) {
      newSet = WorkoutSet(durationSec: 0);
    } else if (measureType == ExerciseMeasureType.repsOnly) {
      newSet = WorkoutSet(reps: 0);
    } else {
      newSet = WorkoutSet(weight: 0, reps: 0);
    }

    final newSets = [..._currentItem.sets, newSet];
    setState(() {
      _currentItem = _currentItem.copyWith(sets: newSets);
      _newlyAddedSetIndex = newSets.length - 1;
      _isDirty = true;
    });
  }

  void _updateSet(int index, WorkoutSet set) {
    final newSets = [..._currentItem.sets];
    newSets[index] = set;
    setState(() {
      _currentItem = _currentItem.copyWith(sets: newSets);
      _isDirty = true;
    });
  }

  void _deleteSet(int index) {
    if (_currentItem.sets.length <= 1) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('最低1セット必要です')));
      return;
    }

    final newSets = [..._currentItem.sets];
    newSets.removeAt(index);
    setState(() {
      _currentItem = _currentItem.copyWith(sets: newSets);
      _isDirty = true;
    });
  }

  Future<void> _copyFromLast() async {
    if (_lastRecord.isEmpty) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('記録のコピー'),
        content: const Text('前回の記録をセットしますか?\n現在の入力内容は上書きされます。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('コピー'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final List<WorkoutSet> copiedSets = [];
      for (var set in _lastRecord) {
        copiedSets.add(
          WorkoutSet(
            weight: (set['weight'] as num?)?.toDouble(),
            reps: set['reps'] as int?,
            durationSec: set['durationSec'] as int?,
            assisted: set['assisted'] as bool? ?? false,
          ),
        );
      }

      setState(() {
        _currentItem = _currentItem.copyWith(sets: copiedSets);
        _hideLastRecord = true;
        _isDirty = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('前回の記録をコピーしました'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error copying sets: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('コピーに失敗しました')));
      }
    }
  }

  Future<void> _saveExercise() async {
    try {
      final workoutProvider = context.read<WorkoutProvider>();

      // Update memo from controller
      final updatedItem = _currentItem.copyWith(memo: _memoController.text);

      List<WorkoutItem> newItems;
      if (widget.exerciseIndex != null) {
        // Update existing exercise
        newItems = [...widget.workout.items];
        newItems[widget.exerciseIndex!] = updatedItem;
      } else {
        // Add new exercise
        newItems = [...widget.workout.items, updatedItem];
      }

      final updatedWorkout = widget.workout.copyWith(items: newItems);
      await workoutProvider.updateCurrentWorkout(updatedWorkout);

      if (mounted) {
        setState(() {
          _canPop = true;
        });
        Navigator.of(context).pop(true); // Return true to indicate save
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('保存に失敗しました: ${e.toString()}')));
      }
    }
  }

  Future<void> _deleteExercise() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('種目を削除'),
        content: Text('${_currentItem.exerciseName}を削除しますか?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('削除'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final workoutProvider = context.read<WorkoutProvider>();

      if (widget.exerciseIndex != null) {
        // Delete existing exercise
        final newItems = [...widget.workout.items];
        newItems.removeAt(widget.exerciseIndex!);

        final updatedWorkout = widget.workout.copyWith(items: newItems);
        await workoutProvider.updateCurrentWorkout(updatedWorkout);
      }

      if (mounted) {
        setState(() {
          _canPop = true;
        });
        Navigator.of(context).pop(true); // Return true to indicate deletion
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('削除に失敗しました: ${e.toString()}')));
      }
    }
  }

  Future<void> _handleBack() async {
    if (_isDirty) {
      final shouldSave = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('変更を保存しますか?'),
          content: const Text('保存せずに戻ると、変更内容は破棄されます。'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('保存する'),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('保存しない', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text('キャンセル'),
            ),
          ],
        ),
      );

      if (shouldSave == true) {
        await _saveExercise();
      } else if (shouldSave == false) {
        setState(() {
          _canPop = true;
        });
        Navigator.of(context).pop(false);
      }
    } else {
      setState(() {
        _canPop = true;
      });
      Navigator.of(context).pop(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final unit = context.select<EconomyProvider, String>(
      (provider) => provider.userProfile?.unit ?? 'kg',
    );

    // Get measure type
    final masterProvider = context.watch<MasterProvider>();
    final exercise = masterProvider.getExercise(_currentItem.exerciseId);
    final measureType = exercise?.measureType ?? ExerciseMeasureType.weightReps;

    final isNewExercise = widget.exerciseIndex == null;

    return PopScope(
      canPop: _canPop,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        await _handleBack();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(isNewExercise ? '種目を追加' : '種目を編集'),
          actions: [
            if (!isNewExercise)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: _deleteExercise,
                tooltip: '削除',
              ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(
                        AppConstants.defaultPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Exercise Header
                          Text(
                            _currentItem.exerciseName,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _currentItem.bodyPartName,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 24),

                          // Last Record
                          if (_lastRecord.isNotEmpty && !_hideLastRecord) ...[
                            LastRecordDisplay(
                              lastRecord: _lastRecord,
                              unit: unit,
                              onCopy: _copyFromLast,
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Sets Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'セット',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                '${_currentItem.sets.length} セット',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Sets List
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _currentItem.sets.length,
                            itemBuilder: (context, index) {
                              final shouldAutoFocus =
                                  index == _newlyAddedSetIndex;
                              return SetInputRow(
                                set: _currentItem.sets[index],
                                setNumber: index + 1,
                                unit: unit,
                                measureType: measureType,
                                onChanged: (set) => _updateSet(index, set),
                                onDelete: () => _deleteSet(index),
                                autoFocus: shouldAutoFocus,
                              );
                            },
                          ),

                          // Add Set Button
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: _addSet,
                              icon: const Icon(Icons.add),
                              label: const Text('セットを追加'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Memo
                          TextField(
                            controller: _memoController,
                            decoration: const InputDecoration(
                              labelText: 'メモ (任意)',
                              border: OutlineInputBorder(),
                              hintText: '種目についてのメモ...',
                            ),
                            maxLines: 3,
                            onChanged: (_) {
                              setState(() {
                                _isDirty = true;
                              });
                            },
                          ),

                          const SizedBox(height: 80), // Space for bottom button
                        ],
                      ),
                    ),
                  ),

                  // Bottom Save Button
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
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _saveExercise,
                          icon: const Icon(Icons.check),
                          label: const Text('保存'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: AppConstants.successColor,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
