import 'package:flutter_test/flutter_test.dart';
import 'package:flame/components.dart';
import 'package:factory_tycoon/game/world/iso_grid.dart';

void main() {
  group('IsoGrid Tests', () {
    late IsoGrid isoGrid;
    
    setUp(() {
      isoGrid = IsoGrid(tileWidth: 64.0, tileHeight: 32.0);
    });
    
    test('should convert grid to world coordinates correctly', () {
      // Test grid to world conversion for isometric diamond shape
      final worldPos = isoGrid.gridToWorld(Vector2(1, 0));
      
      // Expected: (1-0) * 32 = 32, (1+0) * 16 = 16
      expect(worldPos.x, equals(32.0));
      expect(worldPos.y, equals(16.0));
    });
    
    test('should convert world to grid coordinates correctly', () {
      // Test world to grid conversion
      final gridPos = isoGrid.worldToGrid(Vector2(32.0, 16.0));
      
      // Should convert back to approximately (1, 0)
      expect(gridPos.x, closeTo(1.0, 0.01));
      expect(gridPos.y, closeTo(0.0, 0.01));
    });
    
    test('should validate grid positions correctly', () {
      expect(isoGrid.isValidGridPosition(Vector2(0, 0)), isTrue);
      expect(isoGrid.isValidGridPosition(Vector2(49, 49)), isTrue);
      expect(isoGrid.isValidGridPosition(Vector2(-1, 0)), isFalse);
      expect(isoGrid.isValidGridPosition(Vector2(50, 0)), isFalse);
    });
    
    test('should get neighbors correctly', () {
      final neighbors = isoGrid.getNeighbors(Vector2(5, 5));
      
      expect(neighbors.length, equals(4));
      expect(neighbors, contains(Vector2(5, 4))); // North
      expect(neighbors, contains(Vector2(5, 6))); // South
      expect(neighbors, contains(Vector2(6, 5))); // East
      expect(neighbors, contains(Vector2(4, 5))); // West
    });
    
    test('should snap to grid correctly', () {
      final snapped = isoGrid.snapToGrid(Vector2(1.7, 2.3));
      final worldPos = isoGrid.gridToWorld(Vector2(2, 2));
      
      expect(snapped, equals(worldPos));
    });
  });
}