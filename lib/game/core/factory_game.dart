import 'package:flame/game.dart';
import 'package:flame/components.dart';

import 'tick_engine.dart';
import 'constants.dart';
import '../world/iso_grid.dart';
import '../world/depth_sort.dart';
import '../services/economy_service.dart';
import '../services/production_service.dart';
import '../services/inventory_service.dart';

/// Main FlameGame class for Factory Tycoon
class FactoryGame extends FlameGame with HasCollisionDetection {
  late TickEngine tickEngine;
  late IsoGrid isoGrid;
  late DepthSortManager depthSortManager;
  
  // Services
  late EconomyService economyService;
  late ProductionService productionService;
  late InventoryService inventoryService;
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Initialize core systems
    tickEngine = TickEngine(tickInterval: GameConstants.tickInterval);
    isoGrid = IsoGrid(
      tileWidth: GameConstants.tileWidth,
      tileHeight: GameConstants.tileHeight,
    );
    depthSortManager = DepthSortManager();
    
    // Initialize services
    economyService = EconomyService();
    productionService = ProductionService();
    inventoryService = InventoryService(); 
    
    // Initialize services with tick engine
    await economyService.init(this);
    await productionService.init(this);
    await inventoryService.init(this);
    
    // Add tick engine to components
    add(tickEngine);
    
    // Show HUD overlay by default
    overlays.add('hud');
    
    // Set up camera for isometric view
    camera.priority = 0;
    
    // Initialize world bounds
    _setupWorld();
  }
  
  void _setupWorld() {
    // Create a simple world boundary
    final worldBounds = RectangleComponent(
      size: Vector2(
        GameConstants.worldWidth,
        GameConstants.worldHeight,
      ),
      position: Vector2.zero(),
    );
    add(worldBounds);
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    // Update depth sorting every frame
    depthSortManager.sortChildren(children);
  }
  
  /// Convert screen position to grid coordinates
  Vector2 screenToGrid(Vector2 screenPos) {
    return isoGrid.screenToGrid(screenPos);
  }
  
  /// Convert grid coordinates to world position
  Vector2 gridToWorld(Vector2 gridPos) {
    return isoGrid.gridToWorld(gridPos);
  }
  
  /// Place a component at grid position
  void placeAtGrid(Component component, Vector2 gridPos) {
    final worldPos = gridToWorld(gridPos);
    component.position = worldPos;
    add(component);
  }
}