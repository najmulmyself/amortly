import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme_cubit.dart';
import 'widgets/settings_row.dart';
import 'widgets/settings_group.dart';
import 'widgets/pro_upgrade_row.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeCubit = context.watch<AppThemeCubit>();
    final isDarkMode = themeCubit.state == ThemeMode.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(AppStrings.tabSettings),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
        children: [
          // PRO banner
          const ProUpgradeRow(),
          const SizedBox(height: 24),

          // ── Preferences ────────────────────────────────
          SettingsGroup(
            title: 'Preferences',
            isDark: isDark,
            rows: [
              SettingsRow(
                icon: CupertinoIcons.money_dollar,
                iconColor: AppColors.success,
                label: 'Currency',
                trailingValue: 'USD (\$)',
                isDark: isDark,
              ),
              SettingsRow(
                icon: CupertinoIcons.calendar,
                iconColor: AppColors.brand700,
                label: 'Date Format',
                trailingValue: 'May 12 2025',
                isDark: isDark,
              ),
              SettingsRow(
                icon: CupertinoIcons.textformat_123,
                iconColor: AppColors.info,
                label: 'Number Format',
                trailingValue: '1,234.56',
                isDark: isDark,
              ),
              SettingsRow(
                icon: CupertinoIcons.moon_fill,
                iconColor: AppColors.neutral700,
                label: 'Dark Mode',
                showChevron: false,
                isDark: isDark,
                trailingWidget: CupertinoSwitch(
                  value: isDarkMode,
                  activeColor: AppColors.brand700,
                  onChanged: (v) => v
                      ? context.read<AppThemeCubit>().setDark()
                      : context.read<AppThemeCubit>().setLight(),
                ),
              ),
              SettingsRow(
                icon: CupertinoIcons.clock,
                iconColor: AppColors.warning,
                label: 'Default Loan Term',
                trailingValue: '30 Years',
                isDark: isDark,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Trust & Privacy ────────────────────────────
          SettingsGroup(
            title: 'Trust & Privacy',
            isDark: isDark,
            rows: [
              SettingsRow(
                icon: CupertinoIcons.lock_shield_fill,
                iconColor: AppColors.success,
                label: '100% Private',
                trailingValue: '',
                showChevron: false,
                isDark: isDark,
                trailingWidget: const Icon(
                  CupertinoIcons.checkmark_circle_fill,
                  size: 20,
                  color: AppColors.success,
                ),
              ),
              SettingsRow(
                icon: CupertinoIcons.doc_text,
                iconColor: AppColors.brand700,
                label: 'Privacy Policy',
                isDark: isDark,
              ),
              SettingsRow(
                icon: CupertinoIcons.info_circle,
                iconColor: AppColors.neutral500,
                label: 'How Ads Work',
                isDark: isDark,
              ),
              SettingsRow(
                icon: CupertinoIcons.arrow_clockwise_circle,
                iconColor: AppColors.info,
                label: 'Restore Pro Purchase',
                isDark: isDark,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── About ──────────────────────────────────────
          SettingsGroup(
            title: 'About',
            isDark: isDark,
            rows: [
              SettingsRow(
                icon: CupertinoIcons.star_fill,
                iconColor: AppColors.warning,
                label: 'Rate Amortly',
                isDark: isDark,
              ),
              SettingsRow(
                icon: CupertinoIcons.share,
                iconColor: AppColors.brand700,
                label: 'Share Amortly',
                isDark: isDark,
              ),
              SettingsRow(
                icon: CupertinoIcons.info_circle,
                iconColor: AppColors.neutral500,
                label: 'Version 1.0.0',
                trailingValue: '',
                showChevron: false,
                isDark: isDark,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Privacy message
          Center(
            child: Text(
              AppStrings.privacyMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'DMSans',
                fontSize: 12,
                color: AppColors.neutral400,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
