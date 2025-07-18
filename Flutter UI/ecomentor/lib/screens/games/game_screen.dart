import 'dart:async';
import 'package:flutter/material.dart';
import 'models.dart';
import 'timer_utils.dart';
import 'welcome_screen.dart';

class GameScreen extends StatefulWidget {
  final List<Player> players;
  final bool isSinglePlayer;

  GameScreen({required this.players, required this.isSinglePlayer});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<Question> questions;
  int currentQuestionIndex = 0;
  int currentPlayerIndex = 0;
  int timeLeft = 20;
  Timer? questionTimer;
  bool showingResults = false;
  bool isCorrect = false;
  String selectedAnswer = '';

  @override
  void initState() {
    super.initState();
    _initializeQuestions();
    startQuestionTimer();
  }

  void _initializeQuestions() {
    questions = [
      Question(
        text: "Which greenhouse gas has the highest global warming potential?",
        options: ["Carbon dioxide", "Methane", "Sulfur hexafluoride", "Nitrous oxide"],
        correctAnswer: "Sulfur hexafluoride",
        explanation: "Sulfur hexafluoride has a global warming potential 23,500 times that of CO2!",
      ),
      Question(
        text: "What percentage of global greenhouse gas emissions come from transportation?",
        options: ["5%", "15%", "25%", "35%"],
        correctAnswer: "15%",
        explanation: "Transportation accounts for about 15% of global greenhouse gas emissions.",
      ),
      Question(
        text: "Which renewable energy source produces the most electricity worldwide?",
        options: ["Solar", "Wind", "Hydropower", "Geothermal"],
        correctAnswer: "Hydropower",
        explanation: "Hydropower is the largest source of renewable electricity globally.",
      ),
      Question(
        text: "What is the primary cause of ocean acidification?",
        options: ["Plastic pollution", "Oil spills", "Carbon dioxide emissions", "Deforestation"],
        correctAnswer: "Carbon dioxide emissions",
        explanation: "CO2 dissolves in seawater, lowering its pH and causing acidification.",
      ),
      Question(
        text: "What is the largest contributor to deforestation?",
        options: ["Urban expansion", "Agriculture", "Logging", "Infrastructure development"],
        correctAnswer: "Agriculture",
        explanation: "Agriculture is responsible for about 80% of global deforestation.",
      ),
    ];
  }

  void startQuestionTimer() {
    timeLeft = 20;
    showingResults = false;
    selectedAnswer = '';

    questionTimer = TimerUtils.startCountdown(20, (remainingTime) {
      setState(() => timeLeft = remainingTime);
    }, () {
      submitAnswer('');
    });
  }

  void submitAnswer(String answer) {
    questionTimer?.cancel();
    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == questions[currentQuestionIndex].correctAnswer;
      showingResults = true;

      if (isCorrect) {
        widget.players[currentPlayerIndex].score += questions[currentQuestionIndex].points;
      }
    });

    Future.delayed(Duration(seconds: 2), () {
      if (currentQuestionIndex < questions.length - 1) {
        setState(() {
          currentQuestionIndex++;
          startQuestionTimer();
        });
      } else {
        showFinalResults();
      }
    });
  }

  void showFinalResults() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('🏆 Game Complete!', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: widget.players.map((player) {
            return ListTile(
              leading: Text('${player.avatar} ${player.name}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              trailing: Text('${player.score}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            );
          }).toList(),
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
    questionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSinglePlayer ? 'Single Player' : 'Multiplayer Challenge'),
        backgroundColor: Colors.green.shade600, // Thematic color
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Timer Bar
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      Text(
                        'Time Left: $timeLeft seconds',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      LinearProgressIndicator(
                        value: timeLeft / 20,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation(Colors.green.shade600),
                        minHeight: 8,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Player Scores
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: widget.players.map((player) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          '${player.avatar} ${player.name}: ${player.score}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 24),

                // Question Card
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          'Question ${currentQuestionIndex + 1}/${questions.length}',
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                        SizedBox(height: 16),
                        Text(
                          questions[currentQuestionIndex].text,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24),

                        // Answer Buttons
                        Column(
                          children: questions[currentQuestionIndex].options.map((option) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: ElevatedButton(
                                onPressed: showingResults ? null : () => submitAnswer(option),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  backgroundColor: showingResults
                                      ? (option == questions[currentQuestionIndex].correctAnswer
                                          ? Colors.green
                                          : Colors.red)
                                      : Colors.grey.shade200,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: Text(option, style: TextStyle(fontSize: 16, color: Colors.black)),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // Result Explanation (One-Line)
                if (showingResults)
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isCorrect ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isCorrect
                          ? "✅ Correct! ${questions[currentQuestionIndex].explanation}"
                          : "❌ Incorrect! The right answer is: ${questions[currentQuestionIndex].correctAnswer}. ${questions[currentQuestionIndex].explanation}",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
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
