import '../models/workout.dart';
import '../models/title.dart';
import '../models/shop_item.dart';
import '../utils/constants.dart';
import '../models/user_inventory.dart';
import '../repositories/fit_repository.dart';

class EconomyService {
  final FitRepository _repository;

  EconomyService(this._repository);

  // Calculate coins from a workout (total volume)
  int calculateCoins(Workout workout) {
    double totalScore = 0;

    for (var item in workout.items) {
      for (var set in item.sets) {
        // 1. Weighted Sets (Volume)
        if (set.weight != null && set.weight! > 0 && set.reps != null) {
          totalScore += set.weight! * set.reps!;
        }
        // 2. Bodyweight / Reps only (No weight specified or weight is 0)
        else if ((set.weight == null || set.weight! == 0) &&
            set.reps != null &&
            set.reps! > 0) {
          // Assumption: 1 Bodyweight rep ~= 10 points (arbitrary balance)
          totalScore += set.reps! * 10;
        }
        // 3. Time based
        if (set.durationSec != null && set.durationSec! > 0) {
          // 1 second = 1 point
          totalScore += set.durationSec!;
        }
      }
    }

    // Apply multiplier and round to integer
    return (totalScore * AppConstants.coinMultiplier).round();
  }

  // Award coins to user
  Future<void> awardCoins(String uid, int amount) async {
    try {
      final economyState = await _repository.getEconomyState(uid);
      final newState = economyState.copyWith(
        totalCoins: economyState.totalCoins + amount,
        achievementCounts: {
          ...economyState.achievementCounts,
          AppConstants.achievementTotalCoins:
              economyState.getAchievementCount(
                AppConstants.achievementTotalCoins,
              ) +
              amount,
        },
      );

      await _repository.updateEconomyState(uid, newState);
    } catch (e) {
      throw Exception('Failed to award coins: ${e.toString()}');
    }
  }

  // Alias for awardCoins
  Future<void> addCoins(String uid, int amount) async =>
      awardCoins(uid, amount);

  // Deduct coins from user
  Future<void> deductCoins(String uid, int amount) async {
    try {
      final economyState = await _repository.getEconomyState(uid);
      final currentCoins = economyState.totalCoins;
      // Ensure not below 0
      final newCoins = (currentCoins - amount) < 0
          ? 0
          : (currentCoins - amount);

      // Also reduce lifetime to prevent farming
      final currentLifetime = economyState.getAchievementCount(
        AppConstants.achievementTotalCoins,
      );
      final newLifetime = (currentLifetime - amount) < 0
          ? 0
          : (currentLifetime - amount);

      final newState = economyState.copyWith(
        totalCoins: newCoins,
        achievementCounts: {
          ...economyState.achievementCounts,
          AppConstants.achievementTotalCoins: newLifetime,
        },
      );

      await _repository.updateEconomyState(uid, newState);
    } catch (e) {
      throw Exception('Failed to deduct coins: ${e.toString()}');
    }
  }

  // Perform a transaction-like update for purchasing
  // Since we don't have true transactions in abstract repository layer yet,
  // we rely on optimistic updates or separate calls.
  // This method is an alias
  Future<void> consumeCoins(String uid, int amount) async =>
      deductCoins(uid, amount);

  // Update inventory
  Future<void> updateInventory(
    String uid,
    List<UserInventory> inventory,
  ) async {
    try {
      final economyState = await _repository.getEconomyState(uid);
      final newState = economyState.copyWith(inventory: inventory);
      await _repository.updateEconomyState(uid, newState);
    } catch (e) {
      throw Exception('Failed to update inventory: ${e.toString()}');
    }
  }

  // Purchase an item from the shop
  Future<bool> purchaseItem(String uid, String itemId) async {
    try {
      final item = ShopItem.getItemById(itemId);
      if (item == null) {
        throw Exception('Item not found');
      }

      final economyState = await _repository.getEconomyState(uid);

      // Check if already purchased
      if (economyState.isItemPurchased(itemId)) {
        throw Exception('Item already purchased');
      }

      // Check sufficient balance
      if (economyState.totalCoins < item.price) {
        throw Exception(AppConstants.errorInsufficientCoins);
      }

      // Deduct coins and mark as purchased
      final newPurchasedItems = [...economyState.purchasedItemIds, itemId];
      final newState = economyState.copyWith(
        totalCoins: economyState.totalCoins - item.price,
        purchasedItemIds: newPurchasedItems,
      );

      // If it's a title item, also unlock it
      if (item.category == 'title') {
        final newUnlockedTitles = [...economyState.unlockedTitleIds];
        if (!newUnlockedTitles.contains(itemId)) {
          newUnlockedTitles.add(itemId);
        }
        final stateWithTitle = newState.copyWith(
          unlockedTitleIds: newUnlockedTitles,
        );
        await _repository.updateEconomyState(uid, stateWithTitle);
      } else {
        await _repository.updateEconomyState(uid, newState);
      }

      return true;
    } catch (e) {
      throw Exception('Purchase failed: ${e.toString()}');
    }
  }

