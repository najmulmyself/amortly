import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/disclaimer_text.dart';
import 'widgets/dti_progress_bar.dart';
import 'widgets/max_home_card.dart';

class AffordabilityScreen extends StatelessWidget {
  const AffordabilityScreen({super.key});

  void _showInfoSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'How We Calculate Affordability',
                style: TextStyle(
                  fontFamily: 'DMSans',
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
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
          const MaxHomeCard(
            maxHomePrice: '\$512,000',
            statusLabel: 'Good',
            statusDescription:
                'Based on your income, this home is within a comfortable budget range.',
          ),
          const SizedBox(height: 20),

          // Key metrics card
          _MetricsCard(isDark: isDark),
          const SizedBox(height: 20),

          // DTI bars
          _DtiBarsCard(isDark: isDark),
          const SizedBox(height: 20),

          // What This Means
          _WhatThisMeansCard(isDark: isDark),
          const SizedBox(height: 20),

          // Adjust Assumptions
          _AdjustAssumptionsRow(isDark: isDark),
          const SizedBox(height: 20),

          const DisclaimerText(),
        ],
      ),
    );
  }
}

// ─── Metrics card ──────────────────────────────────────────────────────────

class _MetricsCard extends StatelessWidget {
  final bool isDark;
  const _MetricsCard({required this.isDark});

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
            value: '\$2,744 / mo',
            badge: 'Good',
            badgeGreen: true,
            isDark: isDark,
            showBorder: true,
          ),
          _MetricRow(
            icon: CupertinoIcons.person_2,
            label: 'Household Income',
            value: '\$8,000 / mo',
            isDark: isDark,
            showBorder: true,
          ),
          _MetricRow(
            icon: CupertinoIcons.percent,
            label: 'DTI Ratio',
            value: '29.6%',
            badge: 'Good',
            badgeGreen: true,
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
  const _DtiBarsCard({required this.isDark});

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
          const DtiProgressBar(
            label: 'Front-End DTI (Housing)',
            percent: 24.1,
            status: 'Good',
          ),
          const SizedBox(height: 16),
          const DtiProgressBar(
            label: 'Back-End DTI (All Debt)',
            percent: 29.6,
            status: 'Good',
          ),
          const SizedBox(height: 12),
          Text(
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
  const _WhatThisMeansCard({required this.isDark});

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
          ..._bullets(isDark, [
            'Your housing costs are within the recommended 28% threshold',
            'Your total debt payments are well below the 36% back-end limit',
            'You have buffer for a rate increase of ~1–2%',
          ]),
        ],
      ),
    );
  }

  List<Widget> _bullets(bool isDark, List<String> items) {
    return items
        .map(
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
                      color: isDark ? AppColors.neutral300 : AppColors.neutral700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }
}

// ─── Adjust Assumptions row ────────────────────────────────────────────────

class _AdjustAssumptionsRow extends StatelessWidget {
  final bool isDark;
  const _AdjustAssumptionsRow({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
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
