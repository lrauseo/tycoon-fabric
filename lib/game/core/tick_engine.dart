import 'dart:async';
import 'package:flame/components.dart';

/// Tick-based simulation engine that drives production logic
/// independent of framerate using delta time accumulation
class TickEngine extends Component {
  final Duration tickInterval;
  Duration _accumulator = Duration.zero;
  int _tickCount = 0;
  
  /// Stream controller for tick events
  final StreamController<int> _tickController = StreamController<int>.broadcast();
  
  /// Stream that services can listen to for tick events
  Stream<int> get onTick => _tickController.stream;
  
  /// Get current tick count
  int get tickCount => _tickCount;
  
  /// Check if the engine is paused
  bool _isPaused = false;
  bool get isPaused => _isPaused;
  
  TickEngine({required this.tickInterval});
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    print('🕰️ TickEngine initialized with ${tickInterval.inMilliseconds}ms interval');
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    // Skip if paused
    if (_isPaused) return;
    
    // Convert dt (seconds) to Duration and accumulate
    final dtDuration = Duration(microseconds: (dt * 1000000).round());
    _accumulator += dtDuration;
    
    // Process ticks while we have enough accumulated time
    while (_accumulator >= tickInterval) {
      _accumulator -= tickInterval;
      _processTick();
    }
  }
  
  /// Process a single tick
  void _processTick() {
    _tickCount++;
    
    // Emit tick event to all subscribers
    _tickController.add(_tickCount);
    
    // Log every 50 ticks (10 seconds at 200ms intervals) for debugging
    if (_tickCount % 50 == 0) {
      print('🔄 Tick #$_tickCount (${tickInterval.inMilliseconds}ms interval)');
    }
  }
  
  /// Pause the tick engine
  void pause() {
    _isPaused = true;
    print('⏸️ TickEngine paused at tick #$_tickCount');
  }
  
  /// Resume the tick engine
  void resume() {
    _isPaused = false;
    print('▶️ TickEngine resumed at tick #$_tickCount');
  }
  
  /// Reset the tick engine
  void reset() {
    _tickCount = 0;
    _accumulator = Duration.zero;
    print('🔄 TickEngine reset');
  }
  
  /// Get ticks per second
  double get ticksPerSecond => 1000.0 / tickInterval.inMilliseconds;
  
  /// Get current tick phase (0.0 to 1.0 between ticks)
  double get tickPhase {
    if (tickInterval.inMicroseconds == 0) return 0.0;
    return _accumulator.inMicroseconds / tickInterval.inMicroseconds;
  }
  
  /// Get time since last tick
  Duration get timeSinceLastTick => _accumulator;
  
  /// Get time until next tick
  Duration get timeUntilNextTick => tickInterval - _accumulator;
  
  /// Check if a tick just occurred this frame
  bool get didTickThisFrame => _accumulator < Duration(milliseconds: 16);
  
  @override
  void onRemove() {
    _tickController.close();
    print('🛑 TickEngine stopped at tick #$_tickCount');
    super.onRemove();
  }
  
  /// Get engine statistics
  Map<String, dynamic> getStats() {
    return {
      'tickCount': _tickCount,
      'tickInterval': tickInterval.inMilliseconds,
      'ticksPerSecond': ticksPerSecond,
      'isPaused': _isPaused,
      'tickPhase': tickPhase,
      'timeSinceLastTick': timeSinceLastTick.inMilliseconds,
      'timeUntilNextTick': timeUntilNextTick.inMilliseconds,
    };
  }
}