import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class ComparisonCards extends StatelessWidget {
  final String originalMonthly;
  final String newMonthly;
  final String originalTerm;
  final String newTerm;
  final String originalInterest;
  final String newInterest;

  const ComparisonCards({
    super.key,
    required this.originalMonthly,
    required this.newMonthly,
    required this.originalTerm,
    required this.newTerm,
    required this.originalInterest,
    required this.newInterest,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text('COMPARISON', style: AppTextStyles.sectionLabel),
        ),
        Row(
          children: [
            Expanded(
              child: _CompareCard(
                title: 'Without Extra',
                monthly: originalMonthly,
                term: originalTerm,
                totalInterest: originalInterest,
                isHighlight: false,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _CompareCard(
                title: 'With Extra',
                monthly: newMonthly,
                term: newTerm,
                totalInterest: newInterest,
                isHighlight: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CompareCard extends StatelessWidget {
  final String title;
  final String monthly;
  final String term;
  final String totalInterest;
  final bool isHighlight;

  const _CompareCard({
    required this.title,
    required this.monthly,
    required this.term,
    required this.totalInterest,
    required this.isHighlight,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isHighlight
        ? AppColors.accent500
        : (isDark ? AppColors.darkBorder : AppColors.neutral200);
    final bgColor = isHighlight
        ? AppColors.accent50
        : (isDark ? AppColors.darkSurface : AppColors.white);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: isHighlight ? 1.5 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.cardTitle.copyWith(
              color: isHighlight ? AppColors.accent700 : AppColors.neutral500,
            ),
          ),
          const SizedBox(height: 12),
          _Row(label: 'Monthly', value: monthly, highlight: isHighlight),
          const SizedBox(height: 8),
          _Row(label: 'Term', value: term, highlight: isHighlight),
          const SizedBox(height: 8),
          _Row(label: 'Total Interest', value: totalInterest, highlight: isHighlight),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _Row({required this.label, required this.value, required this.highlight});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.cardSubtitle),
        Text(
          value,
          style: AppTextStyles.cardValue.copyWith(
            fontSize: 13,
            color: highlight ? AppColors.accent700 : AppColors.neutral900,
          ),
        ),
      ],
    );
  }
}
