import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/economy_provider.dart';
import '../utils/constants.dart';
import 'home_screen.dart';
import 'body_composition_screen.dart';
import 'fishing_screen.dart';
import 'stats_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // 現在選択されているタブのインデックス
  int _currentIndex = 0;

  // 各タブに対応する画面
  // IndexedStackで状態を保持するため、すべて初期化しておく
  final List<Widget> _screens = [
    const HomeScreen(),
    const BodyCompositionScreen(),
    const FishingScreen(),
    const StatsScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 2) {
      _checkFishingTutorial();
    }
  }

  void _checkFishingTutorial() {
    final provider = context.read<EconomyProvider>();
    final userProfile = provider.userProfile;
    if (userProfile != null && !userProfile.seenTutorials.contains('fishing')) {
      FishingScreen.showTutorial(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStackを使用して、画面の状態（スクロール位置など）を保持したまま切り替える
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppConstants.surfaceColor,
          border: Border(
            top: BorderSide(
              color: Colors.grey[200]!, // Divider color
              width: 1.0,
            ),
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 60,
            child: Row(
              children: [
                _buildNavItem(0, Icons.home_outlined, Icons.home, 'ホーム'),
                _buildNavItem(
                  1,
                  Icons.monitor_weight_outlined,
                  Icons.monitor_weight,
                  '体組成',
                ),
                _buildNavItem(2, Icons.phishing_outlined, Icons.phishing, '釣り'),
                _buildNavItem(
                  3,
                  Icons.bar_chart_outlined,
                  Icons.bar_chart,
                  '統計',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    IconData activeIcon,
    String label,
  ) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? AppConstants.primaryColor : Colors.grey[400];

    return Expanded(
      child: InkWell(
        onTap: () => _onTabTapped(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space
          children: [
            // Top Indicator Bar
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 3,
              width: isSelected ? 40 : 0,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppConstants.primaryColor
                    : Colors.transparent,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(2),
                ),
              ),
            ),
            // Icon & Label
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(isSelected ? activeIcon : icon, color: color, size: 24),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontSize: 10,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 3), // Bottom padding balance
          ],
        ),
      ),
    );
  }
}
