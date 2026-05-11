import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/disclaimer_text.dart';
import '../../../core/widgets/section_label.dart';
import 'widgets/savings_summary_card.dart';
import 'widgets/payment_slider.dart';
import 'widgets/comparison_cards.dart';
import 'widgets/balance_chart.dart';

class ExtraPaymentScreen extends StatefulWidget {
  const ExtraPaymentScreen({super.key});

  @override
  State<ExtraPaymentScreen> createState() => _ExtraPaymentScreenState();
}

class _ExtraPaymentScreenState extends State<ExtraPaymentScreen> {
  double _extraPayment = 200;
  // 0 = Additional Principal, 1 = Recurring Extra
  int _paymentType = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
            onPressed: () {},
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
              interestSaved: '\$136,144',
              yearsSaved: '6 years 2 months',
              newPayoffDate: 'May 2033',
              originalPayoffDate: 'May 2039',
            ),
          ),
          const SizedBox(height: 8),

          // Celebratory sub-line
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
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
                    "That's 74 fewer payments!",
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.brand100 : AppColors.brand800,
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
                  value: 'May 2033',
                  isDark: isDark,
                ),
                Divider(height: 1, thickness: 0.5, color: isDark ? AppColors.darkBorder : AppColors.neutral200),
                _InfoRow(
                  label: 'Total Interest',
                  value: '\$112,806',
                  subtitle: 'vs \$248,950 without extra payments',
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
              value: _extraPayment,
              min: 0,
              max: 2000,
              onChanged: (v) => setState(() => _extraPayment = v),
            ),
          ),
          const SizedBox(height: 20),

          // Choose Extra Payment Type
          const SectionLabel(text: 'Choose Extra Payment Type'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _PaymentTypeSelector(
              isDark: isDark,
              selected: _paymentType,
              onChanged: (i) => setState(() => _paymentType = i),
            ),
          ),
          const SizedBox(height: 20),

          // See Amortization Impact row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _TappableRow(
              isDark: isDark,
              label: 'See Amortization Impact',
              onTap: () {},
            ),
          ),
          const SizedBox(height: 20),

          // Comparison cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ComparisonCards(
              originalMonthly: '\$2,577.80',
              newMonthly: '\$2,577.80',
              originalTerm: '30 years',
              newTerm: '23 yr 10 mo',
              originalInterest: '\$248,950',
              newInterest: '\$112,806',
            ),
          ),
          const SizedBox(height: 20),

          const SectionLabel(text: 'Balance Over Time'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: BalanceChart(extraPayment: _extraPayment),
          ),
          const SizedBox(height: 16),
          const DisclaimerText(short: true),
        ],
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                                : (isDark ? AppColors.neutral500 : AppColors.neutral300),
                            width: selected == i ? 6 : 1.5,
                          ),
                          color: selected == i ? AppColors.brand800 : Colors.transparent,
                        ),
                        child: selected == i
                            ? const Center(
                                child: Icon(Icons.circle, size: 10, color: AppColors.white),
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
                              color: isDark ? AppColors.white : AppColors.neutral900,
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
            const Icon(CupertinoIcons.chevron_right, size: 16, color: AppColors.neutral400),
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
