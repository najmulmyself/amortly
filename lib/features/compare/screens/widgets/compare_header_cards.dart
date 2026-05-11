import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class CompareHeaderCards extends StatelessWidget {
  final String loan1Label;
  final String loan1TotalInterest;
  final String loan1Monthly;
  final String loan2Label;
  final String loan2TotalInterest;
  final String loan2Monthly;

  // Legacy params kept for backward compat
  final String loan1Amount;
  final String loan2Amount;
  final String loan1Rate;
  final String loan1Term;
  final String loan2Rate;
  final String loan2Term;

  const CompareHeaderCards({
    super.key,
    this.loan1Label = 'Without Extra',
    this.loan1TotalInterest = '\$248,950',
    required this.loan1Monthly,
    this.loan2Label = 'With Extra',
    this.loan2TotalInterest = '\$112,806',
    required this.loan2Monthly,
    // legacy
    this.loan1Amount = '',
    this.loan1Rate = '',
    this.loan1Term = '',
    this.loan2Amount = '',
    this.loan2Rate = '',
    this.loan2Term = '',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _LoanCard(
            label: loan1Label,
            totalInterest: loan1TotalInterest,
            monthly: loan1Monthly,
            isPrimary: false,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _LoanCard(
            label: loan2Label,
            totalInterest: loan2TotalInterest,
            monthly: loan2Monthly,
            isPrimary: true,
          ),
        ),
      ],
    );
  }
}

class _LoanCard extends StatelessWidget {
  final String label;
  final String totalInterest;
  final String monthly;
  final bool isPrimary;

  const _LoanCard({
    required this.label,
    required this.totalInterest,
    required this.monthly,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isPrimary
        ? AppColors.accent500
        : (isDark ? AppColors.darkSurface : AppColors.neutral100);
    final labelColor = isPrimary
        ? AppColors.white.withValues(alpha: 0.8)
        : AppColors.neutral500;
    final valueColor = isPrimary
        ? AppColors.white
        : (isDark ? AppColors.white : AppColors.neutral900);
    final subColor = isPrimary
        ? AppColors.white.withValues(alpha: 0.75)
        : AppColors.neutral500;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: isPrimary
            ? null
            : Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.neutral200,
                width: 0.5,
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'DMSans',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: labelColor,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            totalInterest,
            style: TextStyle(
              fontFamily: 'DMSans',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Total Interest',
            style: TextStyle(
              fontFamily: 'DMSans',
              fontSize: 11,
              color: subColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$monthly / mo',
            style: TextStyle(
              fontFamily: 'DMSans',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: subColor,
            ),
          ),
        ],
      ),
    );
  }
}
