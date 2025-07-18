import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const ClimateEscapeGame());
}

/// A simple global utility to store and manage our countdown timer.
/// We’ll store the time in seconds and a callback to notify the app
/// when time reaches zero.
///
/// This is a basic approach without using provider or setState at the top level.
class GlobalTimer {
  // 2 minutes total (120 seconds). You can modify this if you like.
  static int timeLeft = 120;
  static Timer? _timer;

  // A callback that screens can set to know when time updates or ends
  static Function(int)? onTick;

  // Start the countdown
  static void startTimer() {
    stopTimer(); // in case it was running before
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        timeLeft--;
        if (onTick != null) {
          onTick!(timeLeft);
        }
      } else {
        stopTimer();
      }
    });
  }

  // Stop the timer
  static void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  // Reset timeLeft to a new value
  static void reset(int newTime) {
    timeLeft = newTime;
  }
}

/// The main App widget, which sets up routes for different screens.
class ClimateEscapeGame extends StatelessWidget {
  const ClimateEscapeGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Climate Escape Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/puzzle1': (context) => const PuzzleOneScreen(),
        '/puzzle2': (context) => const PuzzleTwoScreen(),
        '/success': (context) => const FinalSuccessScreen(),
        '/gameOver': (context) => const GameOverScreen(),
      },
    );
  }
}

/// A small widget that displays the countdown timer in the top-right corner.
/// If time hits 0, it navigates to Game Over.
class TimerDisplay extends StatefulWidget {
  const TimerDisplay({Key? key}) : super(key: key);

  @override
  State<TimerDisplay> createState() => _TimerDisplayState();
}

class _TimerDisplayState extends State<TimerDisplay> {
  int _secondsLeft = GlobalTimer.timeLeft;

  @override
  void initState() {
    super.initState();
    // Register a callback so that whenever GlobalTimer updates, we update here
    GlobalTimer.onTick = (timeLeft) {
      if (!mounted) return;
      setState(() {
        _secondsLeft = timeLeft;
      });
      if (timeLeft <= 0) {
        // Time’s up -> go to game over
        Future.microtask(() {
          Navigator.pushNamedAndRemoveUntil(context, '/gameOver', (r) => false);
        });
      }
    };
  }

