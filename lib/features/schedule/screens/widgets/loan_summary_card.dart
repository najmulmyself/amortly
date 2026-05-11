import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class LoanSummaryCard extends StatelessWidget {
  final String loanAmount;
  final String rate;
  final String term;
  final String startDate;
  final String totalInterest;
  final String totalCost;
  final String payoffDate;
  final double principalPercent;

  const LoanSummaryCard({
    super.key,
    required this.loanAmount,
    required this.rate,
    required this.term,
    this.startDate = 'May 12, 2025',
    required this.totalInterest,
    required this.totalCost,
    required this.payoffDate,
    required this.principalPercent,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.neutral200,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Text(
              'Loan Summary',
              style: TextStyle(
                fontFamily: 'DMSans',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.white : AppColors.neutral900,
              ),
            ),
          ),
          _divider(isDark),
          _InfoRow(label: 'Loan Amount', value: loanAmount, isDark: isDark),
          _divider(isDark),
          _InfoRow(label: 'Interest Rate', value: rate, isDark: isDark),
          _divider(isDark),
          _InfoRow(label: 'Loan Term', value: term, isDark: isDark),
          _divider(isDark),
          _InfoRow(label: 'Start Date', value: startDate, isDark: isDark),
          _divider(isDark),

          // Principal vs Interest bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: SizedBox(
                height: 6,
                child: Row(
                  children: [
                    Expanded(
                      flex: principalPercent.round(),
                      child: Container(color: AppColors.brand800),
                    ),
                    Expanded(
                      flex: (100 - principalPercent).round(),
                      child: Container(color: AppColors.brand300),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
            child: Row(
              children: [
                _Legend(
                    color: AppColors.brand800,
                    label: 'Principal ${principalPercent.toStringAsFixed(0)}%'),
                const SizedBox(width: 16),
                _Legend(
                    color: AppColors.brand300,
                    label:
                        'Interest ${(100 - principalPercent).toStringAsFixed(0)}%'),
                const Spacer(),
                Text(
                  'Payoff $payoffDate',
                  style: AppTextStyles.cardSubtitle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider(bool isDark) => Divider(
        height: 0.5,
        thickness: 0.5,
        indent: 16,
        endIndent: 0,
        color: isDark ? AppColors.darkBorder : AppColors.neutral200,
      );
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;

  const _InfoRow(
      {required this.label, required this.value, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'DMSans',
              fontSize: 14,
              color: isDark ? AppColors.neutral400 : AppColors.neutral500,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'DMSans',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.white : AppColors.neutral900,
            ),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;

  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyles.cardSubtitle),
      ],
    );
  }
}