  // Equip a title
  Future<void> equipTitle(String uid, String? titleId) async {
    try {
      final economyState = await _repository.getEconomyState(uid);

      // If titleId is null, unequip current title
      if (titleId == null) {
        final newState = economyState.copyWith(clearEquippedTitle: true);
        await _repository.updateEconomyState(uid, newState);
        return;
      }

      // Check if title is unlocked
      if (!economyState.isTitleUnlocked(titleId)) {
        throw Exception('Title not unlocked');
      }

      final newState = economyState.copyWith(equippedTitleId: titleId);
      await _repository.updateEconomyState(uid, newState);
    } catch (e) {
      throw Exception('Failed to equip title: ${e.toString()}');
    }
  }

  // Check and unlock titles based on achievements
  Future<List<String>> checkAndUnlockTitles(
    String uid, {
    int? currentStreak,
  }) async {
    print('🔍 [checkAndUnlockTitles] Starting check for uid: $uid');
    print('   Streak parameter: $currentStreak');

    try {
      final economyState = await _repository.getEconomyState(uid);
      final allTitles = Title.getAllTitles();
      final newlyUnlocked = <String>[];

      print(
        '   Currently unlocked: ${economyState.unlockedTitleIds.length} titles',
      );
      print('   Total titles to check: ${allTitles.length}');

      for (var title in allTitles) {
        // Skip if already unlocked
        if (economyState.isTitleUnlocked(title.id)) {
          continue;
        }

        // Check unlock conditions
        bool shouldUnlock = false;

        switch (title.id) {
          // --- Workout Count ---
          case 'first_log':
            final count = economyState.getAchievementCount(
              AppConstants.achievementTotalWorkouts,
            );
            shouldUnlock = count >= 1;
            if (!shouldUnlock) print('   ❌ ${title.id}: $count < 1');
            break;
          case 'stack_10':
            final count = economyState.getAchievementCount(
              AppConstants.achievementTotalWorkouts,
            );
            shouldUnlock = count >= 10;
            if (!shouldUnlock) print('   ❌ ${title.id}: $count < 10');
            break;
          case 'stack_50':
            final count = economyState.getAchievementCount(
              AppConstants.achievementTotalWorkouts,
            );
            shouldUnlock = count >= 50;
            if (!shouldUnlock) print('   ❌ ${title.id}: $count < 50');
            break;
          case 'stack_100':
            final count = economyState.getAchievementCount(
              AppConstants.achievementTotalWorkouts,
            );
            shouldUnlock = count >= 100;
            if (!shouldUnlock) print('   ❌ ${title.id}: $count < 100');
            break;
          case 'routine_complete':
            final count = economyState.getAchievementCount(
              AppConstants.achievementTotalWorkouts,
            );
            shouldUnlock = count >= 300;
            if (!shouldUnlock) print('   ❌ ${title.id}: $count < 300');
            break;

          // --- Streak ---
          case 'not_mikkabouzu':
            if (currentStreak != null) {
              shouldUnlock = currentStreak >= 1;
              if (!shouldUnlock)
                print('   ❌ ${title.id}: streak $currentStreak < 1');
            } else {
              print('   ⚠️ ${title.id}: streak parameter is null');
            }
            break;
          case 'consistency_power':
            if (currentStreak != null) {
              shouldUnlock = currentStreak >= 3;
              if (!shouldUnlock)
                print('   ❌ ${title.id}: streak $currentStreak < 3');
            } else {
              print('   ⚠️ ${title.id}: streak parameter is null');
            }
            break;
          case 'life_part':
            if (currentStreak != null) {
              shouldUnlock = currentStreak >= 6;
              if (!shouldUnlock)
                print('   ❌ ${title.id}: streak $currentStreak < 6');
            } else {
              print('   ⚠️ ${title.id}: streak parameter is null');
            }
            break;
          case 'iron_man_streak':
            if (currentStreak != null) {
              shouldUnlock = currentStreak >= 12;
              if (!shouldUnlock)
                print('   ❌ ${title.id}: streak $currentStreak < 12');
            } else {
              print('   ⚠️ ${title.id}: streak parameter is null');
            }
            break;

          // --- Volume (Single Max) ---
          case 'pump_intro':
            final vol = economyState.getAchievementCount(
              AppConstants.achievementMaxVolume,
            );
            shouldUnlock = vol >= 5000;
            if (!shouldUnlock) print('   ❌ ${title.id}: maxVol $vol < 5000');
            break;
          case 'oikomi_expert':
            final vol = economyState.getAchievementCount(
              AppConstants.achievementMaxVolume,
            );
            shouldUnlock = vol >= 10000;
            if (!shouldUnlock) print('   ❌ ${title.id}: maxVol $vol < 10000');
            break;
          case 'monster_routine':
            final vol = economyState.getAchievementCount(
              AppConstants.achievementMaxVolume,
            );
            shouldUnlock = vol >= 20000;
            if (!shouldUnlock) print('   ❌ ${title.id}: maxVol $vol < 20000');
            break;

          // --- Total Volume ---
          case 'load_1_ton':
            final vol = economyState.getAchievementCount(
              AppConstants.achievementTotalVolume,
            );
            shouldUnlock = vol >= 1000000;
            if (!shouldUnlock)
              print('   ❌ ${title.id}: totalVol $vol < 1000000');
            break;
          case 'load_10_ton':
            final vol = economyState.getAchievementCount(
              AppConstants.achievementTotalVolume,
            );
            shouldUnlock = vol >= 10000000;
            if (!shouldUnlock)
              print('   ❌ ${title.id}: totalVol $vol < 10000000');
            break;

          // --- Total Duration ---
          case '1_hour_training':
            final duration = economyState.getAchievementCount(
              AppConstants.achievementTotalDuration,
            );
            shouldUnlock = duration >= 3600;
            if (!shouldUnlock)
              print('   ❌ ${title.id}: duration $duration < 3600');
            break;
          case '10_hours_training':
            final duration = economyState.getAchievementCount(
              AppConstants.achievementTotalDuration,
            );
            shouldUnlock = duration >= 36000;
            if (!shouldUnlock)
              print('   ❌ ${title.id}: duration $duration < 36000');
            break;
          case '24_hours_training':
            final duration = economyState.getAchievementCount(
              AppConstants.achievementTotalDuration,
            );
            shouldUnlock = duration >= 86400;
            if (!shouldUnlock)
              print('   ❌ ${title.id}: duration $duration < 86400');
            break;
          case '100_hours_training':
            final duration = economyState.getAchievementCount(
              AppConstants.achievementTotalDuration,
            );
            shouldUnlock = duration >= 360000;
            if (!shouldUnlock)
              print('   ❌ ${title.id}: duration $duration < 360000');
            break;

          // --- Coins ---
          case 'coin_collector':
            final coins = economyState.getAchievementCount(
              AppConstants.achievementTotalCoins,
            );
            shouldUnlock = coins >= 1000;
            if (!shouldUnlock) print('   ❌ ${title.id}: coins $coins < 1000');
            break;
          case 'wealthy':
            final coins = economyState.getAchievementCount(
              AppConstants.achievementTotalCoins,
            );
            shouldUnlock = coins >= 5000;
            if (!shouldUnlock) print('   ❌ ${title.id}: coins $coins < 5000');
            break;
          case 'millionaire':
            final coins = economyState.getAchievementCount(
              AppConstants.achievementTotalCoins,
            );
            shouldUnlock = coins >= 10000;
            if (!shouldUnlock) print('   ❌ ${title.id}: coins $coins < 10000');
            break;
        }

        if (shouldUnlock) {
          print('   ✅ UNLOCKING: ${title.id}');
          newlyUnlocked.add(title.id);
        }
      }

      // Update economy state with newly unlocked titles
      if (newlyUnlocked.isNotEmpty) {
        print(
          '💾 Saving ${newlyUnlocked.length} newly unlocked titles to Firestore...',
        );
        final newUnlockedTitles = [
          ...economyState.unlockedTitleIds,
          ...newlyUnlocked,
        ];
        final newState = economyState.copyWith(
          unlockedTitleIds: newUnlockedTitles,
        );
        await _repository.updateEconomyState(uid, newState);
        print('✅ Titles saved successfully');
      } else {
        print('ℹ️ No titles to save');
      }

      return newlyUnlocked;
    } catch (e) {
      print('❌ Error in checkAndUnlockTitles: $e');
      throw Exception('Failed to check titles: ${e.toString()}');
    }
  }

