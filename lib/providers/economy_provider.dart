import 'package:flutter/foundation.dart';
import '../models/economy_state.dart';
import '../models/title.dart';
import '../models/shop_item.dart';
import '../models/user_profile.dart';
import '../repositories/fit_repository.dart';
import '../services/economy_service.dart';
import '../utils/date_helper.dart';

class EconomyProvider with ChangeNotifier {
  final FitRepository _repository;
  final EconomyService _economyService;
  final String uid;

  EconomyState _economyState = EconomyState();
  UserProfile? _userProfile;
  bool _isLoading = false;
  String? _errorMessage;
  bool _weeklyGoalAchieved = false;

  EconomyProvider({
    required FitRepository repository,
    required EconomyService economyService,
    required this.uid,
  })  : _repository = repository,
        _economyService = economyService {
    _loadData();
  }

  EconomyState get economyState => _economyState;
  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get weeklyGoalAchieved => _weeklyGoalAchieved;

  int get totalCoins => _economyState.totalCoins;
  String? get equippedTitleId => _economyState.equippedTitleId;
  List<String> get unlockedTitleIds => _economyState.unlockedTitleIds;
  List<String> get purchasedItemIds => _economyState.purchasedItemIds;

  // Load economy state and user profile
  Future<void> _loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Load user profile
      _userProfile = await _repository.getUserProfile(uid);

      // Listen to economy state stream
      _repository.getEconomyStateStream(uid).listen(
        (state) {
          _economyState = state;
          notifyListeners();
        },
        onError: (error) {
          debugPrint('Economy state stream error: $error');
        },
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // ==================== Weekly Goal ====================

  Future<void> checkWeeklyGoal() async {
    // If running with local repo, userProfile might be dummy default. ensure weekly goal is set.
    final goal = _userProfile?.weeklyGoal ?? 3;
    final weekStartsOn = _userProfile?.weekStartsOn ?? 'mon';

    try {
      // Get current week date keys
      final weekDateKeys = DateHelper.getCurrentWeekDateKeys(
        weekStartsOn,
      );

      // Get workouts for this week
      final workouts = await _repository.getWorkoutsForWeek(uid, weekDateKeys);

      // Check if goal is achieved
      final workoutCount = workouts.length;
      final goalAchieved = workoutCount >= goal;

      // If goal just achieved and not yet awarded
      if (goalAchieved && !_weeklyGoalAchieved) {
        _weeklyGoalAchieved = true;
        
        // Award bonus (this will also increment achievement count)
        await _economyService.awardWeeklyGoalBonus(uid);
        
        // Check for title unlocks
        await _economyService.checkAndUnlockTitles(uid);
        
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<int> getWeeklyWorkoutCount() async {
    final weekStartsOn = _userProfile?.weekStartsOn ?? 'mon';

    try {
      final weekDateKeys = DateHelper.getCurrentWeekDateKeys(
        weekStartsOn,
      );
      final workouts = await _repository.getWorkoutsForWeek(uid, weekDateKeys);
      return workouts.length;
    } catch (e) {
      return 0;
    }
  }

  // ==================== Shop ====================

  Future<bool> purchaseItem(String itemId) async {
    try {
      await _economyService.purchaseItem(uid, itemId);
      
      // Check for title unlocks after purchase
      await _economyService.checkAndUnlockTitles(uid);
      
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  bool canPurchaseItem(String itemId) {
    final item = ShopItem.getItemById(itemId);
    if (item == null) return false;
    
    return !_economyState.isItemPurchased(itemId) && 
           _economyState.totalCoins >= item.price;
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

  // ==================== Settings ====================

  Future<void> updateSettings(Map<String, dynamic> settings) async {
    try {
      await _repository.updateUserProfile(uid, settings);
      
      // Reload user profile
      _userProfile = await _repository.getUserProfile(uid);
      notifyListeners();
    } catch (e) {
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
}
