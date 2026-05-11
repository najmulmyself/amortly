import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class OnboardingSlide extends StatelessWidget {
  final String title;
  final String body;
  final IconData icon;

  const OnboardingSlide({
    super.key,
    required this.title,
    required this.body,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.brand800, AppColors.brand700],
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Icon(icon, size: 48, color: AppColors.white),
          ),
          const SizedBox(height: 40),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'DMSans',
              fontSize: 26,
              fontWeight: FontWeight.w500,
              color: AppColors.neutral900,
              letterSpacing: -0.02,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            body,
            style: const TextStyle(
              fontFamily: 'DMSans',
              fontSize: 16,
              color: AppColors.neutral500,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