  // Increment achievement count
  Future<void> incrementAchievement(
    String uid,
    String achievementKey, {
    int amount = 1,
  }) async {
    try {
      final economyState = await _repository.getEconomyState(uid);
      final currentCount = economyState.getAchievementCount(achievementKey);

      final newState = economyState.copyWith(
        achievementCounts: {
          ...economyState.achievementCounts,
          achievementKey: currentCount + amount,
        },
      );

      await _repository.updateEconomyState(uid, newState);
    } catch (e) {
      throw Exception('Failed to increment achievement: ${e.toString()}');
    }
  }

  // Update workout stats (volume and duration)
  Future<void> updateWorkoutStats(
    String uid,
    int workoutMaxVolume,
    int workoutTotalVolume,
    int workoutDuration,
  ) async {
    try {
      final economyState = await _repository.getEconomyState(uid);
      final currentTotalVolume = economyState.getAchievementCount(
        AppConstants.achievementTotalVolume,
      );
      final currentMaxVolume = economyState.getAchievementCount(
        AppConstants.achievementMaxVolume,
      );
      final currentTotalDuration = economyState.getAchievementCount(
        AppConstants.achievementTotalDuration,
      );

      final newTotalVolume = currentTotalVolume + workoutTotalVolume;
      final newMaxVolume = (workoutMaxVolume > currentMaxVolume)
          ? workoutMaxVolume
          : currentMaxVolume;
      final newTotalDuration = currentTotalDuration + workoutDuration;

      final newState = economyState.copyWith(
        achievementCounts: {
          ...economyState.achievementCounts,
          AppConstants.achievementTotalVolume: newTotalVolume,
          AppConstants.achievementMaxVolume: newMaxVolume,
          AppConstants.achievementTotalDuration: newTotalDuration,
        },
      );

      await _repository.updateEconomyState(uid, newState);
    } catch (e) {
      throw Exception('Failed to update workout stats: ${e.toString()}');
    }
  }

