import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class MetricRow extends StatelessWidget {
  final String label;
  final String loan1Value;
  final String loan2Value;
  final bool lowerIsBetter;
  final int betterIndex; // 0 = loan1, 1 = loan2, -1 = tie
  final bool isLast;

  const MetricRow({
    super.key,
    required this.label,
    required this.loan1Value,
    required this.loan2Value,
    required this.lowerIsBetter,
    this.betterIndex = -1,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.neutral200,
                ),
              ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              loan1Value,
              style: AppTextStyles.cardValue.copyWith(
                color: betterIndex == 0 ? AppColors.brand800 : AppColors.neutral900,
                fontWeight: betterIndex == 0 ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.cardSubtitle,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              loan2Value,
              style: AppTextStyles.cardValue.copyWith(
                color: betterIndex == 1 ? AppColors.accent700 : AppColors.neutral900,
                fontWeight: betterIndex == 1 ? FontWeight.w600 : FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
