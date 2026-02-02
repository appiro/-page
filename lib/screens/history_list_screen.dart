import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout.dart';
import '../providers/workout_provider.dart';
import '../utils/date_helper.dart';
import '../utils/constants.dart';
import 'workout_exercise_list_screen.dart';

class HistoryListScreen extends StatefulWidget {
  const HistoryListScreen({super.key});

  @override
  State<HistoryListScreen> createState() => _HistoryListScreenState();
}

class _HistoryListScreenState extends State<HistoryListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Set<String> _pendingDeletions = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _confirmCopyWorkout(Workout workout) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ワークアウトのコピー'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '"${workout.title.isEmpty ? '名称未設定' : workout.title}" をコピーして、\n今日の記録として作成しますか？',
            ),
            const SizedBox(height: 8),
            Text(
              DateHelper.formatDisplayDate(
                DateHelper.fromDateKey(workout.workoutDateKey),
              ),
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _copyToToday(workout);
            },
            child: const Text('コピーして作成'),
          ),
        ],
      ),
    );
  }

  void _copyToToday(Workout workout) {
    final newItems = workout.items.map((item) {
      return item.copyWith(sets: item.sets.map((s) => s.copyWith()).toList());
    }).toList();

    final newWorkout = Workout(
      id: '',
      workoutDateKey: DateHelper.getTodayKey(),
      title: workout.title,
      note: workout.note,
      items: newItems,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      coinGranted: false,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WorkoutExerciseListScreen(workout: newWorkout),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final workoutProvider = context.watch<WorkoutProvider>();
    final workouts = workoutProvider.workouts;

    // Sort workouts by date (newest first)
    final sortedWorkouts = [...workouts];
    sortedWorkouts.sort((a, b) => b.workoutDateKey.compareTo(a.workoutDateKey));

    // Filter by search query and pending deletions
    final filteredWorkouts = sortedWorkouts.where((w) {
      if (_pendingDeletions.contains(w.id)) return false;
      if (_searchQuery.isEmpty) return true;
      return w.title.contains(_searchQuery);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.black87),
          decoration: InputDecoration(
            hintText: 'ワークアウト履歴を検索...',
            hintStyle: const TextStyle(color: Colors.black54),
            border: InputBorder.none,
            icon: const Icon(Icons.search, color: Colors.black54),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.black54),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  )
                : null,
          ),
          onChanged: (val) => setState(() => _searchQuery = val),
        ),
      ),
      body: workoutProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : filteredWorkouts.isEmpty
          ? (_searchQuery.isEmpty
                ? _buildEmptyState()
                : const Center(child: Text('見つかりませんでした')))
          : ListView.builder(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              itemCount: filteredWorkouts.length,
              itemBuilder: (context, index) {
                final workout = filteredWorkouts[index];
                return Dismissible(
                  key: Key(workout.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    margin: const EdgeInsets.only(bottom: 12),
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('削除の確認'),
                        content: const Text(
                          'このワークアウトを削除しますか？\nデータは完全に削除され、元に戻せません。',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('キャンセル'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            child: const Text('削除'),
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (direction) async {
                    // Optimistically remove from list to ensure Dismissible is removed from tree
                    setState(() {
                      _pendingDeletions.add(workout.id);
                    });

                    try {
                      await context.read<WorkoutProvider>().deleteWorkout(
                        workout.id,
                      );
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('ワークアウトを削除しました')),
                        );
                      }
                    } catch (e) {
                      // Restore if failed
                      if (mounted) {
                        setState(() {
                          _pendingDeletions.remove(workout.id);
                        });
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('削除失敗: $e')));
                      }
                    }
                  },
                  child: _buildWorkoutCard(workout),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.fitness_center, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'まだワークアウトがありません',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text('最初のワークアウトを記録しましょう！', style: TextStyle(color: Colors.grey[600])),
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
              builder: (context) => WorkoutExerciseListScreen(workout: workout),
            ),
          );
        },
        onLongPress: () => _confirmCopyWorkout(workout),
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
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
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
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey[700]),
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                    );
                  }).toList(),
                ),
                if (workout.items.length > 5)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '他${workout.items.length - 5}種目',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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
        Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
      ],
    );
  }
}
