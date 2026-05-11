import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class DisclaimerText extends StatelessWidget {
  final bool short;

  const DisclaimerText({super.key, this.short = false});

  @override
  Widget build(BuildContext context) {
    final text = short
        ? 'For illustrative purposes only. Not financial advice.'
        : 'Calculations are for illustrative purposes only and do not '
            'constitute financial advice. Interest rate, fees, and payment '
            'amounts may vary. Contact a qualified lender for a personalised quote.';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(text, style: AppTextStyles.disclaimer, textAlign: TextAlign.center),
    );
  }
}
