import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout_item.dart';
import '../models/workout_set.dart';
import '../providers/economy_provider.dart';
import '../widgets/set_input_row.dart';
import '../widgets/last_record_display.dart';

class ExerciseCard extends StatefulWidget {
  final WorkoutItem item;
  final int index;
  final List<Map<String, dynamic>> lastRecord;
  final Function(WorkoutItem) onChanged;
  final VoidCallback onDelete;
  final bool shouldFocusOnLoad;

  const ExerciseCard({
    super.key,
    required this.item,
    required this.index,
    required this.lastRecord,
    required this.onChanged,
    required this.onDelete,
    this.shouldFocusOnLoad = false,
  });

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  late WorkoutItem _currentItem;
  final TextEditingController _memoController = TextEditingController();
  bool _hideLastRecord = false;
  int? _newlyAddedSetIndex; // Track index to focus

  @override
  void initState() {
    super.initState();
    _currentItem = widget.item;
    _memoController.text = widget.item.memo;
  }

  @override
  void dispose() {
    _memoController.dispose();
    super.dispose();
  }

  void _addSet() {
    final newSets = [..._currentItem.sets, WorkoutSet(weight: 0, reps: 0)];
    setState(() {
      _currentItem = _currentItem.copyWith(sets: newSets);
      _newlyAddedSetIndex = newSets.length - 1;
    });
    widget.onChanged(_currentItem);
  }

  void _updateSet(int index, WorkoutSet set) {
    final newSets = [..._currentItem.sets];
    newSets[index] = set;
    _updateItem(_currentItem.copyWith(sets: newSets));
  }

  void _deleteSet(int index) {
    if (_currentItem.sets.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('最低1セット必要です')),
      );
      return;
    }

    final newSets = [..._currentItem.sets];
    newSets.removeAt(index);
    _updateItem(_currentItem.copyWith(sets: newSets));
  }

  Future<void> _copyFromLast() async {
    if (widget.lastRecord.isEmpty) return;

    // Show confirmation dialog matches user request
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('記録のコピー'),
        content: const Text('前回の記録をセットしますか？\n現在の入力内容は上書きされます。'),
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
      for (var set in widget.lastRecord) {
        copiedSets.add(WorkoutSet(
          weight: (set['weight'] as num).toDouble(),
          reps: set['reps'] as int,
          assisted: set['assisted'] as bool? ?? false,
        ));
      }

      _updateItem(_currentItem.copyWith(sets: copiedSets));
      
      setState(() {
        _hideLastRecord = true;
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('コピーに失敗しました')),
        );
      }
    }
  }

  void _updateItem(WorkoutItem item) {
    setState(() {
      _currentItem = item;
    });
    widget.onChanged(item);
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('種目を削除'),
        content: Text('${widget.item.exerciseName}を削除しますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onDelete();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('削除'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final unit = context.select<EconomyProvider, String>(
      (provider) => provider.userProfile?.unit ?? 'kg',
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentItem.exerciseName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        _currentItem.bodyPartName,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: _confirmDelete,
                  tooltip: '削除',
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Last Record
            if (widget.lastRecord.isNotEmpty && !_hideLastRecord) ...[
              LastRecordDisplay(
                lastRecord: widget.lastRecord,
                unit: unit,
                onCopy: _copyFromLast,
              ),
              const SizedBox(height: 12),
            ],

            // Sets
            const Text(
              'セット',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _currentItem.sets.length,
              itemBuilder: (context, index) {
                // Focus if it's a newly added set, OR if it's the first set of a new exercise (and we haven't added manual sets yet)
                final bool shouldAutoFocus = (index == _newlyAddedSetIndex) || 
                                           (widget.shouldFocusOnLoad && index == 0 && _newlyAddedSetIndex == null);
                                           
                return SetInputRow(
                  set: _currentItem.sets[index],
                  setNumber: index + 1,
                  unit: unit,
                  onChanged: (set) => _updateSet(index, set),
                  onDelete: () => _deleteSet(index),
                  autoFocus: shouldAutoFocus,
                );
              },
            ),

            // Add Set Button
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _addSet,
                icon: const Icon(Icons.add),
                label: const Text('セットを追加'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),

            // Memo
            const SizedBox(height: 12),
            TextField(
              controller: _memoController,
              decoration: const InputDecoration(
                labelText: 'メモ (任意)',
                border: OutlineInputBorder(),
                hintText: '種目についてのメモ...',
              ),
              maxLines: 2,
              onChanged: (value) {
                _updateItem(_currentItem.copyWith(memo: value));
              },
            ),
          ],
        ),
      ),
    );
  }
}
