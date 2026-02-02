import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_inventory.dart';

class EconomyState {
  final int totalCoins;
  final int fishingTickets;
  final String? equippedTitleId;
  final List<String> unlockedTitleIds;
  final List<String> purchasedItemIds;
  final Map<String, int> achievementCounts;
  final Map<String, int> fishCollection;
  final List<UserInventory> inventory; // 釣りアイテムのインベントリ

  EconomyState({
    this.totalCoins = 0,
    this.fishingTickets = 0,
    this.equippedTitleId,
    this.unlockedTitleIds = const [],
    this.purchasedItemIds = const [],
    this.achievementCounts = const {},
    this.fishCollection = const {},
    this.inventory = const [],
  });

  factory EconomyState.fromFirestore(DocumentSnapshot doc) {
    if (!doc.exists) {
      return EconomyState();
    }
    
    final data = doc.data() as Map<String, dynamic>;
    
    // インベントリのパース
    List<UserInventory> inventory = [];
    if (data['inventory'] != null) {
      final inventoryData = data['inventory'] as List<dynamic>;
      inventory = inventoryData
          .map((item) => UserInventory.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    
    return EconomyState(
      totalCoins: data['totalCoins'] ?? 0,
      fishingTickets: data['fishingTickets'] ?? 0,
      equippedTitleId: data['equippedTitleId'],
      unlockedTitleIds: List<String>.from(data['unlockedTitleIds'] ?? []),
      purchasedItemIds: List<String>.from(data['purchasedItemIds'] ?? []),
      achievementCounts: Map<String, int>.from(data['achievementCounts'] ?? {}),
      fishCollection: Map<String, int>.from(data['fishCollection'] ?? {}),
      inventory: inventory,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'totalCoins': totalCoins,
      'fishingTickets': fishingTickets,
      'equippedTitleId': equippedTitleId,
      'unlockedTitleIds': unlockedTitleIds,
      'purchasedItemIds': purchasedItemIds,
      'achievementCounts': achievementCounts,
      'fishCollection': fishCollection,
      'inventory': inventory.map((item) => item.toJson()).toList(),
    };
  }

  EconomyState copyWith({
    int? totalCoins,
    int? fishingTickets,
    String? equippedTitleId,
    bool clearEquippedTitle = false,
    List<String>? unlockedTitleIds,
    List<String>? purchasedItemIds,
    Map<String, int>? achievementCounts,
    Map<String, int>? fishCollection,
    List<UserInventory>? inventory,
  }) {
    return EconomyState(
      totalCoins: totalCoins ?? this.totalCoins,
      fishingTickets: fishingTickets ?? this.fishingTickets,
      equippedTitleId: clearEquippedTitle ? null : (equippedTitleId ?? this.equippedTitleId),
      unlockedTitleIds: unlockedTitleIds ?? this.unlockedTitleIds,
      purchasedItemIds: purchasedItemIds ?? this.purchasedItemIds,
      achievementCounts: achievementCounts ?? this.achievementCounts,
      fishCollection: fishCollection ?? this.fishCollection,
      inventory: inventory ?? this.inventory,
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
