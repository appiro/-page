class Title {
  final String id;
  final String name;
  final String description;
  final String condition; // Human-readable unlock condition
  final String iconName; // For future icon support

  const Title({
    required this.id,
    required this.name,
    required this.description,
    required this.condition,
    this.iconName = 'trophy',
  });

  // Define all available titles
  static List<Title> getAllTitles() {
    return [
      const Title(
        id: 'first_step',
        name: 'First Step',
        description: 'Complete your first workout',
        condition: 'Complete 1 workout',
        iconName: 'star',
      ),
      const Title(
        id: 'consistent',
        name: 'Consistent',
        description: 'Achieve your weekly goal',
        condition: 'Achieve weekly goal 1 time',
        iconName: 'check_circle',
      ),
      const Title(
        id: 'dedicated',
        name: 'Dedicated',
        description: 'Keep hitting your weekly goals',
        condition: 'Achieve weekly goal 3 times',
        iconName: 'favorite',
      ),
      const Title(
        id: 'iron_will',
        name: 'Iron Will',
        description: 'Master of consistency',
        condition: 'Achieve weekly goal 10 times',
        iconName: 'military_tech',
      ),
      const Title(
        id: 'coin_collector',
        name: 'Coin Collector',
        description: 'Accumulate significant coins',
        condition: 'Earn 1000 total coins',
        iconName: 'monetization_on',
      ),
      const Title(
        id: 'wealthy',
        name: 'Wealthy',
        description: 'Master of gains',
        condition: 'Earn 5000 total coins',
        iconName: 'diamond',
      ),
      const Title(
        id: 'beginner',
        name: 'Beginner',
        description: 'Complete 5 workouts',
        condition: 'Complete 5 workouts',
        iconName: 'emoji_events',
      ),
      const Title(
        id: 'intermediate',
        name: 'Intermediate',
        description: 'Complete 25 workouts',
        condition: 'Complete 25 workouts',
        iconName: 'workspace_premium',
      ),
      const Title(
        id: 'advanced',
        name: 'Advanced',
        description: 'Complete 100 workouts',
        condition: 'Complete 100 workouts',
        iconName: 'stars',
      ),
    ];
  }

  static Title? getTitleById(String id) {
    try {
      return getAllTitles().firstWhere((title) => title.id == id);
    } catch (e) {
      return null;
    }
  }
}
