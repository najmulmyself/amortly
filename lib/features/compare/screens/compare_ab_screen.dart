/// compare_ab_screen.dart
///
/// "Loan A vs Loan B" independent comparison screen (v2 prototype).
/// The original compare_screen.dart ("With/Without Extra") is unchanged.
/// Route this via a separate path (e.g. '/compare-ab') to trial it.
library;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/disclaimer_text.dart';
import '../../../services/ad_service.dart';
import '../../calculator/cubit/calculator_cubit.dart';
import '../cubit/compare_ab_cubit.dart';
import '../cubit/compare_ab_state.dart';
import 'widgets/compare_header_cards.dart';
import 'widgets/metric_row.dart';
import 'widgets/better_choice_card.dart';

// ─── Entry widget ─────────────────────────────────────────────────────────────

class CompareAbScreen extends StatelessWidget {
  const CompareAbScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => CompareAbCubit(ctx.read<CalculatorCubit>().state.input),
      child: const _CompareAbBody(),
    );
  }
}

// ─── Body ─────────────────────────────────────────────────────────────────────

class _CompareAbBody extends StatelessWidget {
  const _CompareAbBody();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<CompareAbCubit, CompareAbState>(
      builder: (context, state) {
        final cubit = context.read<CompareAbCubit>();
        final ra = state.resultA;
        final rb = state.resultB;

        // Formatted values — Loan A
        final aMonthly = CurrencyFormatter.formatWithCents(ra.monthlyPI);
        final aInterest = CurrencyFormatter.format(ra.totalInterest);
        final aCost = CurrencyFormatter.format(ra.totalCost);
        final aPayoff = DateFormatter.payoffDate(ra.payoffDate);
        final aMonths = state.loanA.termYears * 12;
        final aTermLabel = '${state.loanA.termYears} yr';

        // Formatted values — Loan B
        final bMonthly = CurrencyFormatter.formatWithCents(rb.monthlyPI);
        final bInterest = CurrencyFormatter.format(rb.totalInterest);
        final bCost = CurrencyFormatter.format(rb.totalCost);
        final bPayoff = DateFormatter.payoffDate(rb.payoffDate);
        final bTermLabel = '${state.loanB.termYears} yr';

        // Who wins on each metric?
        final monthlyWinner = ra.monthlyPI <= rb.monthlyPI ? 0 : 1;
        final interestWinner = ra.totalInterest <= rb.totalInterest ? 0 : 1;
        final costWinner = ra.totalCost <= rb.totalCost ? 0 : 1;
        final payoffWinner = aMonths <= state.loanB.termYears * 12 ? 0 : 1;

        // Overall winner — most wins across 4 metrics
        final aWins = [monthlyWinner, interestWinner, costWinner, payoffWinner]
            .where((w) => w == 0)
            .length;
        final bWins = 4 - aWins;
        final hasOverallWinner = aWins != bWins;
        final overallWinner = aWins > bWins ? 0 : 1;

        // Interest difference
        final interestDiff = (ra.totalInterest - rb.totalInterest).abs();
        final interestDiffLabel = CurrencyFormatter.format(interestDiff);
        final monthlySavingsLabel = CurrencyFormatter.formatWithCents(
            (ra.monthlyPI - rb.monthlyPI).abs());

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: const Text('Compare Loans'),
            actions: [
              Builder(
                builder: (btnCtx) => IconButton(
                  icon: const Icon(CupertinoIcons.share, size: 22),
                  onPressed: () => _share(
                    btnCtx,
                    aMonthly: aMonthly,
                    bMonthly: bMonthly,
                    aInterest: aInterest,
                    bInterest: bInterest,
                    aCost: aCost,
                    bCost: bCost,
                  ),
                ),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.only(bottom: 40),
            children: [
              // ── Input panels ──────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _LoanInputPanel(
                        label: 'Loan A',
                        isDark: isDark,
                        accentColor: AppColors.brand700,
                        loanAmount: state.loanA.loanAmount,
                        annualRate: state.loanA.annualRate,
                        termYears: state.loanA.termYears,
                        onAmountChanged: cubit.updateLoanAAmount,
                        onRateChanged: cubit.updateLoanARate,
                        onTermChanged: cubit.updateLoanATerm,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _LoanInputPanel(
                        label: 'Loan B',
                        isDark: isDark,
                        accentColor: AppColors.accent500,
                        loanAmount: state.loanB.loanAmount,
                        annualRate: state.loanB.annualRate,
                        termYears: state.loanB.termYears,
                        onAmountChanged: cubit.updateLoanBAmount,
                        onRateChanged: cubit.updateLoanBRate,
                        onTermChanged: cubit.updateLoanBTerm,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── Summary cards ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CompareHeaderCards(
                  loan1Label: 'Loan A',
                  loan1Monthly: aMonthly,
                  loan1TotalInterest: aInterest,
                  loan2Label: 'Loan B',
                  loan2Monthly: bMonthly,
                  loan2TotalInterest: bInterest,
                ),
              ),
              const SizedBox(height: 16),

              // ── Metric rows ───────────────────────────────────────────────
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
                        label: 'Monthly P&I',
                        loan1Value: aMonthly,
                        loan2Value: bMonthly,
                        lowerIsBetter: true,
                        betterIndex: monthlyWinner,
                      ),
                      MetricRow(
                        label: 'Total Interest',
                        loan1Value: aInterest,
                        loan2Value: bInterest,
                        lowerIsBetter: true,
                        betterIndex: interestWinner,
                      ),
                      MetricRow(
                        label: 'Total Cost',
                        loan1Value: aCost,
                        loan2Value: bCost,
                        lowerIsBetter: true,
                        betterIndex: costWinner,
                      ),
                      MetricRow(
                        label: 'Payoff Date',
                        loan1Value: aPayoff,
                        loan2Value: bPayoff,
                        lowerIsBetter: true,
                        betterIndex: payoffWinner,
                      ),
                      MetricRow(
                        label: 'Loan Term',
                        loan1Value: aTermLabel,
                        loan2Value: bTermLabel,
                        lowerIsBetter: true,
                        betterIndex: payoffWinner,
                        isLast: true,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── Better-choice summary card ─────────────────────────────
              if (hasOverallWinner)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: BetterChoiceCard(
                    winnerLabel: overallWinner == 0 ? 'Loan A' : 'Loan B',
                    reasonText: overallWinner == 0
                        ? 'Loan A saves $interestDiffLabel in interest with a lower monthly payment of $monthlySavingsLabel.'
                        : 'Loan B saves $interestDiffLabel in interest with a lower monthly payment of $monthlySavingsLabel.',
                  ),
                ),
              const SizedBox(height: 16),

              // ── Share button ──────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Builder(
                  builder: (btnCtx) => OutlinedButton.icon(
                    onPressed: () => _share(
                      btnCtx,
                      aMonthly: aMonthly,
                      bMonthly: bMonthly,
                      aInterest: aInterest,
                      bInterest: bInterest,
                      aCost: aCost,
                      bCost: bCost,
                    ),
                    icon: const Icon(CupertinoIcons.share, size: 18),
                    label: const Text('Share This Comparison'),
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
              ),
              const SizedBox(height: 16),
              const DisclaimerText(short: true),
            ],
          ),
        );
      },
    );
  }

  void _share(
    BuildContext context, {
    required String aMonthly,
    required String bMonthly,
    required String aInterest,
    required String bInterest,
    required String aCost,
    required String bCost,
  }) {
    AdService().showInterstitial();
    final box = context.findRenderObject() as RenderBox?;
    final origin =
        box == null ? null : box.localToGlobal(Offset.zero) & box.size;
    final text = '''
Mortgage Comparison — Loan A vs Loan B (via Amortly)

Loan A: $aMonthly/mo · $aInterest interest · $aCost total
Loan B: $bMonthly/mo · $bInterest interest · $bCost total

Calculate yours at https://apps.apple.com/app/amortly
''';
    Share.share(text.trim(), sharePositionOrigin: origin);
  }
}

