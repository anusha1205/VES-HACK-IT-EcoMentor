import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'waste_item.dart';
import 'waste_type.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int score = 0;
  int timeLeft = 10;
  int correctSorts = 0;
  int incorrectSorts = 0;
  List<WasteItem> activeWasteItems = [];
  final Random random = Random();
  late Timer gameTimer;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft <= 0) {
        endGame();
      } else {
        setState(() {
          timeLeft--;
          if (timeLeft % 2 == 0 || activeWasteItems.isEmpty) {
            addNewWasteItem();
          }
        });
      }
    });
  }

  void addNewWasteItem() {
    final screenSize = MediaQuery.of(context).size;
    final newItem = WasteItem.generateRandomItem(screenSize.width, screenSize.height);
    setState(() {
      activeWasteItems.add(newItem);
    });
  }

  void endGame() {
    gameTimer.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Game Over'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Score: $score'),
            Text('Correct: $correctSorts'),
            Text('Incorrect: $incorrectSorts'),
            Text('Incorrectly Placed: ${activeWasteItems.map((e) => e.name).join(", ")}')
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    gameTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: activeWasteItems.map((item) => Positioned(
          left: item.position.dx,
          top: item.position.dy,
          child: Icon(item.icon, size: 50, color: Colors.black),
        )).toList(),
      ),
    );
  }
}
  