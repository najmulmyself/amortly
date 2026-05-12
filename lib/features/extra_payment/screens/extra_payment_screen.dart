import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/disclaimer_text.dart';
import '../../../core/widgets/section_label.dart';
import '../../../services/ad_service.dart';
import '../../calculator/cubit/calculator_cubit.dart';
import '../cubit/extra_payment_cubit.dart';
import '../cubit/extra_payment_state.dart';
import 'widgets/savings_summary_card.dart';
import 'widgets/payment_slider.dart';
import 'widgets/comparison_cards.dart';
import 'widgets/balance_chart.dart';

class ExtraPaymentScreen extends StatelessWidget {
  const ExtraPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) =>
          ExtraPaymentCubit(ctx.read<CalculatorCubit>().state.input),
      child: const _ExtraPaymentBody(),
    );
  }
}

class _ExtraPaymentBody extends StatelessWidget {
  const _ExtraPaymentBody();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<ExtraPaymentCubit, ExtraPaymentState>(
      builder: (context, state) {
        final cubit = context.read<ExtraPaymentCubit>();
        final result = state.result;

        // Format time saved
        final years = result.monthsSaved ~/ 12;
        final months = result.monthsSaved % 12;
        final savedLabel = [
          if (years > 0) '$years ${years == 1 ? 'year' : 'years'}',
          if (months > 0) '$months ${months == 1 ? 'month' : 'months'}',
        ].join(' ');
        final savedDisplay = savedLabel.isEmpty ? '0 months' : savedLabel;

        final originalPayoff = DateTime(
          state.input.startDate.year + state.input.termYears,
          state.input.startDate.month,
        );

        // Monthly P&I base
        final baseMonthly = state.result.originalTotalInterest == 0
            ? CurrencyFormatter.formatWithCents(0)
            : (() {
                final n = state.input.termYears * 12;
                final base = state.result.originalTotalInterest == 0
                    ? 0.0
                    : (state.result.originalTotalInterest +
                            state.input.loanAmount) /
                        n;
                return CurrencyFormatter.formatWithCents(base);
              })();

        // Compute base payment for comparison cards
        final int origMonths = state.result.originalMonths;
        final double basePayment =
            (state.result.originalTotalInterest + state.input.loanAmount) /
                origMonths;
        final newMonths = origMonths - result.monthsSaved;
        final newYrs = newMonths ~/ 12;
        final newMos = newMonths % 12;
        final newTermLabel = newYrs > 0
            ? '$newYrs yr${newMos > 0 ? ' $newMos mo' : ''}'
            : '$newMos mo';
        final origYrs = origMonths ~/ 12;
        final origTermLabel = '$origYrs years';

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: const Text(AppStrings.titleExtraPayment),
            leading: IconButton(
              icon: const Icon(CupertinoIcons.chevron_back, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(CupertinoIcons.info_circle, size: 22),
                onPressed: () => _showInfoSheet(context),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.only(bottom: 32),
            children: [
              // Savings hero card
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: SavingsSummaryCard(
                  interestSaved: CurrencyFormatter.format(result.interestSaved),
                  yearsSaved: savedDisplay,
                  newPayoffDate: DateFormatter.payoffDate(result.newPayoffDate),
                  originalPayoffDate: DateFormatter.payoffDate(originalPayoff),
                ),
              ),
              const SizedBox(height: 8),

              // Celebratory sub-line
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.brand50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.brand100,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Text('🎉', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 8),
                      Text(
                        "That's ${result.monthsSaved} fewer payments!",
                        style: TextStyle(
                          fontFamily: 'DMSans',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color:
                              isDark ? AppColors.brand100 : AppColors.brand800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // New Payoff Date & Total Interest rows
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _InfoCard(
                  isDark: isDark,
                  children: [
                    _InfoRow(
                      label: 'New Payoff Date',
                      value: DateFormatter.payoffDate(result.newPayoffDate),
                      isDark: isDark,
                    ),
                    Divider(
                        height: 1,
                        thickness: 0.5,
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.neutral200),
                    _InfoRow(
                      label: 'Total Interest',
                      value: CurrencyFormatter.format(result.newTotalInterest),
                      subtitle:
                          'vs ${CurrencyFormatter.format(result.originalTotalInterest)} without extra payments',
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Extra payment slider
              const SectionLabel(text: 'Extra Payment'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: PaymentSlider(
                  value: state.extraMonthly,
                  min: 0,
                  max: 2000,
                  onChanged: cubit.setExtra,
                ),
              ),
              const SizedBox(height: 20),

              // Choose Extra Payment Type
              const SectionLabel(text: 'Choose Extra Payment Type'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _PaymentTypeSelector(
                  isDark: isDark,
                  selected: state.paymentType,
                  onChanged: cubit.setPaymentType,
                ),
              ),
              const SizedBox(height: 20),

              // See Amortization Impact row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _TappableRow(
                  isDark: isDark,
                  label: 'See Amortization Impact',
                  onTap: () {
                    AdService().showInterstitial();
                    context.go('/schedule');
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Comparison cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ComparisonCards(
                  originalMonthly:
                      CurrencyFormatter.formatWithCents(basePayment),
                  newMonthly: CurrencyFormatter.formatWithCents(
                      basePayment + state.extraMonthly),
                  originalTerm: origTermLabel,
                  newTerm: newTermLabel,
                  originalInterest:
                      CurrencyFormatter.format(result.originalTotalInterest),
                  newInterest:
                      CurrencyFormatter.format(result.newTotalInterest),
                ),
              ),
              const SizedBox(height: 20),

              const SectionLabel(text: 'Balance Over Time'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: BalanceChart(
                  extraPayment: state.extraMonthly,
                  input: state.input,
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

  void _showInfoSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: const Text('About Extra Payments'),
        message: const Text(
          'Making extra principal payments reduces your loan balance faster, '
          'saving you thousands in interest and years off your mortgage. '
          'The calculator shows the exact savings based on your current loan terms.',
        ),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          child: const Text('Got It'),
        ),
      ),
    );
  }
}

// ─── Sub-widgets ────────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final bool isDark;
  final List<Widget> children;

  const _InfoCard({required this.isDark, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.neutral200,
        ),
      ),
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final String? subtitle;
  final bool isDark;

  const _InfoRow({
    required this.label,
    required this.value,
    this.subtitle,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'DMSans',
                  fontSize: 14,
                  color: isDark ? AppColors.neutral400 : AppColors.neutral500,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 11,
                    color: isDark ? AppColors.neutral400 : AppColors.neutral400,
                  ),
                ),
              ],
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'DMSans',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.white : AppColors.neutral900,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentTypeSelector extends StatelessWidget {
  final bool isDark;
  final int selected;
  final ValueChanged<int> onChanged;

  const _PaymentTypeSelector({
    required this.isDark,
    required this.selected,
    required this.onChanged,
  });

  static const _types = [
    _PaymentTypeItem(
      title: 'Additional Principal',
      subtitle: 'Reduces principal balance',
    ),
    _PaymentTypeItem(
      title: 'Recurring Extra Payment',
      subtitle: 'Every month',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.neutral200,
        ),
      ),
      child: Column(
        children: List.generate(_types.length, (i) {
          final item = _types[i];
          final isLast = i == _types.length - 1;
          return Column(
            children: [
              InkWell(
                onTap: () => onChanged(i),
                borderRadius: BorderRadius.only(
                  topLeft: i == 0 ? const Radius.circular(16) : Radius.zero,
                  topRight: i == 0 ? const Radius.circular(16) : Radius.zero,
                  bottomLeft: isLast ? const Radius.circular(16) : Radius.zero,
                  bottomRight: isLast ? const Radius.circular(16) : Radius.zero,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selected == i
                                ? AppColors.brand800
                                : (isDark
                                    ? AppColors.neutral500
                                    : AppColors.neutral300),
                            width: selected == i ? 6 : 1.5,
                          ),
                          color: selected == i
                              ? AppColors.brand800
                              : Colors.transparent,
                        ),
                        child: selected == i
                            ? const Center(
                                child: Icon(Icons.circle,
                                    size: 10, color: AppColors.white),
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: TextStyle(
                              fontFamily: 'DMSans',
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.neutral900,
                            ),
                          ),
                          Text(
                            item.subtitle,
                            style: const TextStyle(
                              fontFamily: 'DMSans',
                              fontSize: 12,
                              color: AppColors.neutral500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  thickness: 0.5,
                  color: isDark ? AppColors.darkBorder : AppColors.neutral200,
                  indent: 52,
                ),
            ],
          );
        }),
      ),
    );
  }
}

class _TappableRow extends StatelessWidget {
  final bool isDark;
  final String label;
  final VoidCallback onTap;

  const _TappableRow({
    required this.isDark,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.neutral200,
          ),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'DMSans',
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.white : AppColors.neutral900,
              ),
            ),
            const Spacer(),
            const Icon(CupertinoIcons.chevron_right,
                size: 16, color: AppColors.neutral400),
          ],
        ),
      ),
    );
  }
}

class _PaymentTypeItem {
  final String title;
  final String subtitle;

  const _PaymentTypeItem({required this.title, required this.subtitle});
}
