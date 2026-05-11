import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// A single settings row with optional trailing value, chevron, or switch.
class SettingsRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String? trailingValue;
  final bool showChevron;
  final Widget? trailingWidget;
  final VoidCallback? onTap;
  final bool isDark;

  const SettingsRow({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    this.trailingValue,
    this.showChevron = true,
    this.trailingWidget,
    this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: iconColor),
            ),
            const SizedBox(width: 14),

            // Label
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'DMSans',
                  fontSize: 15,
                  color: isDark ? AppColors.white : AppColors.neutral800,
                ),
              ),
            ),

            // Trailing
            if (trailingWidget != null) ...[
              trailingWidget!,
            ] else ...[
              if (trailingValue != null)
                Text(
                  trailingValue!,
                  style: const TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 15,
                    color: AppColors.neutral400,
                  ),
                ),
              if (showChevron)
                const Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: Icon(
                    CupertinoIcons.chevron_right,
                    size: 14,
                    color: AppColors.neutral400,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
