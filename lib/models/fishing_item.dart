enum FishingItemType {
  rod,      // 釣り竿
  bait,     // 撒き餌
  charm,    // お守り
  ticket,   // チケット
  special,  // 特殊アイテム
}

class FishingItem {
  final String id;
  final String name;
  final String description;
  final int price;
  final FishingItemType type;
  final int durability; // 使用回数（0 = 無限）
  final Map<String, dynamic> effects; // 効果データ
  final String iconEmoji;

  const FishingItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.type,
    required this.durability,
    required this.effects,
    required this.iconEmoji,
  });

  // マスターデータ
  static const List<FishingItem> allItems = [
    // 釣り竿
    FishingItem(
      id: 'rod_bamboo',
      name: '竹の釣り竿',
      description: '初心者向けの安価な釣り竿',
      price: 50,
      type: FishingItemType.rod,
      durability: 10,
      effects: {'rarityBoost': 5},
      iconEmoji: '🎣',
    ),
    FishingItem(
      id: 'rod_carbon',
      name: 'カーボン竿',
      description: '軽量で扱いやすい中級者向け',
      price: 150,
      type: FishingItemType.rod,
      durability: 20,
      effects: {'rarityBoost': 10},
      iconEmoji: '🎣',
    ),
    FishingItem(
      id: 'rod_pro',
      name: 'プロ仕様竿',
      description: 'プロ仕様の高性能釣り竿',
      price: 300,
      type: FishingItemType.rod,
      durability: 30,
      effects: {'rarityBoost': 15},
      iconEmoji: '🎣',
    ),
    FishingItem(
      id: 'rod_legend',
      name: '伝説の竿',
      description: '伝説の釣り師が使った最高級品',
      price: 500,
      type: FishingItemType.rod,
      durability: 50,
      effects: {'rarityBoost': 25},
      iconEmoji: '✨',
    ),

    // 撒き餌
    FishingItem(
      id: 'bait_bread',
      name: 'パンくず',
      description: '小魚が好む餌',
      price: 30,
      type: FishingItemType.bait,
      durability: 5,
      effects: {'targetRarity': 1, 'boost': 10},
      iconEmoji: '🍞',
    ),
    FishingItem(
      id: 'bait_worm',
      name: 'ミミズ',
      description: '中型魚が好む餌',
      price: 50,
      type: FishingItemType.bait,
      durability: 5,
      effects: {'targetRarity': 2, 'boost': 10},
      iconEmoji: '🪱',
    ),
    FishingItem(
      id: 'bait_sardine',
      name: 'イワシ',
      description: '大型魚が好む餌',
      price: 100,
      type: FishingItemType.bait,
      durability: 5,
      effects: {'targetRarity': 3, 'boost': 10},
      iconEmoji: '🐟',
    ),
    FishingItem(
      id: 'bait_lure',
      name: '特製ルアー',
      description: '超レア魚を引き寄せる',
      price: 200,
      type: FishingItemType.bait,
      durability: 5,
      effects: {'targetRarity': 4, 'boost': 15},
      iconEmoji: '🎣',
    ),

    // 特殊アイテム
    FishingItem(
      id: 'charm_lucky',
      name: '幸運のお守り',
      description: '未入手の魚が出やすくなる',
      price: 100,
      type: FishingItemType.charm,
      durability: 10,
      effects: {'newFishBoost': 20},
      iconEmoji: '🍀',
    ),
    FishingItem(
      id: 'ticket_5',
      name: '釣りチケット×5',
      description: '釣りチケットを5枚購入',
      price: 80,
      type: FishingItemType.ticket,
      durability: 0,
      effects: {'tickets': 5},
      iconEmoji: '🎫',
    ),
    FishingItem(
      id: 'ticket_10',
      name: '釣りチケット×10',
      description: '釣りチケットを10枚購入（お得）',
      price: 150,
      type: FishingItemType.ticket,
      durability: 0,
      effects: {'tickets': 10},
      iconEmoji: '🎫',
    ),
    FishingItem(
      id: 'special_sonar',
      name: '魚群探知機',
      description: '次の釣りで必ず10匹釣れる',
      price: 250,
      type: FishingItemType.special,
      durability: 3,
      effects: {'guaranteed10': true},
      iconEmoji: '📡',
    ),
    FishingItem(
      id: 'special_golden',
      name: '黄金の餌',
      description: '次の釣りで必ずレア4が釣れる',
      price: 500,
      type: FishingItemType.special,
      durability: 1,
      effects: {'guaranteedRarity4': true},
      iconEmoji: '✨',
    ),
  ];

  static FishingItem? getById(String id) {
    try {
      return allItems.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<FishingItem> getByType(FishingItemType type) {
    return allItems.where((item) => item.type == type).toList();
  }
}
