// import 'package:ecomentor/screens/courses/AQI_Science/c1_video_3.dart';
// import 'package:flutter/material.dart';
// import 'package:ecomentor/screens/courses/AQI_Science/c1_video_1.dart';
// import 'package:ecomentor/screens/courses/AQI_Science/c1_video_2.dart';

// class AQI_Science extends StatefulWidget {
//   const AQI_Science({super.key});

//   @override
//   _AQI_ScienceState createState() => _AQI_ScienceState();
// }

// class _AQI_ScienceState extends State<AQI_Science> {
//   int _score = 0;
//   int _questionIndex = 0;
//   String? _selectedAnswer;
//   bool _answered = false;

//   final List<Map<String, dynamic>> _quizQuestions = [
//     {
//       "question": "1. What does AQI stand for?",
//       "options": ["Air Quality Index", "Atmospheric Quota Indicator", "Air Quota Index", "Air Quantity Indicator"],
//       "answer": "Air Quality Index"
//     },
//     {
//       "question": "2. Which pollutant is NOT considered in AQI calculation?",
//       "options": ["PM2.5", "Carbon Monoxide", "Ozone", "Oxygen"],
//       "answer": "Oxygen"
//     },
//     {
//       "question": "3. What AQI range is considered 'Good'?",
//       "options": ["0-50", "51-100", "101-150", "151-200"],
//       "answer": "0-50"
//     },
//     {
//       "question": "4. Which factor does NOT affect AQI?",
//       "options": ["Temperature", "Wind speed", "Human respiration", "Industrial emissions"],
//       "answer": "Human respiration"
//     },
//     {
//       "question": "5. Which country uses the National Ambient Air Quality Standards (NAAQS) for AQI monitoring?",
//       "options": ["India", "China", "United States", "Germany"],
//       "answer": "United States"
//     },
//   ];

//   void _answerQuestion(String selectedOption) {
//     setState(() {
//       _selectedAnswer = selectedOption;
//       _answered = true;

//       if (_quizQuestions[_questionIndex]["answer"] == selectedOption) {
//         _score++;
//       }
//     });
//   }

//   void _nextQuestion() {
//     setState(() {
//       if (_questionIndex < _quizQuestions.length - 1) {
//         _questionIndex++;
//         _selectedAnswer = null;
//         _answered = false;
//       } else {
//         _showResultsDialog();
//       }
//     });
//   }

//   void _showResultsDialog() {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         title: const Text(
//           "Quiz Completed!",
//           textAlign: TextAlign.center,
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//         content: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Your Score: $_score / ${_quizQuestions.length}",
//                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
//                 textAlign: TextAlign.center,
//               ),
//               const Divider(),
//               const SizedBox(height: 8),
//               const Text("Review Your Answers:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 8),

//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: _quizQuestions.map((question) {
//                   return Padding(
//                     padding: const EdgeInsets.only(bottom: 8.0),
//                     child: RichText(
//                       text: TextSpan(
//                         style: const TextStyle(fontSize: 14, color: Colors.black),
//                         children: [
//                           TextSpan(text: "${question['question']}\n", style: const TextStyle(fontWeight: FontWeight.bold)),
//                           TextSpan(
//                             text: "Correct Answer: ${question['answer']}",
//                             style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               setState(() {
//                 _questionIndex = 0;
//                 _score = 0;
//                 _selectedAnswer = null;
//                 _answered = false;
//               });
//               Navigator.of(ctx).pop();
//             },
//             child: const Text("Restart Quiz", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.of(ctx).pop();
//             },
//             child: const Text("Close", style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold)),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('AQI & The Science of Air Pollution')),
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

//               _buildVideoTile(context, "Video 1: Understanding AQI & Air Pollution", "Learn about AQI, its calculation & impact.", const C1_video_1()),
//               const SizedBox(height: 16),
//               _buildVideoTile(context, "Video 2: How AQI is Calculated?", "Step-by-step guide on AQI calculations.", const C1_video_2()),
//               const SizedBox(height: 16),
//               _buildVideoTile(context, "Video 3: How Different Countries Monitor AQI?", "AQI calculations of Different Countries.", const C1_video_3()),

//               const SizedBox(height: 24),

