import '../models/workout.dart';
import '../models/title.dart';
import '../models/shop_item.dart';
import '../utils/constants.dart';
import '../repositories/fit_repository.dart';

class EconomyService {
  final FitRepository _repository;

  EconomyService(this._repository);

  // Calculate coins from a workout (total volume)
  int calculateCoins(Workout workout) {
    // Using Option A from requirements: Simple volume = Σ(weight × reps)
    // Bodyweight exercises (weight=0) award 0 coins initially
    final totalVolume = workout.totalVolume;
    
    // Apply multiplier and round to integer
    return (totalVolume * AppConstants.coinMultiplier).round();
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
              economyState.getAchievementCount(AppConstants.achievementTotalCoins) + amount,
        },
      );
      
      await _repository.updateEconomyState(uid, newState);
    } catch (e) {
      throw Exception('Failed to award coins: ${e.toString()}');
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
        final stateWithTitle = newState.copyWith(unlockedTitleIds: newUnlockedTitles);
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
  Future<List<String>> checkAndUnlockTitles(String uid) async {
    try {
      final economyState = await _repository.getEconomyState(uid);
      final allTitles = Title.getAllTitles();
      final newlyUnlocked = <String>[];

      for (var title in allTitles) {
        // Skip if already unlocked
        if (economyState.isTitleUnlocked(title.id)) {
          continue;
        }

        // Check unlock conditions
        bool shouldUnlock = false;

        switch (title.id) {
          case 'first_step':
            shouldUnlock = economyState.getAchievementCount(AppConstants.achievementTotalWorkouts) >= 1;
            break;
          case 'consistent':
            shouldUnlock = economyState.getAchievementCount(AppConstants.achievementWeeklyGoal) >= 1;
            break;
          case 'dedicated':
            shouldUnlock = economyState.getAchievementCount(AppConstants.achievementWeeklyGoal) >= 3;
            break;
          case 'iron_will':
            shouldUnlock = economyState.getAchievementCount(AppConstants.achievementWeeklyGoal) >= 10;
            break;
          case 'coin_collector':
            shouldUnlock = economyState.getAchievementCount(AppConstants.achievementTotalCoins) >= 1000;
            break;
          case 'wealthy':
            shouldUnlock = economyState.getAchievementCount(AppConstants.achievementTotalCoins) >= 5000;
            break;
          case 'beginner':
            shouldUnlock = economyState.getAchievementCount(AppConstants.achievementTotalWorkouts) >= 5;
            break;
          case 'intermediate':
            shouldUnlock = economyState.getAchievementCount(AppConstants.achievementTotalWorkouts) >= 25;
            break;
          case 'advanced':
            shouldUnlock = economyState.getAchievementCount(AppConstants.achievementTotalWorkouts) >= 100;
            break;
        }

        if (shouldUnlock) {
          newlyUnlocked.add(title.id);
        }
      }

      // Update economy state with newly unlocked titles
      if (newlyUnlocked.isNotEmpty) {
        final newUnlockedTitles = [...economyState.unlockedTitleIds, ...newlyUnlocked];
        final newState = economyState.copyWith(unlockedTitleIds: newUnlockedTitles);
        await _repository.updateEconomyState(uid, newState);
      }

      return newlyUnlocked;
    } catch (e) {
      throw Exception('Failed to check titles: ${e.toString()}');
    }
  }

  // Increment achievement count
  Future<void> incrementAchievement(String uid, String achievementKey, {int amount = 1}) async {
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

  // Award weekly goal bonus
  Future<void> awardWeeklyGoalBonus(String uid) async {
    try {
      await awardCoins(uid, AppConstants.weeklyGoalBonusCoins);
      await incrementAchievement(uid, AppConstants.achievementWeeklyGoal);
    } catch (e) {
      throw Exception('Failed to award weekly goal bonus: ${e.toString()}');
    }
  }
}
