import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class DtiProgressBar extends StatelessWidget {
  final String label;
  final double percent;
  final String status; // 'Good', 'Fair', 'High'

  const DtiProgressBar({
    super.key,
    required this.label,
    required this.percent,
    required this.status,
  });

  Color get _barColor {
    switch (status) {
      case 'Fair':
        return AppColors.warning;
      case 'High':
        return AppColors.danger;
      default:
        return AppColors.success;
    }
  }

  Color get _badgeBackground {
    switch (status) {
      case 'Fair':
        return AppColors.warning.withValues(alpha: 0.12);
      case 'High':
        return AppColors.danger.withValues(alpha: 0.12);
      default:
        return AppColors.success.withValues(alpha: 0.12);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'DMSans',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.white : AppColors.neutral800,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: _badgeBackground,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '$status  ${percent.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontFamily: 'DMSans',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _barColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (percent / 100).clamp(0.0, 1.0),
            minHeight: 8,
            backgroundColor: isDark ? AppColors.darkElevated : AppColors.neutral200,
            valueColor: AlwaysStoppedAnimation<Color>(_barColor),
          ),
        ),
      ],
    );
  }
}
