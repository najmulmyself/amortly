import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/input_row.dart';
import '../../../../core/widgets/section_label.dart';

class LoanInputForm extends StatelessWidget {
  final String homePrice;
  final String downPayment;
  final String loanAmount;
  final String rate;
  final String term;
  final String propertyTax;
  final String insurance;
  final String pmi;
  final bool includeInPayment;
  final String startDate;
  final ValueChanged<String>? onHomePriceChanged;
  final ValueChanged<String>? onDownPaymentChanged;
  final ValueChanged<String>? onLoanAmountChanged;
  final ValueChanged<String>? onRateChanged;
  final ValueChanged<String>? onTermChanged;
  final ValueChanged<String>? onPropertyTaxChanged;
  final ValueChanged<String>? onInsuranceChanged;
  final ValueChanged<String>? onPmiChanged;
  final ValueChanged<bool>? onIncludeInPaymentChanged;

  const LoanInputForm({
    super.key,
    required this.homePrice,
    required this.downPayment,
    required this.loanAmount,
    required this.rate,
    required this.term,
    required this.propertyTax,
    required this.insurance,
    required this.pmi,
    required this.includeInPayment,
    this.startDate = 'May 12, 2025',
    this.onHomePriceChanged,
    this.onDownPaymentChanged,
    this.onLoanAmountChanged,
    this.onRateChanged,
    this.onTermChanged,
    this.onPropertyTaxChanged,
    this.onInsuranceChanged,
    this.onPmiChanged,
    this.onIncludeInPaymentChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkSurface : AppColors.white;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.neutral200;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel(text: 'Loan Details'),
        _FormCard(
          color: cardColor,
          borderColor: borderColor,
          children: [
            _FormRow(
              icon: CupertinoIcons.home,
              label: 'Home Price',
              child: InputRow(
                label: 'Home Price',
                value: homePrice,
                prefix: '\$',
                onChanged: onHomePriceChanged,
                embedded: true,
              ),
            ),
            _Divider(color: borderColor),
            _FormRow(
              icon: CupertinoIcons.arrow_down_circle,
              label: 'Down Payment',
              subtitle: _downPercent(),
              child: InputRow(
                label: 'Down Payment',
                value: downPayment,
                prefix: '\$',
                onChanged: onDownPaymentChanged,
                embedded: true,
              ),
            ),
            _Divider(color: borderColor),
            _FormRow(
              icon: CupertinoIcons.money_dollar_circle,
              label: 'Loan Amount',
              child: InputRow(
                label: 'Loan Amount',
                value: loanAmount,
                prefix: '\$',
                onChanged: onLoanAmountChanged,
                embedded: true,
              ),
            ),
            _Divider(color: borderColor),
            _FormRow(
              icon: CupertinoIcons.percent,
              label: 'Interest Rate (%)',
              child: InputRow(
                label: 'Interest Rate',
                value: rate,
                suffix: '%',
                onChanged: onRateChanged,
                embedded: true,
              ),
            ),
            _Divider(color: borderColor),
            _FormRow(
              icon: CupertinoIcons.calendar,
              label: 'Loan Term',
              child: InputRow(
                label: 'Loan Term',
                value: term,
                suffix: 'Years',
                onChanged: onTermChanged,
                embedded: true,
              ),
            ),
            _Divider(color: borderColor),
            _FormRow(
              icon: CupertinoIcons.calendar_today,
              label: 'Start Date',
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                child: Text(
                  startDate,
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.neutral300 : AppColors.neutral800,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Taxes & Insurance section
        const SectionLabel(text: 'Taxes & Insurance'),
        _FormCard(
          color: cardColor,
          borderColor: borderColor,
          children: [
            _FormRow(
              icon: CupertinoIcons.building_2_fill,
              label: 'Property Tax (annual)',
              child: InputRow(
                label: 'Property Tax',
                value: propertyTax,
                prefix: '\$',
                onChanged: onPropertyTaxChanged,
                embedded: true,
              ),
            ),
            _Divider(color: borderColor),
            _FormRow(
              icon: CupertinoIcons.shield,
              label: 'Home Insurance (annual)',
              child: InputRow(
                label: 'Home Insurance',
                value: insurance,
                prefix: '\$',
                onChanged: onInsuranceChanged,
                embedded: true,
              ),
            ),
            _Divider(color: borderColor),
            _FormRow(
              icon: CupertinoIcons.lock_shield,
              label: 'PMI (annual)',
              subtitle: 'Optional',
              child: InputRow(
                label: 'PMI',
                value: pmi,
                prefix: '\$',
                onChanged: onPmiChanged,
                embedded: true,
              ),
            ),
            _Divider(color: borderColor),
            // Include in Payment toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Include in Payment',
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: AppColors.neutral800,
                      ),
                    ),
                  ),
                  CupertinoSwitch(
                    value: includeInPayment,
                    activeTrackColor: AppColors.brand700,
                    onChanged: onIncludeInPaymentChanged,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _downPercent() {
    try {
      final hp = double.parse(homePrice.replaceAll(',', ''));
      final dp = double.parse(downPayment.replaceAll(',', ''));
      if (hp == 0) return '';
      return '${(dp / hp * 100).toStringAsFixed(2)}% of home price';
    } catch (_) {
      return '';
    }
  }
}

// ─── Internal helpers ───────────────────────────────────────────────────────

class _FormCard extends StatelessWidget {
  final Color color;
  final Color borderColor;
  final List<Widget> children;

  const _FormCard({
    required this.color,
    required this.borderColor,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(children: children),
      ),
    );
  }
}

class _FormRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final Widget child;

  const _FormRow({
    required this.icon,
    required this.label,
    this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 14),
          child: Icon(
            icon,
            size: 18,
            color: AppColors.brand500,
          ),
        ),
        const SizedBox(width: 10),
        if (subtitle != null && subtitle!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(
              subtitle!,
              style: TextStyle(
                fontFamily: 'DMSans',
                fontSize: 11,
                color: isDark ? AppColors.neutral400 : AppColors.neutral500,
              ),
            ),
          ),
        Expanded(child: child),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  final Color color;
  const _Divider({required this.color});

  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, thickness: 0.5, color: color, indent: 44);
  }
}
