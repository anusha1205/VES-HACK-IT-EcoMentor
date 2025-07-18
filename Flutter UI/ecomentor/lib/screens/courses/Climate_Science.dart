// import 'package:flutter/material.dart'; 

// class Climate_Science extends StatefulWidget {
//   const Climate_Science({super.key});

//   @override
//   _Climate_ScienceState createState() => _Climate_ScienceState();
// }

// class _Climate_ScienceState extends State<Climate_Science> {
//   int _score = 0;
//   int _questionIndex = 0;

//   final List<Map<String, dynamic>> _quizQuestions = [
//     {
//       "question": "1. What is the primary greenhouse gas responsible for climate change?",
//       "options": ["Carbon dioxide", "Methane", "Water vapor", "Nitrous oxide"],
//       "answer": "Carbon dioxide"
//     },
//     {
//       "question": "2. What is the difference between weather and climate?",
//       "options": [
//         "Weather is long-term, climate is short-term", 
//         "Weather is short-term, climate is long-term", 
//         "They are the same thing", 
//         "Weather is global, climate is local"
//       ],
//       "answer": "Weather is short-term, climate is long-term"
//     },
//     {
//       "question": "3. Which of these is NOT a direct effect of global warming?",
//       "options": [
//         "Rising sea levels", 
//         "Increased volcanic activity", 
//         "Extreme weather events", 
//         "Melting glaciers"
//       ],
//       "answer": "Increased volcanic activity"
//     },
//     {
//       "question": "4. What is the Keeling Curve used to measure?",
//       "options": [
//         "Ocean temperatures", 
//         "Atmospheric CO2 levels", 
//         "Sea level rise", 
//         "Arctic ice coverage"
//       ],
//       "answer": "Atmospheric CO2 levels"
//     },
//     {
//       "question": "5. Which international agreement aims to limit global temperature rise to well below 2°C?",
//       "options": [
//         "Kyoto Protocol", 
//         "Montreal Protocol", 
//         "Paris Agreement", 
//         "Copenhagen Accord"
//       ],
//       "answer": "Paris Agreement"
//     },
//   ];

//   void _answerQuestion(String selectedOption) {
//     if (_quizQuestions[_questionIndex]["answer"] == selectedOption) {
//       _score++;
//     }

//     setState(() {
//       if (_questionIndex < _quizQuestions.length - 1) {
//         _questionIndex++;
//       } else {
//         _showResultsDialog();
//       }
//     });
//   }

//   void _showResultsDialog() {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text("Quiz Completed!"),
//         content: Text("Your Score: $_score / ${_quizQuestions.length}"),
//         actions: [
//           TextButton(
//             onPressed: () {
//               setState(() {
//                 _questionIndex = 0;
//                 _score = 0;
//               });
//               Navigator.of(ctx).pop();
//             },
//             child: const Text("Restart Quiz"),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Climate Science & Global Change')),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Course Videos",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 16),
              
//               // Video 1 Box
//               _buildVideoTile(
//                 context,
//                 title: "Video 1: Introduction to Climate Science",
//                 description: "Learn about climate systems and global warming basics.",
//                 destinationPage: Container(), // Replace with your video screen
//               ),

//               const SizedBox(height: 16),

//               // Video 2 Box
//               _buildVideoTile(
//                 context,
//                 title: "Video 2: Greenhouse Effect & Global Warming",
//                 description: "Understanding greenhouse gases and their impact.",
//                 destinationPage: Container(), // Replace with your video screen
//               ),

//               const SizedBox(height: 16),

//               // Video 3 Box
//               _buildVideoTile(
//                 context,
//                 title: "Video 3: Climate Change Solutions",
//                 description: "Exploring ways to combat climate change.",
//                 destinationPage: Container(), // Replace with your video screen
//               ),

//               const SizedBox(height: 24),

//               const Text(
//                 "Climate Science Quiz",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 16),

