import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme_cubit.dart';
import '../../../services/purchase_service.dart';
import 'widgets/settings_row.dart';
import 'widgets/settings_group.dart';
import 'widgets/pro_upgrade_row.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeMode = context.watch<AppThemeCubit>().state;
    final themeLabel = themeMode == ThemeMode.dark
        ? 'Dark'
        : themeMode == ThemeMode.light
            ? 'Light'
            : 'System';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(AppStrings.tabSettings),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
        children: [
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
                icon: CupertinoIcons.sun_max_fill,
                iconColor: AppColors.warning,
                label: 'Theme',
                trailingValue: themeLabel,
                isDark: isDark,
                onTap: () => _showThemePicker(context),
              ),
              SettingsRow(
                icon: CupertinoIcons.clock,
                iconColor: AppColors.brand500,
                label: 'Default Loan Term',
                trailingValue: '30 Years',
                isDark: isDark,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Amortly Pro ────────────────────────────────
          SettingsGroup(
            title: 'Amortly Pro',
            isDark: isDark,
            rows: [
              SettingsRow(
                icon: CupertinoIcons.arrow_clockwise,
                iconColor: AppColors.brand700,
                label: 'Restore Purchases',
                isDark: isDark,
                onTap: () => PurchaseService().restorePurchases(),
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
                onTap: () async {
                  final review = InAppReview.instance;
                  if (await review.isAvailable()) {
                    await review.requestReview();
                  } else {
                    await review.openStoreListing(appStoreId: '');
                  }
                },
              ),
              SettingsRow(
                icon: CupertinoIcons.share,
                iconColor: AppColors.brand700,
                label: 'Share Amortly',
                isDark: isDark,
                onTap: () => Share.share(
                  'Check out Amortly — the best mortgage calculator for iOS! https://apps.apple.com/app/amortly',
                ),
              ),
              SettingsRow(
                icon: CupertinoIcons.doc_text,
                iconColor: AppColors.neutral500,
                label: 'Privacy Policy',
                isDark: isDark,
                onTap: () => launchUrl(
                  Uri.parse('https://amortly.app/privacy'),
                  mode: LaunchMode.externalApplication,
                ),
              ),
              SettingsRow(
                icon: CupertinoIcons.info_circle,
                iconColor: AppColors.neutral500,
                label: 'Terms of Use',
                isDark: isDark,
                onTap: () => launchUrl(
                  Uri.parse('https://amortly.app/terms'),
                  mode: LaunchMode.externalApplication,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // PRO upgrade banner at bottom
          const ProUpgradeRow(),
          const SizedBox(height: 20),

          // Privacy message
          const Center(
            child: Text(
              AppStrings.privacyMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
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

  void _showThemePicker(BuildContext context) {
    final cubit = context.read<AppThemeCubit>();
    showCupertinoModalPopup<void>(
      context: context,
      builder: (sheetContext) => CupertinoActionSheet(
        title: const Text('Theme'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              cubit.setLight();
              Navigator.of(sheetContext, rootNavigator: true).pop();
            },
            child: const Text('Light'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              cubit.setDark();
              Navigator.of(sheetContext, rootNavigator: true).pop();
            },
            child: const Text('Dark'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: false,
          onPressed: () =>
              Navigator.of(sheetContext, rootNavigator: true).pop(),
          child: const Text('Cancel'),
        ),
      ),
    );
  }
}
