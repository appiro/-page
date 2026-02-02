import '../models/fishing_item.dart';
import '../models/user_inventory.dart';

class FishingShopService {
  // アイテム購入
  PurchaseResult purchaseItem(
    FishingItem item,
    int currentCoins,
    List<UserInventory> currentInventory,
  ) {
    // コイン不足チェック
    if (currentCoins < item.price) {
      return PurchaseResult(
        success: false,
        message: 'コインが足りません',
      );
    }

    // チケットアイテムの場合は即座に適用
    if (item.type == FishingItemType.ticket) {
      return PurchaseResult(
        success: true,
        message: '${item.name}を購入しました',
        newCoins: currentCoins - item.price,
        ticketsToAdd: item.effects['tickets'] as int,
      );
    }

    // 釣り竿の場合、既に装備中の竿があるかチェック
    if (item.type == FishingItemType.rod) {
      final hasEquippedRod = currentInventory.any(
        (inv) {
          final invItem = FishingItem.getById(inv.itemId);
          return invItem?.type == FishingItemType.rod && inv.isEquipped;
        },
      );
      
      if (hasEquippedRod) {
        return PurchaseResult(
          success: false,
          message: '既に釣り竿を装備しています。先に装備を解除してください。',
        );
      }
    }

    // インベントリに追加
    final newInventoryItem = UserInventory(
      itemId: item.id,
      remainingUses: item.durability,
      acquiredAt: DateTime.now(),
      isEquipped: item.type == FishingItemType.rod, // 釣り竿は自動装備
    );

    return PurchaseResult(
      success: true,
      message: '${item.name}を購入しました',
      newCoins: currentCoins - item.price,
      newInventoryItem: newInventoryItem,
    );
  }

  // アイテム使用
  UseItemResult useItem(
    UserInventory inventoryItem,
    FishingItem item,
  ) {
    if (inventoryItem.remainingUses <= 0) {
      return UseItemResult(
        success: false,
        message: 'このアイテムは使い切りました',
      );
    }

    // 使用回数を減らす
    final updatedInventory = inventoryItem.copyWith(
      remainingUses: inventoryItem.remainingUses - 1,
    );

    return UseItemResult(
      success: true,
      message: '${item.name}を使用しました',
      updatedInventory: updatedInventory,
      shouldRemove: updatedInventory.remainingUses <= 0,
    );
  }

  // アイテムを装備（釣り竿または消費アイテム）
  EquipResult equipItem(
    UserInventory itemToEquip,
    List<UserInventory> currentInventory,
  ) {
    final item = FishingItem.getById(itemToEquip.itemId);
    if (item == null) {
      return EquipResult(success: false, message: 'アイテムが見つかりません');
    }

    // 装備不可のアイテムタイプ
    if (item.type == FishingItemType.ticket || item.type == FishingItemType.special) { 
      // specialのうち、消費型(guaranteed10など)は装備して使うものとするか、
      // あるいは「使用」して効果を発動するか。
      // リクエストによると「黄金の餌」も装備対象なので、これも装備可能にする。
      // 基本的に ticket 以外は装備可能とする。
      if (item.type == FishingItemType.ticket) {
        return EquipResult(success: false, message: 'このアイテムは装備できません');
      }
    }

    // 更新後のインベントリを作成
    final updatedInventory = currentInventory.map((inv) {
      final invItem = FishingItem.getById(inv.itemId);
      if (invItem == null) return inv;

      // 1. 同じカテゴリ（釣り竿通し、消費アイテム通し）の既存装備を解除
      // 釣り竿なら他の釣り竿を解除
      if (item.type == FishingItemType.rod && invItem.type == FishingItemType.rod) {
        return inv.copyWith(isEquipped: inv.itemId == itemToEquip.itemId);
      }
      
      // 消費アイテム（餌、お守り、特殊）なら、他の消費アイテムを解除
      // 釣り竿以外の装備可能アイテムは「消費アイテム枠」としてひとまとめにする
      if (item.type != FishingItemType.rod && invItem.type != FishingItemType.rod) {
         // IDが一致するものだけ装備、他は解除
         return inv.copyWith(isEquipped: inv.itemId == itemToEquip.itemId);
      }

      // カテゴリが違うものは触らない（竿と餌は共存可能）
      return inv;
    }).toList();

    return EquipResult(
      success: true,
      message: '${item.name}を装備しました',
      updatedInventory: updatedInventory,
    );
  }

