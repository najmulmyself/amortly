import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/disclaimer_text.dart';
import '../cubit/affordability_cubit.dart';
import '../cubit/affordability_state.dart';
import 'widgets/dti_progress_bar.dart';
import 'widgets/max_home_card.dart';

class AffordabilityScreen extends StatelessWidget {
  const AffordabilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AffordabilityCubit(),
      child: const _AffordabilityBody(),
    );
  }
}

class _AffordabilityBody extends StatelessWidget {
  const _AffordabilityBody();

  void _showInfoSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How We Calculate Affordability',
                style: TextStyle(
                  fontFamily: 'DMSans',
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'The maximum home price is based on:\n'
                '• Your monthly income and the standard 28% front-end DTI limit\n'
                '• Your existing debts and the standard 36% back-end DTI limit\n'
                '• The assumed interest rate and 30-year fixed loan term',
                style: TextStyle(
                  fontFamily: 'DMSans',
                  fontSize: 14,
                  height: 1.6,
                  color: AppColors.neutral700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<AffordabilityCubit, AffordabilityState>(
      builder: (context, state) {
        final result = state.result;

        String description;
        if (result.status == 'Good') {
          description =
              'Based on your income, this home is within a comfortable budget range.';
        } else if (result.status == 'Fair') {
          description =
              'This is near the upper limit of your budget — consider a larger down payment or lower rate.';
        } else {
          description =
              'This exceeds recommended DTI limits. Consider reducing your debt or increasing income.';
        }

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(CupertinoIcons.chevron_back, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(AppStrings.titleAffordability),
            actions: [
              IconButton(
                icon: const Icon(CupertinoIcons.info_circle, size: 22),
                onPressed: () => _showInfoSheet(context),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              // Hero card
              MaxHomeCard(
                maxHomePrice: CurrencyFormatter.format(result.maxHomePrice),
                statusLabel: result.status,
                statusDescription: description,
              ),
              const SizedBox(height: 20),

              // Key metrics card
              _MetricsCard(
                isDark: isDark,
                monthlyPayment:
                    CurrencyFormatter.formatWithCents(result.monthlyPayment),
                monthlyIncome:
                    CurrencyFormatter.formatWithCents(state.monthlyIncome),
                dtiPercent: '${result.backEndDTI.toStringAsFixed(1)}%',
                isGood: result.status == 'Good',
              ),
              const SizedBox(height: 20),

              // DTI bars
              _DtiBarsCard(
                isDark: isDark,
                frontEndDTI: result.frontEndDTI,
                frontEndStatus: result.frontEndDTI <= 28
                    ? 'Good'
                    : (result.frontEndDTI <= 33 ? 'Fair' : 'High'),
                backEndDTI: result.backEndDTI,
                backEndStatus: result.backEndDTI <= 36
                    ? 'Good'
                    : (result.backEndDTI <= 43 ? 'Fair' : 'High'),
              ),
              const SizedBox(height: 20),

              // What This Means
              _WhatThisMeansCard(
                isDark: isDark,
                status: result.status,
                frontEndDTI: result.frontEndDTI,
                backEndDTI: result.backEndDTI,
              ),
              const SizedBox(height: 20),

              // Adjust Assumptions
              _AdjustAssumptionsRow(
                isDark: isDark,
                onTap: () => _showAssumptionsSheet(context, state),
              ),
              const SizedBox(height: 20),

              const DisclaimerText(),
            ],
          ),
        );
      },
    );
  }

  void _showAssumptionsSheet(BuildContext context, AffordabilityState state) {
    final cubit = context.read<AffordabilityCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkSurface
          : AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetCtx).viewInsets.bottom,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Adjust Assumptions',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                _AssumptionField(
                  label: 'Monthly Income',
                  value: CurrencyFormatter.format(state.monthlyIncome),
                  prefix: '\$',
                  onChanged: cubit.updateIncome,
                ),
                _AssumptionField(
                  label: 'Monthly Debts',
                  value: CurrencyFormatter.format(state.monthlyDebts),
                  prefix: '\$',
                  onChanged: cubit.updateDebts,
                ),
                _AssumptionField(
                  label: 'Down Payment',
                  value: CurrencyFormatter.format(state.downPayment),
                  prefix: '\$',
                  onChanged: cubit.updateDownPayment,
                ),
                _AssumptionField(
                  label: 'Interest Rate',
                  value: state.annualRate.toString(),
                  suffix: '%',
                  onChanged: cubit.updateRate,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () =>
                        Navigator.of(sheetCtx, rootNavigator: true).pop(),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.brand700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Done'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Metrics card ──────────────────────────────────────────────────────────

class _MetricsCard extends StatelessWidget {
  final bool isDark;
  final String monthlyPayment;
  final String monthlyIncome;
  final String dtiPercent;
  final bool isGood;

  const _MetricsCard({
    required this.isDark,
    required this.monthlyPayment,
    required this.monthlyIncome,
    required this.dtiPercent,
    required this.isGood,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.neutral200,
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          _MetricRow(
            icon: CupertinoIcons.money_dollar_circle,
            label: 'Monthly Payment',
            value: '$monthlyPayment / mo',
            badge: isGood ? 'Good' : 'High',
            badgeGreen: isGood,
            isDark: isDark,
            showBorder: true,
          ),
          _MetricRow(
            icon: CupertinoIcons.person_2,
            label: 'Household Income',
            value: '$monthlyIncome / mo',
            isDark: isDark,
            showBorder: true,
          ),
          _MetricRow(
            icon: CupertinoIcons.percent,
            label: 'DTI Ratio',
            value: dtiPercent,
            badge: isGood ? 'Good' : 'High',
            badgeGreen: isGood,
            isDark: isDark,
            showBorder: false,
          ),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? badge;
  final bool badgeGreen;
  final bool isDark;
  final bool showBorder;

  const _MetricRow({
    required this.icon,
    required this.label,
    required this.value,
    this.badge,
    this.badgeGreen = false,
    required this.isDark,
    required this.showBorder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: isDark ? AppColors.neutral400 : AppColors.neutral500,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 15,
                    color: isDark ? AppColors.neutral300 : AppColors.neutral700,
                  ),
                ),
              ),
              if (badge != null) ...[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: badgeGreen
                        ? AppColors.success.withValues(alpha: 0.12)
                        : AppColors.warning.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badge!,
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: badgeGreen ? AppColors.success : AppColors.warning,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
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
        ),
        if (showBorder)
          Divider(
            height: 0.5,
            thickness: 0.5,
            indent: 44,
            color: isDark ? AppColors.darkBorder : AppColors.neutral200,
          ),
      ],
    );
  }
}

