import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';

class LeaderboardWidget extends StatelessWidget {
  final List<Map<String, dynamic>> leaderboardData;

  const LeaderboardWidget({super.key, required this.leaderboardData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: leaderboardData.map((entry) {
        return ListTile(
          leading: CircleAvatar(child: Text(entry['rank'].toString())),
          title: Text(entry['name'], style: AppTextStyles.bodyLarge),
          trailing: Text('${entry['points']} pts', style: AppTextStyles.bodyMedium),
        );
      }).toList(),
    );
  }
}
