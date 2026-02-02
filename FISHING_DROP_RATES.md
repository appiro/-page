# 🎣 釣り機能の排出率（ドロップ率）

## 📊 現在の排出率

### レアリティ別の排出率

| レアリティ | 確率 | 説明 |
|-----------|------|------|
| ⭐ レアリティ1 | **72%** | コモン（よく釣れる） |
| ⭐⭐ レアリティ2 | **22%** | アンコモン（たまに釣れる） |
| ⭐⭐⭐ レアリティ3 | **5%** | レア（めったに釣れない） |
| ⭐⭐⭐⭐ レアリティ4 | **1%** | 超レア（非常に稀） |

---

## 🎲 抽選ロジック

### 実装コード

```dart
// lib/services/fishing_service.dart

Fish _catchOneFish() {
  final roll = _random.nextInt(100); // 0-99の乱数
  
  int targetRarity;
  if (roll < 72) {           // 0-71 (72%)
    targetRarity = 1;
  } else if (roll < 94) {    // 72-93 (22%)
    targetRarity = 2;
  } else if (roll < 99) {    // 94-98 (5%)
    targetRarity = 3;
  } else {                   // 99 (1%)
    targetRarity = 4;
  }
  
  // 該当レアリティの魚からランダムに選択
  final candidates = Fish.allFishes.where((f) => f.rarity == targetRarity).toList();
  return candidates[_random.nextInt(candidates.length)];
}
```

### 抽選の流れ

1. **0-99の乱数を生成**
2. **レアリティを決定**
   - 0-71 → レアリティ1（72%）
   - 72-93 → レアリティ2（22%）
   - 94-98 → レアリティ3（5%）
   - 99 → レアリティ4（1%）
3. **該当レアリティの魚からランダムに1匹選択**

---

## 📈 期待値

### 100回釣った場合の期待値

| レアリティ | 期待出現回数 |
|-----------|-------------|
| レアリティ1 | 約72回 |
| レアリティ2 | 約22回 |
| レアリティ3 | 約5回 |
| レアリティ4 | 約1回 |

### 10連ガチャの場合

| レアリティ | 1回以上出る確率 |
|-----------|----------------|
| レアリティ1 | ほぼ100% |
| レアリティ2 | 約90% |
| レアリティ3 | 約40% |
| レアリティ4 | 約10% |

---

## 🐟 魚の種類

各レアリティの魚は `lib/models/fish.dart` で定義されています。

### レアリティ1（コモン）
- フナ
- コイ
- タナゴ
- メダカ
- など

### レアリティ2（アンコモン）
- ブラックバス
- ナマズ
- ウナギ
- など

### レアリティ3（レア）
- サケ
- マグロ
- カツオ
- など

### レアリティ4（超レア）
- リュウグウノツカイ
- シーラカンス
- など

---

## 🔧 排出率の調整方法

排出率を変更したい場合は、`lib/services/fishing_service.dart`の`_catchOneFish()`メソッドを編集してください。

### 例: レアリティ4の確率を2%にする

```dart
Fish _catchOneFish() {
  final roll = _random.nextInt(100);
  
  int targetRarity;
  if (roll < 68) {           // 68% (69% → 68%)
    targetRarity = 1;
  } else if (roll < 93) {    // 25% (変更なし)
    targetRarity = 2;
  } else if (roll < 98) {    // 5% (変更なし)
    targetRarity = 3;
  } else {                   // 2% (1% → 2%)
    targetRarity = 4;
  }
  
  // ...
}
```

### 例: レアリティ3の確率を10%にする

```dart
Fish _catchOneFish() {
  final roll = _random.nextInt(100);
  
  int targetRarity;
  if (roll < 64) {           // 64% (69% → 64%)
    targetRarity = 1;
  } else if (roll < 89) {    // 25% (変更なし)
    targetRarity = 2;
  } else if (roll < 99) {    // 10% (5% → 10%)
    targetRarity = 3;
  } else {                   // 1% (変更なし)
    targetRarity = 4;
  }
  
  // ...
}
```

---

## 💡 設計のポイント

### 1. 2段階抽選

1. **レアリティ抽選**: まずレアリティを決定
2. **魚抽選**: 該当レアリティの魚からランダムに選択

この方式により：
- レアリティごとの確率を簡単に調整できる
- 新しい魚を追加しても確率が変わらない
- 各レアリティ内で均等に抽選される

### 2. 確率の合計は100%

```
69% + 25% + 5% + 1% = 100%
```

確率の合計が100%になるように設定されています。

```
72% + 22% + 5% + 1% = 100%
```

### 3. 拡張性

新しいレアリティを追加する場合：

```dart
if (roll < 50) {
  targetRarity = 1;  // 50%
} else if (roll < 75) {
  targetRarity = 2;  // 25%
} else if (roll < 90) {
  targetRarity = 3;  // 15%
} else if (roll < 98) {
  targetRarity = 4;  // 8%
} else {
  targetRarity = 5;  // 2% (新レアリティ)
}
```

---

## 📝 関連ファイル

- `lib/services/fishing_service.dart` - 釣りロジック（排出率の設定）
- `lib/models/fish.dart` - 魚のデータ定義
- `lib/providers/economy_provider.dart` - 釣りの実行とチケット管理
- `lib/screens/fishing_screen.dart` - 釣り画面のUI

---

## 🎯 まとめ

現在の排出率:
- **レアリティ1**: 72% （コモン）← 3%増加
- **レアリティ2**: 22% （アンコモン）← 3%減少
- **レアリティ3**: 5% （レア）
- **レアリティ4**: 1% （超レア）

この設定により、適度な難易度でコレクションを楽しめるバランスになっています。
