import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../services/purchase_service.dart';

/// PRO upgrade banner row — gradient background, title + subtitle, upgrade button.
/// Tapping anywhere calls [PurchaseService.buyPro].
class ProUpgradeRow extends StatelessWidget {
  const ProUpgradeRow({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        try {
          await PurchaseService().buyPro();
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Purchase unavailable: $e'),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.brand800, AppColors.brand700],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Star icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.star_rounded,
                color: AppColors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    AppStrings.proTitle,
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    AppStrings.proSubtitle,
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      fontSize: 13,
                      color: AppColors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),

            // Price badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                AppStrings.proPrice,
                style: TextStyle(
                  fontFamily: 'DMSans',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.brand800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
