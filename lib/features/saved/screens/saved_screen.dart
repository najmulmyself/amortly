import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../calculator/cubit/calculator_cubit.dart';
import '../../calculator/cubit/calculator_state.dart';
import '../../calculator/services/mortgage_calculator.dart';
import '../cubit/saved_cubit.dart';
import '../cubit/saved_state.dart';
import '../models/saved_calculation.dart';
import 'widgets/saved_item_card.dart';
import 'widgets/empty_saved_state.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  int _segmentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<SavedCubit, SavedState>(
      builder: (context, state) {
        final loans = state.filtered;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: const Text(AppStrings.tabSaved),
            actions: [
              IconButton(
                icon: const Icon(CupertinoIcons.line_horizontal_3_decrease,
                    size: 20),
                onPressed: () {},
                tooltip: 'Filter',
              ),
            ],
          ),
          body: Column(
            children: [
              // Loans / Scenarios segmented control
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: _IOSSegmentedControl(
                  labels: const ['Loans', 'Scenarios'],
                  selectedIndex: _segmentIndex,
                  onSelected: (i) => setState(() => _segmentIndex = i),
                  isDark: isDark,
                ),
              ),
              const SizedBox(height: 12),

              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CupertinoSearchTextField(
                  placeholder: 'Search saved loans',
                  style: TextStyle(
                    color: isDark ? AppColors.white : AppColors.neutral900,
                  ),
                  onChanged: (v) => context.read<SavedCubit>().search(v),
                ),
              ),
              const SizedBox(height: 12),

              // Content
              Expanded(
                child: _segmentIndex == 0
                    ? loans.isEmpty
                        ? const EmptySavedState()
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                            itemCount: loans.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (ctx, i) {
                              final loan = loans[i];
                              return Dismissible(
                                key: Key(loan.id),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(CupertinoIcons.trash,
                                      color: Colors.white),
                                ),
                                confirmDismiss: (_) => _confirmDelete(context),
                                onDismissed: (_) =>
                                    context.read<SavedCubit>().delete(loan.id),
                                child: SavedItemCard(
                                  label: loan.name,
                                  price:
                                      CurrencyFormatter.format(loan.homePrice),
                                  date: DateFormatter.longDate(loan.savedAt),
                                  monthly: CurrencyFormatter.formatWithCents(
                                      loan.monthlyPayment),
                                ),
                              );
                            },
                          )
                    : const EmptySavedState(),
              ),
            ],
          ),
          // Add New Loan button
          bottomNavigationBar: Padding(
            padding: EdgeInsets.fromLTRB(
                16, 8, 16, MediaQuery.of(context).padding.bottom + 8),
            child: SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () => _saveCurrentLoan(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brand800,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(CupertinoIcons.add, size: 18),
                label: const Text(
                  '+ Add New Loan',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showCupertinoDialog<bool>(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text('Delete saved loan?'),
        content: const Text('This cannot be undone.'),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () =>
                Navigator.of(context, rootNavigator: true).pop(true),
            child: const Text('Delete'),
          ),
          CupertinoDialogAction(
            onPressed: () =>
                Navigator.of(context, rootNavigator: true).pop(false),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveCurrentLoan(BuildContext context) async {
    final calcState = context.read<CalculatorCubit>().state;
    final controller = TextEditingController();
    final name = await showCupertinoDialog<String>(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text('Name this loan'),
        content: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: CupertinoTextField(
            controller: controller,
            placeholder: 'e.g. Dream Home',
            autofocus: true,
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () =>
                Navigator.of(context, rootNavigator: true).pop(null),
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.of(context, rootNavigator: true)
                .pop(controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (name == null || name.isEmpty) return;

    final input = calcState.input;
    final result = MortgageCalculator.calculate(input);
    final calc = SavedCalculation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      homePrice: input.homePrice,
      downPayment: input.downPayment,
      loanAmount: input.loanAmount,
      annualRate: input.annualRate,
      termYears: input.termYears,
      monthlyPayment: result.totalMonthly,
      totalInterest: result.totalInterest,
      propertyTax: input.propertyTaxAnnual,
      homeInsurance: input.insuranceAnnual,
      pmi: input.pmiAnnual,
      savedAt: DateTime.now(),
    );
    if (context.mounted) {
      context.read<SavedCubit>().save(calc);
    }
  }
}

// ─── iOS segmented control ─────────────────────────────────────────────────

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
