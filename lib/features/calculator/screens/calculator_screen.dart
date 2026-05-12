import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/disclaimer_text.dart';
import '../cubit/calculator_cubit.dart';
import '../cubit/calculator_state.dart';
import 'widgets/loan_input_form.dart';
import 'widgets/result_card.dart';
import 'widgets/quick_presets_bar.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  // UI-only state (not business logic)
  int _modeIndex = 0;
  static const _modes = ['Basic', 'Advanced'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(AppStrings.tabCalculator),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.info_circle, size: 22),
            onPressed: () => _showInfoSheet(context),
          ),
        ],
      ),
      body: BlocBuilder<CalculatorCubit, CalculatorState>(
        builder: (context, state) {
          final cubit = context.read<CalculatorCubit>();
          final input = state.input;
          final result = state.result;

          return ListView(
            padding: const EdgeInsets.only(bottom: 32),
            children: [
          // Mode segmented control (Basic / Advanced / Buy vs Rent)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: _ModeSegmentedControl(
              selectedIndex: _modeIndex,
              labels: _modes,
              onSelected: (i) => setState(() => _modeIndex = i),
            ),
          ),
          const SizedBox(height: 16),

          // Quick presets
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: QuickPresetsBar(
              selectedIndex: state.selectedPreset,
              onSelected: cubit.applyPreset,
            ),
          ),
          const SizedBox(height: 16),

          if (_modeIndex == 0 || _modeIndex == 1) ...[
            // Input form
            LoanInputForm(
              homePrice: CurrencyFormatter.format(input.homePrice),
              downPayment: CurrencyFormatter.format(input.downPayment),
              loanAmount: CurrencyFormatter.format(input.loanAmount),
              rate: input.annualRate.toString(),
              term: input.termYears.toString(),
              propertyTax: CurrencyFormatter.format(input.propertyTaxAnnual),
              insurance: CurrencyFormatter.format(input.insuranceAnnual),
              pmi: CurrencyFormatter.format(input.pmiAnnual),
              includeInPayment: input.includeInPayment,
              startDate: DateFormatter.longDate(input.startDate),
              onHomePriceChanged: cubit.updateHomePrice,
              onDownPaymentChanged: cubit.updateDownPayment,
              onLoanAmountChanged: cubit.updateLoanAmount,
              onRateChanged: cubit.updateRate,
              onTermChanged: cubit.updateTerm,
              onPropertyTaxChanged: cubit.updatePropertyTax,
              onInsuranceChanged: cubit.updateInsurance,
              onPmiChanged: cubit.updatePmi,
              onIncludeInPaymentChanged: cubit.updateIncludeInPayment,
            ),
          ],
          const SizedBox(height: 16),

          // Result hero card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ResultCard(
              monthlyPrincipalInterest:
                  CurrencyFormatter.formatWithCents(result.monthlyPI),
              totalMonthly:
                  CurrencyFormatter.formatWithCents(result.totalMonthly),
              totalInterest: CurrencyFormatter.format(result.totalInterest),
              totalCost: CurrencyFormatter.format(result.totalCost),
              payoffDate: DateFormatter.payoffDate(result.payoffDate),
              onViewSchedule: () => context.go('/schedule'),
              onExtraPayment: () => context.push('/extra-payment'),
            ),
          ),
          const SizedBox(height: 16),

          // Affordability shortcut
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              onPressed: () => context.push('/affordability'),
              icon: const Icon(CupertinoIcons.house, size: 18),
              label: const Text('Check Affordability'),
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
          );
        },
      ),
    );
  }

  void _showInfoSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkSurface
          : AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const Padding(
        padding: EdgeInsets.fromLTRB(24, 20, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About This Calculator',
              style: TextStyle(
                fontFamily: 'DMSans',
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.neutral900,
              ),
            ),
            SizedBox(height: 12),
            DisclaimerText(short: false),
          ],
        ),
      ),
    );
  }
}

// ─── iOS-style pill segmented control ──────────────────────────────────────

class _ModeSegmentedControl extends StatelessWidget {
  final int selectedIndex;
  final List<String> labels;
  final ValueChanged<int> onSelected;

  const _ModeSegmentedControl({
    required this.selectedIndex,
    required this.labels,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkElevated : AppColors.neutral100,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        children: List.generate(labels.length, (i) {
          final selected = i == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelected(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: selected
                      ? (isDark ? AppColors.darkSurface : AppColors.white)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  labels[i],
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 13,
                    fontWeight:
                        selected ? FontWeight.w600 : FontWeight.w400,
                    color: selected
                        ? (isDark ? AppColors.white : AppColors.neutral900)
                        : (isDark
                            ? AppColors.neutral400
                            : AppColors.neutral500),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