  // Award weekly goal bonus
  Future<void> awardWeeklyGoalBonus(String uid) async {
    try {
      await awardCoins(uid, AppConstants.weeklyGoalBonusCoins);
      await incrementAchievement(uid, AppConstants.achievementWeeklyGoal);
    } catch (e) {
      throw Exception('Failed to award weekly goal bonus: ${e.toString()}');
    }
  }

  // ==================== Fishing ====================

  // Award fishing tickets
  Future<void> awardTickets(String uid, int amount) async {
    try {
      final economyState = await _repository.getEconomyState(uid);
      final newState = economyState.copyWith(
        fishingTickets: economyState.fishingTickets + amount,
      );
      await _repository.updateEconomyState(uid, newState);
    } catch (e) {
      throw Exception('Failed to award tickets: ${e.toString()}');
    }
  }

  // Alias for awardTickets
  Future<void> addTickets(String uid, int amount) async =>
      awardTickets(uid, amount);

  // Consume tickets
  Future<void> consumeTickets(String uid, int amount) async {
    try {
      final economyState = await _repository.getEconomyState(uid);
      if (economyState.fishingTickets < amount) {
        throw Exception('Not enough tickets');
      }

      final newState = economyState.copyWith(
        fishingTickets: economyState.fishingTickets - amount,
      );
      await _repository.updateEconomyState(uid, newState);
    } catch (e) {
      throw Exception('Failed to consume tickets: ${e.toString()}');
    }
  }

  // Add caught fish to collection
  Future<void> addCaughtFish(String uid, List<String> fishIds) async {
    try {
      final economyState = await _repository.getEconomyState(uid);
      final newCollection = Map<String, int>.from(economyState.fishCollection);

      for (final fishId in fishIds) {
        newCollection[fishId] = (newCollection[fishId] ?? 0) + 1;
      }

      final newState = economyState.copyWith(fishCollection: newCollection);
      await _repository.updateEconomyState(uid, newState);
    } catch (e) {
      throw Exception('Failed to add caught fish: ${e.toString()}');
    }
  }

  // Manual unlock title (e.g. for purchase)
  Future<void> unlockTitle(String uid, String titleId) async {
    try {
      final economyState = await _repository.getEconomyState(uid);
      if (!economyState.unlockedTitleIds.contains(titleId)) {
        final newUnlockedTitles = [...economyState.unlockedTitleIds, titleId];
        final newState = economyState.copyWith(
          unlockedTitleIds: newUnlockedTitles,
        );
        await _repository.updateEconomyState(uid, newState);
      }
    } catch (e) {
      throw Exception('Failed to unlock title: ${e.toString()}');
    }
  }
}
