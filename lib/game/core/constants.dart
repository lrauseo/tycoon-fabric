/// Global constants for the Factory Tycoon game
class GameConstants {
  // Tick system - configurable via Remote Config
  static Duration get tickInterval => Duration(
    milliseconds: _getRemoteConfigInt('tick_interval_ms', 200)
  );
  
  // Isometric grid
  static const double tileWidth = 64.0;
  static const double tileHeight = 32.0;
  
  // World dimensions (in tiles)
  static const int worldTilesX = 50;
  static const int worldTilesY = 50;
  
  // World dimensions (in pixels)
  static const double worldWidth = worldTilesX * tileWidth;
  static const double worldHeight = worldTilesY * tileHeight;
  
  // Game balance - configurable via Remote Config
  static int get startingMoney => _getRemoteConfigInt('starting_money', 1000);
  static int get conveyorCost => _getRemoteConfigInt('conveyor_cost', 10);
  static int get machineBaseCost => _getRemoteConfigInt('basic_machine_cost', 100);
  
  // Performance
  static int get maxComponents => _getRemoteConfigInt('max_components', 1000);
  static const double targetFPS = 60.0;
  
  // Helper function to get Remote Config values with fallback
  static int _getRemoteConfigInt(String key, int fallback) {
    try {
      // This will be connected to Firebase Remote Config later
      // For now, return fallback values
      return fallback;
    } catch (e) {
      return fallback;
    }
  }
  
  // Tick-based timing helpers
  static int ticksPerSecond(Duration interval) {
    return (1000 / interval.inMilliseconds).round();
  }
  
  static int ticksForDuration(Duration duration, Duration tickInterval) {
    return (duration.inMilliseconds / tickInterval.inMilliseconds).round();
  }
  
  // Common tick intervals for game events
  static int get resourceGenerationTicks => ticksForDuration(
    const Duration(seconds: 2), 
    tickInterval
  );
  
  static int get maintenanceCheckTicks => ticksForDuration(
    const Duration(seconds: 5), 
    tickInterval
  );
  
  static int get marketUpdateTicks => ticksForDuration(
    const Duration(seconds: 10), 
    tickInterval
  );
  
  static int get autoSaveTicks => ticksForDuration(
    const Duration(seconds: 30), 
    tickInterval
  );
}