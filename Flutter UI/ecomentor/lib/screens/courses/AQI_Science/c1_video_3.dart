import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class C1_video_3 extends StatefulWidget {
  const C1_video_3({super.key});

  @override
  _C1_video_3State createState() => _C1_video_3State();
}

class _C1_video_3State extends State<C1_video_3> {
  late YoutubePlayerController _controller;
  bool isQuizVisible = false;

  final Map<int, String> correctAnswers = {
    0: 'The U.S., China, and India',
    1: 'Satellites and ground-based stations',
    2: 'Air Quality Index',
    3: 'Different pollutant limits',
    4: 'PM2.5 and PM10'
  };

  final List<String> questions = [
    'Which countries were mentioned in the video for their AQI monitoring?',
    'What are the two main technologies used for AQI tracking?',
    'What is the standard measure for tracking air pollution?',
    'How do AQI standards differ among countries?',
    'Which two pollutants are commonly measured worldwide?'
  ];

  final List<List<String>> options = [
    ['The U.S., China, and India', 'Only the U.S.', 'Only China', 'Germany and Japan'],
    ['Satellites and ground-based stations', 'Only satellites', 'Only air sensors', 'Drones'],
    ['Air Quality Index', 'Oxygen Index', 'Environmental Score', 'Carbon Rating'],
    ['Different pollutant limits', 'Same standards worldwide', 'Only India has limits', 'Only China monitors AQI'],
    ['PM2.5 and PM10', 'Carbon monoxide and methane', 'Sulfur dioxide and hydrogen', 'Oxygen and nitrogen']
  ];

  List<int?> selectedAnswers = List.filled(5, null);

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId('https://youtu.be/BF2-yxxEHKc')!,
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
      appBar: AppBar(title: const Text("Video 3: How Different Countries Monitor AQI")),
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
              "Different countries have their own methods and standards for monitoring and reporting air quality. Each country may use specific pollutants and measurement scales to track AQI. This section compares how nations like the U.S., China, and India assess air quality and the technologies they employ, including satellite monitoring and ground-based stations.",
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
