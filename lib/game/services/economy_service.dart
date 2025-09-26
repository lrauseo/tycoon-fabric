import 'dart:async';
import 'package:flutter/foundation.dart';

import '../core/factory_game.dart';
import '../core/constants.dart';

/// Manages the game economy - money, costs, revenue
class EconomyService {
  late FactoryGame _gameRef;
  StreamSubscription? _tickSubscription;
  
  /// Money amount - exposed via ValueNotifier for UI binding
  final ValueNotifier<int> money = ValueNotifier(GameConstants.startingMoney);
  
  /// Daily expenses and revenue tracking
  int _dailyExpenses = 0;
  int _dailyRevenue = 0;
  
  int get dailyExpenses => _dailyExpenses;
  int get dailyRevenue => _dailyRevenue;
  int get dailyProfit => _dailyRevenue - _dailyExpenses;
  
  /// Initialize the service and subscribe to tick events
  Future<void> init(FactoryGame gameRef) async {
    _gameRef = gameRef;
    
    // Subscribe to tick events for periodic operations
    _tickSubscription = _gameRef.tickEngine.onTick.listen(_processTick);
  }
  
  /// Process economic updates on each tick
  void _processTick(int tickCount) {
    // Handle periodic expenses (maintenance, salaries, etc.)
    _processPeriodicExpenses(tickCount);
    
    // Reset daily counters every 100 ticks (20 seconds at 200ms ticks)
    if (tickCount % 100 == 0) {
      _resetDailyCounters();
    }
  }
  
  /// Process recurring expenses each tick
  void _processPeriodicExpenses(int tickCount) {
    // For now, no periodic expenses
    // TODO: Add maintenance costs, salaries, electricity, etc.
    
    // Example: Every 10 ticks (2 seconds), deduct 1 coin for electricity
    // if (tickCount % 10 == 0) {
    //   spendMoney(1);
    // }
  }
  
  /// Reset daily financial counters
  void _resetDailyCounters() {
    _dailyExpenses = 0;
    _dailyRevenue = 0;
  }
  
  /// Spend money if available
  bool spendMoney(int amount) {
    if (money.value >= amount) {
      money.value -= amount;
      _dailyExpenses += amount;
      return true;
    }
    return false;
  }
  
  /// Add money from sales
  void addMoney(int amount) {
    money.value += amount;
    _dailyRevenue += amount;
  }
  
  /// Check if player can afford something
  bool canAfford(int cost) {
    return money.value >= cost;
  }
  
  /// Get current money amount
  int getCurrentMoney() {
    return money.value;
  }
  
  /// Dispose of the service
  void dispose() {
    _tickSubscription?.cancel();
    money.dispose();
  }
}