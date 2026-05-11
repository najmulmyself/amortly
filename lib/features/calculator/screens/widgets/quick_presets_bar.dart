import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class QuickPresetsBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onSelected;

  const QuickPresetsBar({
    super.key,
    required this.selectedIndex,
    this.onSelected,
  });

  static const _presets = ['15 yr', '20 yr', '30 yr', 'FHA', 'VA'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _presets.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final selected = i == selectedIndex;
          return GestureDetector(
            onTap: () => onSelected?.call(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? AppColors.brand800 : AppColors.brand50,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                _presets[i],
                style: AppTextStyles.buttonChip.copyWith(
                  color: selected ? AppColors.white : AppColors.brand800,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
