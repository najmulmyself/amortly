import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../features/calculator/models/mortgage_input.dart';

class BalanceChart extends StatelessWidget {
  final double extraPayment;
  final MortgageInput? input;

  const BalanceChart({super.key, required this.extraPayment, this.input});

  /// Builds yearly balance spots (x = year, y = balance in $k).
  List<FlSpot> _buildSpots(double extra) {
    final loan = input;
    final double principal = loan?.loanAmount ?? 360000;
    final double annualRate = loan?.annualRate ?? 6.25;
    final int termYears = loan?.termYears ?? 30;
    final double monthlyRate = annualRate / 100 / 12;
    final int n = termYears * 12;
    final double factor = pow(1 + monthlyRate, n).toDouble();
    final double basePayment = principal * monthlyRate * factor / (factor - 1);
    final double maxY = (principal / 1000 / 100).ceil() * 100;

    final payment = basePayment + extra;
    final spots = <FlSpot>[];
    double bal = principal;

    for (int yr = 0; yr <= termYears; yr++) {
      spots.add(FlSpot(yr.toDouble(), (bal / 1000).clamp(0.0, maxY)));
      if (bal == 0) break;
      for (int m = 0; m < 12; m++) {
        bal -= payment - bal * monthlyRate;
        if (bal < 0) {
          bal = 0;
          break;
        }
      }
    }
    return spots;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final withoutExtra = _buildSpots(0);
    final withExtra = _buildSpots(extraPayment);

    final double maxX = (input?.termYears ?? 30).toDouble();
    final double maxY =
        (((input?.loanAmount ?? 360000) / 1000 / 100).ceil() * 100).toDouble();
    final double gridInterval = maxY / 4;

    final gridColor = isDark ? AppColors.neutral700 : AppColors.neutral200;
    final labelStyle = TextStyle(
      fontFamily: 'DMSans',
      fontSize: 10,
      color: isDark ? AppColors.neutral400 : AppColors.neutral500,
    );

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.neutral200,
          width: 0.5,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(4, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: maxX,
                minY: 0,
                maxY: maxY,
                clipData: const FlClipData.all(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: gridInterval,
                  getDrawingHorizontalLine: (_) =>
                      FlLine(color: gridColor, strokeWidth: 0.5),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 46,
                      interval: gridInterval,
                      getTitlesWidget: (v, _) {
                        if (v % gridInterval != 0)
                          return const SizedBox.shrink();
                        return Text('\$${v.toInt()}k', style: labelStyle);
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      interval: maxX <= 20
                          ? 5
                          : maxX <= 30
                              ? 5
                              : 10,
                      getTitlesWidget: (v, _) {
                        final interval = maxX <= 20 ? 5 : 5;
                        if (v % interval != 0) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text('Yr ${v.toInt()}', style: labelStyle),
                        );
                      },
                    ),
                  ),
                ),
                lineBarsData: [
                  // Without extra — blue
                  LineChartBarData(
                    spots: withoutExtra,
                    color: AppColors.brand500,
                    barWidth: 2,
                    isCurved: true,
                    curveSmoothness: 0.25,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.brand500.withValues(alpha: 0.08),
                    ),
                  ),
                  // With extra — teal
                  LineChartBarData(
                    spots: withExtra,
                    color: AppColors.accent500,
                    barWidth: 2,
                    isCurved: true,
                    curveSmoothness: 0.25,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.accent500.withValues(alpha: 0.08),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const _LegendLine(
                  color: AppColors.brand500, label: 'Without Extra'),
              const SizedBox(width: 20),
              _LegendLine(
                color: AppColors.accent500,
                label: extraPayment > 0
                    ? 'With +\$${extraPayment.toInt()}/mo'
                    : 'With Extra',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendLine extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendLine({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 3,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'DMSans',
            fontSize: 12,
            color: isDark ? AppColors.neutral400 : AppColors.neutral500,
          ),
        ),
      ],
    );
  }
}
