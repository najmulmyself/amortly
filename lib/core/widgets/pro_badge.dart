import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class ProBadge extends StatelessWidget {
  const ProBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.brand800, AppColors.brand700],
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text('PRO', style: AppTextStyles.proBadge),
    );
  }
}