//               const Text(
//                 "AQI Quiz",
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

//   Widget _buildVideoTile(BuildContext context, String title, String description, Widget destinationPage) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 3,
//       child: ListTile(
//         contentPadding: const EdgeInsets.all(16),
//         leading: const Icon(Icons.play_circle_fill, size: 40, color: Colors.blue),
//         title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//         subtitle: Text(description),
//         onTap: () {
//           Navigator.push(context, MaterialPageRoute(builder: (context) => destinationPage));
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
//                     onPressed: _answered ? null : () => _answerQuestion(option),
//                     child: Text(option),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: _selectedAnswer == option
//                           ? (_selectedAnswer == _quizQuestions[_questionIndex]["answer"] ? Colors.green : Colors.red)
//                           : null,
//                     ),
//                   ),
//                 ),
//               );
//             }).toList(),
//             if (_answered)
//               ElevatedButton(
//                 onPressed: _nextQuestion,
//                 child: const Text("Next Question"),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:ecomentor/screens/courses/AQI_Science/c1_video_3.dart';
import 'package:flutter/material.dart';
import 'package:ecomentor/screens/courses/AQI_Science/c1_video_1.dart';
import 'package:ecomentor/screens/courses/AQI_Science/c1_video_2.dart';

class AQI_Science extends StatefulWidget {
  const AQI_Science({super.key});

  @override
  _AQI_ScienceState createState() => _AQI_ScienceState();
}

class _AQI_ScienceState extends State<AQI_Science> {
  int _score = 0;
  int _questionIndex = 0;
  String? _selectedAnswer;
  bool _answered = false;

  final List<Map<String, dynamic>> _quizQuestions = [
    {
      "question": "1. What does AQI stand for?",
      "options": [
        "Air Quality Index",
        "Atmospheric Quota Indicator",
        "Air Quota Index",
        "Air Quantity Indicator"
      ],
      "answer": "Air Quality Index"
    },
    {
      "question": "2. Which pollutant is NOT considered in AQI calculation?",
      "options": ["PM2.5", "Carbon Monoxide", "Ozone", "Oxygen"],
      "answer": "Oxygen"
    },
    {
      "question": "3. What AQI range is considered 'Good'?",
      "options": ["0-50", "51-100", "101-150", "151-200"],
      "answer": "0-50"
    },
    {
      "question": "4. Which factor does NOT affect AQI?",
      "options": [
        "Temperature",
        "Wind speed",
        "Human respiration",
        "Industrial emissions"
      ],
      "answer": "Human respiration"
    },
    {
      "question":
          "5. Which country uses the National Ambient Air Quality Standards (NAAQS) for AQI monitoring?",
      "options": ["India", "China", "United States", "Germany"],
      "answer": "United States"
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
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
                textAlign: TextAlign.center,
              ),
              const Divider(),
              const SizedBox(height: 8),
              const Text("Review Your Answers:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _quizQuestions.map((question) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: RichText(
                      text: TextSpan(
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black),
                        children: [
                          TextSpan(
                              text: "${question['question']}\n",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                            text: "Correct Answer: ${question['answer']}",
                            style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
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
            child: const Text("Restart Quiz",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text("Close",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AQI & The Science of Air Pollution')),
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
                  "Video 1: Understanding AQI & Air Pollution",
                  "Learn about AQI, its calculation & impact.",
                  const C1_video_1()),
              const SizedBox(height: 16),
              _buildVideoTile(
                  context,
                  "Video 2: How AQI is Calculated?",
                  "Step-by-step guide on AQI calculations.",
                  const C1_video_2()),
              const SizedBox(height: 16),
              _buildVideoTile(
                  context,
                  "Video 3: How Different Countries Monitor AQI?",
                  "AQI calculations of Different Countries.",
                  const C1_video_3()),
              const SizedBox(height: 24),
              const Text(
                "AQI Quiz",
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

  Widget _buildVideoTile(BuildContext context, String title, String description,
      Widget destinationPage) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading:
            const Icon(Icons.play_circle_fill, size: 40, color: Colors.blue),
        title: Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => destinationPage));
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
            ...(_quizQuestions[_questionIndex]["options"] as List<String>)
                .map((option) {
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
