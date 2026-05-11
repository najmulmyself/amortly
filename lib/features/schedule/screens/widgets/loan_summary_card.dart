import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class LoanSummaryCard extends StatelessWidget {
  final String loanAmount;
  final String rate;
  final String term;
  final String totalInterest;
  final String totalCost;
  final String payoffDate;
  final double principalPercent;

  const LoanSummaryCard({
    super.key,
    required this.loanAmount,
    required this.rate,
    required this.term,
    required this.totalInterest,
    required this.totalCost,
    required this.payoffDate,
    required this.principalPercent,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.neutral200,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _Stat(label: 'Loan', value: loanAmount)),
              Expanded(child: _Stat(label: 'Rate', value: rate)),
              Expanded(child: _Stat(label: 'Term', value: term)),
            ],
          ),
          const SizedBox(height: 12),
          // Principal vs Interest bar
          ClipRRect(
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
                    child: Container(color: AppColors.brand500),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              _Legend(color: AppColors.brand800, label: 'Principal ${principalPercent.toStringAsFixed(0)}%'),
              const SizedBox(width: 16),
              _Legend(color: AppColors.brand500, label: 'Interest ${(100 - principalPercent).toStringAsFixed(0)}%'),
              const Spacer(),
              Text('Payoff: $payoffDate', style: AppTextStyles.cardSubtitle),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;

  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: AppTextStyles.inputLabel),
        const SizedBox(height: 2),
        Text(value, style: AppTextStyles.cardValue),
      ],
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