// ─── DTI Bars card ─────────────────────────────────────────────────────────

class _DtiBarsCard extends StatelessWidget {
  final bool isDark;
  final double frontEndDTI;
  final String frontEndStatus;
  final double backEndDTI;
  final String backEndStatus;

  const _DtiBarsCard({
    required this.isDark,
    required this.frontEndDTI,
    required this.frontEndStatus,
    required this.backEndDTI,
    required this.backEndStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.neutral200,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Debt-to-Income Ratios',
            style: TextStyle(
              fontFamily: 'DMSans',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.white : AppColors.neutral900,
            ),
          ),
          const SizedBox(height: 16),
          DtiProgressBar(
            label: 'Front-End DTI (Housing)',
            percent: frontEndDTI,
            status: frontEndStatus,
          ),
          const SizedBox(height: 16),
          DtiProgressBar(
            label: 'Back-End DTI (All Debt)',
            percent: backEndDTI,
            status: backEndStatus,
          ),
          const SizedBox(height: 12),
          const Text(
            'Lenders prefer front-end ≤28% and back-end ≤36%',
            style: AppTextStyles.cardSubtitle,
          ),
        ],
      ),
    );
  }
}

// ─── What This Means card ──────────────────────────────────────────────────

class _WhatThisMeansCard extends StatelessWidget {
  final bool isDark;
  final String status;
  final double frontEndDTI;
  final double backEndDTI;

  const _WhatThisMeansCard({
    required this.isDark,
    required this.status,
    required this.frontEndDTI,
    required this.backEndDTI,
  });

  List<String> get _bullets {
    if (status == 'Good') {
      return [
        'Your housing costs are within the recommended 28% threshold',
        'Your total debt payments are well below the 36% back-end limit',
        'You have buffer for a rate increase of ~1–2%',
      ];
    } else if (status == 'Fair') {
      return [
        'Your housing costs are near the upper recommended limit',
        'Consider a larger down payment to reduce monthly payments',
        'Paying down existing debts will improve your buying power',
      ];
    } else {
      return [
        'Your debt-to-income ratio exceeds lender guidelines',
        'Increase income or reduce existing debts before applying',
        'A lower-priced home or larger down payment may help',
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.neutral200,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What This Means',
            style: TextStyle(
              fontFamily: 'DMSans',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.white : AppColors.neutral900,
            ),
          ),
          const SizedBox(height: 12),
          ..._bullets.map(
            (text) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    CupertinoIcons.checkmark_circle_fill,
                    size: 18,
                    color: AppColors.success,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      text,
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 14,
                        height: 1.5,
                        color: isDark
                            ? AppColors.neutral300
                            : AppColors.neutral700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Adjust Assumptions row ────────────────────────────────────────────────

class _AdjustAssumptionsRow extends StatelessWidget {
  final bool isDark;
  final VoidCallback onTap;

  const _AdjustAssumptionsRow({required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.neutral200,
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              CupertinoIcons.slider_horizontal_3,
              size: 18,
              color: AppColors.brand700,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Adjust Assumptions',
                style: TextStyle(
                  fontFamily: 'DMSans',
                  fontSize: 15,
                  color: isDark ? AppColors.white : AppColors.neutral800,
                ),
              ),
            ),
            const Icon(
              CupertinoIcons.chevron_right,
              size: 16,
              color: AppColors.neutral400,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Assumption field for bottom sheet ─────────────────────────────────────

class _AssumptionField extends StatefulWidget {
  final String label;
  final String value;
  final String? prefix;
  final String? suffix;
  final ValueChanged<String> onChanged;

  const _AssumptionField({
    required this.label,
    required this.value,
    this.prefix,
    this.suffix,
    required this.onChanged,
  });

  @override
  State<_AssumptionField> createState() => _AssumptionFieldState();
}

class _AssumptionFieldState extends State<_AssumptionField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(
              widget.label,
              style: TextStyle(
                fontFamily: 'DMSans',
                fontSize: 14,
                color: isDark ? AppColors.neutral400 : AppColors.neutral500,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'DMSans',
                fontSize: 15,
                color: isDark ? AppColors.white : AppColors.neutral900,
              ),
              decoration: InputDecoration(
                isDense: true,
                prefixText: widget.prefix,
                suffixText: widget.suffix,
                border: InputBorder.none,
              ),
              onChanged: widget.onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
