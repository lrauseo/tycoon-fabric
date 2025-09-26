import 'dart:async';
import 'dart:collection';

import '../core/factory_game.dart';
import '../components/conveyor_component.dart';
import '../components/machine_component.dart';
import '../components/item_component.dart';

/// Manages the production system - item flow, processing, conveyors
class ProductionService {
  late FactoryGame _gameRef;
  StreamSubscription? _tickSubscription;
  
  /// Lists to track production components
  final List<ConveyorComponent> _conveyors = [];
  final List<MachineComponent> _machines = [];
  final Queue<ItemComponent> _itemsToMove = Queue<ItemComponent>();
  
  /// Production statistics
  int _itemsProduced = 0;
  int _itemsSold = 0;
  
  int get itemsProduced => _itemsProduced;
  int get itemsSold => _itemsSold;
  
  /// Initialize the service and subscribe to tick events
  Future<void> init(FactoryGame gameRef) async {
    _gameRef = gameRef;
    
    // Subscribe to tick events for production updates
    _tickSubscription = _gameRef.tickEngine.onTick.listen(_processTick);
  }
  
  /// Process production updates on each tick
  void _processTick(int tickCount) {
    // Move items on conveyors
    _processConveyorMovement();
    
    // Process machine operations
    _processMachineOperations();
    
    // Handle item transfers between components
    _processItemTransfers();
    
    // Log production stats every 25 ticks (5 seconds)
    if (tickCount % 25 == 0 && (itemsProduced > 0 || itemsSold > 0)) {
      print('📊 Production Stats - Produced: $itemsProduced, Sold: $itemsSold, Conveyors: ${_conveyors.length}, Machines: ${_machines.length}');
    }
  }
  
  /// Move items along conveyors
  void _processConveyorMovement() {
    for (final conveyor in _conveyors) {
      conveyor.processMovement();
    }
  }
  
  /// Process machine operations (input -> processing -> output)
  void _processMachineOperations() {
    for (final machine in _machines) {
      machine.processProduction();
    }
  }
  
  /// Handle item transfers between adjacent components
  void _processItemTransfers() {
    // Process queued item movements
    while (_itemsToMove.isNotEmpty) {
      final item = _itemsToMove.removeFirst();
      _moveItemToNextComponent(item);
    }
  }
  
  /// Move an item to the next component in the production line
  void _moveItemToNextComponent(ItemComponent item) {
    // TODO: Implement pathfinding and item routing logic
    // For now, this is a placeholder
  }
  
  /// Register a conveyor component with the production system
  void registerConveyor(ConveyorComponent conveyor) {
    if (!_conveyors.contains(conveyor)) {
      _conveyors.add(conveyor);
    }
  }
  
  /// Unregister a conveyor component
  void unregisterConveyor(ConveyorComponent conveyor) {
    _conveyors.remove(conveyor);
  }
  
  /// Register a machine component with the production system
  void registerMachine(MachineComponent machine) {
    if (!_machines.contains(machine)) {
      _machines.add(machine);
    }
  }
  
  /// Unregister a machine component
  void unregisterMachine(MachineComponent machine) {
    _machines.remove(machine);
  }
  
  /// Queue an item for movement
  void queueItemMovement(ItemComponent item) {
    _itemsToMove.add(item);
  }
  
  /// Increment items produced counter
  void itemProduced() {
    _itemsProduced++;
  }
  
  /// Increment items sold counter
  void itemSold() {
    _itemsSold++;
  }
  
  /// Get production statistics
  Map<String, int> getProductionStats() {
    return {
      'itemsProduced': _itemsProduced,
      'itemsSold': _itemsSold,
      'conveyors': _conveyors.length,
      'machines': _machines.length,
    };
  }
  
  /// Dispose of the service
  void dispose() {
    _tickSubscription?.cancel();
    _conveyors.clear();
    _machines.clear();
    _itemsToMove.clear();
  }
}