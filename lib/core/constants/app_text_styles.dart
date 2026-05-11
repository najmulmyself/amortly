import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract class AppTextStyles {
  static const String _font = 'DMSans';

  // Screen / nav
  static const screenTitle = TextStyle(
    fontFamily: _font,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.neutral900,
    letterSpacing: -0.01,
  );
  static const navTitle = TextStyle(
    fontFamily: _font,
    fontSize: 17,
    fontWeight: FontWeight.w500,
    color: AppColors.neutral900,
  );
  static const navBack = TextStyle(
    fontFamily: _font,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.brand800,
  );

  // Hero numbers (result cards)
  static const heroAmount = TextStyle(
    fontFamily: _font,
    fontSize: 34,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
    letterSpacing: -0.025,
    fontFeatures: [FontFeature.tabularFigures()],
  );
  static const heroAmountLarge = TextStyle(
    fontFamily: _font,
    fontSize: 40,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
    letterSpacing: -0.03,
    fontFeatures: [FontFeature.tabularFigures()],
  );
  static const heroLabel = TextStyle(
    fontFamily: _font,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: Color(0xA5B5D4F4),
    letterSpacing: 0.07,
  );
  static const heroSub = TextStyle(
    fontFamily: _font,
    fontSize: 12,
    color: Color(0x8CB5D4F4),
  );
  static const heroStat = TextStyle(
    fontFamily: _font,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.brand100,
    fontFeatures: [FontFeature.tabularFigures()],
  );
  static const heroStatLabel = TextStyle(
    fontFamily: _font,
    fontSize: 10,
    color: Color(0x80B5D4F4),
  );

  // Form / input
  static const inputLabel = TextStyle(
    fontFamily: _font,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.neutral500,
    letterSpacing: 0.07,
  );
  static const inputValue = TextStyle(
    fontFamily: _font,
    fontSize: 21,
    fontWeight: FontWeight.w500,
    color: AppColors.neutral900,
    fontFeatures: [FontFeature.tabularFigures()],
  );
  static const inputPrefix = TextStyle(
    fontFamily: _font,
    fontSize: 15,
    color: AppColors.neutral400,
  );
  static const inputSuffix = TextStyle(
    fontFamily: _font,
    fontSize: 13,
    color: AppColors.neutral400,
  );

  // Card content
  static const cardTitle = TextStyle(
    fontFamily: _font,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.neutral900,
  );
  static const cardSubtitle = TextStyle(
    fontFamily: _font,
    fontSize: 10,
    color: AppColors.neutral500,
  );
  static const cardValue = TextStyle(
    fontFamily: _font,
    fontSize: 17,
    fontWeight: FontWeight.w500,
    color: AppColors.neutral900,
    fontFeatures: [FontFeature.tabularFigures()],
  );
  static const cardValueLarge = TextStyle(
    fontFamily: _font,
    fontSize: 19,
    fontWeight: FontWeight.w500,
    color: AppColors.neutral900,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  // Table
  static const tableHeader = TextStyle(
    fontFamily: 'SF Mono',
    fontSize: 9.5,
    fontWeight: FontWeight.w500,
    color: AppColors.neutral500,
    letterSpacing: 0.04,
  );
  static const tableCell = TextStyle(
    fontFamily: 'SF Mono',
    fontSize: 11,
    color: AppColors.neutral900,
    fontFeatures: [FontFeature.tabularFigures()],
  );
  static const tableCellPrincipal = TextStyle(
    fontFamily: 'SF Mono',
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.brand800,
    fontFeatures: [FontFeature.tabularFigures()],
  );
  static const tableCellInterest = TextStyle(
    fontFamily: 'SF Mono',
    fontSize: 11,
    color: AppColors.brand500,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  // Buttons
  static const buttonPrimary = TextStyle(
    fontFamily: _font,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.brand50,
  );
  static const buttonChip = TextStyle(
    fontFamily: _font,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.brand800,
  );
  static const buttonChipTeal = TextStyle(
    fontFamily: _font,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.accent700,
  );

  // Misc
  static const sectionLabel = TextStyle(
    fontFamily: _font,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.neutral500,
    letterSpacing: 0.07,
  );
  static const disclaimer = TextStyle(
    fontFamily: _font,
    fontSize: 9.5,
    color: AppColors.neutral400,
    height: 1.5,
  );
  static const proBadge = TextStyle(
    fontFamily: _font,
    fontSize: 9,
    fontWeight: FontWeight.w500,
    color: AppColors.brand50,
    letterSpacing: 0.05,
  );
  static const settingsRowLabel = TextStyle(
    fontFamily: _font,
    fontSize: 13,
    color: AppColors.neutral900,
  );
  static const settingsRowValue = TextStyle(
    fontFamily: _font,
    fontSize: 12,
    color: AppColors.neutral500,
  );
  static const tealValue = TextStyle(
    fontFamily: _font,
    fontSize: 17,
    fontWeight: FontWeight.w500,
    color: AppColors.accent700,
    fontFeatures: [FontFeature.tabularFigures()],
  );
  static const tealLabel = TextStyle(
    fontFamily: _font,
    fontSize: 10,
    color: AppColors.accent700,
    letterSpacing: 0.07,
  );
}
