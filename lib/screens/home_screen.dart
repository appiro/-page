import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/economy_provider.dart';
import '../providers/workout_provider.dart';
import '../utils/date_helper.dart';
import '../utils/constants.dart';
import 'workout_exercise_list_screen.dart';
import 'profile_screen.dart';
import 'history_list_screen.dart';
import 'timer_screen.dart';

import 'titles_screen.dart';
import 'settings_screen.dart';

import '../models/economy_state.dart';
import '../models/workout.dart';

import 'calendar_history_screen.dart';
import '../models/title.dart' as app_models;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  bool _checkedTutorial = false;
  final Map<String, bool> _workoutDays = {};
  DateTime? _lastSnackbarTime; // Added for throttling

  @override
  void initState() {
    super.initState();
    // Normalize to midnight for consistent calendar behavior
    final now = DateTime.now();
    _focusedDay = DateTime(now.year, now.month, now.day);
    _selectedDay = _focusedDay;
    // Check weekly goal on home screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
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
      final workouts = await workoutProvider.getWorkoutsInRange(
        firstDay,
        lastDay,
      );
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
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) =>
                CalendarHistoryScreen(initialFocusedDay: selectedDay),
          ),
        )
        .then((_) => _loadWorkoutDays());
  }

  void _showTutorialDialog(BuildContext context, EconomyProvider provider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        int pageIndex = 0;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final pages = [
              {
                'title': 'ようこそ！',
                'icon': Icons.fitness_center,
                'text': 'Fit_Appへようこそ！\n毎日のトレーニングを楽しく記録しましょう。',
              },
              {
                'title': 'ワークアウト記録',
                'icon': Icons.add_circle,
                'text': '画面下の「＋」ボタンから\n自分だけのメニューを作成して\nトレーニングを開始できます。',
              },
              {
                'title': 'コインと称号',
                'icon': Icons.monetization_on,
                'text': 'トレーニング完了でコインをゲット！\nコインでアイテムを買ったり、\n特別な「称号」を集められます。',
              },
              {
                'title': '釣り機能',
                'icon': Icons.directions_boat,
                'text': '息抜きに「釣り」も楽しめます。\nレアな魚をコンプリートしましょう！',
              },
            ];
            final page = pages[pageIndex];

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Column(
                children: [
                  Icon(
                    page['icon'] as IconData,
                    size: 50,
                    color: AppConstants.primaryColor,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    page['title'] as String,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              content: SizedBox(
                height: 120,
                child: Column(
                  children: [
                    Text(
                      page['text'] as String,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        pages.length,
                        (i) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: i == pageIndex
                                ? AppConstants.primaryColor
                                : Colors.grey[300],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                if (pageIndex > 0)
                  TextButton(
                    onPressed: () => setDialogState(() => pageIndex--),
                    child: const Text('戻る'),
                  ),
                if (pageIndex < pages.length - 1)
                  ElevatedButton(
                    onPressed: () => setDialogState(() => pageIndex++),
                    child: const Text('次へ'),
                  )
                else
                  ElevatedButton(
                    onPressed: () {
                      provider.markTutorialAsSeen('home');
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.primaryColor,
                    ),
                    child: const Text('始める'),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _startTodayWorkout() async {
    final workoutProvider = context.read<WorkoutProvider>();

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
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
        Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder: (context) =>
                    WorkoutExerciseListScreen(workout: workout),
              ),
            )
            .then((_) => _loadWorkoutDays());
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('エラー: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final economyProvider = context.watch<EconomyProvider>();

    // Initial Tutorial Check
    if (!_checkedTutorial &&
        !economyProvider.isLoading &&
        economyProvider.userProfile != null) {
      if (!economyProvider.userProfile!.seenTutorials.contains('home')) {
        _checkedTutorial = true;

        // Use Future.delayed to ensure context is ready and frame is done,
        // avoiding "setState() or markNeedsBuild() called during build" errors strictly.
        // Also helps with initial rendering glitches.
        Future.delayed(Duration.zero, () {
          if (mounted) _showTutorialDialog(context, economyProvider);
        });
      } else {
        _checkedTutorial = true;
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8), // Added top spacing
            // Fixed Header
            Container(
              height: 30, // Extremely compact header height
              width: double.infinity,
              color: AppConstants
                  .backgroundColor, // Ensure background covers scrolling content if transparent
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none, // Allow logo to overflow
                children: [
                  Positioned(
                    top: -10, // Center the 50px logo on the 30px header
                    child: SizedBox(
                      height: 50, // Visual Logo Size
                      child: Image.asset('logo.png', fit: BoxFit.contain),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.help_outline,
                              color: AppConstants.primaryColor,
                            ),
                            tooltip: 'チュートリアル',
                            iconSize: 20,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              _showTutorialDialog(
                                context,
                                context.read<EconomyProvider>(),
                              );
                            },
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: const Icon(
                              Icons.settings,
                              color: AppConstants.primaryColor,
                            ),
                            iconSize: 20,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
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
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12), // Spacing for the overflow logo
            // Scrollable Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await context.read<EconomyProvider>().checkWeeklyGoal();
                  await _loadWorkoutDays();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.defaultPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      // Date Header
                      // Streak Header
                      const _ConsecutiveWeeksHeader(),
                      const SizedBox(height: 12),

                      // Calendar
                      // Calendar (Title removed)
                      _buildCalendar(),
                      const SizedBox(height: 24),

                      // Today's Workout Card
                      const _TodayWorkoutCard(),
                      const SizedBox(height: 16),

                      // Weekly Goal Card
                      const _WeeklyGoalCard(),
                      const SizedBox(height: 16),

                      // Economy Display (Moved to Header)
                      // const _EconomyCard(),
                      // const SizedBox(height: 24),

                      // Quick Actions
                      Text(
                        'クイックアクション',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      _buildQuickActions(),
                      const SizedBox(height: 40), // Bottom padding
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: TableCalendar(
          locale: 'ja_JP',
          firstDay: DateTime.utc(2020, 1, 1), // Use UTC for stability
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          calendarFormat: CalendarFormat.month,
          daysOfWeekHeight: 40, // Increased height to prevent clipping
          startingDayOfWeek: StartingDayOfWeek.monday,
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppConstants.primaryColor,
            ),
            leftChevronIcon: Icon(
              Icons.chevron_left,
              color: AppConstants.primaryColor,
            ),
            rightChevronIcon: Icon(
              Icons.chevron_right,
              color: AppConstants.primaryColor,
            ),
          ),
          calendarStyle: CalendarStyle(
            // Today styling
            todayDecoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            todayTextStyle: const TextStyle(
              color: AppConstants.primaryColor,
              fontWeight: FontWeight.bold,
            ),
            // Selected styling (Removed pickup effect)
            selectedDecoration: const BoxDecoration(
              color: Colors.transparent, // No background for selected
              shape: BoxShape.circle,
            ),
            selectedTextStyle: const TextStyle(
              color: Colors.black, // Normal text color
            ),
            // Marker (Workout done) styling
            markerDecoration: const BoxDecoration(
              color: AppConstants.accentColor, // Cyan dots for workouts
              shape: BoxShape.circle,
            ),
            markersMaxCount: 1,
            cellMargin: const EdgeInsets.all(4),
          ),
          calendarBuilders: CalendarBuilders(
            selectedBuilder: (context, day, focusedDay) {
              if (DateHelper.isToday(day)) {
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${day.day}',
                    style: const TextStyle(
                      color: AppConstants.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
              return null;
            },
          ),
          onDaySelected: _onDaySelected,
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
            _loadWorkoutDays(); // Load data without full rebuild explicitly if possible, but simpler to just load.
          },
          eventLoader: (day) {
            final dateKey = DateHelper.toDateKey(day);
            return _workoutDays[dateKey] == true ? [true] : [];
          },
        ),
      ),
    );
  }

  // _buildDateHeader REMOVED

  // NOTE: _buildTodayWorkoutCard, _buildWeeklyGoalCard, _buildEconomyCard are REMOVED
  // and replaced by classes below.

  Widget _buildQuickActions() {
    final actions = [
      _QuickAction(
        icon: Icons.history,
        label: '履歴',
        color: AppConstants.primaryColor,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const HistoryListScreen()),
        ),
      ),
      _QuickAction(
        icon: Icons.timer,
        label: 'タイマー',
        color: AppConstants.primaryColor,
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const TimerScreen())),
      ),
      _QuickAction(
        icon: Icons.emoji_events,
        label: '称号',
        color: AppConstants.primaryColor,
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const TitlesScreen())),
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
            Icon(action.icon, size: 36, color: action.color),
            const SizedBox(height: 8),
            Text(
              action.label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Extracted Widgets for Performance

class _ConsecutiveWeeksHeader extends StatefulWidget {
  const _ConsecutiveWeeksHeader({super.key});

  @override
  State<_ConsecutiveWeeksHeader> createState() =>
      _ConsecutiveWeeksHeaderState();
}

class _ConsecutiveWeeksHeaderState extends State<_ConsecutiveWeeksHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _editName(BuildContext context, String currentName) async {
    _nameController.text = currentName;
    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('名前を変更'),
        content: TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            hintText: '新しい名前',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, _nameController.text),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('保存'),
          ),
        ],
      ),
    );

    if (newName != null && newName.trim().isNotEmpty) {
      if (context.mounted) {
        await context.read<EconomyProvider>().updateDisplayName(newName.trim());
      }
    }
  }

  int _calculateStreak(List<Workout> workouts) {
    if (workouts.isEmpty) return 0;
    final workedWeeks = <String>{};
    for (final workout in workouts) {
      final date = DateHelper.fromDateKey(workout.workoutDateKey);
      final monday = DateHelper.getWeekStart(date, 'mon');
      workedWeeks.add(DateHelper.toDateKey(monday));
    }
    final currentWeekMonday = DateHelper.getWeekStart(DateTime.now(), 'mon');
    final currentKey = DateHelper.toDateKey(currentWeekMonday);
    int streak = 0;
    bool countCurrent = workedWeeks.contains(currentKey);
    DateTime checkDate = currentWeekMonday;
    if (!countCurrent) {
      checkDate = checkDate.subtract(const Duration(days: 7));
      if (!workedWeeks.contains(DateHelper.toDateKey(checkDate))) return 0;
      streak = 1;
      checkDate = checkDate.subtract(const Duration(days: 7));
    } else {
      streak = 1;
      checkDate = checkDate.subtract(const Duration(days: 7));
    }
    while (true) {
      if (workedWeeks.contains(DateHelper.toDateKey(checkDate))) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 7));
      } else {
        break;
      }
    }
    return streak;
  }

  @override
  Widget build(BuildContext context) {
    // Watch workouts & economy
    final workouts = context.select<WorkoutProvider, List<Workout>>(
      (p) => p.workouts,
    );
    final economyProvider = context.watch<EconomyProvider>();

    final streak = _calculateStreak(workouts);
    final isOnFire = streak >= 5;

    final equippedTitle = economyProvider.getEquippedTitle();
    final userProfile = economyProvider.userProfile;
    // Default name is "筋トレ太郎"
    final userName =
        (userProfile?.displayName != null &&
            userProfile!.displayName.isNotEmpty)
        ? userProfile.displayName
        : '筋トレ太郎';

    final titleName = equippedTitle?.name ?? '見習いトレーニー';
    final totalCoins = economyProvider.economyState.totalCoins;

    // Determine Rarity Styles for Badge
    List<BoxShadow> badgeShadows = [];
    Gradient? badgeGradient;
    BoxBorder? badgeBorder;
    Color badgeColor = Colors.amber; // Default (Common)

    if (equippedTitle != null) {
      switch (equippedTitle.rarity) {
        case app_models.TitleRarity.legendary:
          badgeGradient = const LinearGradient(
            colors: [Colors.orange, Colors.redAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
          badgeShadows = [
            BoxShadow(
              color: Colors.redAccent.withOpacity(0.6),
              blurRadius: 10,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Colors.orange.withOpacity(0.4),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ];
          badgeBorder = Border.all(
            color: Colors.white.withOpacity(0.8),
            width: 1,
          );
          badgeColor = Colors.transparent;
          break;
        case app_models.TitleRarity.epic:
          badgeGradient = const LinearGradient(
            colors: [Colors.purpleAccent, Colors.deepPurple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
          badgeShadows = [
            BoxShadow(
              color: Colors.deepPurpleAccent.withOpacity(0.5),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ];
          badgeBorder = Border.all(
            color: Colors.white.withOpacity(0.5),
            width: 1,
          );
          badgeColor = Colors.transparent;
          break;
        case app_models.TitleRarity.rare:
          badgeGradient = const LinearGradient(
            colors: [Colors.cyan, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
          badgeShadows = [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.4),
              blurRadius: 6,
              spreadRadius: 0,
            ),
          ];
          badgeColor = Colors.transparent;
          break;
        case app_models.TitleRarity.common:
        default:
          badgeColor = Colors.amber;
          break;
      }
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // 1. User Profile & Coin Section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left: User Profile (Clickable for Profile Screen)
                Expanded(
                  child: InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          // Avatar
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppConstants.primaryColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppConstants.primaryColor.withOpacity(
                                    0.3,
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Name & Title
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title Badge
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: badgeColor,
                                    gradient: badgeGradient,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: badgeShadows,
                                    border: badgeBorder,
                                  ),
                                  child: Text(
                                    titleName,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // Name with Edit Icon
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        userName,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF2D3142),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Right: Coin Display (Simple)
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.monetization_on_rounded,
                        color: Colors.amber,
                        size: 22,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$totalCoins',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber.shade800,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4), // Padding from right edge
              ],
            ),
          ),

          // 2. Streak Section
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isOnFire) ...[
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: const Icon(
                      Icons.local_fire_department,
                      color: Colors.deepOrange,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '$streak',
                          style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w900,
                            color: isOnFire
                                ? Colors.deepOrange
                                : AppConstants.primaryColor,
                            height: 1.0,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '週間連続',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isOnFire
                                ? Colors.deepOrange
                                : Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (isOnFire) ...[
                  const SizedBox(width: 6),
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: const Icon(
                      Icons.local_fire_department,
                      color: Colors.deepOrange,
                      size: 30,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TodayWorkoutCard extends StatelessWidget {
  const _TodayWorkoutCard();

  Future<void> _startTodayWorkout(BuildContext context) async {
    final workoutProvider = context.read<WorkoutProvider>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final workout = await workoutProvider.getTodayWorkout().timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          final dateKey = DateHelper.getTodayKey();
          return workoutProvider.getOrCreateWorkoutForDate(dateKey);
        },
      );

      if (context.mounted) {
        Navigator.of(context).pop();
        Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder: (context) =>
                    WorkoutExerciseListScreen(workout: workout),
              ),
            )
            .then((_) {
              if (context.mounted) {
                final workouts = context.read<WorkoutProvider>().workouts;
                context.read<EconomyProvider>().checkWeeklyGoal(
                  localWorkouts: workouts,
                );
              }
            });
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('エラー: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
      ),
      child: InkWell(
        // We need to access the parent state's method if we want to refresh calendar...
        // For strict refactoring, we'll implement the navigation logic here
        // and compromise on "automatic dot update" immediately upon return,
        // to decouple.
        onTap: () => _startTodayWorkout(context),
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding * 1.5),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor.withAlpha(
                    (0.1 * 255).round(),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.fitness_center,
                  size: 32,
                  color: AppConstants.accentColor,
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
                        color: AppConstants.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'タップして開始・続行',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.add, size: 24, color: AppConstants.primaryColor),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeeklyGoalCard extends StatelessWidget {
  const _WeeklyGoalCard();

  void _showThrottledSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.orange : null,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showWeeklyGoalPicker(
    BuildContext context,
    EconomyProvider provider,
    int currentGoal,
  ) {
    // Check if already changed in current cycle
    bool alreadyChanged = false;
    final profile = provider.userProfile;
    if (profile != null) {
      final anchor = profile.weeklyGoalAnchor;
      if (anchor != null) {
        final now = DateTime.now();
        final cycleIndex = DateHelper.getCycleIndex(anchor, now);
        final range = DateHelper.getCycleRange(anchor, cycleIndex);
        final cycleStart = range.start;
        final updatedAt = profile.weeklyGoalUpdatedAt;

        print(
          '🔍 Checking if already changed: anchor=$anchor, cycleStart=$cycleStart, updatedAt=$updatedAt',
        );

        if (updatedAt != null && !updatedAt.isBefore(cycleStart)) {
          alreadyChanged = true;
          print('⚠️ Already changed in current cycle!');
        } else {
          print('✅ Not yet changed in current cycle');
        }
      }
    }

    print('📊 alreadyChanged flag: $alreadyChanged');

    showModalBottomSheet(
      context: context,
      builder: (context) {
        int selectedGoal = currentGoal;
        return Container(
          height: 300,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'キャンセル',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const Text(
                      '目標回数を選択',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () async {
                        // Show warning if already changed in current cycle
                        if (alreadyChanged) {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('⚠️ 注意'),
                              content: const Text(
                                '今週の目標は既に変更されています。\n'
                                '再度変更すると、進捗がリセットされる可能性があります。\n\n'
                                '本当に変更しますか？',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text('キャンセル'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.orange,
                                  ),
                                  child: const Text('変更する'),
                                ),
                              ],
                            ),
                          );

                          if (confirm != true) return;
                        }

                        // Update settings
                        Future<void> doUpdate() async {
                          final updateData = <String, dynamic>{
                            'weeklyGoal': selectedGoal,
                            'weeklyGoalUpdatedAt': DateTime.now(),
                          };

                          // Initialize anchor if not set
                          if (provider.userProfile?.weeklyGoalAnchor == null) {
                            updateData['weeklyGoalAnchor'] = DateTime.now();
                            print(
                              '🎯 Initializing weeklyGoalAnchor for the first time',
                            );
                          }

                          await provider.updateSettings(updateData);
                          Navigator.pop(context);
                          _showThrottledSnackBar(
                            context,
                            '週目標を $selectedGoal 回に設定しました',
                          );
                        }

                        await doUpdate();
                      },
                      child: const Text(
                        '保存',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 40,
                  scrollController: FixedExtentScrollController(
                    initialItem: currentGoal - 1,
                  ),
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

  @override
  Widget build(BuildContext context) {
    // Only rebuild when goal-related data changes
    return Consumer<EconomyProvider>(
      builder: (context, economyProvider, child) {
        return FutureBuilder<int>(
          future: economyProvider.getWeeklyWorkoutCount(),
          builder: (context, snapshot) {
            final count = snapshot.data ?? 0;
            final goal = economyProvider.userProfile?.weeklyGoal ?? 3;
            // Use local calculation for UI state
            // If getWeeklyWorkoutCount is async, this widget might flicker on rebuilds?
            // FutureBuilder retains data if future is same? No, getWeeklyWorkoutCount is called anew.
            // Ideally this count should be in the Provider state, not a Future.
            // But for refactoring NOW, we stick to existing flow but localized.

            final achieved = count >= goal;
            final progress = goal > 0 ? count / goal : 0.0;

            final anchor =
                economyProvider.userProfile?.weeklyGoalAnchor ?? DateTime.now();
            final now = DateTime.now();
            final cycleIndex = DateHelper.getCycleIndex(anchor, now);
            final range = DateHelper.getCycleRange(anchor, cycleIndex);
            // Display range (End date inclusive for display, so subtract 1 day from exclusive end)
            final displayEnd = range.end.subtract(const Duration(days: 1));
            final rangeText =
                '${DateHelper.formatDateWithDay(range.start)} 〜 ${DateHelper.formatDateWithDay(displayEnd)}';

            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppConstants.cardBorderRadius,
                ),
              ),
              child: InkWell(
                onTap: () =>
                    _showWeeklyGoalPicker(context, economyProvider, goal),
                borderRadius: BorderRadius.circular(
                  AppConstants.cardBorderRadius,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(
                    AppConstants.defaultPadding * 1.5,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '週目標',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.edit,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                rangeText,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
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
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '$count',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: achieved
                                      ? AppConstants.successColor
                                      : null,
                                ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '/ $goal 回',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: Colors.grey[600]),
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
                            achieved
                                ? AppConstants.successColor
                                : AppConstants.primaryColor,
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
      },
    );
  }
}

class _EconomyCard extends StatelessWidget {
  const _EconomyCard();

  @override
  Widget build(BuildContext context) {
    // Select specific values to avoid rebuilds of other economy fields if possible,
    // but EconomyState is one object. Selector is good.
    return Selector<EconomyProvider, EconomyState>(
      selector: (_, provider) => provider.economyState,
      builder: (context, state, child) {
        // Need to get equipped title name via provider helper or independent lookups
        // Provider helper 'getEquippedTitle' needs reference to full provider?
        // Or we can manually resolve it since the ID is in state.
        final equippedTitleId = state.equippedTitleId;
        final equippedTitle = equippedTitleId != null
            ? context.read<EconomyProvider>().getEquippedTitle()
            : null;
        // Note: read() inside build is discouraged usually but for simple static mapping it's ok?
        // Actually getEquippedTitle just does Title.getTitleById(id).
        // We can do that directly to avoid provider dependency inside build if desired,
        // but consistency is better.
        // However, read() might not be safe if we need to listen?
        // Wait, Selector listens to state. If 'state' changes, builder runs.
        // If getEquippedTitle depends ONLY on state.equippedTitleId, we are fine.

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
                    const Icon(
                      Icons.monetization_on,
                      color: Colors.amber,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'コイン',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                        Text(
                          '${state.totalCoins}',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                if (equippedTitle != null) ...[
                  const Divider(height: 24),
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
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                            Text(
                              equippedTitle.name,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
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
      },
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
