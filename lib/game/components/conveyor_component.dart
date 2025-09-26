import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'item_component.dart';

/// Conveyor belt component that moves items along grid directions (N/S/E/W)
class ConveyorComponent extends SpriteComponent with HasGameRef, TapCallbacks {
  final Vector2 direction;
  final List<ItemComponent> items = [];
  
  /// Movement speed (tiles per tick)
  final double speed = 1.0;
  
  ConveyorComponent({
    required this.direction,
    required Vector2 position,
  }) : super(
          position: position,
          size: Vector2(64, 64), // Placeholder size
        );
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // TODO: Load conveyor sprite
    // sprite = await Sprite.load('conveyor.png');
    
    // Placeholder: Create a colored rectangle
    add(RectangleComponent(
      size: size,
      paint: Paint()..color = const Color(0xFF8B4513), // Brown color
    ));
    
    // Add direction indicator
    _addDirectionIndicator();
  }
  
  void _addDirectionIndicator() {
    // Add a small arrow to show direction
    final arrow = RectangleComponent(
      size: Vector2(10, 2),
      position: Vector2(size.x / 2 - 5, size.y / 2 - 1),
      paint: Paint()..color = const Color(0xFFFFFF00), // Yellow arrow
    );
    add(arrow);
  }
  
  /// Process item movement on each tick
  void processMovement() {
    // Move all items along the conveyor
    for (final item in items) {
      _moveItem(item);
    }
    
    // Remove items that have reached the end
    items.removeWhere((item) => _isItemAtEnd(item));
  }
  
  void _moveItem(ItemComponent item) {
    // Move item in the conveyor's direction
    item.position += direction * speed;
  }
  
  bool _isItemAtEnd(ItemComponent item) {
    // Check if item has moved beyond the conveyor bounds
    return item.position.x > size.x || 
           item.position.y > size.y ||
           item.position.x < 0 ||
           item.position.y < 0;
  }
  
  /// Add an item to this conveyor
  void addItem(ItemComponent item) {
    items.add(item);
    add(item);
  }
  
  /// Remove an item from this conveyor
  void removeItem(ItemComponent item) {
    items.remove(item);
    remove(item);
  }
  
  /// Get the next position an item should move to
  Vector2 getNextPosition() {
    return position + direction;
  }
  
  /// Check if conveyor can accept more items
  bool canAcceptItem() {
    return items.length < 3; // Max 3 items per conveyor
  }
  
  @override
  bool onTapDown(TapDownEvent event) {
    // Handle conveyor selection/interaction
    print('Conveyor tapped at $position');
    return true;
  }
}