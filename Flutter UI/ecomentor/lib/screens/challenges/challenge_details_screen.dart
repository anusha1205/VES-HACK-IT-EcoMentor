import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';

class ChallengeDetailsScreen extends StatefulWidget {
  final String title;

  const ChallengeDetailsScreen({super.key, required this.title});

  @override
  _ChallengeDetailsScreenState createState() => _ChallengeDetailsScreenState();
}

class _ChallengeDetailsScreenState extends State<ChallengeDetailsScreen> {
  int progress = 0; // Track progress locally
  static const int totalDays = 7; // Assuming all challenges are 7-day challenges

  @override
  void initState() {
    super.initState();
    _loadProgress(); // Load saved progress when screen opens
  }

  // Load saved progress from SharedPreferences
  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      progress = prefs.getInt(widget.title) ?? 0; // Default to 0 if no saved data
    });
  }

  // Mark challenge as completed for today
  Future<void> _completeToday() async {
    if (progress < totalDays) {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        progress++;
      });
      await prefs.setInt(widget.title, progress);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isCompleted = progress >= totalDays;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: AppTextStyles.h3.copyWith(color: Colors.white)),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Challenge Progress', style: AppTextStyles.h3),
            const SizedBox(height: 12),

            // Progress Bar
            LinearProgressIndicator(
              value: progress / totalDays,
              backgroundColor: AppColors.background,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
            ),
            const SizedBox(height: 12),

            // Progress Text
            Text(
              progress < totalDays
                  ? 'Day $progress of $totalDays'
                  : 'Challenge Completed! 🎉',
              style: AppTextStyles.bodyLarge,
            ),
            const SizedBox(height: 24),

            // Description
            Text(
              'Complete this challenge by following sustainable habits like reducing plastic usage, saving water, or using public transport!',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 24),

            // Mark as Completed Button
            ElevatedButton(
              onPressed: isCompleted ? null : _completeToday,
              style: ElevatedButton.styleFrom(
                backgroundColor: isCompleted ? Colors.grey : AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                isCompleted ? 'Challenge Completed!' : 'Mark as Completed Today',
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
