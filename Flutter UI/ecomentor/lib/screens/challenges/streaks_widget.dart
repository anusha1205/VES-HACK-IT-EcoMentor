import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';

class StreaksWidget extends StatelessWidget {
  final int streakDays;

  const StreaksWidget({super.key, required this.streakDays});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.local_fire_department, color: AppColors.warning, size: 32),
            const SizedBox(width: 12),
            Text('🔥 $streakDays-Day Streak!', style: AppTextStyles.h3),
          ],
        ),
      ),
    );
  }
}