// ─── Input panel ──────────────────────────────────────────────────────────────

class _LoanInputPanel extends StatefulWidget {
  final String label;
  final bool isDark;
  final Color accentColor;
  final double loanAmount;
  final double annualRate;
  final int termYears;
  final ValueChanged<double> onAmountChanged;
  final ValueChanged<double> onRateChanged;
  final ValueChanged<int> onTermChanged;

  const _LoanInputPanel({
    required this.label,
    required this.isDark,
    required this.accentColor,
    required this.loanAmount,
    required this.annualRate,
    required this.termYears,
    required this.onAmountChanged,
    required this.onRateChanged,
    required this.onTermChanged,
  });

  @override
  State<_LoanInputPanel> createState() => _LoanInputPanelState();
}

class _LoanInputPanelState extends State<_LoanInputPanel> {
  late final TextEditingController _amountCtrl;
  late final TextEditingController _rateCtrl;
  late final TextEditingController _termCtrl;

  @override
  void initState() {
    super.initState();
    _amountCtrl = TextEditingController(
      text: CurrencyFormatter.format(widget.loanAmount),
    );
    _rateCtrl = TextEditingController(
      text: widget.annualRate.toStringAsFixed(2),
    );
    _termCtrl = TextEditingController(
      text: widget.termYears.toString(),
    );
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _rateCtrl.dispose();
    _termCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bg = widget.isDark ? AppColors.darkSurface : AppColors.white;
    final border = widget.isDark ? AppColors.darkBorder : AppColors.neutral200;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: widget.accentColor.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: widget.accentColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              widget.label,
              style: const TextStyle(
                fontFamily: 'DMSans',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Loan amount
          _field(
            label: 'Amount',
            controller: _amountCtrl,
            prefix: '\$',
            keyboardType: TextInputType.number,
            borderColor: border,
            onSubmitted: (v) {
              widget.onAmountChanged(CurrencyFormatter.parse(v));
            },
            onFocusLost: (v) {
              widget.onAmountChanged(CurrencyFormatter.parse(v));
              _amountCtrl.text =
                  CurrencyFormatter.format(CurrencyFormatter.parse(v));
            },
          ),
          const SizedBox(height: 8),

          // Rate
          _field(
            label: 'Rate %',
            controller: _rateCtrl,
            suffix: '%',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            borderColor: border,
            onSubmitted: (v) {
              widget.onRateChanged(double.tryParse(v) ?? widget.annualRate);
            },
            onFocusLost: (v) {
              final r = double.tryParse(v) ?? widget.annualRate;
              widget.onRateChanged(r);
              _rateCtrl.text = r.toStringAsFixed(2);
            },
          ),
          const SizedBox(height: 8),

          // Term
          _field(
            label: 'Term (yr)',
            controller: _termCtrl,
            keyboardType: TextInputType.number,
            borderColor: border,
            onSubmitted: (v) {
              widget.onTermChanged(int.tryParse(v) ?? widget.termYears);
            },
            onFocusLost: (v) {
              final t = int.tryParse(v) ?? widget.termYears;
              widget.onTermChanged(t);
              _termCtrl.text = t.toString();
            },
          ),
        ],
      ),
    );
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    required Color borderColor,
    String? prefix,
    String? suffix,
    TextInputType keyboardType = TextInputType.text,
    required ValueChanged<String> onSubmitted,
    required ValueChanged<String> onFocusLost,
  }) {
    return Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) onFocusLost(controller.text);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'DMSans',
              fontSize: 10,
              color:
                  widget.isDark ? AppColors.neutral400 : AppColors.neutral500,
            ),
          ),
          const SizedBox(height: 3),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: onSubmitted,
            style: TextStyle(
              fontFamily: 'DMSans',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color:
                  widget.isDark ? AppColors.neutral100 : AppColors.neutral900,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
              prefixText: prefix,
              suffixText: suffix,
              prefixStyle: TextStyle(
                fontFamily: 'DMSans',
                fontSize: 13,
                color:
                    widget.isDark ? AppColors.neutral400 : AppColors.neutral500,
              ),
              suffixStyle: TextStyle(
                fontFamily: 'DMSans',
                fontSize: 13,
                color:
                    widget.isDark ? AppColors.neutral400 : AppColors.neutral500,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: widget.accentColor, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
