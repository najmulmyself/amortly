import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Single-line balance chart for the Schedule screen's Chart tab.
class BalanceLineChart extends StatelessWidget {
  final List<FlSpot>? spots;
  final double maxY;

  const BalanceLineChart({super.key, this.spots, this.maxY = 400});

  static const _fallbackSpots = [
    FlSpot(0, 360),
    FlSpot(5, 336),
    FlSpot(10, 303),
    FlSpot(15, 259),
    FlSpot(20, 198),
    FlSpot(25, 115),
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
    final chartSpots =
        (spots != null && spots!.isNotEmpty) ? spots! : _fallbackSpots;
    final maxX = chartSpots.last.x;
    final chartMaxY = maxY;

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
            maxX: maxX,
            minY: 0,
            maxY: chartMaxY,
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
                spots: chartSpots,
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
