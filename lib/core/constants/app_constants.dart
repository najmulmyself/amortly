abstract class AppConstants {
  // Loan limits
  static const double maxLoanAmount = 50000000;
  static const double minLoanAmount = 1000;
  static const double maxAnnualRate = 50.0;
  static const double minAnnualRate = 0.0;
  static const int maxTermYears = 50;
  static const int minTermYears = 1;

  // Free tier limits
  static const int maxFreeSavedCalculations = 10;

  // Ad timing
  static const int interstitialCooldownSeconds = 90;

  // DTI thresholds
  static const double frontEndGood = 28.0;
  static const double frontEndModerate = 31.0;
  static const double frontEndHigh = 36.0;
  static const double backEndGood = 36.0;
  static const double backEndModerate = 43.0;
  static const double backEndHigh = 50.0;

  // Default input values
  static const double defaultLoanAmount = 360000;
  static const double defaultAnnualRate = 6.25;
  static const int defaultTermYears = 30;

  // Supported currencies
  static const List<String> supportedCurrencies = ['USD', 'GBP', 'CAD', 'AUD', 'EUR'];
}
