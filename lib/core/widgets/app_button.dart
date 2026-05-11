import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

enum AppButtonVariant { primary, secondary, chip, chipTeal, danger }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final AppButtonVariant variant;
  final bool isLoading;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.label,
    this.onTap,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case AppButtonVariant.chip:
        return _ChipButton(label: label, onTap: onTap, teal: false, icon: icon);
      case AppButtonVariant.chipTeal:
        return _ChipButton(label: label, onTap: onTap, teal: true, icon: icon);
      case AppButtonVariant.secondary:
        return _SecondaryButton(label: label, onTap: onTap, isLoading: isLoading, icon: icon);
      case AppButtonVariant.danger:
        return _DangerButton(label: label, onTap: onTap);
      case AppButtonVariant.primary:
        return _PrimaryButton(label: label, onTap: onTap, isLoading: isLoading, icon: icon);
    }
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final IconData? icon;

  const _PrimaryButton({required this.label, this.onTap, this.isLoading = false, this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brand800,
          disabledBackgroundColor: AppColors.neutral300,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18, color: AppColors.brand50),
                    const SizedBox(width: 8),
                  ],
                  Text(label, style: AppTextStyles.buttonPrimary),
                ],
              ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final IconData? icon;

  const _SecondaryButton({required this.label, this.onTap, this.isLoading = false, this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: isLoading ? null : onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.brand800,
          side: const BorderSide(color: AppColors.brand300),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: AppColors.brand800),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: AppTextStyles.buttonPrimary.copyWith(color: AppColors.brand800),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChipButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool teal;
  final IconData? icon;

  const _ChipButton({required this.label, this.onTap, this.teal = false, this.icon});

  @override
  Widget build(BuildContext context) {
    final bgColor = teal ? AppColors.accent50 : AppColors.brand50;
    final textStyle = teal ? AppTextStyles.buttonChipTeal : AppTextStyles.buttonChip;
    final iconColor = teal ? AppColors.accent700 : AppColors.brand800;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: iconColor),
              const SizedBox(width: 4),
            ],
            Text(label, style: textStyle),
          ],
        ),
      ),
    );
  }
}

class _DangerButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _DangerButton({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.danger.withAlpha(20),
          foregroundColor: AppColors.danger,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Text(
          label,
          style: AppTextStyles.buttonPrimary.copyWith(color: AppColors.danger),
        ),
      ),
    );
  }
}
