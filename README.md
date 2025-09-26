# 🏭 Factory Tycoon 

Flutter + Flame 2.5D isometric factory tycoon game where players build production lines with conveyors, machines, and junctions to manufacture and sell items for profit.

## 📱 Platform Support
- **Mobile**: iOS 13+ / Android API 23+
- **Orientation**: Portrait only
- **Target**: Mid-range devices, 60 FPS performance

## 🛠️ Development Setup

### Prerequisites
- Flutter 3.13+ with Dart 3.1+
- Android Studio / Xcode for platform builds
- Firebase project (for Analytics & Remote Config)
- Google AdMob account (for rewarded ads)

### Installation
```bash
# Clone repository
git clone <repository-url>
cd factory_tycoon

# Install dependencies
flutter pub get

# Generate code (models, adapters)
dart run build_runner build

# Run on device/emulator
flutter run --profile
```

### Firebase Configuration
1. Create Firebase project at https://console.firebase.google.com
2. Enable **Analytics** and **Remote Config**
3. Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
4. Place files in appropriate platform directories

### Google Mobile Ads Setup
1. Create AdMob account and app
2. Replace test Ad Unit IDs in `lib/integrations/ads/ads_manager.dart`:
   ```dart
   // Replace with your production Ad Unit IDs
   static const String _prodRewardedAdUnitId = Platform.isAndroid
       ? 'ca-app-pub-YOUR_PUBLISHER_ID/ANDROID_REWARDED_AD_ID'
       : 'ca-app-pub-YOUR_PUBLISHER_ID/IOS_REWARDED_AD_ID';
   ```

### In-App Purchase Setup
1. Configure products in Google Play Console / App Store Connect
2. Update product IDs in `lib/integrations/iap/iap_manager.dart`
3. Test with sandbox/test accounts

## 🏗️ Architecture

### Project Structure
```
lib/
  app/                     # Main app & dependency injection
  game/core/               # Game engine & tick system
  game/world/              # Isometric grid & depth sorting
  game/components/         # Conveyors, machines, items
  game/services/           # Economy, production, inventory
  integrations/            # Firebase, Ads, IAP
  data/models/             # Game data models
```

### Key Technical Features
- **Tick-based Simulation**: 200ms production ticks independent of framerate
- **Isometric Grid**: Diamond-shaped coordinate system with depth sorting
- **State Management**: Riverpod for meta-game, ValueNotifier for Game↔UI bridge
- **Local Storage**: Hive-based save/load system
- **Analytics**: Firebase Analytics with key game events
- **Monetization**: Rewarded ads + simple consumable IAPs

## 🎮 Game Features (MVP)

### Core Gameplay
- **Build**: Place conveyors, machines, junctions on isometric grid
- **Produce**: Items flow through production lines every tick
- **Sell**: Completed items generate revenue automatically  
- **Expand**: Reinvest profits in upgrades and new production lines

### Monetization
- **Rewarded Ads**: Production boosts, bonus coins
- **IAP**: Small/large coin packs (no server validation in MVP)

### Analytics Events
- `app_launch`, `tutorial_start`, `tutorial_complete`
- `first_production`, `first_sale`
- `ad_reward_granted`, `iap_purchase_success`

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/game/world/iso_grid_test.dart
```

## 📦 Building

### Android
```bash
# Debug build
flutter build apk --debug

# Release build
flutter build apk --release
```

### iOS
```bash
# Debug build
flutter build ios --debug

# Release build
flutter build ios --release
```

## 📊 Performance Targets
- **FPS**: 60 FPS on mid-range Android with 50+ conveyors + 10+ machines
- **Build Size**: ≤70 MB
- **Stability**: >99% crash-free rate
- **Retention**: D1 retention > 35%

## 🔧 Configuration

### Remote Config Parameters
```json
{
  "starting_money": 1000,
  "conveyor_cost": 10,
  "basic_machine_cost": 100,
  "tick_interval_ms": 200,
  "ads_enabled": true,
  "iap_enabled": true,
  "tutorial_enabled": true
}
```

### Environment Variables
- `FIREBASE_ENABLED`: Enable/disable Firebase integration
- `ADS_ENABLED`: Enable/disable ad functionality
- `IAP_ENABLED`: Enable/disable in-app purchases

## 🚀 Deployment

### Android (Google Play)
1. Generate signed APK/AAB
2. Upload to Google Play Console
3. Configure store listing and pricing

### iOS (App Store)
1. Build and archive in Xcode
2. Upload to App Store Connect
3. Submit for review

## 📄 License
[License information]

## 🤝 Contributing
[Contributing guidelines]