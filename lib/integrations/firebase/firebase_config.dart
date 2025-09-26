import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../../firebase_options.dart';

/// Firebase configuration and initialization
class FirebaseConfig {
  static FirebaseAnalytics? _analytics;
  static FirebaseRemoteConfig? _remoteConfig;
  
  static FirebaseAnalytics get analytics => _analytics!;
  static FirebaseRemoteConfig get remoteConfig => _remoteConfig!;
  
  /// Initialize Firebase services
  static Future<void> initialize() async {
    try {
      // Initialize Firebase with options
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      
      // Initialize Analytics
      _analytics = FirebaseAnalytics.instance;
      await _analytics!.setAnalyticsCollectionEnabled(true);
      
      // Initialize Remote Config
      _remoteConfig = FirebaseRemoteConfig.instance;
      await _remoteConfig!.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );
      
      // Set default Remote Config values
      await _setDefaultRemoteConfigValues();
      
      // Fetch remote config
      await _remoteConfig!.fetchAndActivate();
      
      print('✅ Firebase initialized successfully');
    } catch (e) {
      print('❌ Firebase initialization error: $e');
      rethrow;
    }
  }
  
  /// Set default values for Remote Config
  static Future<void> _setDefaultRemoteConfigValues() async {
    await _remoteConfig!.setDefaults({
      // Game balance
      'starting_money': 1000,
      'conveyor_cost': 10,
      'basic_machine_cost': 100,
      'tick_interval_ms': 200,
      
      // Features
      'ads_enabled': true,
      'iap_enabled': true,
      'tutorial_enabled': true,
      
      // Performance
      'max_components': 1000,
      'auto_save_interval_seconds': 30,
    });
  }
  
  /// Log analytics events
  static Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    try {
      await _analytics?.logEvent(name: name, parameters: parameters);
    } catch (e) {
      print('Analytics error: $e');
    }
  }
  
  /// Get Remote Config value as int
  static int getIntValue(String key) {
    return _remoteConfig?.getInt(key) ?? 0;
  }
  
  /// Get Remote Config value as bool
  static bool getBoolValue(String key) {
    return _remoteConfig?.getBool(key) ?? false;
  }
  
  /// Get Remote Config value as string
  static String getStringValue(String key) {
    return _remoteConfig?.getString(key) ?? '';
  }
  
  /// Common analytics events
  static Future<void> logTutorialStart() async {
    await logEvent('tutorial_start');
  }
  
  static Future<void> logTutorialComplete() async {
    await logEvent('tutorial_complete');
  }
  
  static Future<void> logFirstProduction() async {
    await logEvent('first_production');
  }
  
  static Future<void> logFirstSale() async {
    await logEvent('first_sale');
  }
  
  static Future<void> logAdRewardGranted(String adType) async {
    await logEvent('ad_reward_granted', parameters: {'ad_type': adType});
  }
  
  static Future<void> logIAPPurchaseSuccess(String productId, double value) async {
    await logEvent('iap_purchase_success', parameters: {
      'product_id': productId,
      'value': value,
    });
  }
}