enum TitleRarity { common, rare, epic, legendary }

class Title {
  final String id;
  final String name;
  final String description;
  final String condition; // Human-readable unlock condition
  final String iconName; // For future icon support
  final TitleRarity rarity;
  final int? price; // If non-null, can be purchased with coins

  const Title({
    required this.id,
    required this.name,
    required this.description,
    required this.condition,
    this.iconName = 'trophy',
    this.rarity = TitleRarity.common,
    this.price,
  });

  bool get isPurchasable => price != null;

  // Define all available titles
  static List<Title> getAllTitles() {
    return [
      // --- Cycle / Consistency ---
      const Title(
        id: 'not_mikkabouzu',
        name: 'NOT三日坊主',
        description: '最初の1週間を乗り越えた',
        condition: '最初の週間目標を達成',
        iconName: 'flag',
        rarity: TitleRarity.common,
      ),
      const Title(
        id: 'consistency_power',
        name: '継続は力なり',
        description: '3週間連続で目標を達成中',
        condition: '3サイクル連続達成',
        iconName: 'run_circle',
        rarity: TitleRarity.common,
      ),
      const Title(
        id: 'life_part',
        name: '生活の一部',
        description: 'トレーニングが日常になった証',
        condition: '6サイクル連続達成',
        iconName: 'favorite',
        rarity: TitleRarity.rare,
      ),
      const Title(
        id: 'iron_man_streak',
        name: '鉄人',
        description: '雨の日も風の日も積み重ねた努力',
        condition: '12サイクル連続達成',
        iconName: 'fitness_center',
        rarity: TitleRarity.epic,
      ),

      // --- Workout Count ---
      const Title(
        id: 'first_log',
        name: '初ログ',
        description: '記念すべき第一歩',
        condition: '最初のワークアウトを記録',
        iconName: 'looks_one',
        rarity: TitleRarity.common,
      ),
      const Title(
        id: 'stack_10',
        name: '積み上げ10',
        description: '少しずつ身体が変わってくる頃',
        condition: '累計ワークアウト10回',
        iconName: 'looks_two',
        rarity: TitleRarity.common,
      ),
      const Title(
        id: 'stack_50',
        name: '積み上げ50',
        description: 'ジムの顔馴染みレベル',
        condition: '累計ワークアウト50回',
        iconName: 'filter_5',
        rarity: TitleRarity.common,
      ),
      const Title(
        id: 'stack_100',
        name: '積み上げ100',
        description: '100回の努力の結晶',
        condition: '累計ワークアウト100回',
        iconName: 'workspace_premium',
        rarity: TitleRarity.rare,
      ),
      const Title(
        id: 'routine_complete',
        name: 'ルーティン化完了',
        description: '息をするようにトレーニングする',
        condition: '累計ワークアウト300回',
        iconName: 'auto_awesome',
        rarity: TitleRarity.epic,
      ),

      // --- Volume ---
      const Title(
        id: 'pump_intro',
        name: 'パンプ入門',
        description: '確かな手応えを感じた日',
        condition: '1回の総負荷 5,000kg以上',
        iconName: 'fitness_center',
        rarity: TitleRarity.common,
      ),
      const Title(
        id: 'oikomi_expert',
        name: '追い込み上級',
        description: '限界を超えた先にある景色',
        condition: '1回の総負荷 10,000kg以上',
        iconName: 'flash_on',
        rarity: TitleRarity.rare,
      ),
      const Title(
        id: 'monster_routine',
        name: '怪物ルーティン',
        description: '人間を辞めつつある',
        condition: '1回の総負荷 20,000kg以上',
        iconName: 'local_fire_department',
        rarity: TitleRarity.epic,
      ),
      const Title(
        id: 'load_1_ton',
        name: '積載1トン',
        description: 'チリも積もれば山となる',
        condition: '累計総負荷 1,000,000kg',
        iconName: 'terrain',
        rarity: TitleRarity.rare,
      ),
      const Title(
        id: 'load_10_ton',
        name: '積載10トン',
        description: '大型トラックでも運べない努力',
        condition: '累計総負荷 10,000,000kg',
        iconName: 'diamond',
        rarity: TitleRarity.epic,
      ),

      // --- Quality ---
      const Title(
        id: 'planned',
        name: '計画通り',
        description: '過不足ない完璧なスケジュール管理',
        condition: '週目標回数と実施回数が完全一致',
        iconName: 'check_circle_outline',
        rarity: TitleRarity.rare,
      ),

      // --- Time/Duration ---
      const Title(
        id: '1_hour_training',
        name: '1時間の積み重ね',
        description: '時間こそ最も貴重な資源',
        condition: '累計トレーニング時間1時間',
        iconName: 'timer',
        rarity: TitleRarity.common,
      ),
      const Title(
        id: '10_hours_training',
        name: '10時間の努力',
        description: '継続は力なり',
        condition: '累計トレーニング時間10時間',
        iconName: 'timer_10',
        rarity: TitleRarity.common,
      ),
      const Title(
        id: '24_hours_training',
        name: '1日分の努力',
        description: '丸一日トレーニングに費やした猛者',
        condition: '累計トレーニング時間24時間',
        iconName: 'history',
        rarity: TitleRarity.rare,
      ),
      const Title(
        id: '100_hours_training',
        name: '100時間の境地',
        description: 'もはや住処はジム',
        condition: '累計トレーニング時間100時間',
        iconName: 'hourglass_full',
        rarity: TitleRarity.epic,
      ),

      // --- Purchased (Shop) ---
      const Title(
        id: 'serious_mode',
        name: '今日から本気',
        description: '形から入るのも重要',
        condition: 'ショップで購入',
        iconName: 'shopping_bag',
        rarity: TitleRarity.common,
        price: 500,
      ),
      const Title(
        id: 'protein_believer',
        name: 'プロテイン信者',
        description: 'No Protein, No Life',
        condition: 'ショップで購入',
        iconName: 'water_drop',
        rarity: TitleRarity.common,
        price: 1000,
      ),
      const Title(
        id: 'data_geek',
        name: 'データ厨',
        description: '数字は嘘をつかない',
        condition: 'ショップで購入',
        iconName: 'bar_chart',
        rarity: TitleRarity.rare,
        price: 3000,
      ),
      const Title(
        id: 'bodybuilder',
        name: 'ボディービルダー',
        description: '目指せ、頂点',
        condition: 'ショップで購入',
        iconName: 'emoji_events',
        rarity: TitleRarity.epic,
        price: 10000,
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
