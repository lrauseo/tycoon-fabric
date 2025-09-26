import 'package:flutter_test/flutter_test.dart';
import 'package:factory_tycoon/game/core/factory_game.dart';
import 'package:factory_tycoon/game/core/tick_engine.dart';
import 'package:factory_tycoon/game/services/debug_service.dart';

/// Mock FactoryGame for testing purposes
class MockFactoryGame extends FactoryGame {
  final TickEngine _tickEngine;
  
  MockFactoryGame(this._tickEngine);
  
  @override
  TickEngine get tickEngine => _tickEngine;
}

void main() {
  group('DebugService Integration Tests', () {
    late FactoryGame game;
    late TickEngine tickEngine;
    late DebugService debugService;
    
    setUp(() async {
      // Create tick engine and debug service
      tickEngine = TickEngine(tickInterval: const Duration(milliseconds: 100));
      debugService = DebugService();
      
      // Create a mock game implementation for testing
      game = MockFactoryGame(tickEngine);
      
      // Initialize debug service
      await debugService.init(game);
    });
    
    test('should subscribe to tick events', () async {
      final initialStats = debugService.getDebugStats();
      expect(initialStats['isSubscribed'], isTrue);
      expect(initialStats['totalTicks'], equals(0));
    });
    
    test('should receive and count tick events', () async {
      // Simulate several ticks
      tickEngine.update(0.35); // Should generate 3 ticks
      
      // Wait a bit for async processing
      await Future.delayed(const Duration(milliseconds: 10));
      
      final stats = debugService.getDebugStats();
      expect(stats['totalTicks'], equals(3));
      expect(stats['engineStats']['tickCount'], equals(3));
    });
    
    test('should track ticks per second', () async {
      // Simulate one second of ticks
      for (int i = 0; i < 10; i++) {
        tickEngine.update(0.1); // 100ms intervals = 10 ticks per second
        await Future.delayed(const Duration(milliseconds: 5));
      }
      
      final stats = debugService.getDebugStats();
      expect(stats['totalTicks'], equals(10));
    });
    
    test('should provide engine statistics', () async {
      tickEngine.update(0.15); // 1 tick + some remainder
      await Future.delayed(const Duration(milliseconds: 10));
      
      final stats = debugService.getDebugStats();
      final engineStats = stats['engineStats'] as Map<String, dynamic>;
      
      expect(engineStats['tickCount'], equals(1));
      expect(engineStats['tickInterval'], equals(100));
      expect(engineStats['ticksPerSecond'], equals(10.0));
      expect(engineStats['isPaused'], isFalse);
    });
    
    test('should dispose properly', () {
      debugService.dispose();
      
      final stats = debugService.getDebugStats();
      expect(stats['isSubscribed'], isFalse);
    });
    
    tearDown(() {
      debugService.dispose();
      tickEngine.onRemove();
    });
  });
}