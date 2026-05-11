# AMORTLY — Mortgage Calculator
## Complete Technical Requirements & Coding Agent Prompt

> **How to use this file:** Copy this entire document and paste it as your system prompt or first message to GitHub Copilot, Cursor, Claude Code, or any coding agent. Every section is written to be machine-readable. Follow the order: set up project → implement models → implement calculators → implement screens → add AdMob → add IAP → test.

---

## 0. AGENT INSTRUCTIONS (READ FIRST)

You are building a production iOS app called **Amortly** using Flutter. The app is a mortgage and loan calculator targeting US, UK, Canada, and Australia markets. Your goal is a clean, maintainable codebase that a solo developer can ship and maintain.

**Non-negotiable rules:**
1. All calculations are 100% offline — no HTTP requests for math
2. All user data stays on device — no Firebase, no Supabase, no analytics SDK
3. Every monetary value uses `double` with proper rounding — never `int` for currency
4. Separate business logic (calculators) from UI completely — calculators are pure Dart functions with no Flutter dependency
5. Use Cubit (from flutter_bloc) for state — not setState, not Provider, not Riverpod
6. Every screen file is under 200 lines — extract widgets if longer
7. Format all currency using the `intl` package — never hardcode "$" symbols
8. Write a unit test for every public calculator function before implementing the UI that uses it

---

## 1. TECHNOLOGY STACK

### 1.1 Framework & Language
```
Flutter:         ^3.22.0
Dart:            ^3.4.0
Target platform: iOS only (minimum iOS 16.0)
Architecture:    Feature-first, clean architecture with Cubit
```

### 1.2 Dependencies (pubspec.yaml)
```yaml
dependencies:
  flutter:
    sdk: flutter

  # State management
  flutter_bloc: ^8.1.6
  equatable: ^2.0.5

  # Local storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0

  # Simple key-value storage
  shared_preferences: ^2.3.2

  # Ads
  google_mobile_ads: ^5.3.0

  # In-app purchase
  in_app_purchase: ^3.2.0

  # Charts
  fl_chart: ^0.69.0

  # PDF export (Pro feature)
  pdf: ^3.10.8
  printing: ^5.13.1

  # Sharing
  share_plus: ^10.0.3

  # Currency & number formatting
  intl: ^0.19.0

  # In-app review (prompt for App Store rating)
  in_app_review: ^2.0.9

  # URL launcher (for Privacy Policy)
  url_launcher: ^6.3.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  hive_generator: ^2.0.1
  build_runner: ^2.4.9
  flutter_lints: ^4.0.0
```

### 1.3 Minimum iOS Configuration
```
# ios/Podfile
platform :ios, '16.0'

# ios/Runner/Info.plist — required entries
NSUserTrackingUsageDescription: "We use this to show relevant mortgage and home-buying ads. You can opt out at any time in Settings."
GADApplicationIdentifier: "ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY"  # Replace with real AdMob App ID
```

---

## 2. PROJECT STRUCTURE

Create this exact folder structure. Do not deviate.

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart          # All color values as static const
│   │   ├── app_text_styles.dart     # All TextStyle definitions
│   │   ├── app_strings.dart         # All user-facing strings (no hardcoded strings in widgets)
│   │   └── app_constants.dart       # Non-UI constants (max loan, min rate, etc.)
│   ├── theme/
│   │   ├── app_theme.dart           # ThemeData light + dark
│   │   └── app_theme_cubit.dart     # Cubit for light/dark toggle
│   ├── utils/
│   │   ├── currency_formatter.dart  # formatCurrency(), formatCurrencyCompact()
│   │   ├── date_formatter.dart      # formatMonthYear(), formatDate()
│   │   └── validators.dart          # validateLoanAmount(), validateRate(), etc.
│   └── widgets/
│       ├── app_button.dart          # Primary, secondary, chip button variants
│       ├── input_row.dart           # Standard labeled input row for forms
│       ├── disclaimer_text.dart     # The required "not financial advice" disclaimer
│       ├── pro_badge.dart           # Small "PRO" badge widget
│       ├── section_label.dart       # Uppercase section header
│       └── result_hero_card.dart    # The dark blue result card reused across screens
│
├── features/
│   ├── onboarding/
│   │   ├── screens/
│   │   │   └── onboarding_screen.dart
│   │   └── widgets/
│   │       └── onboarding_slide.dart
│   │
│   ├── calculator/
│   │   ├── models/
│   │   │   ├── mortgage_input.dart       # Input value object
│   │   │   └── mortgage_result.dart      # Calculated result value object
│   │   ├── services/
│   │   │   └── mortgage_calculator.dart  # PURE DART — no Flutter imports
│   │   ├── cubit/
│   │   │   ├── calculator_cubit.dart
│   │   │   └── calculator_state.dart
│   │   └── screens/
│   │       ├── calculator_screen.dart
│   │       └── widgets/
│   │           ├── loan_input_form.dart
│   │           ├── result_card.dart
│   │           └── quick_presets_bar.dart
│   │
│   ├── extra_payment/
│   │   ├── models/
│   │   │   └── extra_payment_result.dart
│   │   ├── services/
│   │   │   └── extra_payment_calculator.dart  # PURE DART
│   │   ├── cubit/
│   │   │   ├── extra_payment_cubit.dart
│   │   │   └── extra_payment_state.dart
│   │   └── screens/
│   │       ├── extra_payment_screen.dart
│   │       └── widgets/
│   │           ├── savings_summary_card.dart
│   │           ├── payment_slider.dart
│   │           ├── comparison_cards.dart
│   │           └── balance_chart.dart
│   │
│   ├── schedule/
│   │   ├── models/
│   │   │   └── amortization_row.dart
│   │   ├── services/
│   │   │   └── amortization_calculator.dart  # PURE DART
│   │   ├── cubit/
│   │   │   ├── schedule_cubit.dart
│   │   │   └── schedule_state.dart
│   │   └── screens/
│   │       ├── schedule_screen.dart
│   │       └── widgets/
│   │           ├── loan_summary_card.dart
│   │           ├── amortization_table.dart
│   │           ├── principal_interest_donut.dart
│   │           └── balance_line_chart.dart
│   │
│   ├── compare/
│   │   ├── models/
│   │   │   └── comparison_result.dart
│   │   ├── cubit/
│   │   │   ├── compare_cubit.dart
│   │   │   └── compare_state.dart
│   │   └── screens/
│   │       ├── compare_screen.dart
│   │       └── widgets/
│   │           ├── compare_header_cards.dart
│   │           ├── metric_row.dart
│   │           └── better_choice_card.dart
│   │
│   ├── affordability/
│   │   ├── models/
│   │   │   └── affordability_result.dart
│   │   ├── services/
│   │   │   └── affordability_calculator.dart  # PURE DART
│   │   ├── cubit/
│   │   │   ├── affordability_cubit.dart
│   │   │   └── affordability_state.dart
│   │   └── screens/
│   │       ├── affordability_screen.dart
│   │       └── widgets/
│   │           ├── max_home_card.dart
│   │           └── dti_progress_bar.dart
│   │
│   ├── saved/
│   │   ├── models/
│   │   │   └── saved_calculation.dart  # @HiveType Hive model
│   │   ├── cubit/
│   │   │   ├── saved_cubit.dart
│   │   │   └── saved_state.dart
│   │   └── screens/
│   │       ├── saved_screen.dart
│   │       └── widgets/
│   │           ├── saved_item_card.dart
│   │           └── empty_saved_state.dart
│   │
│   └── settings/
│       ├── cubit/
│       │   ├── settings_cubit.dart
│       │   └── settings_state.dart
│       └── screens/
│           ├── settings_screen.dart
│           └── widgets/
│               ├── settings_row.dart
│               ├── settings_group.dart
│               └── pro_upgrade_row.dart
│
├── services/
│   ├── ad_service.dart          # AdMob interstitial + banner management
│   ├── purchase_service.dart    # IAP — Pro unlock + restore
│   ├── storage_service.dart     # Hive init + CRUD wrapper
│   └── review_service.dart      # in_app_review trigger logic
│
├── navigation/
│   └── app_router.dart          # GoRouter or Navigator 2.0 routes
│
├── app.dart                     # MaterialApp + theme + router
└── main.dart                    # Hive.init + AdMob init + ATT prompt

