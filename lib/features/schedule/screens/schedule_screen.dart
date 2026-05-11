import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/section_label.dart';
import 'widgets/loan_summary_card.dart';
import 'widgets/amortization_table.dart';
import 'widgets/principal_interest_donut.dart';
import 'widgets/balance_line_chart.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  // 0 = Table, 1 = Chart
  int _tabIndex = 0;
  bool _showMonthly = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(AppStrings.tabSchedule),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.doc_plaintext, size: 20),
            onPressed: () {},
            tooltip: 'Export PDF (Pro)',
          ),
        ],
      ),
      body: Column(
        children: [
          // Table / Chart segmented control
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: _IOSSegmentedControl(
              labels: const ['Table', 'Chart'],
              selectedIndex: _tabIndex,
              onSelected: (i) => setState(() => _tabIndex = i),
              isDark: isDark,
            ),
          ),
          const SizedBox(height: 12),

          // Loan summary card
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: LoanSummaryCard(
              loanAmount: '\$360,000',
              rate: '6.250%',
              term: '30 Years',
              startDate: 'May 12, 2025',
              totalInterest: '\$438,347',
              totalCost: '\$798,347',
              payoffDate: 'May 2055',
              principalPercent: 45.1,
            ),
          ),
          const SizedBox(height: 12),

          if (_tabIndex == 0) ...[
            // Monthly / Yearly / Export toggle bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _ChipButton(
                    label: 'Monthly',
                    selected: _showMonthly,
                    onTap: () => setState(() => _showMonthly = true),
                  ),
                  const SizedBox(width: 8),
                  _ChipButton(
                    label: 'Yearly',
                    selected: !_showMonthly,
                    onTap: () => setState(() => _showMonthly = false),
                  ),
                  const Spacer(),
                  _ExportButton(isDark: isDark),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Amortization table
            Expanded(
              child: AmortizationTable(showMonthly: _showMonthly),
            ),
          ] else ...[
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 32),
                children: const [
                  SectionLabel(text: 'Payment Breakdown'),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: PrincipalInterestDonut(
                      principalPercent: 45.1,
                      loanAmount: '\$360,000',
                      totalInterest: '\$438,347',
                    ),
                  ),
                  SizedBox(height: 20),
                  SectionLabel(text: 'Balance Over Time'),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: BalanceLineChart(),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Reusable chip button ───────────────────────────────────────────────────

class _ChipButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ChipButton(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.brand800
              : (isDark ? AppColors.darkSurface : AppColors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? AppColors.brand800
                : (isDark ? AppColors.darkBorder : AppColors.neutral300),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'DMSans',
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: selected
                ? AppColors.white
                : (isDark ? AppColors.neutral300 : AppColors.neutral500),
          ),
        ),
      ),
    );
  }
}

class _ExportButton extends StatelessWidget {
  final bool isDark;
  const _ExportButton({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.neutral300,
          ),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(CupertinoIcons.arrow_up_doc,
                size: 14, color: AppColors.brand800),
            SizedBox(width: 4),
            Text(
              'Export',
              style: TextStyle(
                fontFamily: 'DMSans',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.brand800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── iOS-style segmented control ────────────────────────────────────────────

class _IOSSegmentedControl extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final bool isDark;

  const _IOSSegmentedControl({
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
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
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    color: selected ? AppColors.brand800 : AppColors.neutral500,
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
