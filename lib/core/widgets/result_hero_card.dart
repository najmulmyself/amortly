import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class ResultHeroCard extends StatelessWidget {
  final String mainLabel;
  final String mainValue;
  final List<HeroStatItem> stats;
  final Widget? bottomContent;

  const ResultHeroCard({
    super.key,
    required this.mainLabel,
    required this.mainValue,
    this.stats = const [],
    this.bottomContent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.brand800, AppColors.brand900],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(mainLabel.toUpperCase(), style: AppTextStyles.heroLabel),
          const SizedBox(height: 4),
          Text(mainValue, style: AppTextStyles.heroAmountLarge),
          if (stats.isNotEmpty) ...[
            const SizedBox(height: 20),
            Container(
              height: 1,
              color: AppColors.darkBorder,
            ),
            const SizedBox(height: 16),
            Row(
              children: stats
                  .map(
                    (s) => Expanded(
                      child: _StatColumn(label: s.label, value: s.value),
                    ),
                  )
                  .toList(),
            ),
          ],
          if (bottomContent != null) ...[
            const SizedBox(height: 16),
            bottomContent!,
          ],
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;

  const _StatColumn({required this.label, required this.value});

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

class HeroStatItem {
  final String label;
  final String value;

  const HeroStatItem({required this.label, required this.value});
}
