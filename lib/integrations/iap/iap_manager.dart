import 'dart:async';
import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';

/// In-App Purchase manager for Factory Tycoon
class IAPManager {
  static const String _kConsumableId = 'coin_pack_small';
  static const String _kConsumableId2 = 'coin_pack_large';
  
  /// Product IDs for different platforms
  static const Set<String> _kIds = <String>{
    _kConsumableId,
    _kConsumableId2,
  };
  
  static InAppPurchase? _inAppPurchase;
  static late StreamSubscription<List<PurchaseDetails>> _subscription;
  static List<ProductDetails> _products = <ProductDetails>[];
  static bool _isAvailable = false;
  static bool _isInitialized = false;
  
  /// Callback for successful purchases
  static Function(String productId, int coinAmount)? onPurchaseSuccess;
  
  /// Initialize In-App Purchase
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      _inAppPurchase = InAppPurchase.instance;
      
      // Check if the store is available
      _isAvailable = await _inAppPurchase!.isAvailable();
      
      if (!_isAvailable) {
        print('⚠️ In-App Purchase store not available');
        return;
      }
      
      // Listen to purchase updates
      _subscription = _inAppPurchase!.purchaseStream.listen(
        _onPurchaseUpdate,
        onDone: () => _subscription.cancel(),
        onError: (Object error) => print('❌ Purchase stream error: $error'),
      );
      
      // Load available products
      await _loadProducts();
      
      _isInitialized = true;
      print('✅ In-App Purchase initialized successfully');
    } catch (e) {
      print('❌ IAP initialization error: $e');
    }
  }
  
  /// Load available products from the store
  static Future<void> _loadProducts() async {
    try {
      final ProductDetailsResponse response = await _inAppPurchase!.queryProductDetails(_kIds);
      
      if (response.notFoundIDs.isNotEmpty) {
        print('⚠️ Products not found: ${response.notFoundIDs}');
      }
      
      _products = response.productDetails;
      print('✅ Loaded ${_products.length} products');
      
      for (final product in _products) {
        print('📦 Product: ${product.id} - ${product.title} - ${product.price}');
      }
    } catch (e) {
      print('❌ Error loading products: $e');
    }
  }
  
  /// Handle purchase updates
  static void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      _handlePurchaseDetails(purchaseDetails);
    }
  }
  
  /// Handle individual purchase details
  static void _handlePurchaseDetails(PurchaseDetails purchaseDetails) async {
    switch (purchaseDetails.status) {
      case PurchaseStatus.pending:
        print('⏳ Purchase pending: ${purchaseDetails.productID}');
        break;
        
      case PurchaseStatus.purchased:
      case PurchaseStatus.restored:
        print('✅ Purchase successful: ${purchaseDetails.productID}');
        
        // Grant the purchased items
        await _grantPurchasedProduct(purchaseDetails);
        
        // Mark the purchase as complete
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase!.completePurchase(purchaseDetails);
        }
        break;
        
      case PurchaseStatus.error:
        print('❌ Purchase error: ${purchaseDetails.error}');
        break;
        
      case PurchaseStatus.canceled:
        print('❌ Purchase canceled: ${purchaseDetails.productID}');
        break;
    }
  }
  
  /// Grant purchased product to the user
  static Future<void> _grantPurchasedProduct(PurchaseDetails purchaseDetails) async {
    try {
      final productId = purchaseDetails.productID;
      int coinAmount = 0;
      
      // Determine coin amount based on product ID
      switch (productId) {
        case _kConsumableId:
          coinAmount = 500; // Small coin pack
          break;
        case _kConsumableId2:
          coinAmount = 2500; // Large coin pack
          break;
        default:
          print('⚠️ Unknown product ID: $productId');
          return;
      }
      
      // Grant coins to the user
      onPurchaseSuccess?.call(productId, coinAmount);
      
      print('🪙 Granted $coinAmount coins for product $productId');
    } catch (e) {
      print('❌ Error granting purchase: $e');
    }
  }
  
  /// Purchase a product
  static Future<bool> buyProduct(String productId) async {
    if (!_isAvailable || !_isInitialized) {
      print('⚠️ In-App Purchase not available or not initialized');
      return false;
    }
    
    try {
      ProductDetails? productDetails;
      
      try {
        productDetails = _products.firstWhere(
          (product) => product.id == productId,
        );
      } catch (e) {
        print('⚠️ Product not found: $productId');
        return false;
      }
      
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: productDetails,
      );
      
      // For consumable products
      await _inAppPurchase!.buyConsumable(purchaseParam: purchaseParam);
      
      return true;
    } catch (e) {
      print('❌ Error purchasing product $productId: $e');
      return false;
    }
  }
  
  /// Get available products
  static List<ProductDetails> get products => _products;
  
  /// Check if IAP is available
  static bool get isAvailable => _isAvailable && _isInitialized;
  
  /// Buy small coin pack
  static Future<bool> buySmallCoinPack() async {
    return await buyProduct(_kConsumableId);
  }
  
  /// Buy large coin pack
  static Future<bool> buyLargeCoinPack() async {
    return await buyProduct(_kConsumableId2);
  }
  
  /// Restore purchases (mainly for iOS)
  static Future<void> restorePurchases() async {
    if (!_isAvailable || !_isInitialized) return;
    
    try {
      await _inAppPurchase!.restorePurchases();
      print('🔄 Restore purchases initiated');
    } catch (e) {
      print('❌ Error restoring purchases: $e');
    }
  }
  
  /// Dispose of the IAP manager
  static void dispose() {
    _subscription.cancel();
  }
  
  /// Get product details by ID
  static ProductDetails? getProductDetails(String productId) {
    try {
      return _products.firstWhere((product) => product.id == productId);
    } catch (e) {
      return null;
    }
  }
}