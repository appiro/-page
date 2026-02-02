import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/economy_provider.dart';
import '../models/title.dart'
    as app_models; // Alias to avoid conflict with standard Title widget if any
import '../utils/constants.dart';

class TitlesScreen extends StatefulWidget {
  const TitlesScreen({super.key});

  @override
  State<TitlesScreen> createState() => _TitlesScreenState();
}

class _TitlesScreenState extends State<TitlesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<EconomyProvider>();
      if (!provider.isLoading && provider.userProfile != null) {
        if (!provider.userProfile!.seenTutorials.contains('titles')) {
          _showTitlesTutorial(context, provider);
        }
      }
    });
  }

  void _showTitlesTutorial(BuildContext context, EconomyProvider provider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('称号コレクションへようこそ！'),
        content: const Text(
          'ここでは、あなたの努力の証である「称号」を確認できます。\n\n'
          '条件を達成して称号を獲得し、「装備」することでホーム画面に表示できます。\n'
          'また、コインを使ってレアな称号を購入することも可能です。',
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              provider.markTutorialAsSeen('titles');
              Navigator.pop(context);
            },
            child: const Text('わかった'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('称号コレクション')),
      body: Consumer<EconomyProvider>(
        builder: (context, provider, child) {
          final unlockedTitles = provider.getUnlockedTitles();
          final lockedTitles = provider.getLockedTitles();
          final equippedTitle = provider.getEquippedTitle();

          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Currently Equipped Section
                if (equippedTitle != null) ...[
                  const Text(
                    '装備中の称号',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildTitleCard(
                    context,
                    provider,
                    equippedTitle,
                    isEquipped: true,
                    isUnlocked: true,
                  ),
                  const SizedBox(height: 24),
                ],

                // Unlocked Section
                Text(
                  '獲得済み (${unlockedTitles.length})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (unlockedTitles.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: Text('獲得した称号はありません')),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: unlockedTitles.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final title = unlockedTitles[index];
                      final isEquipped = title.id == equippedTitle?.id;
                      // Skip if this is the equipped title (optional, but shows full list)
                      // Let's show it but mark it selected
                      return _buildTitleCard(
                        context,
                        provider,
                        title,
                        isEquipped: isEquipped,
                        isUnlocked: true,
                      );
                    },
                  ),
                const SizedBox(height: 24),

                // Locked Section
                Text(
                  '未獲得 (${lockedTitles.length})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (lockedTitles.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: Text('すべての称号を獲得しました！')),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: lockedTitles.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final title = lockedTitles[index];
                      return _buildTitleCard(
                        context,
                        provider,
                        title,
                        isEquipped: false,
                        isUnlocked: false,
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _confirmPurchase(
    BuildContext context,
    EconomyProvider provider,
    app_models.Title title,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title.description),
            const SizedBox(height: 16),
            const Text('この称号を購入しますか？'),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.monetization_on, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  '${title.price} コイン',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            child: const Text('購入する', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (!context.mounted) return;
      final success = await provider.purchaseTitle(title);
      if (context.mounted) {
        if (success) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('「${title.name}」を購入しました！')));
        } // Error is handled in provider notification/snackbar usually or here we could show strict error
      }
    }
  }

  Widget _buildRarityBadge(app_models.TitleRarity rarity) {
    Color color;
    switch (rarity) {
      case app_models.TitleRarity.legendary:
        color = Colors.redAccent;
        break;
      case app_models.TitleRarity.epic:
        color = Colors.deepPurple;
        break;
      case app_models.TitleRarity.rare:
        color = Colors.blueAccent;
        break;
      default:
        color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        rarity.name.toUpperCase(),
        style: const TextStyle(
          fontSize: 9,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTitleCard(
    BuildContext context,
    EconomyProvider provider,
    app_models.Title title, {
    required bool isEquipped,
    required bool isUnlocked,
  }) {
    final isPurchasable = title.isPurchasable && !isUnlocked;
    final canAfford = provider.economyState.totalCoins >= (title.price ?? 0);

    // Rarity Styling Setup
    List<BoxShadow> shadows = [];
    Gradient? backgroundGradient;
    Color borderSideColor = Colors.transparent;
    double borderWidth = 0;
    Color iconColor = Colors.grey;
    Color iconBgColor = Colors.grey[200]!;

    if (isUnlocked) {
      switch (title.rarity) {
        case app_models.TitleRarity.legendary:
          iconColor = Colors.redAccent;
          iconBgColor = Colors.red.shade50;
          backgroundGradient = LinearGradient(
            colors: [Colors.white, Colors.orange.shade50, Colors.red.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
          shadows = [
            BoxShadow(
              color: Colors.redAccent.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.orangeAccent.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ];
          borderWidth = 1;
          borderSideColor = Colors.redAccent.withOpacity(0.3);
          break;

        case app_models.TitleRarity.epic:
          iconColor = Colors.deepPurple;
          iconBgColor = Colors.purple.shade50;
          backgroundGradient = LinearGradient(
            colors: [Colors.white, Colors.deepPurple.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
          shadows = [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ];
          borderWidth = 0.5;
          borderSideColor = Colors.deepPurple.withOpacity(0.3);
          break;

        case app_models.TitleRarity.rare:
          iconColor = Colors.blueAccent;
          iconBgColor = Colors.blue.shade50;
          backgroundGradient = LinearGradient(
            colors: [Colors.white, Colors.lightBlue.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
          shadows = [
            BoxShadow(
              color: Colors.blue.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ];
          borderWidth = 0.5;
          borderSideColor = Colors.blue.withOpacity(0.3);
          break;

        case app_models.TitleRarity.common:
        default:
          iconColor = Colors.blueGrey;
          iconBgColor = Colors.blueGrey.withOpacity(0.1);
          shadows = [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ];
          borderWidth = 1;
          borderSideColor = Colors.grey.shade100;
          break;
      }
    } else {
      // Locked
      iconBgColor = Colors.grey[100]!;
      shadows = [
        BoxShadow(
          color: Colors.black.withOpacity(0.02),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ];
      borderSideColor = Colors.grey.shade200;
      borderWidth = 1;
    }

    // Default glow color
    Color glowColor = AppConstants.accentColor;

    if (isEquipped) {
      // Enhanced Equipped Aura
      switch (title.rarity) {
        case app_models.TitleRarity.legendary:
          glowColor = Colors.redAccent;
          break;
        case app_models.TitleRarity.epic:
          glowColor = Colors.deepPurpleAccent;
          break;
        case app_models.TitleRarity.rare:
          glowColor = Colors.blueAccent;
          break;
        default:
          glowColor = AppConstants.accentColor;
          break;
      }

      borderWidth = 2.5;
      borderSideColor = glowColor;

      // Stack multiple shadows for a "glowing" effect
      shadows = [
        BoxShadow(
          color: glowColor.withOpacity(0.6),
          blurRadius: 12,
          spreadRadius: 1,
        ),
        BoxShadow(
          color: glowColor.withOpacity(0.3),
          blurRadius: 24,
          spreadRadius: 4,
        ),
        ...shadows,
      ];

      if (isUnlocked && title.rarity == app_models.TitleRarity.common) {
        iconColor = glowColor;
      }
    }

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: isEquipped ? 12 : 6,
        horizontal: isEquipped ? 8 : 4,
      ), // Add breathing room for glow
      decoration: BoxDecoration(
        color: isUnlocked
            ? (backgroundGradient == null ? Colors.white : null)
            : Colors.grey[50],
        gradient: backgroundGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderSideColor,
          width: borderWidth > 0 ? borderWidth : 1,
        ),
        boxShadow: shadows,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isUnlocked
              ? () async {
                  if (!isEquipped) {
                    await provider.equipTitle(title.id);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('「${title.name}」を装備しました')),
                      );
                    }
                  }
                }
              : (isPurchasable && canAfford
                    ? () => _confirmPurchase(context, provider, title)
                    : null),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    shape: BoxShape.circle,
                    border: isEquipped
                        ? Border.all(
                            color: glowColor.withOpacity(0.6),
                            width: 2,
                          )
                        : null,
                  ),
                  child: Icon(
                    _getIconData(title.iconName),
                    color: isUnlocked ? iconColor : Colors.grey,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 16),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isUnlocked
                                    ? Colors.black87
                                    : Colors.grey[600],
                              ),
                            ),
                          ),
                          if (isUnlocked &&
                              title.rarity != app_models.TitleRarity.common)
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: _buildRarityBadge(title.rarity),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isUnlocked
                            ? '${title.description}\n条件: ${title.condition}'
                            : '獲得条件: ${title.condition}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isUnlocked
                              ? Colors.grey[700]
                              : Colors.grey[500],
                        ),
                      ),
                      if (!isUnlocked && !isPurchasable)
                        Builder(
                          builder: (context) {
                            final progress = provider.getTitleProgress(
                              title.id,
                            );
                            if (progress != null) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  '進捗: $progress',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppConstants.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      if (isPurchasable)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.amber.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.monetization_on,
                                  size: 12,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${title.price} Coins',
                                  style: TextStyle(
                                    color: Colors.amber[900],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Action
                const SizedBox(width: 12),
                if (isUnlocked)
                  if (isEquipped)
                    Icon(Icons.check_circle, color: glowColor, size: 32)
                  else
                    Text(
                      '装備',
                      style: TextStyle(
                        color: AppConstants.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    )
                else if (isPurchasable)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: canAfford ? Colors.amber : Colors.grey[300],
                      shape: BoxShape.circle,
                      boxShadow: canAfford
                          ? [
                              BoxShadow(
                                color: Colors.amber.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : [],
                    ),
                    child: const Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                      size: 20,
                    ),
                  )
                else
                  Icon(Icons.lock_outline, color: Colors.grey[300], size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'trophy':
        return Icons.emoji_events;
      case 'star':
        return Icons.star;
      case 'check_circle':
        return Icons.check_circle;
      case 'favorite':
        return Icons.favorite;
      case 'military_tech':
        return Icons.military_tech;
      case 'monetization_on':
        return Icons.monetization_on;
      case 'diamond':
        return Icons.diamond;
      case 'workspace_premium':
        return Icons.workspace_premium;
      case 'stars':
        return Icons.stars;
      default:
        return Icons.emoji_events;
    }
  }
}
