import 'package:flutter/foundation.dart';
import '../models/economy_state.dart';
import '../models/title.dart';
import '../models/shop_item.dart';
import '../models/user_profile.dart';
import '../models/fishing_item.dart';
import '../models/user_inventory.dart';
import '../repositories/fit_repository.dart';
import '../services/economy_service.dart';
import '../services/fishing_service.dart';
import '../services/fishing_shop_service.dart';
import '../models/fish.dart';
import '../models/workout.dart';
import '../utils/date_helper.dart';
import '../utils/constants.dart';

class EconomyProvider with ChangeNotifier {
  final FitRepository _repository;
  final EconomyService _economyService;
  final String uid;
  final FishingShopService _fishingShopService = FishingShopService();

  EconomyState _economyState = EconomyState();
  UserProfile? _userProfile;
  // FishingSchedule? _fishingSchedule; // Removed non-existent class
  bool _isLoading = false;
  String? _errorMessage;
  bool _weeklyGoalAchieved = false;
  int _consecutiveWeeksStreak = 0;
  bool _disposed = false;

  EconomyProvider({
    required FitRepository repository,
    required EconomyService economyService,
    required this.uid,
  }) : _repository = repository,
       _economyService = economyService {
    _loadData();
  }

  EconomyState get economyState => _economyState;
  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get weeklyGoalAchieved => _weeklyGoalAchieved;
  int get consecutiveWeeksStreak => _consecutiveWeeksStreak;

  int get totalCoins => _economyState.totalCoins;
  String? get equippedTitleId => _economyState.equippedTitleId;
  List<String> get unlockedTitleIds => _economyState.unlockedTitleIds;
  List<String> get purchasedItemIds => _economyState.purchasedItemIds;

