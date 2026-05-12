import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/disclaimer_text.dart';
import '../../calculator/cubit/calculator_cubit.dart';
import '../../calculator/cubit/calculator_state.dart';
import '../cubit/compare_cubit.dart';
import '../cubit/compare_state.dart';
import 'widgets/compare_header_cards.dart';
import 'widgets/metric_row.dart';
import 'widgets/better_choice_card.dart';

class CompareScreen extends StatelessWidget {
  const CompareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => CompareCubit(ctx.read<CalculatorCubit>().state.input),
      child: const _CompareBody(),
    );
  }
}

class _CompareBody extends StatelessWidget {
  const _CompareBody();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Keep CompareCubit in sync if calculator changes
    context.select<CalculatorCubit, CalculatorState>((c) => c.state);

    return BlocBuilder<CompareCubit, CompareState>(
      builder: (context, state) {
        final result = state.result;
        final base = state.baseMonthlyPI;
        final extra = state.extraMonthly;

        // Loan A (without extra)
        final loan1Monthly = CurrencyFormatter.formatWithCents(base);
        final loan1Interest =
            CurrencyFormatter.format(result.originalTotalInterest);
        final origMonths = result.originalMonths;
        final origPayoff = DateTime(
          state.input.startDate.year,
          state.input.startDate.month + origMonths,
        );

        // Loan B (with extra)
        final loan2Monthly = CurrencyFormatter.formatWithCents(base + extra);
        final loan2Interest = CurrencyFormatter.format(result.newTotalInterest);
        final newMonths = origMonths - result.monthsSaved;
        final newPayoff = result.newPayoffDate;

        // Time saved label
        final yrs = result.monthsSaved ~/ 12;
        final mos = result.monthsSaved % 12;
        final timeSaved = result.monthsSaved == 0
            ? '—'
            : [
                if (yrs > 0) '$yrs yr',
                if (mos > 0) '$mos mo',
              ].join(' ');

        final interestSaved = CurrencyFormatter.format(result.interestSaved);

        // Payoff date labels
        final origPayoffLabel = DateFormatter.payoffDate(origPayoff);
        final newPayoffLabel = DateFormatter.payoffDate(newPayoff);

        // New term label
        final newYrs = newMonths ~/ 12;
        final newMos = newMonths % 12;
        final newTermLabel = newYrs > 0
            ? '$newYrs yr${newMos > 0 ? ' $newMos mo' : ''}'
            : '$newMos mo';
        final origYrs = origMonths ~/ 12;
        final origTermLabel =
            '$origYrs yr${origMonths % 12 > 0 ? ' ${origMonths % 12} mo' : ''}';

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
              // Extra payment picker
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: _ExtraRow(
                  extra: extra,
                  isDark: isDark,
                  onChanged: context.read<CompareCubit>().setExtra,
                ),
              ),
              const SizedBox(height: 12),

              // Side-by-side loan cards
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: CompareHeaderCards(
                  loan1Label: 'Without Extra',
                  loan1TotalInterest: loan1Interest,
                  loan1Monthly: loan1Monthly,
                  loan2Label: 'With +${CurrencyFormatter.format(extra)}/mo',
                  loan2TotalInterest: loan2Interest,
                  loan2Monthly: loan2Monthly,
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
                      color:
                          isDark ? AppColors.darkBorder : AppColors.neutral200,
                    ),
                  ),
                  child: Column(
                    children: [
                      MetricRow(
                        label: 'Payment',
                        loan1Value: loan1Monthly,
                        loan2Value: loan2Monthly,
                        lowerIsBetter: true,
                        betterIndex: 0,
                      ),
                      MetricRow(
                        label: 'Total Interest',
                        loan1Value: loan1Interest,
                        loan2Value: loan2Interest,
                        lowerIsBetter: true,
                        betterIndex: 1,
                      ),
                      MetricRow(
                        label: 'Payoff Date',
                        loan1Value: origPayoffLabel,
                        loan2Value: newPayoffLabel,
                        lowerIsBetter: true,
                        betterIndex: result.monthsSaved > 0 ? 1 : -1,
                      ),
                      MetricRow(
                        label: 'Loan Term',
                        loan1Value: origTermLabel,
                        loan2Value: newTermLabel,
                        lowerIsBetter: true,
                        betterIndex: result.monthsSaved > 0 ? 1 : -1,
                      ),
                      MetricRow(
                        label: 'Time Saved',
                        loan1Value: '—',
                        loan2Value: timeSaved,
                        lowerIsBetter: false,
                        betterIndex: result.monthsSaved > 0 ? 1 : -1,
                      ),
                      MetricRow(
                        label: 'Interest Saved',
                        loan1Value: '—',
                        loan2Value:
                            result.interestSaved > 0 ? interestSaved : '—',
                        lowerIsBetter: false,
                        betterIndex: result.interestSaved > 0 ? 1 : -1,
                        isLast: true,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Better choice card
              if (result.monthsSaved > 0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: BetterChoiceCard(
                    winnerLabel:
                        'With +${CurrencyFormatter.format(extra)}/month',
                    reasonText:
                        'You save $interestSaved in interest and become debt free $timeSaved sooner.',
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
      },
    );
  }
}

// ─── Extra payment row ─────────────────────────────────────────────────────

class _ExtraRow extends StatelessWidget {
  final double extra;
  final bool isDark;
  final ValueChanged<double> onChanged;

  const _ExtraRow({
    required this.extra,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.neutral200,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(CupertinoIcons.add_circled,
                  size: 18, color: AppColors.brand700),
              const SizedBox(width: 10),
              Text(
                'Extra Payment',
                style: TextStyle(
                  fontFamily: 'DMSans',
                  fontSize: 14,
                  color: isDark ? AppColors.neutral300 : AppColors.neutral700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _ExtraChip(
                  value: 0, selected: extra == 0, onTap: () => onChanged(0)),
              _ExtraChip(
                  value: 100,
                  selected: extra == 100,
                  onTap: () => onChanged(100)),
              _ExtraChip(
                  value: 200,
                  selected: extra == 200,
                  onTap: () => onChanged(200)),
              _ExtraChip(
                  value: 500,
                  selected: extra == 500,
                  onTap: () => onChanged(500)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExtraChip extends StatelessWidget {
  final double value;
  final bool selected;
  final VoidCallback onTap;

  const _ExtraChip({
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(left: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? AppColors.brand800 : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? AppColors.brand800 : AppColors.neutral300,
          ),
        ),
        child: Text(
          value == 0 ? 'None' : '+\$${value.toInt()}',
          style: TextStyle(
            fontFamily: 'DMSans',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: selected ? AppColors.white : AppColors.neutral500,
          ),
        ),
      ),
    );
  }
}
