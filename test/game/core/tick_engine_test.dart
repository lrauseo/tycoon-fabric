import 'package:flutter_test/flutter_test.dart';
import 'package:factory_tycoon/game/core/tick_engine.dart';

void main() {
  group('TickEngine Tests', () {
    late TickEngine tickEngine;
    
    setUp(() {
      tickEngine = TickEngine(tickInterval: const Duration(milliseconds: 100));
    });
    
    test('should initialize with correct tick interval', () {
      expect(tickEngine.tickInterval, equals(const Duration(milliseconds: 100)));
      expect(tickEngine.tickCount, equals(0));
      expect(tickEngine.isPaused, isFalse);
    });
    
    test('should calculate ticks per second correctly', () {
      expect(tickEngine.ticksPerSecond, equals(10.0)); // 1000ms / 100ms = 10 ticks/sec
    });
    
    test('should accumulate time and emit ticks', () async {
      final ticks = <int>[];
      tickEngine.onTick.listen((tickCount) {
        ticks.add(tickCount);
      });
      
      // Simulate frame updates
      tickEngine.update(0.05); // 50ms - not enough for a tick
      expect(ticks, isEmpty);
      expect(tickEngine.tickCount, equals(0));
      
      tickEngine.update(0.06); // +60ms = 110ms total - should trigger 1 tick
      expect(ticks, equals([1]));
      expect(tickEngine.tickCount, equals(1));
      
      tickEngine.update(0.15); // +150ms = 260ms total - should trigger 1 more tick  
      expect(ticks, equals([1, 2]));
      expect(tickEngine.tickCount, equals(2));
    });
    
    test('should handle multiple ticks in single update', () async {
      final ticks = <int>[];
      tickEngine.onTick.listen((tickCount) {
        ticks.add(tickCount);
      });
      
      // Update with 350ms - should trigger 3 ticks (100, 200, 300ms)
      tickEngine.update(0.35);
      expect(ticks, equals([1, 2, 3]));
      expect(tickEngine.tickCount, equals(3));
    });
    
    test('should pause and resume correctly', () async {
      final ticks = <int>[];
      tickEngine.onTick.listen((tickCount) {
        ticks.add(tickCount);
      });
      
      // Normal operation
      tickEngine.update(0.15);
      expect(ticks, equals([1]));
      
      // Pause
      tickEngine.pause();
      expect(tickEngine.isPaused, isTrue);
      
      // Should not tick while paused
      tickEngine.update(0.15);
      expect(ticks, equals([1])); // No new ticks
      
      // Resume
      tickEngine.resume();
      expect(tickEngine.isPaused, isFalse);
      
      // Should tick again
      tickEngine.update(0.15);
      expect(ticks, equals([1, 2]));
    });
    
    test('should reset correctly', () async {
      // Advance some ticks
      tickEngine.update(0.25);
      expect(tickEngine.tickCount, equals(2));
      
      // Reset
      tickEngine.reset();
      expect(tickEngine.tickCount, equals(0));
    });
    
    test('should calculate tick phase correctly', () {
      // No time accumulated
      expect(tickEngine.tickPhase, equals(0.0));
      
      // Half tick interval accumulated
      tickEngine.update(0.05); // 50ms out of 100ms
      expect(tickEngine.tickPhase, closeTo(0.5, 0.01));
      
      // Just before a tick
      tickEngine.update(0.049); // 99ms total
      expect(tickEngine.tickPhase, closeTo(0.99, 0.01));
      
      // After tick occurs
      tickEngine.update(0.001); // 100ms total - tick occurs, 0ms remaining
      expect(tickEngine.tickPhase, closeTo(0.0, 0.01));
    });
    
    test('should provide accurate timing information', () {
      final interval = const Duration(milliseconds: 100);
      
      // Test time until next tick
      tickEngine.update(0.03); // 30ms
      expect(tickEngine.timeSinceLastTick, equals(const Duration(milliseconds: 30)));
      expect(tickEngine.timeUntilNextTick, equals(const Duration(milliseconds: 70)));
      
      // Test just before tick
      tickEngine.update(0.069); // 99ms total
      expect(tickEngine.timeSinceLastTick, equals(const Duration(milliseconds: 99)));
      expect(tickEngine.timeUntilNextTick, equals(const Duration(milliseconds: 1)));
    });
    
    test('should provide engine statistics', () {
      tickEngine.update(0.15); // 1 tick
      tickEngine.pause();
      
      final stats = tickEngine.getStats();
      expect(stats['tickCount'], equals(1));
      expect(stats['tickInterval'], equals(100));
      expect(stats['ticksPerSecond'], equals(10.0));
      expect(stats['isPaused'], isTrue);
      expect(stats, containsKey('tickPhase'));
      expect(stats, containsKey('timeSinceLastTick'));
      expect(stats, containsKey('timeUntilNextTick'));
    });
    
    test('should handle edge case of zero interval', () {
      final zeroTickEngine = TickEngine(tickInterval: Duration.zero);
      expect(zeroTickEngine.tickPhase, equals(0.0));
    });
    
    test('should emit ticks consistently over time', () async {
      final ticks = <int>[];
      tickEngine.onTick.listen((tickCount) {
        ticks.add(tickCount);
      });
      
      // Simulate 1 second of irregular frame times
      final frameTimes = [0.016, 0.020, 0.012, 0.018, 0.025, 0.010, 0.030, 0.015]; // ~146ms total
      
      for (final frameTime in frameTimes) {
        tickEngine.update(frameTime);
      }
      
      // Should have triggered 1 tick (at 100ms mark)
      expect(ticks, equals([1]));
      expect(tickEngine.tickCount, equals(1));
      
      // Add more time to trigger second tick
      tickEngine.update(0.060); // +60ms = 206ms total
      expect(ticks, equals([1, 2]));
      expect(tickEngine.tickCount, equals(2));
    });
    
    tearDown(() {
      tickEngine.onRemove();
    });
  });
}