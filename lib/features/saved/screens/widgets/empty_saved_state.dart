import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

class EmptySavedState extends StatelessWidget {
  const EmptySavedState({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.neutral100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              CupertinoIcons.bookmark,
              size: 32,
              color: isDark ? AppColors.neutral500 : AppColors.neutral400,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.emptySaved,
            style: TextStyle(
              fontFamily: 'DMSans',
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.white : AppColors.neutral800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.emptySavedSub,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'DMSans',
              fontSize: 14,
              color: AppColors.neutral500,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
