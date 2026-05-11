import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/disclaimer_text.dart';
import 'widgets/compare_header_cards.dart';
import 'widgets/metric_row.dart';
import 'widgets/better_choice_card.dart';

class CompareScreen extends StatelessWidget {
  const CompareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(AppStrings.tabCompare),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.share, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          // Side-by-side loan cards
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: CompareHeaderCards(
              loan1Label: 'Without Extra',
              loan1Amount: '\$0/month',
              loan1Monthly: '\$2,577.80',
              loan1Rate: '',
              loan1Term: '',
              loan2Label: 'With Extra',
              loan2Amount: '\$200/month',
              loan2Monthly: '\$2,377.80',
              loan2Rate: '',
              loan2Term: '',
            ),
          ),
          const SizedBox(height: 16),

          // Metric comparison rows
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.neutral200,
                ),
              ),
              child: Column(
                children: const [
                  MetricRow(
                    label: 'Monthly Payment',
                    loan1Value: '\$2,577.80',
                    loan2Value: '\$2,577.80',
                    lowerIsBetter: true,
                    betterIndex: 0,
                  ),
                  MetricRow(
                    label: 'Total Interest',
                    loan1Value: '\$248,950',
                    loan2Value: '\$112,806',
                    lowerIsBetter: true,
                    betterIndex: 1,
                  ),
                  MetricRow(
                    label: 'Interest Saved',
                    loan1Value: '-',
                    loan2Value: '\$136,144',
                    lowerIsBetter: false,
                    betterIndex: 1,
                  ),
                  MetricRow(
                    label: 'Payoff Date',
                    loan1Value: 'May 2039',
                    loan2Value: 'May 2033',
                    lowerIsBetter: true,
                    betterIndex: 1,
                  ),
                  MetricRow(
                    label: 'Time Saved',
                    loan1Value: '-',
                    loan2Value: '6 yrs 2 mo',
                    lowerIsBetter: false,
                    betterIndex: 1,
                    isLast: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Better choice card
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: BetterChoiceCard(
              winnerLabel: 'With Extra \$200/month',
              reasonText:
                  'You save \$136,144 in interest and become debt free 6 years 2 months sooner.',
            ),
          ),
          const SizedBox(height: 16),

          // Share button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(CupertinoIcons.share, size: 18),
              label: const Text('Share This Result'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.brand800,
                side: const BorderSide(color: AppColors.brand300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const DisclaimerText(short: true),
        ],
      ),
    );
  }
}
