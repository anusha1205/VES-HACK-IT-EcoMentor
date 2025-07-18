import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class C2_video_2 extends StatefulWidget {
  const C2_video_2({super.key});

  @override
  _C2_video_2State createState() => _C2_video_2State();
}

class _C2_video_2State extends State<C2_video_2> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId('https://youtu.be/AAvptN_TcOQ')!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Video 2: How AQI is Calculated?")),
      body: Padding(
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
              "Your carbon footprint is a measure of how daily activities impact the planet, from driving to food choices. The average person emits around 4 tons of CO2 annually—equivalent to 800 elephants in weight! Simple changes, like switching to LED bulbs or washing clothes in cold water, can significantly reduce emissions. By focusing on key areas like housing, travel, and consumption, you can make a big difference.",
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
