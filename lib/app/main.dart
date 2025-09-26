import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flame/game.dart';

import '../game/core/factory_game.dart';
import '../integrations/firebase/firebase_config.dart';
import '../integrations/ads/ads_manager.dart';
import '../integrations/iap/iap_manager.dart';
import 'di/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  await AppProviders.initialize();
  
  // Initialize Firebase (Analytics & Remote Config)
  try {
    await FirebaseConfig.initialize();
    await FirebaseConfig.logEvent('app_launch');
  } catch (e) {
    print('Firebase initialization failed: $e');
  }
  
  // Initialize Google Mobile Ads
  try {
    await AdsManager.initialize();
  } catch (e) {
    print('Ads initialization failed: $e');
  }
  
  // Initialize In-App Purchases
  try {
    await IAPManager.initialize();
  } catch (e) {
    print('IAP initialization failed: $e');
  }
  
  runApp(
    ProviderScope(
      child: const FactoryTycoonApp(),
    ),
  );
}

class FactoryTycoonApp extends ConsumerWidget {
  const FactoryTycoonApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Factory Tycoon',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      // Force portrait orientation
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.0), // Disable text scaling
          ),
          child: child!,
        );
      },
      home: const GameScreen(),
    );
  }
}

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(factoryGameProvider);
    
    return Scaffold(
      body: GameWidget<FactoryGame>.controlled(
        gameFactory: () => game,
        overlayBuilderMap: {
          'hud': (context, game) => const GameHUD(),
          'store': (context, game) => const GameStore(),
          'upgrades': (context, game) => const GameUpgrades(),
          'pause': (context, game) => const PauseMenu(),
        },
      ),
    );
  }
}

// Placeholder overlay widgets
class GameHUD extends StatelessWidget {
  const GameHUD({super.key});
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Money display
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.shade700,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '💰 1000',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            // Ads test button
            ElevatedButton(
              onPressed: () async {
                if (AdsManager.isRewardedAdReady) {
                  await AdsManager.showProductionBoostAd(
                    onBoostGranted: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('🚀 Production boost granted!'),
                        ),
                      );
                    },
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('⚠️ Ad not ready'),
                    ),
                  );
                }
              },
              child: const Text('📺 Boost'),
            ),
          ],
        ),
      ),
    );
  }
}

class GameStore extends StatelessWidget {
  const GameStore({super.key});
  
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class GameUpgrades extends StatelessWidget {
  const GameUpgrades({super.key});
  
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class PauseMenu extends StatelessWidget {
  const PauseMenu({super.key});
  
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}