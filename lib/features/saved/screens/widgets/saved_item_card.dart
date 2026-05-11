import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class SavedItemCard extends StatelessWidget {
  final String label;
  final String price;
  final String term;
  final String rate;
  final String monthly;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const SavedItemCard({
    super.key,
    required this.label,
    required this.price,
    required this.term,
    required this.rate,
    required this.monthly,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.neutral200,
            width: 0.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.brand800.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                CupertinoIcons.house_fill,
                size: 20,
                color: AppColors.brand800,
              ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.white : AppColors.neutral900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$price · $term · $rate',
                    style: const TextStyle(
                      fontFamily: 'DMSans',
                      fontSize: 13,
                      color: AppColors.neutral500,
                    ),
                  ),
                ],
              ),
            ),

            // Monthly amount
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  monthly,
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.white : AppColors.neutral900,
                  ),
                ),
                const Text(
                  '/ mo',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 11,
                    color: AppColors.neutral400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
