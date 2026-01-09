import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/economy_provider.dart';
import '../providers/workout_provider.dart';
import '../utils/date_helper.dart';
import '../utils/constants.dart';
import 'workout_editor_screen.dart';
import 'history_list_screen.dart';
import 'timer_screen.dart';
import 'stats_screen.dart';
import 'shop_screen.dart';
import 'titles_screen.dart';
import 'settings_screen.dart';
import 'body_composition_screen.dart';
import 'calendar_history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<String, bool> _workoutDays = {};
  DateTime? _lastSnackbarTime; // Added for throttling

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    // Check weekly goal on home screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EconomyProvider>().checkWeeklyGoal();
      _loadWorkoutDays();
    });
  }

  void _showThrottledSnackBar(String message, {bool isError = false}) {
    final now = DateTime.now();
    if (_lastSnackbarTime != null && 
        now.difference(_lastSnackbarTime!) < const Duration(seconds: 2)) {
      return; // Skip if shown recently
    }

    _lastSnackbarTime = now;
    
    // Optional: Hide current snackbar to ensure instant switching if we wanted replacement,
    // but here we just want to ignore subsequent taps.
    // ScaffoldMessenger.of(context).hideCurrentSnackBar(); 

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.orange : null,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _loadWorkoutDays() async {
    final workoutProvider = context.read<WorkoutProvider>();
    final firstDay = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final lastDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
    
    try {
      final workouts = await workoutProvider.getWorkoutsInRange(firstDay, lastDay);
      setState(() {
        _workoutDays.clear();
        for (var workout in workouts) {
          _workoutDays[workout.workoutDateKey] = true;
        }
      });
    } catch (e) {
      // Ignore errors in guest mode
    }
  }


  Future<void> _onDaySelected(DateTime selectedDay, DateTime focusedDay) async {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }

    // Navigate to detailed history calendar
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CalendarHistoryScreen(initialFocusedDay: selectedDay),
      ),
    ).then((_) => _loadWorkoutDays());
  }

  Future<void> _startTodayWorkout() async {
    final workoutProvider = context.read<WorkoutProvider>();
    
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final workout = await workoutProvider.getTodayWorkout().timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          // Create local workout on timeout
          final dateKey = DateHelper.getTodayKey();
          return workoutProvider.getOrCreateWorkoutForDate(dateKey);
        },
      );
      
      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => WorkoutEditorScreen(workout: workout),
          ),
        ).then((_) => _loadWorkoutDays());
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('エラー: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final economyProvider = context.watch<EconomyProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await economyProvider.checkWeeklyGoal();
          await _loadWorkoutDays();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Header
              _buildDateHeader(),
              const SizedBox(height: 24),

              // Calendar
              Text(
                'カレンダー',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              _buildCalendar(),
              const SizedBox(height: 24),

              // Today's Workout Card
              _buildTodayWorkoutCard(),
              const SizedBox(height: 16),

              // Weekly Goal Card
              _buildWeeklyGoalCard(economyProvider),
              const SizedBox(height: 16),

              // Economy Display
              _buildEconomyCard(economyProvider),
              const SizedBox(height: 24),

              // Quick Actions
              Text(
                'クイックアクション',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              _buildQuickActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return SizedBox(
      height: 380, // Fixed height to prevent clipping
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8),
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
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: AppConstants.primaryColor.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              todayTextStyle: const TextStyle(
                color: AppConstants.primaryColor,
                fontWeight: FontWeight.bold,
              ),
              selectedDecoration: const BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: const TextStyle(color: Colors.black),
              markerDecoration: const BoxDecoration(
                color: AppConstants.successColor,
                shape: BoxShape.circle,
              ),
            ),
            onDaySelected: _onDaySelected,
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
              _loadWorkoutDays();
            },
            eventLoader: (day) {
              final dateKey = DateHelper.toDateKey(day);
              return _workoutDays[dateKey] == true ? [true] : [];
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDateHeader() {
    final now = DateTime.now();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateHelper.formatDateWithDay(now),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          DateHelper.formatDisplayDate(now),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }

  Widget _buildTodayWorkoutCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
      ),
      child: InkWell(
        onTap: _startTodayWorkout,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding * 1.5),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor.withAlpha((0.1 * 255).round()),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.fitness_center,
                  size: 32,
                  color: AppConstants.primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "今日のワークアウト",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'タップして開始・続行',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeeklyGoalCard(EconomyProvider economyProvider) {
    return FutureBuilder<int>(
      future: economyProvider.getWeeklyWorkoutCount(),
      builder: (context, snapshot) {
        final count = snapshot.data ?? 0;
        final goal = economyProvider.userProfile?.weeklyGoal ?? 3;
        final achieved = count >= goal;
        final progress = goal > 0 ? count / goal : 0.0;
        
        // Calculate date range
        final weekStartsOn = economyProvider.userProfile?.weekStartsOn ?? 'mon';
        final now = DateTime.now();
        final start = DateHelper.getWeekStart(now, weekStartsOn);
        final end = DateHelper.getWeekEnd(start);
        final rangeText = '${DateHelper.formatDateWithDay(start)} 〜 ${DateHelper.formatDateWithDay(end)}';

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
          ),
          child: InkWell(
            onTap: () => _showWeeklyGoalPicker(context, economyProvider, goal),
            onLongPress: () => _showWeeklyGoalPicker(context, economyProvider, goal, force: true),
            borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding * 1.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '週目標',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(width: 8),
                              Icon(Icons.edit, size: 16, color: Colors.grey[600]),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            rangeText,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                  fontSize: 11,
                                ),
                          ),
                        ],
                      ),
                      if (achieved)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppConstants.successColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            '達成！ 🎉',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '$count',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: achieved ? AppConstants.successColor : null,
                                ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '/ $goal 回',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress.clamp(0.0, 1.0),
                      minHeight: 8,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        achieved ? AppConstants.successColor : AppConstants.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showWeeklyGoalPicker(BuildContext context, EconomyProvider provider, int currentGoal, {bool force = false}) {
    // Check if update is allowed
    final profile = provider.userProfile;
    if (profile != null && !force) {
      final now = DateTime.now();
      final weekStart = DateHelper.getWeekStart(now, profile.weekStartsOn);
      final updatedAt = profile.weeklyGoalUpdatedAt;

      // updatedAtが今週の開始日以降（つまり今週中）なら変更不可
      // ただし、厳密には「今週に入ってから変更したか」を見る
      // updatedAt >= weekStart
      if (updatedAt != null && !updatedAt.isBefore(weekStart)) {
         _showThrottledSnackBar('週目標は週に1回までしか変更できません。\n(長押しでリセット可能)', isError: true);
        return;
      }
    }

    showModalBottomSheet(
      context: context,
      builder: (context) {
        int selectedGoal = currentGoal;
        return Container(
          height: 300,
          color: Colors.white,
          child: Column(
            children: [
              // Toolbar
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('キャンセル', style: TextStyle(color: Colors.grey)),
                    ),
                    const Text('目標回数を選択', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () async {
                        void doUpdate() {
                            provider.updateSettings({
                              'weeklyGoal': selectedGoal,
                              'weeklyGoalUpdatedAt': DateTime.now(),
                            });
                            Navigator.pop(context);
                            _showThrottledSnackBar('週目標を $selectedGoal 回に設定しました');
                        }

                        if (force) {
                           final confirm = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                 title: const Text('目標のリセット'),
                                 content: const Text('今週の目標をリセットして、目標を再設定しますか？'),
                                 actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx, false),
                                      child: const Text('キャンセル'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx, true),
                                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                                      child: const Text('リセット'),
                                    ),
                                 ],
                              ),
                           );
                           if (confirm == true) {
                              doUpdate();
                           }
                        } else {
                           doUpdate();
                        }
                      },
                      child: const Text('保存', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              // Picker
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 40,
                  scrollController: FixedExtentScrollController(initialItem: currentGoal - 1),
                  onSelectedItemChanged: (index) {
                    selectedGoal = index + 1;
                  },
                  children: List.generate(7, (index) {
                    return Center(
                      child: Text(
                        '${index + 1} 回',
                        style: const TextStyle(fontSize: 20),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEconomyCard(EconomyProvider economyProvider) {
    final equippedTitle = economyProvider.getEquippedTitle();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding * 1.5),
        child: Column(
          children: [
            // Coins
            Row(
              children: [
                const Icon(Icons.monetization_on, color: Colors.amber, size: 32),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'コイン',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    Text(
                      '${economyProvider.totalCoins}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            if (equippedTitle != null) ...[
              const Divider(height: 24),
              // Equipped Title
              Row(
                children: [
                  Icon(
                    Icons.emoji_events,
                    color: AppConstants.accentColor,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '現在の称号',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                        Text(
                          equippedTitle.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppConstants.accentColor,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      _QuickAction(
        icon: Icons.history,
        label: '履歴',
        color: Colors.blue,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const HistoryListScreen()),
        ),
      ),
      _QuickAction(
        icon: Icons.monitor_weight,
        label: '体組成',
        color: Colors.green,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const BodyCompositionScreen()),
        ),
      ),
      _QuickAction(
        icon: Icons.timer,
        label: 'タイマー',
        color: Colors.orange,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const TimerScreen()),
        ),
      ),
      _QuickAction(
        icon: Icons.shopping_bag,
        label: 'ショップ',
        color: Colors.purple,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const ShopScreen()),
        ),
      ),
      _QuickAction(
        icon: Icons.emoji_events,
        label: '称号',
        color: Colors.amber,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const TitlesScreen()),
        ),
      ),
      _QuickAction(
        icon: Icons.bar_chart,
        label: '統計',
        color: Colors.teal,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const StatsScreen()),
        ),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return _buildQuickActionCard(action);
      },
    );
  }

  Widget _buildQuickActionCard(_QuickAction action) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
      ),
      child: InkWell(
        onTap: action.onTap,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              action.icon,
              size: 36,
              color: action.color,
            ),
            const SizedBox(height: 8),
            Text(
              action.label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}