test/
├── calculator/
│   ├── mortgage_calculator_test.dart
│   ├── extra_payment_calculator_test.dart
│   ├── amortization_calculator_test.dart
│   └── affordability_calculator_test.dart
└── utils/
    └── currency_formatter_test.dart
```

---

## 3. COLOR SYSTEM (app_colors.dart)

```dart
// lib/core/constants/app_colors.dart
import 'package:flutter/material.dart';

abstract class AppColors {
  // Brand Blues
  static const Color brand900 = Color(0xFF0D2444);
  static const Color brand800 = Color(0xFF1B3F6E); // PRIMARY — buttons, hero cards
  static const Color brand700 = Color(0xFF2D5A9E); // hover, borders
  static const Color brand500 = Color(0xFF4A76A8); // secondary, chart interest
  static const Color brand300 = Color(0xFF7BA3CA); // dividers on dark bg
  static const Color brand100 = Color(0xFFB5D4F4); // text on dark brand bg
  static const Color brand50  = Color(0xFFE8F1FC); // tinted bg, chip fills

  // Accent Teal (savings, positive states)
  static const Color accent700 = Color(0xFF007A5C); // text on teal bg
  static const Color accent500 = Color(0xFF00A87E); // PRIMARY accent
  static const Color accent100 = Color(0xFFA7E3D0); // teal borders
  static const Color accent50  = Color(0xFFE0F7F2); // teal card bg

  // Neutrals
  static const Color neutral950 = Color(0xFF060D14); // pure dark
  static const Color neutral900 = Color(0xFF0F1D2E); // dark mode bg, primary text
  static const Color neutral800 = Color(0xFF1E2D3E); // dark mode surface
  static const Color neutral700 = Color(0xFF2E3D50); // dark mode elevated
  static const Color neutral500 = Color(0xFF6B7A8D); // secondary text, labels
  static const Color neutral400 = Color(0xFF9AAABE); // placeholder, disabled
  static const Color neutral300 = Color(0xFFC8D8E8); // borders, dividers
  static const Color neutral200 = Color(0xFFDDE8F4); // subtle borders
  static const Color neutral100 = Color(0xFFEFF4FA); // dark mode input bg
  static const Color neutral50  = Color(0xFFF5F8FC); // screen background (light)

  // Semantic
  static const Color success    = Color(0xFF10B981);
  static const Color warning    = Color(0xFFF59E0B);
  static const Color danger     = Color(0xFFEF4444);
  static const Color info       = Color(0xFF3B82F6);

  static const Color white      = Color(0xFFFFFFFF);

  // Dark mode surface colors (used in ThemeData dark)
  static const Color darkSurface       = Color(0xFF1E2D3E);
  static const Color darkElevated      = Color(0xFF2E3D50);
  static const Color darkBorder        = Color(0x14FFFFFF); // rgba(255,255,255,0.08)
  static const Color darkBorderSubtle  = Color(0x0AFFFFFF); // rgba(255,255,255,0.06)
}
```

---

## 4. TEXT STYLES (app_text_styles.dart)

```dart
// lib/core/constants/app_text_styles.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

// IMPORTANT: Load DM Sans font.
// Add to pubspec.yaml fonts section:
// fonts:
//   - family: DMSans
//     fonts:
//       - asset: assets/fonts/DMSans-Regular.ttf
//       - asset: assets/fonts/DMSans-Medium.ttf  weight: 500
//
// Download from Google Fonts: https://fonts.google.com/specimen/DM+Sans

abstract class AppTextStyles {
  static const String _font = 'DMSans';

  // Screen background text
  static const screenTitle = TextStyle(
    fontFamily: _font, fontSize: 20, fontWeight: FontWeight.w500,
    color: AppColors.neutral900, letterSpacing: -0.01,
  );
  static const navTitle = TextStyle(
    fontFamily: _font, fontSize: 17, fontWeight: FontWeight.w500,
    color: AppColors.neutral900,
  );
  static const navBack = TextStyle(
    fontFamily: _font, fontSize: 15, fontWeight: FontWeight.w400,
    color: AppColors.brand800,
  );

  // Hero numbers (result cards)
  static const heroAmount = TextStyle(
    fontFamily: _font, fontSize: 34, fontWeight: FontWeight.w500,
    color: AppColors.white, letterSpacing: -0.025,
    fontFeatures: [FontFeature.tabularFigures()],
  );
  static const heroAmountLarge = TextStyle(
    fontFamily: _font, fontSize: 40, fontWeight: FontWeight.w500,
    color: AppColors.white, letterSpacing: -0.03,
    fontFeatures: [FontFeature.tabularFigures()],
  );
  static const heroLabel = TextStyle(
    fontFamily: _font, fontSize: 10, fontWeight: FontWeight.w500,
    color: Color(0xA5B5D4F4), // rgba(181,212,244, 0.65)
    letterSpacing: 0.07,
  );
  static const heroSub = TextStyle(
    fontFamily: _font, fontSize: 12,
    color: Color(0x8CB5D4F4), // rgba(181,212,244, 0.55)
  );
  static const heroStat = TextStyle(
    fontFamily: _font, fontSize: 13, fontWeight: FontWeight.w500,
    color: AppColors.brand100,
    fontFeatures: [FontFeature.tabularFigures()],
  );
  static const heroStatLabel = TextStyle(
    fontFamily: _font, fontSize: 10, color: Color(0x80B5D4F4),
  );

  // Form / input
  static const inputLabel = TextStyle(
    fontFamily: _font, fontSize: 10, fontWeight: FontWeight.w500,
    color: AppColors.neutral500, letterSpacing: 0.07,
  );
  static const inputValue = TextStyle(
    fontFamily: _font, fontSize: 21, fontWeight: FontWeight.w500,
    color: AppColors.neutral900,
    fontFeatures: [FontFeature.tabularFigures()],
  );
  static const inputPrefix = TextStyle(
    fontFamily: _font, fontSize: 15, color: AppColors.neutral400,
  );
  static const inputSuffix = TextStyle(
    fontFamily: _font, fontSize: 13, color: AppColors.neutral400,
  );

