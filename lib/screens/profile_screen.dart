import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/economy_provider.dart';
import '../utils/constants.dart';
import 'debug_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _editName() async {
    final provider = context.read<EconomyProvider>();
    _nameController.text = provider.userProfile?.displayName ?? '';

    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('名前を変更'),
        content: TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            hintText: '新しい名前',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, _nameController.text),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('保存'),
          ),
        ],
      ),
    );

    if (newName != null && newName.trim().isNotEmpty) {
      if (mounted) {
        await provider.updateDisplayName(newName.trim());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final economy = context.watch<EconomyProvider>();
    final profile = economy.userProfile;
    final state = economy.economyState;

    // Safety check just in case keys are missing in old data
    final totalWorkouts = state.getAchievementCount(
      AppConstants.achievementTotalWorkouts,
    );
    final totalVolume = state.getAchievementCount(
      AppConstants.achievementTotalVolume,
    );
    final maxVolume = state.getAchievementCount(
      AppConstants.achievementMaxVolume,
    );
    final streak = economy.consecutiveWeeksStreak;

    // Debug logging
    print('📊 [ProfileScreen] Stats:');
    print(
      '   Total Workouts: $totalWorkouts (type: ${totalWorkouts.runtimeType})',
    );
    print('   Streak: $streak (type: ${streak.runtimeType})');
    print('   Total Volume: $totalVolume (type: ${totalVolume.runtimeType})');
    print('   Max Volume: $maxVolume (type: ${maxVolume.runtimeType})');
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'プロフィール',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.bug_report, color: Colors.grey),
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const DebugScreen()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Avatar & Name Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppConstants.primaryColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppConstants.primaryColor.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          profile?.displayName ?? '名前未設定',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          size: 20,
                          color: Colors.grey,
                        ),
                        onPressed: _editName,
                        tooltip: '名前を変更',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Stats Grid
            Text(
              '統計データ',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.25, // Adjusted to prevent overflow
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildStatCard(
                  '総ワークアウト',
                  '$totalWorkouts 回',
                  Icons.fitness_center,
                ),
                _buildStatCard(
                  '継続週間',
                  '$streak 週間',
                  Icons.local_fire_department,
                  isStreak: true,
                ),
                _buildStatCard(
                  '総負荷量',
                  _formatVol(totalVolume),
                  Icons.line_weight,
                ),
                _buildStatCard(
                  '1回最大負荷',
                  _formatVol(maxVolume),
                  Icons.emoji_events,
                ),
                _buildStatCard(
                  '総時間',
                  _formatDuration(
                    state.getAchievementCount(
                      AppConstants.achievementTotalDuration,
                    ),
                  ),
                  Icons.timer,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    return '$seconds秒';
  }

  String _formatVol(int vol) {
    // Format with commas for readability (e.g. 10,000 kg)
    final formatted = vol.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    return '$formatted kg';
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon, {
    bool isStreak = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Changed to spaceBetween
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isStreak
                    ? Colors.orange.withOpacity(0.1)
                    : AppConstants.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isStreak ? Colors.orange : AppConstants.primaryColor,
                size: 24,
              ),
            ),
            // Removed Spacer()
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isStreak ? Colors.orange[800] : Colors.black87,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
