import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import 'challenge_details_screen.dart';

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});

  @override
  _ChallengesScreenState createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  Map<String, int> challengeProgress = {}; // Stores progress for each challenge

  @override
  void initState() {
    super.initState();
    _loadAllProgress();
  }

  // Load progress for all challenges from SharedPreferences
  Future<void> _loadAllProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      challengeProgress = {
        '7-Day Plastic-Free Streak': prefs.getInt('7-Day Plastic-Free Streak') ?? 0,
        'Water Conservation Streak': prefs.getInt('Water Conservation Streak') ?? 0,
        'Eco Travel Streak': prefs.getInt('Eco Travel Streak') ?? 0,
        'Earth Day Challenge': prefs.getInt('Earth Day Challenge') ?? 0,
        'Energy Saver Week': prefs.getInt('Energy Saver Week') ?? 0,
        'Tree Planting Challenge': prefs.getInt('Tree Planting Challenge') ?? 0,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Challenges', style: AppTextStyles.h3.copyWith(color: Colors.white)),
          backgroundColor: AppColors.primary,
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: const [
              Tab(text: '🔥 Streak'),
              Tab(text: '🌱 Themed'),
              Tab(text: '🏆 Leaderboard'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            StreakChallengesTab(challengeProgress: challengeProgress, onProgressUpdated: _loadAllProgress),
            ThemedChallengesTab(challengeProgress: challengeProgress, onProgressUpdated: _loadAllProgress),
            const LeaderboardTab(),
          ],
        ),
      ),
    );
  }
}

// 🏆 Streak Challenges Tab
class StreakChallengesTab extends StatelessWidget {
  final Map<String, int> challengeProgress;
  final VoidCallback onProgressUpdated;

  const StreakChallengesTab({super.key, required this.challengeProgress, required this.onProgressUpdated});

  @override
  Widget build(BuildContext context) {
    return _buildChallengeList(context, [
      {'title': '7-Day Plastic-Free Streak', 'icon': Icons.recycling, 'desc': 'Avoid plastic for 7 days & earn a badge!'},
      {'title': 'Water Conservation Streak', 'icon': Icons.water_drop, 'desc': 'Track your water savings daily!'},
      {'title': 'Eco Travel Streak', 'icon': Icons.directions_bike, 'desc': 'Use public transport or cycle for 5 days!'},
    ]);
  }

  Widget _buildChallengeList(BuildContext context, List<Map<String, dynamic>> challenges) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: challenges.length,
      itemBuilder: (context, index) {
        final challenge = challenges[index];
        return _buildChallengeCard(context, challenge['title'], challenge['icon'], challenge['desc']);
      },
    );
  }

  Widget _buildChallengeCard(BuildContext context, String title, IconData icon, String description) {
    int progress = challengeProgress[title] ?? 0;
    int totalDays = 7; 

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 40, color: AppColors.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.h3.copyWith(fontSize: 16)),
                  const SizedBox(height: 6),
                  Text(description, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 12),

                  // Progress Bar
                  LinearProgressIndicator(
                    value: progress / totalDays,
                    backgroundColor: AppColors.background,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
                  ),
                  const SizedBox(height: 8),

                  // Progress Text
                  Text(
                    'Day $progress of $totalDays',
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 12),

                  ElevatedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChallengeDetailsScreen(title: title),
                        ),
                      );
                      onProgressUpdated(); // Refresh progress when returning
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('View Challenge', style: AppTextStyles.bodyMedium.copyWith(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🌱 Themed Challenges Tab
class ThemedChallengesTab extends StatelessWidget {
  final Map<String, int> challengeProgress;
  final VoidCallback onProgressUpdated;

  const ThemedChallengesTab({super.key, required this.challengeProgress, required this.onProgressUpdated});

  @override
  Widget build(BuildContext context) {
    return _buildChallengeList(context, [
      {'title': 'Earth Day Challenge', 'icon': Icons.public, 'desc': 'Complete eco-friendly tasks for Earth Day!'},
      {'title': 'Energy Saver Week', 'icon': Icons.lightbulb, 'desc': 'Reduce electricity usage for a week!'},
      {'title': 'Tree Planting Challenge', 'icon': Icons.park, 'desc': 'Plant 5 trees and log your progress!'},
    ]);
  }

  Widget _buildChallengeList(BuildContext context, List<Map<String, dynamic>> challenges) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: challenges.length,
      itemBuilder: (context, index) {
        final challenge = challenges[index];
        return StreakChallengesTab(
          challengeProgress: challengeProgress,
          onProgressUpdated: onProgressUpdated,
        )._buildChallengeCard(context, challenge['title'], challenge['icon'], challenge['desc']);
      },
    );
  }
}

// 🏆 Leaderboard Tab (Unchanged)
class LeaderboardTab extends StatelessWidget {
  const LeaderboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> leaderboard = [
      {'rank': 1, 'name': 'Alice', 'points': 1200},
      {'rank': 2, 'name': 'Bob', 'points': 1100},
      {'rank': 3, 'name': 'Charlie', 'points': 1050},
      {'rank': 4, 'name': 'David', 'points': 980},
      {'rank': 5, 'name': 'Emma', 'points': 950},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: leaderboard.length,
      itemBuilder: (context, index) {
        final entry = leaderboard[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary,
              child: Text(entry['rank'].toString(), style: AppTextStyles.bodyMedium.copyWith(color: Colors.white)),
            ),
            title: Text(entry['name'], style: AppTextStyles.h3.copyWith(fontSize: 16)),
            trailing: Text('${entry['points']} pts', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.success)),
          ),
        );
      },
    );
  }
}
