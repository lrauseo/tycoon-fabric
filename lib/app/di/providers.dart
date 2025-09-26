import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../game/core/factory_game.dart';
import '../../game/services/economy_service.dart';
import '../../game/services/production_service.dart';
import '../../game/services/inventory_service.dart';
import '../../game/services/save_service.dart';

/// Global providers for dependency injection
class AppProviders {
  static Future<void> initialize() async {
    // Initialize Hive for local storage
    await Hive.initFlutter();
    
    // Register Hive adapters here when available
    // await Hive.openBox('savegame');
  }
}

/// Main game instance provider
final factoryGameProvider = Provider<FactoryGame>((ref) {
  return FactoryGame();
});

/// Service providers
final economyServiceProvider = Provider<EconomyService>((ref) {
  return EconomyService();
});

final productionServiceProvider = Provider<ProductionService>((ref) {
  return ProductionService();
});

final inventoryServiceProvider = Provider<InventoryService>((ref) {
  return InventoryService();
});

final saveServiceProvider = Provider<SaveService>((ref) {
  return SaveService();
});

/// Game state providers - these will bridge Game <-> UI
final moneyProvider = Provider<int>((ref) {
  final economyService = ref.watch(economyServiceProvider);
  // This will be implemented with ValueNotifier listening
  return 1000; // placeholder
});

final inventoryProvider = Provider<Map<String, int>>((ref) {
  final inventoryService = ref.watch(inventoryServiceProvider);
  // This will be implemented with ValueNotifier listening
  return {}; // placeholder
});