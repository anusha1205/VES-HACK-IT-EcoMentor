import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class C1_video_1 extends StatefulWidget {
  const C1_video_1({super.key});

  @override
  _C1_video_1State createState() => _C1_video_1State();
}

class _C1_video_1State extends State<C1_video_1> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId:
          YoutubePlayer.convertUrlToId('https://youtu.be/8TT_hSdKm7E')!,
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
      appBar: AppBar(title: const Text("Video 1: Understanding AQI")),
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
              "The Air Quality Index (AQI) is a numerical scale used to measure and communicate the quality of air. It tracks pollutants in the atmosphere, such as particulate matter (PM2.5 and PM10), ground-level ozone, carbon monoxide, sulfur dioxide, and nitrogen dioxide. The AQI is calculated based on the concentration levels of these pollutants and is used to inform the public about the potential health impacts of air quality.",
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
