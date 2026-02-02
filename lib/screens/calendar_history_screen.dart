import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/workout_provider.dart';
import '../providers/master_provider.dart';
import '../utils/constants.dart';
import '../utils/date_helper.dart';
import '../models/workout.dart';
import 'workout_exercise_list_screen.dart';

class CalendarHistoryScreen extends StatefulWidget {
  final DateTime? initialFocusedDay;

  const CalendarHistoryScreen({super.key, this.initialFocusedDay});

  @override
  State<CalendarHistoryScreen> createState() => _CalendarHistoryScreenState();
}

class _CalendarHistoryScreenState extends State<CalendarHistoryScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String? _selectedBodyPartId; // null = ALL
  Map<String, Color> _bodyPartColors = {};
  Map<String, Set<String>> _dailyBodyParts = {}; // dateKey -> Set<bodyPartId>

  static const List<Color> _palette = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pinkAccent,
    Colors.indigo,
    Colors.amber,
    Colors.brown,
  ];

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.initialFocusedDay ?? DateTime.now();
    _selectedDay = _focusedDay;

    // Initial color assignment
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _assignColors();
      _loadMonthData();
    });
  }

  void _assignColors() {
    final bodyParts = context.read<MasterProvider>().bodyParts;
    final newMap = <String, Color>{};
    for (int i = 0; i < bodyParts.length; i++) {
      newMap[bodyParts[i].id] = _palette[i % _palette.length];
    }
    setState(() {
      _bodyPartColors = newMap;
    });
  }

  Future<void> _loadMonthData() async {
    final workoutProvider = context.read<WorkoutProvider>();
    final firstDay = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final lastDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);

    try {
      final workouts = await workoutProvider.getWorkoutsInRange(
        firstDay,
        lastDay,
      );
      final newMap = <String, Set<String>>{};

      for (var workout in workouts) {
        final dateKey = workout.workoutDateKey;
        if (!newMap.containsKey(dateKey)) {
          newMap[dateKey] = {};
        }

        // Collect bodyPartIds from workout items
        for (var item in workout.items) {
          if (item.bodyPartId.isNotEmpty) {
            newMap[dateKey]!.add(item.bodyPartId);
          }
        }
      }

      setState(() {
        _dailyBodyParts = newMap;
      });
    } catch (e) {
      debugPrint('Error loading workouts: $e');
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) async {
    // Navigate to editor
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }

    final dateKey = DateHelper.toDateKey(selectedDay);
    final workoutProvider = context.read<WorkoutProvider>();

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final workout = await workoutProvider.getOrCreateWorkoutForDate(dateKey);
      if (mounted) {
        Navigator.of(context).pop(); // Close dialog
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => WorkoutExerciseListScreen(workout: workout),
          ),
        );
        _loadMonthData(); // Reload on return
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bodyParts = context.watch<MasterProvider>().bodyParts;

    // Refresh colors if body parts changed (simple check)
    if (bodyParts.length != _bodyPartColors.length) {
      // Re-assign might be needed but for now keep simple
    }

    return Scaffold(
      appBar: AppBar(title: const Text('履歴'), centerTitle: true),
      body: Column(
        children: [
          // Filter Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildFilterChip('ALL', null),
                ...bodyParts.map((bp) => _buildFilterChip(bp.name, bp.id)),
              ],
            ),
          ),

          const Divider(height: 1),

          // Calendar
          Expanded(
            child: TableCalendar(
              locale: 'ja_JP',
              daysOfWeekHeight: 30,
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.monday,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              onDaySelected: _onDaySelected,
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
                _loadMonthData();
              },
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                ),
                todayTextStyle: TextStyle(
                  color: AppConstants.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                selectedTextStyle: TextStyle(color: Colors.black),
              ),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, date, focusedDay) => _buildCell(date),
                todayBuilder: (context, date, focusedDay) =>
                    _buildCell(date, isToday: true),
                selectedBuilder: (context, date, focusedDay) =>
                    _buildCell(date, isSelected: true),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper filter chip...
  Widget _buildFilterChip(String label, String? id) {
    // ... (Keep existing implementation, but ensure it's not deleted by overlap)
    final isSelected = _selectedBodyPartId == id;
    final color = id == null
        ? AppConstants.primaryColor
        : (_bodyPartColors[id] ?? Colors.grey);

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedBodyPartId = selected ? id : null;
            if (!selected && id == _selectedBodyPartId) return;
            _selectedBodyPartId = id;
          });
        },
        backgroundColor: Colors.grey[200],
        selectedColor: color.withAlpha(50),
        checkmarkColor: color,
        labelStyle: TextStyle(
          color: isSelected ? color : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? color : Colors.transparent,
            width: 1,
          ),
        ),
        showCheckmark: false,
      ),
    );
  }

  Widget? _buildCell(
    DateTime date, {
    bool isToday = false,
    bool isSelected = false,
  }) {
    final dateKey = DateHelper.toDateKey(date);
    final parts = _dailyBodyParts[dateKey];

    if (parts == null || parts.isEmpty) {
      // No data
      if (isToday) {
        return Center(
          child: Container(
            margin: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(
                0.2,
              ), // Light purple for today
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '${date.day}',
              style: const TextStyle(
                color: AppConstants.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }
      return null;
    }

    // Filter logic
    Color? color;
    if (_selectedBodyPartId != null) {
      if (parts.contains(_selectedBodyPartId)) {
        color = _bodyPartColors[_selectedBodyPartId] ?? Colors.grey;
      } else {
        return null;
      }
    } else {
      final sortedParts = parts.toList()..sort();
      color = _bodyPartColors[sortedParts.first] ?? Colors.grey;
    }

    return Center(
      child: Container(
        margin: const EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          // Add border for today if it has data
          border: isToday
              ? Border.all(
                  color: AppConstants.primaryColor.withOpacity(0.5),
                  width: 2,
                )
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          '${date.day}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