  @override
  void dispose() {
    // Cleanup: only if we want to remove the callback on dispose
    if (GlobalTimer.onTick == (timeLeft) {}) {
      GlobalTimer.onTick = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = _secondsLeft ~/ 60;
    final seconds = _secondsLeft % 60;
    final timeString =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Positioned(
      top: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          timeString,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

/// HOME SCREEN
///
/// Shows an introduction to the story and a button to navigate to Puzzle #1.
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  // A gradient background for extra visual flair
  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3a7bd5), Color(0xFF3a6073)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Whenever the user arrives at Home, reset and start the timer again
    GlobalTimer.reset(120); // 2 minutes
    GlobalTimer.startTimer();

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          // No timer display on Home
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              // Column with image, text, button
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Climate Lab - Escape Room',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Image
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        // Replace this with your local asset if desired
                        'https://images.unsplash.com/photo-1494122475979-86db56f7ba3f?'
                        'ixid=M3w5MTMyMXwwfDF8c2VhcmNofDEyfHxsYWJvcmF0b3J5fGVufDB8fHx8MTY4ODcxMTkxNQ&'
                        'ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Intro text
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Welcome to the Climate Lab! A severe storm is approaching. '
                      'You must solve the puzzles before time runs out!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/puzzle1');
                    },
                    child: const Text('Start Puzzle #1'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// PUZZLE ONE SCREEN
///
/// A simple puzzle: user must enter the correct code "350" to proceed.
class PuzzleOneScreen extends StatefulWidget {
  const PuzzleOneScreen({Key? key}) : super(key: key);

  @override
  State<PuzzleOneScreen> createState() => _PuzzleOneScreenState();
}

class _PuzzleOneScreenState extends State<PuzzleOneScreen> {
  final TextEditingController _inputController = TextEditingController();
  bool _showError = false;

  final String _correctCode = '350'; // Our correct CO2 limit

  void _checkCode() {
    setState(() {
      if (_inputController.text.trim() == _correctCode) {
        // Go to puzzle #2
        Navigator.pushReplacementNamed(context, '/puzzle2');
      } else {
        _showError = true;
      }
    });
  }

  // A custom background
  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF47a8bd), Color(0xFFf1f2b5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          // The timer display in top-right
          const TimerDisplay(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Top row back button / puzzle label
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Text(
                          'Puzzle 1: CO₂ Lock',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48), // to balance spacing
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Puzzle instructions
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: const [
                          Text(
                            'You approach a locked control panel. '
                            'It asks for the “Safe CO₂ Limit (in ppm)”.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Hint: Some scientists note 350 ppm as a threshold.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Input field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _inputController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Enter CO₂ ppm code',
                            border: const OutlineInputBorder(),
                            errorText:
                                _showError ? 'Incorrect code. Try again.' : null,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: _checkCode,
                          child: const Text('Unlock'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// PUZZLE TWO SCREEN
///
/// A second puzzle to demonstrate multiple answers or different puzzle style.
/// Here, we have two text fields. Both must be correct to proceed.
class PuzzleTwoScreen extends StatefulWidget {
  const PuzzleTwoScreen({Key? key}) : super(key: key);

  @override
  State<PuzzleTwoScreen> createState() => _PuzzleTwoScreenState();
}

class _PuzzleTwoScreenState extends State<PuzzleTwoScreen> {
  // Suppose the correct answers are:
  //   Field #1: "green"
  //   Field #2: "earth"
  final _controllerOne = TextEditingController();
  final _controllerTwo = TextEditingController();

  bool _showError = false;

  void _checkAnswers() {
    String ans1 = _controllerOne.text.trim().toLowerCase();
    String ans2 = _controllerTwo.text.trim().toLowerCase();

    // If both answers are correct, success. Otherwise, show error.
    if (ans1 == 'green' && ans2 == 'earth') {
      // All puzzles solved -> Final success
      Navigator.pushReplacementNamed(context, '/success');
    } else {
      setState(() {
        _showError = true;
      });
    }
  }

  // A custom background
  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFEB692), Color(0xFFEA5455)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controllerOne.dispose();
    _controllerTwo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          // The timer in the top-right
          const TimerDisplay(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Top row back + label
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Text(
                          'Puzzle 2: Two-Word Code',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: const Text(
                        'Enter the 2-word phrase that describes a sustainable planet.\n'
                        '(Hint: First word is a color, second word is our home.)',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _controllerOne,
                          decoration: const InputDecoration(
                            labelText: 'Word 1 (Color)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _controllerTwo,
                          decoration: const InputDecoration(
                            labelText: 'Word 2 (Home)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (_showError)
                          const Text(
                            'Incorrect answer. Please try again.',
                            style: TextStyle(color: Colors.red),
                          ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _checkAnswers,
                          child: const Text('Submit'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// FINAL SUCCESS SCREEN
///
/// Shown if user completes both puzzles before time runs out.
class FinalSuccessScreen extends StatelessWidget {
  const FinalSuccessScreen({Key? key}) : super(key: key);

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          colors: [Colors.white, Colors.lightGreen],
          center: Alignment.center,
          radius: 1.2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Once we’re here, we can stop the timer
    GlobalTimer.stopTimer();

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Card(
                  color: Colors.white.withOpacity(0.9),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 32.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'All Puzzles Solved!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Congratulations! You solved all the puzzles '
                          'before time ran out. You saved the Climate Lab!',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            // Return to Home (and reset the game)
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/',
                              (route) => false,
                            );
                          },
                          child: const Text('Return to Home'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// GAME OVER SCREEN
///
/// Shown if time runs out before user completes all puzzles.
class GameOverScreen extends StatelessWidget {
  const GameOverScreen({Key? key}) : super(key: key);

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black, Colors.redAccent],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Timer should be stopped once we're here
    GlobalTimer.stopTimer();

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Card(
                  color: Colors.redAccent.withOpacity(0.9),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 32.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Time’s Up!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'You ran out of time before solving all puzzles. '
                          'The Climate Lab meltdown occurred!',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                          ),
                          onPressed: () {
                            // Return to Home
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/',
                              (route) => false,
                            );
                          },
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
