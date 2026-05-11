import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class MaxHomeCard extends StatelessWidget {
  final String maxHomePrice;
  final String statusLabel;
  final String statusDescription;

  const MaxHomeCard({
    super.key,
    required this.maxHomePrice,
    required this.statusLabel,
    required this.statusDescription,
  });

  Color get _statusColor {
    switch (statusLabel) {
      case 'Fair':
        return AppColors.warning;
      case 'High':
        return AppColors.danger;
      default:
        return AppColors.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.accent700, AppColors.accent500],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'You Can Afford',
                      style: AppTextStyles.heroLabel.copyWith(
                        color: AppColors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      maxHomePrice,
                      style: AppTextStyles.heroAmountLarge.copyWith(
                        color: AppColors.white,
                        fontSize: 32,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusLabel,
                  style: const TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            statusDescription,
            style: TextStyle(
              fontFamily: 'DMSans',
              fontSize: 13,
              color: AppColors.white.withValues(alpha: 0.8),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
