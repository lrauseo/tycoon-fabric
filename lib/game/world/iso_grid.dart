import 'package:flame/components.dart';

/// Handles isometric grid coordinate conversions
/// Grid coordinates -> World coordinates (diamond shape)
class IsoGrid {
  final double tileWidth;
  final double tileHeight;
  
  IsoGrid({
    required this.tileWidth,
    required this.tileHeight,
  });
  
  /// Convert grid coordinates to world position (isometric diamond)
  Vector2 gridToWorld(Vector2 gridPos) {
    final worldX = (gridPos.x - gridPos.y) * tileWidth / 2;
    final worldY = (gridPos.x + gridPos.y) * tileHeight / 2;
    return Vector2(worldX, worldY);
  }
  
  /// Convert world position to grid coordinates
  Vector2 worldToGrid(Vector2 worldPos) {
    final gridX = (worldPos.x / (tileWidth / 2) + worldPos.y / (tileHeight / 2)) / 2;
    final gridY = (worldPos.y / (tileHeight / 2) - worldPos.x / (tileWidth / 2)) / 2;
    return Vector2(gridX, gridY);
  }
  
  /// Convert screen position to grid coordinates (considering camera)
  Vector2 screenToGrid(Vector2 screenPos) {
    // For now, assume screen == world coordinates
    // This will be updated when camera transformations are added
    return worldToGrid(screenPos);
  }
  
  /// Get the world position for grid coordinates, snapped to tile center
  Vector2 snapToGrid(Vector2 gridPos) {
    final snappedGrid = Vector2(
      gridPos.x.roundToDouble(),
      gridPos.y.roundToDouble(),
    );
    return gridToWorld(snappedGrid);
  }
  
  /// Check if grid coordinates are within world bounds
  bool isValidGridPosition(Vector2 gridPos, {int maxX = 50, int maxY = 50}) {
    return gridPos.x >= 0 && 
           gridPos.y >= 0 && 
           gridPos.x < maxX && 
           gridPos.y < maxY;
  }
  
  /// Get neighboring grid positions (N, S, E, W)
  List<Vector2> getNeighbors(Vector2 gridPos) {
    return [
      Vector2(gridPos.x, gridPos.y - 1), // North
      Vector2(gridPos.x, gridPos.y + 1), // South
      Vector2(gridPos.x + 1, gridPos.y), // East
      Vector2(gridPos.x - 1, gridPos.y), // West
    ];
  }
}