// lib/services/purchase_service.dart
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PurchaseService {
  static const String proProductId = 'com.amortly.app.pro';

  static final PurchaseService _instance = PurchaseService._internal();
  factory PurchaseService() => _instance;
  PurchaseService._internal();

  final InAppPurchase _iap = InAppPurchase.instance;
  bool _isPro = false;

  bool get isPro => _isPro;

  Stream<List<PurchaseDetails>> get purchaseStream => _iap.purchaseStream;

  Future<bool> isAvailable() => _iap.isAvailable();

  Future<void> loadProStatus() async {
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
  }

  Future<void> handlePurchaseUpdate(PurchaseDetails details) async {
    if (details.status == PurchaseStatus.purchased ||
        details.status == PurchaseStatus.restored) {
      _isPro = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_pro', true);
    }

    if (details.pendingCompletePurchase) {
      await _iap.completePurchase(details);
    }
  }
}
