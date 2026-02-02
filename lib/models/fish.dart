class Fish {
  final String id;
  final String name;
  final int rarity; // 1 to 4
  final String description;
  final String imagePath; // Using imagePath to correspond to user provided filenames

  const Fish({
    required this.id,
    required this.name,
    required this.rarity,
    required this.description,
    required this.imagePath,
  });

  // Master Data
  static const List<Fish> allFishes = [
    // ★4 (3 types)
    Fish(id: 'shachi', name: 'シャチ', rarity: 4, description: '海の王者。', imagePath: 'assets/fish/shachi.png'),
    Fish(id: 'kaziki', name: 'カジキ', rarity: 4, description: '鋭いツノが特徴。', imagePath: 'assets/fish/kaziki.png'),
    Fish(id: 'guppi', name: 'グッピー', rarity: 4, description: 'なぜか超激レア。美しい尾びれ。', imagePath: 'assets/fish/guppi.png'),

    // ★3 (5 types)
    Fish(id: 'maguro', name: 'マグロ', rarity: 3, description: '止まると死ぬらしい。', imagePath: 'assets/fish/maguro.png'),
    Fish(id: 'kuzira', name: 'クジラ', rarity: 3, description: '哺乳類だけど魚扱い。', imagePath: 'assets/fish/kuzira.png'),
    Fish(id: 'kumanomi', name: 'クマノミ', rarity: 3, description: 'イソギンチャクと仲良し。', imagePath: 'assets/fish/kumanomi.png'),
    Fish(id: 'anko', name: 'アンコウ', rarity: 3, description: '深海の提灯持ち。', imagePath: 'assets/fish/anko.png'),
    Fish(id: 'otoshigo', name: 'タツノオトシゴ', rarity: 3, description: '竜の子。', imagePath: 'assets/fish/otoshigo.png'),

    // ★2 (10 types)
    Fish(id: 'ebi', name: 'エビ', rarity: 2, description: 'プリプリしている。', imagePath: 'assets/fish/ebi.png'),
    Fish(id: 'kani', name: 'カニ', rarity: 2, description: '横歩きが得意。', imagePath: 'assets/fish/kani.png'),
    Fish(id: 'tako', name: 'タコ', rarity: 2, description: '吸盤がすごい。', imagePath: 'assets/fish/tako.png'),
    Fish(id: 'unagi', name: 'ウナギ', rarity: 2, description: 'スタミナ満点。', imagePath: 'assets/fish/unagi.png'),
    Fish(id: 'harisenbom', name: 'ハリセンボン', rarity: 2, description: '怒ると膨らむ。', imagePath: 'assets/fish/harisenbom.png'),
    Fish(id: 'hamachi', name: 'ハマチ', rarity: 2, description: '出世魚。', imagePath: 'assets/fish/hamachi.png'),
    Fish(id: 'kawahagi', name: 'カワハギ', rarity: 2, description: '皮がすぐ剥げる。', imagePath: 'assets/fish/kawahagi.png'),
    Fish(id: 'enzerufish', name: 'エンゼルフィッシュ', rarity: 2, description: '熱帯魚の定番。', imagePath: 'assets/fish/enzerufish.png'),
    Fish(id: 'akamakigai', name: 'アカマキガイ', rarity: 2, description: '赤い巻貝。', imagePath: 'assets/fish/akamakigai.png'),
    Fish(id: 'uni', name: 'ウニ', rarity: 2, description: 'トゲトゲの中身は美味。', imagePath: 'assets/fish/uni.png'),

    // ★1 (26 types)
    Fish(id: 'azi', name: 'アジ', rarity: 1, description: 'フライにすると美味しい。', imagePath: 'assets/fish/azi.png'),
    Fish(id: 'sab', name: 'サバ', rarity: 1, description: '青魚の代表格。', imagePath: 'assets/fish/sab.png'),
    Fish(id: 'sanma', name: 'サンマ', rarity: 1, description: '秋の味覚。', imagePath: 'assets/fish/sanma.png'),
    Fish(id: 'iwashi', name: 'イワシ', rarity: 1, description: '群れで泳ぐ。', imagePath: 'assets/fish/iwashi.png'),
    Fish(id: 'sake', name: 'サケ', rarity: 1, description: '川に戻ってくる。', imagePath: 'assets/fish/sake.png'),
    Fish(id: 'katsuo', name: 'カツオ', rarity: 1, description: 'タタキがうまい。', imagePath: 'assets/fish/katsuo.png'),
    Fish(id: 'dojo', name: 'ドジョウ', rarity: 1, description: '泥の中にいる。', imagePath: 'assets/fish/dojo.png'),
    Fish(id: 'fish', name: 'サカナ', rarity: 1, description: '普通の魚。', imagePath: 'assets/fish/fish.png'),
    Fish(id: 'kingyo', name: 'キンギョ', rarity: 1, description: 'お祭りの定番。', imagePath: 'assets/fish/kingyo.png'),
    Fish(id: 'tobiuo', name: 'トビウオ', rarity: 1, description: '海を飛ぶ。', imagePath: 'assets/fish/tobiuo.png'),
    Fish(id: 'hirame', name: 'ヒラメ', rarity: 1, description: '左ヒラメ。', imagePath: 'assets/fish/hirame.png'),
    Fish(id: 'ishidai', name: 'イシダイ', rarity: 1, description: '縞模様が特徴。', imagePath: 'assets/fish/ishidai.png'),
    Fish(id: 'hotate', name: 'ホタテ', rarity: 1, description: '貝柱が大きい。', imagePath: 'assets/fish/hotate.png'),
    Fish(id: 'makigai', name: '巻貝', rarity: 1, description: 'くるくるしている。', imagePath: 'assets/fish/makigai.png'),
    Fish(id: 'nimaigai', name: '二枚貝', rarity: 1, description: 'パカパカする。', imagePath: 'assets/fish/nimaigai.png'),
    Fish(id: 'hitode1', name: 'ヒトデ(赤)', rarity: 1, description: '星の形。', imagePath: 'assets/fish/hitode1.png'),
    Fish(id: 'hitode2', name: 'ヒトデ(青)', rarity: 1, description: '星の形その2。', imagePath: 'assets/fish/hitode2.png'),
    Fish(id: 'kurage', name: 'クラゲ', rarity: 1, description: '刺されると痛い。', imagePath: 'assets/fish/kurage.png'),
    Fish(id: 'mambou', name: 'マンボウ', rarity: 1, description: 'のんびり屋。', imagePath: 'assets/fish/mambou.png'),
    Fish(id: 'nanyouhagi', name: 'ナンヨウハギ', rarity: 1, description: '忘れっぽいかも？', imagePath: 'assets/fish/nanyouhagi.png'),
    Fish(id: 'nishikigoi', name: 'ニシキゴイ', rarity: 1, description: '泳ぐ宝石。', imagePath: 'assets/fish/nishikigoi.png'),
    Fish(id: 'tai', name: 'タイ', rarity: 1, description: 'めでたい。', imagePath: 'assets/fish/tai.png'),
    Fish(id: 'kinmedai', name: 'キンメダイ', rarity: 1, description: '目が金色。', imagePath: 'assets/fish/kinmedai.png'),
    Fish(id: 'blackbus', name: 'ブラックバス', rarity: 1, description: 'ルアー釣りの対象。', imagePath: 'assets/fish/blackbus.png'),
    Fish(id: 'ika', name: 'イカ', rarity: 1, description: '足は10本。', imagePath: 'assets/fish/ika.png'),
    Fish(id: 'hugu', name: 'フグ', rarity: 1, description: '毒があるけど美味。', imagePath: 'assets/fish/hugu.png'),
  ];

  static Fish getById(String id) {
    return allFishes.firstWhere(
      (fish) => fish.id == id,
      orElse: () => const Fish(
        id: 'unknown', 
        name: '？？？', 
        rarity: 1, 
        description: '未知の魚', 
        imagePath: ''
      ),
    );
  }
}
