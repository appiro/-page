import 'dart:math';
import '../models/fish.dart';

class FishingService {
  final Random _random = Random();

  // Award tickets (just returns the new amount? No, state is managed by provider/repo, 
  // so specific logic usually resides there. 
  // But fishing mechanics (RNG) should be here).

  // Cast line and catch fish
  // Returns a list of caught fish based on number of casts and active effects
  List<Fish> fish(int times, Map<String, dynamic> effects) {
    List<Fish> caughtFish = [];
    
    // 魚群探知機の効果: EconomyProvider側で制御するため、ここではtimesを上書きしない
    // if (effects['guaranteed10'] == true) {
    //   times = 10;
    // }

    for (int i = 0; i < times; i++) {
      caughtFish.add(_catchOneFish(effects));
    }
    
    return caughtFish;
  }

  Fish _catchOneFish(Map<String, dynamic> effects) {
    // 黄金の餌の効果: レア4確定
    if (effects['guaranteedRarity4'] == true) {
      final candidates = Fish.allFishes.where((f) => f.rarity == 4).toList();
      if (candidates.isNotEmpty) {
        return candidates[_random.nextInt(candidates.length)];
      }
    }

    // アイテム効果の取得
    final double rarityBoost = (effects['rarityBoost'] as num?)?.toDouble() ?? 0.0;
    final int? targetRarity = effects['targetRarity'] as int?;
    final int targetBoost = (effects['targetBoost'] as int?) ?? 0;
    final double newFishBoost = (effects['newFishBoost'] as num?)?.toDouble() ?? 0.0;

    // 基本確率（+ 釣り竿のブースト）
    // Rarity 1: 72%
    // Rarity 2: 22%
    // Rarity 3: 5% + boost
    // Rarity 4: 1% + boost
    
    // ブースト分をレア1/2から引いて、レア3/4に足す簡易ロジック
    // レア3と4への配分比率
    final boostToRarity3 = rarityBoost * 0.8;
    final boostToRarity4 = rarityBoost * 0.2;

    double r1Threshold = 72;
    double r2Threshold = 94; // 72+22

    // 高レア確率を増やす
    // ※ 厳密な計算より、ゲーム的な面白さを優先した簡易計算
    // レア4の閾値を下げる（100 - (1 + boost)）
    // レア3の閾値を下げる（レア4閾値 - (5 + boost)）
    
    double r4Chance = 1.0 + boostToRarity4;
    double r3Chance = 5.0 + boostToRarity3;
    
    // 撒き餌効果（特定レアリティの確率アップ）
    if (targetRarity == 1) r1Threshold += targetBoost; // 実質他が減るわけではないが、判定順序的に有利になるかも？
    // シンプルに乱数判定の閾値を調整する
    
    final roll = _random.nextInt(100);
    
    // 撒き餌による特定レアリティ判定（優先的にチェック）
    if (targetRarity != null) {
      // ターゲットのレアリティが当選するかチェック（boost %）
      // 例: targetBoost=10 なら 10% の確率で強制的にそのレアリティになる
      if (_random.nextInt(100) < targetBoost) {
        final candidates = Fish.allFishes.where((f) => f.rarity == targetRarity).toList();
        if (candidates.isNotEmpty) {
          return candidates[_random.nextInt(candidates.length)];
        }
      }
    }

    // 通常のレアリティ判定（ブースト込み）
    int resultRarity;
    
    // 上から判定（レア4 -> レア3 -> ...）することでブーストを反映しやすくする
    if (roll < r4Chance) { // 例: ブースト25%なら 1 + 5 = 6%
      resultRarity = 4;
    } else if (roll < r4Chance + r3Chance) { // 例: 6 + (5 + 20) = 31%
      resultRarity = 3;
    } else if (roll < r4Chance + r3Chance + 22) { // 残りを配分
      resultRarity = 2;
    } else {
      resultRarity = 1;
    }

    // 該当レアリティの魚候補
    var candidates = Fish.allFishes.where((f) => f.rarity == resultRarity).toList();
    if (candidates.isEmpty) {
      candidates = Fish.allFishes.where((f) => f.rarity == 1).toList();
    }
    
    // お守り効果（未入手が出やすい）
    if (newFishBoost > 0) {
      // TODO: ここで未入手判定をするにはユーザーの所持状況が必要だが、
      // Serviceはステートレスにするため、ここでは簡易的に実装するか、
      // 呼び出し元でフィルタリングするなど検討が必要。
      // いったん「ランダムに選ぶ」処理を少し偏らせる（未実装）
    }

    return candidates[_random.nextInt(candidates.length)];
  }
}
