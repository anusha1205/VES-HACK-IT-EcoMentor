import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';

class BadgesWidget extends StatelessWidget {
  final List<String> unlockedBadges;

  const BadgesWidget({super.key, required this.unlockedBadges});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('🏅 Earned Badges', style: AppTextStyles.h3),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          children: [
            for (var badge in ['Plastic-Free', 'Water Saver', 'Eco Warrior'])
              _buildBadge(badge, unlockedBadges.contains(badge)),
          ],
        ),
      ],
    );
  }

  Widget _buildBadge(String title, bool unlocked) {
    return Chip(
      label: Text(title),
      backgroundColor: unlocked ? AppColors.success : AppColors.background,
    );
  }
}
