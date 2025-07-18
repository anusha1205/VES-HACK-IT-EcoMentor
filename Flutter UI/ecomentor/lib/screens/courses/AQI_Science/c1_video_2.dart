import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class C1_video_2 extends StatefulWidget {
  const C1_video_2({super.key});

  @override
  _C1_video_2State createState() => _C1_video_2State();
}

class _C1_video_2State extends State<C1_video_2> {
  late YoutubePlayerController _controller;
  bool isQuizVisible = false;

  final Map<int, String> correctAnswers = {
    0: 'Respiratory issues',
    1: 'Greenhouse gases',
    2: 'Carbon dioxide and methane',
    3: 'Air pollution',
    4: 'Particulate matter and gases'
  };

  final List<String> questions = [
    'What health problems can poor air quality cause?',
    'What type of gases contribute to climate change?',
    'Which two pollutants are highlighted in relation to climate change?',
    'What is one of the main causes of global warming?',
    'What does air pollution mainly consist of?'
  ];

  final List<List<String>> options = [
    ['Respiratory issues', 'Better lung function', 'Increased oxygen levels', 'Improved metabolism'],
    ['Greenhouse gases', 'Oxygen', 'Nitrogen', 'Hydrogen'],
    ['Carbon dioxide and methane', 'Sulfur dioxide and ozone', 'Nitrogen and oxygen', 'PM10 and PM2.5'],
    ['Air pollution', 'Good air circulation', 'Lower temperatures', 'More trees'],
    ['Particulate matter and gases', 'Only water vapor', 'Just nitrogen', 'Pure oxygen']
  ];

  List<int?> selectedAnswers = List.filled(5, null);

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId('https://youtu.be/WQBN08eZq8Q')!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: true,
      ),
    );

    _controller.addListener(() {
      if (_controller.value.playerState == PlayerState.ended && !isQuizVisible) {
        setState(() {
          isQuizVisible = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void checkAnswers() {
    int score = 0;
    for (int i = 0; i < questions.length; i++) {
      if (selectedAnswers[i] != null &&
          options[i][selectedAnswers[i]!] == correctAnswers[i]) {
        score++;
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Quiz Result"),
          content: Text("You scored $score/${questions.length}!"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Video 2: Health & Climate Effects of Bad Air")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              "About this Video",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Poor air quality can lead to various health problems, including respiratory issues, heart disease, and aggravated allergies. Long-term exposure to polluted air also contributes to climate change by releasing greenhouse gases that trap heat in the atmosphere. This section explores the connection between air pollution and human health, as well as its broader impact on global climates.",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 32),

            // Quiz Section
            if (isQuizVisible)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Quiz Time!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            questions[index],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          ...List.generate(options[index].length, (optIndex) {
                            return RadioListTile<int>(
                              title: Text(options[index][optIndex]),
                              value: optIndex,
                              groupValue: selectedAnswers[index],
                              onChanged: (value) {
                                setState(() {
                                  selectedAnswers[index] = value;
                                });
                              },
                            );
                          }),
                          const SizedBox(height: 8),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: checkAnswers,
                      child: const Text('Submit Quiz'),
                    ),
                  ),
                ],
              )
            else
              const Center(
                child: Text(
                  "Watch the full video to unlock the quiz!",
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