  // Card content
  static const cardTitle = TextStyle(
    fontFamily: _font, fontSize: 13, fontWeight: FontWeight.w500,
    color: AppColors.neutral900,
  );
  static const cardSubtitle = TextStyle(
    fontFamily: _font, fontSize: 10, color: AppColors.neutral500,
  );
  static const cardValue = TextStyle(
    fontFamily: _font, fontSize: 17, fontWeight: FontWeight.w500,
    color: AppColors.neutral900,
    fontFeatures: [FontFeature.tabularFigures()],
  );
  static const cardValueLarge = TextStyle(
    fontFamily: _font, fontSize: 19, fontWeight: FontWeight.w500,
    color: AppColors.neutral900,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  // Table
  static const tableHeader = TextStyle(
    fontFamily: 'SF Mono', fontSize: 9.5, fontWeight: FontWeight.w500,
    color: AppColors.neutral500, letterSpacing: 0.04,
  );
  static const tableCell = TextStyle(
    fontFamily: 'SF Mono', fontSize: 11, color: AppColors.neutral900,
    fontFeatures: [FontFeature.tabularFigures()],
  );
  static const tableCellPrincipal = TextStyle(
    fontFamily: 'SF Mono', fontSize: 11, fontWeight: FontWeight.w500,
    color: AppColors.brand800,
    fontFeatures: [FontFeature.tabularFigures()],
  );
  static const tableCellInterest = TextStyle(
    fontFamily: 'SF Mono', fontSize: 11, color: AppColors.brand500,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  // Buttons
  static const buttonPrimary = TextStyle(
    fontFamily: _font, fontSize: 15, fontWeight: FontWeight.w500,
    color: AppColors.brand50,
  );
  static const buttonChip = TextStyle(
    fontFamily: _font, fontSize: 12, fontWeight: FontWeight.w500,
    color: AppColors.brand800,
  );
  static const buttonChipTeal = TextStyle(
    fontFamily: _font, fontSize: 12, fontWeight: FontWeight.w500,
    color: AppColors.accent700,
  );

  // Misc
  static const sectionLabel = TextStyle(
    fontFamily: _font, fontSize: 11, fontWeight: FontWeight.w500,
    color: AppColors.neutral500, letterSpacing: 0.07,
  );
  static const disclaimer = TextStyle(
    fontFamily: _font, fontSize: 9.5, color: AppColors.neutral400,
    height: 1.5,
  );
  static const proBadge = TextStyle(
    fontFamily: _font, fontSize: 9, fontWeight: FontWeight.w500,
    color: AppColors.brand50, letterSpacing: 0.05,
  );
  static const settingsRowLabel = TextStyle(
    fontFamily: _font, fontSize: 13, color: AppColors.neutral900,
  );
  static const settingsRowValue = TextStyle(
    fontFamily: _font, fontSize: 12, color: AppColors.neutral500,
  );
  static const tealValue = TextStyle(
    fontFamily: _font, fontSize: 17, fontWeight: FontWeight.w500,
    color: AppColors.accent700,
    fontFeatures: [FontFeature.tabularFigures()],
  );
  static const tealLabel = TextStyle(
    fontFamily: _font, fontSize: 10, color: AppColors.accent700,
    letterSpacing: 0.07,
  );
}
```

---

## 5. DATA MODELS

### 5.1 MortgageInput
```dart
// lib/features/calculator/models/mortgage_input.dart

class MortgageInput {
  final double loanAmount;       // e.g. 360000.0
  final double annualRatePercent;// e.g. 6.25 (NOT 0.0625)
  final int termYears;           // e.g. 30
  final double propertyTaxAnnual;// e.g. 4500.0 (0 if not entered)
  final double homeInsuranceAnnual;// e.g. 1200.0 (0 if not entered)
  final double pmiAnnual;        // e.g. 0 (0 if not entered)
  final DateTime? startDate;     // optional — for payoff date calculation

  const MortgageInput({
    required this.loanAmount,
    required this.annualRatePercent,
    required this.termYears,
    this.propertyTaxAnnual = 0,
    this.homeInsuranceAnnual = 0,
    this.pmiAnnual = 0,
    this.startDate,
  });

  // Derived convenience getters
  double get monthlyRate => annualRatePercent / 100 / 12;
  int get termMonths => termYears * 12;
  double get monthlyTax => propertyTaxAnnual / 12;
  double get monthlyInsurance => homeInsuranceAnnual / 12;
  double get monthlyPmi => pmiAnnual / 12;

  MortgageInput copyWith({...}); // standard copyWith
}
```

### 5.2 MortgageResult
```dart
// lib/features/calculator/models/mortgage_result.dart

class MortgageResult {
  final double monthlyPrincipalAndInterest; // core P&I payment
  final double monthlyTaxes;               // monthly property tax
  final double monthlyInsurance;           // monthly home insurance
  final double monthlyPmi;                 // monthly PMI
  final double totalMonthlyPayment;        // P&I + taxes + insurance + PMI
  final double totalInterestPaid;          // total interest over full term
  final double totalAmountPaid;            // loan + total interest
  final DateTime? payoffDate;              // calculated from startDate + termMonths
  final MortgageInput input;               // keep reference to inputs
}
```

### 5.3 AmortizationRow
```dart
// lib/features/schedule/models/amortization_row.dart

class AmortizationRow {
  final int month;          // 1-based: 1, 2, 3...360
  final int year;           // 1-based: 1, 1, 1... (12 months per year)
  final double payment;     // same every month (P&I only)
  final double principal;   // portion going to principal
  final double interest;    // portion going to interest
  final double balance;     // remaining balance after this payment
  final DateTime? date;     // actual calendar date if startDate was provided

  // For yearly summaries
  double get yearlyPayment => payment * 12; // approximate
}
```

### 5.4 ExtraPaymentResult
```dart
// lib/features/extra_payment/models/extra_payment_result.dart

class ExtraPaymentResult {
  final double extraMonthlyPayment;     // the extra amount added
  final double newTotalMonthly;         // original P&I + extra
  final int originalTermMonths;         // months without extra payments
  final int newTermMonths;              // months WITH extra payments
  final int monthsSaved;                // difference
  final int yearsSaved;                 // monthsSaved ~/ 12
  final int remainingMonthsSaved;       // monthsSaved % 12
  final double originalTotalInterest;   // without extra
  final double newTotalInterest;        // with extra
  final double interestSaved;           // difference
  final DateTime? newPayoffDate;        // calculated from startDate
  final DateTime? originalPayoffDate;
  final List<BalancePoint> withExtraBalanceCurve;    // for chart
  final List<BalancePoint> withoutExtraBalanceCurve; // for chart
}

class BalancePoint {
  final int month;
  final double balance;
}
```

### 5.5 AffordabilityResult
```dart
// lib/features/affordability/models/affordability_result.dart

class AffordabilityResult {
  final double maxHomePrice;
  final double maxLoanAmount;
  final double downPayment;
  final double monthlyPayment;
  final double frontEndDtiPercent;   // housing costs / gross income
  final double backEndDtiPercent;    // all debts / gross income
  final DTIStatus frontEndStatus;    // good / moderate / high
  final DTIStatus backEndStatus;
}

enum DTIStatus { good, moderate, high, tooHigh }
// good: frontEnd ≤ 28%, backEnd ≤ 36%
// moderate: frontEnd ≤ 31%, backEnd ≤ 43%
// high: frontEnd ≤ 36%, backEnd ≤ 50%
// tooHigh: over those limits
```

### 5.6 SavedCalculation (Hive model)
```dart
// lib/features/saved/models/saved_calculation.dart
import 'package:hive/hive.dart';

part 'saved_calculation.g.dart';

@HiveType(typeId: 0)
class SavedCalculation extends HiveObject {
  @HiveField(0) String id;           // UUID
  @HiveField(1) String name;         // user-given name: "Dream Home"
  @HiveField(2) double loanAmount;
  @HiveField(3) double annualRate;
  @HiveField(4) int termYears;
  @HiveField(5) double monthlyPayment;
  @HiveField(6) double propertyTax;
  @HiveField(7) double homeInsurance;
  @HiveField(8) double pmi;
  @HiveField(9) DateTime savedAt;
  @HiveField(10) String? notes;
}
```

---

## 6. CALCULATOR IMPLEMENTATIONS

> **CRITICAL:** These are pure Dart functions. No imports from Flutter (`dart:ui`, `package:flutter`). Only `dart:math`. Write tests FIRST for every function using the reference values in Section 9.

### 6.1 Core Mortgage Calculator

```dart
// lib/features/calculator/services/mortgage_calculator.dart
// NO flutter imports — pure Dart only
import 'dart:math';

class MortgageCalculator {

  /// Calculate monthly Principal & Interest payment
  /// 
  /// Formula (standard amortization):
  ///   M = P × [r(1+r)^n] / [(1+r)^n - 1]
  ///
  /// Where:
  ///   P = principal (loan amount)
  ///   r = monthly interest rate (annual rate / 100 / 12)
  ///   n = total number of payments (years × 12)
  ///   M = monthly payment
  ///
  /// Edge case: if r == 0 (0% interest), M = P / n (simple division)
  static double calculateMonthlyPayment({
    required double principal,
    required double annualRatePercent,
    required int termYears,
  }) {
    if (principal <= 0) return 0;
    if (termYears <= 0) return 0;

    final int n = termYears * 12;
    final double r = annualRatePercent / 100 / 12;

    if (r == 0) {
      // Zero-interest loan (uncommon but valid)
      return _roundToCents(principal / n);
    }

    final double numerator = principal * r * pow(1 + r, n);
    final double denominator = pow(1 + r, n) - 1;

    return _roundToCents(numerator / denominator);
  }

  /// Calculate total interest paid over the full loan term
  static double calculateTotalInterest({
    required double principal,
    required double annualRatePercent,
    required int termYears,
  }) {
    final double monthly = calculateMonthlyPayment(
      principal: principal,
      annualRatePercent: annualRatePercent,
      termYears: termYears,
    );
    final double totalPaid = monthly * termYears * 12;
    return _roundToCents(totalPaid - principal);
  }

  /// Calculate full MortgageResult
  static MortgageResult calculate(MortgageInput input) {
    final double pi = calculateMonthlyPayment(
      principal: input.loanAmount,
      annualRatePercent: input.annualRatePercent,
      termYears: input.termYears,
    );

    final double totalInterest = calculateTotalInterest(
      principal: input.loanAmount,
      annualRatePercent: input.annualRatePercent,
      termYears: input.termYears,
    );

    final DateTime? payoffDate = input.startDate != null
        ? DateTime(
            input.startDate!.year,
            input.startDate!.month + input.termYears * 12,
          )
        : null;

    return MortgageResult(
      monthlyPrincipalAndInterest: pi,
      monthlyTaxes: input.monthlyTax,
      monthlyInsurance: input.monthlyInsurance,
      monthlyPmi: input.monthlyPmi,
      totalMonthlyPayment: pi + input.monthlyTax + input.monthlyInsurance + input.monthlyPmi,
      totalInterestPaid: totalInterest,
      totalAmountPaid: input.loanAmount + totalInterest,
      payoffDate: payoffDate,
      input: input,
    );
  }

  static double _roundToCents(double value) =>
      (value * 100).round() / 100;
}
```

**Unit test verification values:**
```
Input:  P=$360,000, rate=6.25%, term=30yr
Output: M=$2,216.52/mo (P&I only)
        Total Interest = $438,347.20
        Total Paid = $798,347.20

Input:  P=$450,000, rate=6.5%, term=30yr
Output: M=$2,844.06/mo
        Total Interest = $573,461.60

Input:  P=$200,000, rate=0%, term=20yr
Output: M=$833.33/mo (0% edge case)

Input:  P=$0
Output: M=$0.00 (zero principal edge case)
```

---

### 6.2 Amortization Schedule Calculator

```dart
// lib/features/schedule/services/amortization_calculator.dart
import 'dart:math';

class AmortizationCalculator {

  /// Generate complete month-by-month amortization schedule.
  ///
  /// Each month:
  ///   interest_payment = remaining_balance × monthly_rate
  ///   principal_payment = monthly_payment - interest_payment
  ///   new_balance = remaining_balance - principal_payment
  ///
  /// Final month adjustment: last principal may differ slightly
  /// due to rounding — set final payment to exact remaining balance.
  static List<AmortizationRow> generateSchedule({
    required double principal,
    required double annualRatePercent,
    required int termYears,
    DateTime? startDate,
  }) {
    final double monthlyPayment = MortgageCalculator.calculateMonthlyPayment(
      principal: principal,
      annualRatePercent: annualRatePercent,
      termYears: termYears,
    );

    final double r = annualRatePercent / 100 / 12;
    final int n = termYears * 12;
    final List<AmortizationRow> rows = [];
    double balance = principal;

    for (int month = 1; month <= n; month++) {
      final double interestPayment = _roundToCents(balance * r);
      double principalPayment = _roundToCents(monthlyPayment - interestPayment);

      // Final month: pay exact remaining balance to avoid rounding errors
      if (month == n) {
        principalPayment = balance;
      }

      balance = _roundToCents(balance - principalPayment);
      // Guard against floating point going slightly below zero
      if (balance < 0) balance = 0;

      final DateTime? date = startDate != null
          ? DateTime(startDate.year, startDate.month + month - 1)
          : null;

      rows.add(AmortizationRow(
        month: month,
        year: ((month - 1) ~/ 12) + 1,
        payment: monthlyPayment,
        principal: principalPayment,
        interest: interestPayment,
        balance: balance,
        date: date,
      ));
    }
    return rows;
  }

  /// Group monthly rows into yearly summaries for the "Yearly" toggle view
  static List<YearlySummaryRow> toYearlySummary(List<AmortizationRow> rows) {
    final Map<int, List<AmortizationRow>> byYear = {};
    for (final row in rows) {
      byYear.putIfAbsent(row.year, () => []).add(row);
    }
    return byYear.entries.map((e) {
      final yearRows = e.value;
      return YearlySummaryRow(
        year: e.key,
        totalPayment: yearRows.fold(0, (s, r) => s + r.payment),
        totalPrincipal: yearRows.fold(0, (s, r) => s + r.principal),
        totalInterest: yearRows.fold(0, (s, r) => s + r.interest),
        endingBalance: yearRows.last.balance,
      );
    }).toList();
  }

  /// Find the month where principal payment exceeds interest payment.
  /// This is the insight displayed as the callout on the Schedule screen.
  static int? findPrincipalOvertakesInterestMonth(List<AmortizationRow> rows) {
    for (final row in rows) {
      if (row.principal > row.interest) return row.month;
    }
    return null;
  }

  static double _roundToCents(double v) => (v * 100).round() / 100;
}
```

---

### 6.3 Extra Payment Calculator

```dart
// lib/features/extra_payment/services/extra_payment_calculator.dart
import 'dart:math';

class ExtraPaymentCalculator {

  /// Calculate savings from making extra monthly payments.
  ///
  /// Algorithm: simulate month-by-month with the extra payment applied.
  /// Stop when balance reaches 0 — that's the new term.
  ///
  /// This is more accurate than algebraic shortcuts because it handles
  /// the case where extra payment causes balance to go negative in the
  /// final months (must cap principal at remaining balance).
  static ExtraPaymentResult calculate({
    required double principal,
    required double annualRatePercent,
    required int termYears,
    required double extraMonthlyPayment,
    DateTime? startDate,
  }) {
    final double baseMonthly = MortgageCalculator.calculateMonthlyPayment(
      principal: principal,
      annualRatePercent: annualRatePercent,
      termYears: termYears,
    );

    final double r = annualRatePercent / 100 / 12;
    final double totalMonthly = baseMonthly + extraMonthlyPayment;

    // Simulate with extra payments
    double balance = principal;
    double totalInterestWithExtra = 0;
    int newTermMonths = 0;
    final List<BalancePoint> withExtraCurve = [BalancePoint(month: 0, balance: principal)];

    while (balance > 0) {
      newTermMonths++;
      final double interestThisMonth = balance * r;
      double principalThisMonth = totalMonthly - interestThisMonth;

      // Don't overpay in the last month
      if (principalThisMonth > balance) {
        principalThisMonth = balance;
      }

      totalInterestWithExtra += interestThisMonth;
      balance -= principalThisMonth;
      if (balance < 0.01) balance = 0; // floating point guard

      // Sample every 6 months for chart performance
      if (newTermMonths % 6 == 0 || balance == 0) {
        withExtraCurve.add(BalancePoint(month: newTermMonths, balance: balance));
      }

      // Safety: break if somehow exceeds 50 years (bad input guard)
      if (newTermMonths > 600) break;
    }

    // Original schedule (without extra) for comparison curve
    final double originalTotalInterest = MortgageCalculator.calculateTotalInterest(
      principal: principal,
      annualRatePercent: annualRatePercent,
      termYears: termYears,
    );
    final int originalTermMonths = termYears * 12;
    final List<BalancePoint> withoutExtraCurve = _sampleOriginalCurve(
      principal: principal,
      r: r,
      baseMonthly: baseMonthly,
      totalMonths: originalTermMonths,
    );

    final int monthsSaved = originalTermMonths - newTermMonths;
    final double interestSaved = originalTotalInterest - totalInterestWithExtra;

    final DateTime? newPayoffDate = startDate != null
        ? DateTime(startDate.year, startDate.month + newTermMonths)
        : null;
    final DateTime? originalPayoffDate = startDate != null
        ? DateTime(startDate.year, startDate.month + originalTermMonths)
        : null;

    return ExtraPaymentResult(
      extraMonthlyPayment: extraMonthlyPayment,
      newTotalMonthly: baseMonthly + extraMonthlyPayment,
      originalTermMonths: originalTermMonths,
      newTermMonths: newTermMonths,
      monthsSaved: monthsSaved,
      yearsSaved: monthsSaved ~/ 12,
      remainingMonthsSaved: monthsSaved % 12,
      originalTotalInterest: originalTotalInterest,
      newTotalInterest: totalInterestWithExtra,
      interestSaved: interestSaved > 0 ? interestSaved : 0,
      newPayoffDate: newPayoffDate,
      originalPayoffDate: originalPayoffDate,
      withExtraBalanceCurve: withExtraCurve,
      withoutExtraBalanceCurve: withoutExtraCurve,
    );
  }

  static List<BalancePoint> _sampleOriginalCurve({
    required double principal,
    required double r,
    required double baseMonthly,
    required int totalMonths,
  }) {
    final List<BalancePoint> points = [BalancePoint(month: 0, balance: principal)];
    double balance = principal;
    for (int m = 1; m <= totalMonths; m++) {
      final double interest = balance * r;
      balance -= (baseMonthly - interest);
      if (balance < 0) balance = 0;
      if (m % 6 == 0 || m == totalMonths) {
        points.add(BalancePoint(month: m, balance: balance));
      }
    }
    return points;
  }
}
```

**Unit test verification values:**
```
Input:  P=$360,000, rate=6.25%, term=30yr, extra=$200/mo
Output: newTermMonths=286 (23yr 10mo)
        monthsSaved=74 payments
        yearsSaved=6, remainingMonthsSaved=2
        interestSaved=$136,144 (approximately — test within ±$50)

Input:  extra=$0
Output: monthsSaved=0, interestSaved=0 (zero extra = no change)

Input:  extra > baseMonthly (e.g. extra=$5,000 on $2,216 payment)
Output: Should complete in a few years, no crash, positive interestSaved
```

---

### 6.4 Affordability Calculator

```dart
// lib/features/affordability/services/affordability_calculator.dart

class AffordabilityCalculator {

  /// Calculate maximum home price based on income and debt.
  ///
  /// Method: Back-solve from maximum allowable monthly payment.
  ///
  /// Standard lending ratios used by conventional loans (Fannie Mae / Freddie Mac):
  ///   Front-End DTI: housing costs ≤ 28% of gross monthly income
  ///     housing costs = PITI (principal, interest, taxes, insurance)
  ///   Back-End DTI: all monthly debts ≤ 36% of gross monthly income
  ///     all debts = PITI + car payment + student loans + credit cards
  ///
  /// We use the MORE RESTRICTIVE of the two limits as the max payment.
  ///
  /// To find max loan amount from max payment P:
  ///   Back-solve the amortization formula:
  ///   P = L × [r(1+r)^n] / [(1+r)^n - 1]
  ///   L = P × [(1+r)^n - 1] / [r(1+r)^n]
  static AffordabilityResult calculate({
    required double grossMonthlyIncome,
    required double monthlyDebts,        // non-housing debts only
    required double downPayment,
    required double annualRatePercent,
    required int termYears,
    double estimatedTaxRate = 0.015,     // default 1.5% of home price annually
    double estimatedInsurance = 0.005,   // default 0.5% of home price annually
  }) {
    // DTI limits (conventional loan)
    const double frontEndLimit = 0.28;   // 28% of gross income on housing
    const double backEndLimit = 0.36;    // 36% of gross income on all debts

    final double maxFromFrontEnd = grossMonthlyIncome * frontEndLimit;
    final double maxFromBackEnd = (grossMonthlyIncome * backEndLimit) - monthlyDebts;

    // Most restrictive limit
    final double maxTotalHousingPayment = maxFromFrontEnd < maxFromBackEnd
        ? maxFromFrontEnd
        : maxFromBackEnd;

    if (maxTotalHousingPayment <= 0) {
      return AffordabilityResult.empty();
    }

    final double r = annualRatePercent / 100 / 12;
    final int n = termYears * 12;

    // We need to estimate monthly taxes + insurance before knowing the home price.
    // Use iterative approach: estimate home price → calculate taxes/insurance →
    // recalculate available P&I → recalculate home price → converge (2-3 iterations).
    double estimatedHomePrice = maxTotalHousingPayment * 200; // rough initial estimate
    double availableForPI = maxTotalHousingPayment;

    for (int iteration = 0; iteration < 5; iteration++) {
      final double monthlyTax = (estimatedHomePrice * estimatedTaxRate) / 12;
      final double monthlyInsurance = (estimatedHomePrice * estimatedInsurance) / 12;
      availableForPI = maxTotalHousingPayment - monthlyTax - monthlyInsurance;
      if (availableForPI <= 0) break;

      // Back-solve for max loan amount
      double maxLoan;
      if (r == 0) {
        maxLoan = availableForPI * n;
      } else {
        final double factor = pow(1 + r, n).toDouble();
        maxLoan = availableForPI * (factor - 1) / (r * factor);
      }

      estimatedHomePrice = maxLoan + downPayment;
    }

    final double maxLoan = estimatedHomePrice - downPayment;
    final double actualMonthlyPI = MortgageCalculator.calculateMonthlyPayment(
      principal: maxLoan,
      annualRatePercent: annualRatePercent,
      termYears: termYears,
    );
    final double monthlyTax = (estimatedHomePrice * estimatedTaxRate) / 12;
    final double monthlyInsurance = (estimatedHomePrice * estimatedInsurance) / 12;
    final double totalMonthlyHousing = actualMonthlyPI + monthlyTax + monthlyInsurance;

    final double frontEndDti = (totalMonthlyHousing / grossMonthlyIncome) * 100;
    final double backEndDti = ((totalMonthlyHousing + monthlyDebts) / grossMonthlyIncome) * 100;

    return AffordabilityResult(
      maxHomePrice: (estimatedHomePrice / 1000).round() * 1000.0, // round to nearest $1k
      maxLoanAmount: maxLoan,
      downPayment: downPayment,
      monthlyPayment: totalMonthlyHousing,
      frontEndDtiPercent: frontEndDti,
      backEndDtiPercent: backEndDti,
      frontEndStatus: _dtiStatus(frontEndDti, isFrontEnd: true),
      backEndStatus: _dtiStatus(backEndDti, isFrontEnd: false),
    );
  }

  static DTIStatus _dtiStatus(double dti, {required bool isFrontEnd}) {
    if (isFrontEnd) {
      if (dti <= 28) return DTIStatus.good;
      if (dti <= 31) return DTIStatus.moderate;
      if (dti <= 36) return DTIStatus.high;
      return DTIStatus.tooHigh;
    } else {
      if (dti <= 36) return DTIStatus.good;
      if (dti <= 43) return DTIStatus.moderate;
      if (dti <= 50) return DTIStatus.high;
      return DTIStatus.tooHigh;
    }
  }
}
```

---

## 7. STATE MANAGEMENT (Cubit pattern)

### 7.1 Calculator Cubit (representative example — use same pattern for all cubits)

```dart
// lib/features/calculator/cubit/calculator_state.dart

abstract class CalculatorState extends Equatable {
  const CalculatorState();
}

class CalculatorInitial extends CalculatorState {
  // Default values shown on first open
  final MortgageInput defaults = const MortgageInput(
    loanAmount: 360000,
    annualRatePercent: 6.25,
    termYears: 30,
  );
  @override List<Object?> get props => [];
}

class CalculatorLoaded extends CalculatorState {
  final MortgageInput input;
  final MortgageResult result;
  const CalculatorLoaded({required this.input, required this.result});
  @override List<Object?> get props => [input, result];
}

class CalculatorError extends CalculatorState {
  final String message;
  const CalculatorError(this.message);
  @override List<Object?> get props => [message];
}
```

```dart
// lib/features/calculator/cubit/calculator_cubit.dart

class CalculatorCubit extends Cubit<CalculatorState> {
  CalculatorCubit() : super(CalculatorInitial()) {
    // Calculate with defaults immediately so screen is never empty
    _calculateWithDefaults();
  }

  MortgageInput _currentInput = const MortgageInput(
    loanAmount: 360000,
    annualRatePercent: 6.25,
    termYears: 30,
  );

  MortgageInput get currentInput => _currentInput;

  void _calculateWithDefaults() {
    calculate(_currentInput);
  }

  void calculate(MortgageInput input) {
    try {
      _validateInput(input); // throws ArgumentError if invalid
      _currentInput = input;
      final result = MortgageCalculator.calculate(input);
      emit(CalculatorLoaded(input: input, result: result));
    } on ArgumentError catch (e) {
      emit(CalculatorError(e.message));
    }
  }

  void updateLoanAmount(double amount) =>
      calculate(_currentInput.copyWith(loanAmount: amount));
  void updateRate(double rate) =>
      calculate(_currentInput.copyWith(annualRatePercent: rate));
  void updateTerm(int years) =>
      calculate(_currentInput.copyWith(termYears: years));
  void updatePropertyTax(double tax) =>
      calculate(_currentInput.copyWith(propertyTaxAnnual: tax));

  void applyPreset(LoanPreset preset) {
    switch (preset) {
      case LoanPreset.yr15:
        calculate(_currentInput.copyWith(termYears: 15));
      case LoanPreset.yr20:
        calculate(_currentInput.copyWith(termYears: 20));
      case LoanPreset.yr30:
        calculate(_currentInput.copyWith(termYears: 30));
      case LoanPreset.fha:
        // FHA: min 3.5% down, different PMI rules — adjust accordingly
        calculate(_currentInput.copyWith(termYears: 30));
      case LoanPreset.va:
        // VA: no PMI required
        calculate(_currentInput.copyWith(pmiAnnual: 0, termYears: 30));
    }
  }

  void _validateInput(MortgageInput input) {
    if (input.loanAmount <= 0) throw ArgumentError('Loan amount must be greater than 0');
    if (input.loanAmount > 50000000) throw ArgumentError('Loan amount exceeds maximum');
    if (input.annualRatePercent < 0) throw ArgumentError('Interest rate cannot be negative');
    if (input.annualRatePercent > 50) throw ArgumentError('Interest rate seems unusually high');
    if (input.termYears < 1) throw ArgumentError('Loan term must be at least 1 year');
    if (input.termYears > 50) throw ArgumentError('Loan term cannot exceed 50 years');
  }
}

enum LoanPreset { yr15, yr20, yr30, fha, va }
```

---

## 8. ADMOB INTEGRATION

```dart
// lib/services/ad_service.dart
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  // PRODUCTION IDs — replace test IDs before App Store submission
  static const String _interstitialAdUnitIdIOS =
      'ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY'; // Replace with real unit ID
  static const String _bannerAdUnitIdIOS =
      'ca-app-pub-XXXXXXXXXXXXXXXX/ZZZZZZZZZZ'; // Replace with real unit ID

  // TEST IDs (use during development)
  static const String _testInterstitialId =
      'ca-app-pub-3940256099942544/4411468910';
  static const String _testBannerId =
      'ca-app-pub-3940256099942544/2934735716';

  static bool _useTestIds = true; // Set false before release

  static String get interstitialId =>
      _useTestIds ? _testInterstitialId : _interstitialAdUnitIdIOS;
  static String get bannerId =>
      _useTestIds ? _testBannerId : _bannerAdUnitIdIOS;

  InterstitialAd? _interstitialAd;
  DateTime? _lastInterstitialShown;
  bool _isPro = false;

  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  void setProStatus(bool isPro) => _isPro = isPro;

  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    _loadInterstitial();
  }

