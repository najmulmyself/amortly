import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class PaymentSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double>? onChanged;

  const PaymentSlider({
    super.key,
    required this.value,
    this.min = 0,
    this.max = 1000,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkSurface
            : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkBorder
              : AppColors.neutral200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('EXTRA MONTHLY PAYMENT', style: AppTextStyles.inputLabel),
              Text(
                '\$${value.toStringAsFixed(0)}',
                style: AppTextStyles.inputValue.copyWith(
                  color: AppColors.brand800,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.brand800,
              inactiveTrackColor: AppColors.neutral200,
              thumbColor: AppColors.brand800,
              overlayColor: AppColors.brand800.withAlpha(30),
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('\$${min.toStringAsFixed(0)}', style: AppTextStyles.inputSuffix),
              Text('\$${max.toStringAsFixed(0)}', style: AppTextStyles.inputSuffix),
            ],
          ),
        ],
      ),
    );
  }
}
