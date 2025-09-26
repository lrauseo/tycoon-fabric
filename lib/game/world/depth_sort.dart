import 'package:flame/components.dart';

/// Manages depth sorting for isometric rendering
/// Components with higher Y positions should be drawn last (on top)
class DepthSortManager {
  
  /// Sort children components by their Y position for correct isometric rendering
  void sortChildren(ComponentSet children) {
    final sortableChildren = children
        .where((child) => child is PositionComponent)
        .cast<PositionComponent>()
        .toList();
    
    // Sort by Y position (higher Y = drawn later = on top)
    sortableChildren.sort((a, b) => a.position.y.compareTo(b.position.y));
    
    // Update priorities based on Y position
    for (int i = 0; i < sortableChildren.length; i++) {
      sortableChildren[i].priority = i;
    }
  }
  
  /// Calculate depth priority based on isometric position
  /// In isometric view, objects with higher Y + X should be drawn later
  int calculateDepthPriority(Vector2 position) {
    // Simple depth calculation - higher Y + partial X = higher priority
    return ((position.y + position.x * 0.5) * 100).round();
  }
  
  /// Update a single component's priority based on its position
  void updateComponentPriority(PositionComponent component) {
    component.priority = calculateDepthPriority(component.position);
  }
}