  void _loadInterstitial() {
    if (_isPro) return; // Don't load ads for Pro users
    InterstitialAd.load(
      adUnitId: interstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              _loadInterstitial(); // Preload next ad immediately
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _interstitialAd = null;
              _loadInterstitial();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
          // Retry after 5 minutes on failure
          Future.delayed(const Duration(minutes: 5), _loadInterstitial);
        },
      ),
    );
  }

  /// Show interstitial if:
  /// 1. User is not Pro
  /// 2. Ad is loaded
  /// 3. At least 90 seconds since last ad (AdMob policy + UX)
  bool showInterstitial() {
    if (_isPro) return false;
    if (_interstitialAd == null) return false;

    final now = DateTime.now();
    if (_lastInterstitialShown != null) {
      final secondsSinceLast = now.difference(_lastInterstitialShown!).inSeconds;
      if (secondsSinceLast < 90) return false;
    }

    _lastInterstitialShown = now;
    _interstitialAd!.show();
    return true;
  }

  /// APPROVED TRIGGER POINTS (call showInterstitial() at these locations only):
  ///
  /// 1. ScheduleScreen.initState() — user navigates to amortization table
  ///    → called once per session, not every time they go back/forth
  ///
  /// 2. After ExtraPaymentScreen "Apply Extra Payment" button tap
  ///    → user completed a meaningful action
  ///
  /// 3. After Share button tap in Compare screen
  ///    → user is done with the current task
  ///
  /// NEVER call showInterstitial() in:
  /// - Calculator screen (home screen)
  /// - During input field editing
  /// - On app launch
  /// - In Settings or Onboarding

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: bannerId,
      size: AdSize.banner, // 320x50
      request: const AdRequest(),
      listener: const BannerAdListener(),
    );
  }
  // Banner is ONLY shown on Saved screen (Screen 07)
}
```

---

## 9. IAP INTEGRATION

```dart
// lib/services/purchase_service.dart
import 'package:in_app_purchase/in_app_purchase.dart';