  // 装備解除
  EquipResult unequipItem(
    UserInventory itemToUnequip,
    List<UserInventory> currentInventory,
  ) {
    final updatedInventory = currentInventory.map((inv) {
      if (inv.itemId == itemToUnequip.itemId) {
        return inv.copyWith(isEquipped: false);
      }
      return inv;
    }).toList();

    return EquipResult(
      success: true,
      message: '装備を解除しました',
      updatedInventory: updatedInventory,
    );
  }

  // 装備中のアイテムを取得（指定タイプ）
  UserInventory? getEquippedItem(List<UserInventory> inventory, FishingItemType type) {
    try {
      return inventory.firstWhere((inv) {
        final item = FishingItem.getById(inv.itemId);
        return item?.type == type && inv.isEquipped;
      });
    } catch (e) {
      return null;
    }
  }

  // 装備中の消費アイテムを取得（竿以外）
  UserInventory? getEquippedConsumable(List<UserInventory> inventory) {
    try {
      return inventory.firstWhere((inv) {
        final item = FishingItem.getById(inv.itemId);
        return item != null && item.type != FishingItemType.rod && inv.isEquipped;
      });
    } catch (e) {
      return null;
    }
  }

  // アイテムの効果を取得
  Map<String, dynamic> getActiveEffects(List<UserInventory> inventory) {
    final effects = <String, dynamic>{
      'rarityBoost': 0,
      'targetRarity': null,
      'targetBoost': 0,
      'newFishBoost': 0,
      'guaranteed10': false,
      'guaranteedRarity4': false,
    };

    for (final inv in inventory) {
      if (inv.remainingUses <= 0) continue;

      final item = FishingItem.getById(inv.itemId);
      if (item == null) continue;

      // 装備中でないと効果を発揮しない
      if (!inv.isEquipped) continue;

      // 釣り竿の効果
      if (item.type == FishingItemType.rod) {
        effects['rarityBoost'] = item.effects['rarityBoost'] ?? 0;
      }

      // 撒き餌の効果
      if (item.type == FishingItemType.bait) {
        effects['targetRarity'] = item.effects['targetRarity'];
        effects['targetBoost'] = item.effects['boost'];
      }

      // お守りの効果
      if (item.type == FishingItemType.charm) {
        effects['newFishBoost'] = item.effects['newFishBoost'] ?? 0;
      }

      // 特殊アイテムの効果
      if (item.type == FishingItemType.special) {
        if (item.effects['guaranteed10'] == true) {
          effects['guaranteed10'] = true;
        }
        if (item.effects['guaranteedRarity4'] == true) {
          effects['guaranteedRarity4'] = true;
        }
      }
    }

    return effects;
  }
}

// 購入結果
class PurchaseResult {
  final bool success;
  final String message;
  final int? newCoins;
  final UserInventory? newInventoryItem;
  final int? ticketsToAdd;

  PurchaseResult({
    required this.success,
    required this.message,
    this.newCoins,
    this.newInventoryItem,
    this.ticketsToAdd,
  });
}

// 使用結果
class UseItemResult {
  final bool success;
  final String message;
  final UserInventory? updatedInventory;
  final bool shouldRemove;

  UseItemResult({
    required this.success,
    required this.message,
    this.updatedInventory,
    this.shouldRemove = false,
  });
}

// 装備結果
class EquipResult {
  final bool success;
  final String message;
  final List<UserInventory>? updatedInventory;

  EquipResult({
    required this.success,
    required this.message,
    this.updatedInventory,
  });
}
