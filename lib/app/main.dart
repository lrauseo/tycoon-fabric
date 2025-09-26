import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flame/game.dart';

import '../game/core/factory_game.dart';
import 'di/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  await AppProviders.initialize();
  
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
  Widget build(BuildContext context) => const SizedBox.shrink();
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