class PurchaseService {
  static const String proProductId = 'com.yourname.amortly.pro'; // Must match App Store Connect

  final InAppPurchase _iap = InAppPurchase.instance;
  bool _isPro = false;

  bool get isPro => _isPro;

  Stream<List<PurchaseDetails>> get purchaseStream =>
      _iap.purchaseStream;

  Future<bool> isAvailable() => _iap.isAvailable();

  Future<void> loadProStatus() async {
    // Check SharedPreferences for cached pro status
    final prefs = await SharedPreferences.getInstance();
    _isPro = prefs.getBool('is_pro') ?? false;
  }

  Future<void> buyPro() async {
    final ProductDetailsResponse response =
        await _iap.queryProductDetails({proProductId});

    if (response.productDetails.isEmpty) {
      throw Exception('Product not found. Check App Store Connect product ID.');
    }

    final PurchaseParam param = PurchaseParam(
      productDetails: response.productDetails.first,
    );
    await _iap.buyNonConsumable(purchaseParam: param);
  }

  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
    // Listen to purchaseStream for restored purchases
  }

  Future<void> handlePurchaseUpdate(PurchaseDetails details) async {
    if (details.status == PurchaseStatus.purchased ||
        details.status == PurchaseStatus.restored) {
      _isPro = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_pro', true);
      // Notify AdService to stop loading ads
      AdService().setProStatus(true);
    }

    if (details.pendingCompletePurchase) {
      await _iap.completePurchase(details);
    }
  }
}

