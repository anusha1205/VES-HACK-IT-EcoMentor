import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'climate_words.dart';
import 'models.dart';
import 'timer_utils.dart';
import 'welcome_screen.dart';

class JumbledClimateScreen extends StatefulWidget {
  final Player player;

  JumbledClimateScreen({required this.player});

  @override
  _JumbledClimateScreenState createState() => _JumbledClimateScreenState();
}

class _JumbledClimateScreenState extends State<JumbledClimateScreen> {
  late List<ClimateWord> words;
  int currentWordIndex = 0;
  int score = 0;
  int timeLeft = 30;
  Timer? wordTimer;
  bool showingResult = false;
  TextEditingController answerController = TextEditingController();
  bool isCorrect = false;
  late String jumbledWord;
  int currentLevel = 1;

  @override
  void initState() {
    super.initState();
    _initializeWords();
    jumbledWord = _getJumbledWord(words[currentWordIndex].word);
    startWordTimer();
  }

  void _initializeWords() {
    words = List.from(climateWords)..shuffle(); // Shuffle words
    words = words.take(10).toList(); // Pick random 10 words
    words.sort((a, b) => a.level.compareTo(b.level)); // Ensure progression
    currentLevel = words[currentWordIndex].level;
  }

  void startWordTimer() {
    timeLeft = 30;
    showingResult = false;
    answerController.clear();
    wordTimer = TimerUtils.startCountdown(30, (remainingTime) {
      setState(() => timeLeft = remainingTime);
    }, checkAnswer);
  }

  String _getJumbledWord(String word) {
    List<String> characters = word.split('');
    characters.shuffle();
    return characters.join();
  }

  void checkAnswer() {
    wordTimer?.cancel();
    setState(() {
      showingResult = true;
      
      // Trim spaces and ensure case insensitivity
      String userAnswer = answerController.text.trim().toUpperCase();
      String correctAnswer = words[currentWordIndex].word.trim().toUpperCase();

      isCorrect = userAnswer == correctAnswer;

      if (isCorrect) {
        score += words[currentWordIndex].level * 10 + timeLeft; // More points for harder words
      }
      _showAnswerDialog();
    });

    Future.delayed(Duration(seconds: 2), () {
      if (currentWordIndex < words.length - 1) {
        setState(() {
          currentWordIndex++;
          jumbledWord = _getJumbledWord(words[currentWordIndex].word);
          showingResult = false;
          if (words[currentWordIndex].level > currentLevel) {
            currentLevel = words[currentWordIndex].level;
            _showLevelChangeDialog();
          } else {
            startWordTimer();
          }
        });
      } else {
        showFinalResults();
      }
    });
  }

  void _showAnswerDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(isCorrect ? '✅ Correct!' : '❌ Incorrect'),
        content: Text(isCorrect
            ? '${words[currentWordIndex].explanation}'
            : 'The correct word was: ${words[currentWordIndex].word}\n\n${words[currentWordIndex].explanation}'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLevelChangeDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('🌟 Level Up!'),
        content: Text('You have advanced to Level $currentLevel! Words will now be harder.'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              startWordTimer();
            },
            child: Text('Continue'),
          ),
        ],
      ),
    );
  }

  void showFinalResults() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('🎯 Game Complete!', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Final Score: $score',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Congratulations on completing the challenge!',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => WelcomeScreen()),
                (route) => false,
              );
            },
            child: Text('Back to Menu'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    wordTimer?.cancel();
    answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Jumbled Climate Words - Level $currentLevel'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TimerUtils.buildTimerBar(timeLeft, 30),
                SizedBox(height: 8),
                Text('Time Left: $timeLeft seconds',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                Text('Score: $score', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 24),
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          'Word ${currentWordIndex + 1}/${words.length}',
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                        SizedBox(height: 24),
                        Text(
                          jumbledWord,
                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 4),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Hint: ${words[currentWordIndex].hint}',
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32),
                          child: TextField(
                            controller: answerController,
                            decoration: InputDecoration(
                              labelText: 'Enter your answer',
                              border: OutlineInputBorder(),
                              suffixIcon: IconButton(icon: Icon(Icons.send), onPressed: checkAnswer),
                            ),
                            textCapitalization: TextCapitalization.characters,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20, letterSpacing: 2),
                            onSubmitted: (_) => checkAnswer(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
