import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class CompareHeaderCards extends StatelessWidget {
  final String loan1Label;
  final String loan1Amount;
  final String loan1Monthly;
  final String loan2Label;
  final String loan2Amount;
  final String loan2Monthly;

  // Legacy params kept for backward compat (unused in new design)
  final String loan1Rate;
  final String loan1Term;
  final String loan2Rate;
  final String loan2Term;

  const CompareHeaderCards({
    super.key,
    this.loan1Label = 'Loan A',
    required this.loan1Amount,
    this.loan1Rate = '',
    this.loan1Term = '',
    required this.loan1Monthly,
    this.loan2Label = 'Loan B',
    required this.loan2Amount,
    this.loan2Rate = '',
    this.loan2Term = '',
    required this.loan2Monthly,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _LoanCard(
            label: loan1Label,
            extraLabel: loan1Amount,
            monthly: loan1Monthly,
            isPrimary: false,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _LoanCard(
            label: loan2Label,
            extraLabel: loan2Amount,
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
  final String extraLabel;
  final String monthly;
  final bool isPrimary;

  const _LoanCard({
    required this.label,
    required this.extraLabel,
    required this.monthly,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isPrimary
        ? AppColors.accent500
        : (isDark ? AppColors.darkSurface : AppColors.neutral100);
    final labelColor = isPrimary ? AppColors.white : AppColors.neutral500;
    final valueColor =
        isPrimary ? AppColors.white : (isDark ? AppColors.white : AppColors.neutral900);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
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
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            extraLabel,
            style: TextStyle(
              fontFamily: 'DMSans',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            monthly,
            style: AppTextStyles.cardSubtitle.copyWith(
              color: isPrimary ? AppColors.white.withValues(alpha: 0.8) : AppColors.neutral500,
            ),
          ),
        ],
      ),
    );
  }
}