// Pro features that get unlocked:
// 1. Remove all ads (banner + interstitials)
// 2. PDF export on Schedule screen
// 3. Export data as CSV from Saved screen
// 4. Unlimited saved calculations (free tier: max 10)
```

---

## 10. STORAGE SERVICE (Hive)

```dart
// lib/services/storage_service.dart
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _savedCalcsBox = 'saved_calculations';

  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  late Box<SavedCalculation> _savedBox;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(SavedCalculationAdapter()); // generated by build_runner
    _savedBox = await Hive.openBox<SavedCalculation>(_savedCalcsBox);
  }

  // CRUD for saved calculations
  Future<void> saveCalculation(SavedCalculation calc) async {
    await _savedBox.put(calc.id, calc);
  }

  List<SavedCalculation> getAllSaved() {
    final items = _savedBox.values.toList();
    items.sort((a, b) => b.savedAt.compareTo(a.savedAt)); // newest first
    return items;
  }

  Future<void> deleteCalculation(String id) async {
    await _savedBox.delete(id);
  }

  Future<void> updateCalculationName(String id, String newName) async {
    final calc = _savedBox.get(id);
    if (calc != null) {
      calc.name = newName;
      await calc.save();
    }
  }

  // Settings (SharedPreferences)
  Future<String> getCurrency() async {
    final p = await SharedPreferences.getInstance();
    return p.getString('currency') ?? 'USD';
  }

  Future<void> setCurrency(String currency) async {
    final p = await SharedPreferences.getInstance();
    await p.setString('currency', currency);
  }

  Future<bool> isOnboardingComplete() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool('onboarding_done') ?? false;
  }

  Future<void> setOnboardingComplete() async {
    final p = await SharedPreferences.getInstance();
    await p.setBool('onboarding_done', true);
  }

  Future<int> getCalculationCount() async {
    final p = await SharedPreferences.getInstance();
    return p.getInt('calc_count') ?? 0;
  }

  Future<void> incrementCalculationCount() async {
    final p = await SharedPreferences.getInstance();
    final count = await getCalculationCount();
    await p.setInt('calc_count', count + 1);
  }
}
```

---

## 11. ATT PROMPT (main.dart)

```dart
// lib/main.dart
import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
// Add to pubspec: app_tracking_transparency: ^2.0.4

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Hive (local storage)
  await StorageService().init();

  // 2. Load Pro status before anything else
  await PurchaseService().loadProStatus();

  // 3. Initialize AdMob
  await AdService().initialize();

  // 4. ATT prompt — must happen before first ad request on iOS 14.5+
  // Only request on iOS
  if (Platform.isIOS) {
    final status = await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      // Small delay recommended by Apple — give app time to fully render
      await Future.delayed(const Duration(milliseconds: 500));
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }

  runApp(const AmortlyApp());
}
```

---

## 12. NAVIGATION (app_router.dart)

```dart
// lib/navigation/app_router.dart
// Use GoRouter for named routes. Simplifies deep linking.
// Add to pubspec: go_router: ^14.2.7

