import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/fish.dart';
import '../providers/economy_provider.dart';
import '../utils/constants.dart';

class FishCollectionScreen extends StatelessWidget {
  const FishCollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('魚図鑑'),
      ),
      body: Consumer<EconomyProvider>(
        builder: (context, provider, child) {
          // Group fish by rarity
          final allFish = Fish.allFishes;
          final groupedFish = <int, List<Fish>>{};
          
          for (var fish in allFish) {
            groupedFish.putIfAbsent(fish.rarity, () => []).add(fish);
          }
          
          // Sort rarities descending (4 -> 1)
          final sortedRarities = groupedFish.keys.toList()..sort((a, b) => b.compareTo(a));

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                sliver: SliverMainAxisGroup(
                  slivers: sortedRarities.map((rarity) {
                    final fishes = groupedFish[rarity]!;
                    return SliverMainAxisGroup(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                Text('レア度 ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                Row(
                                  children: List.generate(rarity, (i) => Icon(Icons.star, color: Colors.amber, size: 20)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverGrid(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.8,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final fish = fishes[index];
                              final count = provider.getFishCount(fish.id);
                              final isCaught = count > 0;

                              return Card(
                                elevation: isCaught ? 2 : 0,
                                color: isCaught ? Colors.white : Colors.grey[200],
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    if (isCaught) {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text(
                                            fish.name,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                height: 120,
                                                width: 120,
                                                child: Image.asset(
                                                  fish.imagePath,
                                                  fit: BoxFit.contain,
                                                  errorBuilder: (context, error, stackTrace) => 
                                                    const Icon(Icons.phishing, size: 60, color: Colors.blue),
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: List.generate(
                                                  fish.rarity,
                                                  (index) => const Icon(Icons.star, color: Colors.amber),
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              Text(
                                                fish.description,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(color: Colors.grey[600]),
                                              ),
                                              const SizedBox(height: 16),
                                              Text(
                                                '所持数: $count匹',
                                                style: const TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(),
                                              child: const Text('閉じる'),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        // Icon / Image
                                        Expanded(
                                          child: isCaught 
                                            ? Image.asset(
                                                fish.imagePath,
                                                errorBuilder: (context, error, stackTrace) => 
                                                  const Icon(Icons.phishing, size: 40, color: Colors.blue),
                                              )
                                            : const Icon(Icons.lock, size: 30, color: Colors.grey),
                                        ),
                                        const SizedBox(height: 8),
                                        
                                        // Name
                                        Text(
                                          isCaught ? fish.name : '???',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: isCaught ? Colors.black : Colors.grey[600],
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        
                                        const SizedBox(height: 4),
                                        // Count
                                        if (isCaught)
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.blue[50],
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              '${count}匹',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.blue[800],
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            childCount: fishes.length,
                          ),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 24)),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
