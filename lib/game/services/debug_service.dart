import 'dart:async';
import '../core/factory_game.dart';

/// Debug service to demonstrate tick engine functionality
class DebugService {
  late FactoryGame _gameRef;
  StreamSubscription? _tickSubscription;
  
  int _totalTicks = 0;
  int _lastSecondTicks = 0;
  DateTime _lastSecondTime = DateTime.now();
  
  /// Initialize the debug service and subscribe to tick events
  Future<void> init(FactoryGame gameRef) async {
    _gameRef = gameRef;
    
    // Subscribe to tick events
    _tickSubscription = _gameRef.tickEngine.onTick.listen(_processTick);
    
    print('🐛 DebugService initialized - listening to tick events');
  }
  
  /// Process debug updates on each tick
  void _processTick(int tickCount) {
    _totalTicks++;
    
    // Track ticks per second
    final now = DateTime.now();
    if (now.difference(_lastSecondTime).inMilliseconds >= 1000) {
      final actualTPS = _totalTicks - _lastSecondTicks;
      final expectedTPS = _gameRef.tickEngine.ticksPerSecond;
      
      print('🔍 Debug: Expected TPS: ${expectedTPS.toStringAsFixed(1)}, '
            'Actual TPS: $actualTPS, '
            'Tick #$tickCount');
      
      _lastSecondTicks = _totalTicks;
      _lastSecondTime = now;
    }
    
    // Log major milestones
    if (tickCount % 100 == 0) {
      final stats = _gameRef.tickEngine.getStats();
      print('🎯 Milestone: Tick #$tickCount reached! '
            'Phase: ${(stats['tickPhase'] * 100).toStringAsFixed(1)}%, '
            'Paused: ${stats['isPaused']}');
    }
    
    // Demonstrate tick-based logic
    _demonstrateTickLogic(tickCount);
  }
  
  /// Demonstrate various tick-based game logic patterns
  void _demonstrateTickLogic(int tickCount) {
    // Every 10 ticks (2 seconds at 200ms): Simulate resource generation
    if (tickCount % 10 == 0) {
      print('⚡ Resource generation tick #$tickCount');
    }
    
    // Every 25 ticks (5 seconds at 200ms): Simulate building maintenance
    if (tickCount % 25 == 0) {
      print('🔧 Maintenance check at tick #$tickCount');
    }
    
    // Every 50 ticks (10 seconds at 200ms): Simulate market fluctuation
    if (tickCount % 50 == 0) {
      print('📈 Market update at tick #$tickCount');
    }
  }
  
  /// Get debug statistics
  Map<String, dynamic> getDebugStats() {
    return {
      'totalTicks': _totalTicks,
      'lastSecondTicks': _lastSecondTicks,
      'isSubscribed': _tickSubscription != null,
      'engineStats': _gameRef.tickEngine.getStats(),
    };
  }
  
  /// Dispose of the service
  void dispose() {
    _tickSubscription?.cancel();
    print('🐛 DebugService disposed');
  }
}