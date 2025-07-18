// import 'package:flutter/material.dart';
// // import 'package:ecomentor/screens/courses/Carbon_Footprint/c2_video_1.dart';
// // import 'package:ecomentor/screens/courses/Carbon_Footprint/c2_video_2.dart';
// class Carbon_Footprint extends StatefulWidget {
//   const Carbon_Footprint({super.key});

//   @override
//   _Carbon_FootprintState createState() => _Carbon_FootprintState();
// }

// class _Carbon_FootprintState extends State<Carbon_Footprint> {
//   int _score = 0;
//   int _questionIndex = 0;

//   final List<Map<String, dynamic>> _quizQuestions = [
//     {
//       "question": "1. How much CO2 does the average person release just from breathing per day?",
//       "options": ["0.5 kilograms", "1 kilogram", "2 kilograms", "3 kilograms"],
//       "answer": "1 kilogram"
//     },
//     {
//       "question": "2. What percentage of your carbon footprint comes from the top five daily activities (housing, travel, food, products, and services)?",
//       "options": ["40%", "50%", "60%", "70%"],
//       "answer": "60%"
//     },
//     {
//       "question": "3. How much CO2 is produced per mile when driving a car?",
//       "options": ["204 grams", "304 grams", "404 grams", "504 grams"],
//       "answer": "404 grams"
//     },
//     {
//       "question": "4. How many kilograms of CO2 does beef production generate per kilogram of meat?",
//       "options": ["20 kilograms", "40 kilograms", "60 kilograms", "80 kilograms"],
//       "answer": "60 kilograms"
//     },
//     {
//       "question": "5. How much CO2 is saved annually by switching to LED bulbs?",
//       "options": ["500 pounds", "750 pounds", "1,000 pounds", "1,250 pounds"],
//       "answer": "1,000 pounds"
//     },
//     {
//       "question": "6. What's the average annual carbon footprint of an American?",
//       "options": ["8 tons", "12 tons", "16 tons", "20 tons"],
//       "answer": "16 tons"
//     },
//     {
//       "question": "7. How much CO2 is produced per kilowatt-hour when using coal power?",
//       "options": ["0.45 pounds", "0.65 pounds", "0.85 pounds", "1.05 pounds"],
//       "answer": "0.85 pounds"
//     },
//     {
//       "question": "8. How much CO2 is generated in manufacturing a single smartphone?",
//       "options": ["50 kilograms", "60 kilograms", "70 kilograms", "80 kilograms"],
//       "answer": "70 kilograms"
//     }
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
//       appBar: AppBar(title: const Text('Understanding Carbon Footprint')),
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
//                 title: "Video 1: Carbon Footprint: Your Climate Impact Score",
//                 description: "Learn about daily activities and their CO2 impact.",
//                 destinationPage: Container(), // Replace with your video screen
//               ),

//               const SizedBox(height: 16),

//               // Video 2 Box
//               _buildVideoTile(
//                 context,
//                 title: "Video 2: Carbon Footprint Calculation",
//                 description: "Breaking down the numbers and calculations.",
//                 destinationPage: Container(), // Replace with your video screen
//               ),

//               const SizedBox(height: 24),

//               const Text(
//                 "Carbon Footprint Quiz",
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
// import 'package:ecomentor/screens/courses/Carbon_Footprint/c2_video_1.dart';
// import 'package:ecomentor/screens/courses/Carbon_Footprint/c2_video_2.dart';

class Carbon_Footprint extends StatefulWidget {
  const Carbon_Footprint({super.key});

  @override
  _Carbon_FootprintState createState() => _Carbon_FootprintState();
}

class _Carbon_FootprintState extends State<Carbon_Footprint> {
  int _score = 0;
  int _questionIndex = 0;
  String? _selectedAnswer;
  bool _answered = false;

  final List<Map<String, dynamic>> _quizQuestions = [
    {
      "question": "1. How much CO2 does the average person release just from breathing per day?",
      "options": ["0.5 kilograms", "1 kilogram", "2 kilograms", "3 kilograms"],
      "answer": "1 kilogram"
    },
    {
      "question": "2. What percentage of your carbon footprint comes from the top five daily activities (housing, travel, food, products, and services)?",
      "options": ["40%", "50%", "60%", "70%"],
      "answer": "60%"
    },
    {
      "question": "3. How much CO2 is produced per mile when driving a car?",
      "options": ["204 grams", "304 grams", "404 grams", "504 grams"],
      "answer": "404 grams"
    },
    {
      "question": "4. How many kilograms of CO2 does beef production generate per kilogram of meat?",
      "options": ["20 kilograms", "40 kilograms", "60 kilograms", "80 kilograms"],
      "answer": "60 kilograms"
    },
    {
      "question": "5. How much CO2 is saved annually by switching to LED bulbs?",
      "options": ["500 pounds", "750 pounds", "1,000 pounds", "1,250 pounds"],
      "answer": "1,000 pounds"
    },
    {
      "question": "6. What's the average annual carbon footprint of an American?",
      "options": ["8 tons", "12 tons", "16 tons", "20 tons"],
      "answer": "16 tons"
    },
    {
      "question": "7. How much CO2 is produced per kilowatt-hour when using coal power?",
      "options": ["0.45 pounds", "0.65 pounds", "0.85 pounds", "1.05 pounds"],
      "answer": "0.85 pounds"
    },
    {
      "question": "8. How much CO2 is generated in manufacturing a single smartphone?",
      "options": ["50 kilograms", "60 kilograms", "70 kilograms", "80 kilograms"],
      "answer": "70 kilograms"
    }
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
      appBar: AppBar(title: const Text('Understanding Carbon Footprint')),
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
                title: "Video 1: Carbon Footprint: Your Climate Impact Score",
                description: "Learn about daily activities and their CO2 impact.",
                destinationPage: Container(), // Replace with your video screen
              ),

              const SizedBox(height: 16),

              _buildVideoTile(
                context,
                title: "Video 2: Carbon Footprint Calculation",
                description: "Breaking down the numbers and calculations.",
                destinationPage: Container(), // Replace with your video screen
              ),

              const SizedBox(height: 24),

              const Text(
                "Carbon Footprint Quiz",
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