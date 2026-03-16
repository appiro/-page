import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/fishing_item.dart';
import '../providers/economy_provider.dart';
import '../utils/constants.dart';

class FishingShopScreen extends StatelessWidget {
  const FishingShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final economyProvider = context.watch<EconomyProvider>();
    final state = economyProvider.economyState;
    final totalCoins = state.totalCoins;

    return Scaffold(
      appBar: AppBar(
        title: const Text('釣具屋'),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.amber),
            ),
            child: Row(
              children: [
                const Icon(Icons.monetization_on, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text(
                  '$totalCoins',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCategoryHeader(context, '🎣 釣り竿', 'レアな魚が釣れやすくなります！'),
          ...FishingItem.getByType(FishingItemType.rod).map(
            (item) => _buildShopItemCard(context, item, economyProvider),
          ),
          const SizedBox(height: 24),
          
          _buildCategoryHeader(context, '🐟 撒き餌', '特定の魚をおびき寄せます！'),
          ...FishingItem.getByType(FishingItemType.bait).map(
            (item) => _buildShopItemCard(context, item, economyProvider),
          ),
          const SizedBox(height: 24),
          
          _buildCategoryHeader(context, '✨ 特殊・チケット', '釣りを有利に進めるアイテム！'),
          ...FishingItem.getByType(FishingItemType.charm).map(
            (item) => _buildShopItemCard(context, item, economyProvider),
          ),
          ...FishingItem.getByType(FishingItemType.ticket).map(
            (item) => _buildShopItemCard(context, item, economyProvider),
          ),
          ...FishingItem.getByType(FishingItemType.special).map(
            (item) => _buildShopItemCard(context, item, economyProvider),
          ),
          
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(BuildContext context, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppConstants.primaryColor,
            ),
          ),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildShopItemCard(BuildContext context, FishingItem item, EconomyProvider provider) {
    final canAfford = provider.economyState.totalCoins >= item.price;
    final ownedCount = provider.economyState.inventory
        .where((inv) => inv.itemId == item.id)
        .fold(0, (sum, inv) => sum + inv.remainingUses);
    
    // Check if rod is already owned (for warning/badge)
    final bool isRodOwned = item.type == FishingItemType.rod && ownedCount > 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  item.iconEmoji,
                  style: const TextStyle(fontSize: 32),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  if (ownedCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item.durability > 0 ? '所持: $ownedCount回分' : '購入済み',
                        style: TextStyle(fontSize: 10, color: Colors.green.shade800),
                      ),
                    ),
                  if (item.type == FishingItemType.rod && isRodOwned)
                     Padding(
                       padding: const EdgeInsets.only(top: 4.0),
                       child: Text(
                         '※既に所持しています',
                         style: TextStyle(fontSize: 10, color: Colors.orange.shade800),
                       ),
                     ),
                ],
              ),
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: canAfford
                      ? () => _confirmPurchase(context, item, provider)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    disabledBackgroundColor: Colors.grey[300],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('購入', style: TextStyle(fontSize: 12)),
                      Text(
                        '${item.price} G',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmPurchase(BuildContext context, FishingItem item, EconomyProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${item.name}を購入'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('価格: ${item.price} コイン'),
            const SizedBox(height: 8),
            Text(item.description),
            const SizedBox(height: 16),
            const Text('本当に購入しますか？'),
            if (item.type == FishingItemType.rod)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  '※新しい釣り竿を購入すると、自動的に装備されます。',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              
              try {
                await provider.purchaseFishingItem(item);
                if (context.mounted) {
                   if (provider.errorMessage != null) {
                     ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(content: Text(provider.errorMessage!)),
                     );
                     provider.clearError();
                   } else {
                     ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(
                         content: Text('${item.name}を購入しました！'),
                         backgroundColor: Colors.green,
                       ),
                     );
                   }
                }
              } catch (e) {
                // Error handled in provider
              }
            },
            child: const Text('購入する'),
          ),
        ],
      ),
    );
  }
}
