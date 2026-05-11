import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class BalanceChart extends StatelessWidget {
  final double extraPayment;

  const BalanceChart({super.key, required this.extraPayment});

  // $360k @ 6.25% 30-yr, P&I only
  static const double _principal = 360000;
  static const double _monthlyRate = 0.0625 / 12;
  static const double _basePayment = 2216.52;

  /// Builds yearly balance spots (x = year, y = balance in $k).
  List<FlSpot> _buildSpots(double extra) {
    final payment = _basePayment + extra;
    final spots = <FlSpot>[];
    double bal = _principal;

    for (int yr = 0; yr <= 30; yr++) {
      spots.add(FlSpot(yr.toDouble(), (bal / 1000).clamp(0.0, 400.0)));
      if (bal == 0) break;
      for (int m = 0; m < 12; m++) {
        bal -= payment - bal * _monthlyRate;
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
                maxX: 30,
                minY: 0,
                maxY: 400,
                clipData: const FlClipData.all(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 100,
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
                      interval: 100,
                      getTitlesWidget: (v, _) {
                        if (v % 100 != 0) return const SizedBox.shrink();
                        return Text('\$${v.toInt()}k', style: labelStyle);
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      interval: 5,
                      getTitlesWidget: (v, _) {
                        if (v % 5 != 0) return const SizedBox.shrink();
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
