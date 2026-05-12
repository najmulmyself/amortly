import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../models/amortization_row.dart';

class AmortizationTable extends StatelessWidget {
  final bool showMonthly;
  final List<AmortizationRow> monthlyRows;
  final List<AmortizationRow> yearlyRows;

  const AmortizationTable({
    super.key,
    required this.showMonthly,
    required this.monthlyRows,
    required this.yearlyRows,
  });

  @override
  Widget build(BuildContext context) {
    final rows = showMonthly ? monthlyRows : yearlyRows;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    String period(AmortizationRow r) => showMonthly
        ? DateFormatter.monthYearShort(r.date)
        : r.period.toString();

    return Column(
      children: [
        // Header row
        Container(
          color: isDark ? AppColors.darkElevated : AppColors.neutral100,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              SizedBox(
                width: 44,
                child: Text(
                  showMonthly ? 'MO' : 'YR',
                  style: AppTextStyles.tableHeader,
                ),
              ),
              const Expanded(
                  child: Text('PAYMENT',
                      style: AppTextStyles.tableHeader,
                      textAlign: TextAlign.right)),
              const Expanded(
                  child: Text('PRINCIPAL',
                      style: AppTextStyles.tableHeader,
                      textAlign: TextAlign.right)),
              const Expanded(
                  child: Text('INTEREST',
                      style: AppTextStyles.tableHeader,
                      textAlign: TextAlign.right)),
              const Expanded(
                  child: Text('BALANCE',
                      style: AppTextStyles.tableHeader,
                      textAlign: TextAlign.right)),
            ],
          ),
        ),

        // Data rows
        Expanded(
          child: ListView.builder(
            itemCount: rows.length,
            itemBuilder: (_, i) {
              final row = rows[i];
              final isEven = i.isEven;

              return Container(
                color: isEven
                    ? (isDark ? AppColors.darkSurface : AppColors.white)
                    : (isDark ? AppColors.darkElevated : AppColors.neutral50),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                child: Row(
                  children: [
                    SizedBox(
                      width: 44,
                      child: Text(period(row), style: AppTextStyles.tableCell),
                    ),
                    Expanded(
                        child: Text(
                            CurrencyFormatter.formatWithCents(row.payment),
                            style: AppTextStyles.tableCell,
                            textAlign: TextAlign.right)),
                    Expanded(
                        child: Text(
                            CurrencyFormatter.formatWithCents(row.principal),
                            style: AppTextStyles.tableCellPrincipal,
                            textAlign: TextAlign.right)),
                    Expanded(
                        child: Text(
                            CurrencyFormatter.formatWithCents(row.interest),
                            style: AppTextStyles.tableCellInterest,
                            textAlign: TextAlign.right)),
                    Expanded(
                        child: Text(CurrencyFormatter.format(row.balance),
                            style: AppTextStyles.tableCell,
                            textAlign: TextAlign.right)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
