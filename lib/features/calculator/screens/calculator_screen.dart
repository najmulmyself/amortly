import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/disclaimer_text.dart';
import 'widgets/loan_input_form.dart';
import 'widgets/result_card.dart';
import 'widgets/quick_presets_bar.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  // Calculator mode: 0=Basic, 1=Advanced, 2=Buy vs Rent
  int _modeIndex = 0;

  // Loan inputs
  String _homePrice = '450,000';
  String _downPayment = '90,000';
  String _loanAmount = '360,000';
  String _rate = '6.25';
  String _term = '30';
  String _propertyTax = '4,500';
  String _insurance = '1,200';
  String _pmi = '0';
  bool _includeInPayment = true;
  int _selectedPreset = 2; // 30yr default

  static const _modes = ['Basic', 'Advanced', 'Buy vs Rent'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
      body: ListView(
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
              selectedIndex: _selectedPreset,
              onSelected: (i) => setState(() => _selectedPreset = i),
            ),
          ),
          const SizedBox(height: 16),

          if (_modeIndex == 0 || _modeIndex == 1) ...[
            // Input form
            LoanInputForm(
              homePrice: _homePrice,
              downPayment: _downPayment,
              loanAmount: _loanAmount,
              rate: _rate,
              term: _term,
              propertyTax: _propertyTax,
              insurance: _insurance,
              pmi: _pmi,
              includeInPayment: _includeInPayment,
              onHomePriceChanged: (v) => setState(() => _homePrice = v),
              onDownPaymentChanged: (v) => setState(() => _downPayment = v),
              onLoanAmountChanged: (v) => setState(() => _loanAmount = v),
              onRateChanged: (v) => setState(() => _rate = v),
              onTermChanged: (v) => setState(() => _term = v),
              onPropertyTaxChanged: (v) => setState(() => _propertyTax = v),
              onInsuranceChanged: (v) => setState(() => _insurance = v),
              onPmiChanged: (v) => setState(() => _pmi = v),
              onIncludeInPaymentChanged: (v) =>
                  setState(() => _includeInPayment = v),
            ),
          ] else ...[
            // Buy vs Rent placeholder
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.neutral200,
                  ),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Buy vs Rent — Coming Soon',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 15,
                    color: AppColors.neutral500,
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),

          // Result hero card (at bottom, matching screenshot)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ResultCard(
              monthlyPrincipalInterest: '\$2,043.71',
              totalMonthly: '\$2,377.80',
              totalInterest: '\$375,735',
              totalCost: '\$735,735',
              payoffDate: 'May 2056',
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
                        ? AppColors.brand800
                        : AppColors.neutral500,
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