import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) async {
    final onboardingDone = await StorageService().isOnboardingComplete();
    if (!onboardingDone && state.matchedLocation != '/onboarding') {
      return '/onboarding';
    }
    return null;
  },
  routes: [
    GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/', builder: (_, __) => const CalculatorScreen()),
        GoRoute(path: '/schedule', builder: (_, __) => const ScheduleScreen()),
        GoRoute(path: '/compare', builder: (_, __) => const CompareScreen()),
        GoRoute(path: '/saved', builder: (_, __) => const SavedScreen()),
        GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
      ],
    ),
    GoRoute(path: '/extra-payment', builder: (_, __) => const ExtraPaymentScreen()),
    GoRoute(path: '/affordability', builder: (_, __) => const AffordabilityScreen()),
  ],
);
```

---

## 13. CURRENCY FORMATTER

```dart
// lib/core/utils/currency_formatter.dart
import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final Map<String, NumberFormat> _formatters = {};
  static final Map<String, NumberFormat> _compactFormatters = {};

  /// Returns "$2,844.00" for USD, "£2,844.00" for GBP, etc.
  static String format(double amount, {String currency = 'USD', int decimalPlaces = 2}) {
    final key = '$currency-$decimalPlaces';
    _formatters[key] ??= NumberFormat.currency(
      locale: _localeForCurrency(currency),
      symbol: _symbolForCurrency(currency),
      decimalDigits: decimalPlaces,
    );
    return _formatters[key]!.format(amount);
  }

  /// Returns "$2,844" (no cents) for cleaner display in hero cards
  static String formatNoCents(double amount, {String currency = 'USD'}) =>
      format(amount, currency: currency, decimalPlaces: 0);

  /// Returns "$573k" for large numbers in compact contexts
  static String formatCompact(double amount, {String currency = 'USD'}) {
    final symbol = _symbolForCurrency(currency);
    if (amount >= 1000000) return '$symbol${(amount / 1000000).toStringAsFixed(1)}M';
    if (amount >= 1000) return '$symbol${(amount / 1000).toStringAsFixed(0)}k';
    return format(amount, currency: currency);
  }

  static String _symbolForCurrency(String currency) {
    const symbols = {'USD': '\$', 'GBP': '£', 'CAD': 'CA\$', 'AUD': 'A\$', 'EUR': '€'};
    return symbols[currency] ?? '\$';
  }

  static String _localeForCurrency(String currency) {
    const locales = {'USD': 'en_US', 'GBP': 'en_GB', 'CAD': 'en_CA', 'AUD': 'en_AU', 'EUR': 'de_DE'};
    return locales[currency] ?? 'en_US';
  }
}
```

---

## 14. REFERENCE VALUES FOR UNIT TESTS

Use these exact values to write tests in `test/` before implementing screens.

```
══════════════════════════════════════════════════════════
TEST SUITE 1 — MortgageCalculator
══════════════════════════════════════════════════════════
Case 1 (standard):
  Input:  loan=360000, rate=6.25%, term=30yr
  Expect: monthly=2216.52, totalInterest=438347.20, totalPaid=798347.20

Case 2 (spec values from UI mockup):
  Input:  loan=450000, rate=6.5%, term=30yr
  Expect: monthly=2844.06, totalInterest≈573840, totalPaid≈1023840

Case 3 (15-year):
  Input:  loan=450000, rate=6.5%, term=15yr
  Expect: monthly=3921.17, totalInterest≈255810

Case 4 (zero interest):
  Input:  loan=120000, rate=0%, term=10yr
  Expect: monthly=1000.00 (exactly P/n)

Case 5 (validation):
  Input:  loan=0 → expect ArgumentError
  Input:  rate=-1 → expect ArgumentError
  Input:  term=0 → expect ArgumentError

══════════════════════════════════════════════════════════
TEST SUITE 2 — AmortizationCalculator
══════════════════════════════════════════════════════════
Case 1:
  Input:  loan=360000, rate=6.25%, term=30yr
  Month 1: payment=2216.52, principal=341.52, interest=1875.00, balance=359658.48
  Month 2: principal > month1 principal (principal grows each month)
  Month 360: balance=0.00 (±0.01 tolerance for floating point)
  Total rows: 360

Case 2 (principal overtakes interest):
  Input: loan=360000, rate=6.25%, term=30yr
  findPrincipalOvertakesInterestMonth() → should return month ~144 (year 12)

══════════════════════════════════════════════════════════
TEST SUITE 3 — ExtraPaymentCalculator
══════════════════════════════════════════════════════════
Case 1:
  Input:  loan=360000, rate=6.25%, term=30yr, extra=200/mo
  Expect: monthsSaved=74 (±2 tolerance)
          yearsSaved=6, remainingMonths=2
          interestSaved≈136144 (±500 tolerance)
          newTermMonths=286 (±2)

