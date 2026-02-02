class ShopItem {
  final String id;
  final String name;
  final String description;
  final int price;
  final String category; // 'badge', 'equipment', 'title', 'theme'
  final String iconName;

  const ShopItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.iconName = 'shopping_bag',
  });

  // Define all shop items
  static const List<ShopItem> allItems = [
      // Badges
      ShopItem(
        id: 'bronze_badge',
        name: 'Bronze Badge',
        description: 'A shiny bronze badge',
        price: 50,
        category: 'badge',
        iconName: 'badge',
      ),
      ShopItem(
        id: 'silver_badge',
        name: 'Silver Badge',
        description: 'A prestigious silver badge',
        price: 150,
        category: 'badge',
        iconName: 'badge',
      ),
      ShopItem(
        id: 'gold_badge',
        name: 'Gold Badge',
        description: 'An elite gold badge',
        price: 300,
        category: 'badge',
        iconName: 'badge',
      ),
      
      // Equipment (cosmetic only)
      ShopItem(
        id: 'lifting_belt',
        name: 'Lifting Belt',
        description: 'Professional lifting belt icon',
        price: 100,
        category: 'equipment',
        iconName: 'fitness_center',
      ),
      ShopItem(
        id: 'wrist_wraps',
        name: 'Wrist Wraps',
        description: 'Support wrist wraps icon',
        price: 75,
        category: 'equipment',
        iconName: 'sports',
      ),
      ShopItem(
        id: 'knee_sleeves',
        name: 'Knee Sleeves',
        description: 'Protective knee sleeves icon',
        price: 120,
        category: 'equipment',
        iconName: 'accessibility',
      ),
      
      // Special Titles
      ShopItem(
        id: 'beast_mode_title',
        name: 'Beast Mode',
        description: 'Unleash your inner beast',
        price: 200,
        category: 'title',
        iconName: 'pets',
      ),
      ShopItem(
        id: 'champion_title',
        name: 'Champion',
        description: 'For true champions',
        price: 500,
        category: 'title',
        iconName: 'emoji_events',
      ),
      ShopItem(
        id: 'legend_title',
        name: 'Legend',
        description: 'Legendary status',
        price: 1000,
        category: 'title',
        iconName: 'stars',
      ),
  ];

  static List<ShopItem> getAllItems() => allItems;

  static ShopItem? getItemById(String id) {
    try {
      return getAllItems().firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<ShopItem> getItemsByCategory(String category) {
    return getAllItems().where((item) => item.category == category).toList();
  }
}
