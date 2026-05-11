import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class SavingsSummaryCard extends StatelessWidget {
  final String interestSaved;
  final String yearsSaved;
  final String newPayoffDate;
  final String originalPayoffDate;

  const SavingsSummaryCard({
    super.key,
    required this.interestSaved,
    required this.yearsSaved,
    required this.newPayoffDate,
    required this.originalPayoffDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.accent700, Color(0xFF005A44)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('YOU COULD SAVE', style: TextStyle(
            fontFamily: 'DMSans',
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: AppColors.accent100,
            letterSpacing: 0.07,
          )),
          const SizedBox(height: 4),
          Text(
            interestSaved,
            style: AppTextStyles.heroAmountLarge.copyWith(color: AppColors.white),
          ),
          const SizedBox(height: 4),
          Text(
            'in interest · Pay off $yearsSaved sooner',
            style: const TextStyle(
              fontFamily: 'DMSans',
              fontSize: 12,
              color: AppColors.accent100,
            ),
          ),
          const SizedBox(height: 20),
          Container(height: 1, color: AppColors.accent100.withAlpha(60)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _DateCol(label: 'New Payoff', value: newPayoffDate),
              ),
              Expanded(
                child: _DateCol(label: 'Original Payoff', value: originalPayoffDate),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DateCol extends StatelessWidget {
  final String label;
  final String value;

  const _DateCol({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: const TextStyle(
          fontFamily: 'DMSans',
          fontSize: 10,
          color: AppColors.accent100,
          letterSpacing: 0.07,
        )),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(
          fontFamily: 'DMSans',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.white,
          fontFeatures: [FontFeature.tabularFigures()],
        )),
      ],
    );
  }
}