Case 2 (no extra):
  Input: extra=0
  Expect: monthsSaved=0, interestSaved=0, newTermMonths=originalTermMonths

Case 3 (large extra):
  Input: extra=2000 on loan=360000, rate=6.25%, term=30yr
  Expect: newTermMonths < 100 (loan paid off much sooner — no crash)

══════════════════════════════════════════════════════════
TEST SUITE 4 — AffordabilityCalculator
══════════════════════════════════════════════════════════
Case 1:
  Input:  income=8000/mo, debts=500/mo, down=90000, rate=6.25%, term=30yr
  Expect: maxHomePrice between 400000 and 550000
          frontEndDti between 25% and 31%
          backEndDti between 28% and 38%

Case 2 (debts too high):
  Input:  income=4000/mo, debts=3000/mo
  Expect: maxHomePrice very low or error state
          DTIStatus.tooHigh for backEnd
```

---

## 15. SCREEN IMPLEMENTATION ORDER

Build screens in this order. Each screen depends on the layer below being complete first.

```
Phase 1 — Core infrastructure (Day 1):
  [x] Project setup, pubspec.yaml, folder structure
  [x] app_colors.dart, app_text_styles.dart
  [x] app_theme.dart (light + dark)
  [x] All unit tests (write before screens!)

Phase 2 — Calculator engine (Day 2):
  [x] mortgage_calculator.dart + tests pass
  [x] amortization_calculator.dart + tests pass
  [x] extra_payment_calculator.dart + tests pass
  [x] affordability_calculator.dart + tests pass

Phase 3 — Core screens (Days 3-5):
  [x] OnboardingScreen (1 slide for MVP, 3 slides final)
  [x] CalculatorScreen — basic mode (loan + rate + term only, add tax/insurance later)
  [x] ExtraPaymentScreen — the killer feature
  [x] MainShell (bottom tab bar with 5 tabs)

Phase 4 — Secondary screens (Days 6-7):
  [x] ScheduleScreen — table view only (chart tab = v1.1)
  [x] CompareScreen — extra payment mode
  [x] SavedScreen — list + search + banner ad
  [x] SettingsScreen — all rows

Phase 5 — Monetization (Day 8):
  [x] AdMob integration + test IDs
  [x] IAP Pro unlock + restore
  [x] ATT prompt flow

Phase 6 — Polish (Days 9-10):
  [x] Disclaimer text on all result screens
  [x] Dark mode testing
  [x] Error states + empty states
  [x] AffordabilityScreen
  [x] Real App Store screenshots
  [x] Replace test ad IDs with production IDs
```

---

## 16. APP STORE SUBMISSION CHECKLIST

```
□ Disclaimer "For illustrative purposes only. Not financial advice." 
  visible on: Calculator result, Extra Payment, Affordability, Compare screens

□ Privacy Policy URL in App Store Connect metadata AND
  in Settings → Trust & Privacy → Privacy Policy row

□ Terms of Use link in Settings → About

□ Restore Purchases button in Settings → Amortly Pro section

□ ATT prompt implemented and tested on real device
  (ATT dialog does NOT appear in Simulator)

□ Info.plist: NSUserTrackingUsageDescription filled in

□ Info.plist: GADApplicationIdentifier set to production AdMob App ID

□ IAP product IDs match App Store Connect exactly
  Product ID: com.yourname.amortly.pro

□ App does NOT connect to any external APIs (calculator is offline)

□ App does NOT collect personal data
  Privacy Nutrition Label: Data Not Collected

□ Age Rating: 4+ (no objectionable content)

□ No placeholder content in final build

□ Screenshots taken on real device or Simulator at:
  - 6.9" iPhone 15 Pro Max (required)
  - 6.1" iPhone 15 (required)
  
□ Replace all test AdMob IDs with production IDs before release
  Search codebase for "ca-app-pub-3940256099942544" and replace all
```

---

## 17. CODING STANDARDS & RULES

```
1. All calculator functions are static methods or free functions — no dependencies on Flutter
2. Never use setState — always Cubit
3. Never hardcode currency symbols — always use CurrencyFormatter
4. Never hardcode strings in widget files — use AppStrings
5. Every MonetaryValue displayed must use FontFeature.tabularFigures()
6. All colors from AppColors — never hardcode hex in widgets
7. All TextStyles from AppTextStyles — never create inline TextStyle in widgets
8. Screen files are StatelessWidget or minimal StatefulWidget
9. Complex UI → extract to widget files under features/X/screens/widgets/
10. File naming: snake_case for all files and directories
11. Class naming: PascalCase
12. No print() statements in production code — use debugPrint() or remove
13. Barrel files (index.dart): do not use — import paths explicitly
14. Run flutter analyze before committing — zero warnings, zero errors
15. Run flutter test before committing — all tests must pass
```

---

## 18. REQUIRED APP STRINGS (app_strings.dart)

```dart
abstract class AppStrings {
  // Disclaimer (REQUIRED by Apple for finance apps)
  static const disclaimer =
      'Calculations are for illustrative purposes only and do not '
      'constitute financial advice. Interest rate, fees, and payment '
      'amounts may vary. Contact a qualified lender for a personalised quote.';

  static const disclaimerShort =
      'For illustrative purposes only. Not financial advice.';

  // Privacy
  static const privacyMessage =
      'All calculations stay on your device. No data is ever sent to our servers.';

  // Pro
  static const proTitle = 'Amortly Pro';
  static const proSubtitle = 'Remove Ads + PDF Export';
  static const proPrice = '\$1.99'; // Override with real price from StoreKit

  // Error messages
  static const errorLoanAmount = 'Enter a loan amount greater than \$0';
  static const errorRate = 'Enter an interest rate between 0% and 50%';
  static const errorTerm = 'Loan term must be between 1 and 50 years';
  static const errorHighRate = 'This rate seems unusually high — please verify';

  // Empty states
  static const emptyPaved = 'No saved calculations yet';
  static const emptySavedSub = 'Tap the bookmark icon after calculating to save';

  // ATT description (also in Info.plist)
  static const attDescription =
      'We use this to show relevant mortgage and home-buying ads. '
      'You can opt out in Settings at any time.';
}
```

---

## 19. FEATURE PRIORITY TABLE

| Feature | Version | Calculation | AdMob Trigger | Pro Gate |
|---|---|---|---|---|
| Monthly P&I payment | v1.0 | See §6.1 | No | No |
| Total interest + total cost | v1.0 | See §6.1 | No | No |
| Extra payment savings (slider) | v1.0 | See §6.3 | After "Apply" | No |
| Amortization table (monthly) | v1.0 | See §6.2 | On screen open | No |
| Save calculations | v1.0 | Hive storage | No | Max 10 free |
| Compare: with/without extra | v1.0 | §6.3 comparison | After share | No |
| Settings (currency, dark mode) | v1.0 | N/A | No | No |
| Affordability calculator | v1.1 | See §6.4 | No | No |
| Compare: 2 different loans | v1.1 | Two §6.1 instances | No | No |
| Amortization chart (donut) | v1.1 | fl_chart + §6.2 | No | No |
| Balance-over-time chart | v1.1 | fl_chart + §6.3 | No | No |
| PDF export | v1.1 | pdf package | No | Yes (Pro) |
| Property tax + insurance | v1.1 | Add to §6.1 | No | No |
| FHA / VA presets | v1.1 | PMI rules change | No | No |
| Buy vs Rent comparison | v1.2 | New calculator | No | No |
| Yearly amortization summary | v1.1 | §6.2 grouping | No | No |
| CSV export | v1.2 | Simple file write | No | Yes (Pro) |

---

*End of AMORTLY Technical Requirements v1.0*
*Last updated: May 2026*
*Target: iOS 16.0+, Flutter 3.22+*
