import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class AmortizationTable extends StatelessWidget {
  final bool showMonthly;

  const AmortizationTable({super.key, required this.showMonthly});

  // Static demo data for Phase 1 UI
  static const _monthlyRows = [
    _Row(month: '1', payment: '\$2,216.52', principal: '\$341.52', interest: '\$1,875.00', balance: '\$359,658.48'),
    _Row(month: '2', payment: '\$2,216.52', principal: '\$343.30', interest: '\$1,873.22', balance: '\$359,315.18'),
    _Row(month: '3', payment: '\$2,216.52', principal: '\$345.09', interest: '\$1,871.43', balance: '\$358,970.09'),
    _Row(month: '4', payment: '\$2,216.52', principal: '\$346.89', interest: '\$1,869.63', balance: '\$358,623.20'),
    _Row(month: '5', payment: '\$2,216.52', principal: '\$348.70', interest: '\$1,867.82', balance: '\$358,274.50'),
    _Row(month: '6', payment: '\$2,216.52', principal: '\$350.52', interest: '\$1,866.00', balance: '\$357,923.98'),
    _Row(month: '7', payment: '\$2,216.52', principal: '\$352.34', interest: '\$1,864.18', balance: '\$357,571.64'),
    _Row(month: '8', payment: '\$2,216.52', principal: '\$354.18', interest: '\$1,862.34', balance: '\$357,217.46'),
    _Row(month: '9', payment: '\$2,216.52', principal: '\$356.02', interest: '\$1,860.50', balance: '\$356,861.44'),
    _Row(month: '10', payment: '\$2,216.52', principal: '\$357.88', interest: '\$1,858.64', balance: '\$356,503.56'),
    _Row(month: '11', payment: '\$2,216.52', principal: '\$359.74', interest: '\$1,856.78', balance: '\$356,143.82'),
    _Row(month: '12', payment: '\$2,216.52', principal: '\$361.62', interest: '\$1,854.90', balance: '\$355,782.20'),
  ];

  static const _yearlyRows = [
    _Row(month: 'Year 1', payment: '\$26,598.24', principal: '\$4,217.80', interest: '\$22,380.44', balance: '\$355,782.20'),
    _Row(month: 'Year 2', payment: '\$26,598.24', principal: '\$4,488.60', interest: '\$22,109.64', balance: '\$351,293.60'),
    _Row(month: 'Year 3', payment: '\$26,598.24', principal: '\$4,774.00', interest: '\$21,824.24', balance: '\$346,519.60'),
    _Row(month: 'Year 4', payment: '\$26,598.24', principal: '\$5,075.10', interest: '\$21,523.14', balance: '\$341,444.50'),
    _Row(month: 'Year 5', payment: '\$26,598.24', principal: '\$5,393.20', interest: '\$21,205.04', balance: '\$336,051.30'),
  ];

  @override
  Widget build(BuildContext context) {
    final rows = showMonthly ? _monthlyRows : _yearlyRows;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Header
        Container(
          color: isDark ? AppColors.darkElevated : AppColors.neutral100,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              SizedBox(
                width: 48,
                child: Text(showMonthly ? 'MO' : 'YR', style: AppTextStyles.tableHeader),
              ),
              Expanded(child: Text('PAYMENT', style: AppTextStyles.tableHeader, textAlign: TextAlign.right)),
              Expanded(child: Text('PRINCIPAL', style: AppTextStyles.tableHeader, textAlign: TextAlign.right)),
              Expanded(child: Text('INTEREST', style: AppTextStyles.tableHeader, textAlign: TextAlign.right)),
              Expanded(child: Text('BALANCE', style: AppTextStyles.tableHeader, textAlign: TextAlign.right)),
            ],
          ),
        ),
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    SizedBox(
                      width: 48,
                      child: Text(row.month, style: AppTextStyles.tableCell),
                    ),
                    Expanded(child: Text(row.payment, style: AppTextStyles.tableCell, textAlign: TextAlign.right)),
                    Expanded(child: Text(row.principal, style: AppTextStyles.tableCellPrincipal, textAlign: TextAlign.right)),
                    Expanded(child: Text(row.interest, style: AppTextStyles.tableCellInterest, textAlign: TextAlign.right)),
                    Expanded(child: Text(row.balance, style: AppTextStyles.tableCell, textAlign: TextAlign.right)),
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

class _Row {
  final String month;
  final String payment;
  final String principal;
  final String interest;
  final String balance;

  const _Row({
    required this.month,
    required this.payment,
    required this.principal,
    required this.interest,
    required this.balance,
  });
}
