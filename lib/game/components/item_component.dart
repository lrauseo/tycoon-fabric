import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';

/// Represents an item that flows through the production system
class ItemComponent extends SpriteComponent with HasGameRef {
  final String itemType;
  final int value;
  
  /// Movement properties
  Vector2 velocity = Vector2.zero();
  double speed = 1.0;
  
  ItemComponent({
    required this.itemType,
    required Vector2 position,
    this.value = 10,
  }) : super(
          position: position,
          size: Vector2(16, 16), // Small item size
        );
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // TODO: Load item sprite based on itemType
    // sprite = await Sprite.load('item_$itemType.png');
    
    // Placeholder: Create a colored circle based on item type
    final color = _getItemColor(itemType);
    add(CircleComponent(
      radius: 8,
      paint: Paint()..color = color,
    ));
    
    // Add item type label for debugging
    if (itemType.length <= 6) {
      add(TextComponent(
        text: itemType.substring(0, 3),
        position: Vector2(2, 2),
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 8,
          ),
        ),
      ));
    }
  }
  
  Color _getItemColor(String type) {
    switch (type) {
      case 'raw_material':
        return const Color(0xFF8B4513); // Brown
      case 'basic_component':
        return const Color(0xFF4169E1); // Blue
      case 'advanced_component':
        return const Color(0xFF32CD32); // Green
      case 'finished_product':
        return const Color(0xFFFFD700); // Gold
      default:
        return const Color(0xFF808080); // Gray for unknown
    }
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    // Update position based on velocity
    if (velocity != Vector2.zero()) {
      position += velocity * speed * dt;
    }
  }
  
  /// Set movement direction and speed
  void setMovement(Vector2 direction, double movementSpeed) {
    velocity = direction.normalized();
    speed = movementSpeed;
  }
  
  /// Stop item movement
  void stopMovement() {
    velocity = Vector2.zero();
  }
  
  /// Check if item is moving
  bool get isMoving => velocity != Vector2.zero();
  
  /// Get item properties for serialization
  Map<String, dynamic> toJson() {
    return {
      'itemType': itemType,
      'value': value,
      'position': {
        'x': position.x,
        'y': position.y,
      },
      'velocity': {
        'x': velocity.x,
        'y': velocity.y,  
      },
      'speed': speed,
    };
  }
  
  /// Create item from serialized data
  static ItemComponent fromJson(Map<String, dynamic> json) {
    final item = ItemComponent(
      itemType: json['itemType'] as String,
      position: Vector2(
        (json['position']['x'] as num).toDouble(),
        (json['position']['y'] as num).toDouble(),
      ),
      value: json['value'] as int? ?? 10,
    );
    
    item.velocity = Vector2(
      (json['velocity']['x'] as num).toDouble(),
      (json['velocity']['y'] as num).toDouble(),
    );
    item.speed = (json['speed'] as num?)?.toDouble() ?? 1.0;
    
    return item;
  }
}