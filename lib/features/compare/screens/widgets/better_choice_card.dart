import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class BetterChoiceCard extends StatelessWidget {
  final String winnerLabel;
  final String reasonText;

  const BetterChoiceCard({
    super.key,
    required this.winnerLabel,
    required this.reasonText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.accent50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent100),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.accent500,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.emoji_events_outlined, color: AppColors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$winnerLabel is the better choice',
                  style: AppTextStyles.cardTitle.copyWith(color: AppColors.accent700),
                ),
                const SizedBox(height: 2),
                Text(reasonText, style: AppTextStyles.cardSubtitle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
