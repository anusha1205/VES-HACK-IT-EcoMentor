import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const WasteSorterApp());
}

class WasteSorterApp extends StatelessWidget {
  const WasteSorterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Waste Sorter',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Quicksand',
      ),
      home: const StartScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.lightBlue, Colors.green],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Waste Sorter',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black38,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WasteSorterGameScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green[700],
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Start Game',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('How to Play'),
                      content: const SingleChildScrollView(
                        child: Text(
                          'Drag the waste items to the correct bin:\n\n'
                          '• Blue bin: Recyclables (paper, plastic, glass)\n'
                          '• Green bin: Organic waste (food scraps, plants)\n'
                          '• Red bin: Hazardous waste (batteries, chemicals)\n'
                          '• Gray bin: General waste (non-recyclable items)\n\n'
                          'Score points for correct sorting and try to beat your high score!\n\n'
                          'You have 10 seconds - sort as many items as you can!',
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Got it!'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text(
                  'How to Play',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WasteSorterGameScreen extends StatefulWidget {
  const WasteSorterGameScreen({Key? key}) : super(key: key);

  @override
  State<WasteSorterGameScreen> createState() => _WasteSorterGameScreenState();
}

class _WasteSorterGameScreenState extends State<WasteSorterGameScreen> {
  int score = 0;
  int timeLeft = 20; // Total seconds for the game
  int correctSorts = 0;
  int incorrectSorts = 0;

  // To store the names of correctly / incorrectly sorted items
  final List<String> correctlySortedItems = [];
  final List<String> incorrectlySortedItems = [];

  late Timer gameTimer;
  final Random random = Random();

  // Active waste items on screen
  List<WasteItem> activeWasteItems = [];

  // For giving quick feedback (checkmark/cross) on the bins
  Map<WasteType, bool?> binFeedback = {};
  Map<WasteType, Timer?> feedbackTimers = {};

  // Master list of waste items that we’ll shuffle to reduce repetition
  late List<WasteItemData> _masterWasteList;
  int _currentItemIndex = 0;

  @override
  void initState() {
    super.initState();

    // 1) Define a larger variety of items (reduce repetition, add new ones).
    //    You can add or remove items to your liking.
    final initialWasteItems = <WasteItemData>[
      // Recyclable
      WasteItemData('Plastic Bottle', WasteType.recyclable, Icons.local_drink),
      WasteItemData('Newspaper', WasteType.recyclable, Icons.newspaper),
      WasteItemData('Glass Jar', WasteType.recyclable, Icons.wine_bar),
      WasteItemData('Cardboard Box', WasteType.recyclable, Icons.inbox),
      WasteItemData('Aluminum Can', WasteType.recyclable, Icons.local_cafe),
      WasteItemData('Magazine', WasteType.recyclable, Icons.menu_book),
      WasteItemData('Paper Bag', WasteType.recyclable, Icons.shopping_bag),
      WasteItemData('Milk Carton', WasteType.recyclable, Icons.local_cafe),
      WasteItemData('Cereal Box', WasteType.recyclable, Icons.breakfast_dining),
      WasteItemData('Steel Can', WasteType.recyclable, Icons.radio_button_checked),
      WasteItemData('Paper Cup', WasteType.recyclable, Icons.coffee),
      WasteItemData('Glass Bottle', WasteType.recyclable, Icons.local_bar),

      // Organic
      WasteItemData('Banana Peel', WasteType.organic, Icons.energy_savings_leaf),
      WasteItemData('Apple Core', WasteType.organic, Icons.apple),
      WasteItemData('Coffee Grounds', WasteType.organic, Icons.coffee),
      WasteItemData('Tea Leaves', WasteType.organic, Icons.emoji_food_beverage),
      WasteItemData('Vegetable Scraps', WasteType.organic, Icons.restaurant),
      WasteItemData('Egg Shells', WasteType.organic, Icons.egg),
      WasteItemData('Garden Waste', WasteType.organic, Icons.grass),
      WasteItemData('Food Leftovers', WasteType.organic, Icons.dinner_dining),
      WasteItemData('Bread Crusts', WasteType.organic, Icons.bakery_dining),
      WasteItemData('Nut Shells', WasteType.organic, Icons.eco),
      WasteItemData('Corn Cobs', WasteType.organic, Icons.eco),
      WasteItemData('Orange Peel', WasteType.organic, Icons.energy_savings_leaf),

      // Hazardous
      WasteItemData('Battery', WasteType.hazardous, Icons.battery_alert),
      WasteItemData('Paint Can', WasteType.hazardous, Icons.format_paint),
      WasteItemData('Medicine', WasteType.hazardous, Icons.medication),
      WasteItemData('Motor Oil', WasteType.hazardous, Icons.oil_barrel),
      WasteItemData('Light Bulb', WasteType.hazardous, Icons.lightbulb),
      WasteItemData('Pesticide', WasteType.hazardous, Icons.bug_report),
      WasteItemData('Bleach Bottle', WasteType.hazardous, Icons.sanitizer),
      WasteItemData('Nail Polish', WasteType.hazardous, Icons.brush),
      WasteItemData('Thermometer', WasteType.hazardous, Icons.thermostat),
      WasteItemData('Printer Ink', WasteType.hazardous, Icons.print),
      WasteItemData('Phone Battery', WasteType.hazardous, Icons.phone_android),
      WasteItemData('Chemical Bottle', WasteType.hazardous, Icons.science),

      // General
      WasteItemData('Styrofoam', WasteType.general, Icons.takeout_dining),
      WasteItemData('Dirty Diaper', WasteType.general, Icons.child_care),
      WasteItemData('Chips Bag', WasteType.general, Icons.fastfood),
      WasteItemData('Used Tissue', WasteType.general, Icons.cleaning_services),
      WasteItemData('Plastic Wrap', WasteType.general, Icons.wrap_text),
      WasteItemData('Broken Toy', WasteType.general, Icons.toys),
      WasteItemData('Candy Wrapper', WasteType.general, Icons.cake_outlined),
      WasteItemData('Vacuum Dust', WasteType.general, Icons.cleaning_services),
      WasteItemData('Straw', WasteType.general, Icons.straighten),
      WasteItemData('Rubber Band', WasteType.general, Icons.attractions),
      WasteItemData('Broken Glass', WasteType.general, Icons.broken_image),
      WasteItemData('Used Napkin', WasteType.general, Icons.event_note),
    ];

    // 2) Shuffle the master list to reduce repetition.
    _masterWasteList = List.from(initialWasteItems)..shuffle(random);

    // Start the game timer
    gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft <= 0) {
        endGame();
      } else {
        setState(() {
          timeLeft--;
        });
        // Add a new waste item every second OR whenever list is empty
        // Adjust frequency as you like
        if (timeLeft % 1 == 0 || activeWasteItems.isEmpty) {
          addNewWasteItem();
        }
      }
    });
  }

  // Randomly position items
  void addNewWasteItem() {
    if (!mounted) return;

    // If we've exhausted the list, reshuffle and start again
    if (_currentItemIndex >= _masterWasteList.length) {
      _masterWasteList.shuffle(random);
      _currentItemIndex = 0;
    }

    // Grab the next item from the shuffled list
    final wasteData = _masterWasteList[_currentItemIndex];
    _currentItemIndex++;

    // Decide a random position in the playable area
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    // Reserve ~120 px at bottom for bins, ~50 px at top for scoreboard
    // plus some margin so items aren’t clipped
    const topMargin = 70.0;
    const bottomMargin = 160.0; // bins + a little extra
    final posX = random.nextDouble() * (screenWidth - 100) + 20;
    final posY = random.nextDouble() * (screenHeight - bottomMargin - topMargin) + topMargin;

    final newItem = WasteItem(
      name: wasteData.name,
      type: wasteData.type,
      icon: wasteData.icon,
      position: Offset(posX, posY),
    );

    setState(() {
      activeWasteItems.add(newItem);
    });
  }

  void showFeedback(WasteType binType, bool isCorrect) {
    // Cancel existing timer if any
    feedbackTimers[binType]?.cancel();

    setState(() {
      binFeedback[binType] = isCorrect;
    });

    // Clear feedback after half a second
    feedbackTimers[binType] = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          binFeedback[binType] = null;
        });
      }
    });
  }

  void handleWasteSorted(WasteItem item, WasteType binType) {
    bool isCorrect = item.type == binType;
    showFeedback(binType, isCorrect);

    setState(() {
      activeWasteItems.remove(item);
      if (isCorrect) {
        score += 10;
        correctSorts++;
        correctlySortedItems.add(item.name);
        // Optionally add a new item immediately
        addNewWasteItem();
      } else {
        score = max(0, score - 5);
        incorrectSorts++;
        incorrectlySortedItems.add(item.name);
      }
    });
  }

  void endGame() {
    gameTimer.cancel();
    feedbackTimers.values.forEach((timer) => timer?.cancel());

    // Show final results including the list of items
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Game Over'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Final Score: $score',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text('Correct Sorts: $correctSorts', style: const TextStyle(color: Colors.green)),
              Text('Incorrect Sorts: $incorrectSorts', style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 10),
              Text(
                'Accuracy: ${(correctSorts > 0) ? ((correctSorts / (correctSorts + incorrectSorts) * 100).toStringAsFixed(1) + '%') : '0%'}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              if (correctlySortedItems.isNotEmpty)
                Text('Correctly Sorted Items:', style: TextStyle(fontWeight: FontWeight.bold)),
              for (var correctItem in correctlySortedItems) Text('• $correctItem'),
              const SizedBox(height: 10),
              if (incorrectlySortedItems.isNotEmpty)
                Text('Incorrectly Sorted Items:', style: TextStyle(fontWeight: FontWeight.bold)),
              for (var incorrectItem in incorrectlySortedItems) Text('• $incorrectItem'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const StartScreen()),
              );
            },
            child: const Text('Back to Menu'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const WasteSorterGameScreen()),
              );
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    gameTimer.cancel();
    feedbackTimers.values.forEach((timer) => timer?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(color: const Color(0xFFE0F2F1)),
          Column(
            children: [
              // Top scoreboard area
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                color: Colors.black54,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Score: $score',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Correct: $correctSorts',
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.timer, color: Colors.white),
                        const SizedBox(width: 5),
                        Text(
                          '$timeLeft',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Main Play Area
              Expanded(
                child: Stack(
                  children: [
                    // Draggable waste items
                    ...activeWasteItems.map(
                      (item) => Positioned(
                        left: item.position.dx,
                        top: item.position.dy,
                        child: Draggable<WasteItem>(
                          data: item,
                          feedback: Material(
                            color: Colors.transparent,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(item.icon, size: 50, color: Colors.black87),
                              ],
                            ),
                          ),
                          childWhenDragging: Opacity(
                            opacity: 0.3,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(item.icon, size: 50, color: Colors.black87),
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    backgroundColor: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(item.icon, size: 50, color: Colors.black87),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  item.name,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom bins area
              Container(
                height: 120,
                color: Colors.black54,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildWasteBin(WasteType.recyclable, Colors.blue, Icons.recycling, 'Recyclable'),
                    _buildWasteBin(WasteType.organic, Colors.green, Icons.compost, 'Organic'),
                    _buildWasteBin(WasteType.hazardous, Colors.red, Icons.warning, 'Hazardous'),
                    _buildWasteBin(WasteType.general, Colors.grey, Icons.delete, 'General'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWasteBin(WasteType type, Color color, IconData icon, String label) {
    return DragTarget<WasteItem>(
      onAccept: (item) => handleWasteSorted(item, type),
      builder: (context, candidateData, rejectedData) {
        final isTargeted = candidateData.isNotEmpty;
        final feedback = binFeedback[type];

        // Show a quick checkmark or cross if feedback is not null
        final feedbackIcon = feedback == null
            ? null
            : feedback
                ? const Icon(Icons.check_circle, color: Colors.white, size: 36)
                : const Icon(Icons.cancel, color: Colors.white, size: 36);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 70,
                  height: 80,
                  decoration: BoxDecoration(
                    color: isTargeted ? color.withOpacity(0.7) : color,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    border: Border.all(
                      color: isTargeted ? Colors.white : Colors.black,
                      width: isTargeted ? 2 : 1,
                    ),
                  ),
                  child: Icon(icon, color: Colors.white, size: 30),
                ),
                if (feedbackIcon != null)
                  Positioned(
                    top: 5,
                    right: 5,
                    child: feedbackIcon,
                  ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: isTargeted ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        );
      },
    );
  }
}

// Enums and data classes
enum WasteType {
  recyclable,
  organic,
  hazardous,
  general,
}

// Holds the basic data about each type of waste item
class WasteItemData {
  final String name;
  final WasteType type;
  final IconData icon;

  WasteItemData(this.name, this.type, this.icon);
}

class WasteItem {
  final String name;
  final WasteType type;
  final IconData icon;
  final Offset position;

  WasteItem({
    required this.name,
    required this.type,
    required this.icon,
    required this.position,
  });
}