//               _buildQuizCard(),
//               const SizedBox(height: 16),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildVideoTile(BuildContext context, {required String title, required String description, required Widget destinationPage}) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 3,
//       child: ListTile(
//         contentPadding: const EdgeInsets.all(16),
//         leading: const Icon(Icons.play_circle_fill, size: 40, color: Colors.blue),
//         title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//         subtitle: Text(description),
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => destinationPage),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildQuizCard() {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 3,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               _quizQuestions[_questionIndex]["question"],
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             ...(_quizQuestions[_questionIndex]["options"] as List<String>).map((option) {
//               return Padding(
//                 padding: const EdgeInsets.only(bottom: 8.0),
//                 child: SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: () => _answerQuestion(option),
//                     child: Text(option),
//                   ),
//                 ),
//               );
//             }).toList(),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart'; 

class Climate_Science extends StatefulWidget {
  const Climate_Science({super.key});

  @override
  _Climate_ScienceState createState() => _Climate_ScienceState();
}

class _Climate_ScienceState extends State<Climate_Science> {
  int _score = 0;
  int _questionIndex = 0;
  String? _selectedAnswer;
  bool _answered = false;

  final List<Map<String, dynamic>> _quizQuestions = [
    {
      "question": "1. What is the primary greenhouse gas responsible for climate change?",
      "options": ["Carbon dioxide", "Methane", "Water vapor", "Nitrous oxide"],
      "answer": "Carbon dioxide"
    },
    {
      "question": "2. What is the difference between weather and climate?",
      "options": [
        "Weather is long-term, climate is short-term", 
        "Weather is short-term, climate is long-term", 
        "They are the same thing", 
        "Weather is global, climate is local"
      ],
      "answer": "Weather is short-term, climate is long-term"
    },
    {
      "question": "3. Which of these is NOT a direct effect of global warming?",
      "options": [
        "Rising sea levels", 
        "Increased volcanic activity", 
        "Extreme weather events", 
        "Melting glaciers"
      ],
      "answer": "Increased volcanic activity"
    },
    {
      "question": "4. What is the Keeling Curve used to measure?",
      "options": [
        "Ocean temperatures", 
        "Atmospheric CO2 levels", 
        "Sea level rise", 
        "Arctic ice coverage"
      ],
      "answer": "Atmospheric CO2 levels"
    },
    {
      "question": "5. Which international agreement aims to limit global temperature rise to well below 2°C?",
      "options": [
        "Kyoto Protocol", 
        "Montreal Protocol", 
        "Paris Agreement", 
        "Copenhagen Accord"
      ],
      "answer": "Paris Agreement"
    },
  ];

  void _answerQuestion(String selectedOption) {
    setState(() {
      _selectedAnswer = selectedOption;
      _answered = true;

      if (_quizQuestions[_questionIndex]["answer"] == selectedOption) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      if (_questionIndex < _quizQuestions.length - 1) {
        _questionIndex++;
        _selectedAnswer = null;
        _answered = false;
      } else {
        _showResultsDialog();
      }
    });
  }

  void _showResultsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          "Quiz Completed!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Your Score: $_score / ${_quizQuestions.length}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                textAlign: TextAlign.center,
              ),
              const Divider(),
              const SizedBox(height: 8),
              const Text("Review Your Answers:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _quizQuestions.map((question) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 14, color: Colors.black),
                        children: [
                          TextSpan(text: "${question['question']}\n", style: const TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                            text: "Correct Answer: ${question['answer']}",
                            style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _questionIndex = 0;
                _score = 0;
                _selectedAnswer = null;
                _answered = false;
              });
              Navigator.of(ctx).pop();
            },
            child: const Text("Restart Quiz", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text("Close", style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Climate Science & Global Change')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Course Videos",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              
              _buildVideoTile(
                context,
                title: "Video 1: Introduction to Climate Science",
                description: "Learn about climate systems and global warming basics.",
                destinationPage: Container(),
              ),

              const SizedBox(height: 16),

              _buildVideoTile(
                context,
                title: "Video 2: Greenhouse Effect & Global Warming",
                description: "Understanding greenhouse gases and their impact.",
                destinationPage: Container(),
              ),

              const SizedBox(height: 16),

              _buildVideoTile(
                context,
                title: "Video 3: Climate Change Solutions",
                description: "Exploring ways to combat climate change.",
                destinationPage: Container(),
              ),

              const SizedBox(height: 24),

              const Text(
                "Climate Science Quiz",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              _buildQuizCard(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoTile(BuildContext context, {required String title, required String description, required Widget destinationPage}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: const Icon(Icons.play_circle_fill, size: 40, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destinationPage),
          );
        },
      ),
    );
  }

  Widget _buildQuizCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _quizQuestions[_questionIndex]["question"],
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...(_quizQuestions[_questionIndex]["options"] as List<String>).map((option) {
              final correctAnswer = _quizQuestions[_questionIndex]["answer"];
              final isSelected = _selectedAnswer == option;
              final isCorrectAnswer = option == correctAnswer;
              
              // Determine button color
              Color? buttonColor;
              if (_answered) {
                if (isCorrectAnswer) {
                  buttonColor = Colors.green;
                } else if (isSelected) {
                  buttonColor = Colors.red;
                }
              }

              // Determine text color
              Color textColor = Colors.white;
              if (_answered && (isCorrectAnswer || isSelected)) {
                textColor = Colors.white;
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _answered ? null : () => _answerQuestion(option),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      disabledBackgroundColor: buttonColor,
                    ),
                    child: Text(
                      option,
                      style: TextStyle(color: textColor),
                    ),
                  ),
                ),
              );
            }).toList(),
            if (_answered)
              ElevatedButton(
                onPressed: _nextQuestion,
                child: const Text("Next Question"),
              ),
          ],
        ),
      ),
    );
  }
}