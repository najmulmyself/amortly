import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class ResultCard extends StatelessWidget {
  final String monthlyPrincipalInterest;
  final String totalMonthly;
  final String totalInterest;
  final String totalCost;
  final String payoffDate;
  final VoidCallback? onViewSchedule;
  final VoidCallback? onExtraPayment;

  const ResultCard({
    super.key,
    required this.monthlyPrincipalInterest,
    required this.totalMonthly,
    required this.totalInterest,
    required this.totalCost,
    required this.payoffDate,
    this.onViewSchedule,
    this.onExtraPayment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.brand800, AppColors.brand900],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Main payment area
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('MONTHLY PAYMENT (P&I)', style: AppTextStyles.heroLabel),
                const SizedBox(height: 4),
                Text(monthlyPrincipalInterest, style: AppTextStyles.heroAmountLarge),
                const SizedBox(height: 4),
                Text('Total with taxes & insurance: $totalMonthly',
                    style: AppTextStyles.heroSub),
                const SizedBox(height: 20),
                Container(height: 1, color: AppColors.darkBorder),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _StatCol(label: 'Total Interest', value: totalInterest),
                    ),
                    Expanded(
                      child: _StatCol(label: 'Total Cost', value: totalCost),
                    ),
                    Expanded(
                      child: _StatCol(label: 'Payoff Date', value: payoffDate),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Action buttons
          Container(
            decoration: const BoxDecoration(
              color: AppColors.darkBorderSubtle,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    icon: Icons.table_rows_outlined,
                    label: 'Amortization',
                    onTap: onViewSchedule,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                ),
                Container(width: 1, height: 44, color: AppColors.darkBorder),
                Expanded(
                  child: _ActionButton(
                    icon: Icons.trending_down_outlined,
                    label: 'Extra Payment',
                    onTap: onExtraPayment,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCol extends StatelessWidget {
  final String label;
  final String value;

  const _StatCol({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: AppTextStyles.heroStatLabel),
        const SizedBox(height: 2),
        Text(value, style: AppTextStyles.heroStat),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.onTap,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: AppColors.brand100),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'DMSans',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.brand100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
