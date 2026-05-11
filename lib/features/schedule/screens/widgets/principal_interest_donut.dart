import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class PrincipalInterestDonut extends StatelessWidget {
  final double principalPercent; // 0–100
  final String loanAmount; // e.g. "$360,000"
  final String totalInterest; // e.g. "$438,347"

  const PrincipalInterestDonut({
    super.key,
    required this.principalPercent,
    required this.loanAmount,
    required this.totalInterest,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final interestPercent = 100 - principalPercent;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.neutral200,
          width: 0.5,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Donut
          SizedBox(
            width: 120,
            height: 120,
            child: PieChart(
              PieChartData(
                sectionsSpace: 0,
                centerSpaceRadius: 36,
                startDegreeOffset: -90,
                sections: [
                  PieChartSectionData(
                    value: principalPercent,
                    color: AppColors.brand800,
                    radius: 26,
                    showTitle: false,
                  ),
                  PieChartSectionData(
                    value: interestPercent,
                    color: AppColors.brand300,
                    radius: 26,
                    showTitle: false,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 20),
          // Legend
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LegendItem(
                  color: AppColors.brand800,
                  label: 'Principal',
                  value: loanAmount,
                  percent: principalPercent,
                  isDark: isDark,
                ),
                const SizedBox(height: 16),
                _LegendItem(
                  color: AppColors.brand300,
                  label: 'Total Interest',
                  value: totalInterest,
                  percent: interestPercent,
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String value;
  final double percent;
  final bool isDark;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.value,
    required this.percent,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 12,
          height: 12,
          margin: const EdgeInsets.only(top: 2),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'DMSans',
                  fontSize: 12,
                  color: isDark ? AppColors.neutral400 : AppColors.neutral500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'DMSans',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.white : AppColors.neutral900,
                ),
              ),
              Text(
                '${percent.toStringAsFixed(1)}% of total',
                style: TextStyle(
                  fontFamily: 'DMSans',
                  fontSize: 11,
                  color: isDark ? AppColors.neutral500 : AppColors.neutral400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
