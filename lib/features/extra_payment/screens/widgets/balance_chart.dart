import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class BalanceChart extends StatelessWidget {
  final double extraPayment;

  const BalanceChart({super.key, required this.extraPayment});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.neutral200,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.show_chart,
              size: 40,
              color: AppColors.neutral300,
            ),
            const SizedBox(height: 8),
            const Text(
              'Balance chart — Phase 2',
              style: AppTextStyles.cardSubtitle,
            ),
          ],
        ),
      ),
    );
  }
}
