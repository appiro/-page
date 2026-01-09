import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout.dart';
import '../providers/workout_provider.dart';
import '../utils/date_helper.dart';
import 'workout_editor_screen.dart';

class SearchWorkoutsScreen extends StatefulWidget {
  const SearchWorkoutsScreen({super.key});

  @override
  State<SearchWorkoutsScreen> createState() => _SearchWorkoutsScreenState();
}

class _SearchWorkoutsScreenState extends State<SearchWorkoutsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Workout> _results = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    try {
      final results = await context.read<WorkoutProvider>().searchWorkouts(query);
      setState(() {
        _results = results;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('検索エラー: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
                Text('"${workout.title}" をコピーして、\n今日の記録として作成しますか？'),
                const SizedBox(height: 8),
                Text(DateHelper.formatDisplayDate(DateHelper.fromDateKey(workout.workoutDateKey)), style: const TextStyle(color: Colors.grey)),
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
    // Deep copy items to avoid reference issues
    final newItems = workout.items.map((item) {
        return item.copyWith(
            sets: item.sets.map((s) => s.copyWith()).toList(),
        );
    }).toList();

    final newWorkout = Workout(
      id: '', // New ID will be assigned on save
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
        builder: (_) => WorkoutEditorScreen(workout: newWorkout),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'ワークアウト名を検索...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => _performSearch(),
          autofocus: true,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _performSearch,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasSearched && _results.isEmpty
              ? const Center(child: Text('見つかりませんでした'))
              : ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final workout = _results[index];
                    return ListTile(
                      title: Text(workout.title.isEmpty ? '名称未設定' : workout.title),
                      subtitle: Text('${DateHelper.formatDisplayDate(DateHelper.fromDateKey(workout.workoutDateKey))} - ${workout.items.length} 種目'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('長押しでコピーできます'), duration: Duration(seconds: 1)));
                      },
                      onLongPress: () => _confirmCopyWorkout(workout),
                    );
                  },
                ),
    );
  }
}
