import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/fish.dart';
import '../providers/economy_provider.dart';
import '../utils/constants.dart';
import 'fish_collection_screen.dart';
import '../models/fishing_item.dart';
import '../models/user_inventory.dart';
import '../models/fishing_item.dart';
import '../models/user_inventory.dart';
import 'fishing_shop_screen.dart';
import 'dart:math';
import 'package:flutter/services.dart'; // For HapticFeedback

enum FishingAtmosphere { normal, sunset, night }

class FishingScreen extends StatefulWidget {
  const FishingScreen({super.key});

  @override
  State<FishingScreen> createState() => _FishingScreenState();

  static void showTutorial(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('釣りへようこそ！'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ここでは「釣りチケット」を使って魚釣りができます。\n\n'
                '釣り糸を垂らして、ヒットしたらタップ！\n'
                '珍しい魚を釣って図鑑をコンプリートしましょう。\n\n'
                'チケットはショップで購入したり、ワークアウト報酬で手に入ります。',
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              context.read<EconomyProvider>().markTutorialAsSeen('fishing');
              Navigator.pop(context);
            },
            child: const Text('はじめる'),
          ),
        ],
      ),
    );
  }
}

class _FishingScreenState extends State<FishingScreen>
    with TickerProviderStateMixin {
  late AnimationController _swimController; // For Fish Shadow approaching

  // Animation State
  double _floatOffset = 0.0;
  bool _showFloat = false;
  double _baseScale = 1.0; // Progressive zoom level
  Set<String> _preCastFishIds = {}; // Snapshot for "NEW" badge

  // Animation Controllers
  late AnimationController _pokeController;
  late AnimationController _boatController;
  late AnimationController _cloudController;

  // Atmosphere Animation
  late AnimationController
  _celestialController; // For Sun/Moon rotation & scale

  // Game State
  bool _isFishing = false;
  Fish? _lastCaughtFish; // For single result display logic if needed

  // Atmosphere State
  // Atmosphere State
  FishingAtmosphere _currentAtmosphere = FishingAtmosphere.normal;
  Color _skyColor = const Color(0xFF87CEEB); // Default Sky Blue
  Color _seaColorDeep = const Color(0xFF03A9F4);
  Color _seaColorShallow = const Color(0xFF4FC3F7);

  @override
  void initState() {
    super.initState();
    _swimController = AnimationController(
      duration: const Duration(seconds: 2), // Swim over time
      vsync: this,
    );

    _pokeController = AnimationController(
      // Tackle! (Fast) -> Slowly Return
      // Was 300ms, restored to 1000ms for better "weight"
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _boatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _cloudController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _celestialController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  void dispose() {
    _swimController.dispose();
    _pokeController.dispose();
    _boatController.dispose();
    _cloudController.dispose();
    _celestialController.dispose();
    super.dispose();
  }

  Future<void> _startFishing(int times) async {
    final provider = context.read<EconomyProvider>();

    // Ticket Check
    if (provider.economyState.fishingTickets < times) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('チケットが足りません！')));
      return;
    }

    // Capture snapshot for "NEW" badge logic later
    _preCastFishIds = provider.economyState.fishCollection.keys.toSet();

    setState(() {
      _isFishing = true;
      _showFloat = true; // Show the float/line
      _baseScale = 1.0;

      // Reset atmosphere at start
      _currentAtmosphere = FishingAtmosphere.normal;
      _skyColor = const Color(0xFF87CEEB);
      // Normal Sea: Emerald/Cyan tint to contrast with Sky Blue
      _seaColorDeep = const Color(0xFF00695C);
      _seaColorShallow = const Color(0xFF4DB6AC);

      _celestialController.reset();
      _swimController.reset();
      _pokeController.reset();
    });

    try {
      // 1. Perform Fishing API call first
      List<Fish> caughtFish = await provider.castLine(times);

      if (caughtFish.isEmpty) {
        setState(() {
          _isFishing = false;
          _showFloat = false;
        });
        if (provider.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(provider.errorMessage!)));
        }
        return;
      }

      // 2. Determine Atmosphere based on rarity
      _determineAtmosphere(caughtFish);
      setState(() {});

      // Play Celestial Animation if special
      if (_currentAtmosphere != FishingAtmosphere.normal) {
        await _celestialController.forward();
      }

      // 3. Fish Approach Animation (Swim)
      _baseScale = 1.0;
      _swimController.reset();
      _pokeController.reset();

      // Wait for fish to swim to the hook (2 seconds)
      await _swimController.forward();

      // 4. Poke Animation (Suspense)
      final maxRarity = caughtFish.isNotEmpty
          ? caughtFish.map((f) => f.rarity).reduce(max)
          : 1;

      // Rarity decides number of pokes
      // Rarity decides number of pokes
      int pokes = maxRarity >= 4 ? 4 : (maxRarity >= 3 ? 3 : 2);

      for (int i = 0; i < pokes; i++) {
        // Haptic feedback (Simulation of bite)
        HapticFeedback.mediumImpact();

        // Trigger Zoom IN just as it bites (0ms - 100ms is the dip)
        setState(() {
          _baseScale += 0.05;
        });

        // Run the full "Dip -> Hold -> Return" animation sequence
        // The logic in _buildBoat handles the movement based on controller value 0.0 -> 1.0
        await _pokeController.forward(from: 0.0);

        // Wait between pokes (Rhythm)
        // Shorter wait for the last one to simulate urgency
        if (i < pokes - 1) {
          await Future.delayed(const Duration(milliseconds: 300));
        } else {
          await Future.delayed(const Duration(milliseconds: 100));
        }
      }

      // Hit! Haptic
      HapticFeedback.heavyImpact();

      // 5. Hide Float & Reset zoom before result
      setState(() {
        _baseScale = 1.0;
        _showFloat = false;
      });

      // 6. Show Result
      if (!mounted) return;
      await _showResultDialog(caughtFish);
    } catch (e) {
      debugPrint('Error fishing: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('エラーが発生しました: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isFishing = false;
          _showFloat = false;
          // Slowly revert
          _currentAtmosphere = FishingAtmosphere.normal;
          _skyColor = const Color(0xFF87CEEB);
          _seaColorDeep = const Color(0xFF03A9F4);
          _seaColorShallow = const Color(0xFF4FC3F7);
        });
      }
    }
  }

  void _determineAtmosphere(List<Fish> fishList) {
    if (fishList.isEmpty) return;

    // Get max rarity
    final maxRarity = fishList.map((f) => f.rarity).reduce(max);
    final random = Random();

    if (maxRarity >= 4) {
      // ★4: 50% Night, 25% Sunset, 25% Normal
      final r = random.nextDouble();
      if (r < 0.5) {
        _currentAtmosphere = FishingAtmosphere.night;
      } else if (r < 0.75) {
        _currentAtmosphere = FishingAtmosphere.sunset;
      } else {
        _currentAtmosphere = FishingAtmosphere.normal;
      }
    } else if (maxRarity >= 3) {
      // ★3: 50% Sunset, 50% Normal
      if (random.nextBool()) {
        _currentAtmosphere = FishingAtmosphere.sunset;
      } else {
        _currentAtmosphere = FishingAtmosphere.normal;
      }
    } else {
      _currentAtmosphere = FishingAtmosphere.normal;
    }

    // Base Sea Colors (Normal)
    const baseDeep = Color(0xFF03A9F4);
    const baseShallow = Color(0xFF4FC3F7);

    // Set Color
    switch (_currentAtmosphere) {
      case FishingAtmosphere.sunset:
        _skyColor = const Color(0xFFFF7E5F); // Sunset Orange
        // Darken base by 30%
        _seaColorDeep = Color.lerp(baseDeep, Colors.black, 0.3)!;
        _seaColorShallow = Color.lerp(baseShallow, Colors.black, 0.3)!;
        break;
      case FishingAtmosphere.night:
        _skyColor = const Color(0xFF1A1A2E); // Dark Navy
        // Darken base by 60%
        _seaColorDeep = Color.lerp(baseDeep, Colors.black, 0.6)!;
        _seaColorShallow = Color.lerp(baseShallow, Colors.black, 0.6)!;
        break;
      case FishingAtmosphere.normal:
      default:
        _skyColor = const Color(0xFF87CEEB); // Sky Blue
        _seaColorDeep = baseDeep;
        _seaColorShallow = baseShallow;
    }
  }

  Future<void> _playSingleFishingAnimation(int rarity) async {
    debugPrint('Fishing Animation for Rarity: $rarity');

    // 0. Start (Wait for Uki to settle) - Already waited during Swim (2s)
    // Add small pause before first poke?
    await Future.delayed(const Duration(milliseconds: 500));

    // 1. Poke 1 (Always, since min rarity is 1)
    if (rarity >= 1) {
      await _poke();
      // Wait after 1st poke (Normal Interval)
      await Future.delayed(const Duration(milliseconds: 1200));
    }

    // 2. Poke 2
    if (rarity >= 2) {
      await _poke();
      // "2回目→3回目の間に「静寂0.2〜0.4秒」" -> Pause 400ms -> Increased to 800ms
      await Future.delayed(const Duration(milliseconds: 800));
    }

    // 3. Poke 3
    if (rarity >= 3) {
      await _poke();
      // "3回目→4回目の間に「間（0.4〜0.8秒）」" -> Pause 800ms -> Increased to 1200ms
      await Future.delayed(const Duration(milliseconds: 1200));
    }

    // 4. Poke 4
    if (rarity >= 4) {
      await _poke();
      // Strong Hit preparation
    }

    // Final "Hit" - Tackle and Hold
    await Future.delayed(const Duration(milliseconds: 500));
    await _hit();
    // Wait a bit holding the fish
    await Future.delayed(const Duration(milliseconds: 600));
  }

  Future<void> _hit() async {
    // Stronger impact for final hit
    HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 50));
    HapticFeedback.heavyImpact();

    // Tackle (15 -> 0) and Hold (Bite)
    // Animation 0.0 -> 0.2 covers Tackle & Bite phases.
    _pokeController.reset();
    await _pokeController.animateTo(
      0.2,
      duration: const Duration(milliseconds: 200),
    );
  }

  Future<void> _poke() async {
    HapticFeedback.lightImpact();
    // Progressive Zoom
    setState(() {
      _baseScale += 0.08;
    });

    // Forward plays the sequence: Retreat -> Attack -> Hit
    await _pokeController.forward(from: 0.0);
  }

  Future<void> _showResultDialog(List<Fish> fishList) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('釣れました！ 🎣'),
        content: SizedBox(
          width: double.maxFinite,
          child: fishList.length == 1
              ? _buildSingleResult(fishList.first)
              : _buildMultiResult(fishList),
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

  Widget _buildSingleResult(Fish fish) {
    final isNew = !_preCastFishIds.contains(fish.id);
    final isRarity4 = fish.rarity >= 4;
    final isRarity3 = fish.rarity == 3;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Show Image with fallback
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Rainbow Aura for Rarity 4
            if (isRarity4)
              Container(
                height: 130,
                width: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const SweepGradient(
                    colors: [
                      Colors.red,
                      Colors.orange,
                      Colors.yellow,
                      Colors.green,
                      Colors.blue,
                      Colors.indigo,
                      Colors.purple,
                      Colors.red,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),

            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.blue[50], // Background for transparent PNGs
                shape: BoxShape.circle,
                border: isRarity4
                    ? Border.all(color: Colors.white, width: 4)
                    : null,
              ),
              child: ClipOval(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset(
                    fish.imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.set_meal,
                        size: 60,
                        color: Colors.blue,
                      );
                    },
                  ),
                ),
              ),
            ),

            // Sparkles for Rarity 3+
            if (isRarity3 || isRarity4) ...[
              const Positioned(
                top: 0,
                right: 0,
                child: Icon(Icons.auto_awesome, color: Colors.amber, size: 30),
              ),
              const Positioned(
                bottom: 10,
                left: 0,
                child: Icon(Icons.star, color: Colors.yellow, size: 20),
              ),
            ],

            // NEW Badge
            if (isNew)
              Positioned(
                top: -10,
                left: -10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    'NEW!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          fish.name,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            fish.rarity,
            (index) => const Icon(Icons.star, color: Colors.amber),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          fish.description,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildMultiResult(List<Fish> fishList) {
    return SizedBox(
      height: 300,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.9,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: fishList.length,
        itemBuilder: (context, index) {
          final fish = fishList[index];
          final isNew = !_preCastFishIds.contains(fish.id);
          final isRarity4 = fish.rarity >= 4;
          final isRarity3 = fish.rarity == 3;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Card(
                elevation: isRarity4 ? 8 : 2,
                shadowColor: isRarity4 ? Colors.purpleAccent : Colors.black,
                shape: isRarity4
                    ? RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.amber, width: 2),
                      )
                    : null,
                color: isRarity4 ? Colors.deepPurple[50] : Colors.grey[100],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              fish.imagePath,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.set_meal,
                                    size: 40,
                                    color: Colors.blue,
                                  ),
                            ),
                          ),
                          if (isRarity3 || isRarity4)
                            const Positioned(
                              top: 0,
                              right: 0,
                              child: Icon(
                                Icons.auto_awesome,
                                color: Colors.amber,
                                size: 20,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Text(
                      fish.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        fish.rarity,
                        (index) => const Icon(
                          Icons.star,
                          size: 12,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
              if (isNew)
                Positioned(
                  top: -5,
                  left: -5,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'NEW!',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBoat() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        // Fisherman (Person) - Drawn first so he sits BEHIND the boat hull
        // Fisherman (Person) - Drawn first so he sits BEHIND the boat hull
        Positioned(
          bottom: 25, // Sit inside boat (adjusted for image)
          child: Image.asset('fisher.png', height: 100),
        ),
        // Boat Body
        Container(
          width: 140,
          height: 60,
          decoration: const BoxDecoration(
            color: Colors.brown,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
          child: Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              width: 120,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.brown[800],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        // Fishing Rod
        Positioned(
          bottom: 45,
          right: 50, // Hand position (Refined - moved right)
          child: Transform(
            alignment: Alignment.bottomCenter,
            transform: Matrix4.rotationZ(
              _isFishing ? 0.8 : 0.0,
            ), // Active: / (Right), Idle: | (Vertical)
            child: Container(
              width: 5,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.brown[900],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
        if (_showFloat) ...[
          // String (Line) - Connects Tip to Float
          Positioned(
            bottom: 0, // Water level
            right: -22, // Aligned with Rod Tip
            child: Container(
              width: 1,
              height: 114,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          // Fish Shadow
          Positioned(
            bottom: -35,
            right: -68, // Shifted right slightly (-62 -> -68)
            child: AnimatedBuilder(
              animation: Listenable.merge([_swimController, _pokeController]),
              builder: (context, child) {
                // Poke logic: Tackle! (Fast) -> Slowly Return
                // Base: 15.0 (Shorter distance -> Slower return speed)
                double pokeX = 15.0;
                final val = _pokeController.value;

                if (val < 0.1) {
                  // Tackle: 15 -> 0 (Fast)
                  double t = val / 0.1;
                  pokeX = 15.0 * (1.0 - t);
                } else if (val < 0.2) {
                  // Bite: Stay 0
                  pokeX = 0.0;
                } else {
                  // Slow Return: 0 -> 15
                  double t = (val - 0.2) / 0.8;
                  pokeX = 15.0 * t;
                }

                // Swim logic: From Right (150px offset) to 0
                final swimVal = _swimController.value;
                final swimX = 150.0 * (1.0 - swimVal);

                return Transform.translate(
                  offset: Offset(swimX + pokeX, 0),
                  child: child,
                );
              },
              child: Image.asset(
                'shadow.png',
                width: 40,
                height: 40,
                color: Colors.black.withOpacity(0.4),
              ),
            ),
          ),
          // Hook (Hari)
          Positioned(
            bottom: -15,
            right: -30, // Aligned: Line(-22) - StemLeft(0) at -22.
            // Container Left = Right + Width => Right = Left - Width = -22 - 8 = -30
            child: Container(
              width: 8,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border(
                  left: BorderSide(color: Colors.grey[300]!, width: 2),
                  bottom: BorderSide(color: Colors.grey[300]!, width: 2),
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading:
            !_isFishing, // Disable back button during fishing
        actions: _isFishing
            ? []
            : [
                // Help Button (added for manual tutorial check)
                IconButton(
                  icon: const Icon(
                    Icons.help_outline,
                    color: Colors.white,
                    size: 30,
                  ),
                  tooltip: '遊び方',
                  onPressed: () {
                    FishingScreen.showTutorial(context);
                  },
                ),
                // Hide actions during fishing
                // 1. Shop Button
                IconButton(
                  icon: const Icon(Icons.store, color: Colors.white, size: 30),
                  tooltip: '釣具屋',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const FishingShopScreen(),
                      ),
                    );
                  },
                ),
                // 2. Collection (Book) Button - Moved here
                IconButton(
                  icon: const Icon(Icons.book, color: Colors.white, size: 30),
                  tooltip: '図鑑',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const FishCollectionScreen(),
                      ),
                    );
                  },
                ),
                // 3. Tickets Display - Moved to end
                Consumer<EconomyProvider>(
                  builder: (context, provider, _) {
                    final tickets = provider.economyState.fishingTickets;
                    return Container(
                      margin: const EdgeInsets.only(right: 16, top: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.confirmation_number,
                            color: Colors.orange,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$tickets',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
      ),
      body: AnimatedBuilder(
        animation: _pokeController,
        builder: (context, child) {
          // Screen Shake / Zoom (Progressive + Pulse)
          final pulse = _pokeController.value < 0.5
              ? 0.0
              : (_pokeController.value - 0.5) * 0.1;
          final scale = _baseScale + pulse;
          // Note: pulse adds a little extra kick during dip

          return Transform.scale(
            scale: scale,
            alignment: Alignment.center,
            child: child,
          );
        },
        child: Stack(
          children: [
            // 1. Sky Background (Animated)
            AnimatedContainer(
              duration: const Duration(seconds: 2),
              color: _skyColor,
              curve: Curves.easeInOut,
            ),

            // Celestial Body (Sun/Moon)
            if (_currentAtmosphere != FishingAtmosphere.normal)
              Positioned(
                top: 80,
                right: 40,
                child: RotationTransition(
                  turns: Tween(begin: 0.5, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _celestialController,
                      curve: Curves.easeOutBack,
                    ),
                  ),
                  child: ScaleTransition(
                    scale: CurvedAnimation(
                      parent: _celestialController,
                      curve: Curves.easeOutBack,
                    ),
                    child: _currentAtmosphere == FishingAtmosphere.sunset
                        ? const Icon(
                            Icons.wb_sunny,
                            size: 100,
                            color: Colors.orangeAccent,
                          )
                        : const Icon(
                            Icons.nightlight_round,
                            size: 80,
                            color: Colors.yellowAccent,
                          ),
                  ),
                ),
              ),

            // Clouds (Decorative - Animated)
            AnimatedBuilder(
              animation: _cloudController,
              builder: (context, child) {
                final width = MediaQuery.of(context).size.width;
                // Cloud 1
                final pos1 = (_cloudController.value * (width + 400)) - 200;
                // Cloud 2 (offset by half)
                final pos2 =
                    ((_cloudController.value + 0.5) % 1.0 * (width + 400)) -
                    200;

                return Stack(
                  children: [
                    Positioned(
                      top: 100,
                      left: pos1,
                      child: Icon(
                        Icons.cloud,
                        size: 100,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    Positioned(
                      top: 150,
                      left: pos2,
                      child: Icon(
                        Icons.cloud,
                        size: 120,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                );
              },
            ),

            // 2. Sea Background (Animated)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height * 0.4,
              child: AnimatedContainer(
                duration: const Duration(seconds: 2),
                color: _seaColorShallow, // Use variable
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height * 0.35,
              child: AnimatedContainer(
                duration: const Duration(seconds: 2),
                color: _seaColorDeep, // Use variable
              ),
            ),

            // 3. Boat and Fisher (Custom Widget)
            Positioned(
              bottom:
                  MediaQuery.of(context).size.height * 0.32, // Just above water
              left: 0,
              right: 0,
              child: Align(
                alignment: const Alignment(
                  -0.2,
                  0.0,
                ), // Shift left to approx 2/5 (Center is 0.0, Left is -1.0)
                child: _isFishing
                    ? ScaleTransition(
                        scale: Tween(
                          begin: 1.0,
                          end: 1.05,
                        ).animate(_boatController),
                        child: _buildBoat(),
                      )
                    : _buildBoat(),
              ),
            ),

            // "Tap to fish" text
            if (!_isFishing)
              Positioned(
                top: MediaQuery.of(context).size.height * 0.3,
                left: 0,
                right: 0,
                child: const Center(
                  child: Text(
                    'タップして釣る',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 2,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // 4. Bottom Controls (GO FISH Button)
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: !_isFishing
                  ? Consumer<EconomyProvider>(
                      builder: (context, provider, _) {
                        final tickets = provider.economyState.fishingTickets;
                        final canFish = tickets >= 1;

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Multi Cast Button (Small, above main button)
                            if (tickets >= 2)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: TextButton.icon(
                                  onPressed: () {
                                    final maxCast = tickets > 10 ? 10 : tickets;
                                    _startFishing(maxCast);
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.white.withOpacity(
                                      0.9,
                                    ),
                                    foregroundColor: Colors.black87,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                  ),
                                  icon: const Icon(Icons.grid_view),
                                  label: const Text('まとめ釣り (最大10連)'),
                                ),
                              ),

                            // GO FISH Main Button
                            GestureDetector(
                              onTap: (!canFish) ? null : () => _startFishing(1),
                              child: Container(
                                width: double.infinity,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: canFish
                                      ? Colors.amber[700]
                                      : Colors.grey,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 4,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black38,
                                      offset: const Offset(0, 6),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    'GO FISH!',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 32,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    )
                  : const SizedBox.shrink(),
            ),
            // Equip Slots (Left side)
            if (!_isFishing)
              Positioned(
                top: kToolbarHeight + 50,
                left: 16,
                child: Consumer<EconomyProvider>(
                  builder: (context, provider, _) => _buildEquipSlots(provider),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEquipSlots(EconomyProvider provider) {
    if (!mounted) return const SizedBox.shrink();

    final inventory = provider.economyState.inventory;

    UserInventory? equippedRod;
    UserInventory? equippedItem;
    int equippedItemCount = 0;

    // Find equipped items
    for (var item in inventory) {
      if (item.isEquipped) {
        final def = FishingItem.getById(item.itemId);
        if (def == null) continue;

        if (def.type == FishingItemType.rod) {
          equippedRod = item;
        } else {
          equippedItem = item;
        }
      }
    }

    // Count total items matching the equipped item ID
    if (equippedItem != null) {
      equippedItemCount = inventory
          .where((i) => i.itemId == equippedItem!.itemId)
          .length;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSlot('竿', equippedRod, FishingItemType.rod),
        const SizedBox(height: 12),
        _buildSlot(
          'アイテム',
          equippedItem,
          FishingItemType.bait,
          count: equippedItemCount,
        ),
      ],
    );
  }

  Widget _buildSlot(
    String label,
    UserInventory? inv,
    FishingItemType type, {
    int? count,
  }) {
    final item = inv != null ? FishingItem.getById(inv.itemId) : null;

    return GestureDetector(
      onTap: () => _showEquipSheet(type),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: item != null ? Colors.amber : Colors.white54,
                width: item != null ? 2 : 1,
              ),
            ),
            alignment: Alignment.center,
            child: item != null
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        item.iconEmoji,
                        style: const TextStyle(fontSize: 28),
                      ),
                      if (count != null && count > 1)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'x$count',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      else if (inv!.remainingUses > 0 && item.durability > 1)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${inv.remainingUses}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                              ),
                            ),
                          ),
                        ),
                    ],
                  )
                : const Icon(Icons.add, color: Colors.white54),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              shadows: [Shadow(color: Colors.black, blurRadius: 4)],
            ),
          ),
        ],
      ),
    );
  }

  void _showEquipSheet(FishingItemType type) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => InventorySheet(targetType: type),
    );
  }
}

class InventorySheet extends StatelessWidget {
  final FishingItemType targetType;

  const InventorySheet({super.key, required this.targetType});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EconomyProvider>();
    final inventory = provider.economyState.inventory;

    // Group items by ID
    final Map<String, List<UserInventory>> groupedItems = {};
    for (var inv in inventory) {
      final item = FishingItem.getById(inv.itemId);
      if (item == null) continue;

      bool include = false;
      if (targetType == FishingItemType.rod) {
        if (item.type == FishingItemType.rod) include = true;
      } else {
        if (item.type != FishingItemType.rod &&
            item.type != FishingItemType.ticket)
          include = true;
      }

      if (include) {
        groupedItems.putIfAbsent(inv.itemId, () => []).add(inv);
      }
    }

    final itemIds = groupedItems.keys.toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            targetType == FishingItemType.rod ? '釣り竿を選択' : 'アイテムを選択',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (itemIds.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  'アイテムを持っていません',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: itemIds.length,
                itemBuilder: (context, index) {
                  final itemId = itemIds[index];
                  final instances = groupedItems[itemId]!;
                  final item = FishingItem.getById(itemId)!;

                  final totalCount = instances.length;
                  final equippedInstances = instances
                      .where((i) => i.isEquipped)
                      .toList();
                  final isEquipped = equippedInstances.isNotEmpty;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: isEquipped
                          ? Colors.amber.withOpacity(0.1)
                          : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: isEquipped
                          ? Border.all(color: Colors.amber)
                          : null,
                    ),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item.iconEmoji,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                      title: Text(
                        item.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        item.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '所持: $totalCount',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),
                          const SizedBox(width: 8),
                          isEquipped
                              ? ElevatedButton(
                                  onPressed: () {
                                    // Unequip all instances of this item
                                    for (var inv in equippedInstances) {
                                      provider.unequipItem(inv);
                                    }
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('外す'),
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    // Equip one instance (the first one)
                                    if (instances.isNotEmpty) {
                                      provider.equipItem(instances.first);
                                      Navigator.pop(context);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppConstants.primaryColor,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('装備'),
                                ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
