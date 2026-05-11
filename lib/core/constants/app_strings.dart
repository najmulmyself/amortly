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
  static const proPrice = '\$1.99';

  // Error messages
  static const errorLoanAmount = 'Enter a loan amount greater than \$0';
  static const errorRate = 'Enter an interest rate between 0% and 50%';
  static const errorTerm = 'Loan term must be between 1 and 50 years';
  static const errorHighRate = 'This rate seems unusually high — please verify';

  // Empty states
  static const emptySaved = 'No saved calculations yet';
  static const emptySavedSub = 'Tap the bookmark icon after calculating to save';

  // ATT description
  static const attDescription =
      'We use this to show relevant mortgage and home-buying ads. '
      'You can opt out in Settings at any time.';

  // Tab labels
  static const tabCalculator = 'Calculator';
  static const tabSchedule = 'Schedule';
  static const tabCompare = 'Compare';
  static const tabSaved = 'Saved';
  static const tabSettings = 'Settings';

  // Screen titles
  static const titleCalculator = 'Mortgage Calculator';
  static const titleSchedule = 'Amortization Schedule';
  static const titleCompare = 'Compare Loans';
  static const titleSaved = 'Saved';
  static const titleSettings = 'Settings';
  static const titleExtraPayment = 'Extra Payment';
  static const titleAffordability = 'Affordability';

  // Onboarding
  static const onboardingTitle1 = 'Know Your Mortgage';
  static const onboardingBody1 =
      'Calculate your monthly payment instantly. See exactly where every dollar goes.';
  static const onboardingTitle2 = 'Pay Off Sooner';
  static const onboardingBody2 =
      'See how extra payments save you years and thousands in interest.';
  static const onboardingTitle3 = 'Plan with Confidence';
  static const onboardingBody3 =
      'Compare loans, check affordability, and save your calculations — all offline.';
  static const onboardingCta = 'Get Started';
}
