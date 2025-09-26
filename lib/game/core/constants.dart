/// Global constants for the Factory Tycoon game
class GameConstants {
  // Tick system
  static const Duration tickInterval = Duration(milliseconds: 200);
  
  // Isometric grid
  static const double tileWidth = 64.0;
  static const double tileHeight = 32.0;
  
  // World dimensions (in tiles)
  static const int worldTilesX = 50;
  static const int worldTilesY = 50;
  
  // World dimensions (in pixels)
  static const double worldWidth = worldTilesX * tileWidth;
  static const double worldHeight = worldTilesY * tileHeight;
  
  // Game balance
  static const int startingMoney = 1000;
  static const int conveyorCost = 10;
  static const int machineBaseCost = 100;
  
  // Performance
  static const int maxComponents = 1000;
  static const double targetFPS = 60.0;
}