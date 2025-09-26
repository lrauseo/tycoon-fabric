import 'dart:async';
import 'package:flutter/foundation.dart';

import '../core/factory_game.dart';

/// Manages inventory of items, materials and products
class InventoryService {
  late FactoryGame _gameRef;
  StreamSubscription? _tickSubscription;
  
  /// Inventory storage - exposed via ValueNotifier for UI binding
  final ValueNotifier<Map<String, int>> inventory = ValueNotifier({});
  
  /// Maximum inventory capacity
  int _maxCapacity = 1000;
  int get maxCapacity => _maxCapacity;
  
  /// Current total inventory count
  int get currentCapacity {
    return inventory.value.values.fold(0, (sum, count) => sum + count);
  }
  
  /// Check if inventory has space
  bool get hasSpace => currentCapacity < _maxCapacity;
  
  /// Initialize the service and subscribe to tick events
  Future<void> init(FactoryGame gameRef) async {
    _gameRef = gameRef;
    
    // Subscribe to tick events for inventory management
    _tickSubscription = _gameRef.tickEngine.onTick.listen(_processTick);
    
    // Initialize with starting materials
    _initializeStartingInventory();
  }
  
  /// Initialize inventory with basic starting materials
  void _initializeStartingInventory() {
    final startingInventory = <String, int>{
      'raw_material': 50,
      'basic_component': 10,
    };
    
    inventory.value = Map.from(startingInventory);
  }
  
  /// Process inventory updates on each tick
  void _processTick(int tickCount) {
    // Handle inventory decay, spoilage, or automatic selling
    _processInventoryDecay(tickCount);
    
    // Auto-save inventory every 150 ticks (30 seconds)
    if (tickCount % 150 == 0) {
      print('💾 Auto-saving inventory - Utilization: ${getUtilizationPercentage().toStringAsFixed(1)}%');
    }
  }
  
  /// Process any inventory decay or automatic operations
  void _processInventoryDecay(int tickCount) {
    // For now, no decay
    // TODO: Add perishable items, automatic selling, etc.
    
    // Example: Every 50 ticks (10 seconds), check for full inventory and auto-sell overflow
    // if (tickCount % 50 == 0 && currentCapacity >= maxCapacity * 0.9) {
    //   _autoSellExcessItems();
    // }
  }
  
  /// Add items to inventory
  bool addItem(String itemType, int quantity) {
    if (currentCapacity + quantity > _maxCapacity) {
      return false; // Not enough space
    }
    
    final currentInventory = Map<String, int>.from(inventory.value);
    currentInventory[itemType] = (currentInventory[itemType] ?? 0) + quantity;
    inventory.value = currentInventory;
    
    return true;
  }
  
  /// Remove items from inventory
  bool removeItem(String itemType, int quantity) {
    final currentInventory = Map<String, int>.from(inventory.value);
    final currentAmount = currentInventory[itemType] ?? 0;
    
    if (currentAmount < quantity) {
      return false; // Not enough items
    }
    
    if (currentAmount == quantity) {
      currentInventory.remove(itemType);
    } else {
      currentInventory[itemType] = currentAmount - quantity;
    }
    
    inventory.value = currentInventory;
    return true;
  }
  
  /// Check if inventory has enough of specific item
  bool hasItem(String itemType, int quantity) {
    final currentAmount = inventory.value[itemType] ?? 0;
    return currentAmount >= quantity;
  }
  
  /// Get current amount of specific item
  int getItemCount(String itemType) {
    return inventory.value[itemType] ?? 0;
  }
  
  /// Get all items in inventory
  Map<String, int> getAllItems() {
    return Map.from(inventory.value);
  }
  
  /// Upgrade inventory capacity
  void upgradeCapacity(int additionalCapacity) {
    _maxCapacity += additionalCapacity;
  }
  
  /// Clear entire inventory (for testing or reset)
  void clearInventory() {
    inventory.value = {};
  }
  
  /// Get inventory utilization percentage
  double getUtilizationPercentage() {
    return (currentCapacity / _maxCapacity) * 100;
  }
  
  /// Dispose of the service
  void dispose() {
    _tickSubscription?.cancel();
    inventory.dispose();
  }
}