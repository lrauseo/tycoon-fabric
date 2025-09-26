import 'dart:async';
import 'package:flame/components.dart';

/// Tick-based simulation engine that drives production logic
/// independent of framerate (200ms ticks)
class TickEngine extends Component {
  final Duration tickInterval;
  Timer? _timer;
  
  /// Stream controller for tick events
  final StreamController<void> _tickController = StreamController<void>.broadcast();
  
  /// Stream that services can listen to for tick events
  Stream<void> get onTick => _tickController.stream;
  
  int _tickCount = 0;
  int get tickCount => _tickCount;
  
  TickEngine({required this.tickInterval});
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _startTicking();
  }
  
  void _startTicking() {
    _timer = Timer.periodic(tickInterval, (_) {
      _processTick();
    });
  }
  
  void _processTick() {
    _tickCount++;
    
    // Emit tick event to all subscribers
    _tickController.add(null);
  }
  
  /// Pause the tick engine
  void pause() {
    _timer?.cancel();
    _timer = null;
  }
  
  /// Resume the tick engine
  void resume() {
    if (_timer == null) {
      _startTicking();
    }
  }
  
  /// Check if the tick engine is running
  bool get isRunning => _timer != null;
  
  @override
  void onRemove() {
    _timer?.cancel();
    _tickController.close();
    super.onRemove();
  }
}