import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Single-line balance chart for the Schedule screen's Chart tab.
/// Shows remaining loan balance over 30 years for a $360k @ 6.25% 30-yr loan.
class BalanceLineChart extends StatelessWidget {
  const BalanceLineChart({super.key});

  // Pre-computed yearly balance snapshots in $k ($360k @ 6.25%, P&I only)
  static const _spots = [
    FlSpot(0, 360),
    FlSpot(1, 356),
    FlSpot(2, 351),
    FlSpot(3, 346),
    FlSpot(4, 341),
    FlSpot(5, 336),
    FlSpot(6, 330),
    FlSpot(7, 324),
    FlSpot(8, 318),
    FlSpot(9, 311),
    FlSpot(10, 303),
    FlSpot(11, 296),
    FlSpot(12, 287),
    FlSpot(13, 278),
    FlSpot(14, 269),
    FlSpot(15, 259),
    FlSpot(16, 248),
    FlSpot(17, 237),
    FlSpot(18, 225),
    FlSpot(19, 212),
    FlSpot(20, 198),
    FlSpot(21, 183),
    FlSpot(22, 168),
    FlSpot(23, 151),
    FlSpot(24, 134),
    FlSpot(25, 115),
    FlSpot(26, 95),
    FlSpot(27, 74),
    FlSpot(28, 52),
    FlSpot(29, 28),
    FlSpot(30, 0),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
      padding: const EdgeInsets.fromLTRB(4, 16, 16, 16),
      child: SizedBox(
        height: 200,
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
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
              LineChartBarData(
                spots: _spots,
                color: AppColors.brand700,
                barWidth: 2.5,
                isCurved: true,
                curveSmoothness: 0.25,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.brand700.withValues(alpha: 0.18),
                      AppColors.brand700.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
