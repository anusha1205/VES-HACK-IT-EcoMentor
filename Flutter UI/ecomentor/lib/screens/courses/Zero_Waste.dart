import 'package:flutter/material.dart';
import 'package:ecomentor/screens/courses/Zero_Waste/c5_video_2.dart';
import 'package:ecomentor/screens/courses/Zero_Waste/c5_video_1.dart';

class Zero_Waste extends StatelessWidget {
  const Zero_Waste({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AQI & The Science of Air Pollution')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Course Videos",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Video 1 Box
            _buildVideoTile(
              context,
              title: "Video 1: Understanding AQI & Air Pollution",
              description: "Learn about AQI, its calculation & impact.",
              destinationPage: const C5_video_1(),
            ),

            const SizedBox(height: 16),

            // Video 2 Box
            _buildVideoTile(
              context,
              title: "Video 2: How AQI is Calculated?",
              description: "Step-by-step guide on AQI calculations.",
              destinationPage: const C5_video_2(),
            ),
          ],
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
}
