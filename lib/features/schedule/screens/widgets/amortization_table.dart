import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class AmortizationTable extends StatelessWidget {
  final bool showMonthly;

  const AmortizationTable({super.key, required this.showMonthly});

  // Monthly demo data — $360k @ 6.25% 30yr P&I = $2,216.52/mo
  static const _monthlyRows = [
    _Row(period: 'Jan 25', payment: '\$2,216.52', principal: '\$341.52',   interest: '\$1,875.00', balance: '\$359,658'),
    _Row(period: 'Feb 25', payment: '\$2,216.52', principal: '\$343.30',   interest: '\$1,873.22', balance: '\$359,315'),
    _Row(period: 'Mar 25', payment: '\$2,216.52', principal: '\$345.09',   interest: '\$1,871.43', balance: '\$358,970'),
    _Row(period: 'Apr 25', payment: '\$2,216.52', principal: '\$346.89',   interest: '\$1,869.63', balance: '\$358,623'),
    _Row(period: 'May 25', payment: '\$2,216.52', principal: '\$348.70',   interest: '\$1,867.82', balance: '\$358,274'),
    _Row(period: 'Jun 25', payment: '\$2,216.52', principal: '\$350.52',   interest: '\$1,866.00', balance: '\$357,924'),
    _Row(period: 'Jul 25', payment: '\$2,216.52', principal: '\$352.34',   interest: '\$1,864.18', balance: '\$357,572'),
    _Row(period: 'Aug 25', payment: '\$2,216.52', principal: '\$354.18',   interest: '\$1,862.34', balance: '\$357,217'),
    _Row(period: 'Sep 25', payment: '\$2,216.52', principal: '\$356.02',   interest: '\$1,860.50', balance: '\$356,861'),
    _Row(period: 'Oct 25', payment: '\$2,216.52', principal: '\$357.88',   interest: '\$1,858.64', balance: '\$356,504'),
    _Row(period: 'Nov 25', payment: '\$2,216.52', principal: '\$359.74',   interest: '\$1,856.78', balance: '\$356,144'),
    _Row(period: 'Dec 25', payment: '\$2,216.52', principal: '\$361.62',   interest: '\$1,854.90', balance: '\$355,782'),
  ];

  // Yearly demo data — exactly matches design screenshot
  static const _yearlyRows = [
    _Row(period: '1',   payment: '\$28,533', principal: '\$12,215', interest: '\$16,318', balance: '\$347,785'),
    _Row(period: '2',   payment: '\$28,533', principal: '\$12,880', interest: '\$15,653', balance: '\$334,905'),
    _Row(period: '3',   payment: '\$28,533', principal: '\$13,583', interest: '\$14,950', balance: '\$321,322'),
    _Row(period: '4',   payment: '\$28,533', principal: '\$14,325', interest: '\$14,208', balance: '\$306,997'),
    _Row(period: '5',   payment: '\$28,533', principal: '\$15,108', interest: '\$13,425', balance: '\$291,889'),
    _Row(period: '...',  payment: '...',     principal: '...',      interest: '...',      balance: '...'),
    _Row(period: '30',  payment: '\$28,533', principal: '\$27,304', interest: '\$1,229',  balance: '\$0'),
  ];

  @override
  Widget build(BuildContext context) {
    final rows = showMonthly ? _monthlyRows : _yearlyRows;
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
              const Expanded(child: Text('PAYMENT',   style: AppTextStyles.tableHeader, textAlign: TextAlign.right)),
              const Expanded(child: Text('PRINCIPAL', style: AppTextStyles.tableHeader, textAlign: TextAlign.right)),
              const Expanded(child: Text('INTEREST',  style: AppTextStyles.tableHeader, textAlign: TextAlign.right)),
              const Expanded(child: Text('BALANCE',   style: AppTextStyles.tableHeader, textAlign: TextAlign.right)),
            ],
          ),
        ),

        // Data rows
        Expanded(
          child: ListView.builder(
            itemCount: rows.length,
            itemBuilder: (_, i) {
              final row = rows[i];
              final isEllipsis = row.period == '...';
              final isEven = i.isEven;

              if (isEllipsis) {
                return Container(
                  color: isDark ? AppColors.darkElevated : AppColors.neutral100,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      SizedBox(width: 44, child: Text('·  ·  ·', style: AppTextStyles.tableCell.copyWith(color: AppColors.neutral400))),
                      Expanded(child: Text('·  ·  ·', style: AppTextStyles.tableCell.copyWith(color: AppColors.neutral400), textAlign: TextAlign.right)),
                      Expanded(child: Text('·  ·  ·', style: AppTextStyles.tableCell.copyWith(color: AppColors.neutral400), textAlign: TextAlign.right)),
                      Expanded(child: Text('·  ·  ·', style: AppTextStyles.tableCell.copyWith(color: AppColors.neutral400), textAlign: TextAlign.right)),
                      Expanded(child: Text('·  ·  ·', style: AppTextStyles.tableCell.copyWith(color: AppColors.neutral400), textAlign: TextAlign.right)),
                    ],
                  ),
                );
              }

              return Container(
                color: isEven
                    ? (isDark ? AppColors.darkSurface : AppColors.white)
                    : (isDark ? AppColors.darkElevated : AppColors.neutral50),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                child: Row(
                  children: [
                    SizedBox(
                      width: 44,
                      child: Text(row.period, style: AppTextStyles.tableCell),
                    ),
                    Expanded(child: Text(row.payment,    style: AppTextStyles.tableCell,              textAlign: TextAlign.right)),
                    Expanded(child: Text(row.principal,  style: AppTextStyles.tableCellPrincipal,     textAlign: TextAlign.right)),
                    Expanded(child: Text(row.interest,   style: AppTextStyles.tableCellInterest,      textAlign: TextAlign.right)),
                    Expanded(child: Text(row.balance,    style: AppTextStyles.tableCell,              textAlign: TextAlign.right)),
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
  final String period;
  final String payment;
  final String principal;
  final String interest;
  final String balance;

  const _Row({
    required this.period,
    required this.payment,
    required this.principal,
    required this.interest,
    required this.balance,
  });
}
