// lib/services/ad_service.dart
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  // TEST IDs — replace with real production IDs before App Store submission
  static const String _testInterstitialId =
      'ca-app-pub-3940256099942544/4411468910';
  static const String _testBannerId = 'ca-app-pub-3940256099942544/2934735716';

  // PRODUCTION IDs — swap these and set _useTestIds = false before release
  static const String _prodInterstitialId =
      'ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY';
  static const String _prodBannerId = 'ca-app-pub-XXXXXXXXXXXXXXXX/ZZZZZZZZZZ';

  static const bool _useTestIds = true; // Set false before release

  static String get interstitialId =>
      _useTestIds ? _testInterstitialId : _prodInterstitialId;
  static String get bannerId => _useTestIds ? _testBannerId : _prodBannerId;

  InterstitialAd? _interstitialAd;
  DateTime? _lastInterstitialShown;
  bool _isPro = false;

  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  void setProStatus(bool isPro) {
    _isPro = isPro;
    if (isPro) {
      _interstitialAd?.dispose();
      _interstitialAd = null;
    }
  }

  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    _loadInterstitial();
  }

  void _loadInterstitial() {
    if (_isPro) return;
    InterstitialAd.load(
      adUnitId: interstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialAd!.fullScreenContentCallback =
              FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              _loadInterstitial();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _interstitialAd = null;
              _loadInterstitial();
            },
          );
        },
        onAdFailedToLoad: (_) {
          _interstitialAd = null;
          Future.delayed(const Duration(minutes: 5), _loadInterstitial);
        },
      ),
    );
  }

  /// Shows an interstitial if: not Pro, ad loaded, ≥90 s since last one.
  /// Returns true if the ad was shown.
  bool showInterstitial() {
    if (_isPro) return false;
    if (_interstitialAd == null) return false;

    final now = DateTime.now();
    if (_lastInterstitialShown != null &&
        now.difference(_lastInterstitialShown!).inSeconds < 90) {
      return false;
    }

    _lastInterstitialShown = now;
    _interstitialAd!.show();
    return true;
  }

  /// Creates a 320×50 banner ad. Caller is responsible for disposing.
  /// Banner is ONLY shown on the Saved screen.
  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: bannerId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: const BannerAdListener(),
    );
  }
}
