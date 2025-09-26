import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Google Mobile Ads manager for the Factory Tycoon game
class AdsManager {
  static bool _isInitialized = false;
  static RewardedAd? _rewardedAd;
  static bool _isRewardedAdReady = false;
  
  /// Test Ad Unit IDs (use these during development)
  static const String _testRewardedAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917' // Android test rewarded ad
      : 'ca-app-pub-3940256099942544/1712485313'; // iOS test rewarded ad
  
  /// Production Ad Unit IDs (replace with your real IDs)
  static const String _prodRewardedAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-YOUR_PUBLISHER_ID/ANDROID_REWARDED_AD_ID'
      : 'ca-app-pub-YOUR_PUBLISHER_ID/IOS_REWARDED_AD_ID';
  
  /// Get the appropriate ad unit ID based on debug/release mode
  static String get _rewardedAdUnitId {
    // In debug mode, use test ads
    bool useTestAds = true; // Set to false when ready for production
    return useTestAds ? _testRewardedAdUnitId : _prodRewardedAdUnitId;
  }
  
  /// Initialize Google Mobile Ads SDK
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      await MobileAds.instance.initialize();
      
      // Set test device for debugging (optional)
      await _setTestDevice();
      
      _isInitialized = true;
      print('✅ Google Mobile Ads initialized successfully');
      
      // Load the first rewarded ad
      await _loadRewardedAd();
    } catch (e) {
      print('❌ Ads initialization error: $e');
    }
  }
  
  /// Set test device for debugging ads
  static Future<void> _setTestDevice() async {
    try {
      // Add your test device ID here for testing
      // You can find your device ID in the console logs when you first run ads
      final requestConfiguration = RequestConfiguration(
        testDeviceIds: ['YOUR_TEST_DEVICE_ID'], // Replace with actual device ID
      );
      MobileAds.instance.updateRequestConfiguration(requestConfiguration);
    } catch (e) {
      print('Test device setup error: $e');
    }
  }
  
  /// Load rewarded ad
  static Future<void> _loadRewardedAd() async {
    try {
      await RewardedAd.load(
        adUnitId: _rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            _rewardedAd = ad;
            _isRewardedAdReady = true;
            print('✅ Rewarded ad loaded successfully');
            
            // Set ad callbacks
            _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (RewardedAd ad) {
                print('📺 Rewarded ad showed full screen content');
              },
              onAdDismissedFullScreenContent: (RewardedAd ad) {
                print('❌ Rewarded ad dismissed');
                ad.dispose();
                _rewardedAd = null;
                _isRewardedAdReady = false;
                // Load next ad
                _loadRewardedAd();
              },
              onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
                print('❌ Rewarded ad failed to show: $error');
                ad.dispose();
                _rewardedAd = null;
                _isRewardedAdReady = false;
                // Load next ad
                _loadRewardedAd();
              },
            );
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('❌ Rewarded ad failed to load: $error');
            _isRewardedAdReady = false;
            
            // Retry loading after delay
            Future.delayed(const Duration(seconds: 5), () {
              _loadRewardedAd();
            });
          },
        ),
      );
    } catch (e) {
      print('❌ Error loading rewarded ad: $e');
    }
  }
  
  /// Show rewarded ad with callback for reward
  static Future<bool> showRewardedAd({
    required Function(RewardItem reward) onReward,
  }) async {
    if (!_isRewardedAdReady || _rewardedAd == null) {
      print('⚠️ Rewarded ad not ready');
      return false;
    }
    
    try {
      await _rewardedAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        print('🎁 User earned reward: ${reward.amount} ${reward.type}');
        onReward(reward);
      });
      
      return true;
    } catch (e) {
      print('❌ Error showing rewarded ad: $e');
      return false;
    }
  }
  
  /// Check if rewarded ad is ready
  static bool get isRewardedAdReady => _isRewardedAdReady;
  
  /// Dispose of all ads
  static void dispose() {
    _rewardedAd?.dispose();
    _rewardedAd = null;
    _isRewardedAdReady = false;
  }
  
  /// Show production boost rewarded ad
  static Future<bool> showProductionBoostAd({
    required Function() onBoostGranted,
  }) async {
    return await showRewardedAd(
      onReward: (reward) {
        print('🚀 Production boost granted!');
        onBoostGranted();
      },
    );
  }
  
  /// Show money bonus rewarded ad
  static Future<bool> showMoneyBonusAd({
    required Function(int bonusAmount) onMoneyGranted,
  }) async {
    return await showRewardedAd(
      onReward: (reward) {
        final bonusAmount = reward.amount.toInt() * 100; // Convert to game currency
        print('💰 Money bonus granted: $bonusAmount');
        onMoneyGranted(bonusAmount);
      },
    );
  }
}