  // Load economy state and user profile
  Future<void> _loadData() async {
    print('🔄 [EconomyProvider] _loadData called for user: $uid');
    if (_disposed) {
      print('⚠️ [EconomyProvider] Provider is disposed, aborting load');
      return;
    }
    _isLoading = true;
    notifyListeners();

    try {
      // Load user profile
      print('🔄 [EconomyProvider] Loading user profile...');
      _userProfile = await _repository.getUserProfile(uid);
      print('✅ [EconomyProvider] User profile loaded: $_userProfile');

      // Listen to economy state stream
      print('🔄 [EconomyProvider] Subscribing to economy state stream...');
      _repository
          .getEconomyStateStream(uid)
          .listen(
            (state) {
              if (_disposed) return;
              print(
                '✅ [EconomyProvider] Received economy state update: Coins=${state.totalCoins}, Workouts=${state.getAchievementCount("totalWorkouts")}',
              );
              _economyState = state;
              notifyListeners();
            },
            onError: (error) {
              print('❌ [EconomyProvider] Economy state stream error: $error');
            },
          );

      if (_disposed) return;
      _isLoading = false;
      // Calculate streak initially
      calculateConsecutiveWeeksStreak();
      notifyListeners();
    } catch (e, stackTrace) {
      print('❌ [EconomyProvider] Error in _loadData: $e');
      print(stackTrace);
      if (_disposed) return;
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // ==================== Weekly Goal ====================

  // ==================== Weekly Goal ====================

  Future<void> checkWeeklyGoal({List<Workout>? localWorkouts}) async {
    if (_userProfile == null) return;

    // Initialize anchor if missing
    if (_userProfile!.weeklyGoalAnchor == null) {
      // Set anchor to start of today (00:00:00) to ensure clean weekly boundaries
      final now = DateTime.now();
      final anchorDate = DateTime(now.year, now.month, now.day);
      await updateSettings({'weeklyGoalAnchor': anchorDate});
      if (_userProfile?.weeklyGoalAnchor == null) return;
    }

    var anchor = _userProfile!.weeklyGoalAnchor!;

    // Normalize anchor to start of day if it has a time component
    if (anchor.hour != 0 || anchor.minute != 0 || anchor.second != 0) {
      print('⚠️ Normalizing anchor from $anchor to start of day');
      anchor = DateTime(anchor.year, anchor.month, anchor.day);
      await updateSettings({'weeklyGoalAnchor': anchor});
    }
    final now = DateTime.now();
    final currentCycleIndex = DateHelper.getCycleIndex(anchor, now);

    try {
      // 1. Get workouts covering the cycle
      final dateKeys = DateHelper.getDateKeysForCycle(
        anchor,
        currentCycleIndex,
      );

      List<Workout> workouts;
      if (localWorkouts != null) {
        workouts = localWorkouts
            .where((w) => dateKeys.contains(w.workoutDateKey))
            .toList();
      } else {
        workouts = await _repository.getWorkoutsForWeek(uid, dateKeys);
      }

      // 2. Filter strictly within cycle range [start, end)
      final range = DateHelper.getCycleRange(anchor, currentCycleIndex);
      final count = workouts.where((w) {
        // Using DateHelper parsing.
        // Note: If workout has specific timestamp field 'createdAt' use it, otherwise dateKey.
        // Assuming dateKey is primary for now as per previous code.
        final wDate = DateHelper.fromDateKey(w.workoutDateKey);
        return wDate.isAtSameMomentAs(range.start) ||
            (wDate.isAfter(range.start) && wDate.isBefore(range.end));
      }).length;

      final goal = _userProfile!.weeklyGoal;
      final achieved = count >= goal;

      _weeklyGoalAchieved = achieved;

      // 3. Reward Check
      // Condition: Target met AND not yet rewarded for this specific cycle
      if (achieved &&
          _userProfile!.lastRewardedCycleIndex < currentCycleIndex) {
        // Reward Formula: Linear (100 + goal * 50)
        // e.g. Goal 3 -> 250 coins
        final reward = 100 + (goal * 50);

        print(
          '🎉 Weekly goal achieved! Granting reward: $reward coins (Cycle: $currentCycleIndex)',
        );

        // 4. Update Profile FIRST to lock this cycle (prevent double spend)
        await updateSettings({'lastRewardedCycleIndex': currentCycleIndex});

        // 5. Grant Reward
        // Assuming addCoins exists or we use awardWeeklyGoalBonus generic
        // If specific method for coins doesn't exist, we fallback to specific service call
        // For this task, we assume we can add coins.
        await _economyService.addCoins(uid, reward);

        print(
          '✅ Reward granted successfully. New cycle index: $currentCycleIndex',
        );
      } else if (achieved) {
        print(
          'ℹ️ Goal achieved but already rewarded for cycle $currentCycleIndex (last: ${_userProfile!.lastRewardedCycleIndex})',
        );
      }

      // ALWAYS Check titles
      await _economyService.checkAndUnlockTitles(
        uid,
        currentStreak: _consecutiveWeeksStreak,
      );

      // Recalculate streak after checking goal
      await calculateConsecutiveWeeksStreak();

      notifyListeners();
    } catch (e) {
      print('❌ Error in checkWeeklyGoal: $e');
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<int> getWeeklyWorkoutCount() async {
    if (_userProfile?.weeklyGoalAnchor == null) return 0;

    final anchor = _userProfile!.weeklyGoalAnchor!;
    final now = DateTime.now();
    final currentCycleIndex = DateHelper.getCycleIndex(anchor, now);

    try {
      final dateKeys = DateHelper.getDateKeysForCycle(
        anchor,
        currentCycleIndex,
      );
      final workouts = await _repository.getWorkoutsForWeek(uid, dateKeys);

      final range = DateHelper.getCycleRange(anchor, currentCycleIndex);
      final count = workouts.where((w) {
        final wDate = DateHelper.fromDateKey(w.workoutDateKey);
        return wDate.isAtSameMomentAs(range.start) ||
            (wDate.isAfter(range.start) && wDate.isBefore(range.end));
      }).length;

      return count;
    } catch (e) {
      return 0;
    }
  }

  Future<void> calculateConsecutiveWeeksStreak() async {
    if (_userProfile?.weeklyGoalAnchor == null) {
      _consecutiveWeeksStreak = 0;
      notifyListeners();
      return;
    }

    var anchor = _userProfile!.weeklyGoalAnchor!;

    // Normalize anchor to start of day
    if (anchor.hour != 0 || anchor.minute != 0 || anchor.second != 0) {
      anchor = DateTime(anchor.year, anchor.month, anchor.day);
    }

    final now = DateTime.now();
    final currentCycleIndex = DateHelper.getCycleIndex(anchor, now);
    final goal = _userProfile!.weeklyGoal;

    // Fetch last 52 weeks of workouts to be safe
    final startDate = now.subtract(const Duration(days: 366));

    try {
      final allWorkouts = await _repository.getWorkoutsByDateRange(
        uid,
        startDate,
        now,
      );

      final Map<int, int> workoutsPerCycle = {};
      for (var w in allWorkouts) {
        final wDate = DateHelper.fromDateKey(w.workoutDateKey);
        final index = DateHelper.getCycleIndex(anchor, wDate);
        workoutsPerCycle[index] = (workoutsPerCycle[index] ?? 0) + 1;
      }

      int streak = 0;
      bool isCurrentWeek = true;

      // Iterate backwards
      for (int i = currentCycleIndex; i > currentCycleIndex - 52; i--) {
        final count = workoutsPerCycle[i] ?? 0;

        if (count >= goal) {
          streak++;
        } else {
          // If current week is not met, we don't increment, but we verify previous weeks
          if (isCurrentWeek) {
            // Current week shortfall doesn't break the streak from the past
          } else {
            // A past week failed, so the streak stops
            break;
          }
        }
        isCurrentWeek = false;
      }

      _consecutiveWeeksStreak = streak;
      notifyListeners();
    } catch (e) {
      print('Error calculating streak: $e');
    }
  }

  // ==================== Shop ====================

  Future<bool> purchaseItem(String itemId) async {
    try {
      await _economyService.purchaseItem(uid, itemId);

      // Check for title unlocks after purchase
      await _economyService.checkAndUnlockTitles(
        uid,
        currentStreak: _consecutiveWeeksStreak,
      );

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  bool canPurchaseItem(String itemId) {
    if (_economyState.isItemPurchased(itemId)) return false;

    // Check price in ShopItem master data
    final item = ShopItem.allItems.firstWhere((i) => i.id == itemId);
    return _economyState.totalCoins >= item.price;
  }

  // ==================== Fishing Shop ====================

  Future<void> purchaseFishingItem(FishingItem item) async {
    final result = _fishingShopService.purchaseItem(
      item,
      _economyState.totalCoins,
      _economyState.inventory,
    );

    if (!result.success) {
      _errorMessage = result.message;
      notifyListeners();
      return;
    }

    try {
      // チケット購入の場合
      if (result.ticketsToAdd != null) {
        await _economyService.consumeCoins(uid, item.price);
        await _economyService.addTickets(uid, result.ticketsToAdd!);
      } else {
        // 通常アイテム購入
        // Firestoreにはインベントリ全体を保存する必要があるため、少し複雑
        final newInventory = [
          ..._economyState.inventory,
          result.newInventoryItem!,
        ];

        // コイン消費とインベントリ更新をトランザクション的に行いたいが、
        // 現状のServiceインタフェースでは個別の更新になる
        await _economyService.consumeCoins(uid, item.price);
        await _economyService.updateInventory(uid, newInventory);

        _economyState = _economyState.copyWith(
          inventory: newInventory,
          totalCoins: result.newCoins,
        );
      }

      notifyListeners();
    } catch (e) {
      _errorMessage = '購入処理に失敗しました: $e';
      notifyListeners();
    }
  }

  Future<void> useFishingItem(UserInventory inventoryItem) async {
    final item = FishingItem.getById(inventoryItem.itemId);
    if (item == null) return;

    // 「釣り竿」以外は釣り実行時に自動消費されるため、ここでは何もしない（釣り竿装備は別メソッド）
    // もし手動で使用するアイテム（例：チケット回復薬など）があればここに実装

    // 現在の使用可能アイテムは、釣り画面で選択・自動適用されるタイプなので
    // ここでは装備ロジックのみ提供
  }

  Future<void> equipItem(UserInventory item) async {
    final result = _fishingShopService.equipItem(item, _economyState.inventory);

    if (!result.success) {
      _errorMessage = result.message;
      notifyListeners();
      return;
    }

    try {
      if (result.updatedInventory != null) {
        await _economyService.updateInventory(uid, result.updatedInventory!);
        _economyState = _economyState.copyWith(
          inventory: result.updatedInventory,
        );
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = '装備変更に失敗しました: $e';
      notifyListeners();
    }
  }

  Future<void> unequipItem(UserInventory item) async {
    final result = _fishingShopService.unequipItem(
      item,
      _economyState.inventory,
    );

    try {
      if (result.updatedInventory != null) {
        await _economyService.updateInventory(uid, result.updatedInventory!);
        _economyState = _economyState.copyWith(
          inventory: result.updatedInventory,
        );
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = '装備解除に失敗しました: $e';
      notifyListeners();
    }
  }

  // ==================== Fishing ====================

  Future<List<Fish>> castLine(int times) async {
    // 1. Check tickets
    if (_economyState.fishingTickets < times) {
      _errorMessage = 'チケットが足りません';
      notifyListeners();
      return [];
    }

    try {
      // 2. Consume tickets
      await _economyService.consumeTickets(uid, times);

      List<Fish> allCaughtFish = [];
      List<UserInventory> currentInventory = [..._economyState.inventory];
      bool inventoryChanged = false;

      final fishingService = FishingService();

      // 3. Loop per cast to handle item consumption correctly
      for (int i = 0; i < times; i++) {
        // アイテム効果の取得 (現在のインベントリ状態から)
        final effects = _fishingShopService.getActiveEffects(currentInventory);

        // 1匹釣る
        final caughtList = fishingService.fish(1, effects);
        allCaughtFish.addAll(caughtList);

        // 4. Consume item durability per cast
        bool localChanged = false;
        final consumedTypes = <FishingItemType>{}; // 各キャスト内でタイプごとに消費を1回に制限

        // Iterate backwards to safely remove items
        for (int j = currentInventory.length - 1; j >= 0; j--) {
          final item = currentInventory[j];
          if (item.isEquipped) {
            final itemDef = FishingItem.getById(item.itemId);
            if (itemDef != null && itemDef.durability > 0) {
              // 既にこのタイプのアイテムを消費済みならスキップ（重複消費防止）
              if (consumedTypes.contains(itemDef.type)) {
                continue;
              }

              final result = _fishingShopService.useItem(item, itemDef);

              if (result.success && result.updatedInventory != null) {
                // 消費成功したらこのタイプは済みとする
                consumedTypes.add(itemDef.type);

                if (result.shouldRemove) {
                  currentInventory.removeAt(j);
                } else {
                  currentInventory[j] = result.updatedInventory!;
                }
                localChanged = true;
              }
            }
          }
        }
        if (localChanged) inventoryChanged = true;
      }

      // 5. Update collection
      final fishIds = allCaughtFish.map((f) => f.id).toList();
      await _economyService.addCaughtFish(uid, fishIds);

      // 6. Update inventory (bulk update)
      if (inventoryChanged) {
        await _economyService.updateInventory(uid, currentInventory);
        _economyState = _economyState.copyWith(inventory: currentInventory);
      }

      return allCaughtFish;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return [];
    }
  }

  // Award tickets (wrapper)
  Future<void> awardTickets(int amount) async {
    try {
      await _economyService.awardTickets(uid, amount);
    } catch (e) {
      debugPrint('Failed to award tickets: $e');
      // Don't expose error strictly for background tasks
    }
  }

  List<Fish> getCaughtFish() {
    return Fish.allFishes
        .where((fish) => _economyState.fishCollection.containsKey(fish.id))
        .toList();
  }

  int getFishCount(String fishId) {
    return _economyState.fishCollection[fishId] ?? 0;
  }

  // ==================== Titles ====================

  Future<void> equipTitle(String? titleId) async {
    try {
      await _economyService.equipTitle(uid, titleId);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<bool> purchaseTitle(Title title) async {
    if (title.price == null) return false;

    // Check funds
    if (_economyState.totalCoins < title.price!) {
      _errorMessage = 'コインが足りません';
      notifyListeners();
      return false;
    }

    try {
      // Consume coins and unlock
      await _economyService.consumeCoins(uid, title.price!);
      await _economyService.unlockTitle(uid, title.id);

      // Since EconomyService methods don't return new state, we must reload or update locally
      // Ideally reload for consistency
      final newState = await _repository.getEconomyState(uid);
      _economyState = newState;

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = '購入に失敗しました: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Title? getEquippedTitle() {
    if (_economyState.equippedTitleId == null) return null;
    return Title.getTitleById(_economyState.equippedTitleId!);
  }

  List<Title> getUnlockedTitles() {
    return Title.getAllTitles()
        .where((title) => _economyState.isTitleUnlocked(title.id))
        .toList();
  }

  List<Title> getLockedTitles() {
    return Title.getAllTitles()
        .where((title) => !_economyState.isTitleUnlocked(title.id))
        .toList();
  }

  String? getTitleProgress(String titleId) {
    // 1. streak
    if (titleId == 'not_mikkabouzu') return '$_consecutiveWeeksStreak / 1 週間';
    if (titleId == 'consistency_power') {
      return '$_consecutiveWeeksStreak / 3 週間';
    }
    if (titleId == 'life_part') return '$_consecutiveWeeksStreak / 6 週間';
    if (titleId == 'iron_man_streak') return '$_consecutiveWeeksStreak / 12 週間';

    // 2. Count
    final count = _economyState.getAchievementCount(
      AppConstants.achievementTotalWorkouts,
    );
    if (titleId == 'first_log') return '$count / 1 回';
    if (titleId == 'stack_10') return '$count / 10 回';
    if (titleId == 'stack_50') return '$count / 50 回';
    if (titleId == 'stack_100') return '$count / 100 回';
    if (titleId == 'routine_complete') return '$count / 300 回';

    // 3. Volume (Single Max)
    final maxVol = _economyState.getAchievementCount(
      AppConstants.achievementMaxVolume,
    );
    if (titleId == 'pump_intro') return '${_formatVol(maxVol)} / 5,000 kg';
    if (titleId == 'oikomi_expert') return '${_formatVol(maxVol)} / 10,000 kg';
    if (titleId == 'monster_routine') {
      return '${_formatVol(maxVol)} / 20,000 kg';
    }

    // 4. Total Volume
    final totalVol = _economyState.getAchievementCount(
      AppConstants.achievementTotalVolume,
    );
    if (titleId == 'load_1_ton') {
      return '${_formatVol(totalVol)} / 1,000,000 kg';
    }
    if (titleId == 'load_10_ton') {
      return '${_formatVol(totalVol)} / 10,000,000 kg';
    }

    return null;
  }

  String _formatVol(int vol) {
    // Format with commas, e.g. 2,500
    return vol.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  // ==================== Settings ====================

  Future<void> updateDisplayName(String newName) async {
    return updateSettings({'displayName': newName});
  }

  Future<void> markTutorialAsSeen(String tutorialId) async {
    if (_userProfile == null) return;
    if (_userProfile!.seenTutorials.contains(tutorialId)) return;

    final updatedList = List<String>.from(_userProfile!.seenTutorials)
      ..add(tutorialId);

    // We update local state immediately
    _userProfile = _userProfile!.copyWith(seenTutorials: updatedList);
    notifyListeners();

    await updateSettings({'seenTutorials': updatedList});
  }

  Future<void> updateSettings(Map<String, dynamic> settings) async {
    try {
      print('📝 Updating settings: $settings');
      await _repository.updateUserProfile(uid, settings);

      // Reload user profile
      _userProfile = await _repository.getUserProfile(uid);
      print(
        '✅ Settings updated successfully. New profile: weeklyGoal=${_userProfile?.weeklyGoal}, anchor=${_userProfile?.weeklyGoalAnchor}',
      );
      notifyListeners();
    } catch (e) {
      print('❌ Error updating settings: $e');
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> registerWorkoutCompletion(Workout workout) async {
    print('📊 [registerWorkoutCompletion] Starting...');

    final totalVol = workout.totalVolume.round();
    final maxVol = totalVol;
    final totalDuration = workout.totalDuration;

    print(
      '📊 Stats - Volume: $totalVol, Max: $maxVol, Duration: $totalDuration',
    );

    // Update stats
    await _economyService.updateWorkoutStats(
      uid,
      maxVol,
      totalVol,
      totalDuration,
    );
    print('✅ Workout stats updated');

    // Reload state to get latest achievement counts
    final newState = await _repository.getEconomyState(uid);
    _economyState = newState;

    final totalWorkouts = _economyState.getAchievementCount(
      AppConstants.achievementTotalWorkouts,
    );
    final totalVolume = _economyState.getAchievementCount(
      AppConstants.achievementTotalVolume,
    );
    final maxVolume = _economyState.getAchievementCount(
      AppConstants.achievementMaxVolume,
    );

    print('📊 Current Stats:');
    print('   - Total Workouts: $totalWorkouts');
    print('   - Total Volume: $totalVolume');
    print('   - Max Volume: $maxVolume');
    print('   - Current Streak: $_consecutiveWeeksStreak');

    // Check and unlock titles with current streak
    print('🔍 Checking title unlock conditions...');
    final unlockedTitles = await _economyService.checkAndUnlockTitles(
      uid,
      currentStreak: _consecutiveWeeksStreak,
    );

    if (unlockedTitles.isNotEmpty) {
      print('🎉 Newly unlocked titles: $unlockedTitles');
    } else {
      print('ℹ️ No new titles unlocked');
    }

    // Reload state again to reflect unlocked titles
    final finalState = await _repository.getEconomyState(uid);
    _economyState = finalState;

    print(
      '✅ [registerWorkoutCompletion] Complete. Unlocked titles: ${_economyState.unlockedTitleIds.length}',
    );

    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
