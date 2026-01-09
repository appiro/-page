import 'package:cloud_firestore/cloud_firestore.dart';

class EconomyState {
  final int totalCoins;
  final String? equippedTitleId;
  final List<String> unlockedTitleIds;
  final List<String> purchasedItemIds;
  final Map<String, int> achievementCounts; // e.g., 'weeklyGoalAchieved': 5, 'totalWorkouts': 10

  EconomyState({
    this.totalCoins = 0,
    this.equippedTitleId,
    this.unlockedTitleIds = const [],
    this.purchasedItemIds = const [],
    this.achievementCounts = const {},
  });

  factory EconomyState.fromFirestore(DocumentSnapshot doc) {
    if (!doc.exists) {
      return EconomyState();
    }
    
    final data = doc.data() as Map<String, dynamic>;
    return EconomyState(
      totalCoins: data['totalCoins'] ?? 0,
      equippedTitleId: data['equippedTitleId'],
      unlockedTitleIds: List<String>.from(data['unlockedTitleIds'] ?? []),
      purchasedItemIds: List<String>.from(data['purchasedItemIds'] ?? []),
      achievementCounts: Map<String, int>.from(data['achievementCounts'] ?? {}),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'totalCoins': totalCoins,
      'equippedTitleId': equippedTitleId,
      'unlockedTitleIds': unlockedTitleIds,
      'purchasedItemIds': purchasedItemIds,
      'achievementCounts': achievementCounts,
    };
  }

  EconomyState copyWith({
    int? totalCoins,
    String? equippedTitleId,
    bool clearEquippedTitle = false,
    List<String>? unlockedTitleIds,
    List<String>? purchasedItemIds,
    Map<String, int>? achievementCounts,
  }) {
    return EconomyState(
      totalCoins: totalCoins ?? this.totalCoins,
      equippedTitleId: clearEquippedTitle ? null : (equippedTitleId ?? this.equippedTitleId),
      unlockedTitleIds: unlockedTitleIds ?? this.unlockedTitleIds,
      purchasedItemIds: purchasedItemIds ?? this.purchasedItemIds,
      achievementCounts: achievementCounts ?? this.achievementCounts,
    );
  }

  // Helper methods
  bool isTitleUnlocked(String titleId) {
    return unlockedTitleIds.contains(titleId);
  }

  bool isItemPurchased(String itemId) {
    return purchasedItemIds.contains(itemId);
  }

  int getAchievementCount(String achievementKey) {
    return achievementCounts[achievementKey] ?? 0;
  }
}
